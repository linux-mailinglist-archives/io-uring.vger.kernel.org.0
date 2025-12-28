Return-Path: <io-uring+bounces-11316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BB4CE520C
	for <lists+io-uring@lfdr.de>; Sun, 28 Dec 2025 16:46:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2B0F330050A9
	for <lists+io-uring@lfdr.de>; Sun, 28 Dec 2025 15:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9E8136E3F;
	Sun, 28 Dec 2025 15:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mwZdNqhj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com [209.85.167.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45912B665
	for <io-uring@vger.kernel.org>; Sun, 28 Dec 2025 15:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766936764; cv=none; b=peiUhT1Pd7LoYNfRKJjr9Z6/uDqMllV3DLR0cF4nJIbQyQS6bbvalMAKc7t2yZAqKRZCZlA6jyQmTbAwgK9ib7O0BwQxrqFcUW8LYqj/IVVpXD5qXfu3I5jpY8eG171f6WXKCE2Nqd//20qII7kQzhYNG7mAQ/TZn4M0jKA8Y+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766936764; c=relaxed/simple;
	bh=MulVmjwHARqy7rwheWw9SrpplrM/PogbmzNEZ4x0TyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QSZsS2qTYSzZc21zT0s1M+N6iw8SeK/BFIF5gVZsMVAb1P6H42reeYMD4HAWHUJtjqPo/4R453nIjR4kScPFUTq/WzuyztDsYqFMUcMIkIywcBV2T6osQOm2/+yCRJfSUYD2AjnN21Xxm5Ck5Eu4lXDZTgUGQLXTqAhZa8RGKRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mwZdNqhj; arc=none smtp.client-ip=209.85.167.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f193.google.com with SMTP id 5614622812f47-455bef556a8so5783568b6e.1
        for <io-uring@vger.kernel.org>; Sun, 28 Dec 2025 07:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766936760; x=1767541560; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QL4j19IOrqqmuzYnZ1SxQd2ieNi3NuzYkFJwG9nk0po=;
        b=mwZdNqhjFGOL4n9k1Sqy4FOxlXC9psNVL5UnwecICk1z4pLTizL6lXm6TBk7jllPII
         z4Fm6Qq3E/Ya2n3ZmOu1ULsDGT5fTGGEOWE5414wkZMo1n9xAAmNbhd16OXY/16kfftw
         qqKv4FkWIo9daU1y4VfBELCXGGa7qUcFsMcHtwEoRoQxW9VGcl8S66x3/aLtgsYDqo4L
         C1X+NaAiLfLxzoO0kGvIAedBttwl6zxIIJii3PTIyB0cN18JLFD+OwlMdx3BVn9C/AyY
         KXNOL6CDPHLrCZr26q5uOr1LqRsAamPjnaePe3HOM2t7+HZuj+l553ERGTWflr7NQUWW
         lo/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766936760; x=1767541560;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QL4j19IOrqqmuzYnZ1SxQd2ieNi3NuzYkFJwG9nk0po=;
        b=goibqjqrTvDOcdBhlthqMJ6TChRlsxIhXCU1HcEquxJwWzb14edNquwWN7YHRaGjco
         W+vez7Lr+fce1n+ZStUOAyuZUvH/9Ul7ThhOXeeuLtB/yLJK71zHWFAzz/BnNBjGTKdk
         tb5bksjqfyZcVyM7IKim1T0PKMSDKkwqQCYfRco6NQOeGMkuSv1o02s790Opkh19IQtb
         hz9idZrQoX7Z3KRkYfynTEi3Q0ImhnmR8RXDLYt+r09IEx1jeSEN51jh9FwoFl8Jg7rj
         +E9+gOe4edWGcNshX3G8DdM5f+DyXj3+mpvYOG6lHB/XUY+kn6essU9x967EGVySQp2P
         czqQ==
X-Gm-Message-State: AOJu0Yw7/lzuPdg8mALNa74tNM+NLBMSQYj1zLMIUvIuKgG0j2nuXHtr
	XDVpBl42Vl2LWHfZFBDeZcZEHTBZncwEkBZ8raeRA4WqzCCbOTR49x8DPNGRwQA3WH8=
X-Gm-Gg: AY/fxX4pIVYyPr7WeF0v2uX99r1HXNLhxs7KYd3hytnAZKlSF8SWhV5+kxEr+TQ/a6I
	tXBpS3ANqqx+JgriukY63/2R2j6YZ/bAmRrb2ZJMy3v1kSYQj8YLVB8moqYY+B8DBpc/NMRdDBM
	ryAnu2mmRBKrwbda67F0+aGOAnX/XSrovNZWqhkEOQajF5VCFzmN5qFfCWEvqzieknSGA9mFo1S
	/tqtAh7hlXHEyU/Prm5z1Lrz778B9ronPV5SRuFbXMOlycMALP28tW2zE2MjHPl5xMQ8kIEocyQ
	Ai3/UQl1YIVwgxZSTWy4YwPJ9rinwvneayLcyilUcw+3FmHIRWDh+m8r3XTmqbikMGXErEdpGp1
	/Qcu11o22+fyOqRb4DGSeL2/RaQ0TuspDKArG2oVoY+/L8lrvRDvHgmwIDbNFal2/bEJZxICtkx
	EUeXU91P4s
X-Google-Smtp-Source: AGHT+IGcxfzcltO6pnSTS55PPFijzWihLWrTkPcsukI/zVMOfd6BTNXV8M7bnuYSBkzfYvwLBvcsUQ==
X-Received: by 2002:a05:6808:2389:b0:450:d09a:8cc4 with SMTP id 5614622812f47-457b20ca09fmr11421695b6e.38.1766936759898;
        Sun, 28 Dec 2025 07:45:59 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc6673ccc2sm19134080a34.12.2025.12.28.07.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Dec 2025 07:45:58 -0800 (PST)
Message-ID: <b59640ae-97a8-4a46-88fb-e96d1ac394f9@kernel.dk>
Date: Sun, 28 Dec 2025 08:45:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
To: Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 netdev <netdev@vger.kernel.org>
Cc: io-uring <io-uring@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Julian Orth <ju.orth@gmail.com>
References: <07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk>
 <willemdebruijn.kernel.18e89ba05fbac@gmail.com>
 <fe9dbb70-c345-41b2-96d6-2788e2510886@kernel.dk>
 <willemdebruijn.kernel.1996d0172c2e@gmail.com>
 <0f83a7fb-0d1d-40d1-8281-2f6d53270895@kernel.dk>
 <3308e844-6c04-44a1-84c9-9b9f1aaef917@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3308e844-6c04-44a1-84c9-9b9f1aaef917@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/28/25 8:02 AM, Paolo Abeni wrote:
> On 12/23/25 6:27 PM, Jens Axboe wrote:
>> On 12/19/25 1:08 PM, Willem de Bruijn wrote:
>>> [PATCH net v2] assuming this is intended to go through the net tree.
>>>
>>> Jens Axboe wrote:
>>>> On 12/19/25 12:02 PM, Willem de Bruijn wrote:
>>>>> Jens Axboe wrote:
>>>>>> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but it
>>>>>> posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
>>>>>> incorrect, as ->msg_get_inq is just the caller asking for the remainder
>>>>>> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
>>>>>> original commit states that this is done to make sockets
>>>>>> io_uring-friendly", but it's actually incorrect as io_uring doesn't use
>>>>>> cmsg headers internally at all, and it's actively wrong as this means
>>>>>> that cmsg's are always posted if someone does recvmsg via io_uring.
>>>>>>
>>>>>> Fix that up by only posting a cmsg if u->recvmsg_inq is set.
>>>>>>
>>>>>> Additionally, mirror how TCP handles inquiry handling in that it should
>>>>>> only be done for a successful return. This makes the logic for the two
>>>>>> identical.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
>>>>>> Reported-by: Julian Orth <ju.orth@gmail.com>
>>>>>> Link: https://github.com/axboe/liburing/issues/1509
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>
>>>>>> ---
>>>>>>
>>>>>> V2:
>>>>>> - Unify logic with tcp
>>>>>> - Squash the two patches into one
>>>>>>
>>>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>>>> index 55cdebfa0da0..a7ca74653d94 100644
>>>>>> --- a/net/unix/af_unix.c
>>>>>> +++ b/net/unix/af_unix.c
>>>>>> @@ -2904,6 +2904,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>>>>>  	unsigned int last_len;
>>>>>>  	struct unix_sock *u;
>>>>>>  	int copied = 0;
>>>>>> +	bool do_cmsg;
>>>>>>  	int err = 0;
>>>>>>  	long timeo;
>>>>>>  	int target;
>>>>>> @@ -2929,6 +2930,9 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>>>>>  
>>>>>>  	u = unix_sk(sk);
>>>>>>  
>>>>>> +	do_cmsg = READ_ONCE(u->recvmsg_inq);
>>>>>> +	if (do_cmsg)
>>>>>> +		msg->msg_get_inq = 1;
>>>>>
>>>>> I would avoid overwriting user written fields if it's easy to do so.
>>>>>
>>>>> In this case it probably is harmless. But we've learned the hard way
>>>>> that applications can even get confused by recvmsg setting msg_flags.
>>>>> I've seen multiple reports of applications failing to scrub that field
>>>>> inbetween calls.
>>>>>
>>>>> Also just more similar to tcp:
>>>>>
>>>>>        do_cmsg = READ_ONCE(u->recvmsg_inq);
>>>>>        if ((do_cmsg || msg->msg_get_inq) && (copied ?: err) >= 0) {
>>>>
>>>> I think you need to look closer, because this is actually what the tcp
>>>> path does:
>>>>
>>>> if (tp->recvmsg_inq) {
>>>> 	[...]
>>>> 	msg->msg_get_inq = 1;
>>>> }
>>>
>>> I indeed missed that TCP does the same. Ack. Indeed consistency was what I asked for.
>>>
>>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>>
>> Can someone get this applied, please?
> 
> For a few more days it's just me. That means a significantly longer than
> usual latency, but I'm almost there.

Thanks Paolo!

-- 
Jens Axboe

