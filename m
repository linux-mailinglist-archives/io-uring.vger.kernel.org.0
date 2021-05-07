Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05D43767D8
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 17:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhEGPXL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 11:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhEGPXK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 11:23:10 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2E8C061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 08:22:11 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j20so7946516ilo.10
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 08:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lFPrcYPeOUCw/PCayoyGOwZGVDgv/b6+pP7sJap5ano=;
        b=lyZ1vg/D4TE2PmgTJLwLA0zt1vSS/0zvqUumOO8PBtCayIqYYErTXZTyxdkGTm5OOe
         o/LasHMY/34URYilScQPEfQt4ZJ7g9vdHtBwhxvq3u9EOzHvdn6Igy1acl90I5TlDeFu
         JXEipAxka5PmQe4O0X5aiG/qR4/HVKs9HEeDLbH4gIrKhk0b02Y/4O1+pmiLzeySvMsN
         zmRcboOnS/aL2AQrv0egmilyK6tRVXTHI9ThxtSyV4SagpLXIcQxrJKsp9BhWki1+I2P
         0V+RZsglamhpF7QOgX+HAC8vYoVXKD4JX+9eCh/hs4cvygKpO1gXBeaYcL9KJSZlDrxR
         Gg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lFPrcYPeOUCw/PCayoyGOwZGVDgv/b6+pP7sJap5ano=;
        b=tv5Vq7rStyqA1q4iZbTefkXBisSV1Lx/XOf8fPqEflepUwWQ5H5OJy5HdLapa4beYq
         13sWElO1REt3vYutZlm/qeRhRqMMHiztT7hLsCt/O9M+6/UwBcci4PECuq2hxcfuicNL
         Tw3L16ZNXdCqXYXvAnAHxnNgKRLfqExZO+42o2M1Vewog+wHhHKTFoTHXobDrxXUxofw
         ulhWGkfoDLa8Ac7bixbVYdLedie99xsAX6guA9i18StXs/0j+uZaFw917U8NnmycJROl
         s+E9CRvS9rX9J/aWYfbk7QjwnbDywAPpFslnsxVTKZ8N8wF1WwIMwW3fNlQqIpcWr/fW
         myIA==
X-Gm-Message-State: AOAM5329X1OP5NLeDQ2e4DR11smAtrmgiAtl44hOVAirocBowA9x97io
        4759lkTnGDYDrmT24lBGHsbyLQ==
X-Google-Smtp-Source: ABdhPJzBADXJyn6ULwoJca6f6qW4YwotrYRrCzeDOm7+dEVzZlaVMm8MJrntd1xj/loSbX5YNOW+xA==
X-Received: by 2002:a92:611:: with SMTP id x17mr9557619ilg.239.1620400930374;
        Fri, 07 May 2021 08:22:10 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f9sm2352117iol.23.2021.05.07.08.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 08:22:10 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13] io_uring: add IORING_REGISTER_PRIORITY
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1620311593-46083-1-git-send-email-haoxu@linux.alibaba.com>
 <38e587bb-a484-24dc-1ea9-cc252b1639ba@kernel.dk>
 <92da0bd6-3de9-eedd-fca7-87d8ad99ba70@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <685bc9d9-3d31-6534-4eb0-293257bf49be@kernel.dk>
Date:   Fri, 7 May 2021 09:22:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <92da0bd6-3de9-eedd-fca7-87d8ad99ba70@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/21 1:20 PM, Hao Xu wrote:
> 在 2021/5/7 上午1:10, Jens Axboe 写道:
>> On 5/6/21 8:33 AM, Hao Xu wrote:
>>> Users may want a higher priority for sq_thread or io-worker. Provide a
>>> way to change the nice value(for SCHED_NORMAL) or scheduling policy.
>>
>> Silly question - why is this needed for sqpoll? With the threads now
>> being essentially user threads, why can't we just modify nice and
>> scheduler class from userspace instead? That should work now. I think
>> this is especially true for sqpoll where it's persistent, and argument
>> could be made for the io-wq worker threads that we'd need io_uring
>> support for that, as they come and go and there's no reliable way to
>> find and tweak the thread scheduler settings for that particular use
>> case.
>>
>> It may be more convenient to support this through io_uring, and that is
>> a valid argument. I do think that the better way would then be to simply
>> pass back the sqpoll pid after ring setup, because then it'd almost be
>> as simple to do it from the app itself using the regular system call
>> interfaces for that.
>>
> Hi Jens,
> It's my bad. I didn't realize this until I almost completed the patch,
> then I looked into io_uring_param, found just __u32 resv[3] can be
> leveraged. Not sure if it's neccessary to occupy one to do this, so I
> still sent this patch for comments.
>> In summary, I do think this _may_ make sense for the worker threads,
>> being able to pass in this information and have io-wq worker thread
>> setup perform the necessary tweaks when a thread is created, but it does
> I'm working on this(for the io-wq worker), have done part of it.
>> seem a bit silly to add this for sqpoll where it could just as easily be
>> achieved from the application itself without needing to add this
> It's beyond my knowledge, correct me if I'm wrong: if we do
> it from application, we have to search the pid of sq_thread by it's name
> which is iou-sqp-`sqd->task_pid`, and may be cut off because of
> TASK_COMM_LEN(would this macro value be possibly changed in the
> future?). And set_task_comm() is called when sq_thread runs, so there is
> very small chance(but there is) that set_task_comm() hasn't been called
> when application try to get the command name of sq_thread. Based on this
> (if it is not wrong...) I think return pid of sq_thread in io_uring
> level may be a better choice.

Right, as mentioned in my email, we'd want to return the pid to both
make it easier and reliable to perform this action for the sqpoll
thread. Otherwise it's a bit of a mess in the application with having to
look it up, even if we enure we set task comm before the thread is live.
Having to lookup through that is very ugly, and I would not want the
application to do that.

But returning the pid would be a trivial change... We already copy the
params back, we can just stuff it in there. Either as a new member, or
re-use one of the existing sqthread members as they don't return any
information currently.

-- 
Jens Axboe

