Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72769200B53
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 16:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgFSOW0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 10:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgFSOWY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 10:22:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E9BC0613EF
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 07:22:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s10so4574950pgm.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 07:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vxtHFfxRa6J52mPRG6jvgbvliKZllqWnNgXrzGwwQhE=;
        b=FHU640PiXW0xLyp6AL1PCI7tRK5wZ06ZcDtLoY1aP2MLtQLYA/U8l9u+b9wpPYqO6A
         rKlg/ouC1alQwarF28E0DQZ1SJXWsrDrDUYLSjHv95gzOTS88oBzZ0IP7kYuLRe4dEpU
         K51/lr0hGhn6/egk9YmTp7T1VdLVAlWt3OFSjyKaAMn7Ld7iL3gdHOiFXMm/AJFzUHfu
         wfMLS9RtdrGdqp76or0DL9iuXL2SBwqm/1H76EveVh8A5a/g6wllP0xfgCSEi5teRCjP
         SPRU9LwxkuNVMzFCC3C33qwzViJCT+14F747rhVJ9n+i2CVu4EK2i39GuuwIMefZN7za
         ESGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vxtHFfxRa6J52mPRG6jvgbvliKZllqWnNgXrzGwwQhE=;
        b=BO6VFuPJmj77rYlp/aqqv/WDZvuCeEkojwQlF6tkzgaEV8DVShMuJ8FpbhRs3eMFUa
         LQBnPArAK7CzdQt4MFGGmNhlT+Xawh0yn+tk/dgaO6xWRdXaONvX4goQHm5RKwUrDw0L
         LExAQJ9WZ/VYc4x90cibT28vxNMaDslJN7fmvIuucprNvrTA7ESNr/DspBrFWvoV+Hwo
         9d1Cr4BRU1l39YcyN2b1h3jZbPlqbpug3iw4MdLjzWiFANqEeVi2W6qceRV4ggXRO74m
         LTTpdho6i+HIgOdZuKRj3xYPwonAHyxXCvOUbe68/Z8vWjfMSJPb7NCAhJMngMy9GlBy
         oryg==
X-Gm-Message-State: AOAM533RVkd9NvVZuPW91OFY6vYTDdN7OJajI9/qznBjHi7xps/U9p4h
        W7KW9727jyTV7ipQch89xY6eeQ==
X-Google-Smtp-Source: ABdhPJxRONpeZFjGL6amyDVA55vSKIbY4ULoW+nnBgRLPw2fISt14O88Or5B2Im6nt4e2+NiD0KsNQ==
X-Received: by 2002:a65:43cb:: with SMTP id n11mr3240011pgp.160.1592576544118;
        Fri, 19 Jun 2020 07:22:24 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p11sm6265486pfq.10.2020.06.19.07.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 07:22:23 -0700 (PDT)
Subject: Re: [PATCH 04/15] io_uring: re-issue block requests that failed
 because of resources
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-5-axboe@kernel.dk>
 <cdd4bf56-5a08-5d28-969f-81b70cc3c473@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <da21ba82-c027-0c15-93e3-a372283d7030@kernel.dk>
Date:   Fri, 19 Jun 2020 08:22:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cdd4bf56-5a08-5d28-969f-81b70cc3c473@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/20 8:12 AM, Pavel Begunkov wrote:
> On 18/06/2020 17:43, Jens Axboe wrote:
>> Mark the plug with nowait == true, which will cause requests to avoid
>> blocking on request allocation. If they do, we catch them and reissue
>> them from a task_work based handler.
>>
>> Normally we can catch -EAGAIN directly, but the hard case is for split
>> requests. As an example, the application issues a 512KB request. The
>> block core will split this into 128KB if that's the max size for the
>> device. The first request issues just fine, but we run into -EAGAIN for
>> some latter splits for the same request. As the bio is split, we don't
>> get to see the -EAGAIN until one of the actual reads complete, and hence
>> we cannot handle it inline as part of submission.
>>
>> This does potentially cause re-reads of parts of the range, as the whole
>> request is reissued. There's currently no better way to handle this.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 148 ++++++++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 124 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 2e257c5a1866..40413fb9d07b 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -900,6 +900,13 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
>>  static void __io_queue_sqe(struct io_kiocb *req,
>>  			   const struct io_uring_sqe *sqe);
>>  
> ...> +
>> +static void io_rw_resubmit(struct callback_head *cb)
>> +{
>> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	int err;
>> +
>> +	__set_current_state(TASK_RUNNING);
>> +
>> +	err = io_sq_thread_acquire_mm(ctx, req);
>> +
>> +	if (io_resubmit_prep(req, err)) {
>> +		refcount_inc(&req->refs);
>> +		io_queue_async_work(req);
>> +	}
> 
> Hmm, I have similar stuff but for iopoll. On top removing grab_env* for
> linked reqs and some extra. I think I'll rebase on top of this.

Yes, there's certainly overlap there. I consider this series basically
wrapped up, so feel free to just base on top of it.

>> +static bool io_rw_reissue(struct io_kiocb *req, long res)
>> +{
>> +#ifdef CONFIG_BLOCK
>> +	struct task_struct *tsk;
>> +	int ret;
>> +
>> +	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
>> +		return false;
>> +
>> +	tsk = req->task;
>> +	init_task_work(&req->task_work, io_rw_resubmit);
>> +	ret = task_work_add(tsk, &req->task_work, true);
> 
> I don't like that the request becomes un-discoverable for cancellation
> awhile sitting in the task_work list. Poll stuff at least have hash_node
> for that.

Async buffered IO was never cancelable, so it doesn't really matter.
It's tied to the task, so we know it'll get executed - either run, or
canceled if the task is going away. This is really not that different
from having the work discoverable through io-wq queueing before, since
the latter could never be canceled anyway as it sits there
uninterruptibly waiting for IO completion.

-- 
Jens Axboe

