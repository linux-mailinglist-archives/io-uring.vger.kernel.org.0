Return-Path: <io-uring+bounces-7350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3656A781FB
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 20:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 076221886192
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 18:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B20204866;
	Tue,  1 Apr 2025 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n4qeR0lZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B1879FE
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743531274; cv=none; b=pPI6GQiSW+Wxxci+ArIJUnlLS1JEfEWhOcCpvBxlMrXdG/2PKbKMrozxl1gxm5zRae1R9mpimy/02h3ADLZ0wUiv24ww+bDP+LoK9gVcSFFyD3BcpTVw9SLzXtCt+ATes+y6kzI0tDTMRoA7pB6X0W3YUPo6rD8DKj+eW+UDVB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743531274; c=relaxed/simple;
	bh=xYpVgdcsyMYOD1Dsm18WJUQGwdwy6cGG5Ne780npYuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rHBAzBVpVXatHQDTp+SZhiRD3YiNgA6Es4TaogVgstolhQxeF35Aj2z0Dw1crcdaUO8Yp6ND+ZV/UzS7wl1dbpu07Vc+p50jShQzSyspz83MUffRYacfKMAyBHqCo2ZxLY/ArDdzoR/7bR0ahWkGYIZo+Sp6E+i/VEevonQ8Alg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n4qeR0lZ; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-855bd88ee2cso142334739f.0
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 11:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743531270; x=1744136070; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fonokh/0ABfvfnHXaLv8dh+58LI8H/4f3BoLGexAcow=;
        b=n4qeR0lZCTd98A8m3Rc/6fI2L8dGAVZzfNaUp8uSS4nR5E7SXuO4L9AWP0EL+uR8wf
         rhjIlPgFBPovOL6ZBUlHl1h9+KSusrZPOp/TFU6aC46dGqPWTi66UqVG6LvBtw5EMQ7M
         kZSYml9mq8Bcu0T7+vYQSIptBR7GMZMPwlLfYMujOy2AmsvttN2o+bH+YJaSL7+IgXUJ
         o7Y+06NX7xkGBtVJ+DsL7C5a7A8jLeSf9haBzVY6HeDWmAW5Vns/Y68DvHOT7L+cqQ2t
         GtpVL30ikfCfN35vNY4opLbRHT5dLMYv6aFldzFYQ0k9/cSIedyWMzsIZiNkL888FA1u
         VN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743531270; x=1744136070;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fonokh/0ABfvfnHXaLv8dh+58LI8H/4f3BoLGexAcow=;
        b=qkLwulM2na0BSpWmmKadw+/ZVxNJ8Z4PBOMlFSsmn8oSLzRxA4r7jicAj0/B0s2aLb
         UsDSxwricYGZvEE71qz6Pf3X5amD4RLfuxgTwZpSv1v5HhhuhE3IHULXE9uXX1q5sKu0
         j+WMwmc5ZgwlvtCndoTEcnl35IH66yN/HsixHJCSdyUrRc/lhsvJVEKmWdu0wEwx4w9a
         wKIoW0QDAJO7bQEVbEcwB3003jStarQnnBKQHRmdJk0wNeE9g30VjNStpKa6vabmb2IO
         gHKHwCs+ylg3w04CEiGJhIErlnUUaWGRIAjGUrlSR4dyXUQx/hdI75kkvFC8ljbg78WQ
         hjFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVthRTSiM8YJ2pzP/bj+PBdHJhLPMWMmKqwSp+wc8u9blpi1hDDJMHF0GOSmOReZq34uKawXBGHTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbHI0pa74kfv9nUWNjkMmR6WqmpPXZAnd1sg5047UHNKoeIw4t
	Ujh57njHG4M4+H2tr89t2irzTyvA/ZMbxCRvWBgr3Z5O+qGoSci7OiD3+hUTWtE=
X-Gm-Gg: ASbGncuNAYuXmmRoUrrs85HRvlwDpDoH/yU8szkDHBUDCvRUyDcadYgiDghlY1J/tFp
	zXCDzkuy1ABkf3mP8ONtUF4eEctkOwGddb6trjWTrK9/LfY7euJzx4sx8u+9C4kN/+g+p29tkIW
	LlDKSyQrnMGzY3pEkgdcz80GG4azxzoVlnz+W6b6qNJh6hjVpb8SS66bvknRJCf+zAH0JYQrl0d
	iOU6ksQAkGQAD5W0HwYKYzEhxGza0ATpXL0Uigjb1MVY2PxsKYbOnCPnq/PPXHmogE6lGKonp+Q
	C2xSA0+OZW7wieG9iA7z1nQbJunlibjHJ92P07/9mg==
X-Google-Smtp-Source: AGHT+IG9cWd40eYag9etepC94UwUu1CBaEqfBSh2evYsn624sqlSTYOn44rKBaWs5mf+0w1cQ0UcoQ==
X-Received: by 2002:a05:6602:3605:b0:85b:37eb:f466 with SMTP id ca18e2360f4ac-85e9e847deemr1522014639f.1.1743531270030;
        Tue, 01 Apr 2025 11:14:30 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4648cb539sm2469435173.135.2025.04.01.11.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 11:14:29 -0700 (PDT)
Message-ID: <827b11ed-2fb3-40ae-a266-17080fa751be@kernel.dk>
Date: Tue, 1 Apr 2025 12:14:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: add lockdep checks for io_handle_tw_list
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ffd30102aee729e48911f595d1c05804e59b0403.1743522348.git.asml.silence@gmail.com>
 <65765d68-cda0-41fb-acdf-58e7b5c1243f@kernel.dk>
 <b0d73d31-ae08-48f8-a4a9-30f6ad0f1e6b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b0d73d31-ae08-48f8-a4a9-30f6ad0f1e6b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/25 11:19 AM, Pavel Begunkov wrote:
> On 4/1/25 17:13, Jens Axboe wrote:
>> On 4/1/25 9:46 AM, Pavel Begunkov wrote:
>>> Add a lockdep check to io_handle_tw_list() verifying that the context is
>>> locked and no task work drops it by accident.
>>
>> I think we'd want a bit more of a "why" explanation here, but I can add
>> that while committing.
>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 6df996d01ccf..13e0b48d1aac 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -1054,6 +1054,10 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
>>>               mutex_lock(&ctx->uring_lock);
>>>               percpu_ref_get(&ctx->refs);
>>>           }
>>> +
>>> +        lockdep_assert(req->ctx == ctx);
>>> +        lockdep_assert_held(&ctx->uring_lock);
>>> +
>>>           INDIRECT_CALL_2(req->io_task_work.func,
>>>                   io_poll_task_func, io_req_rw_complete,
>>>                   req, ts);
>>
>> If the assumption is that some previous tw messed things up, might not
>> be a bad idea to include dumping of that if one of the above lockdep
>> asserts fail? Preferably in such a way that code generation is the same
>> when lockdep isn't set...
> 
> We can move it after the tw run where it still has the request
> (but doesn't own it).

Yep let's do that, but it'd still be nice to dump what func is if it
ends up triggering.

-- 
Jens Axboe

