Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CA42F3E10
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbhALWBm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 17:01:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406812AbhALVeM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:34:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLFYE4009535;
        Tue, 12 Jan 2021 21:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=jd80kfM42Wg2JvpHRugzml+zZOas3E8TWSDeSnqaFVk=;
 b=iBA9SuztZJcJAS4n3U3+VaWqgsKGvFVV+YRbQYqULbUNQeAnvv27d63O5izny1Em1Dhl
 HgHl5gLcgonOri34sL6oM3w2582pEja264C9ro9Xa5xRociVry33fLciW40QjO8nIAcl
 WLotA8liqNXn1IGZaWlNblNe0nuYLdJdVoeCTlSQxSZRavhIPtaJISXaPpsJ+eyz1stA
 rG464/0jVP3UazVKZelQXGDWzHEufxnkRc2BXvLw3Ha89TV10aLAiCqDqo+mtBFa/CNE
 b/+8sKacGockTcxuVudPWRRK+1mRe1Z5KoQY50eNGDh2QwEVSMiuNS97Ue8gDHU7rjZK iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 360kvk0g29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLG2A0103630;
        Tue, 12 Jan 2021 21:33:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 360keyeu7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:28 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLXRHN023056;
        Tue, 12 Jan 2021 21:33:27 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:27 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 05/13] io_uring: add rsrc_ref locking routines
Date:   Tue, 12 Jan 2021 13:33:05 -0800
Message-Id: <1610487193-21374-6-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=983 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=998 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120127
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Encapsulate resource reference locking into separate routines.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d0bc4c8..c5e3269 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7260,14 +7260,24 @@ static void io_rsrc_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
+static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
+{
+	spin_lock_bh(&ctx->rsrc_ref_lock);
+}
+
+static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
+{
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
+}
+
 static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 				 struct fixed_rsrc_data *rsrc_data,
 				 struct fixed_rsrc_ref_node *ref_node)
 {
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	rsrc_data->node = ref_node;
 	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 	percpu_ref_get(&rsrc_data->refs);
 }
 
@@ -7284,9 +7294,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!backup_node)
 		return -ENOMEM;
 
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7676,7 +7686,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 	data = ref_node->rsrc_data;
 	ctx = data->ctx;
 
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	ref_node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
@@ -7688,7 +7698,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
-- 
1.8.3.1

