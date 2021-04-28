Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E5A36D9B2
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbhD1Oie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbhD1Oib (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:38:31 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4501AC061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:37:45 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f15-20020a05600c4e8fb029013f5599b8a9so7356385wmq.1
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bif/XwW/p7JgjM8unkChqyQOqK1cQtJBGndRSEGeunM=;
        b=Cix9gkGjZH+zyF4E1OOlM4h2nDMSlQU7KctkRlZBevDSnfeaBQuybDwECReZf4PhwF
         94hgW6ikxYcWpnYhqsMg15VAOv/bHqHK10NLP81Q9f30GdOKM/DbOvaDcjajHbuvG07E
         smHMuJ45tJd8JN393MVrlOzmemdoX8Ho6IsiuiNIUkAw8R5Mf8TxiEPGV6l0QnxilrAg
         zBDx/Mugu3Mli78H3lP0KDfd9dxNgeBtAaZdn616Hr63pHF8/0nehEK2IhHzI1ei3BwR
         AK+Hcd5NL2Y+FdEjXULh7Yk9FUmvScvGJ+0b16Ykt1CV7vdEjbTFDPqe2OtYMhluAJGd
         8dWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bif/XwW/p7JgjM8unkChqyQOqK1cQtJBGndRSEGeunM=;
        b=eMknGKghYxfJ4KAuuRDaop7hoN/LvalW/qiayGkeAQylXXRn9Nz54oC7uj5U2aBRRh
         A2LNOKIbuFkpK1GoO54daD5jaWPqKw4RshP7UhmkS1Zgph6715DskMDkjro+FDid7qFA
         Xe7RXR4B7Anf5xOv3qASsSoYvNmQ97wfRfMEhIMYsuaNv/VD/JA2698wwlL/rlC0lyYu
         k6KUSNPgozW66ciAS8JNqcEscGH0hT2h/1fCGKWOiOJR9WOgju2ksh2dB83Z2z4X1Xid
         9g4hdZfwxZu6F9sGFA6b6S8u0vvyG6ysnRZKM6WqgMulA6PEPYH4HStp+eDnJQJzIFeT
         TIxA==
X-Gm-Message-State: AOAM532+uhCPR+5vARTP6Ugu2M5L9acWOpS7XzZBIdlKHL19bscDetXd
        bWylPkuyGUEwIoblsgYikic=
X-Google-Smtp-Source: ABdhPJy7Btwd+RQgO6V7foPjTzPmfsCnR/RXlnil8vdlI1LUPBPZO4/fdCBg0otnvZlo19hsf756qw==
X-Received: by 2002:a7b:c846:: with SMTP id c6mr4803860wml.75.1619620664036;
        Wed, 28 Apr 2021 07:37:44 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id v20sm4184529wmj.15.2021.04.28.07.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:37:43 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
Message-ID: <6cc0020d-bfad-d723-6cc3-8bb2b8c4d313@gmail.com>
Date:   Wed, 28 Apr 2021 15:37:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 3:34 PM, Pavel Begunkov wrote:
> On 4/28/21 2:32 PM, Hao Xu wrote:
>> sqes are submitted by sqthread when it is leveraged, which means there
>> is IO latency when waking up sqthread. To wipe it out, submit limited
>> number of sqes in the original task context.
>> Tests result below:
> 
> Frankly, it can be a nest of corner cases if not now then in the future,
> leading to a high maintenance burden. Hence, if we consider the change,
> I'd rather want to limit the userspace exposure, so it can be removed
> if needed.
> 
> A noticeable change of behaviour here, as Hao recently asked, is that
> the ring can be passed to a task from a completely another thread group,
> and so the feature would execute from that context, not from the
> original/sqpoll one.

So maybe something like:
if (same_thread_group()) {
	/* submit */
}

> 
> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
> ignored if the previous point is addressed.

I'd question whether it'd be better with the flag or without doing
this feature by default.

> 
>>
>> 99th latency:
>> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
>> with this patch:
>> 2k      	13	13	12	13	13	12	12	11	11	10.304	11.84
>> without this patch:
>> 2k      	15	14	15	15	15	14	15	14	14	13	11.84
> 
> Not sure the second nine describes it well enough, please can you
> add more data? Mean latency, 50%, 90%, 99%, 99.9%, t-put.
> 
> Btw, how happened that only some of the numbers have fractional part?
> Can't believe they all but 3 were close enough to integer values.
> 
>> fio config:
>> ./run_fio.sh
>> fio \
>> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
>> --direct=1 --rw=randread --time_based=1 --runtime=300 \
>> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
>> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
>> --io_sq_thread_idle=${2}
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>  fs/io_uring.c                 | 29 +++++++++++++++++++++++------
>>  include/uapi/linux/io_uring.h |  1 +
>>  2 files changed, 24 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 1871fad48412..f0a01232671e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
>>  {
>>  	struct io_ring_ctx *ctx = req->ctx;
>>  	struct io_kiocb *link = io_prep_linked_timeout(req);
>> -	struct io_uring_task *tctx = req->task->io_uring;
>> +	struct io_uring_task *tctx = NULL;
>> +
>> +	if (ctx->sq_data && ctx->sq_data->thread)
>> +		tctx = ctx->sq_data->thread->io_uring;
> 
> without park it's racy, sq_data->thread may become NULL and removed,
> as well as its ->io_uring.
> 
>> +	else
>> +		tctx = req->task->io_uring;
>>  
>>  	BUG_ON(!tctx);
>>  	BUG_ON(!tctx->io_wq);
> 
> [snip]
> 

-- 
Pavel Begunkov
