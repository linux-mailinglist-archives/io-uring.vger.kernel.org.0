Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDC639BBD8
	for <lists+io-uring@lfdr.de>; Fri,  4 Jun 2021 17:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhFDP3c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 11:29:32 -0400
Received: from mail-ej1-f43.google.com ([209.85.218.43]:35464 "EHLO
        mail-ej1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhFDP3c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 11:29:32 -0400
Received: by mail-ej1-f43.google.com with SMTP id h24so15148130ejy.2;
        Fri, 04 Jun 2021 08:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7NyVlw+9K3FCCA2uSnrwkKBb8HWv+UokBAr++IGfKhM=;
        b=s23oVB5rPIhGFMyr1LyWqg7VxA8HL8EXKsYpTHJLuS4X6y9Vrb7wI62S0KFSWxnHBf
         dT5GTpmpcIaqkKEUc/E9il76pbzxzwljOa8MrSIXZeaBoR6SFVr2pzQsdwCd6DWC73vW
         p+otwlyKxble5KWISQe7WFkYBXg0h/V2J7M0OiR1GB9XoEo7NrAAN4dEENjkehjXCC3q
         MxcB9472C8G9ghk2w4rxyh3/ybOdPduXmoPiB8uI5YeXr34MPa+TvKi7B89YZ+ncibtK
         ltuASF2UMkwGU0OQ3B+oTrbOHOq4EtYy06degtU0J2IpWz2heYb2HRKBIVYXJL0yFPT6
         vqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7NyVlw+9K3FCCA2uSnrwkKBb8HWv+UokBAr++IGfKhM=;
        b=KIDXYuus3dnZxgKfA61WAc8POHcXhD1b4fiEu/P3GlbHoqYin8cAAyby0XjvdrYDbI
         AO5doYFdUmzht/ZOnJf9ajO5XP4jIgZdt5Y3uIarAjC85hTn5LC46MHjB+snQ3wD/yqJ
         C/C+xH75uO6gUtlQHvwxxs3gNDk8M7Rxt+SjWe47Xb9eYwA/ZhtvJwrsItvb6NXLeJFV
         MWEoAcuPw+whFx86TzX/TyimnyorPGtjvY4p0Fsb8JjmwYYI+46HgamLF8gHIb81eYOp
         GwLZbNuOLf1H/sPXhitARPZIkE8Nual/h69xrQ6hIzjzxly5sDmatn8WUFA1T1+EEztS
         uaOQ==
X-Gm-Message-State: AOAM530p5a2favn6/LG2OxSwszsApD4NKsrsCcVQgYl0pEQgz8foRlXy
        QhO2mjNLEkaksSgnCvxdouwYMI7w9RDlAHEb
X-Google-Smtp-Source: ABdhPJxhbgjPO19SxBBdwFn1xHwfvCgfMF+F5nkBG4btosn6hicrMJb2fxbOmZ3Vou71B5Zr1xGT5w==
X-Received: by 2002:a17:906:17c4:: with SMTP id u4mr4768007eje.481.1622820391430;
        Fri, 04 Jun 2021 08:26:31 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:b808])
        by smtp.gmail.com with ESMTPSA id de19sm3480486edb.70.2021.06.04.08.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 08:26:31 -0700 (PDT)
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
References: <cover.1622558659.git.asml.silence@gmail.com>
 <20210603185943.eeav4sfkrxyuhytp@alap3.anarazel.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 0/4] futex request support
Message-ID: <3b365e09-2524-77b4-472b-d03aea4130c0@gmail.com>
Date:   Fri, 4 Jun 2021 16:26:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603185943.eeav4sfkrxyuhytp@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 7:59 PM, Andres Freund wrote:
> Hi,
> 
> On 2021-06-01 15:58:25 +0100, Pavel Begunkov wrote:
>> Should be interesting for a bunch of people, so we should first
>> outline API and capabilities it should give. As I almost never
>> had to deal with futexes myself, would especially love to hear
>> use case, what might be lacking and other blind spots.
> 
> I did chat with Jens about how useful futex support would be in io_uring, so I
> should outline our / my needs. I'm off work this week though, so I don't think
> I'll have much time to experiment.
> 
> For postgres's AIO support (which I am working on) there are two, largely
> independent, use-cases for desiring futex support in io_uring.
> 
> The first is the ability to wait for locks (queued r/w locks, blocking
> implemented via futexes) and IO at the same time, within one task. Quickly and
> efficiently processing IO completions can improve whole-system latency and
> throughput substantially in some cases (journalling, indexes and other
> high-contention areas - which often have a low queue depth). This is true
> *especially* when there also is lock contention, which tends to make efficient
> IO scheduling harder.

Can you give a quick pointer to futex uses in the postgres code or
where they are? Can't find in master but want to see what types of
futex operations are used and how.

> The second use case is the ability to efficiently wait in several tasks for
> one IO to be processed. The prototypical example here is group commit/journal
> flush, where each task can only continue once the journal flush has
> completed. Typically one of waiters has to do a small amount of work with the
> completion (updating a few shared memory variables) before the other waiters
> can be released. It is hard to implement this efficiently and race-free with
> io_uring right now without adding locking around *waiting* on the completion
> side (instead of just consumption of completions). One cannot just wait on the
> io_uring, because of a) the obvious race that another process could reap all
> completions between check and wait b) there is no good way to wake up other
> waiters once the userspace portion of IO completion is through.

IIRC, the idea is to have a link "I/O -> fut_wake(master_task or nr=1)",
and then after getting some work done the woken task does wake(nr=all),
presumably via sys_futex or io_uring. Is that right?

As with this option userspace can't modify the memory on which futex
sits, the wake in the patchset allows to do an atomic add similarly
to FUTEX_WAKE_OP. However, I still have general concerns if that's
a flexible enough way.

When io_uring-BPF is added it can be offloaded to BPF programs
probably together with "updating a few shared memory variables",
but these are just thoughts for the future.

> All answers for postgres:
> 
>> 1) Do we need PI?
> 
> Not right now.
> 
> Not related to io_uring: I do wish there were a lower overhead (and lower
> guarantees) version of PI futexes. Not for correctness reasons, but
> performance. Granting the waiter's timeslice to the lock holder would improve
> common contention scenarios with more runnable tasks than cores.
> 
> 
>> 2) Do we need requeue? Anything else?
> 
> I can see requeue being useful, but I haven't thought it through fully.
> 
> Do the wake/wait ops as you have them right now support bitsets?

No, but trivial to add

>> 3) How hot waits are? May be done fully async avoiding io-wq, but
>> apparently requires more changes in futex code.
> 
> The waits can be quite hot, most prominently on low latency storage, but not
> just.

Thanks Andres, that clears it up. The next step would be to verify
that FUTEX_WAKE_OP-style waking is enough.

-- 
Pavel Begunkov
