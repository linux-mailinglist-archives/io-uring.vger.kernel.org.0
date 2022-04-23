Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3062E50C7FC
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 09:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiDWHV7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 03:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiDWHV6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 03:21:58 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A41314B2EA
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 00:19:03 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d15so1165387plh.2
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 00:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:references:from
         :in-reply-to:content-transfer-encoding;
        bh=US1oNWZGB1bZhIl5xysm01n5BsU6qK+ozXuTHSS2Ux4=;
        b=IfTV4Bbsh/3TxtGtnWAN3npX4I9Xe69OJRRdb4aWiC68qeZG2BWIxDOeRQeKl/ticH
         5Yn8QYkGZ5WoIuiX/b0u0kzn94isB1rD0a88o6V93U0WwgNVZgjiY6iqsRLc9glTIXMv
         zzYBQr/DS2hJ7ztYqotlDlECujuTK8LmM1ymG12vw0Aged3xsLqHMaMLtpkxSe8FHpZj
         jq/URQgPT60f81UQYcYHuRlhVr60cMorBIaXgI6fzVSMtN2DJwKqdY5xPXIi9dlqZ7sK
         jLZNK9TgocmjvM19DgQo006ejZ9u8zQLcFD8pF0j4DwndMON8nTDvRu3Yd2Or2Vy9s6f
         NP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:references:from:in-reply-to:content-transfer-encoding;
        bh=US1oNWZGB1bZhIl5xysm01n5BsU6qK+ozXuTHSS2Ux4=;
        b=0L0dqHFBeOHiYZeN6WxAVdo4AE92pLHt48DDiSIc75uj09SFm37q8oen+VcJVeEgnP
         kYNf7x7CfmopUCLWawh0u0ADZjELiFo46sn8hlv20ybj/uRFGB3HWCEFN8yqDe2Y79ta
         Bk+RPSxsNBUWUfZZ88fqzwqYYUgoDByBnZ/0OmwH8aoWvaGLLfQ34YX0DWGDq00wT97c
         7O9Dx5m9y2rEmTzaG6KmYaJ+lNm2MtyzsCBz5lrFWvKQHEQSuQdA8Nj6tYRhYcwzwJho
         pxnfDhMt/TL0HhArm9tImd7XescsjVip9TtAXgVy8Jywe/nex/lY6qgLLgQWpWjDW/wM
         Kciw==
X-Gm-Message-State: AOAM533UxISAY6ftXwBmxWauQEz6/ZQ7YPPJx1evF6Ts/l425FBvkWGY
        /HRe45ochh7N6gW+9GfKrgc=
X-Google-Smtp-Source: ABdhPJxSI4WnMN84wDw4QPyeu5qNizw5jjhdKdtA0VhjNJ/0quaTAJlYiIC7qtivHh22grI24VFJHA==
X-Received: by 2002:a17:90b:1b45:b0:1d2:d46f:57d4 with SMTP id nv5-20020a17090b1b4500b001d2d46f57d4mr9633923pjb.214.1650698342467;
        Sat, 23 Apr 2022 00:19:02 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id ca11-20020a056a00418b00b0050a55c55fe5sm4512303pfb.75.2022.04.23.00.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 00:19:02 -0700 (PDT)
Message-ID: <84d6985f-4b0f-13b0-14c4-82921c81dd59@gmail.com>
Date:   Sat, 23 Apr 2022 15:19:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: memory access op ideas
To:     Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>,
        io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <9fef64ff-d13d-f9ff-a230-0d8fe928097e@gmail.com>
 <0bc0f745-96d4-cedc-c502-67122bc878d1@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <0bc0f745-96d4-cedc-c502-67122bc878d1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 4/22/22 9:38 PM, Jens Axboe 写道:
> On 4/22/22 6:52 AM, Hao Xu wrote:
>> Hi Avi,
>> ? 4/13/22 6:33 PM, Avi Kivity ??:
>>> Unfortunately, only ideas, no patches. But at least the first seems very easy.
>>>
>>>
>>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op itself (1-8 bytes) to a user memory location specified by the op.
>>>
>>>
>>> Linked to another op, this can generate an in-memory notification useful for busy-waiters or the UMWAIT instruction
>>>
>>>
>>> This would be useful for Seastar, which looks at a timer-managed memory location to check when to break computation loops.
>>>
>>>
>>> - IORING_OP_MEMCPY - asynchronously copy memory
>>>
>>>
>>> Some CPUs include a DMA engine, and io_uring is a perfect interface to exercise it. It may be difficult to find space for two iovecs though.
>>
>> I have a question about the 'DMA' here, do you mean DMA device for
>> memory copy? My understanding is you want async memcpy so that the
>> cpu can relax when the specific hardware is doing memory copy. the
>> thing is for cases like busy waiting or UMAIT, the length of the memory
>> to be copied is usually small(otherwise we don't use busy waiting or
>> UMAIT, right?). Then making it async by io_uring's iowq may introduce
>> much more overhead(the context switch).
> 
> Nothing fast should use io-wq. But not sure why you think this would
> need it, as long as you can start the operation in a sane fashion and
> get notified when done, why would it need io-wq?
Ah, yes, forgot the some basic logic while sending the email.
> 

