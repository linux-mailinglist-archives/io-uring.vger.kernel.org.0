Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0F36FD389
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 03:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjEJB3r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 21:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjEJB3q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 21:29:46 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918631BD;
        Tue,  9 May 2023 18:29:43 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QGHWR2N4sz4f3jYs;
        Wed, 10 May 2023 09:29:39 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHvbCB81pkeKF+JA--.18228S3;
        Wed, 10 May 2023 09:29:39 +0800 (CST)
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address:
 0000000000000048
To:     Guangwu Zhang <guazhang@redhat.com>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com>
Date:   Wed, 10 May 2023 09:29:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHvbCB81pkeKF+JA--.18228S3
X-Coremail-Antispam: 1UD129KBjvJXoWxArW8Jry5ArWrAFyDtFW3trb_yoWrJF4fpr
        4jqr48Gr48Jr13Jr1UCr1UJr1UK3y3ZF4UXr17JryrJF18W3WDJ34DJFWUJ3sxJrW5Xr13
        tw1kXw10yryUZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrR6zUUUUU
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

在 2023/05/10 8:49, Guangwu Zhang 写道:
> Hi,
> 
> We found this kernel NULL pointer issue with latest
> linux-block/for-next, please check it.
> 
> Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> 
> 
> [  112.483804] BUG: kernel NULL pointer dereference, address: 0000000000000048
> [  112.490809] #PF: supervisor read access in kernel mode
> [  112.495976] #PF: error_code(0x0000) - not-present page
> [  112.501141] PGD 800000044d20c067 P4D 800000044d20c067 PUD 4734d5067 PMD 0
> [  112.508057] Oops: 0000 [#1] PREEMPT SMP PTI
> [  112.512265] CPU: 24 PID: 7767 Comm: user-data Kdump: loaded Not
> tainted 6.4.0-rc1+ #1
> [  112.520141] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
> Gen10, BIOS U30 06/20/2018
> [  112.528713] RIP: 0010:bfq_bio_bfqg+0x8/0x80

Can you show more details about addr2line result? It'll be much helpful.

Thanks,
Kuai
> [  112.532925] Code: 6b 70 48 89 43 60 5b 5d c3 cc cc cc cc 0f 1f 44
> 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00
> 41 54 53 <48> 8b 46 48 48 89 fb 48 89 f7 48 85 c0 74 26 48 63 15 72 40
> 6b 01
> [  112.551805] RSP: 0018:ffffaed687ef3b30 EFLAGS: 00010096
> [  112.557058] RAX: ffff9a90f2600000 RBX: ffff9a90f2600000 RCX: 0000000000000001
> [  112.564232] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff9a90f2600000
> [  112.571408] RBP: ffff9a90c508d500 R08: ffff9a90e2b8a688 R09: ffff9a90e2b8a688
> [  112.578581] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  112.585756] R13: ffff9a90c508d500 R14: 0000000000000000 R15: 0000000000000000
> [  112.592930] FS:  00007fe41b0f0880(0000) GS:ffff9a94afc00000(0000)
> knlGS:0000000000000000
> [  112.601065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  112.606842] CR2: 0000000000000048 CR3: 000000046346e005 CR4: 00000000007706e0
> [  112.614016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  112.621189] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  112.628362] PKRU: 55555554
> [  112.631082] Call Trace:
> [  112.633539]  <TASK>
> [  112.635650]  bfq_bic_update_cgroup+0x2c/0x240
> [  112.640033]  bfq_init_rq+0xdd/0x670
> [  112.643545]  ? blk_rq_map_user_iov+0xc5/0x2f0
> [  112.647931]  bfq_insert_request.isra.0+0x5d/0x250
> [  112.652663]  bfq_insert_requests+0x59/0x80
> [  112.656782]  blk_mq_flush_plug_list+0x172/0x570
> [  112.661342]  blk_add_rq_to_plug+0x45/0x150
> [  112.665462]  nvme_uring_cmd_io+0x242/0x390 [nvme_core]
> [  112.670652]  io_uring_cmd+0x95/0x120
> [  112.674250]  io_issue_sqe+0x199/0x3d0
> [  112.677932]  io_submit_sqes+0x119/0x3d0
> [  112.681788]  __do_sys_io_uring_enter+0x2c2/0x470
> [  112.686433]  do_syscall_64+0x59/0x90
> [  112.690031]  ? exc_page_fault+0x65/0x150
> [  112.693977]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  112.699057] RIP: 0033:0x7fe41ae3ee5d
> [  112.702651] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e
> fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
> 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89
> 01 48
> [  112.721530] RSP: 002b:00007ffc6fdebc28 EFLAGS: 00000206 ORIG_RAX:
> 00000000000001aa
> [  112.729143] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe41ae3ee5d
> [  112.736317] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 0000000000000005
> [  112.743492] RBP: 00007ffc6fdec730 R08: 0000000000000000 R09: 0000000000000080
> [  112.750666] R10: 0000000000000001 R11: 0000000000000206 R12: 00007ffc6fdec848
> [  112.757841] R13: 0000000000401346 R14: 0000000000403de8 R15: 00007fe41b32c000
> [  112.765019]  </TASK>
> 
> .
> 

