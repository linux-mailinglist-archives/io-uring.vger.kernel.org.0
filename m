Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726046B6099
	for <lists+io-uring@lfdr.de>; Sat, 11 Mar 2023 21:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCKUqJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Mar 2023 15:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCKUqI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Mar 2023 15:46:08 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628504A1C3;
        Sat, 11 Mar 2023 12:46:07 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso8384273wmi.4;
        Sat, 11 Mar 2023 12:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678567566;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YU3gC3e1vJQ0laUGrTRI2BWJxIlCEPpJlTbALFyZKiE=;
        b=EtqMxfvY21UUr7QecZtyr5/geGGqEC4W9MhYPAjSoCm6gOYLJQxeu20PJFDCeHtlXp
         5wiqQnCrUu7vyE4DOdMy78il+cjw20o233Pq/rpUs5d8k3+48glyCS4u25h4M3GOJXUG
         d9UfKoWhJYIsx650RK4uSpINp72NA/YfV/zCee/iagTgrzfxNq8tU8VyVCcrwZu/VU/N
         8eqZay0AeTV/eykbo5gi/Jluqvsnf9bN2o4ZV4DfBM+1pwESs4WosnZHiFXNwAihNbxU
         jP16Qy7TmrpODHE0ol4bo1d0XinJe9G2zLwGxSY2YpGNgJ7HDelg45wCjXz2YrZBy8MI
         byyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678567566;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YU3gC3e1vJQ0laUGrTRI2BWJxIlCEPpJlTbALFyZKiE=;
        b=R2tY6/HbtaoHl5lBC9RxiiS39DMcsNtWya2QVSMnV63DGcQijtmEU+exyAqI0zfaUC
         X89zAGKYvsQjx97k0nydKfdOXIVPbft+47fvbCuzkhzofyvkDDuBC7+/j1yE0kL3Z1Ve
         qysnqbp1/5PT+yU1sceyvl6nbXsNWxPHypBmWxxe1s2NM79YqO+FE9GTrqFbH253dtXY
         qOiryKrz1wvKkOrqYQQoNyb7ezcWTe/NYrsuMRWhyFbg3yvmJN1Y8MgwGT/0+Ix+362Z
         Tsd/1LUbuZHDhFjS9vdxeuoB68bh5AXCOiB70CdCXTuFg8fwzmNTqgearzx6MFA14Odx
         7CpQ==
X-Gm-Message-State: AO0yUKXVjoKJq04tlaAmG4SiI4y1FqOyqLkm7R37VWflQ2v5PhwJQ5DA
        thc5tZhvKjpbrH5xn7PheSHze5H8WoQ=
X-Google-Smtp-Source: AK7set/gSKDIsFYnQzjDnEjdDGwkhbCHaX+AQSGfsMrjnuJPIdTipn9lms9Dd/gfAzpjyjFL1LAjKg==
X-Received: by 2002:a05:600c:4450:b0:3eb:36fa:b791 with SMTP id v16-20020a05600c445000b003eb36fab791mr6206842wmn.31.1678567565714;
        Sat, 11 Mar 2023 12:46:05 -0800 (PST)
Received: from [192.168.8.100] (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id n25-20020a7bc5d9000000b003ecdbba95fdsm2490586wmk.23.2023.03.11.12.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 12:46:05 -0800 (PST)
Message-ID: <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
Date:   Sat, 11 Mar 2023 20:45:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
Content-Language: en-US
In-Reply-To: <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/23 17:24, Jens Axboe wrote:
> On 3/10/23 12:04?PM, Pavel Begunkov wrote:
>> io_uring extensively uses task_work, but when a task is waiting
>> for multiple CQEs it causes lots of rescheduling. This series
>> is an attempt to optimise it and be a base for future improvements.
>>
>> For some zc network tests eventually waiting for a portion of
>> buffers I've got 10x descrease in the number of context switches,
>> which reduced the CPU consumption more than twice (17% -> 8%).
>> It also helps storage cases, while running fio/t/io_uring against
>> a low performant drive it got 2x descrease of the number of context
>> switches for QD8 and ~4 times for QD32.
>>
>> Not for inclusion yet, I want to add an optimisation for when
>> waiting for 1 CQE.
> 
> Ran this on the usual peak benchmark, using IRQ. IOPS is around ~70M for
> that, and I see context rates of around 8.1-8.3M/sec with the current
> kernel.
> 
> Applied the two patches, but didn't see much of a change? Performance is
> about the same, and cx rate ditto. Confused... As you probably know,
> this test waits for 32 ios at the time.

If I'd to guess it already has perfect batching, for which case
the patch does nothing. Maybe it's due to SSD coalescing +
small ro I/O + consistency and small latencies of Optanes,
or might be on the scheduling and the kernel side to be slow
to react.

I was looking at trace_io_uring_local_work_run() while testing,
It's always should be @loop=QD (i.e. 32) for the patch, but
the guess is it's also 32 with that setup but without patches.

> Didn't take a closer look just yet, but I grok the concept. One
> immediate thing I'd want to change is the FACILE part of it. Let's call
> it something a bit more straightforward, perhaps LIGHT? Or LIGHTWEIGHT?

I don't really care, will change, but let me also ask why?
They're more or less synonyms, though facile is much less
popular. Is that your reasoning?

> I can see this mostly being used for filling a CQE, so it could also be
> named something like that. But could also be used for light work in the
> same vein, so might not be a good idea to base the naming on that.

-- 
Pavel Begunkov
