Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A8F1EEEE9
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 03:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgFEBCE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 21:02:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgFEBCE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 21:02:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0550wAbs013923;
        Fri, 5 Jun 2020 01:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=o9ypjZyCA0VBz2Muy68hLq03h76EHgerbymps1DkDOU=;
 b=gL7bys1VIhZGsCCqmaT0WwAFIcPipflavAWs4OO5GGTGLrqjPiATcCYGfhdiYOruyyeh
 Il5HzrEaYuCNK46stGfKHxk+belxiviYlt7fnYPV2C5DJBnR3oO85hRDG7keW2iXFw5u
 RZetWx462VbqrKBQ4QfyBFkbHvMuaEOlxjJhD7UXrGDbw+rPtiUMadkzNBzQ1zFrd/OF
 q90uWWzpkrRuz8GF/pRNSE69K6pBwKbvY4Bs9BsaYzMWvKxeTzMwTAD13d1Dl43Fb+b7
 6RG5evuThkEVql4e7DJHqtGgPBA9ti1bR5i+mtyhlHFKOvYSdiYms9tCGo3AsTokvyfR aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31f9260esc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 01:02:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0550vNs5133188;
        Fri, 5 Jun 2020 01:02:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31f92rx88f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 01:02:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 055120Pv021392;
        Fri, 5 Jun 2020 01:02:00 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Jun 2020 18:02:00 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: validate the full range of provided buffers for access
Date:   Thu,  4 Jun 2020 18:01:52 -0700
Message-Id: <1591318912-34736-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591318912-34736-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1591318912-34736-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=1 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=1 cotscore=-2147483648 bulkscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050004
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Account for the number of provided buffers when validating the address
range.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb25e39..c64ea37 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3116,7 +3116,7 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
 
-	if (!access_ok(u64_to_user_ptr(p->addr), p->len))
+	if (!access_ok(u64_to_user_ptr(p->addr), (p->len * p->nbufs)))
 		return -EFAULT;
 
 	p->bgid = READ_ONCE(sqe->buf_group);
-- 
1.8.3.1

