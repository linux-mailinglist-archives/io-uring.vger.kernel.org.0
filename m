Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDEC3E7DB0
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 18:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhHJQoy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 12:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236236AbhHJQov (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 12:44:51 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B6C0613C1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:44:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u16so21932530ple.2
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ScNqN13HfBMZYxBc2thLPbgiBy6luB1V2KjfITBf6DE=;
        b=w9oaVqG4AX/mRNwaohArp8R9bw91iH8Eko/4RxW4S3IuZ4JO2LBzw9820PoKYmFGL7
         NWLBz6fbo5JH0gK2Lg0JsaFfVguTN7n8UtRCM6e42cMl6UddioZrbE7KCv8jSHVq4RNY
         3w0on3tOIiPlivQFZviiLGzCikgR5qJE6+DzbHWZNnBTAPMfy5IiwjR5Zh/mC01jW2le
         U2E6mnQzEPwWzNQ2v16UEkb/zxNc2BYk++vN4CRLQSToeD1A228pcpI07O20Rrz+DeRy
         nNV5D6u3ebm3qfe9GdVmAB2hxgqk//evXWE+QB+89fJyB1zwdaF5fRKvRpUvt3NwtMrM
         v0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ScNqN13HfBMZYxBc2thLPbgiBy6luB1V2KjfITBf6DE=;
        b=Tf0B05wzusl9bN9nS9l6k5+7uwizTYQrAaktl21cTHTFh/09NSPSrbjGnlLFD50vjI
         8le6VL8PKEGVr/udtV+1F+Y1sCMJqQv3wT7RBjXKZtLKsTjVVdRfNL/wNRyOpg644sKB
         DNoXcmk/hGH48aBwOcFsgTPLyEUTordHSP0dOAWa9Q4MuA6PR3rVIB5oea0YsDMg9IxY
         O0lwJwB8zwNq7eZSxegQtrGgQiwb62zBBIZIWPH+Nie4hA0rj2bHPFpPLsl+qj6/Z8DU
         1N97bLLjj24ZGSr/nIJW3kngxA9xAld3ud4cUxzkFdIJbPCQ0qFVGjc1miE1+3uDyVI8
         mqxA==
X-Gm-Message-State: AOAM531janxb/1YIz9a6C772OjOUjibcArfjCVT/V615+cATbM7latVU
        AeZ1ET0Uoi/0a7+u4e+rdVugYbdwe9HB6a6L
X-Google-Smtp-Source: ABdhPJyUkk5qbVZsvsPv8DhEZ/7ZuE0eJuJWMiEreHae64MQP8LQUFS3oL2JivABUClZwLcwp03MAg==
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id l6-20020a056a0016c6b029032de1909dd0mr29527418pfc.70.1628613869126;
        Tue, 10 Aug 2021 09:44:29 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id c13sm24387719pfi.71.2021.08.10.09.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 09:44:28 -0700 (PDT)
Subject: Re: [PATCHSET v3 0/5] Enable bio recycling for polled IO
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20210810163728.265939-1-axboe@kernel.dk>
Message-ID: <bf0d0a11-342e-d49e-1f18-b5a0439db76b@kernel.dk>
Date:   Tue, 10 Aug 2021 10:44:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210810163728.265939-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 10:37 AM, Jens Axboe wrote:
> Hi,
> 
> This is v3 of this patchset. We're back to passing the cache pointer
> in the kiocb, I do think that's the cleanest and it's also the most
> efficient approach. A patch has been added to remove a member from
> the io_uring req_rw structure, so that the kiocb size bump doesn't
> result in the per-command part of io_kiocb to bump into the next
> cacheline.
> 
> Another benefit of this approach is that we get per-ring caching.
> That means if an application splits polled IO into two threads, one
> doing submit and one doing reaps, then we still get the full benefit
> of the bio caching.
> 
> The tldr; here is that we get about a 10% bump in polled performance with
> this patchset, as we can recycle bio structures essentially for free.
> Outside of that, explanations in each patch. I've also got an iomap patch,
> but trying to keep this single user until there's agreement on the
> direction.
> 
> Against for-5.15/io_uring, and can also be found in my
> io_uring-bio-cache.3 branch.

As a reference. Before the patch:

axboe@amd ~/g/fio (master)> sudo taskset -c 0  t/io_uring -b512 -d128 -s32 -c32 -p1 -F1 -B1 /dev/nvme3n1
i 8, argc 9
Added file /dev/nvme3n1 (submitter 0)
sq_ring ptr = 0x0x7f63a7c42000
sqes ptr    = 0x0x7f63a7c40000
cq_ring ptr = 0x0x7f63a7c3e000
polled=1, fixedbufs=1, register_files=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=1600
IOPS=3111520, IOS/call=32/31, inflight=128 (128)

or around 3.1M IOPS (single thread, single core), and after:

axboe@amd ~/g/fio (master)> sudo taskset -c 0  t/io_uring -b512 -d128 -s32 -c32 -p1 -F1 -B1 /dev/nvme3n1
i 8, argc 9
Added file /dev/nvme3n1 (submitter 0)
sq_ring ptr = 0x0x7f62726bc000
sqes ptr    = 0x0x7f62726ba000
cq_ring ptr = 0x0x7f62726b8000
polled=1, fixedbufs=1, register_files=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=1791
IOPS=3417120, IOS/call=32/31, inflight=128 (128)

which is about a ~10% increase in per-core IOPS for this kind of
workload.

-- 
Jens Axboe

