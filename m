Return-Path: <io-uring+bounces-8942-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6FC3B2273A
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 14:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E21716AA9F
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 12:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6203A2222BF;
	Tue, 12 Aug 2025 12:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="WTKJMJNG"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737233C2F;
	Tue, 12 Aug 2025 12:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755002669; cv=pass; b=f86WGSuUYZJ4eP4IdIUE2u+UHxmwmZab/g6jw83WaZtp4wwEFQxPT0XAotn+mbpp8zY9VjqkOOzruQ967tnW9WLsP569rdOi/dX7G5yMJ8USI8lrS+6hKVru+dLX2qQeBMfWN4+yhhhiZT6k2hb6Ply1lJeBN5gOoFdyV71k4X8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755002669; c=relaxed/simple;
	bh=aovnMvauQF14l6Ev5ezrn3B0Zeb5MSpsT+UmdVvzVno=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=N34LPRXHpjxFbpID+wqfZqDjsQdFw1SFDakyaiVDpJWev2h2XWbUoxv5IvI+0rdu3xDV2oNQmEj7+EyvifndFs+m9GmKdYS2i9omC1SKLlOGd6U80DjiTvMH8wq7GzxGuTboY+yyI6MUxo/rkGtgOjkG4cr6bcfXmOOjfC8PnSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=WTKJMJNG; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1755002654; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lVQIibjdfhvMYBlR2QpvF1RpUnyaGJfDmIVEFm3xuwbZcYpobtvb/c3y6dMugUmzWCCYGzbietd7im/ZYeZ3a2vCQjrlHYrk7bd4hJ9UQGZ9qm4Gh8xuyJWjiOPaipLeea5+dlAtyIORY21oc7UPnqjTW7v0riPFQsy4FaczsIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755002654; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=NOOoxngxEdcM2kIUlTo4kWzeob+fFsO+rooI1FvSjkE=; 
	b=nytNkYIIiLDhhjbMrHhe2+Z5MxLiti3Szv3XASp1+vniC+tsQ9mnhozUKxRZk+LXZEJ8YwbebpSABegV7MzIrYY+fkglLUcZxS4AlWnSi4OQvBtAKEk2EgBCIzrJix2x5VRpp6oEGzlKHLTYYMtreDBVRY+Npj4RbEOT/OkZGrc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755002654;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=NOOoxngxEdcM2kIUlTo4kWzeob+fFsO+rooI1FvSjkE=;
	b=WTKJMJNGyjpvuT+FaweVGWfRNbK7cw18YEFnMqJ+BdA4lIjv4WTx8YVo2+rTxwTw
	LaR+Dm8z+NfEXiPbDuh5ZlodPnt/uLRFTiLA9HiaHtxN1vVIHmNBHoqTjBomQ3Pq52e
	GEU7dhMZRGyThkxeepM3njE/+99uTEPNMc7LGz1E=
Received: by mx.zohomail.com with SMTPS id 1755002651086223.74919088830302;
	Tue, 12 Aug 2025 05:44:11 -0700 (PDT)
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
In-Reply-To: <aJsxUpWXu6phEMLR@sidongui-MacBookPro.local>
Date: Tue, 12 Aug 2025 09:43:56 -0300
Cc: Benno Lossin <lossin@kernel.org>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9A6E941F-3F40-40C5-A900-4C22B27D1982@collabora.com>
References: <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>
 <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>
 <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
 <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
 <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
 <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>
 <aJnjYPAqA6vtn9YH@sidongui-MacBookPro.local>
 <8416C381-A654-41D4-A731-323CEDE58BB1@collabora.com>
 <aJoDTDwkoj50eKBX@sidongui-MacBookPro.local>
 <DC0B7TRVRFMY.29LDRJOU3WJY2@kernel.org>
 <aJsxUpWXu6phEMLR@sidongui-MacBookPro.local>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External



> On 12 Aug 2025, at 09:19, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> On Tue, Aug 12, 2025 at 10:34:56AM +0200, Benno Lossin wrote:
>> On Mon Aug 11, 2025 at 4:50 PM CEST, Sidong Yang wrote:
>>> On Mon, Aug 11, 2025 at 09:44:22AM -0300, Daniel Almeida wrote:
>>>>> There is `uring_cmd` callback in `file_operation` at c side. =
`Pin<&mut IoUringCmd>`
>>>>> would be create in the callback function. But the callback =
function could be
>>>>> called repeatedly with same `io_uring_cmd` instance as far as I =
know.
>>>>>=20
>>>>> But in c side, there is initialization step `io_uring_cmd_prep()`.
>>>>> How about fill zero pdu in `io_uring_cmd_prep()`? And we could =
assign a byte
>>>>> as flag in pdu for checking initialized also we should provide 31 =
bytes except
>>>>> a byte for the flag.
>>>>>=20
>>>>=20
>>>> That was a follow-up question of mine. Can=C2=B4t we enforce =
zero-initialization
>>>> in C to get rid of this MaybeUninit? Uninitialized data is just bad =
in general.
>>>>=20
>>>> Hopefully this can be done as you've described above, but I don't =
want to over
>>>> extend my opinion on something I know nothing about.
>>>=20
>>> I need to add a commit that initialize pdu in prep step in next =
version.=20
>>> I'd like to get a comment from io_uring maintainer Jens. Thanks.
>>>=20
>>> If we could initialize (filling zero) in prep step, How about =
casting issue?
>>> Driver still needs to cast array to its private struct in unsafe?
>>=20
>> We still would have the casting issue.
>>=20
>> Can't we do the following:
>>=20
>> * Add a new associated type to `MiscDevice` called `IoUringPdu` that
>>  has to implement `Default` and have a size of at most 32 bytes.
>> * make `IoUringCmd` generic
>> * make `MiscDevice::uring_cmd` take `Pin<&mut =
IoUringCmd<Self::IoUringPdu>>`
>> * initialize the private data to be `IoUringPdu::default()` when we
>>  create the `IoUringCmd` object.
>=20
> `uring_cmd` could be called multiple times. So we can't initialize
> in that time. I don't understand that how can we cast [u8; 32] to
> `IoUringPdu` safely. It seems that casting can't help to use unsafe.
> I think best way is that just return zerod `&mut [u8; 32]` and
> each driver implements safe serde logic for its private data.=20
>=20

Again, can=E2=80=99t we use FromBytes for this?



