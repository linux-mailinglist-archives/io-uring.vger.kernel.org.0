Return-Path: <io-uring+bounces-9372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64525B39511
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84ACF189773F
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 07:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A7E2D6410;
	Thu, 28 Aug 2025 07:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mezRO6x0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A51C2D640F;
	Thu, 28 Aug 2025 07:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756365870; cv=none; b=gt/WgYvxKS7bCgEvRifkHP0zUbXENKHmPUskZrsH81k+Zg+zRYCRt8CX/cUJkSgM15u9yCbMIXGdULxGVdF18UnYAS0kI/5vpdf4BTPRuEnWjq8tHRL77Kfm7UuVlQIaCBk4Q21uK5/Y6orILfqHO0Lie4Nq9EaNZxJU73uDSLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756365870; c=relaxed/simple;
	bh=kQG38cYM4JRE1WeFJ56W/++Qh87E6kimOZt0OksguyY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ETMqAV8g4JXSrgeTE5Ht3hh0CcsGLN75iMbIhjJDGgExnhiA7K/sFkE4uUmXtPnexyQ8jTdAtx3gUuFJyN63h4BOOypx2dT8LXfhfMpC+KjiTScpo5OT0tH1XMbKbJZp7FAjY4p4o8M/Zxh7ZRid264R5Z/0k1Drqa5gjgwLJEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mezRO6x0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6982C4CEEB;
	Thu, 28 Aug 2025 07:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756365868;
	bh=kQG38cYM4JRE1WeFJ56W/++Qh87E6kimOZt0OksguyY=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=mezRO6x0xwzQ0vmC6QNKbYumTfS+3CrobdOo9gPvJ74sShwJrBkTPJdXl+egE+Bfx
	 ju4q4nmU1TkaSjdLR0rXxw3cVbVFA48SbB3MOuiIomFfCnwTN7kIIPffJFPqLqozYU
	 RETK1ALs/EmzE6iWB96RLWMO9f69VnaqUOQ+BobASqskVQI1W6V/gYW2V2t9HThsfC
	 wreAGw4VATkziaoU8ahLKELTUPRDrlzV6ZwBYFDXDPle0miWtNJWTOSR19RfpPf3l9
	 syFsfKeDHzf7CQzx3aFL8HSVOgYNVSP5wVkkXaLXk3OPsQIwbbcDYQVL5A5+Hwybzf
	 4OxGxBugduf3A==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 Aug 2025 09:24:24 +0200
Message-Id: <DCDVQJI16SQI.RKEIM4BE7RZT@kernel.org>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Caleb Sander Mateos"
 <csander@purestorage.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v3 3/5] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Daniel Almeida" <daniel.almeida@collabora.com>, "Sidong Yang"
 <sidong.yang@furiosa.ai>
X-Mailer: aerc 0.20.1
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-4-sidong.yang@furiosa.ai>
 <713667D6-8001-408D-819D-E9326FC3AFD5@collabora.com>
In-Reply-To: <713667D6-8001-408D-819D-E9326FC3AFD5@collabora.com>

On Wed Aug 27, 2025 at 10:41 PM CEST, Daniel Almeida wrote:
>> On 22 Aug 2025, at 09:55, Sidong Yang <sidong.yang@furiosa.ai> wrote:
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
>
> I don=E2=80=99t think you need to manually specify c_void here.

In fact using `c_void` as the pointee type is wrong, since it's a ZST
and thus this call copies no bytes whatsoever.

> Benno, can=E2=80=99t we use core::mem::zeroed() or something like that to=
 avoid this unsafe?
>
> The input was zeroed in prep() and the output can just be a zeroed T on t=
he
> stack, unless I missed something?

Hmm I'm not sure I follow, I don't think that `mem::zeroed` will help
(it also is an unsafe function).

We have a helper in flight that might be useful in this case:

    https://lore.kernel.org/all/20250826-nova_firmware-v2-1-93566252fe3a@nv=
idia.com

---
Cheers,
Benno

