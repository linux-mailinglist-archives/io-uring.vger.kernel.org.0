Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10536F256B
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjD2RRQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 13:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjD2RRP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 13:17:15 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277621B3
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 10:17:14 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b781c9787so340535b3a.1
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 10:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682788633; x=1685380633;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wh2tecoG/SOIbjAoMjLEYWI38jcVC09Ourwewcg6so=;
        b=YpoXu+moBQbpcnqsk6XGOoIw5aS5BkwpHweeXrkcSiB+L9dHUaG+yr6JLYxsT4Spwh
         LUtuHC0D5pH1zsn3TBfLqNqKw5bAJWmJUyruC955+vY7ww/c8GeB7IWaKxuX2AbIrga+
         fRlujMOmTKssnyRCIQIIDHgPl85N1EVkcc1ro+UeHbt21vVnJc3OmtGFSw6LeA2JkhNM
         rdWzI2qm05ChrujER28FUKGDGwQ2R7S2evkOax+ZFlgkztSKhc+ygp1oFJnoOPu9x0Uz
         Ka5sAL8ZaII0VDNJdYaLTI8osss5OAp6PGbXjkk2qCChA1XDXO2kg9eXZqzbVuDdontG
         qeCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682788633; x=1685380633;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wh2tecoG/SOIbjAoMjLEYWI38jcVC09Ourwewcg6so=;
        b=iYGYv8+kvBsuYjo5M/oEIu3qs+MMZMx5Rc4UlKnKNv8yrt9YZgTqXpY093fou9u1vK
         3UnrcAMgfw4rSqn+XF+jL086+Y5+V7V078DdOpO1RTicSlh/7Pm6jJzNUXwxXwNHsJnC
         xv2tOkAxe07A+Hx0CB9UW2Kp605DzwUGGB8RmP88XDwm9uVCmiHZ43pAGVedcMncC8FB
         Sh68Y84QmWctC9EhoeOAejYOXyH2LzUE+5GWglcUfotXr944xU1/xy9DwH7Axp8aQP/E
         3hIOzEtF3UJ112YAq6pKZWaqL3t3YXPHTlV4sJd110wW1XKNvsL4CTaINRC6zN3ydlqp
         nLCA==
X-Gm-Message-State: AC+VfDxrP/h6/Qt4asi3+JvRLnvpJDzYL/QVOAucmJcUbIBUg7wUYv6n
        G9ejW4zYDg7xqsS2P8qw6UQGDA==
X-Google-Smtp-Source: ACHHUZ6Oe9piteGShm01mlinvU7oEyq/rqc3PozEXDwTdw7U3tqcXri396GJLN9wlpv3LLd6BwAOyw==
X-Received: by 2002:a05:6a20:8e19:b0:f6:9492:93b8 with SMTP id y25-20020a056a208e1900b000f6949293b8mr9795411pzj.3.1682788633495;
        Sat, 29 Apr 2023 10:17:13 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090abd1600b00246b7b8b43asm3268939pjr.49.2023.04.29.10.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Apr 2023 10:17:12 -0700 (PDT)
Message-ID: <d7e9e68d-64b2-ab30-3c93-13dbeda27bce@kernel.dk>
Date:   Sat, 29 Apr 2023 11:17:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 00/12] io_uring attached nvme queue
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, sagi@grimberg.me,
        kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com
References: <CGME20230429094228epcas5p4a80d8ed77433989fa804ecf449f83b0b@epcas5p4.samsung.com>
 <20230429093925.133327-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/23 3:39?AM, Kanchan Joshi wrote:
> This series shows one way to do what the title says.
> This puts up a more direct/lean path that enables
>  - submission from io_uring SQE to NVMe SQE
>  - completion from NVMe CQE to io_uring CQE
> Essentially cutting the hoops (involving request/bio) for nvme io path.
> 
> Also, io_uring ring is not to be shared among application threads.
> Application is responsible for building the sharing (if it feels the
> need). This means ring-associated exclusive queue can do away with some
> synchronization costs that occur for shared queue.
> 
> Primary objective is to amp up of efficiency of kernel io path further
> (towards PCIe gen N, N+1 hardware).
> And we are seeing some asks too [1].
> 
> Building-blocks
> ===============
> At high level, series can be divided into following parts -
> 
> 1. nvme driver starts exposing some queue-pairs (SQ+CQ) that can
> be attached to other in-kernel user (not just to block-layer, which is
> the case at the moment) on demand.
> 
> Example:
> insmod nvme.ko poll_queus=1 raw_queues=2
> 
> nvme0: 24/0/1/2 default/read/poll queues/raw queues
> 
> While driver registers other queues with block-layer, raw-queues are
> rather reserved for exclusive attachment with other in-kernel users.
> At this point, each raw-queue is interrupt-disabled (similar to
> poll_queues). Maybe we need a better name for these (e.g. app/user queues).
> [Refer: patch 2]
> 
> 2. register/unregister queue interface
> (a) one for io_uring application to ask for device-queue and register
> with the ring. [Refer: patch 4]
> (b) another at nvme so that other in-kernel users (io_uring for now) can
> ask for a raw-queue. [Refer: patch 3, 5, 6]
> 
> The latter returns a qid, that io_uring stores internally (not exposed
> to user-space) in the ring ctx. At max one queue per ring is enabled.
> Ring has no other special properties except the fact that it stores a
> qid that it can use exclusively. So application can very well use the
> ring to do other things than nvme io.
> 
> 3. user-interface to send commands down this way
> (a) uring-cmd is extended to support a new flag "IORING_URING_CMD_DIRECT"
> that application passes in the SQE. That is all.
> (b) the flag goes down to provider of ->uring_cmd which may choose to do
>   things differently based on it (or ignore it).
> [Refer: patch 7]
> 
> 4. nvme uring-cmd understands the above flag. It submits the command
> into the known pre-registered queue, and completes (polled-completion)
> from it. Transformation from "struct io_uring_cmd" to "nvme command" is
> done directly without building other intermediate constructs.
> [Refer: patch 8, 10, 12]
> 
> Testing and Performance
> =======================
> fio and t/io_uring is modified to exercise this path.
> - fio: new "registerqueues" option
> - t/io_uring: new "k" option
> 
> Good part:
> 2.96M -> 5.02M
> 
> nvme io (without this):
> # t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k0 /dev/ng0n1
> submitter=0, tid=2922, file=/dev/ng0n1, node=-1
> polled=1, fixedbufs=1/0, register_files=1, buffered=1, register_queues=0 QD=64
> Engine=io_uring, sq_ring=64, cq_ring=64
> IOPS=2.89M, BW=1412MiB/s, IOS/call=2/1
> IOPS=2.92M, BW=1426MiB/s, IOS/call=2/2
> IOPS=2.96M, BW=1444MiB/s, IOS/call=2/1
> Exiting on timeout
> Maximum IOPS=2.96M
> 
> nvme io (with this):
> # t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/ng0n1
> submitter=0, tid=2927, file=/dev/ng0n1, node=-1
> polled=1, fixedbufs=1/0, register_files=1, buffered=1, register_queues=1 QD=64
> Engine=io_uring, sq_ring=64, cq_ring=64
> IOPS=4.99M, BW=2.43GiB/s, IOS/call=2/1
> IOPS=5.02M, BW=2.45GiB/s, IOS/call=2/1
> IOPS=5.02M, BW=2.45GiB/s, IOS/call=2/1
> Exiting on timeout
> Maximum IOPS=5.02M
> 
> Not so good part:
> While single IO is fast this way, we do not have batching abilities for
> multi-io scenario. Plugging, submission and completion batching are tied to
> block-layer constructs. Things should look better if we could do something
> about that.
> Particularly something is off with the completion-batching.
> 
> With -s32 and -c32, the numbers decline:
> 
> # t/io_uring -b512 -d64 -c32 -s32 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/ng0n1
> submitter=0, tid=3674, file=/dev/ng0n1, node=-1
> polled=1, fixedbufs=1/0, register_files=1, buffered=1, register_queues=1 QD=64
> Engine=io_uring, sq_ring=64, cq_ring=64
> IOPS=3.70M, BW=1806MiB/s, IOS/call=32/31
> IOPS=3.71M, BW=1812MiB/s, IOS/call=32/31
> IOPS=3.71M, BW=1812MiB/s, IOS/call=32/32
> Exiting on timeout
> Maximum IOPS=3.71M
> 
> And perf gets restored if we go back to -c2
> 
> # t/io_uring -b512 -d64 -c2 -s32 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/ng0n1
> submitter=0, tid=3677, file=/dev/ng0n1, node=-1
> polled=1, fixedbufs=1/0, register_files=1, buffered=1, register_queues=1 QD=64
> Engine=io_uring, sq_ring=64, cq_ring=64
> IOPS=4.99M, BW=2.44GiB/s, IOS/call=5/5
> IOPS=5.02M, BW=2.45GiB/s, IOS/call=5/5
> IOPS=5.02M, BW=2.45GiB/s, IOS/call=5/5
> Exiting on timeout
> Maximum IOPS=5.02M
> 
> Source
> ======
> Kernel: https://github.com/OpenMPDK/linux/tree/feat/directq-v1
> fio: https://github.com/OpenMPDK/fio/commits/feat/rawq-v2
> 
> Please take a look.

This looks like a great starting point! Unfortunately I won't be at
LSFMM this year to discuss it in person, but I'll be taking a closer
look at this. Some quick initial reactions:

- I'd call them "user" queues rather than raw or whatever, I think that
  more accurately describes what they are for.

- I guess there's no way around needing to pre-allocate these user
  queues, just like we do for polled_queues right now? In terms of user
  API, it'd be nicer if you could just do IORING_REGISTER_QUEUE (insert
  right name here...) and it'd allocate and return you an ID.

- Need to take a look at the uring_cmd stuff again, but would be nice if
  we did not have to add more stuff to fops for this. Maybe we can set
  aside a range of "ioctl" type commands through uring_cmd for this
  instead, and go that way for registering/unregistering queues.

We do have some users that are CPU constrained, and while my testing
easily maxes out a gen2 optane (actually 2 or 3) with the generic IO
path, that's also with all the fat that adds overhead removed. Most
people don't have this luxury, necessarily, or actually need some of
this fat for their monitoring, for example. This would provide a nice
way to have pretty consistent and efficient performance across distro
type configs, which would be great, while still retaining the fattier
bits for "normal" IO.
 

-- 
Jens Axboe

