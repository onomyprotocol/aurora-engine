use borsh::{BorshDeserialize, BorshSerialize};
use crate::{Add, Div, Mul, Sub, Write};

#[derive(Debug, Default, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub struct U256(primitive_types::U256);

impl U256 {
    pub const MAX: U256 = U256(primitive_types::U256::MAX);

    pub const fn new(raw: [u64; 4]) -> U256 {
        Self(primitive_types::U256(raw))
    }

    pub const fn new_u64(value: u64) -> U256 {
        Self(primitive_types::U256([value, 0, 0, 0]))
    }

    pub const fn zero() -> Self {
        Self(primitive_types::U256::zero())
    }

    pub fn one() -> Self {
        Self(primitive_types::U256::one())
    }

    pub fn from_bytes(bytes: [u8; 32]) -> U256 {
        Self(primitive_types::U256::from(bytes))
    }

    pub fn from_slice(slice: &[u8]) -> U256 {
        Self(primitive_types::U256::from(slice))
    }

    pub fn from_big_endian(slice: &[u8]) -> U256 {
        Self(primitive_types::U256::from_big_endian(slice))
    }

    pub fn is_zero(&self) -> bool {
        self.0.is_zero()
    }

    pub fn to_be_bytes(self) -> [u8; 32] {
        let mut result = [0u8; 32];
        self.0.to_big_endian(&mut result);
        result
    }

    pub fn bits(&self) -> u64 {
        self.0.bits() as u64
    }

    pub fn checked_add(self, other: Self) -> Option<Self> {
        self.0.checked_add(other.0).map(Self)
    }

    pub fn checked_sub(self, other: Self) -> Option<Self> {
        self.0.checked_sub(other.0).map(Self)
    }

    pub fn checked_mul(self, other: Self) -> Option<Self> {
        self.0.checked_mul(other.0).map(Self)
    }

    pub fn as_u64(&self) -> u64 {
        self.0.as_u64()
    }

    pub fn as_u128(&self) -> u128 {
        self.0.as_u128()
    }

    pub fn pow(self, exp: Self) -> Self {
        Self(self.0.pow(exp.0))
    }

    pub fn into_raw(self) -> primitive_types::U256 {
        self.0
    }
}

impl Add<U256> for U256 {
    type Output = U256;

    fn add(self, rhs: U256) -> Self::Output {
        U256(self.0 + rhs.0)
    }
}

impl Sub<U256> for U256 {
    type Output = U256;

    fn sub(self, rhs: U256) -> Self::Output {
        U256(self.0 - rhs.0)
    }
}

impl Mul<U256> for U256 {
    type Output = U256;

    fn mul(self, rhs: U256) -> Self::Output {
        U256(self.0 * rhs.0)
    }
}

impl Div<U256> for U256 {
    type Output = U256;

    fn div(self, rhs: U256) -> Self::Output {
        U256(self.0 / rhs.0)
    }
}

impl BorshSerialize for U256 {
    fn serialize<W: Write>(&self, writer: &mut W) -> std::io::Result<()> {
        writer.write_all(&self.to_be_bytes())
    }
}

impl BorshDeserialize for U256 {
    fn deserialize(buf: &mut &[u8]) -> std::io::Result<Self> {
        let mut value_raw = [0u8; 32];
        value_raw.copy_from_slice(&buf[20..52]);
        let value = Self(primitive_types::U256::from(value_raw));
        Ok(value)
    }
}
