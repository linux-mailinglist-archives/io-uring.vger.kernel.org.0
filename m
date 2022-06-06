Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6A853E1F8
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiFFG5j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiFFG5f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:57:35 -0400
Received: from pv50p00im-tydg10021701.me.com (pv50p00im-tydg10021701.me.com [17.58.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4781D300
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1654498652;
        bh=a6+ARZx9IJXP9bGHAg/DFfI2dMCBSma0ujlc7GbjIMg=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=EN4xVw2RodBFSQHq4w7afwTNe4HlmHGrSSc1dFp0iJN8SU69RO9rMQAeC+IyUb2Ex
         TNHBNyIBS+Y7f49qPWksG3wL40hWvk77oqrxdMfo92TBiCmqhbe6wU/DEfJWQOfCyj
         j9WDXa3P9E4iUjTaLI19Lcnht2CSNf3TxzVG3hGJ8u/pJTqaYQTYp5FzENz5MUHjlh
         c7P3JTFuM7NYMIQKjS8dO04SEzYYmvvUNSssEo97mhmUnr77gU5la0wXvJVP9z3gUX
         PL8d2mWTx1uzAUpesu+pUEEjJ1/+3/ZXU/IlMoxcX7ply2zR3UYlAeb6rvgRRRDblD
         z1OYe7Zo+1+Cw==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10021701.me.com (Postfix) with ESMTPSA id 3A2333A0D74;
        Mon,  6 Jun 2022 06:57:29 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/3] io_uring: add an io_hash_bucket structure for smaller granularity lock
Date:   Mon,  6 Jun 2022 14:57:15 +0800
Message-Id: <20220606065716.270879-3-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606065716.270879-1-haoxu.linux@icloud.com>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_02:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2206060031
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a new io_hash_bucket structure so that each bucket in cancel_hash
has separate spinlock. This is a prep patch for later use.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/cancel.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 4f35d8696325..b9218310611c 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -4,3 +4,8 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
+
+struct io_hash_bucket {
+	spinlock_t		lock;
+	struct hlist_head	list;
+};
-- 
2.25.1

