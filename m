Return-Path: <io-uring+bounces-8881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4BAB18E14
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 12:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C08587AF216
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 10:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F12218AA0;
	Sat,  2 Aug 2025 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cglgFRw1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4960A920;
	Sat,  2 Aug 2025 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754131963; cv=none; b=OBY1s5CwYWHxZP115SLcy/xEcPgUjAvRlxc6ujS3Y3qx01t9CH3joKkMh8mICobwAHJlHIl1fUDK50nhPLpCTQI2nt0jzE+Rxmvpo3LDSnYwvGL30FVljRqxPCNF6HO3Y2+/mVx5bMVcka1EsTiwr7pTFyKc44r+bnXVMIJFCo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754131963; c=relaxed/simple;
	bh=McDOCJ4a4SES7KPDnkL9sXicW14MZyBPA3AthU5BLwQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=DvMtwejkIuhHyveXdiT4UKAnw6nmVZj4J9yW6OyDKQHdJvAA1KiwETUSbTjokJsrOIutpC5dL/0ShhzJyNHpkjrraqTGnyUwOQCsJdqrZm3XCQc05PLg9/0q4/pJzyMjm2UE8xrNg8hgT3Xu5Yo3q7CaEHMv+ArJrmQHfid3dFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cglgFRw1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9F1C4CEEF;
	Sat,  2 Aug 2025 10:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754131963;
	bh=McDOCJ4a4SES7KPDnkL9sXicW14MZyBPA3AthU5BLwQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=cglgFRw1n+ZP/WSEAFGuvsxp6UkFoRchsbQuyBWm0Q4Yfn08fC5gLlBU2jrgMmetd
	 2sEXQIsf8aSZPgKuA1lzS25bt/NjZw3iEb64gV16Dgi80ceB+bUapS5Ppcozg26Qwk
	 jr70YQO35BC5OFDFA8EtSq7+fGCyteAMGfSIi5bKafYJkv3CIfRpMExtp+sAvDXqkG
	 QvFtbFYW1qTrf5Ena86cGKGL0n74ghGKdKF0WnrnpyITLNRWG5hWTWta5/SlHJJLZv
	 WhajmY/HMv2qdP12+ifn9Kq7ond0EL7DkldjpcIjpziy5hF8htiQz8lvlpuq9GXSRM
	 ZTQ9rQfKCTByw==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 02 Aug 2025 12:52:39 +0200
Message-Id: <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Daniel Almeida" <daniel.almeida@collabora.com>, "Sidong Yang"
 <sidong.yang@furiosa.ai>
Cc: "Caleb Sander Mateos" <csander@purestorage.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Jens Axboe"
 <axboe@kernel.dk>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <io-uring@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
In-Reply-To: <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>

On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>> +    #[inline]
>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
>
> Why MaybeUninit? Also, this is a question for others, but I don=E2=80=99t=
 think
> that `u8`s can ever be uninitialized as all byte values are valid for `u8=
`.

`u8` can be uninitialized. Uninitialized doesn't just mean "can take any
bit pattern", but also "is known to the compiler as being
uninitialized". The docs of `MaybeUninit` explain it like this:

    Moreover, uninitialized memory is special in that it does not have a
    fixed value (=E2=80=9Cfixed=E2=80=9D meaning =E2=80=9Cit won=E2=80=99t =
change without being written
    to=E2=80=9D). Reading the same uninitialized byte multiple times can gi=
ve
    different results.

But the return type probably should be `&mut [MaybeUninit<u8>; 32]`
instead.

>> +    #[inline]
>> +    pub unsafe fn from_raw<'a>(ptr: *mut bindings::io_uring_cmd) -> Pin=
<&'a mut IoUringCmd> {
>> +        // SAFETY: The caller guarantees that the pointer is not dangli=
ng and stays valid for the
>> +        // duration of 'a. The cast is okay because `IoUringCmd` is `re=
pr(transparent)` and has the
>> +        // same memory layout as `bindings::io_uring_cmd`. The returned=
 `Pin` ensures that the object
>> +        // cannot be moved, which is required because the kernel may ho=
ld pointers to this memory
>> +        // location and moving it would invalidate those pointers.
>
> Please break this into multiple paragraphs.

We usually use bullet point lists for this.=20

---
Cheers,
Benno

