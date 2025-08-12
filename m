Return-Path: <io-uring+bounces-8939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 852D4B22189
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 10:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39E18561C49
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 08:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17292E7BD6;
	Tue, 12 Aug 2025 08:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hkd2yKo/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958292E7BD4;
	Tue, 12 Aug 2025 08:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754987700; cv=none; b=O6iWzPh43vQA/nAg1qmsOPDHIlymp0e3bkv3Ac3BDFyurHpTF1PdruWWMYhOKlWqi5wS5PkgZsGzuTR+y4+oqvio6nTf6WLAl62vN9xMBRjuIrORXgsDAu4jkIOxrGcbreyz1qNgkD+Y0X1RUeyboyEHNI8YFrDPH3jbC1AsylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754987700; c=relaxed/simple;
	bh=xTdISAyT0Kzubsk+Rx8mfxAyPYBnzZHTr/cxp81IiDg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=c/a1MK95UztSAp92zzG41/5KY/0T+rZp+4fv6aUb1lNlwHPpJzNqNf9o0u4gTLG0pieEa6inXwEBfEN0BiSwD2zE6RjKviCijHryOTv9/cKAK9JjbAnLvffukxbi4rLq4EHay2f+ShrrjD44LaRiOn+v3dI7+DX3SFtPxyDzSNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hkd2yKo/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAF6C4CEF4;
	Tue, 12 Aug 2025 08:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754987700;
	bh=xTdISAyT0Kzubsk+Rx8mfxAyPYBnzZHTr/cxp81IiDg=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=Hkd2yKo/gVbX3VsamhkYHbKRttvNnisB93+cA9XGxZfcrtke2QmefE7w9fBcu4aNx
	 lCl9WtvZPEtgJMy/Q3qMk/jM6jAsOLWjY0SFwp4ZEwYfsw5G5vadd5n7V5sGU/XH9X
	 QGbzBfaj+bmwgJVQ3LdJGOqjubLphcJeRxq8Vto1fro5FFQEIBWnwLNgd9vpT6N0lY
	 fk+ySHit55c3ow/+ej6DSWoP1cMnk4bWASbJq8BOG5de7YIWjNc1jLGKJrqt04m8Ym
	 2lzpPsSfJsTLsxYEJ8eypyTAYB39tq8GEWkL0FfXapB7IILpjYrvJg2WJMElCk86b6
	 oDhIwd0yKqweA==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Aug 2025 10:34:56 +0200
Message-Id: <DC0B7TRVRFMY.29LDRJOU3WJY2@kernel.org>
Cc: "Caleb Sander Mateos" <csander@purestorage.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Jens Axboe"
 <axboe@kernel.dk>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Sidong Yang" <sidong.yang@furiosa.ai>, "Daniel Almeida"
 <daniel.almeida@collabora.com>
X-Mailer: aerc 0.20.1
References: <aJXG3wPf9W3usEj2@sidongui-MacBookPro.local>
 <DBXTJQ27RY6K.1R6KUNEXF008N@kernel.org>
 <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>
 <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>
 <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
 <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
 <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
 <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>
 <aJnjYPAqA6vtn9YH@sidongui-MacBookPro.local>
 <8416C381-A654-41D4-A731-323CEDE58BB1@collabora.com>
 <aJoDTDwkoj50eKBX@sidongui-MacBookPro.local>
In-Reply-To: <aJoDTDwkoj50eKBX@sidongui-MacBookPro.local>

On Mon Aug 11, 2025 at 4:50 PM CEST, Sidong Yang wrote:
> On Mon, Aug 11, 2025 at 09:44:22AM -0300, Daniel Almeida wrote:
>> > There is `uring_cmd` callback in `file_operation` at c side. `Pin<&mut=
 IoUringCmd>`
>> > would be create in the callback function. But the callback function co=
uld be
>> > called repeatedly with same `io_uring_cmd` instance as far as I know.
>> >=20
>> > But in c side, there is initialization step `io_uring_cmd_prep()`.
>> > How about fill zero pdu in `io_uring_cmd_prep()`? And we could assign =
a byte
>> > as flag in pdu for checking initialized also we should provide 31 byte=
s except
>> > a byte for the flag.
>> >=20
>>=20
>> That was a follow-up question of mine. Can=C2=B4t we enforce zero-initia=
lization
>> in C to get rid of this MaybeUninit? Uninitialized data is just bad in g=
eneral.
>>=20
>> Hopefully this can be done as you've described above, but I don't want t=
o over
>> extend my opinion on something I know nothing about.
>
> I need to add a commit that initialize pdu in prep step in next version.=
=20
> I'd like to get a comment from io_uring maintainer Jens. Thanks.
>
> If we could initialize (filling zero) in prep step, How about casting iss=
ue?
> Driver still needs to cast array to its private struct in unsafe?

We still would have the casting issue.

Can't we do the following:

* Add a new associated type to `MiscDevice` called `IoUringPdu` that
  has to implement `Default` and have a size of at most 32 bytes.
* make `IoUringCmd` generic
* make `MiscDevice::uring_cmd` take `Pin<&mut IoUringCmd<Self::IoUringPdu>>=
`
* initialize the private data to be `IoUringPdu::default()` when we
  create the `IoUringCmd` object.
* provide a `fn pdu(&mut self) -> &mut Pdu` on `IoUringPdu<Pdu>`.

Any thoughts? If we don't want to add a new associated type to
`MiscDevice` (because not everyone has to declare the `IoUringCmd`
data), I have a small trait dance that we can do to avoid that:

    pub trait IoUringMiscDevice: MiscDevice {
        type IoUringPdu: Default; // missing the 32 byte constraint
    }

and then in MiscDevice we still add this function:

        fn uring_cmd(
            _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
            _io_uring_cmd: Pin<&mut IoUringCmd<Self::IoUringPdu>>,
            _issue_flags: u32,
        ) -> Result<i32>
        where
            Self: IoUringMiscDevice,
        {
            build_error!(VTABLE_DEFAULT_ERROR)
        }

It can only be called when the user also implements `IoUringMiscDevice`.

---
Cheers,
Benno

