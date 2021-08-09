Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F753E43C1
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 12:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhHIKTx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 06:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhHIKTs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 06:19:48 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B187C0613D3;
        Mon,  9 Aug 2021 03:19:26 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k29so7881808wrd.7;
        Mon, 09 Aug 2021 03:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A6Ae7xPC6TT4sJ48PYeG//W+J15PNWyZPd8GaVrXFvQ=;
        b=t0yqnmVZ7G8O4QNYo+va0H7kkgJkRTgiSbU7RgX9mmipDuz4XyacEFKeSSkzMRFmju
         LJlaAnPFecno3FgBF6HJBGZwuVAv3SRGJt2r03cPu8BF5jzbM5LtLQFw2npggsNQbsuq
         oicgGZnj0HalaMJkpWTIwSk/19seGJk+MPhNiSNmo8vBMl7gVWbMdHLF92/cDBa/GPXp
         F3VSUyuYaVFN3NjPxGwHUNFs7CxzpCTg9bO0+z46tqak47+O+WOZ1qcFW2qx8+KsGWQI
         PsHfoKFZscFb2L7cX1CgXluPIi13bmONUfOe/YJVs5GeyNrZBTPi0Lo8QYFSlw2CSOM3
         XsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A6Ae7xPC6TT4sJ48PYeG//W+J15PNWyZPd8GaVrXFvQ=;
        b=mCNnmgZ9Pv8AEVkOt8yjOVymHceM0MRVXiENV0dd3MuBNJ7EiW2mizVlk2dsLLLemk
         iUDL7m5rh8So/05n1hOpMqxCvX7L1Iz00Q6r/QupMbjoBF8KOXE2TQLk0SmUVRMM6ePH
         PB5xjrlOVXK9qRShM6xZ7RoAoB5avAAAry2PUeXRj0ryrJ96fGYMnTlLcf0TAJoMF56x
         x23TL6w39E6K830Jl4nVKoAMLIRcR1/FAoXcPWoKwKjDZi59X1GupNX+sON3AiOL3tcp
         V4lYK50TkcZoxjCqWiXIqQHVHDBh0APbZR8U/14Gk9h7/Gjymu5pESJYwUwW81CX4RSC
         6LHw==
X-Gm-Message-State: AOAM530gdT/EynCy5jQohCBmV6Xy3aUkU0mRvUNp3Z1/0ZisNSsIOOXa
        Hrtq3L1FB7VAuOR7yy3SUWkkXdo6eFw=
X-Google-Smtp-Source: ABdhPJx8wM+R1/sM4r5WRL+myJnzLkKhINN9ZRKpWQpJgX+TsMQXTiDLWSYxRcIDp9hOEEfncomiuQ==
X-Received: by 2002:a5d:5906:: with SMTP id v6mr24235502wrd.194.1628504364740;
        Mon, 09 Aug 2021 03:19:24 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id k17sm19657437wrw.53.2021.08.09.03.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 03:19:24 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
To:     Nadav Amit <namit@vmware.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <488f005c-fd92-9881-2700-b2eb1adbb78e@gmail.com>
 <40885F33-F35D-49E9-A79F-DB3C35278F73@vmware.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <90d77c2e-23a2-4e77-3626-6bb08027b7d4@gmail.com>
Date:   Mon, 9 Aug 2021 11:18:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <40885F33-F35D-49E9-A79F-DB3C35278F73@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/8/21 6:31 PM, Nadav Amit wrote:
>> On Aug 8, 2021, at 5:55 AM, Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 8/8/21 1:13 AM, Nadav Amit wrote:
>>> From: Nadav Amit <namit@vmware.com>
>>>
>>> When using SQPOLL, the submission queue polling thread calls
>>> task_work_run() to run queued work. However, when work is added with
>>> TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains
>>
>> static int io_req_task_work_add(struct io_kiocb *req)
>> {
>> 	...
>> 	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
>> 	if (!task_work_add(tsk, &tctx->task_work, notify))
>> 	...
>> }
>>
>> io_uring doesn't set TIF_NOTIFY_SIGNAL for SQPOLL. But if you see it, I'm
>> rather curious who does.
> 
> I was saying io-uring, but I meant io-uring in the wider sense:
> io_queue_worker_create().
> 
> Here is a call trace for when TWA_SIGNAL is used. io_queue_worker_create()
> uses TWA_SIGNAL. It is called by io_wqe_dec_running(), and not shown due
> to inlining:
> 
> [   70.540761] Call Trace:
> [   70.541352]  dump_stack+0x7d/0x9c
> [   70.541930]  task_work_add.cold+0x9/0x12
> [   70.542591]  io_wqe_dec_running+0xd6/0xf0
> [   70.543259]  io_wq_worker_sleeping+0x3d/0x60
> [   70.544106]  schedule+0xa0/0xc0
> [   70.544673]  userfaultfd_read_iter+0x2c3/0x790
> [   70.545374]  ? wake_up_q+0xa0/0xa0
> [   70.545887]  io_iter_do_read+0x1e/0x40
> [   70.546531]  io_read+0xdc/0x340
> [   70.547148]  ? update_curr+0x72/0x1c0
> [   70.547887]  ? update_load_avg+0x7c/0x600
> [   70.548538]  ? __switch_to_xtra+0x10a/0x500
> [   70.549264]  io_issue_sqe+0xd99/0x1840
> [   70.549887]  ? lock_timer_base+0x72/0xa0
> [   70.550516]  ? try_to_del_timer_sync+0x54/0x80
> [   70.551224]  io_wq_submit_work+0x87/0xb0
> [   70.552001]  io_worker_handle_work+0x2b5/0x4b0
> [   70.552705]  io_wqe_worker+0xd6/0x2f0
> [   70.553364]  ? recalc_sigpending+0x1c/0x50
> [   70.554074]  ? io_worker_handle_work+0x4b0/0x4b0
> [   70.554813]  ret_from_fork+0x22/0x30
> 
> Does it answer your question?

Pretty much, thanks

-- 
Pavel Begunkov
