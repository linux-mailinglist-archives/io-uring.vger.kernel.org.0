Return-Path: <io-uring+bounces-11018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BEC8CB78F1
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 02:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4D2D3300B6AA
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 01:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E077226CF7;
	Fri, 12 Dec 2025 01:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RubvEpgn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8112119067C
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 01:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765503724; cv=none; b=brQH09LIm0SRxSR2jONV2cU55onznv/+31tiBE+Quc9IXrJmqj0ukYqvMjwVZwROLk/WmJHr8g+138xoszn4/7vlda/EKmunsw4KffrHvSG+HgyhCpquymAHTgNF3Np4mNLeL1qs9sWZvVvFOYxhEIEAfBSuIzLXaffo/kPxEfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765503724; c=relaxed/simple;
	bh=6LSK4ywG/srZ2SGYyt1vlDgvWJo4sm3sssH7HdNwvUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZfQnTWDoDX+r2YsiuAyviIcDe738UVSSJAotmfUtfIdckZsxoegBhIKGzKAnmRLpgAjZp9BHsx/iIfpbFgQUZnHMDI1JYtApRMPTiP+kT/M+sd3J5BNsNprEVFW6ZwVgrTQjkx8rFGzyArdu+fDkFgGT/4fywMdKdsfSN5/B1Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RubvEpgn; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7ade456b6abso561883b3a.3
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 17:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765503722; x=1766108522; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K76noSQmYycpq1JkZd3WvuE+fIzPQm2fkSyWrW1T+oE=;
        b=RubvEpgn7+V7WeD8lWyxCVRDr1L4iBfOGtVKn49ZEXZw4aeYca0qes7HVjo7MfWSW7
         ZFiVNYa9dN0KTCDfxchHi7chQVLGU/BQlsPelZimIUzQ8TswzXDDheuCzR8luB8XBpMe
         BJNFrj+iLxNcF8vIk7q20FPVIB5beKlTaHHE7/RSnppf1kyNLDrZT2UTnRH2hJj3TWYD
         DWCt/pGdQEU0A5TBzIW3ILH/JdDmRyKS3XHEver24T979lQWNNHOKZcfypiSluaSSAU1
         EkvtDnMvY+Rhrb25Bk3lgoC2vp4W0+8y+T+uECdTyQv1FyQhEy23/2ZBB1P93K9P9aOl
         qubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765503722; x=1766108522;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K76noSQmYycpq1JkZd3WvuE+fIzPQm2fkSyWrW1T+oE=;
        b=tqzt7W6nvTZR4O0BfYLizudnbO3FOI10/K5cL8ZEfO3swgoAoG1+M3EcZFm4ENEzGE
         bzE17xHs+LefFYS4nEyJdgRBCQlQ/E31t6IvvIBmw8hBpk2d+jlFSJ8XNKDnBvNE+44s
         pxrvSQuIyqDdCNeWRGZBWE9iJxApfTAFMRTwwHQx+pi4ZTx4e4exGP16O0UbiEd45432
         Qh7R8W/3KFSmf+urS2QMVls+itpFUy4p9V8dqjUD0keJRdHqw0q4hrwuW875DO6SwbOL
         aFP9kXcXoTl1cu3Z/iMRUgh5IWC5/jHFR7vz6KprAVfuLuvb6ErBWckTWQamupUqKb2G
         8qzw==
X-Forwarded-Encrypted: i=1; AJvYcCU7tSNOulGN9TnlntN39AJM0zC89Q6MiwCzYjWa3gLBp62vDswmABqQJVz2IG1SLxEQr3WY8h4CWw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzL8N/+dWctM4viSzMDn+IGxmGyVtGUrHZg7vAHWrAx3qGCCmGf
	SVlBC1023FXZXQo1felX23TvnnpSd2TG+le65K/wLgMmBHNXLUTn5F9t
X-Gm-Gg: AY/fxX4DP8su1kMDnZpN4OHq4EvGfbcCdzxkNT5WEio3isNdUcdxV61MRquLofYdlrV
	rKafLcoo7OKTlw4rsf/jfnLi/eQku6CmuBDoJCNna2yiN4lWPPHX4JuTPH8a9lARWgyySRXZ6G/
	sDJcLr+WsQRlO1Tmk8BqJ0vpmcFSSauB/8KZ0CtZvwrCS3grIBU4ujhM3FOEk4OzoLo/rr6DiP6
	QGBshn1Pd773SmbADzkO/+At0nBBgrVFvvaiL1/4qPFCNHnYvBoMcIgs8ZMRgxFaAla+dZBxZzo
	lEuokPOwWmLDKRz+9FLvGTiOFs6H28hToxd1d9hlv8KY9VSUOlG9DIJTjhwp8uQyhPdRj4U0hpm
	jTO4VMoANeFhXAxZmvPCIDCieBSMumlC0WzdwCU4qRC5qmE0Mh55Ta1UIOvU4oqwXYg7IEc7jok
	3qA+f4faMgPqvxpSoNlK1/TV7dk3kRHBA=
X-Google-Smtp-Source: AGHT+IHe4EYNrEA0hnBRQZlC1nQeW8CW3mU9FaCz+DTAQ6S/Ig8iMSGpPQNIXfjrSrAuqWb3GVTthQ==
X-Received: by 2002:a05:6a20:7fa0:b0:342:9cb7:64a3 with SMTP id adf61e73a8af0-369addc13e2mr480940637.34.1765503721593;
        Thu, 11 Dec 2025 17:42:01 -0800 (PST)
Received: from [100.82.101.13] ([203.208.167.148])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2c963b53sm3419272a12.36.2025.12.11.17.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 17:42:01 -0800 (PST)
Message-ID: <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
Date: Fri, 12 Dec 2025 09:41:56 +0800
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

Oh, we can't add nr_events == iob.nr_reqs check, if blk_mq_add_to_batch 
add failed,
completed IO will not add into iob, iob.nr_reqs will be 0, this may 
cause io hang.

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


