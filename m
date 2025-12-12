Return-Path: <io-uring+bounces-11029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C03CB9BA5
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 21:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 515B8300BB91
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 20:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E77F293C4E;
	Fri, 12 Dec 2025 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a8efRgrn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4AA245019
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765570185; cv=none; b=Jwgz8zTIVDYyZ3zaUooW2ncDUbHLZn4wH2BH6wSXri2nWckVYPIgDGnHZZVW++0w2HiviH95qaN1F23nJy6wrLva+8poddtPRP1STsQQlcXQlK7bhxxryQ9/3H52aa61WoirPLn+BTA0mPYyAnB8sxa9xaITNiU1cvoeTXzl2j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765570185; c=relaxed/simple;
	bh=x73/8xqefFdQdI8l6SLgDkcTgNIkcQcDre0wdajWwig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dKuZ6AZP9q3ZRHvN554GCwnqA2Xiwqrh4QQpjXC6gmZjBDgS+dVZ//goBEm4wR1QpLul+MFnkp3r0b9+U+myfWA8p72LRpcn71tdLxdJu6aQRLxMUG4182Cn2kAJDjD9w5OaiuSs6fyEtGUIoQbTs4y/J6mehcmxnW3/eOC0QJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a8efRgrn; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7ade456b6abso1294124b3a.3
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 12:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765570181; x=1766174981; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s6Bo0y8Sr/LwIs+a8Xvg5LPNcB5BaXQGC5+64MLSaH4=;
        b=a8efRgrnHVU9eUITWr+ycQC0LV2rrKnGgq+j4VR5tnKKCPo6XY+TawhO1AaHRzA9du
         PrIvc/17grbkooAmPYYohTJRQ8EycElDer+8BSfPvB/dvKm4YwseqvcoXdCk4q4dnitG
         5yNlWMjF3DBxCQiwNtOYFOdEkwDN7Aupmlrc7zU8ZpN/7O2uzIWXEFlmGaYh8S2hPv9q
         rbnlM9g5s2QAqfABw6j7XMmHQZjjnxJCyI3v23gBGuz8rnPd/SChjcuvedspIfu9K2My
         fkrp5yrf7qRm89MSR0UPTquThFfgb8UMjcKN26iqiuF/UQwOAuGUfRLSApi6UW+J47Oe
         DbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765570181; x=1766174981;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s6Bo0y8Sr/LwIs+a8Xvg5LPNcB5BaXQGC5+64MLSaH4=;
        b=FYYxbDfn9BA2k3H0E/nQNIVw9ebnzSbz1n4x5n5P1curo7UBdHH/UZXKoY0cn/hCB5
         pN7Lq65xzbILfnd0lG57dm/gsa3240QfK7JppG2BGfTpGAImXjMrp0H7mEU8cA2clhiD
         BeUHhTimMiUdBDWdBU6v/kgCTpYpnS81rxFt7njD9o5MDfcxy0IZTJaF3qWDpTagaO6O
         DaiQ63QITRkwac+PzO3qyoaXbmyeUxifJn6oJl2q+cehfVdfIKvC2atb6KhmomGN+rhN
         x6uC9gVZMKw8lgYkNl/LzEdQ6Ewq04DqEuTDN4QcLpDwVmy60Lo6IrdV4lUa9ntY6tvj
         u1aQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2CqPdJFj/5v8MgY+0RktMHd/Yrc4EQrjCK86OCCCBKFOtMYFLCPJLg8GRIaHDHegk55M8ozYEqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnhpis53ETp6h8f5BhayDwQj7rRsNSWS7fXHe83cI1S2r1/iyc
	3xH5l5IFMwu6LbNzyQEu6JpLcbLISB93s5l3KyN4ahyQAP5Z0qdgSm7opNJItGAfLO0=
X-Gm-Gg: AY/fxX6fCQX/geeKZopqUHK/AcqUNoMUK6y3kHSn6l94dwZ2aSKMEeAY5g8SQEeoWQ8
	nfuL9CkyEDBLc7Xt1t7bt04KAvloNQAbqmEsGhTV8EJFBRDyvMGALtn+edPH/79fWl0M2RqYgD1
	DGUevO0X2BqsbgtMrW4IsDAlpd9JmyV6isp2+g7bsmpLLlcHyNA4AUDlHwMpuA7091TBq6Bj6e+
	fdQFiR1BheL4DueuWFZi+wtQpLYoqwt+YdlJWg9zcc9A5ccm9oNWQi4Vn6e5z5fvU4U8M+vKm2k
	pDnjcCzSVXMQGMoavNx9I4RIZcheyDcjS2tWOU3VRrCZaVPqX0BP8A59hM66SkAVHqZ/o14G8w3
	u+FIkWkJROD40lgYiKOBqcFvGI2SetMndNX/qj1TUSP73bKe6xdqD3ldPvzBDgMx1cZSmIqkG7+
	k9Js/5bBBMRe/9knLdz9ywkFeAYas7Dvi2HA7C30r4WdRhYt0/AsSp/wTt9L55
X-Google-Smtp-Source: AGHT+IH90j3m+YQyWuLBpr7tqE4XFupOl56Z5xJ7Q5NCIiB8WMpiyLFsjWc2jqnJT3tXrWI5Q70cFQ==
X-Received: by 2002:a05:6a00:3689:b0:7ab:995a:46b0 with SMTP id d2e1a72fcca58-7f667c20e69mr3050467b3a.15.1765570180911;
        Fri, 12 Dec 2025 12:09:40 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c22842e5sm6037858b3a.7.2025.12.12.12.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 12:09:40 -0800 (PST)
Message-ID: <95358f2c-d739-4dc1-b423-6ac3cbd96225@kernel.dk>
Date: Fri, 12 Dec 2025 13:09:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Diangang Li <lidiangang@bytedance.com>,
 Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
 <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
 <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com>
 <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
 <b640d708-6270-4946-916d-350d323f1678@bytedance.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <b640d708-6270-4946-916d-350d323f1678@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/25 6:32 AM, Diangang Li wrote:
>> @@ -1327,17 +1326,12 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>>   	if (ctx->poll_multi_queue || force_nonspin)
>>   		poll_flags |= BLK_POLL_ONESHOT;
>>   
>> +	/*
>> +	 * Loop over uncompleted polled IO requests, and poll for them.
>> +	 */
>>   	list_for_each_entry(req, &ctx->iopoll_list, iopoll_node) {
>>   		int ret;
>>   
>> -		/*
>> -		 * Move completed and retryable entries to our local lists.
>> -		 * If we find a request that requires polling, break out
>> -		 * and complete those lists first, if we have entries there.
>> -		 */
>> -		if (READ_ONCE(req->iopoll_completed))
>> -			break;
> 
> Suggest keeping iopoll_completed here to avoid unnecessary subsequent 
> polling and to process IRQ-completed requests promptly.

There should not be any IRQ completed requests in here. The block layer
used to allow that, but that should no longer be the case. If it's a
polled request, then it will by definition end up in a polled queue and
need iopoll completion. Or it'll sit for a while and be completed by a
timeout. If someone is still allowing polled IO with IRQ completions
then that should be fixed, and there's no reason why we should try and
catch those cases here. Will not happen with NVMe, for example.

For the other point, there's no way for ->iopoll_completed to be set
before iob.complete(&iob) has been called to invoke the callback, which
in turn sets it. Hence there's no way for us to end up in this loop and
have ->iopoll_completed set.

So no, I don't think we need it, and honestly it wasn't even really
needed the posted changes either.

-- 
Jens Axboe

