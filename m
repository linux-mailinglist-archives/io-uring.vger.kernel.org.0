Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDDB5277BC
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbiEONM5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbiEONM4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:12:56 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61D5DF67
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620375;
        bh=x6IB+rJOUQrmoPA9dhyLFYmiqltZCCEup0t7ONB9B3s=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=lzGtwEWRIssY6BO/oSP98HD0PCObvNv0CnG7a1VPz4fn8VwkMksC7XIGVgDvkXe0O
         DHbVN0cwJzXkBo7vFuzqiFFWTZSKqiGiTWnIeW8Q2xgHOGWK6/37wLXnRzTt5lzpHw
         73INBcpXec5s98DZdJjrP+eaB8amqJ/mk8eyOT3KUUoxEgDyrfVRVSt5QwDMIpOeZI
         12OT+xlbD3adHSEdO+fjIDNq2TS6BW9FgVkyS642HK5fs8Fl++zMwrwOZQ0JAQqcbT
         nqoOIjgplSzFBmhRnRgZzGlrqIlX3T33ycgyZ8kRyvAzjX7ZO7mG6tabooo61ulg+h
         reg0tglHffPGQ==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id F35253E1F13;
        Sun, 15 May 2022 13:12:52 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 04/11] io-wq: tweak io_get_acct()
Date:   Sun, 15 May 2022 21:12:23 +0800
Message-Id: <20220515131230.155267-5-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=787 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205150069
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <haoxu.linux@gmail.com>

From: Hao Xu <howeyxu@tencent.com>

Add an argument for io_get_acct() to indicate fixed or normal worker

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 73fbe62617b7..8db3132dc3a1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -215,20 +215,24 @@ static void io_worker_release(struct io_worker *worker)
 		complete(&worker->ref_done);
 }
 
-static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound)
+static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound,
+					      bool fixed)
 {
-	return &wqe->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
+	unsigned index = bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND;
+
+	return fixed ? &wqe->fixed_acct[index] : &wqe->acct[index];
 }
 
 static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
 						   struct io_wq_work *work)
 {
-	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND), false);
 }
 
 static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND);
+	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND,
+			   worker->flags & IO_WORKER_F_FIXED);
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -1131,7 +1135,7 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	int i;
 retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
+		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0, false);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
 			if (match->cancel_all)
-- 
2.25.1

