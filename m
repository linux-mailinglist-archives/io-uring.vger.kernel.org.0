Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D972F3E0B
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbhALWB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 17:01:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406976AbhALVeN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:34:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLFKtk009382;
        Tue, 12 Jan 2021 21:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4Ns1PxAXCf28O4OdaBch2T6XvXYQFJ4GLqyKvCB9RLw=;
 b=EvNN6/HII35Aa++IH5I07MoLfPsXlZFc6wcL1oLvRlrtaNlfeczMIyt3vwb1t6mMAq60
 YyAED/+J53+B3C0FlFEZjHeStHoSSTmTbaxu/IfEcjcHaS9FoipcpQdWep7yg75u8Dk2
 7mlcHt6o0zmseCH0VHT85QICqfS1emYmwnQbTZbgyCJHepvm23Uyn5T9GceKVX5HI0OX
 94MwcMmajnN9EarJtu6sSyc2vk+5Mkc7nZhIveAU7MWmb8wwExglOyXbmJfHZ5/a1VKQ
 948gb2QC2Lmq79cTDEb11u14tvLPGmEHf9oTTO6vAHck4OmuWqDWKyjVNpGYQUT8eSRk Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvk0g2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLFbEr131513;
        Tue, 12 Jan 2021 21:33:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 360ke76qt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLXTCn011390;
        Tue, 12 Jan 2021 21:33:29 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:29 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 11/13] io_uring: make percpu_ref_release names consistent
Date:   Tue, 12 Jan 2021 13:33:11 -0800
Message-Id: <1610487193-21374-12-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120127
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make the percpu ref release function names consistent between rsrc data
and nodes.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 96f760e..5ab0ff1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7297,7 +7297,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 #endif
 }
 
-static void io_rsrc_ref_kill(struct percpu_ref *ref)
+static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_rsrc_data *data;
 
@@ -7376,7 +7376,7 @@ static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
 	data->ctx = ctx;
 	init_completion(&data->done);
 
-	if (percpu_ref_init(&data->refs, io_rsrc_ref_kill,
+	if (percpu_ref_init(&data->refs, io_rsrc_data_ref_zero,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
 		kfree(data);
 		return ERR_PTR(-ENOMEM);
@@ -7759,7 +7759,7 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
-static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
+static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_rsrc_ref_node *ref_node;
 	struct fixed_rsrc_data *data;
@@ -7803,7 +7803,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 	if (!ref_node)
 		return ERR_PTR(-ENOMEM);
 
-	if (percpu_ref_init(&ref_node->refs, io_rsrc_data_ref_zero,
+	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
 			    0, GFP_KERNEL)) {
 		kfree(ref_node);
 		return ERR_PTR(-ENOMEM);
-- 
1.8.3.1

