Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40206201854
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387583AbgFSOgp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 10:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387576AbgFSOgo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 10:36:44 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C9AC0613EF
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 07:36:43 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b5so4564749pgm.8
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 07:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pZm6yfNYNBuxBStKZC0kZanPMnKOlf2CgfGPgI4tuHQ=;
        b=uqgJVkp2ta13UJdmiW7Lw1bFtHRXApq/tVCDyt3pdUyhLeTsrd5cL3WhGO3XyEGEUj
         lnDHihZwWdimLe6RISBNN32+ELxaLgJ8/y4dcXDHN/GHrdU63EgDC4BsgFD/CQ6bxmSX
         BjsUEvg1+/6CaqfL4ZohtQouempwFJyB34irxdn3pQwDv4FXJtpk8F1knNvZbWe6dk/G
         tiUPF0iInhm/PXgGCIKHtskVRZq78Pb81cuOlKAUYpeAp39mlQEZWasHKf/6KecRgIqq
         2Qyeok7cXRpAZFm11moXK535vCVJ5QuNGI/Ob/P1YI1oIVBOQIh+UXokJpmC3VimY6mL
         0IpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZm6yfNYNBuxBStKZC0kZanPMnKOlf2CgfGPgI4tuHQ=;
        b=aBZKKE1ahztxC4/bQ4olity0ppjgzaGqvBXnUqs6OhMuoJ3vE6dJ5deW2ITQ4o3nzu
         t+Cs1LF7Jq5hy5DjDhHKtRf+7sR6h6KwyigoDQZ5Z3R/NxzvXbG/TzV5hxA5ur9SFlKO
         VshGfQ2//OwD+QQw8u7bsElOW/eL5MRCtiklJM4Chv/k8tHcP1PTq3ncuVn/uok6B3XD
         58NhRvjxJenbiETZUcnyQZRXhyHKW6ofFW3sJRXYlsNQrfffCRX/Eb6ZS7mrclVgOME6
         pzS4C3ofeeuDrSdg9hOMZDA8aVbmrlOE17PZvTFJpmAHULEXmz4QxU7CxiQr8fYhpRmd
         7/Qg==
X-Gm-Message-State: AOAM531JmIkKN2v8h/5dV6M5UPjw1jQ+ve8WUzAVWZXqsvpmur4UXjvJ
        alCMJwZa3ykdECV08a5oYPETdQ==
X-Google-Smtp-Source: ABdhPJwLZap2gCbNRLjuZq9p47CcZnx/KyR0tvZKTiGdcuRCXJAnOlkelvd5T5h1TxDPz4q9D8EYAA==
X-Received: by 2002:a62:640b:: with SMTP id y11mr8309607pfb.195.1592577403047;
        Fri, 19 Jun 2020 07:36:43 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b191sm5484675pga.13.2020.06.19.07.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 07:36:42 -0700 (PDT)
Subject: Re: [PATCH 04/15] io_uring: re-issue block requests that failed
 because of resources
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-5-axboe@kernel.dk>
 <cdd4bf56-5a08-5d28-969f-81b70cc3c473@gmail.com>
 <da21ba82-c027-0c15-93e3-a372283d7030@kernel.dk>
 <105a78f0-407f-09e3-5951-7f76756762b2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e7f492a3-e180-ccf6-fcf2-2cd7f318f152@kernel.dk>
Date:   Fri, 19 Jun 2020 08:36:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <105a78f0-407f-09e3-5951-7f76756762b2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/20 8:30 AM, Pavel Begunkov wrote:
> On 19/06/2020 17:22, Jens Axboe wrote:
>> On 6/19/20 8:12 AM, Pavel Begunkov wrote:
>>> On 18/06/2020 17:43, Jens Axboe wrote:
>>>> Mark the plug with nowait == true, which will cause requests to avoid
>>>> blocking on request allocation. If they do, we catch them and reissue
>>>> them from a task_work based handler.
>>>>
>>>> Normally we can catch -EAGAIN directly, but the hard case is for split
>>>> requests. As an example, the application issues a 512KB request. The
>>>> block core will split this into 128KB if that's the max size for the
>>>> device. The first request issues just fine, but we run into -EAGAIN for
>>>> some latter splits for the same request. As the bio is split, we don't
>>>> get to see the -EAGAIN until one of the actual reads complete, and hence
>>>> we cannot handle it inline as part of submission.
>>>>
>>>> This does potentially cause re-reads of parts of the range, as the whole
>>>> request is reissued. There's currently no better way to handle this.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  fs/io_uring.c | 148 ++++++++++++++++++++++++++++++++++++++++++--------
>>>>  1 file changed, 124 insertions(+), 24 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 2e257c5a1866..40413fb9d07b 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -900,6 +900,13 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
>>>>  static void __io_queue_sqe(struct io_kiocb *req,
>>>>  			   const struct io_uring_sqe *sqe);
>>>>  
>>> ...> +
>>>> +static void io_rw_resubmit(struct callback_head *cb)
>>>> +{
>>>> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
>>>> +	struct io_ring_ctx *ctx = req->ctx;
>>>> +	int err;
>>>> +
>>>> +	__set_current_state(TASK_RUNNING);
>>>> +
>>>> +	err = io_sq_thread_acquire_mm(ctx, req);
>>>> +
>>>> +	if (io_resubmit_prep(req, err)) {
>>>> +		refcount_inc(&req->refs);
>>>> +		io_queue_async_work(req);
>>>> +	}
>>>
>>> Hmm, I have similar stuff but for iopoll. On top removing grab_env* for
>>> linked reqs and some extra. I think I'll rebase on top of this.
>>
>> Yes, there's certainly overlap there. I consider this series basically
>> wrapped up, so feel free to just base on top of it.
>>
>>>> +static bool io_rw_reissue(struct io_kiocb *req, long res)
>>>> +{
>>>> +#ifdef CONFIG_BLOCK
>>>> +	struct task_struct *tsk;
>>>> +	int ret;
>>>> +
>>>> +	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
>>>> +		return false;
>>>> +
>>>> +	tsk = req->task;
>>>> +	init_task_work(&req->task_work, io_rw_resubmit);
>>>> +	ret = task_work_add(tsk, &req->task_work, true);
>>>
>>> I don't like that the request becomes un-discoverable for cancellation
>>> awhile sitting in the task_work list. Poll stuff at least have hash_node
>>> for that.
>>
>> Async buffered IO was never cancelable, so it doesn't really matter.
>> It's tied to the task, so we know it'll get executed - either run, or
>> canceled if the task is going away. This is really not that different
>> from having the work discoverable through io-wq queueing before, since
>> the latter could never be canceled anyway as it sits there
>> uninterruptibly waiting for IO completion.
> 
> Makes sense. I was thinking about using this task-requeue for all kinds
> of requests. Though, instead of speculating it'd be better for me to embody
> ideas into patches and see.

And that's fine, for requests where it matters, on-the-side
discoverability can still be a thing. If we're in the task itself where
it is queued, that provides us safey from the work going way from under
us. Then we just have to mark it appropriately, if it needs to get
canceled instead of run to completion.

Some care needed, of course, but there's nothing that would prevent this
from working. Ideally we'd be able to peal off a task_work entry, but
that's kind of difficult with the singly linked non-locked list.

-- 
Jens Axboe

