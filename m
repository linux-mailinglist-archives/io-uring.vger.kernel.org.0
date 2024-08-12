Return-Path: <io-uring+bounces-2716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A0194F657
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 493851C221CF
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C60189B8E;
	Mon, 12 Aug 2024 18:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="asZeWG1g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCDD189B89
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 18:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723486290; cv=none; b=sqGVNVRO9zVNTJDQYPQFbNCnpWFPkdTxIITwrErGzzxQZZj4SNvOtS2Cug6is+/Fmuod59dhVW2UDiXQmKhMvGEoRw6cV2w96nSXvS5VzR4oL2Zs9+jr2ttElRM8AjUxri7b7PVgtgMEuRqhtYGWdwRkBLmqGfqbJNAQif+E9CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723486290; c=relaxed/simple;
	bh=920ohsyJfpMwMKf3pkr88GtXX8oJXmaE7Q1VD3CHtd0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=SnJa9S9AJudEFSk95t9XlVIKnAXNu48JoE0QucinbVfI7Cpavat4NC1zKvgztr3ql/L32yAK0aiSODBY0Ca5+Ua451lfBO08D8sTitiB7ur2k/SV7Q8TJIVtze/FCF4zP/VvJNaURH13ITjbpy6N3/EWZJ7HZK23FrxMU1twkSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=asZeWG1g; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2cdae2bc04dso884423a91.0
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 11:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723486287; x=1724091087; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahZwHebNKFSNEQH29+jaFvx3Arb1VckxPjCemYImpoQ=;
        b=asZeWG1gu6gcWKCNnS69wPtTqOYx1Ka5RUKDM8vfAzOpEXPKJCXhJoAJnMH7uSjT1T
         HNn3pVIY8GKTxv1/G/LX12UmxnDY+4Fro1IMo8WTAnlW642hqlEBefdIQO2AaboMQ0uD
         QkdgUIcsAOhNol+A4pnEB7VEhizy0zAa4eKEhALyYQ7SZCTOOWYBHWUKXco2bTsJkT2u
         5ZMZCLuuu373BvSLTl8TQ+qpP/iXxkwKOjAYdwB2+x88i9nh7W03NHs4L0HmZfyALfmW
         QieBcehhfgTBA2Ewa/3pwmERRHiGpPGavUH6kmNfGuQD2eRwQEV8u+5dZI1iedZDTr9F
         fD6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723486287; x=1724091087;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ahZwHebNKFSNEQH29+jaFvx3Arb1VckxPjCemYImpoQ=;
        b=BoXyTUebO0TNiKlNIKfesLgrStyiNKSjnn5AqocDDmEBlSGXN+AbXFLXPTft//r/wW
         Mu/gQ3G1PTtP2NzDOfYoRxQ4mi+iRNFrAoxBjIpFBsCmY50CPxxlAJoaIubLV/kO//II
         2DIXynId1hvjL0iCacS3y5YDSqYimmstSk21Ok2hk/NDSioqduuaCy/PZ7S32TXbqs9B
         xlLvWwj8bKPUviLrDDgo7ul4QeZ+QOSlaPv0V2RnbAW5kZpT49sgsipjJ8IMPL3AxcbS
         s+doZl1wbyl+fG0rxRLVi8KQXGFimuTpvL4tMdbBvF46dzlAGNsPvdUF8+v7CJZ3KRIp
         WaWg==
X-Forwarded-Encrypted: i=1; AJvYcCXn+e7hXT32FpCdz65TSai5YUPstY8GtFv/oo/VQvsxsOm0s5SbI1xql3D/kAV5700j4XUxDhxpyJIidkhv2KWNpZGqprZWV/k=
X-Gm-Message-State: AOJu0YyBo/MEjBJc2Ui6tRKBIEoW/HFRt5LjnbnQaF9mBOc/VjOBdhuO
	8N/XF1+OZgNRBYp0H4hkaD3Ffift0p2ZMjBNYtchE4NehtSmWdUXoV4FsIvNAys=
X-Google-Smtp-Source: AGHT+IGvm6fCFxJa98rggqT59rvJ43gmJb2qVZAh5W8gBTakxAL/V/vSHUHZA4bf4h4llekUA94YEw==
X-Received: by 2002:a17:90b:5202:b0:2cd:8fcd:8479 with SMTP id 98e67ed59e1d1-2d3926b863dmr679574a91.4.1723486287241;
        Mon, 12 Aug 2024 11:11:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3931f1255sm400119a91.53.2024.08.12.11.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 11:11:26 -0700 (PDT)
Message-ID: <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
Date: Mon, 12 Aug 2024 12:11:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
From: Jens Axboe <axboe@kernel.dk>
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
Content-Language: en-US
In-Reply-To: <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/24 12:10 PM, Jens Axboe wrote:
> On 8/11/24 7:00 PM, Olivier Langlois wrote:
>> On Sun, 2024-08-11 at 20:34 -0400, Olivier Langlois wrote:
>>> io_napi_entry() has 2 calling sites. One of them is unlikely to find
>>> an
>>> entry and if it does, the timeout should arguable not be updated.
>>>
>>> The other io_napi_entry() calling site is overwriting the update made
>>> by io_napi_entry() so the io_napi_entry() timeout value update has no
>>> or
>>> little value and therefore is removed.
>>>
>>> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
>>> ---
>>>  io_uring/napi.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/io_uring/napi.c b/io_uring/napi.c
>>> index 73c4159e8405..1de1d4d62925 100644
>>> --- a/io_uring/napi.c
>>> +++ b/io_uring/napi.c
>>> @@ -26,7 +26,6 @@ static struct io_napi_entry
>>> *io_napi_hash_find(struct hlist_head *hash_list,
>>>  	hlist_for_each_entry_rcu(e, hash_list, node) {
>>>  		if (e->napi_id != napi_id)
>>>  			continue;
>>> -		e->timeout = jiffies + NAPI_TIMEOUT;
>>>  		return e;
>>>  	}
>>>  
>> I am commenting my own patch because I found something curious that I
>> was not sure about when I was reviewing the code.
>>
>> Should the remaining e->timeout assignation be wrapped with a
>> WRITE_ONCE() macro to ensure an atomic store?
> 
> I think that makes sense to do as lookup can be within rcu, and
> hence we have nothing serializing it. Not for torn writes, but to
> ensure that the memory sanitizer doesn't complain. I can just make
> this change while applying, or send a v2.

As a separate patch I mean, not a v2. That part can wait until 6.12.

-- 
Jens Axboe


