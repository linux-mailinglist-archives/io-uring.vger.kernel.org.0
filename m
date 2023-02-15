Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB742698888
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 00:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBOXDN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 18:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBOXDN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 18:03:13 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD1C457FC
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 15:02:52 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id w20-20020a17090a8a1400b00233d7314c1cso3926361pjn.5
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 15:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pt01F/AL0bHCD2M1+Qbo+8jJHgibTZI9pFJ6Cm89/Mo=;
        b=ugnNSrxeDiMH5X5R6ZjCCQ/DzhZ4d80O36pYq3S9RWJVMDLV27rC9BbdCo484P/ThA
         HFLta5T6H6JnwO9rWQIprn8AyHdkroTKjDJ3l/6TMX1pqRW7sjeUl63LD4eycpGydZCz
         w5n/egZI+HngmF9Xw6cESdcuOekHCYqya9eZ8BRGQ1W2W2P9XP2y8rpfFaKV4XhXVxiN
         EXkMXMLUQW2cRNtyn7IJG6NhHC9P5w2UG2sQ2Mu5vvo+/JkIpuNTBz4+DM9dPFjiztlt
         Mk8z8zthh2TzKlbm18T8GAHrl59zt6nenhqxp/3akaBLKqlG+0duex5Irm4krTRsktyS
         lqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pt01F/AL0bHCD2M1+Qbo+8jJHgibTZI9pFJ6Cm89/Mo=;
        b=v1M/zM6mfRKlmgwHuuP+j9MccqzurfYudFdwNbggTEK/z8zn+9qJfjMNDQoHj76Bia
         XKI2LoaoNM/QQT8WflzONuhVEJ6GXDMkM7QGaRiwrWJFx0pwE+T991XOmkpVh1XdaZbL
         JScV7toM6rGC+IfKDdvZ7uQoaNiSvMQBK3gkHSe6CNvgEMVbxaQqdmJMZwoYRiY/Db+o
         ZeakbtHEJftLAhP8ZS5ELNCjTR7Pg8arFMTrBKWtTc99U4WPa6kOa7oVXqPA7X0DVn5N
         o3Ht8ibnHvvSs9r3rjEJyoIw71aIYTNVNKM9ZA5J/8MzbFvfAMyCsi2+5Xe+1Zbrj3aQ
         1LEw==
X-Gm-Message-State: AO0yUKXXR7JJ16rM+s26uIxiyznQymqo0eDySJ1myzx/G0j7ZYiegCJZ
        +p1Rpy515eybD3wBYL4tZVYPEw==
X-Google-Smtp-Source: AK7set8IZCm+hUBBe9GG/6VSOARu2D+S3wpMM0veliSrozUjFzr1K59RUOiX7gG3Gd8iEUUc7aOtig==
X-Received: by 2002:a17:903:41cc:b0:199:3f82:ef62 with SMTP id u12-20020a17090341cc00b001993f82ef62mr4421643ple.5.1676502171113;
        Wed, 15 Feb 2023 15:02:51 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l3-20020a170903120300b00186c3afb49esm12615649plh.209.2023.02.15.15.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 15:02:50 -0800 (PST)
Message-ID: <73566dc4-317b-5808-a5a5-78dc195ebd77@kernel.dk>
Date:   Wed, 15 Feb 2023 16:02:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
 <0bfe6cdb-2749-c08d-a1b2-ef46fed1ded3@bell.net>
 <a03d75b9-a9b8-b950-c53d-6df85fe8adc4@kernel.dk>
 <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
 <4f4f9048-b382-fa0e-8b51-5a0f0bb08402@kernel.dk>
 <99a41070-f334-f3cb-47cd-8855c938d71f@bell.net>
 <d8dc9156-c001-8181-a946-e9fdfe13f165@kernel.dk>
 <c7725c80-ba8c-1182-7adc-bc107f4f5b75@bell.net>
 <5e72c1fc-1a7b-a4ed-4097-96816b802e6d@bell.net>
 <c100a264-d897-1b9e-0483-22272bccd802@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c100a264-d897-1b9e-0483-22272bccd802@bell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/15/23 3:10 PM, John David Anglin wrote:
> On 2023-02-15 4:39 p.m., John David Anglin wrote:
>> On 2023-02-15 4:06 p.m., John David Anglin wrote:
>>> On 2023-02-15 3:37 p.m., Jens Axboe wrote:
>>>>> System crashes running test buf-ring.t.
>>>> Huh, what's the crash?
>>> Not much info.  System log indicates an HPMC occurred. Unfortunately, recovery code doesn't work.
>> The following occurred running buf-ring.t under gdb:
>>
>> INFO: task kworker/u64:9:18319 blocked for more than 123 seconds.
>>       Not tainted 6.1.12+ #4
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:kworker/u64:9   state:D stack:0     pid:18319 ppid:2 flags:0x00000000
>> Workqueue: events_unbound io_ring_exit_work
>> Backtrace:
>>  [<0000000040b5c210>] __schedule+0x2e8/0x7f0
>>  [<0000000040b5c7d0>] schedule+0xb8/0x1d0
>>  [<0000000040b66534>] schedule_timeout+0x11c/0x1b0
>>  [<0000000040b5d71c>] __wait_for_common+0x194/0x2e8
>>  [<0000000040b5d8ac>] wait_for_completion+0x3c/0x50
>>  [<0000000040b46508>] io_ring_exit_work+0x3d8/0x4d0
>>  [<0000000040268da8>] process_one_work+0x238/0x520
>>  [<00000000402692a4>] worker_thread+0x214/0x778
>>  [<0000000040276f94>] kthread+0x24c/0x258
>>  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28
>>
>> INFO: task kworker/u64:10:18320 blocked for more than 123 seconds.
>>       Not tainted 6.1.12+ #4
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:kworker/u64:10  state:D stack:0     pid:18320 ppid:2 flags:0x00000000
>> Workqueue: events_unbound io_ring_exit_work
>> Backtrace:
>>  [<0000000040b5c210>] __schedule+0x2e8/0x7f0
>>  [<0000000040b5c7d0>] schedule+0xb8/0x1d0
>>  [<0000000040b66534>] schedule_timeout+0x11c/0x1b0
>>  [<0000000040b5d71c>] __wait_for_common+0x194/0x2e8
>>  [<0000000040b5d8ac>] wait_for_completion+0x3c/0x50
>>  [<0000000040b46508>] io_ring_exit_work+0x3d8/0x4d0
>>  [<0000000040268da8>] process_one_work+0x238/0x520
>>  [<00000000402692a4>] worker_thread+0x214/0x778
>>  [<0000000040276f94>] kthread+0x24c/0x258
>>  [<0000000040202020>] ret_from_kernel_thread+0x20/0x28
>>
>> gdb was sitting at a break at line 328.
> With Helge's latest patch, we get a software lockup:
> 
> TCP: request_sock_TCP: Possible SYN flooding on port 31309. Sending cookies.  Check SNMP counters.
> watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u64:13:14621]
> Modules linked in: binfmt_misc ext4 crc16 jbd2 ext2 mbcache sg ipmi_watchdog ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse nfsd ip_tables x_tables ipv6 autofs4 xfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod sd_mod t10_pi ses enclosure scsi_transport_sas crc64_rocksoft crc64 sr_mod uas usb_storage cdrom ohci_pci ehci_pci ohci_hcd pata_cmd64x ehci_hcd sym53c8xx libata scsi_transport_spi usbcore tg3 scsi_mod scsi_common usb_common
> CPU: 0 PID: 14621 Comm: kworker/u64:13 Not tainted 6.1.12+ #5
> Hardware name: 9000/800/rp3440
> Workqueue: events_unbound io_ring_exit_work

This is not related to Helge's patch, 6.1-stable is just still missing:

commit fcc926bb857949dbfa51a7d95f3f5ebc657f198c
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Jan 27 09:28:13 2023 -0700

    io_uring: add a conditional reschedule to the IOPOLL cancelation loop

and I'm guessing you're running without preempt.

-- 
Jens Axboe


