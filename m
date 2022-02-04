Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84924A9C4C
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 16:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376281AbiBDPxG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Feb 2022 10:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376284AbiBDPxE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Feb 2022 10:53:04 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62106C061714
        for <io-uring@vger.kernel.org>; Fri,  4 Feb 2022 07:53:04 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id 9so7894964iou.2
        for <io-uring@vger.kernel.org>; Fri, 04 Feb 2022 07:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R0/VRC6MJ23IQ50AYwFq/GKus1/XLDPRN4c2rFVnHh4=;
        b=y8WVG/cr2hESo2ZAmi6wf+elNqaLhdSNLWBcBWKyCXqFmTfgBdvPdjEBItKIio9jrS
         XvpGKHKh1MJ/GE6NqPmUQev2b5VYblmBdJKMq3aXJxvNs55OOV0F690ipyORSDJvxoKv
         UDrI3wUyCybjZdImtwSs7C7HQhtrRy60DW1rxfvkoWI4NeVV5FDS1FfuVBv/tVR7OjS4
         NhIu+MVi2LAhjrQXZbAw44SUhFWzv1t8b0GdIVFqoNMEkyEoSWY4J3SOnCPUDbctpqfk
         HbgHNxyg4sREsA5kipSkq+ufpfWYUxa6U7YsCXWAir6Wr7Yhj26vbWshuQaEtBS+Fpow
         30ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R0/VRC6MJ23IQ50AYwFq/GKus1/XLDPRN4c2rFVnHh4=;
        b=0AbuBW2HV0vxeCdKyqm5VsB+PMnpu3b1bPPvcBj/WTRF6MUx0HmndCzczFYbkYnPf+
         PbTG4+g6UKFvjlhLrvzBGg4roHeeW33c9wVNSdtPhW0FHsfIRMJQMmcZ4A4ONSD5E8Au
         SBy1e+xcCgTTBOpPkofbHMJndBEdkf5BC75KBRH8eHg6T1QOQ2puEM9mnKXKBE7GklxE
         OEN4q6RoHlWwqCIVSfLgghuvuYmnHvsnTSf+AuSHwq7C9Yvs1gy8ajmq7heakvJxSATg
         99JQaGR80Eq28Zy3blb+MHZOkSloFGKSbQKuZoU9K+WIJ0cE5kQzVWNErosE+cuFMqzn
         DicA==
X-Gm-Message-State: AOAM532YFac067e0EOU3aPSLL2YINCMrO6nZjxIUzyz30yqBDeghrvYL
        z7mtLY+BJHZMgYCJFHatVHsKJg==
X-Google-Smtp-Source: ABdhPJz6JUld3GIj2G/MqGVt9QQZDE+ivq+9gC+gx6uR9GscY9lcvssPpMtbXVeagNeLAJ5EKhAcHw==
X-Received: by 2002:a02:7417:: with SMTP id o23mr1653087jac.145.1643989983674;
        Fri, 04 Feb 2022 07:53:03 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s18sm1132681iov.5.2022.02.04.07.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 07:53:03 -0800 (PST)
Subject: Re: [PATCH v6 0/5] io_uring: remove ring quiesce in io_uring_register
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220204145117.1186568-1-usama.arif@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b67f1ce6-6110-b6f3-e66e-f636d47a736d@kernel.dk>
Date:   Fri, 4 Feb 2022 08:53:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220204145117.1186568-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/22 7:51 AM, Usama Arif wrote:
> Ring quiesce is currently used for registering/unregistering eventfds,
> registering restrictions and enabling rings.
> 
> For opcodes relating to registering/unregistering eventfds, ring quiesce
> can be avoided by creating a new RCU data structure (io_ev_fd) as part
> of io_ring_ctx that holds the eventfd_ctx, with reads to the structure
> protected by rcu_read_lock and writes (register/unregister calls)
> protected by a mutex.
> 
> With the above approach ring quiesce can be avoided which is much more
> expensive then using RCU lock. On the system tested, io_uring_reigster with
> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
> before with ring quiesce.
> 
> IORING_SETUP_R_DISABLED prevents submitting requests and
> so there will be no requests until IORING_REGISTER_ENABLE_RINGS
> is called. And IORING_REGISTER_RESTRICTIONS works only before
> IORING_REGISTER_ENABLE_RINGS is called. Hence ring quiesce is
> not needed for these opcodes.

I wrote a simple test case just verifying register+unregister, and also
doing a loop to catch any issues around that. Here's the current kernel:

[root@archlinux liburing]# time test/eventfd-reg 

real	0m7.980s
user	0m0.004s
sys	0m0.000s
[root@archlinux liburing]# time test/eventfd-reg 

real	0m8.197s
user	0m0.004s
sys	0m0.000s

which is around ~80ms for each register/unregister cycle, and here are
the results with this patchset:

[root@archlinux liburing]# time test/eventfd-reg

real	0m0.002s
user	0m0.001s
sys	0m0.000s
[root@archlinux liburing]# time test/eventfd-reg

real	0m0.001s
user	0m0.001s
sys	0m0.000s

which looks a lot more reasonable.

I'll look over this one and see if I've got anything to complain about,
just ran it first since I wrote the test anyway. Here's the test case,
btw:

https://git.kernel.dk/cgit/liburing/commit/?id=5bde26e4587168a439cabdbe73740454249e5204

-- 
Jens Axboe

