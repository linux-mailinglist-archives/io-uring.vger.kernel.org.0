Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9FD6FD56A
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 06:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjEJEwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 00:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjEJEw3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 00:52:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B07D116
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 21:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683694305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yxgPKDke8VbkrzDJvNKbVrSGQeJEQn3ljaxNNYZGTb8=;
        b=GWDe9EvciAWg7+PK13AfyBL+UHwnJh99YyAwoQSgzLniLztp5Ccql0fjiNQVDPR8pchfHs
        kuYHqmCUo5Kxn0dZT/1j9a9DFRQxgyVA7vqAbC833KNv7NVTxbZzicnUTCjbh1J/YSscEg
        yxCcU6zoxo9a13nejdtcnIDSoVQYmn8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-AwD9W7lCOY2vN1zlq87afg-1; Wed, 10 May 2023 00:51:44 -0400
X-MC-Unique: AwD9W7lCOY2vN1zlq87afg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1aaf6ef3580so38176405ad.3
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 21:51:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683694302; x=1686286302;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yxgPKDke8VbkrzDJvNKbVrSGQeJEQn3ljaxNNYZGTb8=;
        b=KjHBXmvS7xFJXksECFkDJ33xsQS1Qrjy1Mnilq3jeSQ6Db7LP2fGXWyl67E6imaOxI
         aeqA/Raymfauv11jIXpvCKO4hmZQsq8/PuwVkXt6zUJR3pUNimK9zUZbEj8uqyf2WmSY
         mmIIjK6JDvGx9w9N/jvKTMdEwA8hojLnBWXWDObPBeOIIs+plkSFJq1wi4fImqEWQQ24
         MwFXJFJLkhTuiflXDcmJSKFIdcoM2+EzU0/RebaKw+VO9eX2wQTMYHeEP2+EygpwC7vk
         PwEEbhShqGCqCDv/w6F21atDQgfddn35glhW0TINY0zB0oDTTcbW4DE+N9LR1nWSga8O
         CoTg==
X-Gm-Message-State: AC+VfDz0kFG3S+lf3vKiwQyvseAsqsb9ovbM04TjjjsLW52NDfv0zVC1
        3JEM/u6BNL9Dz/Qq+oaY+w0MQ6fDvklMaRlmuso1k5I+/leANk9K2xcSu/KzZ6lc3zygGcLPNuM
        0eIPgnAAPjTYN+DdfXbRd/y0bzV8RfZMkKHJDrPKi91VXRQ3jzW8=
X-Received: by 2002:a17:902:c947:b0:1ab:2659:b533 with SMTP id i7-20020a170902c94700b001ab2659b533mr19976687pla.3.1683694302507;
        Tue, 09 May 2023 21:51:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Zx2Yb51KLvW7LHZObOBRGQvmmaP1UCzS7sj1BfersOCkBquDwqiymi9u4/BYB3zQn1JLKZrgZ6fszv6+hGBQ=
X-Received: by 2002:a17:902:c947:b0:1ab:2659:b533 with SMTP id
 i7-20020a170902c94700b001ab2659b533mr19976675pla.3.1683694302194; Tue, 09 May
 2023 21:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
 <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com> <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
 <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com>
In-Reply-To: <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com>
From:   Guangwu Zhang <guazhang@redhat.com>
Date:   Wed, 10 May 2023 12:52:47 +0800
Message-ID: <CAGS2=Yob_Ud9A-aTu5hQt8+kW4cyrLX12hNJTrRkJYigFT-AmA@mail.gmail.com>
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address: 0000000000000048
To:     Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

HI,
after applying your patch[1], the system will panic after reboot.

  OK  ] Finished Coldplug All udev Devices.
[  OK  ] Reached target Network.
         Starting dracut initqueue hook...
[    4.675720] list_add double add: new=ffff90b056320a48,
prev=ffffa4f685f43a70, next=ffff90b056320a48.
[    4.684931] ------------[ cut here ]------------
[    4.689578] kernel BUG at lib/list_debug.c:33!
[    4.694053] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[    4.699134] CPU: 14 PID: 706 Comm: systemd-udevd Not tainted 6.4.0-rc1+ #2
[    4.706049] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
Gen10, BIOS U30 06/20/2018
[    4.714621] RIP: 0010:__list_add_valid+0x8b/0x90
[    4.719271] Code: d1 4c 89 c6 4c 89 ca 48 c7 c7 78 d1 bb 99 e8 cc
56 b6 ff 0f 0b 48 89 f2 4c 89 c1 48 89 fe 48 c7 c7 d0 d1 bb 99 e8 b5
56 b6 ff <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
90 48
[    4.738150] RSP: 0018:ffffa4f685f43a48 EFLAGS: 00010246
[    4.743405] RAX: 0000000000000058 RBX: ffff90b056320a00 RCX: 0000000000000000
[    4.750578] RDX: 0000000000000000 RSI: ffff90b76fb9f840 RDI: ffff90b76fb9f840
[    4.757752] RBP: ffffa4f685f43a68 R08: 0000000000000000 R09: 00000000ffff7fff
[    4.764925] R10: ffffa4f685f43900 R11: ffffffff9a1e6888 R12: ffffa4f685f43b78
[    4.772100] R13: ffffa4f685f43a70 R14: ffff90b38a035800 R15: ffff90b056320a48
[    4.779275] FS:  00007fea88741540(0000) GS:ffff90b76fb80000(0000)
knlGS:0000000000000000
[    4.787411] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.793189] CR2: 00007fff014ba608 CR3: 0000000449ed4006 CR4: 00000000007706e0
[    4.800362] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.807536] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    4.814710] PKRU: 55555554
[    4.817429] Call Trace:
[    4.819887]  <TASK>
[    4.821995]  blk_mq_dispatch_plug_list+0x112/0x320
[    4.826820]  blk_mq_flush_plug_list+0x43/0x190
[    4.831289]  __blk_flush_plug+0x102/0x160
[    4.835325]  blk_finish_plug+0x25/0x40
[    4.839095]  read_pages+0x19a/0x220
[    4.842606]  page_cache_ra_unbounded+0x137/0x180
[    4.847250]  force_page_cache_ra+0xc5/0xf0
[    4.851369]  filemap_get_pages+0xf9/0x360
[    4.855406]  filemap_read+0xc5/0x320
[    4.859001]  ? generic_fillattr+0x45/0xf0
[    4.863036]  ? _copy_to_user+0x20/0x40
[    4.866808]  ? cp_new_stat+0x150/0x180
[    4.870579]  blkdev_read_iter+0xaf/0x170
[    4.874524]  vfs_read+0x1b5/0x2d0
[    4.877860]  ksys_read+0x5f/0xe0
[    4.881107]  do_syscall_64+0x59/0x90
[    4.884706]  ? exc_page_fault+0x65/0x150
[    4.888653]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[    4.893737] RIP: 0033:0x7fea8934eaf2

[1] https://lore.kernel.org/linux-block/007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com/


> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f6dad0886a2f..bd94d8a5416f 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2712,6 +2712,7 @@ static void blk_mq_dispatch_plug_list(struct
> blk_plug *plug, bool from_sched)
>          struct request **requeue_lastp = &requeue_list;
>          unsigned int depth = 0;
>          LIST_HEAD(list);
> +       LIST_HEAD(passthrough_list);
>
>          do {
>                  struct request *rq = rq_list_pop(&plug->mq_list);
> @@ -2723,7 +2724,10 @@ static void blk_mq_dispatch_plug_list(struct
> blk_plug *plug, bool from_sched)
>                          rq_list_add_tail(&requeue_lastp, rq);
>                          continue;
>                  }
> -               list_add(&rq->queuelist, &list);
> +               if (blk_rq_is_passthrough(rq))
> +                       list_add(&rq->queuelist, &passthrough_list);
> +               else
> +                       list_add(&rq->queuelist, &list);
>                  depth++;
>          } while (!rq_list_empty(plug->mq_list));
>
> @@ -2731,6 +2735,9 @@ static void blk_mq_dispatch_plug_list(struct
> blk_plug *plug, bool from_sched)
>          trace_block_unplug(this_hctx->queue, depth, !from_sched);
>
>          percpu_ref_get(&this_hctx->queue->q_usage_counter);
> +       if (!list_empty(&passthrough_list))
> +               blk_mq_insert_requests(this_hctx, this_ctx,
> &passthrough_list,
> +                                      from_sched);
>          if (this_hctx->queue->elevator) {
>
> this_hctx->queue->elevator->type->ops.insert_requests(this_hctx,
>                                  &list, 0);
>
> Thanks,
> Kuai
>


-- 

Guangwu Zhang, RHCE, ISTQB, ITIL

Quality Engineer, Kernel Storage QE

Red Hat

