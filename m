Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE3D17AF5F
	for <lists+io-uring@lfdr.de>; Thu,  5 Mar 2020 21:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCEUF7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Mar 2020 15:05:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgCEUF7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Mar 2020 15:05:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 025K3Dvk022598;
        Thu, 5 Mar 2020 20:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=t8CAWsgw/ELAbr5QnCrpPBQ505nk1Vu1ytI4BAQPrjk=;
 b=qw5KAu+5x/mirpb96LhLseOQBeoE1g3KqE56X2xHk0uyspvS/7d79kx9XbhpTUcU7uj3
 dvVo/KBxCSR/2onyknlNQJSLw325k5akEGJ/QT2uC9/SkdupNuXCdQwRCpVEkizLrZF9
 6ewlsMmbqeNpMWBFXrIpQA3d1cjozQq6CFYv0+NVRD5HPArWkNpPxmURjVvgxOXZxEWN
 e/H4O4ZZp9I/kabwHM/XtyLc2NPfxv63pFsl13+SjpeA5JUGyhoI/bGsWHfw9sWnMsQq
 Ky358/r857GJoJ90QY0CwjiuGBf3vNOzjIiROeHrsuO/CxErp6Ce4w8po/6ZjBGator+ Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yghn3k7ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 20:05:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 025K3BNE121033;
        Thu, 5 Mar 2020 20:05:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yg1h48kdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 20:05:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 025K5sBK007254;
        Thu, 5 Mar 2020 20:05:54 GMT
Received: from kili.mountain (/41.210.146.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Mar 2020 12:05:53 -0800
Date:   Thu, 5 Mar 2020 23:05:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] io_uring: Fix error handling in
 __io_compat_recvmsg_copy_hdr()
Message-ID: <20200305200544.5wmrfo7hbfybp3w5@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9551 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9551 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050116
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need to check if __get_compat_msghdr() fails and return immediately
on error.  Also if compat_import_iovec() fails then we should return a
negative error code, but the current behavior is to just return
success.

Fixes: ede6c476b57d ("io_uring: add IOSQE_BUFFER_SELECT support for IORING_OP_RECVMSG")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d7c42bd04c78..c1a59cde2d88 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3684,6 +3684,8 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 	msg_compat = (struct compat_msghdr __user *) sr->msg;
 	ret = __get_compat_msghdr(&io->msg.msg, msg_compat, &io->msg.uaddr,
 					&ptr, &len);
+	if (ret)
+		return ret;
 
 	uiov = compat_ptr(ptr);
 	if (req->flags & REQ_F_BUFFER_SELECT) {
@@ -3703,8 +3705,8 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 		ret = compat_import_iovec(READ, uiov, len, UIO_FASTIOV,
 						&io->msg.iov,
 						&io->msg.msg.msg_iter);
-		if (ret > 0)
-			ret = 0;
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
-- 
2.11.0

