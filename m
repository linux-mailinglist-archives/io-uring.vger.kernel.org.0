Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C064DDCA9
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbiCRPWb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 11:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbiCRPWa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 11:22:30 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC071227C70
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:21:10 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id x4so9609132iop.7
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=OIVVSfYFT8uQ0iBf/GiRPnxD+yRyF19C6hSpBLcBXNg=;
        b=nY0q3H4FjGjiffIZuHg6E5CTJMnyUzsvY0Z6q2zMbvmF3+fOCOtDsUbp2TDkA2kfiF
         gOA8Td7S182P4JNTrP6bhrEsLUWVWjXs5gd5b5iXfqkpXt5Md0mrgsZ1wQD/rlq2HM9s
         Jxd1lvXlj24j7lroCuOuL2b/nUdbRtGcdT9YLWBovouyaN4teihDgmB0BrOmWa7bnMmV
         RJO8kHlgKrPV7L281o8Dk+vhkpoo5D5HioOSURWK0rXSBvefWEgHFjvTWeaxflPbHSYM
         7tlhsSbGu1Jv2oXUH9In/cwwray1P12bO4D/SQUOX4ZMpz39TukD+ggEtIno4pkv/3AW
         EVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OIVVSfYFT8uQ0iBf/GiRPnxD+yRyF19C6hSpBLcBXNg=;
        b=4fRqUc9nXYgQQGWl78Kg41L+ZsOD0dG4FO1pOybXV63K5vbjfJE9POrBD0/T4ErO7o
         NEKJ5TE6hzeVOTFMfp+aRjMTNOGROP+jwuKQDR/LSb6UZ88NH7PMg5MmkVxokOrQh6yA
         GjzVhvLFyv0C3HQfnYpa73lc/yLxkDS8OdJl9THjd5VXQrCzJIaBx501hKUVAkMaqyCH
         QHUebdTOQOJkHXOdtSai86pKSeLe3Job+9LxlYIhdx4kkZgESEtl7YOZoRkDmrXTq/s9
         waRfPoqXiBcFYao95WgdWFp1kkaWOI9Z3l1U/gci7ivVdQxU0S7/ATEkOrE9nXKIzCzr
         ufxw==
X-Gm-Message-State: AOAM532HDih/LEQntoqi7elblYXcgfD8Q18tOCud95HABfaTHDmZeYed
        cJdkLU7Y8k2v/AOk1v05+wHcwFwFS0g/m1J1
X-Google-Smtp-Source: ABdhPJzGyYUhGPxRGKFhYUJcRYxFIqzB+hwM3beKociI7Tom/EgduIneFK50rqm8y+YfslyAh0v7cA==
X-Received: by 2002:a05:6638:d93:b0:317:ca63:2d38 with SMTP id l19-20020a0566380d9300b00317ca632d38mr4888395jaj.171.1647616869951;
        Fri, 18 Mar 2022 08:21:09 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i8-20020a0566022c8800b006463c801381sm4856147iow.48.2022.03.18.08.21.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 08:21:09 -0700 (PDT)
Message-ID: <ce480edd-c82b-c094-39cd-d45d6b76e5a3@kernel.dk>
Date:   Fri, 18 Mar 2022 09:21:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 4/4] io_uring: optimise compl locking for non-shared rings
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1647610155.git.asml.silence@gmail.com>
 <9c91a7dc445420230f7936d7f913eb212c1c07a3.1647610155.git.asml.silence@gmail.com>
 <3530662a-0ae0-996c-79ee-cc4db39b965a@kernel.dk>
 <7ef3335a-8e7c-d559-5a78-f48bf506f53c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7ef3335a-8e7c-d559-5a78-f48bf506f53c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/22 9:13 AM, Pavel Begunkov wrote:
> On 3/18/22 14:54, Jens Axboe wrote:
>> On 3/18/22 7:52 AM, Pavel Begunkov wrote:
>>> When only one task submits requests, most of CQEs are expected to be
>>> filled from that task context so we have natural serialisation. That
>>> would mean that in those cases we don't need spinlocking around CQE
>>> posting. One downside is that it also mean that io-wq workers can't emit
>>> CQEs directly but should do it through the original task context using
>>> task_works. That may hurt latency and performance and might matter much
>>> to some workloads, but it's not a huge deal in general as io-wq is a
>>> slow path and there is some additional merit from tw completion
>>> batching.
>>
>> Not too worried about io-wq task_work for cq filling, it is the slower
>> path after all. And I think we can get away with doing notifications as
>> it's just for CQ filling. If the task is currently waiting in
>> cqring_wait, then it'll get woken anyway and it will process task work.
>> If it's in userspace, it doesn't need a notification. That should make
>> it somewhat lighter than requiring using TIF_NOTIFY_SIGNAL for that.
>>
>>> The feature should be opted-in by the userspace by setting a new
>>> IORING_SETUP_PRIVATE_CQ flag. It doesn't work with IOPOLL, and also for
>>> now only the task that created a ring can submit requests to it.
>>
>> I know this is a WIP, but why do we need CQ_PRIVATE? And this needs to
> 
> One reason is because of the io-wq -> tw punting, which is not optimal
> for e.g. active users of IOSQE_ASYNC. The second is because the
> fundamental requirement is that only one task should be submitting
> requests. Was thinking about automating it, e.g. when we register
> a second tctx we go through a slow path waiting for all current tw
> to complete and then removing an internal and not userspace visible
> CQ_PRIVATE flag.

Was thinking something along those lines too. The alternative is setting
up the ring with SETUP_SINGLE_ISSUER or something like that, having the
application tell us that it is a single issuer and no submits are
shared across threads. Serves the same kind of purpose as CQ_PRIVATE,
but enables us to simply fail things if the task violates those
constraints. Would also be a better name I believe as it might enable
further optimizations in the future, like for example the mutex
reduction for submits.

> Also, as SQPOLL task is by definition the only one submitting SQEs,
> was thinking about enabling it by default for them, but didn't do
> because of the io-wq / IOSQE_ASYNC.

Gotcha.

>> work with registered files (and ring fd) as that is probably a bigger
>> win than skipping the completion_lock if you're not shared anyway.
> 
> It does work with fixed/registered files and registered io_uring fds.

t/io_uring fails for me with registered files or rings, getting EINVAL.
Might be user error, but that's simply just setting CQ_PRIVATE for
setup.

> In regards of "a bigger win", probably in many cases, but if you submit
> a good batch at once, and completion tw batching doesn't kick in (e.g.
> direct bdev read of not too high intensity), it might save
> N spinlock/unlock when registered ring fd would kill only one pair of
> fdget/fdput.

Definitely, various cases where one would be a bigger win than the
other, agree on that. But let's just ensure that both work together :-)

-- 
Jens Axboe

