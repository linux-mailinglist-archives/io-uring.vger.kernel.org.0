Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580013A27D6
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 11:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFJJL7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 05:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhFJJL7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 05:11:59 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A70C061574;
        Thu, 10 Jun 2021 02:09:47 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id m18so1398255wrv.2;
        Thu, 10 Jun 2021 02:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aA3qNpdrQMqkukZT9c2cYMIlRMYPN4cXLvEY+pr6FGE=;
        b=mlnXzW0JDlw/F9ohxso+1nE1ibYnYhrOGRPE1df+XW8avkT5qXymLsKUaTvsrjtKeH
         KX9KhlnLx0fQ4uRmqGTgkzclsmTyGptiW061DpN8wnA122ySA9u4YRIgyzW22HFI9lLo
         LIGgICl8bViq0QG4qX5+nV1BpSYtvM0V/Q9u9lUY3FA/61FWI8jIxHLhC6GgyH2vWnfX
         Rdk7z11eNncrigDnaA0yma7pISLLAiSD/nAnVEhkxmYm9X9xhAA+TotFVjyRSvCvuBWy
         T0BgaIz2VwmiyUaIJ8kTXBGtMTMrz1448VNUM3nv3E8xYxOscygD0uoYLWLHt5qd4Drj
         xHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aA3qNpdrQMqkukZT9c2cYMIlRMYPN4cXLvEY+pr6FGE=;
        b=nZOPpWBCpDThWaA8vyLSz2xnSdX1O8NlXjDWogEBrqOw45zgnREx3yOEWgkZuWuurU
         gZ7L3afomofH6WPEKWoJq5Qclq4jWYovny1A+sMt3TCMRN5JzTmpWrbWv2xhccefg4CM
         zG28eU7HE6PVNN2jzeLniV/VXLfUc8wk/EV9C9NFIpF+v7tDT+ixXTHbkzJfSIWitmNl
         9RTbEadzdlXm0I+xfsg4xqmK/pyjrxdXbJO8nEgvxCG465rbtpvxXipUVGH9ZtiWIoAe
         StYfaa56fH9D+GXldlauzqN7KIp1IB5Gp+DHbLTNIUdR9whPIwE/TcDsnVKa7NsDsWZ4
         JqpA==
X-Gm-Message-State: AOAM530bnSHszlgGXjKXpSv8C7RNHfn7nklT37u9M67vuSWN6LFkIX7/
        tQtfP0PxDwkLlclNP9JbEZA=
X-Google-Smtp-Source: ABdhPJxqrRuVI+dreFR9Ia4t+/Q60mfSF2kuvuRz1tIIMoka/FZFX+Q52Yl0pQNepm0ykiPHCoLIZQ==
X-Received: by 2002:adf:fdcd:: with SMTP id i13mr4268863wrs.307.1623316185636;
        Thu, 10 Jun 2021 02:09:45 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id n7sm8151882wmq.37.2021.06.10.02.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 02:09:44 -0700 (PDT)
Subject: Re: io_uring: BPF controlled I/O
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lsf-pc@lists.linux-foundation.org
References: <23168ac0-0f05-3cd7-90dc-08855dd275b2@gmail.com>
 <CAM1kxwjHrf74u5OLB=acP2fBy+cPG4NNxa-51O35caY4VKdkkg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <7a7d32eb-69fb-93ef-4092-c4da926dd416@gmail.com>
Date:   Thu, 10 Jun 2021 10:09:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAM1kxwjHrf74u5OLB=acP2fBy+cPG4NNxa-51O35caY4VKdkkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/7/21 7:51 PM, Victor Stewart wrote:
> On Sat, Jun 5, 2021 at 5:09 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> One of the core ideas behind io_uring is passing requests via memory
>> shared b/w the userspace and the kernel, a.k.a. queues or rings. That
>> serves a purpose of reducing number of context switches or bypassing
>> them, but the userspace is responsible for controlling the flow,
>> reaping and processing completions (a.k.a. Completion Queue Entry, CQE),
>> and submitting new requests, adding extra context switches even if there
>> is not much work to do. A simple illustration is read(open()), where
>> io_uring is unable to propagate the returned fd to the read, with more
>> cases piling up.
>>
>> The big picture idea stays the same since last year, to give out some
>> of this control to BPF, allow it to check results of completed requests,
>> manipulate memory if needed and submit new requests. Apart from being
>> just a glue between two requests, it might even offer more flexibility
>> like keeping a QD, doing reduce/broadcast and so on.
>>
>> The prototype [1,2] is in a good shape but some work need to be done.
>> However, the main concern is getting an understanding what features and
>> functionality have to be added to be flexible enough. Various toy
>> examples can be found at [3] ([1] includes an overview of cases).
>>
>> Discussion points:
>> - Use cases, feature requests, benchmarking
> 
> hi Pavel,
> 
> coincidentally i'm tossing around in my mind at the moment an idea for
> offloading
> the PING/PONG of a QUIC server/client into the kernel via eBPF.
> 
> problem being, being that QUIC is userspace run transport and that NAT-ed UDP
> mappings can't be expected to stay open longer than 30 seconds, QUIC
> applications
> bare a large cost of context switching wake-up to conduct connection lifetime
> maintenance... especially when managing a large number of mostly idle long lived
> connections. so offloading this maintenance service into the kernel
> would be a great
> efficiency boon.
> 
> the main impediment is that access to the kernel crypto libraries
> isn't currently possible
> from eBPF. that said, connection wide crypto offload into the NIC is a
> frequently mentioned
> subject in QUIC circles, so one could argue better to allocate the
> time to NIC crypto offload
> and then simply conduct this PING/PONG offload in plain text.
> 
> CQEs would provide a great way for the offloaded service to be able to
> wake up the
> application when it's input is required.

Interesting, want to try out the idea? All pointers are here
and/or in the patchset's cv, but if anything is not clear,
inconvenient, lacks needed functionality, etc. let me know


> anyway food for thought.
> 
> Victor
> 
>> - Userspace programming model, code reuse (e.g. liburing)
>> - BPF-BPF and userspace-BPF synchronisation. There is
>>   CQE based notification approach and plans (see design
>>   notes), however need to discuss what else might be
>>   needed.
>> - Do we need more contexts passed apart from user_data?
>>   e.g. specifying a BPF map/array/etc fd io_uring requests?
>> - Userspace atomics and efficiency of userspace reads/writes. If
>>   proved to be not performant enough there are potential ways to take
>>   on it, e.g. inlining, having it in BPF ISA, and pre-verifying
>>   userspace pointers.
>>
>> [1] https://lore.kernel.org/io-uring/a83f147b-ea9d-e693-a2e9-c6ce16659749@gmail.com/T/#m31d0a2ac6e2213f912a200f5e8d88bd74f81406b
>> [2] https://github.com/isilence/linux/tree/ebpf_v2
>> [3] https://github.com/isilence/liburing/tree/ebpf_v2/examples/bpf
>>
>>
>> -----------------------------------------------------------------------
>> Design notes:
>>
>> Instead of basing it on hooks it adds support of a new type of io_uring
>> requests as it gives a better control and let's to reuse internal
>> infrastructure. These requests run a new type of io_uring BPF programs
>> wired with a bunch of new helpers for submitting requests and dealing
>> with CQEs, are allowed to read/write userspace memory in virtue of a
>> recently added sleepable BPF feature. and also provided with a token
>> (generic io_uring token, aka user_data, specified at submission and
>> returned in an CQE), which may be used to pass a userspace pointer used
>> as a context.
>>
>> Besides running BPF programs, they are able to request waiting.
>> Currently it supports CQ waiting for a number of completions, but others
>> might be added and/or needed, e.g. futex and/or requeueing the current
>> BPF request onto an io_uring request/link being submitted. That hides
>> the overhead of creating BPF requests by keeping them alive and
>> invoking multiple times.
>>
>> Another big chunk solved is figuring out a good way of feeding CQEs
>> (potentially many) to a BPF program. The current approach
>> is to enable multiple completion queues (CQ), and specify for each
>> request to which one steer its CQE, so all the synchronisation
>> is in control of the userspace. For instance, there may be a separate
>> CQ per each in-flight BPF request, and they can work with their own
>> queues and send an CQE to the main CQ so notifying the userspace.
>> It also opens up a notification-like sync through CQE posting to
>> neighbours' CQs.
>>
>>
>> --
>> Pavel Begunkov

-- 
Pavel Begunkov
