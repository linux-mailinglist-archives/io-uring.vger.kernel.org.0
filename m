Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8265F7B75
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiJGQbG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 12:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJGQbF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 12:31:05 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CB9102DC4
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 09:31:01 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id e205so4028076iof.1
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 09:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=op03PwUmvX6MQUDSVwxtP4/PgfuJx4xmwiFWIIgO/6A=;
        b=c7gVkU8l0RkAG7LdgjUT4cOgyVrH1mnstu9EfXovMbLwAl/BybcZ2HwG1PheXhJgWE
         88Ir6yAAeP/BJ7uZ431ig66fUUwWcdNB2LCAcJFkQ3xincfJMuM6CW4cN8VzDssDdLcL
         IZHnje0ZmNElmxA1ijAQf0yHqpR9ECyQ+UK93eO+ZMy1sHXEKbUbErvn85ZpLP+Xkbjf
         5B0znozV6RmB4LzRSuFboUnPH0AQlYbzlpgvY6ikF4+adBN7IkJKjVh18k8QT9850zHc
         +QzQBT/jCBXn9El75ud37+jGN8zzYhYTn0JbvAvCXRt51/Aac+Av7ZG75KX6lMv9Y9br
         8+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=op03PwUmvX6MQUDSVwxtP4/PgfuJx4xmwiFWIIgO/6A=;
        b=lKU/LZDhr9iZthU/yYaE2R8tOtD3bVkotL6nJYQAAHLK0eXhkQ+wKG7DkYVVmfpIEB
         yJqINBRPumKBszTyq/2RGSA4F93vlE+8wep6kOgfmzq5us05wanwxXKkX3Iv2kQBBOB3
         YsE1rt4+lBX9igZhEi9IB4WiOWOWALaiiZ/CSu812nLj4l06FEYZahp7kA64ski7hBIJ
         yDb2BvL174N4eY+Cu7s1gwI8+O/O1F20lHmUWjnRPpO5zPZbo/kGK6S6zH635TkFBsH0
         2Y3GTK6CPsWR8xgxm4K0iR9SroY83QZwVh/trSmELF0xFIU278dzUd37OE2vYDQn0S2m
         IHMQ==
X-Gm-Message-State: ACrzQf3noiryzuWmUnCBFOBQMZ+UurExPxvHyuUlgytlhYBsIZoUGE1l
        NCFZOJuSDwYOKJnsunUS/QBXfbN8JlHAkg==
X-Google-Smtp-Source: AMsMyM575R7rlNRnZCkF3028UVy2ln+RzMhMHysgX4PkgHo/fbwEgPxlDKmxF3Wc2sQe7eZv5NLewQ==
X-Received: by 2002:a05:6638:3818:b0:35a:8cf5:e007 with SMTP id i24-20020a056638381800b0035a8cf5e007mr2948013jav.227.1665160260961;
        Fri, 07 Oct 2022 09:31:00 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id bm12-20020a05663842cc00b003638d00b759sm687051jab.54.2022.10.07.09.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 09:31:00 -0700 (PDT)
Message-ID: <96dc6533-a3af-a98c-9b6e-cda47c4f3379@kernel.dk>
Date:   Fri, 7 Oct 2022 10:30:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [GIT PULL] io_uring updates for 6.1-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dylan Yudaken <dylany@fb.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <2fad8156-a3ad-5532-aee6-3f872a84e9c2@kernel.dk>
 <CAHk-=wg1RzrA5dq_9RTz-mhxOPmy7nFap2NiS-Kz6KwpUuDMmg@mail.gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wg1RzrA5dq_9RTz-mhxOPmy7nFap2NiS-Kz6KwpUuDMmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/7/22 10:07 AM, Linus Torvalds wrote:
> On Mon, Oct 3, 2022 at 7:18 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - Series that adds supported for more directly managed task_work
>>   running. This is beneficial for real world applications that end up
>>   issuing lots of system calls as part of handling work.
> 
> While I agree with the concept, I'm not convinced this is done the
> right way.
> 
> It looks very much like it was done in a "this is perfect for
> benchmarks" mode.
> 
> I think you should consider it much more similar to plugging (both
> network and disk IO). In particular, I think that you'll find that
> once you have random events like memory allocations blocking in other
> places, you actually will want to unplug early, so that you don't end
> up sleeping with unstarted work to do.
> 
> And the reason I say this code looks like "made for benchmarks" is
> that you'll basically never see those kinds of issues when you just
> run some benchmark that is tuned for this.  For the benchmark, you
> just want the user to control exactly when to start the load, because
> you control pretty much everything.
> 
> And then real life happens, and you have situations where you get
> those odd hiccups from other things going on, and you wonder "why was
> no IO taking place?"
> 
> Maybe I'm misreading the code, but it looks to me that the deferred
> io_uring work is basically deferred completely synchronously.
> 
> I've pulled this, and maybe I'm misreading it. Or maybe there's some
> reason why io_uring is completely different from all the other
> situations where we've ever wanted to do this kind of plugging for
> batching, but I really doubt that io_uring is magically different...

I'll try and address these separately.

It's interesting that you suspect it's made for benchmarks. In practice,
this came about from very much the opposite angle - benchmarks were
fine, but production code for Thrift was showing cases where the
io_uring backend didn't perform as well as the epoll one. Dylan did a
lot of debugging and head scratching here, because it wasn't one of
those "let's profile and see what it is - oh yep, this needs to be
improved" kind of cases. Benchmark are easy because they are very much
targeted - if you write something that tries to behave like thrift, then
it too will perform fine. One of the key differences is that
production code actually does a bunch of things when processing a
request, issuing other system calls. A benchmark does not.

When the backend issues a receive and no data is available, an internal
poll trigger is used to know when we can actually receive data. When
that triggers, task_work is queued to do the actual receive. That's
considered the fast part, because it's basically just copying the data.
task_work is tied to exiting to userspace, which means that basically
anything the backend does that isn't strict CPU processing will end up
flushing the task_work. This really hurts efficiencies at certain rates
of load. The problem was worse when task_work actually triggered a
forced kernel enter/exit via TWA_SIGNAL doing an IPI to reschedule if it
was running in userspace, but it was still an issue even with just
deferring it to be run whenever a transition happened anyway.

I do agree that you have a point on it being somewhat similar to
plugging in the sense that you would probably want this flushed if you
get scheduled out anyway. For production loads where you end up being
resource constrained (not a rare occurence...), we want them run before
putting the task to sleep. We'll look into making a tweak like that, it
seems like the right thing to do.

I'm sure Dylan can chime in on the above too once he's back, to add some
more data to this change.

-- 
Jens Axboe
