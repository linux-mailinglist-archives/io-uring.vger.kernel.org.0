Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA9B51E50B
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 09:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346562AbiEGHL6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 03:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239988AbiEGHL6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 03:11:58 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52F05C666;
        Sat,  7 May 2022 00:08:12 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id q4so6535077plr.11;
        Sat, 07 May 2022 00:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=awliyi+kCIvNX2z6aujZlzd03dTxPLU8kWaR2tWe1kk=;
        b=P+zW8iI0IbkFaZZ9UEYGGU2h252N0+v+tAi4Icwmo7mIaUElEvc9+VyCF1qOaGyB2N
         D9RuRZQ10SLbz2ttCOOWEyHggVVGTu2qaTJnuC9OIPFVzAB10gAlzDimACC6t0YhZoSQ
         CaRDX8PR2tbwlKhGrYyC8zPDsHAnbqoGdqVgWV+cNDg7lGSpmEzCxPR6x5roMTn95U32
         Z1ZO3l9DqvWpqvMwvkMlN70nZsFr4y7UzgRdAf3jfnTKvMPs/tfpAhNiybHvMU3O0sDC
         /DMeec9jU2aP1+IQYFJ0rkp0+BOs4BBZXBzTEilRLsj7dGo+vMI3HLBKXqE4jr5k2CbU
         4JBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=awliyi+kCIvNX2z6aujZlzd03dTxPLU8kWaR2tWe1kk=;
        b=o3Mm9giN4HEIKTNw7PhS3JRnyZxqIR3I0RV7fl+yD9VNlpdoSEDyOVGAiUhT3cDvqr
         WO2h7M63zT74ArDDcTftu47CtK1Dh/tdtB//cG9jSA3V3ZtA0fd+0RRHrztct78H2Ufg
         2cm0EyTOkkUWTYm5gD9u3P3W/CFyJUb4IeMK8Hmwq3zCgCZ7NTenVW0LR+MHC7m9XxWx
         zUWNA3F+b7WCLFi8/9IjmWwwRkLQNYwPuyFdK65bL2s7adKkswAMFq6mZalSZg97qTLO
         l6uA4NaHagxMk3npNKlGpnYPMr9BdyNO1sygm5n8UYp+HAq4qKLfBsq0nCkGf2PyuUUm
         hTIg==
X-Gm-Message-State: AOAM533tRSKkx4sc+jzg0al3qNHxCnbvxFN1u7Ikuf58k7a4AwVJbDaK
        XeoniZkwBK+D0bR+rorvqik=
X-Google-Smtp-Source: ABdhPJz5LZF6eTrh/zxulRXbyTA6Du8i8dNZINn88gq6oaMXfsBEC1RjyGqeSHLr0Xu5/f1+1v9X8w==
X-Received: by 2002:a17:90a:b106:b0:1d9:7cde:7914 with SMTP id z6-20020a17090ab10600b001d97cde7914mr8396395pjq.56.1651907292308;
        Sat, 07 May 2022 00:08:12 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id o11-20020a056a001bcb00b0050dc76281cesm4480772pfw.168.2022.05.07.00.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 00:08:11 -0700 (PDT)
Message-ID: <135b16e4-f316-cb25-9cdd-09bd63eb4aef@gmail.com>
Date:   Sat, 7 May 2022 15:08:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 3/5] io_uring: let fast poll support multishot
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-4-haoxu.linux@gmail.com>
 <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 上午1:19, Pavel Begunkov 写道:
> On 5/6/22 08:01, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> For operations like accept, multishot is a useful feature, since we can
>> reduce a number of accept sqe. Let's integrate it to fast poll, it may
>> be good for other operations in the future.
>>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>   fs/io_uring.c | 41 ++++++++++++++++++++++++++---------------
>>   1 file changed, 26 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8ebb1a794e36..d33777575faf 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5952,7 +5952,7 @@ static void io_poll_remove_entries(struct 
>> io_kiocb *req)
>>    * either spurious wakeup or multishot CQE is served. 0 when it's 
>> done with
>>    * the request, then the mask is stored in req->cqe.res.
>>    */
>> -static int io_poll_check_events(struct io_kiocb *req, bool locked)
>> +static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>>   {
>>       struct io_ring_ctx *ctx = req->ctx;
>>       int v;
>> @@ -5981,17 +5981,26 @@ static int io_poll_check_events(struct 
>> io_kiocb *req, bool locked)
>>           /* multishot, just fill an CQE and proceed */
>>           if (req->cqe.res && !(req->apoll_events & EPOLLONESHOT)) {
>> -            __poll_t mask = mangle_poll(req->cqe.res & 
>> req->apoll_events);
>> -            bool filled;
>> -
>> -            spin_lock(&ctx->completion_lock);
>> -            filled = io_fill_cqe_aux(ctx, req->cqe.user_data, mask,
>> -                         IORING_CQE_F_MORE);
>> -            io_commit_cqring(ctx);
>> -            spin_unlock(&ctx->completion_lock);
>> -            if (unlikely(!filled))
>> -                return -ECANCELED;
>> -            io_cqring_ev_posted(ctx);
>> +            if (req->flags & REQ_F_APOLL_MULTISHOT) {
>> +                io_tw_lock(req->ctx, locked);
>> +                if (likely(!(req->task->flags & PF_EXITING)))
>> +                    io_queue_sqe(req);
> 
> That looks dangerous, io_queue_sqe() usually takes the request ownership
> and doesn't expect that someone, i.e. io_poll_check_events(), may still be
> actively using it.
> 
> E.g. io_accept() fails on fd < 0, return an error,
> io_queue_sqe() -> io_queue_async() -> io_req_complete_failed()
> kills it. Then io_poll_check_events() and polling in general
> carry on using the freed request => UAF. Didn't look at it
> too carefully, but there might other similar cases.
> 
I checked this when I did the coding, it seems the only case is
while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
uses req again after req recycled in io_queue_sqe() path like you
pointed out above, but this case should be ok since we haven't
reuse the struct req{} at that point.
In my first version, I skiped the do while{} in io_poll_check_events()
for multishot apoll and do the reap in io_req_task_submit()

static void io_apoll_task_func(struct io_kiocb *req, bool *locked) 

   { 

           int ret; 

 

           ret = io_poll_check_events(req, locked); 

           if (ret > 0) 

                   return; 

 

           __io_poll_clean(req); 

 

           if (!ret) 

                   io_req_task_submit(req, locked);   <------here 

           else 

                   io_req_complete_failed(req, ret); 

   }

But the disadvantage is in high frequent workloads case, it may loop in
io_poll_check_events for long time, then finally generating cqes in the
above io_req_task_submit() which is not good in terms of latency. 

> 
