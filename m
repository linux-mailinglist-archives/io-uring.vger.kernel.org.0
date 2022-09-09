Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326015B37A7
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 14:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiIIMW2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 08:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiIIMWE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 08:22:04 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB923AB02;
        Fri,  9 Sep 2022 05:21:02 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E9CBD56CED;
        Fri,  9 Sep 2022 12:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1662726059; x=
        1664540460; bh=bP3+AOJHdRqv44E0d5LE/Jfsa5J39IoOWEP/mPRdR2g=; b=R
        9BOrJBku0VrPqIPafDuM0hiQHWR2BcobS6C53PTX39ITOZQnxrutKcMb9EojywhJ
        IqkU+uidMJyu92Ysiy1ZC7L5zuE0M+5Y2H6An7creOs7UfGeyEb1vWgAhcrdXLq9
        HBkkbcEzsbiOSbIpFdr6hf8hrrV+gcxr8+HU+Tot7w=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3XcQUUddyfYm; Fri,  9 Sep 2022 15:20:59 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A499656529;
        Fri,  9 Sep 2022 15:20:58 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 15:20:58 +0300
Received: from altair.lan (10.199.18.119) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 15:20:57 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v4 0/3] implement direct IO with integrity
Date:   Fri, 9 Sep 2022 15:20:37 +0300
Message-ID: <20220909122040.1098696-1-a.buev@yadro.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.119]
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

Changes since v3:
 - fixed warnings reported by robot 

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

