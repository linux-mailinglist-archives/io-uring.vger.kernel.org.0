Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31176F2260
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 04:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347136AbjD2CUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 22:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjD2CT7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 22:19:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE66212B
        for <io-uring@vger.kernel.org>; Fri, 28 Apr 2023 19:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682734743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=bMurEh3aXJmDffGcx2DdPyzoHd2PXqMBG8UnbQY3qTE=;
        b=LB+jy++xBEGsPy9KMNjGyaNUHqOzXS12XKE1140wbaUCyvYnfwF/B6qsXIVO3/jFG5+clS
        u8d4l5aLuDd/Ke23DllZYLg3ylkaHie4cSKBPQFJPUsYkPRd+D8LM6uQDuFRTi5Kn0L86n
        jr/Z47sPnW75wMscXqYamU3eZxOonvA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-zp_TC5w7P_2No_7sSNkuxA-1; Fri, 28 Apr 2023 22:18:59 -0400
X-MC-Unique: zp_TC5w7P_2No_7sSNkuxA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07970185A790;
        Sat, 29 Apr 2023 02:18:59 +0000 (UTC)
Received: from ovpn-8-24.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB5AB440BC;
        Sat, 29 Apr 2023 02:18:52 +0000 (UTC)
Date:   Sat, 29 Apr 2023 10:18:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     ming.lei@redhat.com, lsf-pc@lists.linux-foundation.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: [LSF/MM/BPF TOPIC] ublk & io_uring: ublk zero copy support
Message-ID: <ZEx+h/iFf46XiWG1@ovpn-8-24.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

ublk zero copy is observed to improve big chunk(64KB+) sequential IO performance a
lot, such as, IOPS of ublk-loop over tmpfs is increased by 1~2X[1], Jens also observed
that IOPS of ublk-qcow2 can be increased by ~1X[2]. Meantime it saves memory bandwidth.

So this is one important performance improvement.

So far there are three proposal:

1) splice based

- spliced page from ->splice_read() can't be written

ublk READ request can't be handled because spliced page can't be written
to, and extending splice for ublk zero copy isn't one good solution[3]

- it is very hard to meet above requirements  wrt. request buffer lifetime

splice/pipe focuses on page reference lifetime, but ublk zero copy pays more
attention to ublk request buffer lifetime. If is very inefficient to respect
request buffer lifetime by using all pipe buffer's ->release() which requires
all pipe buffers and pipe to be kept when ublk server handles IO. That means
one single dedicated ``pipe_inode_info`` has to be allocated runtime for each
provided buffer, and the pipe needs to be populated with pages in ublk request
buffer.

IMO, it isn't one good way to take splice from both correctness and performance
viewpoint.

2) io_uring register buffer based

- the main idea is to register one runtime buffer in fast io path, and
  unregister it after the buffer is used by the following OPs

- the main problem is that bad performance caused by io_uring link model

registering buffer has to be one OP, same with unregistering buffer; the
following normal OPs(such as FS IO) have to depend on the registering
buffer OP, then io_uring link has to be used.

It is normal to see more than one normal OPs which depend on the registering
buffer OP, so all these OPs(registering buffer, normal (FS IO) OPs and
unregistering buffer) have to be linked together, then normal(FS IO) OPs
have to be submitted one by one, and this way is slow, because there is
often no dependency among all these normal FS OPs. Basically io_uring
link model does not support this kind of 1:N dependency.

No one posted code for showing this approach yet.

3) io_uring fused command[1]

- fused command extend current io_uring usage by allowing submitting following
FS OPs(called secondary OPs) after the primary command provides buffer, and
primary command won't be completed until all secondary OPs are done.

This way solves the problem in 2), and meantime avoids the buffer register cost in
both submission and completion IO fast code path because the primary command won't
be completed until all secondary OPs are done, so no need to write/read the
buffer into per-context global data structure.

Meantime buffer lifetime problem is addressed simply, so correctness gets guaranteed,
and performance is pretty good, and even IOPS of 4k IO gets a little
improved in some workloads, or at least no perf regression is observed
for small size IO.

fused command can be thought as one single request logically, just it has more
than one SQE(all share same link flag), that is why is named as fused command.

- the only concern is that fused command starts one use usage of io_uring, but
still not see comments wrt. what/why is bad with this kind of new usage/interface.

I propose this topic and want to discuss about how to move on with this
feature.


[1] https://lore.kernel.org/linux-block/20230330113630.1388860-1-ming.lei@redhat.com/
[2] https://lore.kernel.org/linux-block/b3fc9991-4c53-9218-a8cc-5b4dd3952108@kernel.dk/
[3] https://lore.kernel.org/linux-block/CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com/


Thanks,
Ming

