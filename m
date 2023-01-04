Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF91665DDAB
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 21:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240096AbjADU02 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 15:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbjADU00 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 15:26:26 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E63373AE
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 12:26:25 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id g10so12755501wmo.1
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 12:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bbl6oAOcfLHSCEiuys6oEiZDm4zugAYZf4BtxWSsPTI=;
        b=QeMnbLn5BTZRw4oV8zJ425PbS86Mu3WYzXN4bwG0owlMtSr2MM2UEPVXLMOKkAHMIh
         d3XckLWurcTdwV75r2nKfpOgtNUsJjnM4jtbVqCQEd3W5YBlzklVezk7k8951A8i1NxF
         GwIgFs0xmjBK7JNg2Jgvi/lNWVEAaV87/ZVFrd+LCf2WHcJR4Qw4Z/LDqrHC3a8eQ6Fm
         F7zpPG+JM9eB7Zr/Xs5XnzKdTtgBGBkGTtPrNGtim76bGjmcVN/h/8Xm3BbdYCuPPdMU
         OC4KnKVpLA7hSCvn3u0WAweTReJaWiFfCJgFxQM8rd9sjZpw0nwrPvosop4HfljZ64Es
         rsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bbl6oAOcfLHSCEiuys6oEiZDm4zugAYZf4BtxWSsPTI=;
        b=FxWQxLYDwU3dkppXSkbn2X2amguHeEj9TRk2CSwYcbbVKMdvMGsukxlpoaKYW0PyXx
         c6pz2cX3gIlK+/yW+T/U5qdZYpf13QG4B5AmrebJbMjQSpRmOJBlKuAQN296VYo5XaLI
         qqfPMO1WwPF0/izbaZnBtjYRGc0vi8ljL7H4nMNm3J4L4DVqN0E4hjZ3DIbM7OHaeAUc
         LMDpw6qBAeWRvIMAawIXlXeJSbyxJS9dGgIsVQjcmku7HY05xsgyRR4sF/w9kJgm7h7Q
         CrcuQ8XXnwFti70kI511B+ENtl7v5lHU2jKWqK6LNnRjw3dh9YI7z094cIKUXQNhUdYw
         f0gA==
X-Gm-Message-State: AFqh2kotI1Fu0I2zzIDRKnIW2d7k0zilpKnxgxYWkdwwUe5OHb2IF48Y
        fHtaO8hGoMgsfEElANFoG8yMmjZGdtg=
X-Google-Smtp-Source: AMrXdXsZJcCB3lHVLG8LboCnwpCwfhFtdM1jka/XQ3Jy5/RGu7p5z8khZsMM1vHVhuju2UQANRoCEA==
X-Received: by 2002:a05:600c:ace:b0:3d1:fe0a:f134 with SMTP id c14-20020a05600c0ace00b003d1fe0af134mr34720530wmr.19.1672863983261;
        Wed, 04 Jan 2023 12:26:23 -0800 (PST)
Received: from [192.168.8.100] (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c3b1200b003a6125562e1sm51742317wms.46.2023.01.04.12.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:26:22 -0800 (PST)
Message-ID: <65da93cd-7521-2070-3317-2986a46f9914@gmail.com>
Date:   Wed, 4 Jan 2023 20:25:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC v2 00/13] CQ waiting and wake up optimisations
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1672713341.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/3/23 03:03, Pavel Begunkov wrote:
> The series replaces waitqueues for CQ waiting with a custom waiting
> loop and adds a couple more perf tweak around it. Benchmarking is done
> for QD1 with simulated tw arrival right after we start waiting, it
> gets us from 7.5 MIOPS to 9.2, which is +22%, or double the number for
> the in-kernel io_uring overhead (i.e. without syscall and userspace).
> That matches profiles, wake_up() _without_ wake_up_state() was taking
> 12-14% and prepare_to_wait_exclusive() was around 4-6%.

The numbers are gathered with an in-kernel trick. Tried to quickly
measure without it:

modprobe null_blk no_sched=1 irqmode=2 completion_nsec=0
taskset -c 0 fio/t/io_uring -d1 -s1 -c1 -p0 -B1 -F1 -X -b512 -n4 /dev/nullb0

The important part here is using timers-backed nullblk and pinning
multiple workers to a single CPU. -n4 was enough for me to keep
the CPU 100% busy.

old:
IOPS=539.51K, BW=2.11GiB/s, IOS/call=1/1
IOPS=542.26K, BW=2.12GiB/s, IOS/call=1/1
IOPS=540.73K, BW=2.11GiB/s, IOS/call=1/1
IOPS=541.28K, BW=2.11GiB/s, IOS/call=0/0

new:
IOPS=561.85K, BW=2.19GiB/s, IOS/call=1/1
IOPS=561.58K, BW=2.19GiB/s, IOS/call=1/1
IOPS=561.56K, BW=2.19GiB/s, IOS/call=1/1
IOPS=559.94K, BW=2.19GiB/s, IOS/call=1/1

The different is only ~3.5%  because of huge additional overhead
for nullb timers, block qos and other unnecessary bits.

P.S. tested with an out-of-tree patch adding a flag enabling/disabling
the feature to remove variance b/w reboots.

-- 
Pavel Begunkov
