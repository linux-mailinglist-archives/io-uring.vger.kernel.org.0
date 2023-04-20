Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B69C6E9853
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 17:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjDTPbs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 11:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjDTPbr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 11:31:47 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A320B40D2
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 08:31:46 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dm2so7260880ejc.8
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 08:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682004705; x=1684596705;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KK1/RmT8+lpgI/pTT2ZMZldC4R02ExSdLWBsBLwKly4=;
        b=CyhoggHHu7+IimLsrB++mRd/+2uu7N+5RUl9VRw4YGTIH7wPHbFZZhKgUWc2taI7T/
         2cwt9ABfdVZUOxoSaY7LintrgF5FAPrfALJzeJOL63TvajKOji53Q4UbikSnUD67XAPi
         9RKN7Q2cWticJZ5d1Nb2ZuyZt65Xns9YhzEKtIinbb8HRlbBHfdrurz4K3snUTPLm+aw
         FHklyKIdKPFoaNkpwM9NqO54aVRV8HEc/zCJ8gAaDOmsL89fzUdoqHh8Mo0RhcCi8KAb
         qsP2oyY7Ln2ve6zrmQi674+GyQyJd4CZI61LFdQqRoDFNdmt/yOs1WWuHQ53wUYDzPhq
         z1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682004705; x=1684596705;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KK1/RmT8+lpgI/pTT2ZMZldC4R02ExSdLWBsBLwKly4=;
        b=bqnEYGJn0rJalWe+gD9LEs2o0n1oZ2LOtXTgFovxDCjJh30Me7Wy8ptk5ZRy88BWTG
         5v2TsVrKs8c2xDVx0lKMD94cIsPngiGZfgiXRMYN649/I+l/kpSUrzz0LrmVb/aa+ubY
         uVoyEkqnHaRidUwydh7m2oc+b90yzov/yXNEoMp5898+CiJEGV3zDrmHso7DH0NS1aMD
         crF1iY+YJ2RneSc+puvPgWPMKiBXhAnGIzqSHnZGtcTW1PI+DzUD8GKTqZdt6cN3Hxv8
         a+g+S4vlqAIvPqruZiy+RTRs/7vC4WBNPn+ImA9imH/s6Y/fRy2XQmLsgzCPFjkI3M9y
         AWRA==
X-Gm-Message-State: AAQBX9fiZLvp+BZ17JR8y334PtLY1XkV7Jl7y0l4h4JPspsVQggr97Hu
        ZAyIQV+Lcto5T9OdQ1Aoif6cCSxNhEw=
X-Google-Smtp-Source: AKy350YSsU+r8LJNkCtxgOY5ECg94wG4YqL3XwlmjcIv1AuAR44VXuD2kLOXjxNOn4tDHWaYyrDvyg==
X-Received: by 2002:a17:906:a057:b0:8b1:7ae8:ba6f with SMTP id bg23-20020a170906a05700b008b17ae8ba6fmr1838997ejb.16.1682004704917;
        Thu, 20 Apr 2023 08:31:44 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:7db2])
        by smtp.gmail.com with ESMTPSA id l3-20020a170906230300b0094e7d196aa4sm853125eja.160.2023.04.20.08.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 08:31:44 -0700 (PDT)
Message-ID: <b5b427e3-77b5-6ed8-6dcd-cd2b789735a7@gmail.com>
Date:   Thu, 20 Apr 2023 16:28:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCHSET 0/6] Enable NO_OFFLOAD support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com
References: <20230419162552.576489-1-axboe@kernel.dk>
 <1f57b637-e0b5-2954-fa34-ff2672f55787@gmail.com>
 <3a273417-762c-da28-b918-e79eae0dc3f4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3a273417-762c-da28-b918-e79eae0dc3f4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/23 16:08, Jens Axboe wrote:
> On 4/19/23 6:43?PM, Pavel Begunkov wrote:
>> On 4/19/23 17:25, Jens Axboe wrote:
>>> Hi,
>>>
>>> This series enables support for forcing no-offload for requests that
>>> otherwise would have been punted to io-wq. In essence, it bypasses
>>> the normal non-blocking issue in favor of just letting the issue block.
>>> This is only done for requests that would've otherwise hit io-wq in
>>> the offload path, anything pollable will still be doing non-blocking
>>> issue. See patch 3 for details.
>>
>> That's shooting ourselves in the leg.
>>
>> 1) It has never been easier to lock up userspace. They might be able
>> to deal with simple cases like read(pipe) + write(pipe), though even
>> that in a complex enough framework would cause debugging and associated
>> headache.
>>
>> Now let's assume that the userspace submits nvme passthrough requests,
>> it exhausts tags and a request is left waiting there. To progress
>> forward one of the previous reqs should complete, but it's only putting
>> task in tw, which will never be run with DEFER_TASKRUN.
>>
>> It's not enough for the userspace to be careful, for DEFER_TASKRUN
>> there will always be a chance to get locked .
>>
>> 2) It's not limited only to requests we're submitting, but also
>> already queued async requests. Inline submission holds uring_lock,
>> and so if io-wq thread needs to grab a registered file for the
>> request, it'll io_ring_submit_lock() and wait until the submission
>> ends. Same for provided buffers and some other cases.
>>
>> Even task exit will actively try to grab the lock.
> 
> One thing I pondered was making the inline submissions similar to io-wq
> submissions - eg don't hold uring_lock over them. To make useful, I
> suspect we'd want to prep all SQ entries upfront, and then drop for
> submission.

That would need completion caches (ctx->submit_state) to be changed,
either by allowing multiple of them or limiting by some other mean
to only 1 inline submitter. Also, that will probably return the
request refcounting back, and DEFER_TASKRUN would probably need
to retake the lock for execution unless there are magic tricks
around it. Not an easy task if we don't want to hurt performance.


> We'd also want to make this mutually exclusive with IOPOLL, obviously.
> Doesn't make any sense to do anyway for IOPOLL, but it needs to be
> explicitly disallowed.

-- 
Pavel Begunkov
