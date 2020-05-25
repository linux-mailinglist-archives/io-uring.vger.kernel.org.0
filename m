Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D004C1E101E
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2020 16:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390817AbgEYOKb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 May 2020 10:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388862AbgEYOKa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 May 2020 10:10:30 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C365C05BD43
        for <io-uring@vger.kernel.org>; Mon, 25 May 2020 07:10:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 5so41258pjd.0
        for <io-uring@vger.kernel.org>; Mon, 25 May 2020 07:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OcO07edtTN+YC22DMtvn7bgGQYHqEWV0DlbpUjGbS7Y=;
        b=T+ZO3oLnmzEpqyJX3Z/S9uQ8MwYvxh1EQVM5sv1GujR55scKT8JXd5+I6ACdXu+aJG
         ZCVzlmaYKXlBgtFRhM6B4nEgVBlkmZ9vs8dwsYlEJw8gTH55fG2/q2DPyK95fZ3pf8JV
         uYWSY/iGNhlwnSz8igyUBR/nwqL8oiupeYURpk5jqVHU/JQj8KZS5a/oYy+6x/3jDZip
         BItBtIW7+wMWwGU/gEktPgaw1IoQsOD+SdJtN09uUk7fMHDaS39uq1usKwH+WUPfoSA9
         n1cGeACE3gNYEIOcGaUg3FdgU9d7y1aPm/8KQPF9pN5SGF1oFmN2Qoq9iPCXSJ/TzJJo
         gX5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OcO07edtTN+YC22DMtvn7bgGQYHqEWV0DlbpUjGbS7Y=;
        b=iGmQdVyRzYyL6jcVRNsVgNIYhltC3t1ZApte275bnGxc2VA2Kp/hkGkDunpo7hKziX
         ghUFWrVfZ8Lce7AyHR7ifF0ABKHx3KL6uG5cJbSvitf/yebuGqqPLZJq1SDjItt1J9jG
         5Urpp4aq2CaWlTTES2+JNVwdxy0Cfml6h7p7cWdvBbEopg8xvaJWKwtan0k64/G80QWW
         Hd98XdRHEYSGksubxLts+SuDVBe75o/CXx4Qdk1zCpzr/Ww1mQXw+TmdsdR2I2Bu9Yn0
         fAkhRgtP094VnyDuXdZxq7HduYsQ5N9F2qMe+ZkPyyAVclcJF57RvLZZ6EjESFbkS8nP
         t3Ew==
X-Gm-Message-State: AOAM532r5l83TutpM3T94DaK9BjmcaXJqXM2X9ogkA43nY+qyoR46Llr
        +Oa+pUeq5F3kZDH6Fg589jmIKw==
X-Google-Smtp-Source: ABdhPJzySSFNKQEKywjSi1ASg5xPkGeRVH8c+Jb4249ZlsxLFFSFH1lssoODFU1LFU8WtkyAuwQz2A==
X-Received: by 2002:a17:90a:dd44:: with SMTP id u4mr19310112pjv.132.1590415829858;
        Mon, 25 May 2020 07:10:29 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:a8a5:6c21:23f4:ef58? ([2605:e000:100e:8c61:a8a5:6c21:23f4:ef58])
        by smtp.gmail.com with ESMTPSA id 3sm13526266pfo.27.2020.05.25.07.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 07:10:29 -0700 (PDT)
Subject: Re: io_uring: BUG: kernel NULL pointer dereference
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
References: <20200525103051.lztpbl33hsgv6grz@steredhat>
 <20200525134552.5dyldwmeks3t6vj6@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b1689238-b236-cc93-9909-c09120e7975c@kernel.dk>
Date:   Mon, 25 May 2020 08:10:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200525134552.5dyldwmeks3t6vj6@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/20 7:45 AM, Stefano Garzarella wrote:
> On Mon, May 25, 2020 at 12:30:51PM +0200, Stefano Garzarella wrote:
>> Hi Jens,
>> using fio and io_uring engine with SQPOLL and IOPOLL enabled, I had the
>> following issue that happens after 4/5 seconds fio has started.
>> Initially I had this issue on Linux v5.7-rc6, but I just tried also
>> Linux v5.7-rc7:
>>
>> [   75.343479] nvme nvme0: pci function 0000:04:00.0
>> [   75.355110] nvme nvme0: 16/0/15 default/read/poll queues
>> [   75.364946]  nvme0n1: p1
>> [   82.739285] BUG: kernel NULL pointer dereference, address: 00000000000003b0
>> [   82.747054] #PF: supervisor read access in kernel mode
>> [   82.752785] #PF: error_code(0x0000) - not-present page
>> [   82.758516] PGD 800000046c042067 P4D 800000046c042067 PUD 461fcf067 PMD 0 
>> [   82.766186] Oops: 0000 [#1] SMP PTI
>> [   82.770076] CPU: 2 PID: 1307 Comm: io_uring-sq Not tainted 5.7.0-rc7 #11
>> [   82.777939] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.2.6 06/08/2015
>> [   82.786290] RIP: 0010:task_numa_work+0x4f/0x2c0
>> [   82.791341] Code: 18 4c 8b 25 e3 f0 8e 01 49 8b 9f 00 08 00 00 4d 8b af c8 00 00 00 49 39 c7 0f 85 e8 01 00 00 48 89 6d 00 41 f6 47 24 04 75 67 <48> 8b ab b0 03 00 00 48 85 ed 75 16 8b 3d 6f 68 94 01 e8 aa fb 04
>> [   82.812296] RSP: 0018:ffffaaa98415be10 EFLAGS: 00010246
>> [   82.818123] RAX: ffff953ee36b8000 RBX: 0000000000000000 RCX: 0000000000000000
>> [   82.826083] RDX: 0000000000000001 RSI: ffff953ee36b8000 RDI: ffff953ee36b8dc8
>> [   82.834042] RBP: ffff953ee36b8dc8 R08: 00000000001200db R09: ffff9542e3ad2e08
>> [   82.842002] R10: ffff9542ecd20070 R11: 0000000000000000 R12: 00000000fffca35b
>> [   82.849962] R13: 000000012a06a949 R14: ffff9542e3ad2c00 R15: ffff953ee36b8000
>> [   82.857922] FS:  0000000000000000(0000) GS:ffff953eefc40000(0000) knlGS:0000000000000000
>> [   82.866948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   82.873357] CR2: 00000000000003b0 CR3: 000000046bbd0002 CR4: 00000000001606e0
>> [   82.881316] Call Trace:
>> [   82.884046]  task_work_run+0x68/0xa0
>> [   82.888026]  io_sq_thread+0x252/0x3d0
>> [   82.892111]  ? finish_wait+0x80/0x80
>> [   82.896097]  kthread+0xf9/0x130
>> [   82.899598]  ? __ia32_sys_io_uring_enter+0x370/0x370
>> [   82.905134]  ? kthread_park+0x90/0x90
>> [   82.909217]  ret_from_fork+0x35/0x40
>> [   82.913203] Modules linked in: nvme nvme_core xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc ip6table_mangle ip6table_nat iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter rfkill sunrpc intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul iTCO_wdt crc32_pclmul dcdbas ghash_clmulni_intel iTCO_vendor_support intel_cstate intel_uncore pcspkr intel_rapl_perf ipmi_ssif ixgbe mei_me mdio tg3 dca mei lpc_ich ipmi_si acpi_power_meter ipmi_devintf ipmi_msghandler ip_tables xfs libcrc32c mgag200 drm_kms_helper drm_vram_helper drm_ttm_helper ttm drm megaraid_sas crc32c_intel i2c_algo_bit wmi
>> [   82.990613] CR2: 00000000000003b0
>> [   82.994307] ---[ end trace 6d1725e8f60fece7 ]---
>> [   83.039157] RIP: 0010:task_numa_work+0x4f/0x2c0
>> [   83.044211] Code: 18 4c 8b 25 e3 f0 8e 01 49 8b 9f 00 08 00 00 4d 8b af c8 00 00 00 49 39 c7 0f 85 e8 01 00 00 48 89 6d 00 41 f6 47 24 04 75 67 <48> 8b ab b0 03 00 00 48 85 ed 75 16 8b 3d 6f 68 94 01 e8 aa fb 04
>> [   83.065165] RSP: 0018:ffffaaa98415be10 EFLAGS: 00010246
>> [   83.070993] RAX: ffff953ee36b8000 RBX: 0000000000000000 RCX: 0000000000000000
>> [   83.078953] RDX: 0000000000000001 RSI: ffff953ee36b8000 RDI: ffff953ee36b8dc8
>> [   83.086913] RBP: ffff953ee36b8dc8 R08: 00000000001200db R09: ffff9542e3ad2e08
>> [   83.094873] R10: ffff9542ecd20070 R11: 0000000000000000 R12: 00000000fffca35b
>> [   83.102833] R13: 000000012a06a949 R14: ffff9542e3ad2c00 R15: ffff953ee36b8000
>> [   83.110793] FS:  0000000000000000(0000) GS:ffff953eefc40000(0000) knlGS:0000000000000000
>> [   83.119821] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   83.126230] CR2: 00000000000003b0 CR3: 000000046bbd0002 CR4: 00000000001606e0
>> [  113.113624] nvme nvme0: I/O 219 QID 19 timeout, aborting
>> [  113.120135] nvme nvme0: Abort status: 0x0
>>
>> Steps I did:
>>
>>   $ modprobe nvme poll_queues=15
>>   $ fio fio_iou.job
>>
>> This is the fio_iou.job that I used:
>>
>>   [global]
>>   filename=/dev/nvme0n1
>>   ioengine=io_uring
>>   direct=1
>>   runtime=60
>>   ramp_time=5
>>   gtod_reduce=1
>>
>>   cpus_allowed=4
>>
>>   [job1]
>>   rw=randread
>>   bs=4K
>>   iodepth=1
>>   registerfiles
>>   sqthread_poll=1
>>   sqthread_poll_cpu=2
>>   hipri
>>
>> I'll try to bisect, but I have some suspicions about:
>> b41e98524e42 io_uring: add per-task callback handler
> 
> I confirm, the bisection ended with this:
> b41e98524e424d104aa7851d54fd65820759875a is the first bad commit

I think the odd part here is that task_tick_numa() checks for a
valid mm, and queues work if the task has it. But for the sqpoll
kthread, the mm can come and go. By the time the task work is run,
the mm is gone and we oops on current->mm == NULL.

I think the below should fix it:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 538ba5d94e99..24a8557f001f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2908,7 +2908,8 @@ static void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	/*
 	 * We don't care about NUMA placement if we don't have memory.
 	 */
-	if (!curr->mm || (curr->flags & PF_EXITING) || work->next != work)
+	if (!curr->mm || (curr->flags & (PF_EXITING | PF_KTHREAD)) ||
+	    work->next != work)
 		return;
 
 	/*

-- 
Jens Axboe

