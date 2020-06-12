Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67211F7230
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 04:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgFLCZK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 22:25:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgFLCZJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 22:25:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05C2P8LH008151;
        Fri, 12 Jun 2020 02:25:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=i5Ct6Rfq/EoFy5DiEJH5dDd7xnl3hlcv8EkSR8ksjOE=;
 b=eCKTkHJhQf8cgUTgbSfN+AdKWF9bg8w1nlTpqlv66Qy2y/2+zsIYTL/NITlCl47gDoPw
 kva7CZpU1vXN9YwdDrDRR3ENB264UrPVXM5ODjRxAsH8R+HgY+nIbCDtKB+/9EhgQHiZ
 TSdXHs9ZZsuU1EZQJk0Pt9N3nEeWkGO6AEJcHvTXKvB/i5KfnJnUSRQtVxgQp2iye7ug
 +E8x8n5rzOfA7LA5iTawzjtI9JYc1K3ErjrP/Uun9EE0rVZxSfbagRce8wQtnpbUvsq1
 LlY6aD7+7zDzeByiHJsCISUauoMgFeUnvdQpr+nohHe66laJfi539HASs6AiGZDzgoK7 dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31jepp4p6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 12 Jun 2020 02:25:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05C2MtZX146851;
        Fri, 12 Jun 2020 02:25:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31m0vdg8ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jun 2020 02:25:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05C2NgVn009632;
        Fri, 12 Jun 2020 02:23:42 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jun 2020 19:23:42 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 1/2] io_uring: disallow overlapping ranges for buffer registration
Date:   Thu, 11 Jun 2020 19:23:36 -0700
Message-Id: <1591928617-19924-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9649 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006120017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9649 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 cotscore=-2147483648 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006120016
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Buffer registration is expensive in terms of cpu/mem overhead and there
seems no good reason to allow overlapping ranges.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9158130..4248726 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7211,6 +7211,12 @@ static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
 	return 0;
 }
 
+static inline int iov_overlap(struct iovec *v1, struct iovec *v2)
+{
+	return (v1->iov_base <= (v2->iov_base + v2->iov_len - 1) &&
+		v2->iov_base <= (v1->iov_base + v1->iov_len - 1));
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 				  unsigned nr_args)
 {
@@ -7233,7 +7239,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
 		unsigned long off, start, end, ubuf;
 		int pret, nr_pages;
-		struct iovec iov;
+		struct iovec iov, prv_iov;
 		size_t size;
 
 		ret = io_copy_iov(ctx, &iov, arg, i);
@@ -7258,6 +7264,12 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 		start = ubuf >> PAGE_SHIFT;
 		nr_pages = end - start;
 
+		/* disallow overlapping buffers */
+		if (i > 0 && iov_overlap(&prv_iov, &iov))
+			goto err;
+
+		prv_iov = iov;
+
 		if (ctx->account_mem) {
 			ret = io_account_mem(ctx->user, nr_pages);
 			if (ret)
-- 
1.8.3.1

