Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A6C1F722F
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 04:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgFLCYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 22:24:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60296 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgFLCYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 22:24:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05C2HMdh185946;
        Fri, 12 Jun 2020 02:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=FwWCp6vjt8nvo7eDqU99TKCY8vUQrKGn8Aof7HXGwMc=;
 b=GfHdEkelyFTiuAD0wZWHTfb5t+4d7xsz4tiDaPmlOG00xBjnwFHmgXNpegzUMw4J2M6e
 SBEgs+cXuDstuapYMGHLfqz3jlvGpCDl36uVPb62N/LD39nKSERh0A4AFx0rSoc2KcGC
 W59COXAhSfJDttH+dBFsNtG/H6Xr1Q6jcgt6obKs+dqfvJYiG/yyKRCunvfO7iR+SqhQ
 pdmR+rZoIjqLBm7KC1hPzaO1up3WjdMg2lUq851pqWYlhAuLGcX1cTY2a2OVty7z00XO
 kZ3Myy1A3CPEaAi9voAJRuuqITcmhWnHDhre+/09noAjGJ4sGzTzYXoSH13Wu3QtMsZp cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31jepp4p12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 12 Jun 2020 02:24:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05C2MrI1146802;
        Fri, 12 Jun 2020 02:24:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31m0vdg3xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jun 2020 02:24:06 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05C2NhhZ009634;
        Fri, 12 Jun 2020 02:23:43 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jun 2020 19:23:42 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 2/2] io_uring: report pinned memory usage
Date:   Thu, 11 Jun 2020 19:23:37 -0700
Message-Id: <1591928617-19924-3-git-send-email-bijan.mottahedeh@oracle.com>
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

Long term, it makes sense to separate reporting and enforcing of pinned
memory usage.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

It is useful to view
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4248726..cf3acaa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7080,6 +7080,8 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	atomic_long_sub(nr_pages, &user->locked_vm);
+	if (current->mm)
+		atomic_long_sub(nr_pages, &current->mm->pinned_vm);
 }
 
 static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
@@ -7096,6 +7098,8 @@ static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
 			return -ENOMEM;
 	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
 					new_pages) != cur_pages);
+	if (current->mm)
+		atomic_long_add(nr_pages, &current->mm->pinned_vm);
 
 	return 0;
 }
-- 
1.8.3.1

