Return-Path: <io-uring+bounces-6601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EEF9A3F8E0
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0956E864430
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 15:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA0121171D;
	Fri, 21 Feb 2025 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fR9/Oyoi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DCF212B07;
	Fri, 21 Feb 2025 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740151649; cv=none; b=ORk+50aK8IwKc8gM3fO7WAYJ7MZUv1VC1FVaba9hYQLUG4JEDwQx7UHbp1fzOYVTBSPTQXW9cwMjVBD0/7EgA2eDq8FCxyLqKdqGF1WpqYpnAt1H2BHnrEqZY1Eg6BSBxzQlsbiRmv56YGTqUGQI9VRtbiSZNBdGRGkQzFvhQn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740151649; c=relaxed/simple;
	bh=5yxGsMRYTXuIQYRwb+D3swc/pR+GWOkx1HET+lS/Qcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YJD6WRDir83QjAYRabXWP+coes6OVGJdh3RG2r3G1YUJJ3TemO7uTmVZTugRkM7Snu0K8hU5L109XQyHELTqaC8eCyrMHZfCCBXNrKXxBcVI2Gj7WZrR2OD2WkyQwE0djoxiRPBlezjjUMw1/ydoXZInb2Z+A6+WR+iTtLUlS5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fR9/Oyoi; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38f3913569fso2018412f8f.1;
        Fri, 21 Feb 2025 07:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740151646; x=1740756446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4lCZ8MAj4Q/VEcZka8A73ItGpOE2Ji1aovZAZl6qhTA=;
        b=fR9/Oyoi2UYmu7jZrGS/5a2/hT+hEOpRshRP+gYkEiS8EzdD6kGfRHtnM2Pcc3JtMJ
         Jxizi8rUtX3Zf1ZC/dVnbs89Gd5oAVFuGnDh1C01hQiARjD8LHy+T8FGUnQ5J7oQmZJ+
         SCPi64NKQ9rLBrz24o3fOEmfGzJ3hs/6o2V6CPSn8qQd8q5VOXczPij382vhm8eLpzvx
         w+5TMTdUKeGZ0tK1bq1O/7u06tLG9MF16KQyBcU7tTrlyvREEjf2vM2lZlimxzRNTsDE
         XzvkikiN80HpQr1y/XFarDP4BeyzO5+QqeHDj/ST9+Sb/5lcwAIpGSNX6upkA04ju7Vo
         NhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740151646; x=1740756446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4lCZ8MAj4Q/VEcZka8A73ItGpOE2Ji1aovZAZl6qhTA=;
        b=FMeHG7qhad+rlONxiWhCQTJBnj//aPf0+kgpGdbgyeH8BDARDyHU0KC/k2BmgaT1tw
         /GUtwNWiA+MePoS/Mz0TqP1QgXboGMwDRGuTZ6dPJbNxSB2cOBQIaBNxfFaCvs4w+LWE
         /QGoMVWCanVXpmYbwtBWbRh8pphVoknDJcBp7c/oPuIpCYWFk0wX3ADdeep0Ub1W3p8f
         Sn08qvbDyrrq17mNt7jnFeCSOMPuI9W0ARZcXIxjZw4wRmgW+olw6uEWtlk0/bZ0wAT/
         nFXJnV5OpEGbyWa0XWcwc+dlt1bU8niHxNJsemBkKUPqNorhsB/OyTfH6O2D22xUEm9h
         2M2w==
X-Forwarded-Encrypted: i=1; AJvYcCVjNhFKb74FkNl4d2EZQAsCA+Jql5QdzHeK72F4JtqbEnGYr4a/ZCST7ZKxBvOJ81ph3sMz6n7X/06Nna54@vger.kernel.org, AJvYcCXdHACOcv8gY/YtjldUtZZZUBpaG+nR7v58HG7MzgnAOGtJmw+HGVhMwVg6gkH7jKS2bFC02epUVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoL8104NqDImGu2W5l8NQgCvCe+KOFV1aRHVVRrHMSGrpAmOVK
	lQOMhaCP1T4JuLhhopKh6QsGO6rJ9w3lFSF9odEi2XefUl2TpCu7JWjcyg==
X-Gm-Gg: ASbGnct0JlxnBW2w2Rv1dHUyH4RYmfuX+QhLYC2YQnQaR/ti3GFpQDDG/UGoUsAtGuO
	KNcfDIbrfu3vFkpbV/8vF2+d0oOIMM1rxtWYOl3BmyqO7Tpb+2/U8sqp4lSOwcLP07BIf15EV3d
	9wWMTb9bAlNbGxsCMZ0enQtmZ0DcC9XNoxEcJNpkf0GYNEZ64SrW5TGYFEQmQyzUjt0if+aStBR
	6Q/bTZQt0kFidgAW/ToA3ih4Q7L8g1q/4mV60nxKYaWFJXEj9PFR9i2cOV63b8kritwZhx3VNht
	sBBTLzRaA4SLZqkLKpEVx1j56UfmJDlTcWwa
X-Google-Smtp-Source: AGHT+IGD/aMM2q3Rt2CDkJPFyBfFg5d7nPBarKdfXefG+hE2yGfdQ1oLqoKGdgaTbF12wddYzIBM6Q==
X-Received: by 2002:a05:6000:1862:b0:38d:b349:2db2 with SMTP id ffacd0b85a97d-38f6f515313mr2830130f8f.22.1740151645193;
        Fri, 21 Feb 2025 07:27:25 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258ccd3bsm23702128f8f.22.2025.02.21.07.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 07:27:24 -0800 (PST)
Message-ID: <b4e6ef48-6b3e-4b62-978c-6e80d3e9218e@gmail.com>
Date: Fri, 21 Feb 2025 15:28:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring/io-wq: try to batch multiple free work
To: Bui Quang Minh <minhquangbui99@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20250221041927.8470-1-minhquangbui99@gmail.com>
 <20250221041927.8470-3-minhquangbui99@gmail.com>
 <f34a5715-fae0-406e-a27b-7e94e3113641@gmail.com>
 <e4be0a96-8e09-4591-96fe-a1d38208875a@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e4be0a96-8e09-4591-96fe-a1d38208875a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/21/25 14:52, Bui Quang Minh wrote:
> On 2/21/25 19:44, Pavel Begunkov wrote:
>> On 2/21/25 04:19, Bui Quang Minh wrote:
>>> Currently, in case we don't use IORING_SETUP_DEFER_TASKRUN, when io
>>> worker frees work, it needs to add a task work. This creates contention
>>> on tctx->task_list. With this commit, io work queues free work on a
>>> local list and batch multiple free work in one call when the number of
>>> free work in local list exceeds IO_REQ_ALLOC_BATCH.
>>
>> I see no relation to IO_REQ_ALLOC_BATCH, that should be
>> a separate macro.
>>
>>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>>> ---
>>>   io_uring/io-wq.c    | 62 +++++++++++++++++++++++++++++++++++++++++++--
>>>   io_uring/io-wq.h    |  4 ++-
>>>   io_uring/io_uring.c | 23 ++++++++++++++---
>>>   io_uring/io_uring.h |  6 ++++-
>>>   4 files changed, 87 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
>>> index 5d0928f37471..096711707db9 100644
>>> --- a/io_uring/io-wq.c
>>> +++ b/io_uring/io-wq.c
>> ...
>>> @@ -601,7 +622,41 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
>>>               wq->do_work(work);
>>>               io_assign_current_work(worker, NULL);
>>>   -            linked = wq->free_work(work);
>>> +            /*
>>> +             * All requests in free list must have the same
>>> +             * io_ring_ctx.
>>> +             */
>>> +            if (last_added_ctx && last_added_ctx != req->ctx) {
>>> +                flush_req_free_list(&free_list, tail);
>>> +                tail = NULL;
>>> +                last_added_ctx = NULL;
>>> +                free_req = 0;
>>> +            }
>>> +
>>> +            /*
>>> +             * Try to batch free work when
>>> +             * !IORING_SETUP_DEFER_TASKRUN to reduce contention
>>> +             * on tctx->task_list.
>>> +             */
>>> +            if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>> +                linked = wq->free_work(work, NULL, NULL);
>>> +            else
>>> +                linked = wq->free_work(work, &free_list, &did_free);
>>
>> The problem here is that iowq is blocking and hence you lock up resources
>> of already completed request for who knows how long. In case of unbound
>> requests (see IO_WQ_ACCT_UNBOUND) it's indefinite, and it's absolutely
>> cannot be used without some kind of a timer. But even in case of bound
>> work, it can be pretty long.
> That's a good point, I've overlooked the fact that work handler might block indefinitely.
>> Maybe, for bound requests it can target N like here, but read jiffies
>> in between each request and flush if it has been too long. So in worst
>> case the total delay is the last req execution time + DT. But even then
>> it feels wrong, especially with filesystems sometimes not even
>> honouring NOWAIT.
>>
>> The question is, why do you force it into the worker pool with the
>> IOSQE_ASYNC flag? It's generally not recommended, and the name of the
>> flag is confusing as it should've been more like "WORKER_OFFLOAD".
> 
> 
> I launched more workers to parallel the work handler, but as you said, it seems like an incorrect use case.

Not as much incorrect as generally inefficient and not recommended,
especially not recommended before trying it without the flag. People
often fall into the trap of "Oh, it's _async_, surely I have to set it",
really unfortunate naming.

> However, I think the request free seems heavy, we need to create a task work so that we can hold the uring_lock to queue the request to ctx->submit_state->compl_reqs. Let me play around more to see if I can find an optimization for this.

That's because it's a slow fallback path for cases that can't do
async for one reason or another, and ideally we wouldn't have it
at all. In reality it's used more than I'd wish for, but it's
still a path we don't heavily optimise.

Btw, if you're really spamming iowq threads, I'm surprised that's
the only hotspot you have. There should be some contention for
CQE posting (->completion_lock), and probably in the iowq queue
locking, and so on.

-- 
Pavel Begunkov


