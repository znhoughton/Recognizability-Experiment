"""
Compute GPT-2 surprisal of 'up' in each experimental sentence.
Run from the Analysis/ directory. Output saved to ../Data/gpt2_surprisal.csv.
"""

import os
import torch
from transformers import GPT2LMHeadModel, GPT2Tokenizer
import pandas as pd

script_dir = os.path.dirname(os.path.abspath(__file__))
data_dir = os.path.join(script_dir, '..', 'Data')
output_path = os.path.join(data_dir, 'gpt2_surprisal.csv')

if os.path.exists(output_path):
    print(f"Output already exists at {output_path}. Delete it to recompute.")
    exit(0)

tokenizer = GPT2Tokenizer.from_pretrained('gpt2')
model = GPT2LMHeadModel.from_pretrained('gpt2')
model.eval()

# ' up' as a mid-sentence word is a single token (Ġup) in GPT-2
up_token_id = tokenizer.encode(' up', add_special_tokens=False)[0]


def compute_surprisal_of_up(sentence):
    inputs = tokenizer(sentence, return_tensors='pt')
    input_ids = inputs['input_ids'][0]

    positions = (input_ids == up_token_id).nonzero(as_tuple=True)[0]

    if len(positions) == 0:
        return None

    # Take the first occurrence (the particle)
    pos = positions[0].item()

    if pos == 0:
        return None

    with torch.no_grad():
        outputs = model(input_ids.unsqueeze(0))
        logits = outputs.logits

    # Surprisal = -log P(up | all preceding tokens)
    log_probs = torch.log_softmax(logits[0, pos - 1, :], dim=-1)
    return float(-log_probs[up_token_id].item())


data_cleaned = pd.read_csv(os.path.join(data_dir, 'data_analysis_cleaned.csv'))

item_sentences = (
    data_cleaned[
        (data_cleaned['Condition'] == 'Experimental') &
        (data_cleaned['Type'] == 'Phrasal Verb')
    ]
    .groupby('Item')[['Item', 'Word', 'Sentences']]
    .first()
    .reset_index(drop=True)
)

item_sentences['gpt2_surprisal'] = item_sentences['Sentences'].apply(
    compute_surprisal_of_up
)

n_missing = item_sentences['gpt2_surprisal'].isna().sum()
if n_missing > 0:
    print(f"Warning: {n_missing} items had no ' up' token found:")
    print(item_sentences[item_sentences['gpt2_surprisal'].isna()][['Item', 'Word', 'Sentences']])

item_sentences[['Item', 'Word', 'gpt2_surprisal']].to_csv(output_path, index=False)
print(f"Saved surprisal for {len(item_sentences)} items to {output_path}")
print(item_sentences[['Word', 'Sentences', 'gpt2_surprisal']].head(10).to_string())