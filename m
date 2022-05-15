Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777C85277C3
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbiEONN0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbiEONNZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:13:25 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311D0DF71
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620403;
        bh=osERllyiWWDuMwoMXBhRuq5EfjuyDVz5xKPNUP5znhU=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=IpYdqZTU+JbOVqdTIxGV7idv6RIeyqBhiql29FVbHQ+SpaZ+B3YmP0MioBTomnY9H
         lBhuh3aFD/4fSwzrGI7rhTOo9Rx4had70DpG3rsL6jRRJNZHIHOJaXK0uznGu4bmmU
         WfptpmlY2qHuWuEwuBYkiPJvmRtDY0Iv6xmHbitzV3C6sS0ywM5E7ecz+LHAbn7Pf6
         0A14aY6x8uc1jtCn2Ux6tXmFpkpl3Pzo9gBfgzGAbzuYBo1tdQWb6WFE2d4R3yQDyU
         HQ4yzChrWSF+0ed+l63xDyLxw9W2wyx4sqL2MjtxstcCDoMZpt3tdqVFTcFNnZUIWE
         xgC2HOSc9e7Mg==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id 6AE6C3E1CCA;
        Sun, 15 May 2022 13:13:18 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 11/11] io_uring: cancel works in exec work list for fixed worker
Date:   Sun, 15 May 2022 21:12:30 +0800
Message-Id: <20220515131230.155267-12-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
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

From: Hao Xu <howeyxu@tencent.com>

From: Hao Xu <howeyxu@tencent.com>

When users want to cancel a request, look into the exec work list of
fixed worker as well. It's not sane to ignore it.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c6e4179a9961..5345a5f57e4f 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1287,32 +1287,26 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 	return false;
 }
 
-static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
-				       struct io_cb_cancel_data *match)
-{
+static void io_wqe_cancel_pending_work_fixed(struct io_wqe *wqe,
+					     struct io_cb_cancel_data *match,
+					     bool exec) {
 	int i, j;
 	struct io_wqe_acct *acct, *iw_acct;
 
-retry_public:
-	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		acct = io_get_acct(wqe, i == 0, false);
-		if (io_acct_cancel_pending_work(wqe, acct, match)) {
-			if (match->cancel_all)
-				goto retry_public;
-			return;
-		}
-	}
-
-retry_private:
+retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		acct = io_get_acct(wqe, i == 0, true);
 		raw_spin_lock(&acct->lock);
 		for (j = 0; j < acct->nr_fixed; j++) {
-			iw_acct = &acct->fixed_workers[j]->acct;
+			if (exec)
+				iw_acct = &acct->fixed_workers[j]->acct;
+			else
+				iw_acct = &acct->fixed_workers[j]->exec_acct;
+
 			if (io_acct_cancel_pending_work(wqe, iw_acct, match)) {
 				if (match->cancel_all) {
 					raw_spin_unlock(&acct->lock);
-					goto retry_private;
+					goto retry;
 				}
 				break;
 			}
@@ -1321,6 +1315,26 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	}
 }
 
+static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
+{
+	int i;
+	struct io_wqe_acct *acct;
+
+retry:
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		acct = io_get_acct(wqe, i == 0, false);
+		if (io_acct_cancel_pending_work(wqe, acct, match)) {
+			if (match->cancel_all)
+				goto retry;
+			return;
+		}
+	}
+
+	io_wqe_cancel_pending_work_fixed(wqe, match, false);
+	io_wqe_cancel_pending_work_fixed(wqe, match, true);
+}
+
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
-- 
2.25.1

