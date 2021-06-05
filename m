Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB5439C6F6
	for <lists+io-uring@lfdr.de>; Sat,  5 Jun 2021 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFEJKx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Jun 2021 05:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFEJKx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Jun 2021 05:10:53 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C74C061766;
        Sat,  5 Jun 2021 02:08:54 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v206-20020a1cded70000b02901a586d3fa23so2602330wmg.4;
        Sat, 05 Jun 2021 02:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zQeCXqjQd9aw48hyC7AHhGyQXiz3bxiLBpZBaVxJ25w=;
        b=J+sLRExq/Ui6OcZryuLF1gx8vLob6v5V737iYqAVsmXoueR5iOSC+TJ2Kk/XGalQJ9
         xvMMw5TLQH0e6p8nWn0Q/bh5cghPOPe1nnMtlB8hHNGI5ei8DkVDfirQCuOxUkGHWZ1C
         ccDzvRwQxkbaQiAzoX2+U2SJzKdiPga3gIZVjoPiqBNI3wBE7qmUpaPr+KAMSu47sUKP
         LM2xr+Lm+wj8abp4lGSp2hYjO+hyD9qc/nWE10uyVtgm5Su7ewnRdjshxMvb3UHa6ACg
         DGVqlZpXdWJbu8Nvi6vJ2De7vAqVT8uxH3iPqP26BJoUtGRwq2SwZ56lULovuOCRlmTS
         hgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zQeCXqjQd9aw48hyC7AHhGyQXiz3bxiLBpZBaVxJ25w=;
        b=afdfjFoD3s8liyHKx/Vq8GflBtVGtx6ljLhYct81g0YENPBLP3ef9Fsmh+xnfQKrtY
         AsjpjJCuZvE3VdCPOiNVRWQ5GOvHeAYzc8tRWb08rvDPLSrsPf5OC+YMCYyXo0zNgo6J
         HOQBmBHAj8WzWBxkkfdV05hN5VQ880TI74Uy4EE6KWcaOymOOsvH/vubxzEyyfRW4+cf
         57i6Xb5lazN7NYQSfeXcCBZ2gObp4vkXVWMQKHcV04Znzd0yPZQTdRJXSHq/f8zkX0WU
         hDPc+jFcaCGOPr1chavIhO6tyo7ESUmFeSmWTJb9d8Fwl0iAQHN5nIJxuh93pE4yG+R0
         j0wA==
X-Gm-Message-State: AOAM532hL6JDzfWAOchnsgz2P1qWNBb3y0Qtr7Gho/NMnqA1qok9iOpZ
        Lto5J+w446/cc+RpUzfI2bJNM3ca6K4jFffG
X-Google-Smtp-Source: ABdhPJwTsTRj6ti2jdQBE4W9n3oEk1izFXSxDlniBFOnSOKT/mxG4SAANGYMvfyFfwFeD51gWSAQQQ==
X-Received: by 2002:a7b:c954:: with SMTP id i20mr7328878wml.161.1622884132619;
        Sat, 05 Jun 2021 02:08:52 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.230])
        by smtp.gmail.com with ESMTPSA id x125sm4496702wmg.37.2021.06.05.02.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 02:08:52 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lsf-pc@lists.linux-foundation.org
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: io_uring: BPF controlled I/O
Message-ID: <23168ac0-0f05-3cd7-90dc-08855dd275b2@gmail.com>
Date:   Sat, 5 Jun 2021 10:08:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

One of the core ideas behind io_uring is passing requests via memory
shared b/w the userspace and the kernel, a.k.a. queues or rings. That
serves a purpose of reducing number of context switches or bypassing
them, but the userspace is responsible for controlling the flow,
reaping and processing completions (a.k.a. Completion Queue Entry, CQE),
and submitting new requests, adding extra context switches even if there
is not much work to do. A simple illustration is read(open()), where
io_uring is unable to propagate the returned fd to the read, with more
cases piling up.

The big picture idea stays the same since last year, to give out some
of this control to BPF, allow it to check results of completed requests,
manipulate memory if needed and submit new requests. Apart from being
just a glue between two requests, it might even offer more flexibility
like keeping a QD, doing reduce/broadcast and so on.

The prototype [1,2] is in a good shape but some work need to be done.
However, the main concern is getting an understanding what features and
functionality have to be added to be flexible enough. Various toy
examples can be found at [3] ([1] includes an overview of cases).

Discussion points:
- Use cases, feature requests, benchmarking
- Userspace programming model, code reuse (e.g. liburing)
- BPF-BPF and userspace-BPF synchronisation. There is
  CQE based notification approach and plans (see design
  notes), however need to discuss what else might be
  needed.
- Do we need more contexts passed apart from user_data?
  e.g. specifying a BPF map/array/etc fd io_uring requests?
- Userspace atomics and efficiency of userspace reads/writes. If
  proved to be not performant enough there are potential ways to take
  on it, e.g. inlining, having it in BPF ISA, and pre-verifying
  userspace pointers.

[1] https://lore.kernel.org/io-uring/a83f147b-ea9d-e693-a2e9-c6ce16659749@gmail.com/T/#m31d0a2ac6e2213f912a200f5e8d88bd74f81406b
[2] https://github.com/isilence/linux/tree/ebpf_v2
[3] https://github.com/isilence/liburing/tree/ebpf_v2/examples/bpf


-----------------------------------------------------------------------
Design notes:

Instead of basing it on hooks it adds support of a new type of io_uring
requests as it gives a better control and let's to reuse internal
infrastructure. These requests run a new type of io_uring BPF programs
wired with a bunch of new helpers for submitting requests and dealing
with CQEs, are allowed to read/write userspace memory in virtue of a
recently added sleepable BPF feature. and also provided with a token
(generic io_uring token, aka user_data, specified at submission and
returned in an CQE), which may be used to pass a userspace pointer used
as a context.

Besides running BPF programs, they are able to request waiting.
Currently it supports CQ waiting for a number of completions, but others
might be added and/or needed, e.g. futex and/or requeueing the current
BPF request onto an io_uring request/link being submitted. That hides
the overhead of creating BPF requests by keeping them alive and
invoking multiple times.

Another big chunk solved is figuring out a good way of feeding CQEs
(potentially many) to a BPF program. The current approach
is to enable multiple completion queues (CQ), and specify for each
request to which one steer its CQE, so all the synchronisation
is in control of the userspace. For instance, there may be a separate
CQ per each in-flight BPF request, and they can work with their own
queues and send an CQE to the main CQ so notifying the userspace.
It also opens up a notification-like sync through CQE posting to
neighbours' CQs.


-- 
Pavel Begunkov
