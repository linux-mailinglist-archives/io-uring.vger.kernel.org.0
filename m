Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32D56C2229
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 21:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjCTUEO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 16:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCTUEE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 16:04:04 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8DD28EAF
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 13:03:43 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id bc5so1353256ilb.9
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 13:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679342621; x=1681934621;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q1kOq1BIsybjWD+K8RdfOxwHJDwmDLwkKFSIkcKXWuY=;
        b=mitcPxXmcDWJID8YFSmxEJqxtbj9ddskpnS0JiMPiCRIpOtDibTQNYa9YqxNsRcoga
         sbDk6oBo8pCDIw8IN8d8+cwBu3ltuYagvm82yxeM/YSypoa8qOU2AlehmdQAgjAnhimX
         omZ3Snz/w7YSBMj0Oo+PQGtIgZ+zVVLTyikW2X5Yhj7fKLTF01PdDlGN1kW3k/EbLcoF
         M0CyZkLy5rU7SNpy4dAOKG3Wtt5J1UiBHqapYeJxE1rw/PmuWIta67SPf6SY4KOuOMwF
         SAQj/wscUCtZxxq1hEg5mSayLLVVF9O4n7BKwgVxG4N4q0W2kT4nwC8xF+GeU6H6qq3U
         L3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342621; x=1681934621;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1kOq1BIsybjWD+K8RdfOxwHJDwmDLwkKFSIkcKXWuY=;
        b=DOibqacNHXdIjxoNEtCdTER2wZSg+HMwdv+UOw4J1sMr4QC6EWGKFwf5Ff5DXt9Hz1
         KuZa6IXu5eWwsDrMS5Oh9WB5rBHpRMq9Hv0e0oHQXuNj/GTpsvqHDfqX/j2TyRfx4Ozf
         jET/3Mf/1+z/cQ2EoXlCH5g+Mhbg+oumMo08eyejnCqYX8EMlfVkItJyXQ26i4pqVwh6
         qnBPQQ1vsyGpmGPHdwnavSj7cOjbPeT2hlLOM5Ke64FJcVH4PDH6zZ2CLx+zrOaQNfp5
         JpIBjVYdPKMZAy6Fit+yXlGRrzubD7uH6+NaFFWtv6OC+LXnYKsouDi14F78NzH30wkz
         j+fg==
X-Gm-Message-State: AO0yUKXqKnbqDmPJyQsERl0XWrvb8IgHrqtTaAvkrVBfoEDvVwfJrrqM
        s+oe4JSW6LgUs3cYpsLftj6ZMUKWaHgGAtLukt4/Sg==
X-Google-Smtp-Source: AK7set+pdAA/d+cqcoJD1kScZd+39M+Jc3xYMzUqXuWkjUStdQfwe7unHchBhdUp7s6aqGK2II1R5A==
X-Received: by 2002:a92:cdab:0:b0:323:10c5:899e with SMTP id g11-20020a92cdab000000b0032310c5899emr415804ild.1.1679342620823;
        Mon, 20 Mar 2023 13:03:40 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s19-20020a056638259300b003acde48bdc3sm3400253jat.111.2023.03.20.13.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 13:03:40 -0700 (PDT)
Message-ID: <a3c007ee-f324-df9c-56ae-2356f10d76e6@kernel.dk>
Date:   Mon, 20 Mar 2023 14:03:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring/uring_cmd: push IRQ based completions through
 task_work
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/23 9:06?AM, Kanchan Joshi wrote:
> On Sun, Mar 19, 2023 at 8:51?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> This is similar to what we do on the non-passthrough read/write side,
>> and helps take advantage of the completion batching we can do when we
>> post CQEs via task_work. On top of that, this avoids a uring_lock
>> grab/drop for every completion.
>>
>> In the normal peak IRQ based testing, this increases performance in
>> my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 2e4c483075d3..b4fba5f0ab0d 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
>>  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
>>  {
>>         struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>> +       struct io_ring_ctx *ctx = req->ctx;
>>
>>         if (ret < 0)
>>                 req_set_fail(req);
>>
>>         io_req_set_res(req, ret, 0);
>> -       if (req->ctx->flags & IORING_SETUP_CQE32)
>> +       if (ctx->flags & IORING_SETUP_CQE32)
>>                 io_req_set_cqe32_extra(req, res2, 0);
>> -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
>> +       if (ctx->flags & IORING_SETUP_IOPOLL) {
>>                 /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>                 smp_store_release(&req->iopoll_completed, 1);
>> -       else
>> -               io_req_complete_post(req, 0);
>> +               return;
>> +       }
>> +       req->io_task_work.func = io_req_task_complete;
>> +       io_req_task_work_add(req);
>>  }
> 
> Since io_uring_cmd_done itself would be executing in task-work often
> (always in case of nvme), can this be further optimized by doing
> directly what this new task-work (that is being set up here) would
> have done?
> Something like below on top of your patch -
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index e1929f6e5a24..7a764e04f309 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -58,8 +58,12 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd,
> ssize_t ret, ssize_t res2)
>                 smp_store_release(&req->iopoll_completed, 1);
>                 return;
>         }
> -       req->io_task_work.func = io_req_task_complete;
> -       io_req_task_work_add(req);
> +       if (in_task()) {
> +               io_req_complete_defer(req);
> +       } else {
> +               req->io_task_work.func = io_req_task_complete;
> +               io_req_task_work_add(req);
> +       }
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_done);

Good point, though I do think we should rework to pass in the flags
instead. I'll take a look.

-- 
Jens Axboe

