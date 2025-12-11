Return-Path: <io-uring+bounces-11012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A482CB59CD
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 12:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E8CD7300118A
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 11:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF4120C463;
	Thu, 11 Dec 2025 11:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dm2R+g0z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5751FDA
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 11:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765451630; cv=none; b=VQuIY793V6VX6+ZIK2Oded9nWRM38rGyCLMlgDa46/6zXaV5jq+XqsN31ldYu6cXu4P2ecjTIaeeFCe3bAxjwxEAZ1ud9pMzic4P9cWXp2oTRnbrVW7vxAYoCcDqN9K3RJ+lPNRQAdf7N2e7p62WQ94zPNZi3EfpoD6uq4XSS9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765451630; c=relaxed/simple;
	bh=fasKx73HCsgUOkjdFfRHo0oH4Zt/FDmkk6t+OKZIQNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tIYy1M1XcW96OjL9NSI6C/7/zzTT4yvEKIMmLObibRX0Mk9AG4a6ilkWlkbssWjg3oRTMtRhs3218wduRUDmIw/uYFcWasXZHdkviGQzU/VfbwievmykWF1KfxSMDv4p0IKDAuL4XKBDgMIprAVVnNVFr7kJLV3nmk99odaRfzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dm2R+g0z; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-340c39ee02dso697755a91.1
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 03:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765451627; x=1766056427; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2dggoB44XMrJKtOKgZCjO20e7v+C+m2RlGLlHtW+7Q=;
        b=Dm2R+g0z+feu+Rik/UJpdjgXq2dHRQLjfyGKrPvnOq349pVmyFcXToRP0yyqWkFLva
         j5dZbTwSOulHnz7EIvfKzPQxgHNslzbNb3vLyoxnkcpO8MT7sS80Zwc/JC624Jx2JyWb
         ENobmOMraSiAM8s6JhNkNfwy8WL5hU3H7HyTk4chmGZqgQBI89MoxZ7heR4UArGeS6CO
         3AW45S/ZQOAmZZpgiUonrrMJZg5extwgjlSK7H94k53On5mhDgcUMf0Hjd3ZUpfh9YBn
         pNrUHFqkTeoCayrCt6FDaaBP5eGjq4n+N/yXOQyk6Axl6EGeVyD8dmdBjhGzRUK73fIW
         P7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765451627; x=1766056427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o2dggoB44XMrJKtOKgZCjO20e7v+C+m2RlGLlHtW+7Q=;
        b=GPsuUovhkkyDepfBmI1MT/p/VmXPXh8/J5vw6XqoMjXBvgLQ1EV5+59cpeImLkRs7k
         3adtErDEsIYMco2meN3ZyRX4ORw144mQ4py+FNZOrlDA2hpg9ic5G1f0xFcXmalTHkOz
         wjJKNXkfv5FYIp6TUI7uKG/2r4Wm6cH76tSnDvO9Uirz1YjDV+eRPM7tKfVivv3x8Nts
         /qxH12PNOyljtXn/EZfWgs/dIOuIUCm9/5aqUL6cz3WQZj2v145/asDeWmFi6mX5fvXN
         +BVxXkzmW68Fa7D3l9IRifMEGyWrEgXmB+/oIbjHG80kHcWfDF5cUDX5IsC83QU7lrlg
         xM9w==
X-Forwarded-Encrypted: i=1; AJvYcCWERvnNzKysomF0yzXIjv+pCHItXEkBgY2O4Tc/hYpKm6k23y5c71VuqKFtB9S+9ZdClDCRANuGGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnY3oOhqESdCpujK8RtoP679Yz19QEBK58VtcPE5lUpDCjVw5D
	DigqmaQxHNl3/uRaOk9Y16EjO4t68RSiqm2qOzpLvUbZKYUP8JaYZ3Ln+UhVm5YU
X-Gm-Gg: AY/fxX7JD68yWF0kQU0aUBnGgQq4jh69x7BOEteo109DcloHZxI4JaK4WbLQmsd0HWY
	m4LLhKcsur3gOB4rHxRbme3yiL2Fgu8tpzGNvKjLKWv3Wh6AYKUV4A63jCawxpE/3DrC4afKrQL
	dvWc0Wuh7Uf8H2I9MdZJFLDSMEXlDqaXXfu8NvMt98F+3xftnH/vDeMKd+GtwaF4l5rx4qzAJ2z
	JnmX7dEoKqATnLDOjVTg6Sl0d6K8IOrXoOrAJxCkRONBeWeyS7vz60oVsxRnQOL2EzudPDB/CDW
	qRNFotlXLl2AQ2Z10RuZaM9nQ/31zCEdfOiQMnm+nhTJvbUbaujFf/P1dsviWDDJCYsxoP1o2HN
	1Jxg1Lnd3i/TQ5u4CqZU9vMJ9AUeGkNnyeffOISw1MeGr/oLLQ40X1xtebOxO5kssiTbGWw85lz
	c+S0KeW2AhZXNz05NGy3PjMuJBd8NT/LKwYNNJxUnvcuI=
X-Google-Smtp-Source: AGHT+IHlXo9VHbA4b7rur0WyXgMU+pPImfHCf0NPnfMF4CpW0PjO5+Az8jbS4VEDGvV0TrOYNl9pkg==
X-Received: by 2002:a05:6a20:2451:b0:366:14ac:e1fe with SMTP id adf61e73a8af0-366e33cd686mr5593993637.80.1765451627353;
        Thu, 11 Dec 2025 03:13:47 -0800 (PST)
Received: from [10.254.159.240] ([139.177.225.246])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c26515d4bsm2097656a12.9.2025.12.11.03.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 03:13:47 -0800 (PST)
Message-ID: <9a63350f-b599-4f00-8d0b-4da2dbe99fc2@gmail.com>
Date: Thu, 11 Dec 2025 19:13:42 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
From: Fengnan Chang <fengnanchang@gmail.com>
In-Reply-To: <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/12/11 18:33, Jens Axboe 写道:
> On 12/11/25 3:22 AM, Jens Axboe wrote:
>> On 12/11/25 12:38 AM, Fengnan wrote:
>>>
>>> ? 2025/12/11 12:10, Jens Axboe ??:
>>>> On 12/10/25 7:15 PM, Jens Axboe wrote:
>>>>> On 12/10/25 1:55 AM, Fengnan Chang wrote:
>>>>>> In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
>>>>>> is considered that the current req is the actual completed request.
>>>>>> This may be reasonable for multi-queue ctx, but is problematic for
>>>>>> single-queue ctx because the current request may not be done when the
>>>>>> poll gets to the result. In this case, the completed io needs to wait
>>>>>> for the first io on the chain to complete before notifying the user,
>>>>>> which may cause io accumulation in the list.
>>>>>> Our modification plan is as follows: change io_wq_work_list to normal
>>>>>> list so that the iopoll_list list in it can be removed and put into the
>>>>>> comp_reqs list when the request is completed. This way each io is
>>>>>> handled independently and all gets processed in time.
>>>>>>
>>>>>> After modification,  test with:
>>>>>>
>>>>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
>>>>>> /dev/nvme6n1
>>>>>>
>>>>>> base IOPS is 725K,  patch IOPS is 782K.
>>>>>>
>>>>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
>>>>>> /dev/nvme6n1
>>>>>>
>>>>>> Base IOPS is 880k, patch IOPS is 895K.
>>>>> A few notes on this:
>>>>>
>>>>> 1) Manipulating the list in io_complete_rw_iopoll() I don't think is
>>>>>      necessarily safe. Yes generally this is invoked from the
>>>>>      owning/polling task, but that's not guaranteed.
>>>>>
>>>>> 2) The patch doesn't apply to the current tree, must be an older
>>>>>      version?
>>>>>
>>>>> 3) When hand-applied, it still throws a compile warning about an unused
>>>>>      variable. Please don't send untested stuff...
>>>>>
>>>>> 4) Don't just blatantly bloat the io_kiocb. When you change from a
>>>>>      singly to a doubly linked list, you're growing the io_kiocb size. You
>>>>>      should be able to use a union with struct io_task_work for example.
>>>>>      That's already 16b in size - win/win as you don't need to slow down
>>>>>      the cache management as that can keep using the linkage it currently
>>>>>      is using, and you're not bloating the io_kiocb.
>>>>>
>>>>> 5) The already mentioned point about the cache free list now being
>>>>>      doubly linked. This is generally a _bad_ idea as removing and adding
>>>>>      entries now need to touch other entries too. That's not very cache
>>>>>      friendly.
>>>>>
>>>>> #1 is kind of the big one, as it means you'll need to re-think how you
>>>>> do this. I do agree that the current approach isn't necessarily ideal as
>>>>> we don't process completions as quickly as we could, so I think there's
>>>>> merrit in continuing this work.
>>>> Proof of concept below, entirely untested, at a conference. Basically
>>>> does what I describe above, and retains the list manipulation logic
>>>> on the iopoll side, rather than on the completion side. Can you take
>>>> a look at this? And if it runs, can you do some numbers on that too?
>>> This patch works, and in my test case, the performance is identical to
>>> my patch.
>> Good!
>>
>>> But there is a small problem, now looking for completed requests,
>>> always need to traverse the whole iopoll_list. this can be a bit
>>> inefficient in some cases, for example if the previous sent 128K io ,
>>> the last io is 4K, the last io will be returned much earlier, this
>>> kind of scenario can not be verified in the current test. I'm not sure
>>> if it's a meaningful scenario.
>> Not sure that's a big problem, you're just spinning to complete anyway.
>> You could add your iob->nr_reqs or something, and break after finding
>> those know have completed. That won't necessarily change anything, could
>> still be the last one that completed. Would probably make more sense to
>> pass in 'min_events' or similar and stop after that. But I think mostly
>> tweaks that can be made after the fact. If you want to send out a new
>> patch based on the one I sent, feel free to.
> Eg, something like this on top would do that. Like I mentioned earlier,
> you cannot do the list manipulation where you did it, it's not safe. You
> have to defer it to reaping time. If we could do it from the callback
> where we mark it complete, then that would surely make things more
> trivial and avoid iteration when not needed.

Yes, it's not safe do the list manipulation in io_complete_rw_iopoll.
It looks more reasonable with the following modifications.
Your changes look good enough, but please give me more time, I'd
like to do some more testing and rethink this.

>
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index cae9e857aea4..93709ee6c3ee 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -917,6 +917,7 @@ static inline bool blk_mq_add_to_batch(struct request *req,
>   	else if (iob->complete != complete)
>   		return false;
>   	iob->need_ts |= blk_mq_need_time_stamp(req);
> +	iob->nr_reqs++;
>   	rq_list_add_tail(&iob->req_list, req);
>   	return true;
>   }
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 72e34acd439c..9335b552e040 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1821,6 +1821,7 @@ void bdev_fput(struct file *bdev_file);
>   struct io_comp_batch {
>   	struct rq_list req_list;
>   	bool need_ts;
> +	int nr_reqs;
>   	void (*complete)(struct io_comp_batch *);
>   };
>   
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 307f1f39d9f3..37b5b2328f24 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1358,6 +1358,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   		iob.complete(&iob);
>   
>   	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_node) {
> +		if (nr_events == iob.nr_reqs)
> +			break;
>   		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
>   		if (!smp_load_acquire(&req->iopoll_completed))
>   			continue;
>


