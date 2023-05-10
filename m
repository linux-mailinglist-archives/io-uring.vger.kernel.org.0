Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3566FD3B6
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 04:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjEJCAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 22:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjEJCAW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 22:00:22 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D813AAF;
        Tue,  9 May 2023 19:00:20 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QGJBk127Nz4f3mJ2;
        Wed, 10 May 2023 10:00:14 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgAXB+Wu+lpkqqwWJA--.63589S3;
        Wed, 10 May 2023 10:00:15 +0800 (CST)
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address:
 0000000000000048
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
 <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com>
 <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com>
Date:   Wed, 10 May 2023 10:00:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgAXB+Wu+lpkqqwWJA--.63589S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw43Ww1rGFy5GFW7uw48Zwb_yoW8ZFWUpw
        45XF4qkFWkJF10gay8Ka17ua48tFn0vFyakw15Gr4fArsIgrZIvFn3AFZrZrZ2vrsYkrnr
        Grs8K39xJr4Fgw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9
        -UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

在 2023/05/10 9:49, Yu Kuai 写道:
> Hi,
> 
> 在 2023/05/10 9:29, Yu Kuai 写道:
>> Hi,
>>
>> 在 2023/05/10 8:49, Guangwu Zhang 写道:
>>> Hi,
>>>
>>> We found this kernel NULL pointer issue with latest
>>> linux-block/for-next, please check it.
>>>
>>> Kernel repo: 
>>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
>>>
>>>
>>> [  112.483804] BUG: kernel NULL pointer dereference, address: 
>>> 0000000000000048
> 
> Base on this offset, 0x48 match bio->bi_blkg, so I guess this is because
> bio is NULL, so the problem is that passthrough request insert into
> elevator.
> 
Sorry that attached patch has some problem, please try this one.

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f6dad0886a2f..bd94d8a5416f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2712,6 +2712,7 @@ static void blk_mq_dispatch_plug_list(struct 
blk_plug *plug, bool from_sched)
         struct request **requeue_lastp = &requeue_list;
         unsigned int depth = 0;
         LIST_HEAD(list);
+       LIST_HEAD(passthrough_list);

         do {
                 struct request *rq = rq_list_pop(&plug->mq_list);
@@ -2723,7 +2724,10 @@ static void blk_mq_dispatch_plug_list(struct 
blk_plug *plug, bool from_sched)
                         rq_list_add_tail(&requeue_lastp, rq);
                         continue;
                 }
-               list_add(&rq->queuelist, &list);
+               if (blk_rq_is_passthrough(rq))
+                       list_add(&rq->queuelist, &passthrough_list);
+               else
+                       list_add(&rq->queuelist, &list);
                 depth++;
         } while (!rq_list_empty(plug->mq_list));

@@ -2731,6 +2735,9 @@ static void blk_mq_dispatch_plug_list(struct 
blk_plug *plug, bool from_sched)
         trace_block_unplug(this_hctx->queue, depth, !from_sched);

         percpu_ref_get(&this_hctx->queue->q_usage_counter);
+       if (!list_empty(&passthrough_list))
+               blk_mq_insert_requests(this_hctx, this_ctx, 
&passthrough_list,
+                                      from_sched);
         if (this_hctx->queue->elevator) {
 
this_hctx->queue->elevator->type->ops.insert_requests(this_hctx,
                                 &list, 0);

Thanks,
Kuai

