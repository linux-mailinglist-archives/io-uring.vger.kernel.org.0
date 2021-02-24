Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEFA3235E4
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 03:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhBXCwF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 21:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhBXCwE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 21:52:04 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E9FC061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 18:51:18 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id g4so540517pgj.0
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 18:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cfrbrl5rKrzKQP6oy7BixifnnoAc0AqZgZJVhgFnqBc=;
        b=uh0/r2885xk3O/RcFbRwBWbvBHUcwdRnz+k57Kgsh+HMyTHN0lbI8nM/qFaJBw+ej7
         zz49EGMLcF6ajFnKE+e0v4Vbl6HAXlApnjnNVZuobH8DkbrN9vqBJXvv7Z2jJ8u/jxFn
         mDF0YpLtefWQkv5hRjQrqpBvNYP/9Yt4yTd496N0EU+vTtePxZqm9mUzgRNTp7OdohHw
         sVk018ZA0lGADROufzyac+mIe22gR9KEenhtVrps3L3Ku0dqb7dAGLMmMO8PzXPsALdb
         pAB4+vtHEwzbDLAxuQg/XbdjBbZFp28AUmMsqVSn+WJxNmWjxhX0CHa6dTCPPyOlPHQ2
         rWqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cfrbrl5rKrzKQP6oy7BixifnnoAc0AqZgZJVhgFnqBc=;
        b=aXaCH+cEFJLf/5G5yUEpCCmCJHskgMXX5TmO87RwrWfD+2gqKi8of8ho0MCloLZ0Fi
         eF2xxHlMRfXV9Kv4onQN7BaFcD9HksA/jgWzzZSsnWUyqz8XipXShJ29cEgHb5EdRu6j
         6cs29+yrSlaMz2tuaCXNjKLbvtcPNmXDXaQMxefVRbmUeYyoU/0stmHjhNDiBUrDzEEE
         i4BlW2uysQwwHBhQOdodWVh/kzvg+NhmcSbOJMVbPTTsy0oQ9bUcn/JDAlgbc9OgYJoL
         kseyFlAUbWtVsC7NEYr/ziR8JgJA7zyUVTwahFb7olZkXvjcBL0eqeZSSLDPWX0R3Yot
         IIlg==
X-Gm-Message-State: AOAM5336N+WRrJ6blkecvq3GFCKdIP2f0joY8HyZKqpa2uN9PSTBErQ8
        FC5lkvvXzSlXZktV5Jxhl1oWB3A13e4EpQ==
X-Google-Smtp-Source: ABdhPJy0EkuWfeiWaBIBCn3J0HdvOavx1sDiRFTtLqciGBKj5Bq0xgkEzhfbeawqPfF8WMaQiKCPmg==
X-Received: by 2002:aa7:96b0:0:b029:1e6:ef55:c4c8 with SMTP id g16-20020aa796b00000b02901e6ef55c4c8mr29231870pfk.40.1614135077242;
        Tue, 23 Feb 2021 18:51:17 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o11sm468001pjg.41.2021.02.23.18.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 18:51:16 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't issue reqs in iopoll mode when ctx is
 dying
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
 <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
 <3e3cb8da-d925-7ebd-11a0-f9e145861962@linux.alibaba.com>
 <f3081423-bdee-e7e4-e292-aa001f0937d1@gmail.com>
 <e185a388-9b7c-b01f-bcf9-2440d9024fd2@gmail.com>
 <754563ed-5b2b-075d-16f8-d980e51102e6@linux.alibaba.com>
 <215e12a6-1aa7-c56f-1349-bd3828b225f6@kernel.dk>
 <7f52ca3a-b456-582e-c3db-99d2d028042f@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6a09434b-f975-cc49-cc6a-a5d369be325b@kernel.dk>
Date:   Tue, 23 Feb 2021 19:51:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7f52ca3a-b456-582e-c3db-99d2d028042f@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/21 7:45 PM, Xiaoguang Wang wrote:
> hi,
> 
>> On 2/23/21 7:30 PM, Xiaoguang Wang wrote:
>>> hi Pavel,
>>>
>>>> On 08/02/2021 13:35, Pavel Begunkov wrote:
>>>>> On 08/02/2021 02:50, Xiaoguang Wang wrote:
>>>>>>>> The io_identity's count is underflowed. It's because in io_put_identity,
>>>>>>>> first argument tctx comes from req->task->io_uring, the second argument
>>>>>>>> comes from the task context that calls io_req_init_async, so the compare
>>>>>>>> in io_put_identity maybe meaningless. See below case:
>>>>>>>>        task context A issue one polled req, then req->task = A.
>>>>>>>>        task context B do iopoll, above req returns with EAGAIN error.
>>>>>>>>        task context B re-issue req, call io_queue_async_work for req.
>>>>>>>>        req->task->io_uring will set to task context B's identity, or cow new one.
>>>>>>>> then for above case, in io_put_identity(), the compare is meaningless.
>>>>>>>>
>>>>>>>> IIUC, req->task should indicates the initial task context that issues req,
>>>>>>>> then if it gets EAGAIN error, we'll call io_prep_async_work() in req->task
>>>>>>>> context, but iopoll reqs seems special, they maybe issued successfully and
>>>>>>>> got re-issued in other task context because of EAGAIN error.
>>>>>>>
>>>>>>> Looks as you say, but the patch doesn't solve the issue completely.
>>>>>>> 1. We must not do io_queue_async_work() under a different task context,
>>>>>>> because of it potentially uses a different set of resources. So, I just
>>>>>>> thought that it would be better to punt it to the right task context
>>>>>>> via task_work. But...
>>>>>>>
>>>>>>> 2. ...iovec import from io_resubmit_prep() might happen after submit ends,
>>>>>>> i.e. when iovec was freed in userspace. And that's not great at all.
>>>>>> Yes, agree, that's why I say we neeed to re-consider the io identity codes
>>>>>> more in commit message :) I'll have a try to prepare a better one.
>>>>>
>>>>> I'd vote for dragging -AGAIN'ed reqs that don't need io_import_iovec()
>>>>> through task_work for resubmission, and fail everything else. Not great,
>>>>> but imho better than always setting async_data.
>>>>
>>>> Hey Xiaoguang, are you working on this? I would like to leave it to you,
>>>> If you do.
>>> Sorry, currently I'm busy with other project and don't have much time to work on
>>> it yet. Hao Xu will help to continue work on the new version patch.
>>
>> Is it issue or reissue? I found this one today:
>>
>> https://lore.kernel.org/io-uring/c9f6e1f6-ff82-0e58-ab66-956d0cde30ff@kernel.dk/
> Yeah, my initial patch is similar to yours, but it only solves the bug described
> in my commit message partially(ctx is dying), you can have a look at my commit message
> for the bug bug scene, thanks.

Are you sure? We just don't want to reissue it, we need to fail it.
Hence if we catch it at reissue time, that should be enough. But I'm
open to clue batting :-)

-- 
Jens Axboe

