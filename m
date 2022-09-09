Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBD35B2F13
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 08:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiIIGfZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 02:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiIIGfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 02:35:23 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAD9481C4;
        Thu,  8 Sep 2022 23:35:21 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6DACE566F1;
        Fri,  9 Sep 2022 06:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1662705318; x=
        1664519719; bh=103tqh1X9vgRK9R4xZs/S2qKAynHwmjKGuc+Y20yVGQ=; b=b
        Xc3G+SDj7E8K7zIlZWkkeDzzxLaplulitWx5Bq8HX+EJB2o2FovT4zM9m65avDqP
        BDuZpN0RsSztI893cVedQCLA2GQwgd3ReVtePO7JdJFnYxBXY127SMkKcqBqKjon
        ksqaipGXDXJ4mu4S8Nzh40EDgwVaoE+40btRujA9ic=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7aR_vaqlQme6; Fri,  9 Sep 2022 09:35:18 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4C83B566CB;
        Fri,  9 Sep 2022 09:35:16 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 09:35:16 +0300
Received: from altair.lan (172.17.190.47) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 09:35:12 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v3 0/3] implement direct IO with integrity
Date:   Fri, 9 Sep 2022 09:32:54 +0300
Message-ID: <20220909063257.1072450-1-a.buev@yadro.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.190.47]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series of patches makes possible to do direct block IO
with integrity payload using io uring kernel interface.
Userspace app can utilize new READV_PI/WRITEV_PI operation with a new
fields in sqe struct (pi_addr/pi_len) to provide iovec's with
integrity data.

Changes since v2:
 - separate code from fast path
 - keep rw_pi struct size <= 64 byte
 - using kiocb->private pointer to pass
   PI data iterator to block direct IO layer   
 - improved bio_integrity_add_iovec function 

Alexander V. Buev (3):
  block: bio-integrity: add PI iovec to bio
  block: io-uring: add READV_PI/WRITEV_PI operations
  block: fops: handle IOCB_USE_PI in direct IO

 block/bio-integrity.c         | 163 +++++++++
 block/fops.c                  |  80 +++++
 include/linux/bio.h           |   8 +
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   6 +
 include/uapi/linux/uio.h      |   3 +-
 io_uring/Makefile             |   3 +-
 io_uring/io_uring.c           |   2 +
 io_uring/opdef.c              |  27 ++
 io_uring/rw.h                 |   4 +
 io_uring/rw_pi.c              | 619 ++++++++++++++++++++++++++++++++++
 io_uring/rw_pi.h              |  34 ++
 12 files changed, 948 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/rw_pi.c
 create mode 100644 io_uring/rw_pi.h

-- 
2.30.2

