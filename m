Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DFA2F3E07
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393798AbhALWA7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 17:00:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47080 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437168AbhALVeP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:34:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLXX17114941;
        Tue, 12 Jan 2021 21:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=+3NEJ2o0r/C6z4qPpv4KTJgpxktL3gHewVCaZGQ1bHI=;
 b=gJq4pRJM4kT7wR7k94BJexXsFfvKeYvniZFqisfBTXLn8uQ7rE6TrYIRFwW49nJ7pFhz
 ITPrTLpBkgXuMxJ38KC+JKJH3II9aQmqPOZzqz1Mrg/eXLBzLK7e4zCsfCBFX5+QUEsD
 85RGdUZJUlsNHAWtMzhRoSB+KX6XA228JizB/RNhv/JgUUebwJv1DTDXzG0ayk77DPQ5
 VJrApyXmipEVtKOqUD7D+jGA7Km/4GW/zp5g45TEknPJ0W1EleBxJ7PP57OKWkpnZh7c
 yCSJOFD3uYTVIxEtI8jSD/ewlXg01w0KBNkDpnpxBF6siJ5targ8p4RmjPjPGRY8NyxX bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 360kg1rk06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLG3dL103685;
        Tue, 12 Jan 2021 21:33:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 360keyeu7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:28 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLXR2l023052;
        Tue, 12 Jan 2021 21:33:27 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:27 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 04/13] io_uring: split alloc_fixed_file_ref_node
Date:   Tue, 12 Jan 2021 13:33:04 -0800
Message-Id: <1610487193-21374-5-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120128
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split alloc_fixed_file_ref_node into resource generic/specific parts,
to be leveraged for fixed buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 158b53f..d0bc4c8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7699,7 +7699,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
-static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
+static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_ref_node *ref_node;
@@ -7715,9 +7715,21 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 	}
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	ref_node->done = false;
+	return ref_node;
+}
+
+static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
+			struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_ref_node *ref_node;
+
+	ref_node = alloc_fixed_rsrc_ref_node(ctx);
+	if (!ref_node)
+		return NULL;
+
 	ref_node->rsrc_data = ctx->file_data;
 	ref_node->rsrc_put = io_ring_file_put;
-	ref_node->done = false;
 	return ref_node;
 }
 
-- 
1.8.3.1

