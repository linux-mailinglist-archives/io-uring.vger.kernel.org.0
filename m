Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A771DA41C
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 23:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgESVwi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 17:52:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36954 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgESVwi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 17:52:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLpjc5041389;
        Tue, 19 May 2020 21:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=eV2bhWSKnOffRXGHvxHMCGGK5w22ZFmqk4UFRDSMYJU=;
 b=HwN2Z8BMdOSkk4jlTXtJi+CUv17/NcZewuh32V6x7zI8kuZISqRbyA8CMc5TlLAv6jSn
 ipKJHw/ohCoJehuCObRyS96v9CBG4Sb1Vmmec57PzzKXITuH7vsogbsEjAiX372SBnaJ
 REy8IFPlxhfF+L9qjzAz3dPs0aFGgI3BFYBXDm1j0/9pZYRyJPd5mYQOWKvf2u6iy3xC
 1bYQjlUBa2iBJ6XEP/Eu1PQyqmVluCWd0DO4E51yKQ+N+FCjnVGUNwQQzbeVZ0y52xCp
 klAZiLkUZxca9NA6XAaYziJf0/sWgsK+xpwl/hw0uiNBNeRtsyx4WeFqyOcIbseDdkrM Gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284m00bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:52:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLqYbD116560;
        Tue, 19 May 2020 21:52:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 313gj2cm0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:52:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04JLqRIr005490;
        Tue, 19 May 2020 21:52:27 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:52:27 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 1/3] preseve wait_nr if SETUP_IOPOLL is set
Date:   Tue, 19 May 2020 14:52:19 -0700
Message-Id: <1589925141-48552-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
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

When SETUP_IOPOLL is set, __sys_io_uring_enter() must be called to reap
new completions but the call won't be made if both wait_nr and submit
are zero, so preserve wait_nr.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 src/queue.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/queue.c b/src/queue.c
index 14a0777..c7473c0 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -60,7 +60,14 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 			err = -errno;
 		} else if (ret == (int)submit) {
 			submit = 0;
-			wait_nr = 0;
+			/*
+			 * When SETUP_IOPOLL is set, __sys_io_uring enter()
+			 * must be called to reap new completions but the call
+			 * won't be made if both wait_nr and submit are zero
+			 * so preserve wait_nr.
+			 */
+			if (!(ring->flags & IORING_SETUP_IOPOLL))
+				wait_nr = 0;
 		} else {
 			submit -= ret;
 		}
-- 
1.8.3.1

