Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5E43A4E97
	for <lists+io-uring@lfdr.de>; Sat, 12 Jun 2021 14:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhFLML1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Jun 2021 08:11:27 -0400
Received: from a4-1.smtp-out.eu-west-1.amazonses.com ([54.240.4.1]:58231 "EHLO
        a4-1.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231338AbhFLMLU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Jun 2021 08:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=vbsgq4olmwpaxkmtpgfbbmccllr2wq3g; d=urbackup.org; t=1623499759;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=59eDDRVgFZIKOoLW3rxSyIaMb7iMEJTUysOkKB7gGVo=;
        b=L/4ytbn8HfovwNdIes/M+hSI2/sO9Luo+AFew40TYGbl7VMlo6Jv3lvXa53MloHl
        /QrSkBEDWDa8R5hQXY+bPdWWJJnsenPoaNWdSB1GaWXyBjJqqZuGckzAmz8Az4i8Dv2
        t5nzQ+aXWXId+6WGPYw9lwoM7mQfUc/WLfTQfU18=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=uku4taia5b5tsbglxyj6zym32efj7xqv; d=amazonses.com; t=1623499759;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=59eDDRVgFZIKOoLW3rxSyIaMb7iMEJTUysOkKB7gGVo=;
        b=IUmXTEmNqyZ24LzO8eUy5tzEEhmB2d4y5ckx2ZpOnzbJhBkcUQaoBCeY7NdEi1AX
        Cp1J2kfCl/ZcxIWvSN/ZGbGCr0ouLgjDPZhaqzj1WtVVQLg1PAK9m6+rH0Xw0sHPEJZ
        nDA7sE22NVgay9rdiBuLR+KJ+5CEnRB0/T5BRmgY=
Subject: Re: [PATCH 1/1] io_uring: fix link timeout refs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <0102017a00205d53-86fbc6bd-1ae8-4719-91eb-54319f3ab61c-000000@eu-west-1.amazonses.com>
Date:   Sat, 12 Jun 2021 12:09:19 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
X-SES-Outgoing: 2021.06.12-54.240.4.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I get this with 5.10.43, maybe it has something to do with this commit?

[14708.160839] ------------[ cut here ]------------
[14708.160842] refcount_t: underflow; use-after-free.
[14708.160858] WARNING: CPU: 0 PID: 14523 at lib/refcount.c:28 
refcount_warn_saturate+0xa6/0xf0
[14708.160859] Modules linked in: bcache crc64 zram dm_cache_smq 
dm_cache dm_persistent_data dm_bio_prison dm_bufio loop dm_crypt bfq xfs 
dm_mod st sr_mod cdrom bridge stp llc snd_pcm snd_timer snd soundcore 
serio_raw pcspkr evdev sg hyperv_fb hv_balloon hv_utils hyperv_keyboard 
joydev button ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp 
libiscsi scsi_transport_iscsi drm configfs ip_tables x_tables autofs4 
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx raid1 raid0 multipath linear md_mod ata_generic 
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sd_mod 
t10_pi hid_generic hid_hyperv hv_netvsc hv_storvsc hid scsi_transport_fc 
aesni_intel ata_piix crypto_simd cryptd glue_helper libata psmouse 
scsi_mod i2c_piix4 hv_vmbus
[14708.160918] CPU: 0 PID: 14523 Comm: +submit worker Not tainted 5.10.43 #1
[14708.160919] Hardware name: Microsoft Corporation Virtual 
Machine/Virtual Machine, BIOS 090007  05/18/2018
[14708.160922] RIP: 0010:refcount_warn_saturate+0xa6/0xf0
[14708.160925] Code: 05 ff c4 14 01 01 e8 2f 87 3e 00 0f 0b c3 80 3d ed 
c4 14 01 00 75 95 48 c7 c7 90 83 12 82 c6 05 dd c4 14 01 01 e8 10 87 3e 
00 <0f> 0b c3 80 3d cc c4 14 01 00 0f 85 72 ff ff ff 48 c7 c7 e8 83 12
[14708.160926] RSP: 0000:ffffc90003b1fe28 EFLAGS: 00010082
[14708.160928] RAX: 0000000000000000 RBX: ffff888029d13970 RCX: 
ffff8882a4a18b88
[14708.160930] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: 
ffff8882a4a18b80
[14708.160931] RBP: ffff888029d13000 R08: ffffffff825e21c8 R09: 
0000000000027ffb
[14708.160932] R10: 00000000ffff8000 R11: 3fffffffffffffff R12: 
ffff888029d1395c
[14708.160933] R13: ffff8881e6ff1000 R14: ffff8881e6ff12c0 R15: 
0000000000000086
[14708.160935] FS:  00007ead3b378700(0000) GS:ffff8882a4a00000(0000) 
knlGS:0000000000000000
[14708.160936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14708.160937] CR2: 00007ead28c39b78 CR3: 000000017a310000 CR4: 
00000000003506f0
[14708.160940] Call Trace:
[14708.160945]  io_link_timeout_fn+0x19d/0x1b0
[14708.160948]  ? io_async_find_and_cancel+0x120/0x120
[14708.160952]  __hrtimer_run_queues+0x12a/0x270
[14708.160954]  hrtimer_interrupt+0x110/0x2c0
[14708.160957]  __sysvec_hyperv_stimer0+0x2e/0x60
[14708.160960]  sysvec_hyperv_stimer0+0x31/0x80
[14708.160963]  ? asm_sysvec_hyperv_stimer0+0xa/0x20
[14708.160964]  asm_sysvec_hyperv_stimer0+0x12/0x20
[14708.160967] RIP: 0033:0x562ee0bd7eaf
[14708.160968] Code: e5 48 83 ec 10 48 89 7d f8 48 8b 45 f8 48 89 c7 e8 
ce ff ff ff 48 8b 45 f8 be 08 00 00 00 48 89 c7 e8 e5 eb fe ff c9 c3 90 
55 <48> 89 e5 48 83 ec 10 48 89 7d f8 48 83 7d f8 00 74 17 48 8b 45 f8
[14708.160970] RSP: 002b:00007ead3b3750c0 EFLAGS: 00000206
[14708.160971] RAX: 0000562ee0bd7eae RBX: 00007f18da102a88 RCX: 
0000000000000000
[14708.160972] RDX: 00007ead379f31e0 RSI: 00007ead3b3751a0 RDI: 
00007ead379f31e0
[14708.160973] RBP: 00007ead3b3750e0 R08: 0000000000000000 R09: 
0000562ee0c4c32e
[14708.160974] R10: 0000015ad445f000 R11: 0000000000000000 R12: 
0000000000000001
[14708.160975] R13: 0000562ee0bef78c R14: 0000000000000000 R15: 
0000000000802000
[14708.160977] ---[ end trace a97dee1eaae3c5d6 ]---


On 07.05.2021 22:06 Pavel Begunkov wrote:
> WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
> RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
> Call Trace:
>   __refcount_sub_and_test include/linux/refcount.h:283 [inline]
>   __refcount_dec_and_test include/linux/refcount.h:315 [inline]
>   refcount_dec_and_test include/linux/refcount.h:333 [inline]
>   io_put_req fs/io_uring.c:2140 [inline]
>   io_queue_linked_timeout fs/io_uring.c:6300 [inline]
>   __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
>   io_submit_sqe fs/io_uring.c:6534 [inline]
>   io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
>   __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
>   __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182
>
> io_link_timeout_fn() should put only one reference of the linked timeout
> request, however in case of racing with the master request's completion
> first io_req_complete() puts one and then io_put_req_deferred() is
> called.
>
> Cc: stable@vger.kernel.org # 5.12+
> Fixes: 9ae1f8dd372e0 ("io_uring: fix inconsistent lock state")
> Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>
> P.s. wasn't able to trigger
>
>   fs/io_uring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f46acbbeed57..9ac5e278a91e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6363,10 +6363,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>   	if (prev) {
>   		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
>   		io_put_req_deferred(prev, 1);
> +		io_put_req_deferred(req, 1);
>   	} else {
>   		io_req_complete_post(req, -ETIME, 0);
>   	}
> -	io_put_req_deferred(req, 1);
>   	return HRTIMER_NORESTART;
>   }
>   


