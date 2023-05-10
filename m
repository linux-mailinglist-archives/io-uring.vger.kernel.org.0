Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D226FD39F
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 03:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbjEJBtX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 21:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjEJBtX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 21:49:23 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E98B3A85;
        Tue,  9 May 2023 18:49:21 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QGHy5437Rz4f3kjc;
        Wed, 10 May 2023 09:49:17 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgA33eob+FpkHyEWJA--.35705S3;
        Wed, 10 May 2023 09:49:16 +0800 (CST)
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address:
 0000000000000048
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
 <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
Date:   Wed, 10 May 2023 09:49:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgA33eob+FpkHyEWJA--.35705S3
X-Coremail-Antispam: 1UD129KBjvJXoWxArWUXryUGr43Ww1UWFWxJFb_yoW7Jr45pr
        4ktFW8Gr48Jr15Jw43Cr1UJr1UtrWfZF1UJrn3Zr1rtF47G3WDXwn8GryDAryDJrZ8Zry3
        tFn8Jw18tryjqaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
        DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

在 2023/05/10 9:29, Yu Kuai 写道:
> Hi,
> 
> 在 2023/05/10 8:49, Guangwu Zhang 写道:
>> Hi,
>>
>> We found this kernel NULL pointer issue with latest
>> linux-block/for-next, please check it.
>>
>> Kernel repo: 
>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
>>
>>
>> [  112.483804] BUG: kernel NULL pointer dereference, address: 
>> 0000000000000048

Base on this offset, 0x48 match bio->bi_blkg, so I guess this is because
bio is NULL, so the problem is that passthrough request insert into
elevator.

Can you try follwing patch?

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f6dad0886a2f..fe3ed0a647e6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2731,7 +2731,7 @@ static void blk_mq_dispatch_plug_list(struct 
blk_plug *plug, bool from_sched)
         trace_block_unplug(this_hctx->queue, depth, !from_sched);

         percpu_ref_get(&this_hctx->queue->q_usage_counter);
-       if (this_hctx->queue->elevator) {
+       if (this_hctx->queue->elevator && !blk_rq_is_passthrough(rq)) {
 
this_hctx->queue->elevator->type->ops.insert_requests(this_hctx,
                                 &list, 0);
                 blk_mq_run_hw_queue(this_hctx, from_sched);

Thanks,
Kuai
>> [  112.490809] #PF: supervisor read access in kernel mode
>> [  112.495976] #PF: error_code(0x0000) - not-present page
>> [  112.501141] PGD 800000044d20c067 P4D 800000044d20c067 PUD 4734d5067 
>> PMD 0
>> [  112.508057] Oops: 0000 [#1] PREEMPT SMP PTI
>> [  112.512265] CPU: 24 PID: 7767 Comm: user-data Kdump: loaded Not
>> tainted 6.4.0-rc1+ #1
>> [  112.520141] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
>> Gen10, BIOS U30 06/20/2018
>> [  112.528713] RIP: 0010:bfq_bio_bfqg+0x8/0x80
> 
> Can you show more details about addr2line result? It'll be much helpful.
> 
> Thanks,
> Kuai
>> [  112.532925] Code: 6b 70 48 89 43 60 5b 5d c3 cc cc cc cc 0f 1f 44
>> 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00
>> 41 54 53 <48> 8b 46 48 48 89 fb 48 89 f7 48 85 c0 74 26 48 63 15 72 40
>> 6b 01
>> [  112.551805] RSP: 0018:ffffaed687ef3b30 EFLAGS: 00010096
>> [  112.557058] RAX: ffff9a90f2600000 RBX: ffff9a90f2600000 RCX: 
>> 0000000000000001
>> [  112.564232] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
>> ffff9a90f2600000
>> [  112.571408] RBP: ffff9a90c508d500 R08: ffff9a90e2b8a688 R09: 
>> ffff9a90e2b8a688
>> [  112.578581] R10: 0000000000000000 R11: 0000000000000000 R12: 
>> 0000000000000000
>> [  112.585756] R13: ffff9a90c508d500 R14: 0000000000000000 R15: 
>> 0000000000000000
>> [  112.592930] FS:  00007fe41b0f0880(0000) GS:ffff9a94afc00000(0000)
>> knlGS:0000000000000000
>> [  112.601065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  112.606842] CR2: 0000000000000048 CR3: 000000046346e005 CR4: 
>> 00000000007706e0
>> [  112.614016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>> 0000000000000000
>> [  112.621189] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
>> 0000000000000400
>> [  112.628362] PKRU: 55555554
>> [  112.631082] Call Trace:
>> [  112.633539]  <TASK>
>> [  112.635650]  bfq_bic_update_cgroup+0x2c/0x240
>> [  112.640033]  bfq_init_rq+0xdd/0x670
>> [  112.643545]  ? blk_rq_map_user_iov+0xc5/0x2f0
>> [  112.647931]  bfq_insert_request.isra.0+0x5d/0x250
>> [  112.652663]  bfq_insert_requests+0x59/0x80
>> [  112.656782]  blk_mq_flush_plug_list+0x172/0x570
>> [  112.661342]  blk_add_rq_to_plug+0x45/0x150
>> [  112.665462]  nvme_uring_cmd_io+0x242/0x390 [nvme_core]
>> [  112.670652]  io_uring_cmd+0x95/0x120
>> [  112.674250]  io_issue_sqe+0x199/0x3d0
>> [  112.677932]  io_submit_sqes+0x119/0x3d0
>> [  112.681788]  __do_sys_io_uring_enter+0x2c2/0x470
>> [  112.686433]  do_syscall_64+0x59/0x90
>> [  112.690031]  ? exc_page_fault+0x65/0x150
>> [  112.693977]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>> [  112.699057] RIP: 0033:0x7fe41ae3ee5d
>> [  112.702651] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e
>> fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
>> 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89
>> 01 48
>> [  112.721530] RSP: 002b:00007ffc6fdebc28 EFLAGS: 00000206 ORIG_RAX:
>> 00000000000001aa
>> [  112.729143] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 
>> 00007fe41ae3ee5d
>> [  112.736317] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 
>> 0000000000000005
>> [  112.743492] RBP: 00007ffc6fdec730 R08: 0000000000000000 R09: 
>> 0000000000000080
>> [  112.750666] R10: 0000000000000001 R11: 0000000000000206 R12: 
>> 00007ffc6fdec848
>> [  112.757841] R13: 0000000000401346 R14: 0000000000403de8 R15: 
>> 00007fe41b32c000
>> [  112.765019]  </TASK>
>>
>> .
>>
> 
> .
> 

