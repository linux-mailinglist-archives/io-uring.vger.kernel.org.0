Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A7373BF11
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 21:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjFWTq7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 15:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjFWTq6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 15:46:58 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039212718
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 12:46:56 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b5585e84b4so1567515ad.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 12:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687549615; x=1690141615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kvlrK1wxkFGK367UKBUXJTWo+IcfSGkVZ/cKhrGVKAY=;
        b=ZyHsGzKXpDJ6RPn+CL8q4/ifZ5P9nefxUnpT8FrfNRbLHa+SRhu1f5PaT4aKTVAiMl
         GClpmS8Sg4rT/gWJnExToW5j1Jx7RrMNG/Qxg+W4OEptMcOHWe4GdwpAeubiBFvrKMZy
         e4qhLadmvbefo3k1rclWL2D1Tx59cf9xg6LGW4gcaMrnnqZPyRcUmA7uU4oKWF1ZW013
         1/AsCAu5j0poGrkN6nFxO4TooiAQIFKCPygGL5WCUKOJeTGOBEJeasTVGCvotESx4N+R
         0NWxaR6tdu36HpOg5IlfLW0Jf+O4gedjtAFokVY1pt6cdyjXvoiyDTRELBhE9G5DjLgs
         MLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687549615; x=1690141615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kvlrK1wxkFGK367UKBUXJTWo+IcfSGkVZ/cKhrGVKAY=;
        b=E7s2Whu8wE0lTf7XC6EVF2YMilISG6YxQA7fERe5Bpo6hVuXfNwf2FVMc2ElxiHPRC
         vXOpPGWBm4WHjBJhe5I+prS9f7otRDSQIrKiumjW4fXHnfpprpnrlfTtjclm3++ijcLi
         utmqCL/qwSqCPsqs2bzNxpAIrByULLpDhB9oX8Vjlc20zlqoF2oTqYt1UIrSZdRRLoFs
         Vg5AForDgJ1Lw48Fm5PO12SjJEoUgaDOeUobMMHpZ1bdo26YlZ6DBUTG1r0TJcH9yjLl
         1u5Kd+Dun+D6KI+iDTOPc90y4VPdhUBomT/1acVb5/RvE0oOb7QVweuni1a6ywvA6hPg
         2j7g==
X-Gm-Message-State: AC+VfDyL0KHPb8UYJE02qw9gpX7uyNaEav7qO7itOg5QoafztoZ8tg+S
        5TuwkZ5ZTXpMPb5yJbmmqlnk0A==
X-Google-Smtp-Source: ACHHUZ7W9ykKqmJYZ0EbvUBZKAvicajOzdyH9LAv97ZIzlWtxsFVPYQFgD8a0srusm/1t0YdWU4SYw==
X-Received: by 2002:a17:903:2451:b0:1b0:34c6:3bf2 with SMTP id l17-20020a170903245100b001b034c63bf2mr27103839pls.5.1687549615435;
        Fri, 23 Jun 2023 12:46:55 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id iy22-20020a170903131600b001b04b1fae4dsm7590464plb.35.2023.06.23.12.46.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 12:46:54 -0700 (PDT)
Message-ID: <dbd09055-1fb7-66e1-2647-73b7cb4036b8@kernel.dk>
Date:   Fri, 23 Jun 2023 13:46:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5/6] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20230609183125.673140-1-axboe@kernel.dk>
 <20230609183125.673140-6-axboe@kernel.dk>
 <20230623190418.zx2x536uy7q5mtag@awork3.anarazel.de>
 <93ab1214-2415-1059-633e-b95b299287a3@kernel.dk>
 <20230623193433.bf5mnwfrm2x7ykep@awork3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230623193433.bf5mnwfrm2x7ykep@awork3.anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/23 1:34?PM, Andres Freund wrote:
> Hi,
> 
> On 2023-06-23 13:07:12 -0600, Jens Axboe wrote:
>> On 6/23/23 1:04?PM, Andres Freund wrote:
>>> Hi,
>>>
>>> I'd been chatting with Jens about this, so obviously I'm interested in the
>>> feature...
>>>
>>> On 2023-06-09 12:31:24 -0600, Jens Axboe wrote:
>>>> Add support for FUTEX_WAKE/WAIT primitives.
>>>>
>>>> IORING_OP_FUTEX_WAKE is mix of FUTEX_WAKE and FUTEX_WAKE_BITSET, as
>>>> it does support passing in a bitset.
>>>>
>>>> Similary, IORING_OP_FUTEX_WAIT is a mix of FUTEX_WAIT and
>>>> FUTEX_WAIT_BITSET.
>>>
>>> One thing I was wondering about is what happens when there are multiple
>>> OP_FUTEX_WAITs queued for the same futex, and that futex gets woken up. I
>>> don't really have an opinion about what would be best, just that it'd be
>>> helpful to specify the behaviour.
>>
>> Not sure I follow the question, can you elaborate?
>>
>> If you have N futex waits on the same futex and someone does a wait
>> (with wakenum >= N), then they'd all wake and post a CQE. If less are
>> woken because the caller asked for less than N, than that number should
>> be woken.
>>
>> IOW, should have the same semantics as "normal" futex waits.
> 
> With a normal futex wait you can't wait multiple times on the same futex in
> one thread. But with the proposed io_uring interface, one can.

Right, but you could have N threads waiting on the same futex.

> Basically, what is the defined behaviour for:
> 
>    sqe = io_uring_get_sqe(ring);
>    io_uring_prep_futex_wait(sqe, futex, 0, FUTEX_BITSET_MATCH_ANY);
> 
>    sqe = io_uring_get_sqe(ring);
>    io_uring_prep_futex_wait(sqe, futex, 0, FUTEX_BITSET_MATCH_ANY);
> 
>    io_uring_submit(ring)
> 
> when someone does:
>    futex(FUTEX_WAKE, futex, 1, 0, 0, 0);
>    or
>    futex(FUTEX_WAKE, futex, INT_MAX, 0, 0, 0);
> 
> or the equivalent io_uring operation.

Waking with num=1 should wake just one of them, which one is really down
to the futex ordering which depends on task priority (which would be the
same here), and ordered after that. So first one should wake the first
sqe queued.

Second one will wake all of them, in that order.

I'll put that in the the test case.

> Is it an error? Will there always be two cqes queued? Will it depend
> on the number of wakeups specified by the waker?  I'd assume the
> latter, but it'd be good to specify that.

It's not an error, I would not want to police that. It will purely
depend on the number of wakes specified by the wake operation. If it's
1, one will be triggered. If it's INT_MAX, then both of them will
trigger. First case will generate one CQE, second one will generate both
CQEs.

No documentation has been written for the io_uring bits yet. But the
current branch is ready for wider posting, so I should get that written
up too...

-- 
Jens Axboe

