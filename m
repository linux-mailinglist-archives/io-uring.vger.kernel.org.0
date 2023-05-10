Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7056FD35A
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 02:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbjEJAtE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 20:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjEJAtD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 20:49:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5566240CE
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 17:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683679692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=DpVMeblzWLLNSO+KpVvlFMBDTVbc6pLPgEIf+DHTaPE=;
        b=RfvVmmDhshd72mPWBmxIW9T5nW0DPlgGS3Fyj+VPIM7ClbjAUCwtwkKHmks6pyhE0cybQS
        oSD3uXSRSBRAH2vjSOfM0eRHRb93+yRBc/Mk57nUeKqsfirSvcmh39gHG+UEznM9IZOy2w
        02cYkdOj1+tgWyjAmvdKku6jir3lemY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-rJzN6n8JMCCqp7K_PweCsg-1; Tue, 09 May 2023 20:48:11 -0400
X-MC-Unique: rJzN6n8JMCCqp7K_PweCsg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-24e2be731feso3588064a91.1
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 17:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683679690; x=1686271690;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DpVMeblzWLLNSO+KpVvlFMBDTVbc6pLPgEIf+DHTaPE=;
        b=SocnRbDYX3lsVGebWUx5VFsqZpAsPCjMZrCxhXHMLp6wukiOusPs6IIOySPHOx7JL6
         pekrXL2hrQ0PGCJoURVKYCZtQguPcjRbIf7szWMrkUdftTp9UM4nE1onJ/XOGUjxXnoo
         7NiUWJTwFuzAtb6iQEPEO8cMQFV0xvGSO49M2knGFdlTmWBwhCoU0I5RBoB21XoPbOTZ
         Pg4mkTnkfKyjESuA+lorzbIqiTzAekd+0SNWuf+zfKZQPgwbh2/9pg4CA2Ugl7yz4KfZ
         8XV/rOspgAM/W1+JCPZKNJe2BfV+jWI5AFEe3udmbAVRcIlV2FIjxdqib3ggmV12F2OD
         sIMA==
X-Gm-Message-State: AC+VfDwJ29DduYmfdYokRhdf2avnfBTBzwoX52N4wbuRSoCdUBjYyWor
        3msgDniB0ydQsPRvBZuDNWl+o8svuW+on0SYUDCRnoDIUBJsXR4Y54lmaUsZ/6gnfljPf36gET9
        WNlRikDjYsnXB1nYCIbcNlwCbOHdHaejRZh0=
X-Received: by 2002:a17:90a:a681:b0:23f:582d:f45f with SMTP id d1-20020a17090aa68100b0023f582df45fmr15486710pjq.1.1683679689838;
        Tue, 09 May 2023 17:48:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ561Owgx5sEPjjOJq4ynZWpS6299R2MFKmfzOgmFOfGCK72En1Y6azFAWthRxybFxkzHwPBXKBTya4dSePxr3Y=
X-Received: by 2002:a17:90a:a681:b0:23f:582d:f45f with SMTP id
 d1-20020a17090aa68100b0023f582df45fmr15486694pjq.1.1683679689490; Tue, 09 May
 2023 17:48:09 -0700 (PDT)
MIME-Version: 1.0
From:   Guangwu Zhang <guazhang@redhat.com>
Date:   Wed, 10 May 2023 08:49:15 +0800
Message-ID: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
Subject: [bug report] BUG: kernel NULL pointer dereference, address: 0000000000000048
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We found this kernel NULL pointer issue with latest
linux-block/for-next, please check it.

Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git


[  112.483804] BUG: kernel NULL pointer dereference, address: 0000000000000048
[  112.490809] #PF: supervisor read access in kernel mode
[  112.495976] #PF: error_code(0x0000) - not-present page
[  112.501141] PGD 800000044d20c067 P4D 800000044d20c067 PUD 4734d5067 PMD 0
[  112.508057] Oops: 0000 [#1] PREEMPT SMP PTI
[  112.512265] CPU: 24 PID: 7767 Comm: user-data Kdump: loaded Not
tainted 6.4.0-rc1+ #1
[  112.520141] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
Gen10, BIOS U30 06/20/2018
[  112.528713] RIP: 0010:bfq_bio_bfqg+0x8/0x80
[  112.532925] Code: 6b 70 48 89 43 60 5b 5d c3 cc cc cc cc 0f 1f 44
00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00
41 54 53 <48> 8b 46 48 48 89 fb 48 89 f7 48 85 c0 74 26 48 63 15 72 40
6b 01
[  112.551805] RSP: 0018:ffffaed687ef3b30 EFLAGS: 00010096
[  112.557058] RAX: ffff9a90f2600000 RBX: ffff9a90f2600000 RCX: 0000000000000001
[  112.564232] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff9a90f2600000
[  112.571408] RBP: ffff9a90c508d500 R08: ffff9a90e2b8a688 R09: ffff9a90e2b8a688
[  112.578581] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  112.585756] R13: ffff9a90c508d500 R14: 0000000000000000 R15: 0000000000000000
[  112.592930] FS:  00007fe41b0f0880(0000) GS:ffff9a94afc00000(0000)
knlGS:0000000000000000
[  112.601065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  112.606842] CR2: 0000000000000048 CR3: 000000046346e005 CR4: 00000000007706e0
[  112.614016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  112.621189] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  112.628362] PKRU: 55555554
[  112.631082] Call Trace:
[  112.633539]  <TASK>
[  112.635650]  bfq_bic_update_cgroup+0x2c/0x240
[  112.640033]  bfq_init_rq+0xdd/0x670
[  112.643545]  ? blk_rq_map_user_iov+0xc5/0x2f0
[  112.647931]  bfq_insert_request.isra.0+0x5d/0x250
[  112.652663]  bfq_insert_requests+0x59/0x80
[  112.656782]  blk_mq_flush_plug_list+0x172/0x570
[  112.661342]  blk_add_rq_to_plug+0x45/0x150
[  112.665462]  nvme_uring_cmd_io+0x242/0x390 [nvme_core]
[  112.670652]  io_uring_cmd+0x95/0x120
[  112.674250]  io_issue_sqe+0x199/0x3d0
[  112.677932]  io_submit_sqes+0x119/0x3d0
[  112.681788]  __do_sys_io_uring_enter+0x2c2/0x470
[  112.686433]  do_syscall_64+0x59/0x90
[  112.690031]  ? exc_page_fault+0x65/0x150
[  112.693977]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  112.699057] RIP: 0033:0x7fe41ae3ee5d
[  112.702651] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e
fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89
01 48
[  112.721530] RSP: 002b:00007ffc6fdebc28 EFLAGS: 00000206 ORIG_RAX:
00000000000001aa
[  112.729143] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe41ae3ee5d
[  112.736317] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 0000000000000005
[  112.743492] RBP: 00007ffc6fdec730 R08: 0000000000000000 R09: 0000000000000080
[  112.750666] R10: 0000000000000001 R11: 0000000000000206 R12: 00007ffc6fdec848
[  112.757841] R13: 0000000000401346 R14: 0000000000403de8 R15: 00007fe41b32c000
[  112.765019]  </TASK>

