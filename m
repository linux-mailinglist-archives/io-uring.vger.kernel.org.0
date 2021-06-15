Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A0E3A80E3
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhFONmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhFONmW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 09:42:22 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83C4C0611BE
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 06:39:59 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so2040395wmq.5
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 06:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MGzi9gI4uHhGc6Uyx47gpVVD3c+OcUpbf5RuoYMXEWE=;
        b=huaVPxWOKROv24XqlxzGgRMs5HMvMZXxOq4OzAYyDmSUSDLO/2P/K8lUr5/kv8xtV/
         dK0pBNcWrUw337870YiVtnKFSh+LOddg6g3/bKyFtHm9pbbEZ51FfwbS3/AaJCdkNUA8
         clPYhHrNtYGgrd+hR+nN3WW2Vco41HUWDiM69xksM5qm8Ml6LfeM2+eEtGs26r1IxDuh
         Dm3ngJtJccYbCTRlyjaz7VMUjaORp01MkWn2AuV0V6pNLbAhHDYNt4O8lCKFg68lXDpF
         sUhEsr3IG/3iyx3Gkl5CGc9+DdQ7PRrLsu6W5aaWWc5/LmjVkEMA+QkWKP511J0/8ARe
         O5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGzi9gI4uHhGc6Uyx47gpVVD3c+OcUpbf5RuoYMXEWE=;
        b=cwJ97mZh1oETVwK6fN0Y/dZhpz1bkBInVmSJOM0FPAqfU4TVX/B1M4GuyMxfEYA2XK
         LaQykHvfFAtMDw9agUbt8KMNpJ/VxAgfRpdy6N2KxxkXZFCy8+/9beQx1rFnNnGEXjor
         I/T9bxBvHU2B6caITqbtYQg55g0nbEOCdq3gmFJQ04GUB0I1vgPPgNA+OlRdPBPcnT6p
         +qKM+8IIOqKrohUfdGoa4TypoE9N3siGzGkWk/lGydMgzO2Trp/bnVR0hD3eUoZa8ppz
         BPWRWRUtQuSi9qvD2tkZy+OczH2B240WmW5C/V6bd7A0ymjLEhvsn5mWADDturinIFcY
         gQmw==
X-Gm-Message-State: AOAM5311un42jGv6YWwHu+e65bCVp7SpRjvuGyC1UTUDeGw/TkYPdsai
        C61GNLYKPsjXsTzMG2F/coUXKVdkXGV4904E
X-Google-Smtp-Source: ABdhPJwqFLKweJIseMuQj2pdw4AIL2TX/gXyZ0o87Lh6R38Fk0ezFMqTdIlA+fOTNi1R8ug20pTVKg==
X-Received: by 2002:a1c:e90d:: with SMTP id q13mr22771502wmc.163.1623764398346;
        Tue, 15 Jun 2021 06:39:58 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id z5sm300067wrp.92.2021.06.15.06.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 06:39:58 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix link timeout refs
To:     Martin Raiber <martin@urbackup.org>, io-uring@vger.kernel.org
References: <ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com>
 <0102017a00205d53-86fbc6bd-1ae8-4719-91eb-54319f3ab61c-000000@eu-west-1.amazonses.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <4c6e0d31-b27b-213e-afa1-86f8b8d4891d@gmail.com>
Date:   Tue, 15 Jun 2021 14:39:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0102017a00205d53-86fbc6bd-1ae8-4719-91eb-54319f3ab61c-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/21 1:09 PM, Martin Raiber wrote:
> I get this with 5.10.43, maybe it has something to do with this commit?

Can be. I remember there were two related patches close together.
Need to take a look

> 
> [14708.160839] ------------[ cut here ]------------
> [14708.160842] refcount_t: underflow; use-after-free.
> [14708.160858] WARNING: CPU: 0 PID: 14523 at lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0
> [14708.160859] Modules linked in: bcache crc64 zram dm_cache_smq dm_cache dm_persistent_data dm_bio_prison dm_bufio loop dm_crypt bfq xfs dm_mod st sr_mod cdrom bridge stp llc snd_pcm snd_timer snd soundcore serio_raw pcspkr evdev sg hyperv_fb hv_balloon hv_utils hyperv_keyboard joydev button ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi drm configfs ip_tables x_tables autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear md_mod ata_generic crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sd_mod t10_pi hid_generic hid_hyperv hv_netvsc hv_storvsc hid scsi_transport_fc aesni_intel ata_piix crypto_simd cryptd glue_helper libata psmouse scsi_mod i2c_piix4 hv_vmbus
> [14708.160918] CPU: 0 PID: 14523 Comm: +submit worker Not tainted 5.10.43 #1
> [14708.160919] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  05/18/2018
> [14708.160922] RIP: 0010:refcount_warn_saturate+0xa6/0xf0
> [14708.160925] Code: 05 ff c4 14 01 01 e8 2f 87 3e 00 0f 0b c3 80 3d ed c4 14 01 00 75 95 48 c7 c7 90 83 12 82 c6 05 dd c4 14 01 01 e8 10 87 3e 00 <0f> 0b c3 80 3d cc c4 14 01 00 0f 85 72 ff ff ff 48 c7 c7 e8 83 12
> [14708.160926] RSP: 0000:ffffc90003b1fe28 EFLAGS: 00010082
> [14708.160928] RAX: 0000000000000000 RBX: ffff888029d13970 RCX: ffff8882a4a18b88
> [14708.160930] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff8882a4a18b80
> [14708.160931] RBP: ffff888029d13000 R08: ffffffff825e21c8 R09: 0000000000027ffb
> [14708.160932] R10: 00000000ffff8000 R11: 3fffffffffffffff R12: ffff888029d1395c
> [14708.160933] R13: ffff8881e6ff1000 R14: ffff8881e6ff12c0 R15: 0000000000000086
> [14708.160935] FS:  00007ead3b378700(0000) GS:ffff8882a4a00000(0000) knlGS:0000000000000000
> [14708.160936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [14708.160937] CR2: 00007ead28c39b78 CR3: 000000017a310000 CR4: 00000000003506f0
> [14708.160940] Call Trace:
> [14708.160945]  io_link_timeout_fn+0x19d/0x1b0
> [14708.160948]  ? io_async_find_and_cancel+0x120/0x120
> [14708.160952]  __hrtimer_run_queues+0x12a/0x270
> [14708.160954]  hrtimer_interrupt+0x110/0x2c0
> [14708.160957]  __sysvec_hyperv_stimer0+0x2e/0x60
> [14708.160960]  sysvec_hyperv_stimer0+0x31/0x80
> [14708.160963]  ? asm_sysvec_hyperv_stimer0+0xa/0x20
> [14708.160964]  asm_sysvec_hyperv_stimer0+0x12/0x20
> [14708.160967] RIP: 0033:0x562ee0bd7eaf
> [14708.160968] Code: e5 48 83 ec 10 48 89 7d f8 48 8b 45 f8 48 89 c7 e8 ce ff ff ff 48 8b 45 f8 be 08 00 00 00 48 89 c7 e8 e5 eb fe ff c9 c3 90 55 <48> 89 e5 48 83 ec 10 48 89 7d f8 48 83 7d f8 00 74 17 48 8b 45 f8
> [14708.160970] RSP: 002b:00007ead3b3750c0 EFLAGS: 00000206
> [14708.160971] RAX: 0000562ee0bd7eae RBX: 00007f18da102a88 RCX: 0000000000000000
> [14708.160972] RDX: 00007ead379f31e0 RSI: 00007ead3b3751a0 RDI: 00007ead379f31e0
> [14708.160973] RBP: 00007ead3b3750e0 R08: 0000000000000000 R09: 0000562ee0c4c32e
> [14708.160974] R10: 0000015ad445f000 R11: 0000000000000000 R12: 0000000000000001
> [14708.160975] R13: 0000562ee0bef78c R14: 0000000000000000 R15: 0000000000802000
> [14708.160977] ---[ end trace a97dee1eaae3c5d6 ]---
> 
> 
> On 07.05.2021 22:06 Pavel Begunkov wrote:
>> WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
>> RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
>> Call Trace:
>>   __refcount_sub_and_test include/linux/refcount.h:283 [inline]
>>   __refcount_dec_and_test include/linux/refcount.h:315 [inline]
>>   refcount_dec_and_test include/linux/refcount.h:333 [inline]
>>   io_put_req fs/io_uring.c:2140 [inline]
>>   io_queue_linked_timeout fs/io_uring.c:6300 [inline]
>>   __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
>>   io_submit_sqe fs/io_uring.c:6534 [inline]
>>   io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
>>   __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
>>   __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182
>>
>> io_link_timeout_fn() should put only one reference of the linked timeout
>> request, however in case of racing with the master request's completion
>> first io_req_complete() puts one and then io_put_req_deferred() is
>> called.
>>
>> Cc: stable@vger.kernel.org # 5.12+
>> Fixes: 9ae1f8dd372e0 ("io_uring: fix inconsistent lock state")
>> Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> P.s. wasn't able to trigger
>>
>>   fs/io_uring.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index f46acbbeed57..9ac5e278a91e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6363,10 +6363,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>>       if (prev) {
>>           io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
>>           io_put_req_deferred(prev, 1);
>> +        io_put_req_deferred(req, 1);
>>       } else {
>>           io_req_complete_post(req, -ETIME, 0);
>>       }
>> -    io_put_req_deferred(req, 1);
>>       return HRTIMER_NORESTART;
>>   }
>>   
> 
> 

-- 
Pavel Begunkov
