Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239FF1A3C34
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 00:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgDIWDs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 18:03:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33584 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgDIWDs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 18:03:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039LwIrr078719;
        Thu, 9 Apr 2020 22:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=udlMrhWzTc1DQaWfT2cVRvpb4hn3rqAbVyKH21iEdYc=;
 b=CXZXuKbM9mpkaU46suy4OA1twA4IOCi7MZpz2To81cAtBjp0LWrSyPB4MuHBbnnSlReS
 xUA/GieZpqkfL47tzdZKx2tFGzlg2NqHr/Mo1MEvpafAim/KvsTGfXW6lYhe31WqoVQh
 DKUwCtj+gg9pRK3rpXcEwB5wrJFCshYy3T+PraaVCxvkOevgqUWSf6TvCCCfurTJgXoU
 A2DKupnjC9x26pm00NuvGRcz2yiczOVWa0z9CZb7688MhxQcC6OFyXIMoFa8d7JqjjAI
 VUIxUw+Cg485iFgYSVVr9wvX2TiUNWTw+WWghjGnDnj+oVelC/dPT/u03H6OofnBVQvI 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3091m3m1gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 22:03:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039M2nuu108812;
        Thu, 9 Apr 2020 22:03:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 309ag5t8y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 22:03:45 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039M3ir9008148;
        Thu, 9 Apr 2020 22:03:44 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 15:03:44 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 1/1] io_uring: preserve work->mm since actual work processing may need it
Date:   Thu,  9 Apr 2020 15:03:37 -0700
Message-Id: <1586469817-59280-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090154
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do not clear work->mm since io_madvise() passes it to do_madvise()
when the request is actually processed.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io-wq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4023c98..4d20754 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -431,8 +431,6 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 		if (!worker->mm)
 			set_fs(USER_DS);
 		worker->mm = work->mm;
-		/* hang on to this mm */
-		work->mm = NULL;
 		return;
 	}
 
-- 
1.8.3.1

