use std::io::Write;
use borsh::{BorshDeserialize, BorshSerialize};
use crate::account_id::AccountId;
use crate::{Balance, EthAddress, U256};

#[must_use]
#[derive(Debug, BorshSerialize, BorshDeserialize)]
pub enum PromiseArgs {
    Create(PromiseCreateArgs),
    Callback(PromiseWithCallbackArgs),
}

#[must_use]
#[derive(Debug, BorshSerialize, BorshDeserialize)]
pub struct PromiseCreateArgs {
    pub target_account_id: AccountId,
    pub method: String,
    pub args: Vec<u8>,
    pub attached_balance: u128,
    pub attached_gas: u64,
}

#[must_use]
#[derive(Debug, BorshSerialize, BorshDeserialize)]
pub struct PromiseWithCallbackArgs {
    pub base: PromiseCreateArgs,
    pub callback: PromiseCreateArgs,
}

#[derive(Debug, BorshSerialize, BorshDeserialize)]
pub enum PromiseAction {
    Transfer {
        amount: u128,
    },
    DeployConotract {
        code: Vec<u8>,
    },
    FunctionCall {
        name: String,
        args: Vec<u8>,
        attached_yocto: u128,
        gas: u64,
    },
}

#[must_use]
#[derive(Debug, BorshSerialize, BorshDeserialize)]
pub struct PromiseBatchAction {
    pub target_account_id: AccountId,
    pub actions: Vec<PromiseAction>,
}

/// withdraw NEAR eth-connector call args
#[derive(BorshSerialize, BorshDeserialize)]
pub struct WithdrawCallArgs {
    pub recipient_address: EthAddress,
    pub amount: Balance,
}

/// withdraw NEAR eth-connector call args
#[derive(BorshSerialize, BorshDeserialize)]
pub struct RefundCallArgs {
    pub recipient_address: EthAddress,
    pub erc20_address: Option<EthAddress>,
    pub amount: U256,
}

// impl BorshSerialize for RefundCallArgs {
//     fn serialize<W: Write>(&self, writer: &mut W) -> std::io::Result<()> {
//         todo!()
//     }
// }
