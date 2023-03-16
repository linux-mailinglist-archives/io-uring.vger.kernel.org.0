Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3501F6BCF5F
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 13:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCPM1D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 08:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCPM1C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 08:27:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851C8B951C;
        Thu, 16 Mar 2023 05:27:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x13so7003434edd.1;
        Thu, 16 Mar 2023 05:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678969620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FMPnvazr+M7z4sZEE7rgBOYU1SkrFZ97M1BFgoNS8gw=;
        b=cnCIU0eqE26HcDU24iSiJg0ojw3gvWmnT5o+GNnM2pZLJ6StCW8oixYjGqCqtM8sLi
         CuaIHKHYKkydG6MR3NaflN92wYNDdby4MlI/Ko7J2nFxay7LacD3X4Qs/W3mMGC3abMI
         T0kImGkAKtkYZ2L+yoeE6s1enbieGnXpx8gnaYWrkwTXkYyGOq2cPxSyJA2qt7yJUgKc
         0sgoKvIhtlb5cFm7gOcR//9O053Eu9sj9xutx3v0LdDxZ3j8Az7dACiphaBHqbGllU58
         s8DIvki+CSpgqz3ALUvnaZqt9LNhsOGDau2/Cg9A2w2vSPns927OguoRE0kbQp0dmOaV
         SQgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678969620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMPnvazr+M7z4sZEE7rgBOYU1SkrFZ97M1BFgoNS8gw=;
        b=1GVnJ2DRvVcdLJrMecqjd7zKCFckrYwyQYTI2MTs79ucz4N3iPjx+0Sj4D3mBIwxDp
         cxQ5vlZJv382UdE7IOGbgK9dn0n0/KhCrs1PCa/0p3VkuxTMhj1nHh0VeH9vIKhxztCA
         y5zUmHi39J+4G6rxOjrNgeLbaRXp9kklqWHdOxRf5bBShCKzUxAmDp302dNiDl//Wtiu
         lhOIX1vGnj/3DD4s0t6P5qPn3I288Gaby4GdcgtqjxAI63b633eocbabmiJhza4xHkFA
         4kEVQrXzCNIs06A9BueEGRxZzO6Bd75/cF8Y2Bysh2BFyq4QEoxuU9U0eBgdsVw9S76e
         scRQ==
X-Gm-Message-State: AO0yUKXmViUw6eIK3vR8oF38pR0lKaEIsI/WkNeOQdZ8w/9pM3qSDxqf
        jehY+nkUlxjlBmNPZyIzOzPUIgt31EE=
X-Google-Smtp-Source: AK7set89MPgG9LNvjpKvJpjB5Cq3XHoTPOr7lXk0mwqkqLDeZ/FMi09O/bDr8GSECX4NHNpd77EO7A==
X-Received: by 2002:a17:907:9882:b0:91f:5845:4e31 with SMTP id ja2-20020a170907988200b0091f58454e31mr10966023ejc.26.1678969620026;
        Thu, 16 Mar 2023 05:27:00 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id qa17-20020a170907869100b008cecb8f374asm3789152ejc.0.2023.03.16.05.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 05:26:59 -0700 (PDT)
Message-ID: <7d533b7f-17e3-96e4-4fcb-f9bc4ce5e0ed@gmail.com>
Date:   Thu, 16 Mar 2023 12:25:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
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

Tried it out. No difference with bs=512, qd=4 is completed before
it gets to schedule() in io_cqring_wait(). With QD32, it's local tw run
__io_run_local_work() spins 2 loops, and QD=8 somewhat in the middle
with rare extra sched.

For bs=4096 QD=8 I see a lot of:

io_cqring_wait() @min_events=8
schedule()
__io_run_local_work() nr=4
schedule()
__io_run_local_work() nr=4


And if we benchmark without and with the patch there is a nice
CPU util reduction.

CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
   0    1.18    0.00   19.24    0.00    0.00    0.00    0.00    0.00    0.00   79.57
   0    1.63    0.00   29.38    0.00    0.00    0.00    0.00    0.00    0.00   68.98

-- 
Pavel Begunkov
