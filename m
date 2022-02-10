Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF984B0E46
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 14:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242068AbiBJNR5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 08:17:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbiBJNR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 08:17:57 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE9E208;
        Thu, 10 Feb 2022 05:17:56 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C196B4748F;
        Thu, 10 Feb 2022 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1644498544; x=
        1646312945; bh=+ZynpC6SVVut+KORnWp4eSDexnB0V4ijqletfz1S2rY=; b=K
        94lxnCviVmv4HksVtT5mrtuSDyx/nd6F8HUe0jLFzb0YthM6zH9IJgpCdmXBsZ9L
        Q7+UrJmTdf8Grd4LgiaDWVbMWP6xtBzqqTYRLIsBJWyHLohx+byyEgc+t/ds7NxL
        +sXkrH+9uLHErsHFgS3zm65ctkI4Yeu9YWedFgyFLo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gDeJDtpU0uko; Thu, 10 Feb 2022 16:09:04 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4CA21418B8;
        Thu, 10 Feb 2022 16:09:03 +0300 (MSK)
Received: from localhost.localdomain (10.178.114.63) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 10 Feb 2022 16:09:02 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v2 0/3] implement direct IO with integrity
Date:   Thu, 10 Feb 2022 16:08:22 +0300
Message-ID: <20220210130825.657520-1-a.buev@yadro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
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

Changes since v1:
 - switch to using separated io uring op codes and additional
   sqe fields (instead of sqe flag)
 - ability to process multiple iovecs
 - use unused space in bio to pin user pages

Alexander V. Buev (3):
  block: bio-integrity: add PI iovec to bio
  block: io_uring: add READV_PI/WRITEV_PI operations
  block: fops: handle IOCB_USE_PI in direct IO

 block/bio-integrity.c           | 151 +++++++++++++++++++++++
 block/fops.c                    |  62 ++++++++++
 fs/io_uring.c                   | 209 ++++++++++++++++++++++++++++++++
 include/linux/bio.h             |   8 ++
 include/linux/fs.h              |   2 +
 include/trace/events/io_uring.h |  17 +--
 include/uapi/linux/io_uring.h   |   6 +-
 include/uapi/linux/uio.h        |   3 +-
 8 files changed, 449 insertions(+), 9 deletions(-)

-- 
2.34.1

