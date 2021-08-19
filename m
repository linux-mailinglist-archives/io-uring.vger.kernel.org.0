Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509793F1F36
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 19:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhHSRgr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 13:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhHSRgq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 13:36:46 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3A9C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 10:36:10 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so1186130otg.11
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 10:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pZCJRJ/w1XakS99kOy6qC/oGQp1huXI23sYK6wMq4dQ=;
        b=koDj8A/ipnGUD66fxjU2Krd7Y1dJgJT2kjpg/p+Ov9aTzfNjkOPmpBCw9i6ceYvRa4
         nqYnjUYZTwWl1b0XVtavkFs8uovjQUuKbfPJ1fc+OJU+y4/3YgmsgLoZDQxpjQS6kAmV
         y82TF29k1tqvm83Mto49L86n/xdKMfnfVu13UzJCIx6+K6FFr1fceq0SQrWBzg01/ZGI
         2l9d4crr9EQ8TEsyOKUaOShRdZ6MDZJlbfxEV9vl5/BQLW3F6yeXvlLUV8EfjNibJM45
         thP5Glb8uev9rY9smJSGjhofshZtCbM/bNTncOd7YkIi3teIU6xiV702lyHfREkH8VH4
         Ydvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZCJRJ/w1XakS99kOy6qC/oGQp1huXI23sYK6wMq4dQ=;
        b=gRphcIzXZ6rACX7wisSmWiaBDWSfWT/KomVLRUkrpt1oRkT5coLmYSX16nx1CceVHh
         DWyL2WR0uqCqf97WTtkNc1lH50LQhgV5bkxHg6rWpYhNkYQ89+ZAnyGPvy09tpybuLDl
         ju0Ib1e5hYSl4LCTnGyOXmuM36eJ25LVwtYnSHwy7dqNNt88eWjMLgZQZlydC/fjDo0f
         2oK1p6Juqf92W9Znb0sV8WFxTZ9MCZxrxQMk6MSlU9iI3QXmYFj6YPpb8uVvgqKtyzvA
         u21+aJdNtg1mkmXymEHJWAk7mKIok2uYgRtn9+5EyEX7Xi3xUiEk/hwEK6qChXuiNEz2
         hAaQ==
X-Gm-Message-State: AOAM5320PBefsyammabSjrUvPk4xGPLJYhjD6rMqil2D2+44lv1LwL+c
        R9SMsW6lwPRtr7cvyQSuLLry31/6eBMOg/HY
X-Google-Smtp-Source: ABdhPJx46jyZjrefL9L7fyDVtSWcBh6tmfkm56tqMGkFTW2Frg6EzCDGMKHrGO1fPVISmoJ/36kQHw==
X-Received: by 2002:a9d:5f0e:: with SMTP id f14mr12906742oti.107.1629394569514;
        Thu, 19 Aug 2021 10:36:09 -0700 (PDT)
Received: from [192.168.1.170] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p64sm807757oih.29.2021.08.19.10.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 10:36:09 -0700 (PDT)
Subject: Re: [PATCH] io_uring: remove PF_EXITING checking in io_poll_rewait()
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
References: <0d53b4d3-b388-bd82-05a6-d4815aafff49@kernel.dk>
 <71755898-060a-6975-88b8-164fc3fff366@linux.alibaba.com>
 <f2c01919-d8c8-3750-c926-13fbee14eed7@kernel.dk>
Message-ID: <5df6fdf4-dc27-7ee5-d4d5-b48ab30c809c@kernel.dk>
Date:   Thu, 19 Aug 2021 11:36:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f2c01919-d8c8-3750-c926-13fbee14eed7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 11:29 AM, Jens Axboe wrote:
> On 8/19/21 11:26 AM, Hao Xu wrote:
>> 在 2021/8/19 下午11:48, Jens Axboe 写道:
>>> We have two checks of task->flags & PF_EXITING left:
>>>
>>> 1) In io_req_task_submit(), which is called in task_work and hence always
>>>     in the context of the original task. That means that
>>>     req->task == current, and hence checking ->flags is totally fine.
>>>
>>> 2) In io_poll_rewait(), where we need to stop re-arming poll to prevent
>>>     it interfering with cancelation. Here, req->task is not necessarily
>>>     current, and hence the check is racy. Use the ctx refs state instead
>>>     to check if we need to cancel this request or not.
>> Hi Jens,
>> I saw cases that io_req_task_submit() and io_poll_rewait() in one
>> function, why one is safe and the other one not? btw, it seems both two
>> executes in task_work context..and task_work_add() may fail and then
>> work goes to system_wq, is that case safe?
> 
> io_req_task_submit() is guaranteed to be run in the task that is req->task,
> io_poll_rewait() is not. The latter can get called from eg the poll
> waitqueue handling, which is not run from the task in question.

Pavel nudged me, and in the 5.15 branch we actually only do run rewait
from the task itself. So this patch isn't needed, we can ignore it!
Might just augment it with a comment, like it was done for submit.

-- 
Jens Axboe

