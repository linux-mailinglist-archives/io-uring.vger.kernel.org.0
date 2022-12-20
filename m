Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1683652609
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 19:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiLTSLB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 13:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLTSLA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 13:11:00 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB3B112A
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 10:10:58 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id u8so3166367ilq.13
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 10:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UTJEfbjEL9SEAQnmqQuwjnpIkEHJQWLN6g+qPa3ajIM=;
        b=lBCfMQTajgANH0aMa04AI3yg0QxexWXYQeFHpW0YYkJ1/ssUGHEM9YzGtn1a7PPGHU
         GoAC73I+t2AMK5R6NQl2T7DTnjGkmVkK1zg7jQoGNkSQNC5f1bArdZAdxKIJXXUK2F7N
         GD/ovWZLygolB4bFXRU+IDvYEkeUQ4J6kdWNFZFlQBORwX68zLpY3kVZKWIc6ZWV5vQE
         3oeiCDO0LhTqOhcyRU/2V4R2NlZuoPYTujbwRCaFu95O2JQ10oNjsyzljHZR6hCEbrWT
         mny6ifZri/wyGbEpvAPsC7SL4Nshkb4KXWmJy2H/6T8KLx1ttjDM5QbOY8t6jtILvey7
         v4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTJEfbjEL9SEAQnmqQuwjnpIkEHJQWLN6g+qPa3ajIM=;
        b=Sz9ruwL286xJzFcvNp0rjVp7BA2vedqEcjrlbVW28GJ7AYNfEUvdCTpXGXj/sic/im
         kd3Rw1JBlGDaERRn5hfBSdfN2nPHTIfzcpFzM+F3eOYCAIZoQJG2WpttYLJe2OI5OLZ2
         UbnUXWGSAHWwSmZ7/NSXl9zDyDWDGu2e0vWD6t+ZOYsuwW30EKRKkOS+7BHkkwBRg6w6
         FVsfTRT+oRy3P9T1i4RUbr9UAbgI2QVExjMxw2uYWejxLKpitZmlgJdHIXRtwaIH8YvE
         XRL5VnuOoiymMgUmYscnUSHyyxEGg3ly+4+um9fRB5UsnG8b5l2KNa/mUDYD/Uo7Uq5K
         9Z3g==
X-Gm-Message-State: ANoB5pmJQIBN+rceiRCCrgfHFUiziivQAqqVxpMPdOh9bR378TKyZtNJ
        GcwOMUzqmnozI3yaW6kGVv9pvw==
X-Google-Smtp-Source: AA0mqf7T9SYcfprAJ+7vKRPjECKt9x3vwLbXgd/TZT1WQHFA3s563pzjjByUa82E4TUn3US3jsN/hA==
X-Received: by 2002:a92:dc83:0:b0:302:42c9:8f2f with SMTP id c3-20020a92dc83000000b0030242c98f2fmr4855759iln.1.1671559857588;
        Tue, 20 Dec 2022 10:10:57 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c27-20020a02331b000000b0038a6da37802sm4851276jae.24.2022.12.20.10.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 10:10:56 -0800 (PST)
Message-ID: <626cbdac-78a0-d8d9-b574-8617792542ac@kernel.dk>
Date:   Tue, 20 Dec 2022 11:10:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC] io_uring: wake up optimisations
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <81104db1a04efbfcec90f5819081b4299542671a.1671559005.git.asml.silence@gmail.com>
 <7e983688-5fcf-a1fd-3422-4baed6a0cb89@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7e983688-5fcf-a1fd-3422-4baed6a0cb89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/22 11:06 AM, Pavel Begunkov wrote:
> On 12/20/22 17:58, Pavel Begunkov wrote:
>> NOT FOR INCLUSION, needs some ring poll workarounds
>>
>> Flush completions is done either from the submit syscall or by the
>> task_work, both are in the context of the submitter task, and when it
>> goes for a single threaded rings like implied by ->task_complete, there
>> won't be any waiters on ->cq_wait but the master task. That means that
>> there can be no tasks sleeping on cq_wait while we run
>> __io_submit_flush_completions() and so waking up can be skipped.
> 
> Not trivial to benchmark as we need something to emulate a task_work
> coming in the middle of waiting. I used the diff below to complete nops
> in tw and removed preliminary tw runs for the "in the middle of waiting"
> part. IORING_SETUP_SKIP_CQWAKE controls whether we use optimisation or
> not.
> 
> It gets around 15% more IOPS (6769526 -> 7803304), which correlates
> to 10% of wakeup cost in profiles. Another interesting part is that
> waitqueues are excessive for our purposes and we can replace cq_wait
> with something less heavier, e.g. atomic bit set

I was thinking something like that the other day, for most purposes
the wait infra is too heavy handed for our case. If we exclude poll
for a second, everything else is internal and eg doesn't need IRQ
safe locking at all. That's just one part of it. But I didn't have
a good idea for the poll() side of things, which would be required
to make some progress there.

-- 
Jens Axboe


