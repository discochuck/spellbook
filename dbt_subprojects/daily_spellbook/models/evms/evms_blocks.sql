{{ config(
        schema='evms',
        alias = 'blocks',
        unique_key=['blockchain', 'number'],
        post_hook='{{ expose_spells(\'["ethereum", "polygon", "bnb", "avalanche_c", "gnosis", "fantom", "optimism", "arbitrum", "celo", "base", "zksync", "zora", "scroll", "linea", "zkevm", "blast", "mantle", "ronin"]\',
                                    "sector",
                                    "evms",
                                    \'["hildobby"]\') }}'
        )
}}

{% set blocks_models = [
     ('ethereum', source('ethereum', 'blocks'))
     , ('polygon', source('polygon', 'blocks'))
     , ('bnb', source('bnb', 'blocks'))
     , ('avalanche_c', source('avalanche_c', 'blocks'))
     , ('gnosis', source('gnosis', 'blocks'))
     , ('fantom', source('fantom', 'blocks'))
     , ('optimism', source('optimism', 'blocks'))
     , ('arbitrum', source('arbitrum', 'blocks'))
     , ('celo', source('celo', 'blocks'))
     , ('base', source('base', 'blocks'))
     , ('zksync', source('zksync', 'blocks'))
     , ('zora', source('zora', 'blocks'))
     , ('scroll', source('scroll', 'blocks'))
     , ('linea', source('linea', 'blocks'))
     , ('zkevm', source('zkevm', 'blocks'))
     , ('blast', source('blast', 'blocks'))
     , ('mantle', source('mantle', 'blocks'))
     , ('mode', source('mode', 'blocks'))
     , ('sei', source('sei', 'blocks'))
     , ('ronin', source('ronin', 'blocks'))
] %}

SELECT *
FROM (
        {% for blocks_model in blocks_models %}
        SELECT
        '{{ blocks_model[0] }}' AS blockchain
        , hash
        , miner
        , nonce
        , parent_hash
        , size
        , time
        , CAST(total_difficulty AS double) AS total_difficulty
        , number
        , base_fee_per_gas
        , CAST(difficulty AS double) AS difficulty
        , gas_limit
        , gas_used
        FROM {{ blocks_model[1] }}
        {% if not loop.last %}
        {% if is_incremental() %}
        {% endif %}
        UNION ALL
        {% endif %}
        {% endfor %}
        );