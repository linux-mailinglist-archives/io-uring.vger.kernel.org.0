Return-Path: <io-uring+bounces-9373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E07DB3951A
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 585BC16FD49
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 07:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE03D2C08A8;
	Thu, 28 Aug 2025 07:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGY/4w04"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F6E2877E2;
	Thu, 28 Aug 2025 07:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756365960; cv=none; b=AMKqoNWKh4WQ+/sr5pCSNtgcjjqzehZmpkQw8SzF6deWXkFqPDjLf/zptE3M3zaDWLaQfjuqwDVx/YRY+k0dlgaxvbwwlGr1QOhP/xQaivGPDSWilCRkzOMzjPqi7CRXaIxB/AikmyaWUKZm4GcnwVWQGkthwMV2R+GHxQqWmfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756365960; c=relaxed/simple;
	bh=2BRwtGaDZ/6Km5UhK2qGK47+lM1iCESKOunbULBWRtk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=exNbtV3jASM+Eb9ZMHMh0NxXiCHq3CK4Efdi2xahSq5xukDI+Ta1fkHqoacHShVq5O6SSuBa2CEIKBN0gEiY4jtpns4rBcHrM+kMOrC4R42ZbGW6uE/GCbvdRaIetxIRyi5tyeyAgF2zAxcUpQEtlQJ6QPyQY/WQEn6H4n/K7Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGY/4w04; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F754C4CEEB;
	Thu, 28 Aug 2025 07:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756365960;
	bh=2BRwtGaDZ/6Km5UhK2qGK47+lM1iCESKOunbULBWRtk=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=XGY/4w04AxdmWRUziN0qjr1ZicsrOZFbfNTMFu54+Tta8pvvQLQFGnifdQmgWDRhn
	 5QewdC/u4PqZPmxavJ6LnkWMTwDoqPjw2L+8rLKXWMAS3v+UJKMw7JYMtlHjCIATNi
	 wC/nbK02Menz8rZm7LtB6aSTAEgZngLZ0mKtL26Spire86NWqXpq1mUjmwodyCLsoC
	 cZ84LyUoNZh1hPg+lAvSka87xmafwc/nHZbdl9BF4/PtJ9x3Pz04+qz1Q2ZIscisc1
	 6+r+x7TzyA/iTpj1yyIkPbxHazFsrtHOWWWc6bswy+NYK3MqkTzfACEbja6+Nlo1X5
	 dNyZwsZaQvmxQ==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 Aug 2025 09:25:56 +0200
Message-Id: <DCDVRPJKZBC3.31KGTGS90WUUA@kernel.org>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Caleb Sander Mateos"
 <csander@purestorage.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v3 3/5] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Ming Lei" <ming.lei@redhat.com>, "Sidong Yang" <sidong.yang@furiosa.ai>
X-Mailer: aerc 0.20.1
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-4-sidong.yang@furiosa.ai> <aK-kd3GBhxOzt_mA@fedora>
In-Reply-To: <aK-kd3GBhxOzt_mA@fedora>

On Thu Aug 28, 2025 at 2:36 AM CEST, Ming Lei wrote:
> On Fri, Aug 22, 2025 at 12:55:53PM +0000, Sidong Yang wrote:
>> +    /// Reads protocol data unit as `T` that impl `FromBytes` from urin=
g cmd
>> +    ///
>> +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.
>> +    #[inline]
>> +    pub fn read_pdu<T: FromBytes>(&self) -> Result<T> {
>> +        // SAFETY: `self.inner` is guaranteed by the type invariant to =
point
>> +        // to a live `io_uring_cmd`, so dereferencing is safe.
>> +        let inner =3D unsafe { &mut *self.inner.get() };
>> +
>> +        let len =3D size_of::<T>();
>> +        if len > inner.pdu.len() {
>> +            return Err(EFAULT);
>> +        }
>> +
>> +        let mut out: MaybeUninit<T> =3D MaybeUninit::uninit();
>> +        let ptr =3D &raw mut inner.pdu as *const c_void;
>> +
>> +        // SAFETY:
>> +        // * The `ptr` is valid pointer from `self.inner` that is guara=
nteed by type invariant.
>> +        // * The `out` is valid pointer that points `T` which impls `Fr=
omBytes` and checked
>> +        //   size of `T` is smaller than pdu size.
>> +        unsafe {
>> +            core::ptr::copy_nonoverlapping(ptr, out.as_mut_ptr().cast::=
<c_void>(), len);
>> +        }
>> +
>> +        // SAFETY: The read above has initialized all bytes in `out`, a=
nd since `T` implements
>> +        // `FromBytes`, any bit-pattern is a valid value for this type.
>> +        Ok(unsafe { out.assume_init() })
>> +    }
>> +
>> +    /// Writes the provided `value` to `pdu` in uring_cmd `self`
>> +    ///
>> +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.
>> +    #[inline]
>> +    pub fn write_pdu<T: AsBytes>(&mut self, value: &T) -> Result<()> {
>> +        // SAFETY: `self.inner` is guaranteed by the type invariant to =
point
>> +        // to a live `io_uring_cmd`, so dereferencing is safe.
>> +        let inner =3D unsafe { &mut *self.inner.get() };
>> +
>> +        let len =3D size_of::<T>();
>> +        if len > inner.pdu.len() {
>> +            return Err(EFAULT);
>> +        }
>> +
>> +        let src =3D (value as *const T).cast::<c_void>();
>> +        let dst =3D &raw mut inner.pdu as *mut c_void;
>> +
>> +        // SAFETY:
>> +        // * The `src` is points valid memory that is guaranteed by `T`=
 impls `AsBytes`
>> +        // * The `dst` is valid. It's from `self.inner` that is guarant=
eed by type invariant.
>> +        // * It's safe to copy because size of `T` is no more than len =
of pdu.
>> +        unsafe {
>> +            core::ptr::copy_nonoverlapping(src, dst, len);
>> +        }
>> +
>> +        Ok(())
>> +    }
>
> pdu is part of IoUringCmd, which is live in the whole uring_cmd lifetime.=
 But
> both read_pdu()/write_pdu() needs copy to read or write any byte in the p=
du, which
> is slow and hard to use, it could be more efficient to add two methods to=
 return
> Result<&T> and Result<mut &T> for user to manipulate uring_cmd's pdu.

That can also be useful, but you do need to ensure that the pdu is
aligned to at least the required alignment of `T` for this to be sound.
I also don't follow your argument that reading & writing the pdu is
slow.

---
Cheers,
Benno

