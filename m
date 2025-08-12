Return-Path: <io-uring+bounces-8944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F08B229CA
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 16:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D49021AA4631
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 14:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFBC299A93;
	Tue, 12 Aug 2025 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="ce7kOzhR"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B7129993E;
	Tue, 12 Aug 2025 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755007226; cv=pass; b=gJ3Hbp/22GRHnUM427baJEsGG3iDuw+Fvte7DVU+ekqmuFcMJrODKqt/84lWo/+dloTvwfhwDDTnljc0rZ5oOagGGbWIBiFNJcBIGQvwd/6GV5+0QUoTkWa9zVqVTXrjrw0G0QQwkC8gY+wxb/RPVPph8JM619eKux31g212eBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755007226; c=relaxed/simple;
	bh=j/ZA9gBNBT8J+qne6/TuGelsITMow80OaGf0G+XRTkA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=RbxZ838UnyeFhiPdmAm4SHR9mhwjKu1Te3Ck2Ft1+Oc/VVxbNUc6OJzJrHaY24Kip10mnvSHp5Nrynp8QSuqQb0rnujHNI9NNbxVbbtzmhbuyUTxnse6omKbhXmSD2ejhfyIynB6WnsG7b2bBMaVjaKOpd4Hdc7QuFO+5P02IK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=ce7kOzhR; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1755007212; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=IcuDeos2bCTRmTMoVIBbpJaTJYJ30GqATX28LI3my20fN+iU+WJWEz0/64KjFXHelkSfEAhLlsFuqKJeu2Waf1wFg0CDhFOzGwxD+0uQtPTqxqV9FMXKSrFGOKQ8n+oii0v5FUr3Vj9tIimLoNuuijXMRIIU+HFMY6tvU6qP+dQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755007212; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=j/ZA9gBNBT8J+qne6/TuGelsITMow80OaGf0G+XRTkA=; 
	b=Yx8wVISr71b7mBgqaVHc4qkAAm7QErSSSx3cdG9CGqhAZuPkcvbR0GO2Ce4QxsmWTeN67p5TKngJt5TZNz8JY4ZkEuTLEEVDX1BOh2jvQ1qDjHqTCf/FK4AVN7Rb/io7Vrr/FeVnCl0v3wziHGVGGjfW2bNfAxFHj6g17QRQHSE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755007212;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=j/ZA9gBNBT8J+qne6/TuGelsITMow80OaGf0G+XRTkA=;
	b=ce7kOzhRfJmPLf4ZYtzz/7eIbfviSb3l3LRdtmjLbG0oPiJLU0cqZrSZP6RtKle/
	9ppwtg6iL+qmZ5n+Un+LnLBWsxkqe36IbdkhL2YOnDgfWVXOR/+shBQNmLM8aQywsQx
	UOf5v5JBn74EA5v30Q1S8SItsj7rHJgBr+WLTbzU=
Received: by mx.zohomail.com with SMTPS id 1755007210561917.3985262935906;
	Tue, 12 Aug 2025 07:00:10 -0700 (PDT)
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
In-Reply-To: <aJtIDlSBLJSRxBwQ@sidongui-MacBookPro.local>
Date: Tue, 12 Aug 2025 10:59:55 -0300
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
Message-Id: <F3F2A1C5-AD63-4F6C-A60D-F7C5CE7E65A9@collabora.com>
References: <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
 <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
 <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
 <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>
 <aJnjYPAqA6vtn9YH@sidongui-MacBookPro.local>
 <8416C381-A654-41D4-A731-323CEDE58BB1@collabora.com>
 <aJoDTDwkoj50eKBX@sidongui-MacBookPro.local>
 <DC0B7TRVRFMY.29LDRJOU3WJY2@kernel.org>
 <aJsxUpWXu6phEMLR@sidongui-MacBookPro.local>
 <9A6E941F-3F40-40C5-A900-4C22B27D1982@collabora.com>
 <aJtIDlSBLJSRxBwQ@sidongui-MacBookPro.local>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External



> On 12 Aug 2025, at 10:56, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> On Tue, Aug 12, 2025 at 09:43:56AM -0300, Daniel Almeida wrote:
>>=20
>>=20
>>> On 12 Aug 2025, at 09:19, Sidong Yang <sidong.yang@furiosa.ai> =
wrote:
>>>=20
>>> On Tue, Aug 12, 2025 at 10:34:56AM +0200, Benno Lossin wrote:
>>>> On Mon Aug 11, 2025 at 4:50 PM CEST, Sidong Yang wrote:
>>>>> On Mon, Aug 11, 2025 at 09:44:22AM -0300, Daniel Almeida wrote:
>>>>>>> There is `uring_cmd` callback in `file_operation` at c side. =
`Pin<&mut IoUringCmd>`
>>>>>>> would be create in the callback function. But the callback =
function could be
>>>>>>> called repeatedly with same `io_uring_cmd` instance as far as I =
know.
>>>>>>>=20
>>>>>>> But in c side, there is initialization step =
`io_uring_cmd_prep()`.
>>>>>>> How about fill zero pdu in `io_uring_cmd_prep()`? And we could =
assign a byte
>>>>>>> as flag in pdu for checking initialized also we should provide =
31 bytes except
>>>>>>> a byte for the flag.
>>>>>>>=20
>>>>>>=20
>>>>>> That was a follow-up question of mine. Can=C2=B4t we enforce =
zero-initialization
>>>>>> in C to get rid of this MaybeUninit? Uninitialized data is just =
bad in general.
>>>>>>=20
>>>>>> Hopefully this can be done as you've described above, but I don't =
want to over
>>>>>> extend my opinion on something I know nothing about.
>>>>>=20
>>>>> I need to add a commit that initialize pdu in prep step in next =
version.=20
>>>>> I'd like to get a comment from io_uring maintainer Jens. Thanks.
>>>>>=20
>>>>> If we could initialize (filling zero) in prep step, How about =
casting issue?
>>>>> Driver still needs to cast array to its private struct in unsafe?
>>>>=20
>>>> We still would have the casting issue.
>>>>=20
>>>> Can't we do the following:
>>>>=20
>>>> * Add a new associated type to `MiscDevice` called `IoUringPdu` =
that
>>>> has to implement `Default` and have a size of at most 32 bytes.
>>>> * make `IoUringCmd` generic
>>>> * make `MiscDevice::uring_cmd` take `Pin<&mut =
IoUringCmd<Self::IoUringPdu>>`
>>>> * initialize the private data to be `IoUringPdu::default()` when we
>>>> create the `IoUringCmd` object.
>>>=20
>>> `uring_cmd` could be called multiple times. So we can't initialize
>>> in that time. I don't understand that how can we cast [u8; 32] to
>>> `IoUringPdu` safely. It seems that casting can't help to use unsafe.
>>> I think best way is that just return zerod `&mut [u8; 32]` and

Also, I agree about zeroing out the array, let=E2=80=99s try to not have =
this
MaybeUninit thing here if possible.

>>> each driver implements safe serde logic for its private data.=20
>>>=20
>>=20
>> Again, can=C2=B4t we use FromBytes for this?
>=20
> Agreed, we need FromBytes for read_pdu and AsBytes for write_pdu. I'll =
reference
> dma code for next version.
>=20
> Thanks,
> Sidong
>>=20
>>=20



