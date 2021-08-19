Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AB73F1F40
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 19:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhHSRhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 13:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbhHSRhk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 13:37:40 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E911C061756
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 10:37:04 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id o185so9470293oih.13
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 10:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=h2KmX+Kt8F7IOcAiRQHlpKyDyafw+L8RGoEwse7djnk=;
        b=FZFxLQed4zORttIxoma/QDpyC/TGWqmrA4m9ZwZDs3KTd5qxmEZ+UsLrC3rujVmizR
         CuR1o2mXQFwYov/ygV/i5iArLmbSILRjA1PjmocyeaghsPLRjlPrcPUDDBl7W9YUtss0
         esFBVmAbAEMsmnvPfSgHP/WwcTJp9YyiJfMtLHyzDT79MX2aXdq/H/5uJiBZeK3bPrw5
         dofmARgIk2XKKnUM5K4yXihBRBwnyWWjhpL/mQ115+ggiBcAVTB4RXKTU3YF9AGFEAvA
         i2FRGa5MjbDAcQASCK1sn23JDNaVvb0671AoeQDsuLIjeNnuc1/Pj+b4A0mHeXfwAbJf
         Hjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h2KmX+Kt8F7IOcAiRQHlpKyDyafw+L8RGoEwse7djnk=;
        b=laapuZm5ou+lRHDJP8UlZjpCLJEg6nY1yO9FBbDru40ZX6kT5oq3fzMlKhApkW8wXC
         Iyb73q4VUYRD2b5AxPQMdXGAZcYMSWQZ8l7JnmXJzPuc3++ta6hAOU1sPq5q1VmAetkq
         PgDyC9VvyqvDh8aXPDcym1wHc87bLycwiLeUj36PKfSDAt0GrLPy10rtg8DrU8agFrY7
         JdJlVty+LsIMSbUDmJvlRUK+uARV5j6gQ40TyPVLm4E1OtWEEqR4jgjxeIL8LmCFk/KH
         oor+RXcGyxRySAywIVt/ZRQJfAkytoDX4UXxwt+4Er9rG6WexCD3bkpvl56awv5L32HK
         PKQA==
X-Gm-Message-State: AOAM533pGRCyc2JyvallSBqnPfiACES/o5LOxpSIpmSIvjRgYyAMNyqf
        ITpCME9L1JXYSidl1TsAdSrNqdbfFcoRJWIL
X-Google-Smtp-Source: ABdhPJyNSKxK+nltQIG20VF/OccO7JZtLmRU2JlRHTrSB/A/y54gV4O20vOhnNDOqS50XKBUIKzGtQ==
X-Received: by 2002:a05:6808:68d:: with SMTP id k13mr3508994oig.83.1629394623267;
        Thu, 19 Aug 2021 10:37:03 -0700 (PDT)
Received: from [192.168.1.170] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u19sm731471oof.30.2021.08.19.10.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 10:37:03 -0700 (PDT)
Subject: Re: [PATCH] io_uring: remove PF_EXITING checking in io_poll_rewait()
To:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
References: <0d53b4d3-b388-bd82-05a6-d4815aafff49@kernel.dk>
 <71755898-060a-6975-88b8-164fc3fff366@linux.alibaba.com>
 <f2c01919-d8c8-3750-c926-13fbee14eed7@kernel.dk>
 <6e8d52e3-1f44-d2fd-5377-aefdeb90b011@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9427231f-b14c-510f-0628-37bd0a00a9d8@kernel.dk>
Date:   Thu, 19 Aug 2021 11:37:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6e8d52e3-1f44-d2fd-5377-aefdeb90b011@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 11:36 AM, Hao Xu wrote:
> 在 2021/8/20 上午1:29, Jens Axboe 写道:
>> On 8/19/21 11:26 AM, Hao Xu wrote:
>>> 在 2021/8/19 下午11:48, Jens Axboe 写道:
>>>> We have two checks of task->flags & PF_EXITING left:
>>>>
>>>> 1) In io_req_task_submit(), which is called in task_work and hence always
>>>>      in the context of the original task. That means that
>>>>      req->task == current, and hence checking ->flags is totally fine.
>>>>
>>>> 2) In io_poll_rewait(), where we need to stop re-arming poll to prevent
>>>>      it interfering with cancelation. Here, req->task is not necessarily
>>>>      current, and hence the check is racy. Use the ctx refs state instead
>>>>      to check if we need to cancel this request or not.
>>> Hi Jens,
>>> I saw cases that io_req_task_submit() and io_poll_rewait() in one
>>> function, why one is safe and the other one not? btw, it seems both two
>>> executes in task_work context..and task_work_add() may fail and then
>>> work goes to system_wq, is that case safe?
> I've got answer for the second question..
>>
>> io_req_task_submit() is guaranteed to be run in the task that is req->task,
>> io_poll_rewait() is not. The latter can get called from eg the poll
>> waitqueue handling, which is not run from the task in question.
> I only found io_poll_rewait() call in io_async_task_func() and
> io_poll_task_func(), both are in task_work

Yeah see followup, my information was outdated, we only do rewait from the
right context at this point. Hence the PF_EXITING check is actually fine.

-- 
Jens Axboe

