Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6753E43F7
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 12:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhHIKfy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 06:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbhHIKfx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 06:35:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C774C061798;
        Mon,  9 Aug 2021 03:35:33 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k29so7944934wrd.7;
        Mon, 09 Aug 2021 03:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9H3/YxJliW7+PjfOPoBWLU1jHzqvHq35yXLPygLxSdo=;
        b=hthcYKVf83AXqgasc5NyEfIDMWmMgKfNGxawq6gZz2gaSMqJS+rRQUakune+NKaFwL
         PWJDK9ErDEW34vNJW9n7J9dpt7ZzwbFCdrCvNcmlxrepfHAHecb0XVg4aM0u4hncM7i6
         53VxTLY49b3abv37IzTOHYqk0mvsH0uhTrVwoXDTrLTfEquAoYEnRjiweS6bOZIjbLeD
         5H08UlOzKwXlga54vz2bX0+AnMn94fbWypilLR6vuk+aHukH2O43/U1M4YaRAbIROiTc
         G8xZSU07EA1I7rafFTFvZkXVG3Y3xMKxDK9G40cSwjFyVoEgtfJfsKterO88WfBJmQX8
         s1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9H3/YxJliW7+PjfOPoBWLU1jHzqvHq35yXLPygLxSdo=;
        b=Gg7KF6TwM4TANtJs2WhIr9AqXWG9dlkDn/NkA39BJ92FfeAhuoBzJaN6KsVCyB9BxH
         q2UF7mnMf2rTrG/HruDWBr2hClRwgD8ujT57FdVKQlEDOg36zEAY3QJ4d9SJ1jDi+wHk
         LDAR3ZrKQPtJfGrgW9GIF6smQNbjoezpOhrxRf9fECn1ijmKA/CiUOONYEwzs9F7/1Y3
         t486lcaa3IViztSrWRFdLLx2kE0mK1q6VbklGAOZP+vgnDpblubk9Q+DvNLpWn5/jbb2
         8MKoRikLrKlF0KhsavCfEPCAlJWRTTW1X8sKx3xNKO2gPniNrCNalc3f0F14XC1FJu7+
         Cjpg==
X-Gm-Message-State: AOAM532dDNxClhWBpjqbJAKfdLBB6wUDKH/v7kYe6djgVpyM1cK/YlBg
        TwvFTEj/U4urh64eSkeRP56mxozQbHA=
X-Google-Smtp-Source: ABdhPJy3Bzt9mLaQEf4eh6vQkAD+sJbKaM2ao3RiD/vM6K1AVBCZ2BcK3/fpWDbkoqvL4ekQQMqwJQ==
X-Received: by 2002:adf:eec9:: with SMTP id a9mr23386141wrp.226.1628505331499;
        Mon, 09 Aug 2021 03:35:31 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id o2sm17367468wmq.30.2021.08.09.03.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 03:35:31 -0700 (PDT)
To:     Nadav Amit <namit@vmware.com>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <488f005c-fd92-9881-2700-b2eb1adbb78e@gmail.com>
 <40885F33-F35D-49E9-A79F-DB3C35278F73@vmware.com>
 <8825c48c-3574-c76f-4ff2-e68aaf657cda@linux.alibaba.com>
 <CAC2285F-0841-47F5-8567-24C1377DDFB6@vmware.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
Message-ID: <f47cc1a7-eae5-df1b-a811-f2eabd6d735c@gmail.com>
Date:   Mon, 9 Aug 2021 11:35:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAC2285F-0841-47F5-8567-24C1377DDFB6@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 5:50 AM, Nadav Amit wrote:
>> On Aug 8, 2021, at 9:07 PM, Hao Xu <haoxu@linux.alibaba.com> wrote:
>> 在 2021/8/9 上午1:31, Nadav Amit 写道:
>>>> On Aug 8, 2021, at 5:55 AM, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> On 8/8/21 1:13 AM, Nadav Amit wrote:
>>>>> From: Nadav Amit <namit@vmware.com>
>>>>>
>>>>> When using SQPOLL, the submission queue polling thread calls
>>>>> task_work_run() to run queued work. However, when work is added with
>>>>> TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains
>>>>
>>>> static int io_req_task_work_add(struct io_kiocb *req)
>>>> {
>>>> 	...
>>>> 	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
>>>> 	if (!task_work_add(tsk, &tctx->task_work, notify))
>>>> 	...
>>>> }
>>>>
>>>> io_uring doesn't set TIF_NOTIFY_SIGNAL for SQPOLL. But if you see it, I'm
>>>> rather curious who does.
>>> I was saying io-uring, but I meant io-uring in the wider sense:
>>> io_queue_worker_create().
>>> Here is a call trace for when TWA_SIGNAL is used. io_queue_worker_create()
>>> uses TWA_SIGNAL. It is called by io_wqe_dec_running(), and not shown due
>>> to inlining:
>> Hi Nadav, Pavel,
>> How about trying to make this kind of call to use TWA_NONE for sqthread,
>> though I know for this case currently there is no info to get to know if
>> task is sqthread. I think we shouldn't kick sqthread.
> 
> It is possible, but it would break the abstractions and propagating
> it would be disgusting. Let me give it some thought.

We already do io_wq_enqueue() only from the right task context,
so in theory instead of pushing it through tw, we can create
a new thread on the spot. Though, would need to be careful
with locking.

Anyway, agree that it's better to be left for next.

> Regardless, I think that this patch should go to 5.14 and stable,
> and any solution to avoid kicking the SQ should come on top (to be
> safe).

-- 
Pavel Begunkov
