Return-Path: <io-uring+bounces-8889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DF303B1C6E3
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 15:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C92C94E21EF
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 13:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C024428A1C3;
	Wed,  6 Aug 2025 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pWfsYmeR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8891FCFF8;
	Wed,  6 Aug 2025 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754487508; cv=none; b=ds/omHcPJzlent23/MErtkEB8pXzyaBblDggX+9+2EKA5sOn/sLrOdw0aNZgu5CuYH8ZI5VwaVckXnfcZ2FLMFNya/Kpld37zyJh50aF93sgc4AgReG4N+hHP+zFGxlHOHuF2I5XRqQKh0OGiQxmhRdkbbX5nJLzRhPWQt9zsXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754487508; c=relaxed/simple;
	bh=EXeJdlV2l9siHlCdzxLcpO0/EEIT41rvnXKkPC75PL4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=JuLAF4WQ6sdcn/1I0d6uIPEBIeTf2zGtgRJV6PbeGjbUExJ8MukGB8vcBrpwllFuYoaVMFbPyFWElb7xjFKSWEWyd+2Qa2JT49+eGhLWQJYlfw4t+5orEAg9JKwuMm9dSP0WeGn65MbCU1uRa0YymnYb0pvMWLGf11TlrjymRAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pWfsYmeR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BF6C4CEE7;
	Wed,  6 Aug 2025 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754487508;
	bh=EXeJdlV2l9siHlCdzxLcpO0/EEIT41rvnXKkPC75PL4=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=pWfsYmeRTznjmgArL1NsO2hc+MId0hZuVHfbE2pF4bs6gHPm5QDi/ZvxFZI8n1jwb
	 SrmwVe39Pp89NRON+Cc61hENmdSRXtXPHD0dtFWpkTySNboj9sKEY1e7LJlLdAvsmR
	 IMkZnRnlPhZ6hMdvuzecEUawEOpbQhu1zCoTll4GFYAOq+5lxmSEKfRLDt/rz6cXDU
	 XwaBsR4oUFS/kVRqn8vygNgICPRGduT8HH6ueM69wCdSAJEZdQempfGFE2H+TWxlKU
	 SDK1AWVYtoPaYoNJk3Hpg2GpDXjrUs1DDPrS2MubLOw3jfI/EHVa0pfUy1nDdyTNex
	 3C/PsAZYIrXgw==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 06 Aug 2025 15:38:24 +0200
Message-Id: <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org>
Cc: "Sidong Yang" <sidong.yang@furiosa.ai>, "Caleb Sander Mateos"
 <csander@purestorage.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Jens Axboe" <axboe@kernel.dk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Daniel Almeida" <daniel.almeida@collabora.com>
X-Mailer: aerc 0.20.1
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
 <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
In-Reply-To: <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>

On Wed Aug 6, 2025 at 2:38 PM CEST, Daniel Almeida wrote:
> Hi Benno,
>
>> On 2 Aug 2025, at 07:52, Benno Lossin <lossin@kernel.org> wrote:
>>=20
>> On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
>>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>>>> +    #[inline]
>>>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
>>>=20
>>> Why MaybeUninit? Also, this is a question for others, but I don=E2=80=
=99t think
>>> that `u8`s can ever be uninitialized as all byte values are valid for `=
u8`.
>>=20
>> `u8` can be uninitialized. Uninitialized doesn't just mean "can take any
>> bit pattern", but also "is known to the compiler as being
>> uninitialized". The docs of `MaybeUninit` explain it like this:
>>=20
>>    Moreover, uninitialized memory is special in that it does not have a
>>    fixed value (=E2=80=9Cfixed=E2=80=9D meaning =E2=80=9Cit won=E2=80=99=
t change without being written
>>    to=E2=80=9D). Reading the same uninitialized byte multiple times can =
give
>>    different results.
>>=20
>> But the return type probably should be `&mut [MaybeUninit<u8>; 32]`
>> instead.
>
>
> Right, but I guess the question then is why would we ever need to use
> MaybeUninit here anyways.
>
> It's a reference to a C array. Just treat that as initialized.

AFAIK C uninitialized memory also is considered uninitialized in Rust.
So if this array is not properly initialized on the C side, this would
be the correct type. If it is initialized, then just use `&mut [u8; 32]`.

---
Cheers,
Benno

