Return-Path: <io-uring+bounces-8945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36D4AB22AE6
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 16:46:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F0B33A8A26
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 14:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEE42EB5D5;
	Tue, 12 Aug 2025 14:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="dQJtpdhY"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A2529B78F;
	Tue, 12 Aug 2025 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755009564; cv=pass; b=tU7hKMWoC1oaAYVQX2zNTCFx8uuJP2N+IWcprrDyjAQEageQkGbyrD3wHCEhDhinyOyLXM7FxfYiEwYiy6tLbIFymimLtE/Nin3cldpCWKbAaaSay6StBcQgebdLPYQzNDIlOsD3G/jqu8oDa1Co8u2mu/K6VpvKizYeTYuItQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755009564; c=relaxed/simple;
	bh=InctXarNnqRb/ETOEqPkXyiCrdu9G+g2vgs+2i3eu0o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lXFIDuNlJXnTtn0C4rhRJn5xsNv6l7WrIGwWtOwvsf7SZvCyKCdWLAIvQWhlgO7xZ69pEP8iKA09NuZ8yIl6ct/6uIj6dpOzspJULyUpVg0+sy2wlZp2fRvB5aDXJI6GPn2UU8fxHLO1+WbpEt0lJlO2wV32RNUJOlG0S6Z3IJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=dQJtpdhY; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1755009547; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VNIJHveWjcDpqQni0+4iLdgu8IR4dRcXl8oufGXiTGquLeDsAt8QjeEpz9Hq+YpyDx+OFlrEWVdd2S9W1/lcctfp4kH9OWVzZrqwNd9OzqpGYGvMzxPtTLlslWSUZSUn9alUc7tmIaPkie/pgTV0S6CIjmmViyUxdCoGkk9ddL0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755009547; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7VrnAWJxdraX6dhHjpJR8jY8sV7Cnz/G12zmpVymZD4=; 
	b=AMX5U20IxaeMrByKOx99fUiAJzzUPEjkW5C+nzQH16nl7dgrMWcSTupe8CS/jiX8AUKbYaJDLa8i79UcKQVGDJWbnag/Ifc53mjIHPHQ9s9nQNPGwkEiu1kmc6LRMZ13TVPOWqZ2gPv2szNyZrD1rsinr1UNM0PAgOwYAjzb2ko=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755009547;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=7VrnAWJxdraX6dhHjpJR8jY8sV7Cnz/G12zmpVymZD4=;
	b=dQJtpdhYSR5oX1TSSqhJuPTVhQw3xGI2GDyrIDXtfYm0FEgO4/Sewz2eQuAkpbkD
	GCT3uobPEm4GXc1EIB6r+Eds+mWdQ+XTiJsl5c9TSFUWzj8rp4wN2c34vmHL544mV3Y
	vOvuhElL2mtGziL25AHof0mqjP71vl3Je/Yub2I0=
Received: by mx.zohomail.com with SMTPS id 1755009545996160.38625888863203;
	Tue, 12 Aug 2025 07:39:05 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <DC0B7TRVRFMY.29LDRJOU3WJY2@kernel.org>
Date: Tue, 12 Aug 2025 11:38:51 -0300
Cc: Sidong Yang <sidong.yang@furiosa.ai>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <06EA9E60-9BED-4275-9ED3-DA54CF3A8451@collabora.com>
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
 <DC0B7TRVRFMY.29LDRJOU3WJY2@kernel.org>
To: Benno Lossin <lossin@kernel.org>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External



> On 12 Aug 2025, at 05:34, Benno Lossin <lossin@kernel.org> wrote:
>=20
> On Mon Aug 11, 2025 at 4:50 PM CEST, Sidong Yang wrote:
>> On Mon, Aug 11, 2025 at 09:44:22AM -0300, Daniel Almeida wrote:
>>>> There is `uring_cmd` callback in `file_operation` at c side. =
`Pin<&mut IoUringCmd>`
>>>> would be create in the callback function. But the callback function =
could be
>>>> called repeatedly with same `io_uring_cmd` instance as far as I =
know.
>>>>=20
>>>> But in c side, there is initialization step `io_uring_cmd_prep()`.
>>>> How about fill zero pdu in `io_uring_cmd_prep()`? And we could =
assign a byte
>>>> as flag in pdu for checking initialized also we should provide 31 =
bytes except
>>>> a byte for the flag.
>>>>=20
>>>=20
>>> That was a follow-up question of mine. Can=C2=B4t we enforce =
zero-initialization
>>> in C to get rid of this MaybeUninit? Uninitialized data is just bad =
in general.
>>>=20
>>> Hopefully this can be done as you've described above, but I don't =
want to over
>>> extend my opinion on something I know nothing about.
>>=20
>> I need to add a commit that initialize pdu in prep step in next =
version.=20
>> I'd like to get a comment from io_uring maintainer Jens. Thanks.
>>=20
>> If we could initialize (filling zero) in prep step, How about casting =
issue?
>> Driver still needs to cast array to its private struct in unsafe?
>=20
> We still would have the casting issue.
>=20
> Can't we do the following:
>=20
> * Add a new associated type to `MiscDevice` called `IoUringPdu` that
>  has to implement `Default` and have a size of at most 32 bytes.
> * make `IoUringCmd` generic
> * make `MiscDevice::uring_cmd` take `Pin<&mut =
IoUringCmd<Self::IoUringPdu>>`
> * initialize the private data to be `IoUringPdu::default()` when we
>  create the `IoUringCmd` object.
> * provide a `fn pdu(&mut self) -> &mut Pdu` on `IoUringPdu<Pdu>`.
>=20
> Any thoughts? If we don't want to add a new associated type to
> `MiscDevice` (because not everyone has to declare the `IoUringCmd`
> data), I have a small trait dance that we can do to avoid that:


Benno,

IIUC, and note that I'm not proficient with io_uring in general:

I think we have to accept that we will need to parse types from and to =
byte
arrays, and that is inherently unsafe. It is no different from what is =
going on
in UserSliceReader/UserSliceWriter, and IMHO, we should copy that in as =
much as
it makes sense.

I think that the only difference is that all uAPI types de-facto satisfy =
all
the requirements for FromBytes/AsBytes, as we've discussed previously, =
whereas
here, drivers have to prove that their types can implement the trait.


By the way, Sidong, is this byte array shared with userspace? i.e.: is =
there
any copy_to/from_user() taking place here?

-- Daniel=

