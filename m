Return-Path: <io-uring+bounces-7283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F98A750F1
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 20:41:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CE831694F1
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 19:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591751E3780;
	Fri, 28 Mar 2025 19:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mc/kkK08"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0FD440C
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 19:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743190876; cv=none; b=DLrMz5nYcCs7LrZFTnElbq7Lftrr/Ktu1BjP/gpMRnjK2z5A/bmM4jkKMgcSj0pv+TfIbQgCNs4Eu4J7pMV8gzgosDUogH188rEKi1ymnme1tjrc99BkX3LSHLz0fFdkBwkvGCQLH64RIIf5y3yOe4DaAKUP9kzCE/OiK/aOdWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743190876; c=relaxed/simple;
	bh=gGbF0UheBJqLmm9MZrBMNlOU9W4/l1egLQ7aRYz7Tv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJqQQ2vhGi6sb25dIspe6OgqbQz3eEua5eG6hZ9rwGQhe9OXQeHGw+x+hLCnaLX/2jR7T/+g8dmp/Zdyw1ZjQBx50J2SgsVL5b+KsT8OMHgG4YKTseiYZPuPcZHj4KmTIR77SU0RSGwU2aawviEN0PMmdEitMUnktkEnHbNabG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=mc/kkK08; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=sNxfLBb5shECwsPWSOylRpnKndzkoUxawVjcjwxZK/o=; b=mc/kkK086p0MFNFJEPnciSBYv7
	0DPb0dFnuk/e5ilAEDwpAxFZRTeBZjcpEKsduLvpmPpxuhvHEasQSyjl5b+MtBITlBVlx7YQn2m/0
	I2b4VedD23X13T8Yd8+6l37tMY/RzBxsYfpbfTJAq2RTOBssgyT6zcyoZP8xnOh4rfwiwMN6o7SCt
	hgMFWmC02jljrRyJHb2C2ZpnyYr6PKxT5wh7KyyPZVTyZn047b+gz4i3uWYVDh39406x8MIYDR6WC
	Q8LuNoB9B851iuVmU+0upu5Weaxu8a7tcs4Ey4vpkw5Ym/xijVKutqUzBzCRvOvFuWFJFdcQuBvDw
	cGj7CfFDCESKK9KTmtZ4b0Gy9frJakqwMDNBkguie6HBtex4lSQ4C210XR1yBh+V5ytPg3nbsbQyD
	hnMOk4AdHYi6JrfJPFGXfJIpIlPUrF2i7UEvYD/O8VfJDN/+dYIYJF4oj+uTqJ7fjAxXCVrMCt0NM
	Ku1B9H2RN6l+EV7aaTM/VEpk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tyFZo-007954-0D;
	Fri, 28 Mar 2025 19:41:12 +0000
Message-ID: <86b1dce5-4bb4-4a0b-9cff-e72f488bf57d@samba.org>
Date: Fri, 28 Mar 2025 20:41:10 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Breno Leitao <leitao@debian.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
 <3b59c209-374c-4d04-ad5d-7ad8aa312c0b@kernel.dk>
 <e5cac037-f729-4d3a-9fe6-2c9ba9d55894@gmail.com>
 <876b1590-0576-40f8-af9a-bcd135374320@gmail.com>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <876b1590-0576-40f8-af9a-bcd135374320@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.03.25 um 18:21 schrieb Pavel Begunkov:
> On 3/28/25 17:18, Pavel Begunkov wrote:
>> On 3/28/25 16:34, Jens Axboe wrote:
>>> On 3/28/25 9:02 AM, Pavel Begunkov wrote:
>>>> On 3/28/25 14:30, Jens Axboe wrote:
>>>>> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>>>>>> Hi Jens,
>>>>>>
>>>>>> while playing with the kernel QUIC driver [1],
>>>>>> I noticed it does a lot of getsockopt() and setsockopt()
>>>>>> calls to sync the required state into and out of the kernel.
>>>>>>
>>>>>> My long term plan is to let the userspace quic handshake logic
>>>>>> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
>>>>>>
>>>>>> The used level is SOL_QUIC and that won't work
>>>>>> as io_uring_cmd_getsockopt() has a restriction to
>>>>>> SOL_SOCKET, while there's no restriction in
>>>>>> io_uring_cmd_setsockopt().
>>>>>>
>>>>>> What's the reason to have that restriction?
>>>>>> And why is it only for the get path and not
>>>>>> the set path?
>>>>>
>>>>> There's absolutely no reason for that, looks like a pure oversight?!
>>>>
>>>> Cc Breno, he can explain better, but IIRC that's because most
>>>> of set/get sockopt options expect user pointers to be passed in,
>>>> and io_uring wants to use kernel memory. It's plumbed for
>>>> SOL_SOCKET with sockptr_t, but there was a push back against
>>>> converting the rest.
>>>
>>> Gah yes, now I remember. What's pretty annoying though, as it leaves the
>>> get/setsockopt parts less useful than they should be, compared to the
>>> regular syscalls.
>>>
>>> Did we ever ponder ways of getting this sorted out on the net side?
>>
>> I remember Breno looking at several different options.
>>
>> Breno, can you remind me, why can't we convert ->getsockopt to
>> take a normal kernel ptr for length while passing a user ptr
>> for value as before?
> 
> Similar to this:
> 
> getsockopt_syscall(void __user *len_uptr) {
>      int klen;
> 
>      copy_from_user(&klen, len_uptr);
>      ->getsockopt(&klen);
>      copy_to_user(len_uptr, &klen);
> }

Yes, I was thinking about something similar.

I'll give it a go next week.

Thanks!
metze


