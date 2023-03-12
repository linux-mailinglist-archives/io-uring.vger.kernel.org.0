Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073256B6781
	for <lists+io-uring@lfdr.de>; Sun, 12 Mar 2023 16:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjCLPbc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Mar 2023 11:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCLPbb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Mar 2023 11:31:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8003E61D
        for <io-uring@vger.kernel.org>; Sun, 12 Mar 2023 08:31:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p6so10457942plf.0
        for <io-uring@vger.kernel.org>; Sun, 12 Mar 2023 08:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678635090;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UQoRmUqlROgj8IG7Rr2xdXdk+jkNogH4MWaMk8pJc9s=;
        b=qGHQKNT1XtNnFAjfNiSHTpyICLEYI/7IO47fzs15u7uFKbBr+6vCqKRi0uN1w6YVp9
         7vxc4A9qYo8bgmzmfmXEBfZDriGDIXf3RwBdiPKMH1c02cN6Ky7JFUYoobvd+0AHwTtC
         nLV5kGq3l7gkIO3rc0GDXAeZVxGKKdHyz+oTkPCo1Qamb4gSHv6CrmvzKMct4OgxGiGI
         spSAqDQvAMNWj0bAlWIiqxDuNe33ZqOrSk7vsJogGNqI5xLGWJsm878vxTAjrTUEUXQD
         f5KSRcBJ9PmQ+D+6s7O8N80eYdxvLyPx+glooJnU8H7qRXpwfr0J6dabeYGHFC3aTeQ4
         aNNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678635090;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQoRmUqlROgj8IG7Rr2xdXdk+jkNogH4MWaMk8pJc9s=;
        b=pM+cvA7KHRCf5QWtLh7HC9rpgZT7wFYFG1tFAsig8Orx0rUBs+xZOLA6Xmeb6rItxX
         BQW37lMiGf4b7h16ALXplvGSRZVcu2b7p0Qkk+UimQItXc9yIwRekCNNhnv6zElm4EYv
         xxIu/QtRboxLWBm8Fpod8MZI7Q3hQToTtrod9CvqGuMQr5KmxxcBG5h/p5QHDQ2L1S9G
         ZyXXAVlivEvZwf0hhvJk+5iIXYgM+JjkRk/ln1njd7gA2Hxul6hh/MEw79PisNlvhqH7
         rl4qlOqWflgDL8po7b9xLrwMLwnsVa83YXe+DJd1cxhPKuTTdeUETKnWUPHmoYXQeCM6
         PSkg==
X-Gm-Message-State: AO0yUKW/gGRE4a3IKgl+/C2vzUhLWPIhXAFGAqukw0v7O0mpSxKRJfh0
        lQjKfRfEz2mSzAEP+crOvVbmhoWVBPRBVQYF+XHCgg==
X-Google-Smtp-Source: AK7set8T2h7ywbsK8hamtxiYgM5D/+z8T7IB6z1vPmewJ4Hp3/uwhoh/Zo/+AK5eM+XjUhg94Cz07w==
X-Received: by 2002:a17:903:6c3:b0:19a:a815:2864 with SMTP id kj3-20020a17090306c300b0019aa8152864mr7539223plb.4.1678635090104;
        Sun, 12 Mar 2023 08:31:30 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id kq13-20020a170903284d00b00198f73f9d54sm2992152plb.117.2023.03.12.08.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 08:31:29 -0700 (PDT)
Message-ID: <7bceab46-f4cd-3064-ff9e-1e64b18a901b@kernel.dk>
Date:   Sun, 12 Mar 2023 09:31:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
 <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
 <c81c971e-3e00-0767-3158-d712208f15e9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c81c971e-3e00-0767-3158-d712208f15e9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/23 1:53?PM, Pavel Begunkov wrote:
> On 3/11/23 20:45, Pavel Begunkov wrote:
>> On 3/11/23 17:24, Jens Axboe wrote:
>>> On 3/10/23 12:04?PM, Pavel Begunkov wrote:
>>>> io_uring extensively uses task_work, but when a task is waiting
>>>> for multiple CQEs it causes lots of rescheduling. This series
>>>> is an attempt to optimise it and be a base for future improvements.
>>>>
>>>> For some zc network tests eventually waiting for a portion of
>>>> buffers I've got 10x descrease in the number of context switches,
>>>> which reduced the CPU consumption more than twice (17% -> 8%).
>>>> It also helps storage cases, while running fio/t/io_uring against
>>>> a low performant drive it got 2x descrease of the number of context
>>>> switches for QD8 and ~4 times for QD32.
>>>>
>>>> Not for inclusion yet, I want to add an optimisation for when
>>>> waiting for 1 CQE.
>>>
>>> Ran this on the usual peak benchmark, using IRQ. IOPS is around ~70M for
>>> that, and I see context rates of around 8.1-8.3M/sec with the current
>>> kernel.
>>>
>>> Applied the two patches, but didn't see much of a change? Performance is
>>> about the same, and cx rate ditto. Confused... As you probably know,
>>> this test waits for 32 ios at the time.
>>
>> If I'd to guess it already has perfect batching, for which case
>> the patch does nothing. Maybe it's due to SSD coalescing +
>> small ro I/O + consistency and small latencies of Optanes,
>> or might be on the scheduling and the kernel side to be slow
>> to react.
> 
> And if that's that, I have to note that it's quite a sterile
> case, the last time I asked the usual batching we're currently
> getting for networking cases is 1-2.

I can definitely see this being very useful for the more
non-deterministic cases where "completions" come in more sporadically.
But for the networking case, if this is eg receives, you'd trigger the
wakeup anyway to do the actual receive? And then the cqe posting doesn't
trigger another wakeup.

-- 
Jens Axboe

