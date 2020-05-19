Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727AC1DA41A
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 23:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgESVwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 17:52:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgESVwb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 17:52:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLpOPM142555;
        Tue, 19 May 2020 21:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=VVtDqI7RkLLefqyeh2KDqL2jJmhXPp+9lxYlCOpvwPk=;
 b=qRR/x3ZR7nnUlyhKlaui3J4gzl4pRP/o36Ndsbb2eGd52h6GPs/T0vYfxDDimBvEPHmT
 jhTE9NlL/BdInrdIh1XV7hy1g+XUMWL6jhUoenxzOK3KdGv0IfHxg5H5cpKmYyHbMNNk
 xtuhzhNUlTYDMue3D3mTG7ITeqs40l0lme1iY3tt9outBhFM1vZ2sOwxxiEqcoE+IgTR
 EXvemXdHgmfFuTpQz04ySDqKysFJls/9OM00bchjQknEUKnxRTy20tSPzsJpezQUTgox
 Siqma2DaT27FhQF3TrTAzmB1j8Qj7SwTuE5y8Gl26e0KIwKo3zVPgm+bWtWIK43GYScs 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tnfwmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:52:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLqPcg020059;
        Tue, 19 May 2020 21:52:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 314gm5vnpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:52:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JLqRFd030614;
        Tue, 19 May 2020 21:52:28 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:52:27 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 2/3] update wait_nr to account for completed event
Date:   Tue, 19 May 2020 14:52:20 -0700
Message-Id: <1589925141-48552-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190184
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If there are events to wait for, then account for one already complete.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 src/queue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/queue.c b/src/queue.c
index c7473c0..da2f405 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -49,6 +49,8 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 			err = -EAGAIN;
 			break;
 		}
+		if (wait_nr && cqe)
+			wait_nr--;
 		if (wait_nr)
 			flags = IORING_ENTER_GETEVENTS;
 		if (submit)
-- 
1.8.3.1

