Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FA845FD0C
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 07:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbhK0GSZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 01:18:25 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16309 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbhK0GQZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 01:16:25 -0500
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J1Lr80406z90wH;
        Sat, 27 Nov 2021 14:12:40 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 27 Nov 2021 14:13:08 +0800
Subject: Re: [PATCH -next] io_uring: fix soft lockup when call
 __io_remove_buffers
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211122024737.2198530-1-yebin10@huawei.com>
From:   yebin <yebin10@huawei.com>
Message-ID: <61A1CC74.5010007@huawei.com>
Date:   Sat, 27 Nov 2021 14:13:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20211122024737.2198530-1-yebin10@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2021/11/22 10:47, Ye Bin wrote:
> I got issue as follows:
> [ 567.094140] __io_remove_buffers: [1]start ctx=0xffff8881067bf000 bgid=65533 buf=0xffff8881fefe1680
> [  594.360799] watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [kworker/u32:5:108]
> [  594.364987] Modules linked in:
> [  594.365405] irq event stamp: 604180238
> [  594.365906] hardirqs last  enabled at (604180237): [<ffffffff93fec9bd>] _raw_spin_unlock_irqrestore+0x2d/0x50
> [  594.367181] hardirqs last disabled at (604180238): [<ffffffff93fbbadb>] sysvec_apic_timer_interrupt+0xb/0xc0
> [  594.368420] softirqs last  enabled at (569080666): [<ffffffff94200654>] __do_softirq+0x654/0xa9e
> [  594.369551] softirqs last disabled at (569080575): [<ffffffff913e1d6a>] irq_exit_rcu+0x1ca/0x250
> [  594.370692] CPU: 2 PID: 108 Comm: kworker/u32:5 Tainted: G            L    5.15.0-next-20211112+ #88
> [  594.371891] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> [  594.373604] Workqueue: events_unbound io_ring_exit_work
> [  594.374303] RIP: 0010:_raw_spin_unlock_irqrestore+0x33/0x50
> [  594.375037] Code: 48 83 c7 18 53 48 89 f3 48 8b 74 24 10 e8 55 f5 55 fd 48 89 ef e8 ed a7 56 fd 80 e7 02 74 06 e8 43 13 7b fd fb bf 01 00 00 00 <e8> f8 78 474
> [  594.377433] RSP: 0018:ffff888101587a70 EFLAGS: 00000202
> [  594.378120] RAX: 0000000024030f0d RBX: 0000000000000246 RCX: 1ffffffff2f09106
> [  594.379053] RDX: 0000000000000000 RSI: ffffffff9449f0e0 RDI: 0000000000000001
> [  594.379991] RBP: ffffffff9586cdc0 R08: 0000000000000001 R09: fffffbfff2effcab
> [  594.380923] R10: ffffffff977fe557 R11: fffffbfff2effcaa R12: ffff8881b8f3def0
> [  594.381858] R13: 0000000000000246 R14: ffff888153a8b070 R15: 0000000000000000
> [  594.382787] FS:  0000000000000000(0000) GS:ffff888399c00000(0000) knlGS:0000000000000000
> [  594.383851] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  594.384602] CR2: 00007fcbe71d2000 CR3: 00000000b4216000 CR4: 00000000000006e0
> [  594.385540] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  594.386474] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  594.387403] Call Trace:
> [  594.387738]  <TASK>
> [  594.388042]  find_and_remove_object+0x118/0x160
> [  594.389321]  delete_object_full+0xc/0x20
> [  594.389852]  kfree+0x193/0x470
> [  594.390275]  __io_remove_buffers.part.0+0xed/0x147
> [  594.390931]  io_ring_ctx_free+0x342/0x6a2
> [  594.392159]  io_ring_exit_work+0x41e/0x486
> [  594.396419]  process_one_work+0x906/0x15a0
> [  594.399185]  worker_thread+0x8b/0xd80
> [  594.400259]  kthread+0x3bf/0x4a0
> [  594.401847]  ret_from_fork+0x22/0x30
> [  594.402343]  </TASK>
>
> Message from syslogd@localhost at Nov 13 09:09:54 ...
> kernel:watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [kworker/u32:5:108]
> [  596.793660] __io_remove_buffers: [2099199]start ctx=0xffff8881067bf000 bgid=65533 buf=0xffff8881fefe1680
>
> We can reproduce this issue by follow syzkaller log:
> r0 = syz_io_uring_setup(0x401, &(0x7f0000000300), &(0x7f0000003000/0x2000)=nil, &(0x7f0000ff8000/0x4000)=nil, &(0x7f0000000280)=<r1=>0x0, &(0x7f0000000380)=<r2=>0x0)
> sendmsg$ETHTOOL_MSG_FEATURES_SET(0xffffffffffffffff, &(0x7f0000003080)={0x0, 0x0, &(0x7f0000003040)={&(0x7f0000000040)=ANY=[], 0x18}}, 0x0)
> syz_io_uring_submit(r1, r2, &(0x7f0000000240)=@IORING_OP_PROVIDE_BUFFERS={0x1f, 0x5, 0x0, 0x401, 0x1, 0x0, 0x100, 0x0, 0x1, {0xfffd}}, 0x0)
> io_uring_enter(r0, 0x3a2d, 0x0, 0x0, 0x0, 0x0)
>
> The reason above issue  is 'buf->list' has 2,100,000 nodes, occupied cpu lead
> to soft lockup.
> To solve this issue, we need add schedule point when do while loop in
> '__io_remove_buffers'.
> After add  schedule point we do regression, get follow data.
> [  240.141864] __io_remove_buffers: [1]start ctx=0xffff888170603000 bgid=65533 buf=0xffff8881116fcb00
> [  268.408260] __io_remove_buffers: [1]start ctx=0xffff8881b92d2000 bgid=65533 buf=0xffff888130c83180
> [  275.899234] __io_remove_buffers: [2099199]start ctx=0xffff888170603000 bgid=65533 buf=0xffff8881116fcb00
> [  296.741404] __io_remove_buffers: [1]start ctx=0xffff8881b659c000 bgid=65533 buf=0xffff8881010fe380
> [  305.090059] __io_remove_buffers: [2099199]start ctx=0xffff8881b92d2000 bgid=65533 buf=0xffff888130c83180
> [  325.415746] __io_remove_buffers: [1]start ctx=0xffff8881b92d1000 bgid=65533 buf=0xffff8881a17d8f00
> [  333.160318] __io_remove_buffers: [2099199]start ctx=0xffff8881b659c000 bgid=65533 buf=0xffff8881010fe380
> ...
>
> Fixes:8bab4c09f24e("io_uring: allow conditional reschedule for intensive iterators")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>   fs/io_uring.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 76871e3807fd..d8a6446a7921 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4327,6 +4327,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
>   		kfree(nxt);
>   		if (++i == nbufs)
>   			return i;
> +		cond_resched();
>   	}
>   	i++;
>   	kfree(buf);
> @@ -9258,10 +9259,8 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
>   	struct io_buffer *buf;
>   	unsigned long index;
>   
> -	xa_for_each(&ctx->io_buffers, index, buf) {
> +	xa_for_each(&ctx->io_buffers, index, buf)
>   		__io_remove_buffers(ctx, buf, index, -1U);
> -		cond_resched();
> -	}
>   }
>   
>   static void io_req_caches_free(struct io_ring_ctx *ctx)
ping...
