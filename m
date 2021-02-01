Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A02230A787
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 13:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhBAMYk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 07:24:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47162 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBAMYj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 07:24:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111CEpWO077887;
        Mon, 1 Feb 2021 12:23:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=TDLU8elTzfkETu0v7dnO9J6Fm1wtMapt/et95Jh9m88=;
 b=AKmYuYVdCHZL5ke3Y0ufc5+bdoxgxCoVReOtZIGT02LBsXf0+5SR3+zQXG6Mvuz09T+s
 m2keYWcLA20KEUc5I3uMNh48MDieMf/Rj9X/lndlwIOZSR52hsdxHrY/2UNVpPDavLsu
 9JmIP7GjbY0bD3Agxd3NInjm5bbYm04Y+qg4PmFOL2lcit8VblxqHlZdEdElUjQNdPWw
 eJidf0Hguu8EvDuBBT75dC3gUmeKSIX5mn+ZXxGoB+D2I/wAt7y31XsP4KGVE9jkAJpq
 VktCATgbuvJRuCkn9sJX8Se4HgQJljT+ksIC3VRrigunwMa5MY7aOUYKkUEfXnWOYa8V Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cydkmwvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 12:23:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111CA8Lg147030;
        Mon, 1 Feb 2021 12:23:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 36dh7pn27q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 12:23:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 111CNm61018588;
        Mon, 1 Feb 2021 12:23:48 GMT
Received: from mwanda (/10.175.186.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Feb 2021 04:23:48 -0800
Date:   Mon, 1 Feb 2021 15:23:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] io_uring: Fix NULL dereference in error in
 io_sqe_files_register()
Message-ID: <YBfyzmcP1N6jpDjo@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010064
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010064
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we hit a "goto out_free;" before the "ctx->file_data" pointer has
been assigned then it leads to a NULL derefence when we call:

	free_fixed_rsrc_data(ctx->file_data);

We can fix this by moving the assignment earlier.

Fixes: 3cfb739c561e ("io_uring: create common fixed_rsrc_data allocation routines")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 03748faa5295..8e8b74dd7d9b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7869,6 +7869,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	file_data = alloc_fixed_rsrc_data(ctx);
 	if (!file_data)
 		return -ENOMEM;
+	ctx->file_data = file_data;
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
@@ -7878,7 +7879,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
 		goto out_free;
-	ctx->file_data = file_data;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
 		struct fixed_rsrc_table *table;
-- 
2.29.2

