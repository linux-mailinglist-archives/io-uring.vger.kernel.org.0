Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC987201EDB
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2020 01:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgFSX7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 19:59:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48466 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbgFSX7w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 19:59:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JNwWZs068721;
        Fri, 19 Jun 2020 23:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=BLd+FjinzvJYpidtkwhbYfp6sCB3MA8TWLi6NWO9YhA=;
 b=Orcm4CN43p8pdw/AYiNS7WbeyYfwwSfU92l4BkdI+Eqe4xj8hn4JOO/5x11NCGeaF+5F
 SEAfbnctFWUP//on01NeEiyiYdcMOMiha0JGG7abUF1PIgY4GLsyR81eku0lbN8AmmgB
 ttfJKJl9ki/GT3MXt9exgoc51+LmfFDrWLIe5Wf2zuu18FfSv4ANbNDWny7dpKvDB0X3
 VL2h0xgQjuTUVSp2pasNoWFKlcYh1xgf3H5n7dXSGGMT0vzVWK4BfxZyazz/UsGSSceV
 5WTfK7GHwkcwWWRtfXvGP+HiVIDFsCiB4dBBiGOpsXd+dWn+wQEfbVaFyBXRQR+uag/e Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31q66095dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 23:59:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JNqdpW134559;
        Fri, 19 Jun 2020 23:57:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31q66dr0gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 23:57:49 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05JNvnuu017956;
        Fri, 19 Jun 2020 23:57:49 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 16:57:48 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 1/1] io_uring: use valid mm in io_req_work_grab_env() in SQPOLL mode
Date:   Fri, 19 Jun 2020 16:57:44 -0700
Message-Id: <1592611064-35370-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592611064-35370-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1592611064-35370-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=1 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 suspectscore=1 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190169
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If current->mm is not set in SQPOLL mode, then use ctx->sqo_mm;
otherwise fail thre request.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cb696ab..fd53ea6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1062,8 +1062,18 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 					const struct io_op_def *def)
 {
 	if (!req->work.mm && def->needs_mm) {
-		mmgrab(current->mm);
-		req->work.mm = current->mm;
+		struct mm_struct *mm = current->mm;
+
+		if (!mm) {
+			if (req->ctx && req->ctx->sqo_thread)
+				mm = req->ctx->sqo_mm;
+			else
+				req->work.flags |= IO_WQ_WORK_CANCEL;
+		}
+		if (mm) {
+			mmgrab(mm);
+			req->work.mm = mm;
+		}
 	}
 	if (!req->work.creds)
 		req->work.creds = get_current_cred();
-- 
1.8.3.1

