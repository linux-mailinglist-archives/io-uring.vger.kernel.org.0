Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D23450A358
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 16:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389772AbiDUOx7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 10:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389689AbiDUOxz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 10:53:55 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B5A43EDA
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 07:50:47 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id s25so2164960wrb.8
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 07:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=o4mayAdAkyInCPYgfHHms9b6cOuMuaIotjJwxw+6hts=;
        b=mQ11i20w62MMp7RBOxi/qhuXoOxf9wh/a5Fc6gG1qyKlpCxun5iK8jFUj+A3vW0Wh2
         cuft+VYwC73ta+6Hi5/dBlcqedWO4hYEoxhp5ILVT/urfd3b/rbVu7Sk3ISldTmo1G4w
         YMS642IGNbF22ZXkhIQftJxcEN3+d+3CcgnO4qxLh1nRf6ITuQ1khxWR9S3admYD7lvJ
         frlfK7W7qjK/53/LioC9jB+pMKq5b2xwLDSSxsJm+2Ex1bZ4mzBSregukp+eNdzmnS0s
         hIBY32JYBJD0Epzt8mqmsc7cGxLByy7UttRIyETjqf8iX8rqf8H+uyFXcwcVj4PI+QsR
         C0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o4mayAdAkyInCPYgfHHms9b6cOuMuaIotjJwxw+6hts=;
        b=xs4OfPXlSg8ZzuxH89g94M7z1vWixl1URt9u2RD1POjAKu1FSazzLS3sDyUaqpI/UL
         SegdaCEuUeCMALcIiawwCo4bPSi0XSmvzCqTGqN82ZpY5J+UPERwk04HyB2P6igQKliY
         g33njH0cYVyQk0hR2WrF1XVTRdK34FAJ19ytuIUUoVr2qBcyxqLmdZfLTte0mDJHVlKk
         +Dv/kftaAfvEBuUSelKZK5GhZcBJEubDriYkOoQPfINGizrMLmS8Ulv9GqaKrsYmaNSc
         ybSYgHfUItrCsXuh/xy/loOXq9mEFjGiGrjTFSO5zrnmNasscalI7Wqc9kPr2aj2C8KP
         X2VA==
X-Gm-Message-State: AOAM530cIIRp2rNNyMWiMQNFRV42GNGAGK0XV1q55905RWZTy/nz/zVD
        OsPy1EnYGCc51EVAkpdwV8CueI3wHKY=
X-Google-Smtp-Source: ABdhPJzq4KvF9FDYdVyD3H5jbSaKrAP17ARHhTA7iHsETFdmH9tA33T3X/pO7LKVtn96rggAA+Ipxw==
X-Received: by 2002:adf:f508:0:b0:207:a8fe:c8bd with SMTP id q8-20020adff508000000b00207a8fec8bdmr64393wro.313.1650552646011;
        Thu, 21 Apr 2022 07:50:46 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id b13-20020a05600018ad00b0020a87feadfcsm2936011wri.84.2022.04.21.07.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 07:50:45 -0700 (PDT)
Message-ID: <6088470f-d7f8-f5d3-1860-2f5aeda32935@gmail.com>
Date:   Thu, 21 Apr 2022 15:50:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC 00/11] io_uring specific task_work infra
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1650548192.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1650548192.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/22 14:44, Pavel Begunkov wrote:
> For experiments only. If proves to be useful would need to make it
> nicer on the non-io_uring side.
> 
> 0-10 save 1 spinlock/unlock_irq pair and 2 cmpxchg per batch. 11/11 in
> general trades 1 per tw add spin_lock/unlock_irq and 2 per batch spinlocking
> with 2 cmpxchg to 1 per tw add cmpxchg and 1 per batch cmpxchg.

null_blk irqmode=1 completion_nsec=0 submit_queues=32 poll_queues=32
echo -n 0 > /sys/block/nullb0/queue/iostats
echo -n 2 > /sys/block/nullb0/queue/nomerges
io_uring -d<QD> -s<QD> -c<QD> -p0 -B1 -F1 -b512 /dev/nullb0


      | base | 1-10         | 1-11
___________________________________________
QD1  | 1.88 | 2.15 (+14%)  | 2.19 (+16.4%)
QD4  | 2.8  | 3.06 (+9.2%) | 3.11 (+11%)
QD32 | 3.61 | 3.81 (+5.5%) | 3.96 (+9.6%)

The numbers are in MIOPS, (%) is relative diff with the baseline.
It gives more than I expected, but the testing is not super
consistent, so a part of it might be due to variance.


> Pavel Begunkov (11):
>    io_uring: optimise io_req_task_work_add
>    io_uringg: add io_should_fail_tw() helper
>    io_uring: ban tw queue for exiting processes
>    io_uring: don't take ctx refs in tctx_task_work()
>    io_uring: add dummy io_uring_task_work_run()
>    task_work: add helper for signalling a task
>    io_uring: run io_uring task_works on TIF_NOTIFY_SIGNAL
>    io_uring: wire io_uring specific task work
>    io_uring: refactor io_run_task_work()
>    io_uring: remove priority tw list
>    io_uring: lock-free task_work stack
> 
>   fs/io-wq.c                |   1 +
>   fs/io_uring.c             | 213 +++++++++++++++-----------------------
>   include/linux/io_uring.h  |   4 +
>   include/linux/task_work.h |   4 +
>   kernel/entry/kvm.c        |   1 +
>   kernel/signal.c           |   2 +
>   kernel/task_work.c        |  33 +++---
>   7 files changed, 115 insertions(+), 143 deletions(-)
> 

-- 
Pavel Begunkov
