Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05FF7D9FC2
	for <lists+io-uring@lfdr.de>; Fri, 27 Oct 2023 20:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjJ0SUR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Oct 2023 14:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbjJ0SUQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Oct 2023 14:20:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CAC12A
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:15 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39REBfOB006902
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=2MEE7cRzsGfeMnNn2eY3zHEqVKk2sJ/zEGUF3QOFPSY=;
 b=KWJuyjy+x/LAlqbRsk/xsVlv18Yc6lOYqXbkvmdkogqh3LaxyJvQCkcCMpkkAL2J+w2q
 Y9iFu8NYxIpFxKbdlN/zh1dOvERifnzPnRiOfuvrmfvz/LvBbdIoOZWI1YPtk0e7tvEb
 UMjsjsYWwfD2ByiMzztD6IGABzDeDLrDuddVlCMGKP0OGEuZ69bdc+74ngUA+guITMC+
 zUNsvzjzeVvz0gKLGDdPjV4fpUAJdRkUc32RM3g97Jq0JlI16DxZ55mBfY+mjpsjyyBB
 4F/QKsDzPFX2BAA2+NGNPcy89nQ7dvnmivsrIgRoNRMl6sQCwHz5ESLi12llCWAB5Dwp TA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3u0erd21xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:14 -0700
Received: from twshared9012.02.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 27 Oct 2023 11:20:02 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 837F820D093C8; Fri, 27 Oct 2023 11:19:50 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 4/4] io_uring: remove uring_cmd cookie
Date:   Fri, 27 Oct 2023 11:19:29 -0700
Message-ID: <20231027181929.2589937-5-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231027181929.2589937-1-kbusch@meta.com>
References: <20231027181929.2589937-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: z-y7AJETJ8TK-oMoBnPTU8weT6X434oG
X-Proofpoint-GUID: z-y7AJETJ8TK-oMoBnPTU8weT6X434oG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_17,2023-10-27_01,2023-05-22_02
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

No more users of this field.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring.h | 8 ++------
 io_uring/uring_cmd.c     | 1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index fe23bf88f86fa..9e6ce6d4ab51f 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -32,12 +32,8 @@ enum io_uring_cmd_flags {
 struct io_uring_cmd {
 	struct file	*file;
 	const struct io_uring_sqe *sqe;
-	union {
-		/* callback to defer completions to task context */
-		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
-		/* used for polled completion */
-		void *cookie;
-	};
+	/* callback to defer completions to task context */
+	void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
 	u32		cmd_op;
 	u32		flags;
 	u8		pdu[32]; /* available inline for free use */
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index acbc2924ecd21..b39ec25c36bc3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -182,7 +182,6 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
 			return -EOPNOTSUPP;
 		issue_flags |=3D IO_URING_F_IOPOLL;
 		req->iopoll_completed =3D 0;
-		WRITE_ONCE(ioucmd->cookie, NULL);
 	}
=20
 	ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
--=20
2.34.1

