from string import ascii_uppercase

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    """
    Template code for a transformer block.

    Add more parameters to this function if this block has multiple parent blocks.
    There should be one parameter for each output variable from each parent block.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    # Specify your transformation logic here

    #data.columns = data.columns.str.lower()

    # Define a function to convert camel case to snake case
    print(data.columns)
    
    # Define column name mappings
    column_mapping = {
        'VendorID': 'vendor_id',
        'RatecodeID': 'ratecode_id',
        'PULocationID': 'pu_location_id',
        'DOLocationID': 'do_location_id'
    }

    # Rename columns based on the mapping
    data = data.rename(columns=column_mapping)
    print(data.columns)


    # Remove rows where passenger_count is equal to 0 and trip_distance is equal to 0
    data = data[(data['passenger_count'] != 0) & (data['trip_distance'] != 0)]
    print(data.shape)
    print(data['vendor_id'].unique())

    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date



    return data

    #print(f"Rows with out passengers: {data['passenger_count'].fillna(0).isin([0]).sum() }")
    #return data[data['passenger_count']>0]


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert 'vendor_id' in output.columns, "DataFrame does not have 'vendor_id' column"
    assert output['passenger_count'].isin([0]).sum()==0, 'There are rides with zero passengers'
    assert output['trip_distance'].isin([0]).sum()==0, 'There are trip_distance that are zero passengers'
