Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557042DA264
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 22:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503036AbgLNVK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 16:10:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47390 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbgLNVKF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 16:10:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKtbva016125;
        Mon, 14 Dec 2020 21:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=pmA91N/MpLXTPEiPt84mP3HWQTIEqUw85v6RobRNOoo=;
 b=teRyY7nV0bZo3cRmGeQWxm3dv3fNK9QjI2UWerHWvxx+ouE9egv9ONTuWZEz41OSxClt
 bevZN3eVG1o9DSBjt2Him8lsNpArCn934rQtiB+I0/zjsG5hdBFu4LVKf8BRg2MEHU+p
 Ehomt0NPDRnm/pvxO72x/4FCXyDGcpkpZTOcbLVb3Ph+ONigd+LkvQttAlVFFH6Xv5QA
 MCJL++j9oGKYJt+922T8hlvpD0/tfh1Tw3h30GQzOaR/1N4d3cDr6eetoURK1tDcPMoV
 7wDvo2x0B8aCVayQfuujq6INQu/iHOKxyEjb/W6GsC5r3nm7jpsyEV8yFY+FNMpNr4qC jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35ckcb7p5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 21:09:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKu5fw163142;
        Mon, 14 Dec 2020 21:09:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35d7sv3fm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:09:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEL9KOG019897;
        Mon, 14 Dec 2020 21:09:20 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 13:09:20 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH 2/5] liburing: support buffer registration sharing
Date:   Mon, 14 Dec 2020 13:09:08 -0800
Message-Id: <1607980151-18816-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140140
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 src/include/liburing/io_uring.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 4e61817..f238d2f 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -102,6 +102,8 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SHARE_BUF	(1U << 7)	/* share buffer registration */
+#define IORING_SETUP_ATTACH_BUF	(1U << 8)	/* attach buffer registration */
 
 enum {
 	IORING_OP_NOP,
-- 
1.8.3.1

