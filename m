Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EC639C702
	for <lists+io-uring@lfdr.de>; Sat,  5 Jun 2021 11:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFEJTu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Jun 2021 05:19:50 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35481 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFEJTt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Jun 2021 05:19:49 -0400
Received: by mail-wm1-f54.google.com with SMTP id h5-20020a05600c3505b029019f0654f6f1so8727251wmq.0;
        Sat, 05 Jun 2021 02:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QDZG/MbQsYaBSqUoq3kmvKlvV7WuorolHxO8v0QfRKo=;
        b=awncJhwrtENOXkl7EyLB2Qd9xZCXI34A5jV8yJHi7ZjYrmraeD1DSIHWDE42+nBXus
         pIxDd0CpG4N+WRwdQRrYcA7AVOD7tNOl6b9CuKn0BCSwxcpt4/lDoXkByacnsdysHvJ8
         kmqzeY6meziH3RuKF9JCHtl4B87tG+5ynFYnQekju+fg8qXuUdDCkwsLJEKJAgG6dFk6
         1wk/9w4wCvCad83KGd1MoVoDINczb+k7rloYR6VqHypvp6xkOtah9pyk0eZvmKrQf4Yp
         s3/edU6RclqRZUgGBeyirr+Mrz3M2y32A26HsanROZFfNnQKhkw2MaC0jj+3Brc86STU
         cz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QDZG/MbQsYaBSqUoq3kmvKlvV7WuorolHxO8v0QfRKo=;
        b=PZtKWgszSSezgPRx+o5BRamG6o8sEOXYOX5iBASELPpw8kx6ia6Ge8QJdzQFBoVBPH
         5dfm7DBvOl3iDIldXiQ9gWtibHY36ZMt4JfraVQpPoVuCwKVj6zLbor3brBDvLJa9zTS
         BJgMYt85eGIkH8P7h8omJ2wEYRInkLboFx+xJQjlpGZ8gX6fp5TM0+BiUY93yMJJqHPU
         zzBh3U+l7BzW1JNn51S9P+4rT3SzO++2ddPk7i7YX8vaNDGMlZGYPZUz/uXZi2nyYUWT
         5Vx/+SdfSJ9rmnCeqn2pGMwdrjzn4BjPqkeEHucRp2RO9E/3KoHuQh2+f8Arc2yCiOsB
         Q5VA==
X-Gm-Message-State: AOAM530EuRjNu3T6KvcGHVw/6XVv/d6mhaPMhEaeqJHbQKVxAyukFZJS
        Ba+yg/660/MjghVOJopbaLw=
X-Google-Smtp-Source: ABdhPJz0y+2vUWdxaNHruUOvaQmtyvXtB+II7EOQDcWc3W155betasOc89F2DqRpHJEiWldK4GB3Rg==
X-Received: by 2002:a7b:c106:: with SMTP id w6mr7324124wmi.75.1622884605537;
        Sat, 05 Jun 2021 02:16:45 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.230])
        by smtp.gmail.com with ESMTPSA id y22sm12938584wma.36.2021.06.05.02.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 02:16:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lsf-pc@lists.linux-foundation.org
References: <23168ac0-0f05-3cd7-90dc-08855dd275b2@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] io_uring: BPF controlled I/O
Message-ID: <77b2c502-f8a3-2ec3-0373-6a34f991ab19@gmail.com>
Date:   Sat, 5 Jun 2021 10:16:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <23168ac0-0f05-3cd7-90dc-08855dd275b2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I botched subject tags, should be [LSF/MM/BPF TOPIC].

On 6/5/21 10:08 AM, Pavel Begunkov wrote:
> One of the core ideas behind io_uring is passing requests via memory
> shared b/w the userspace and the kernel, a.k.a. queues or rings. That
> serves a purpose of reducing number of context switches or bypassing
> them, but the userspace is responsible for controlling the flow,
> reaping and processing completions (a.k.a. Completion Queue Entry, CQE),
> and submitting new requests, adding extra context switches even if there
> is not much work to do. A simple illustration is read(open()), where
> io_uring is unable to propagate the returned fd to the read, with more
> cases piling up.
> 
> The big picture idea stays the same since last year, to give out some
> of this control to BPF, allow it to check results of completed requests,
> manipulate memory if needed and submit new requests. Apart from being
> just a glue between two requests, it might even offer more flexibility
> like keeping a QD, doing reduce/broadcast and so on.
> 
> The prototype [1,2] is in a good shape but some work need to be done.
> However, the main concern is getting an understanding what features and
> functionality have to be added to be flexible enough. Various toy
> examples can be found at [3] ([1] includes an overview of cases).
> 
> Discussion points:
> - Use cases, feature requests, benchmarking
> - Userspace programming model, code reuse (e.g. liburing)
> - BPF-BPF and userspace-BPF synchronisation. There is
>   CQE based notification approach and plans (see design
>   notes), however need to discuss what else might be
>   needed.
> - Do we need more contexts passed apart from user_data?
>   e.g. specifying a BPF map/array/etc fd io_uring requests?
> - Userspace atomics and efficiency of userspace reads/writes. If
>   proved to be not performant enough there are potential ways to take
>   on it, e.g. inlining, having it in BPF ISA, and pre-verifying
>   userspace pointers.
> 
> [1] https://lore.kernel.org/io-uring/a83f147b-ea9d-e693-a2e9-c6ce16659749@gmail.com/T/#m31d0a2ac6e2213f912a200f5e8d88bd74f81406b
> [2] https://github.com/isilence/linux/tree/ebpf_v2
> [3] https://github.com/isilence/liburing/tree/ebpf_v2/examples/bpf
> 
> 
> -----------------------------------------------------------------------
> Design notes:
> 
> Instead of basing it on hooks it adds support of a new type of io_uring
> requests as it gives a better control and let's to reuse internal
> infrastructure. These requests run a new type of io_uring BPF programs
> wired with a bunch of new helpers for submitting requests and dealing
> with CQEs, are allowed to read/write userspace memory in virtue of a
> recently added sleepable BPF feature. and also provided with a token
> (generic io_uring token, aka user_data, specified at submission and
> returned in an CQE), which may be used to pass a userspace pointer used
> as a context.
> 
> Besides running BPF programs, they are able to request waiting.
> Currently it supports CQ waiting for a number of completions, but others
> might be added and/or needed, e.g. futex and/or requeueing the current
> BPF request onto an io_uring request/link being submitted. That hides
> the overhead of creating BPF requests by keeping them alive and
> invoking multiple times.
> 
> Another big chunk solved is figuring out a good way of feeding CQEs
> (potentially many) to a BPF program. The current approach
> is to enable multiple completion queues (CQ), and specify for each
> request to which one steer its CQE, so all the synchronisation
> is in control of the userspace. For instance, there may be a separate
> CQ per each in-flight BPF request, and they can work with their own
> queues and send an CQE to the main CQ so notifying the userspace.
> It also opens up a notification-like sync through CQE posting to
> neighbours' CQs.
> 
> 

-- 
Pavel Begunkov
