Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B455741AA
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 04:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiGNC7Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 22:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiGNC7Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 22:59:24 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43F322515
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 19:59:18 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 72so372082pge.0
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 19:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=1KjU3PLDicyTH9daCuPh3Hm/2NYtDhdcfpWa369op3Q=;
        b=P5iQCyYlTsWtVPtEI0II+heIZcCoqfKjjY/xe4s2LceVtVDAHq00Lu3V671XO9gku7
         ZEg3PGC9W0VsHuaUE2hYzV8yIXcus0U8vDn1HaqzvGhE2W22MedVCuSOF85jx5sU52dB
         A8UAGW6WZOBAcL93zXURNqLAj+/ANC2GyBz5gQvc2iFNY5ISoR4gtHgp4XDR9TtSmSJR
         EZ+41S8nT6NSsH8Hw9YJwWqQiX9ufJg6fWnRrTLEAYf2emokOZJEaWkELyrFcQNVDg+l
         +OUO98q768NrpGwYzL1TzVZBV7Ox2AcDg4Pj96PcLZweruJGqrU/3VYyr9nxbaOVdxWJ
         aYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=1KjU3PLDicyTH9daCuPh3Hm/2NYtDhdcfpWa369op3Q=;
        b=OXv/iKtlH3fSmKLB7wCYPF5rWOwIabddu0otpAW/KGpe9Gb9hKtF3CGyHyDz7IN6nW
         EqaSRUXQq14PO4IgKaCbJnkyT/va5lwN1stTIEhA98eEsr8VtK8n/UVt8gLultIxp3fE
         2XHuaKY8o70FAqAUDMY8k5DIfMnmkubXKlonS55fma8wD1Nd1/mx20Zq0EajpHMYSD/2
         xeC0DGnQ5ASRlkO2/SUfiJczhWhOEpTXej4/M/Y5nJ72bT3Rjswn2tcb1mG6oBsgdirK
         6RMyywpOOmLh8594iJjnzNHFSrUnDVhQIRZi20W3ZWIGJkI/lEL96Sbc1bj10GqOHoVg
         Y7EA==
X-Gm-Message-State: AJIora83Y7Bhz9Wz/0ob4d+wtyuuxzGuwhExCCNrwQtu5LD+0LsjNq1o
        Y5jnxNTcEQ3j2079bBiVzk4BNg==
X-Google-Smtp-Source: AGRyM1tEmFHfcBWA2ZOuLTAe6QSvtuq1xH6f410WpSbSCppUsKGCEnMcfChAcS4BhJ7h2U4zEo2wrA==
X-Received: by 2002:a63:460f:0:b0:412:7a8b:128c with SMTP id t15-20020a63460f000000b004127a8b128cmr5833883pga.270.1657767558145;
        Wed, 13 Jul 2022 19:59:18 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e29-20020aa7981d000000b0052ab54a4711sm271471pfl.150.2022.07.13.19.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 19:59:17 -0700 (PDT)
Message-ID: <38b6e5f5-247a-bd44-061d-f492e7d47b99@kernel.dk>
Date:   Wed, 13 Jul 2022 20:59:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V5 0/2] ublk: add io_uring based userspace block driver
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220713140711.97356-1-ming.lei@redhat.com>
 <6e5d590b-448d-ea75-f29d-877a2cd6413b@kernel.dk> <Ys9g9RhZX5uwa9Ib@T590>
 <94289486-a7fa-1801-3c67-717e0392f374@kernel.dk>
In-Reply-To: <94289486-a7fa-1801-3c67-717e0392f374@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/22 8:54 PM, Jens Axboe wrote:
> On 7/13/22 6:19 PM, Ming Lei wrote:
>> On Wed, Jul 13, 2022 at 02:25:25PM -0600, Jens Axboe wrote:
>>> On 7/13/22 8:07 AM, Ming Lei wrote:
>>>> Hello Guys,
>>>>
>>>> ublk driver is one kernel driver for implementing generic userspace block
>>>> device/driver, which delivers io request from ublk block device(/dev/ublkbN) into
>>>> ublk server[1] which is the userspace part of ublk for communicating
>>>> with ublk driver and handling specific io logic by its target module.
>>>
>>> Ming, is this ready to get merged in an experimental state?
>>
>> Hi Jens,
>>
>> Yeah, I think so.
>>
>> IO path can survive in xfstests(-g auto), and control path works
>> well in ublksrv builtin hotplug & 'kill -9' daemon test.
>>
>> The UAPI data size should be good, but definition may change per
>> future requirement change, so I think it is ready to go as
>> experimental.
> 
> OK let's give it a go then. I tried it out and it seems to work for me,
> even if the shutdown-while-busy is something I'd to look into a bit
> more.
> 
> BTW, did notice a typo on the github page:
> 
> 2) dependency
> - liburing with IORING_SETUP_SQE128 support
> 
> - linux kernel 5.9(IORING_SETUP_SQE128 support)
> 
> that should be 5.19, typo.

I tried this:

axboe@m1pro-kvm ~/g/ubdsrv (master)> sudo ./ublk add -t loop /dev/nvme0n1
axboe@m1pro-kvm ~/g/ubdsrv (master) [255]> 

and got this dump:

[   34.041647] WARNING: CPU: 3 PID: 60 at block/blk-mq.c:3880 blk_mq_release+0xa4/0xf0
[   34.043858] Modules linked in:
[   34.044911] CPU: 3 PID: 60 Comm: kworker/3:1 Not tainted 5.19.0-rc6-00320-g5c37a506da31 #1608
[   34.047689] Hardware name: linux,dummy-virt (DT)
[   34.049207] Workqueue: events blkg_free_workfn
[   34.050731] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   34.053026] pc : blk_mq_release+0xa4/0xf0
[   34.054360] lr : blk_mq_release+0x44/0xf0
[   34.055694] sp : ffff80000b16bcb0
[   34.056804] x29: ffff80000b16bcb0 x28: 0000000000000000 x27: 0000000000000000
[   34.059135] x26: 0000000000000000 x25: ffff00001fe9bb05 x24: 0000000000000000
[   34.061454] x23: ffff000005062eb8 x22: ffff000004608998 x21: 0000000000000000
[   34.063775] x20: ffff000004608a50 x19: ffff000004608950 x18: ffff80000b7b3c88
[   34.066085] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[   34.068410] x14: 0000000000000002 x13: 0000000000013638 x12: 0000000000000000
[   34.070715] x11: ffff80000945b7e8 x10: 0000000000006f2e x9 : 00000000ffffffff
[   34.073037] x8 : ffff800008fb5000 x7 : ffff80000860cf28 x6 : 0000000000000000
[   34.075334] x5 : 0000000000000000 x4 : 0000000000000028 x3 : ffff80000b16bc14
[   34.077650] x2 : ffff0000086d66a8 x1 : ffff0000086d66a8 x0 : ffff0000086d6400
[   34.079966] Call trace:
[   34.080789]  blk_mq_release+0xa4/0xf0
[   34.081811]  blk_release_queue+0x58/0xa0
[   34.082758]  kobject_put+0x84/0xe0
[   34.083590]  blk_put_queue+0x10/0x18
[   34.084468]  blkg_free_workfn+0x58/0x84
[   34.085511]  process_one_work+0x2ac/0x438
[   34.086449]  worker_thread+0x1cc/0x264
[   34.087322]  kthread+0xd0/0xe0
[   34.088053]  ret_from_fork+0x10/0x20


-- 
Jens Axboe

