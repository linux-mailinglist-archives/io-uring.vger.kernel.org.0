Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416EB7CE11F
	for <lists+io-uring@lfdr.de>; Wed, 18 Oct 2023 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjJRPYq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Oct 2023 11:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjJRPYq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Oct 2023 11:24:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69D198
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:24:44 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 39I84NIU015181
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:24:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=a+CBAEnmZsjKkElSI8KyeZYdLbO9F0M1lGnJEP99RWs=;
 b=N8CshzJ9Eq9BIS21Znz+dzoSBoCZigVCBULa8imL7wj00d7+P2QvPQcEJfhBbfsrsCrE
 KFdAQE11y/uTPNNfMYhJk6wciRVGJkPeLZVYBeUXUMLqIRNZ0bz3yjExy+MfL77IPt8P
 azeGX1r9d/H3wtR4xaxG4w3EQOgzGxsuvwmsQtPCKwgFlMG6+sRS7EAjxS6cAOmWw822
 eTP3oAjZcDvyVmL+urGvSDXmNOZtVkxECdaNgtqXVbR8O/+nWgbKpcONcpbema0SvdkP
 a7mQQJPcAY/pchvwuEuuD0SS3ZA1XEQ3hB8tR6WzpvsljCxLQBU+qsO880MCvypb7P7d eA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3ttbhatctk-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:24:43 -0700
Received: from twshared34392.14.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 18 Oct 2023 08:24:32 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 90DE9205F440F; Wed, 18 Oct 2023 08:24:27 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 4/4] io_uring: remove uring_cmd cookie
Date:   Wed, 18 Oct 2023 08:18:43 -0700
Message-ID: <20231018151843.3542335-5-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231018151843.3542335-1-kbusch@meta.com>
References: <20231018151843.3542335-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: c22ermQ3dVE-gZ4QVLYD-QqRgADtxshn
X-Proofpoint-ORIG-GUID: c22ermQ3dVE-gZ4QVLYD-QqRgADtxshn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_13,2023-10-18_01,2023-05-22_02
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 106cdc55ff3bd..30d3db4bc61a7 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -25,12 +25,8 @@ enum io_uring_cmd_flags {
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
index 537795fddc87d..56f3ef8206057 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -133,7 +133,6 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
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

