Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4401DA425
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 23:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgESVxL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 17:53:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgESVxL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 17:53:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLpjSb041375;
        Tue, 19 May 2020 21:53:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=7mQ05onKcDgXu/1WPn8xqAG/gPLxbvK8u1N7Gt/VRlI=;
 b=loTQx6YXcrfvfTFXi5+17cwG0woRdGVw1HPO3b30kOqbg4X9y6k6hFGEBLm11m53xRoW
 HYoqD3ER+znzYG/K3C+I8oldVTro5RA9NkbWFanDHR8fQcmbGzX22iFmSuqRTBsmKyAI
 qT+W3h7aSsoSARoxeyt38+so7K046owfUhty5zZwFtm+vYZh6FKZXpU8mEuFsjoDFg8O
 x2pnAUn2Wg0c2pdV8bITYMrYbbx6BEVmK80ETLXy1G65q6KbZWWWKDWv+fITxIdOPBpQ
 0LxKNxz3YRk2O3pLqxDWI+V3ObEjrQ2zZJvV8dcedSgh4GFtJCqCD4hUPeDXVL8Npjuh WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284m00du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:53:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLr8wI182021;
        Tue, 19 May 2020 21:53:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 312sxtm25v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:53:08 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04JLqvVt005853;
        Tue, 19 May 2020 21:52:57 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:52:57 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 2/2] io_uring: mark REQ_NOWAIT for a non-mq queue as unspported
Date:   Tue, 19 May 2020 14:52:50 -0700
Message-Id: <1589925170-48687-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190184
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mark a REQ_NOWAIT request for a non-mq queue as unspported instead of
retryable since otherwise the io_uring layer will keep resubmitting
the request.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 block/blk-core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5847993..3807140 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -962,14 +962,10 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 	}
 
 	/*
-	 * Non-mq queues do not honor REQ_NOWAIT, so complete a bio
-	 * with BLK_STS_AGAIN status in order to catch -EAGAIN and
-	 * to give a chance to the caller to repeat request gracefully.
+	 * Non-mq queues do not honor REQ_NOWAIT, return -EOPNOTSUPP.
 	 */
-	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q)) {
-		status = BLK_STS_AGAIN;
-		goto end_io;
-	}
+	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
+		goto not_supported;
 
 	if (should_fail_bio(bio))
 		goto end_io;
-- 
1.8.3.1

