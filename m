Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A44B6DB407
	for <lists+io-uring@lfdr.de>; Fri,  7 Apr 2023 21:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjDGTSG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Apr 2023 15:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjDGTSF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Apr 2023 15:18:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B88976F
        for <io-uring@vger.kernel.org>; Fri,  7 Apr 2023 12:18:04 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 337GiLuv028093
        for <io-uring@vger.kernel.org>; Fri, 7 Apr 2023 12:18:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=OUahnU2vQF7v2u8mdfu+tv4js0n8ogHNDJ3QjG1WFzs=;
 b=M09D4pjBtkENGGsAcvpvv5MsN+ic1NkADHSeasf5TJsmgU64TGEq10veYT5dnaIOWddh
 sxTrhwYhr3icf3iGxRecM6j/xfIy+htS/zIIGurWplAvqMtobpyAQ0EHTohX7kdXnmUn
 VtJl0IAi+Bnd7cjKuGEyURoAFibYz3oG3bBdGCG5a7uAZpzHFsyYUHq/QRCKWXdaMad4
 s9r3gvg+cKTXGE3pGIi2mOWfwt/S+IFPqDtkoKaLGF2M35acRdskWJ9lE0XZPbR0UV/L
 ZmvbbgQ3FaLj8VikP+IY6C+cxhCBYpbGaY6xHAPrG8fGjwedxPaN84wQH2GspF3Dk+C2 pA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3pt9yhn2jf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Apr 2023 12:18:03 -0700
Received: from twshared15216.17.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 7 Apr 2023 12:17:02 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id CC8D1157B5F8C; Fri,  7 Apr 2023 12:16:48 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 5/5] io_uring: remove uring_cmd cookie
Date:   Fri, 7 Apr 2023 12:16:36 -0700
Message-ID: <20230407191636.2631046-6-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230407191636.2631046-1-kbusch@meta.com>
References: <20230407191636.2631046-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: mo8FCSJuEdet6c5oFjJbTrN7_LPghfSc
X-Proofpoint-ORIG-GUID: mo8FCSJuEdet6c5oFjJbTrN7_LPghfSc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

No users of this field anymore, so remove it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring.h | 8 ++------
 io_uring/uring_cmd.c     | 1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b9328ca3352..235307bf6a072 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -25,12 +25,8 @@ enum io_uring_cmd_flags {
 struct io_uring_cmd {
 	struct file	*file;
 	const void	*cmd;
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
index f7a96bc76ea13..94586f691984c 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -127,7 +127,6 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
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

