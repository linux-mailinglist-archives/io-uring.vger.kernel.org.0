Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341B254F066
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 07:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380028AbiFQFEl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 01:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiFQFEk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 01:04:40 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C678666BD
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 22:04:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655442277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hs3j07ZBWqc/g1a7MtF6WCr4H+zAPOPJk7E2NtLXEEk=;
        b=CDx7OtXuAPtKJTW6aPInZeoyKnU/8fRRpqanuQdypnZ2/YW0Mt0+yG/gUdThJPcW/of82l
        FaCnBgt0fpEuGIvVxWO1FmrobFK3r7H4C3w9/V9B7kP86OQ+Ui7qXIaR4jmaKx7deSDNVe
        FS3tLt6rHBA0Lp51xUtwYGJ/YAsQj0E=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2] io_uring: kbuf: add comments for some tricky code
Date:   Fri, 17 Jun 2022 13:04:29 +0800
Message-Id: <20220617050429.94293-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add comments to explain why it is always under uring lock when
incrementing head in __io_kbuf_recycle. And rectify one comemnt about
kbuf consuming in iowq case.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---

v1->v2:
 - modify comments to make it look better
 - remove weird chars which turns out to be some helper line by some vim plugin

 io_uring/kbuf.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 07dbb0d17aae..d641d1f9450f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -52,6 +52,13 @@ void __io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	if (req->flags & REQ_F_BUFFER_RING) {
 		if (req->buf_list) {
 			if (req->flags & REQ_F_PARTIAL_IO) {
+				/*
+				 * If we end up here, then the io_uring_lock has
+				 * been kept held since we retrieved the buffer.
+				 * For the io-wq case, we already cleared
+				 * req->buf_list when the buffer was retrieved,
+				 * hence it cannot be set here for that case.
+				 */
 				req->buf_list->head++;
 				req->buf_list = NULL;
 			} else {
@@ -163,12 +170,13 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	if (issue_flags & IO_URING_F_UNLOCKED || !file_can_poll(req->file)) {
 		/*
 		 * If we came in unlocked, we have no choice but to consume the
-		 * buffer here. This does mean it'll be pinned until the IO
-		 * completes. But coming in unlocked means we're in io-wq
-		 * context, hence there should be no further retry. For the
-		 * locked case, the caller must ensure to call the commit when
-		 * the transfer completes (or if we get -EAGAIN and must poll
-		 * or retry).
+		 * buffer here, otherwise nothing ensures that the buffer won't
+		 * get used by others. This does mean it'll be pinned until the
+		 * IO completes, coming in unlocked means we're being called from
+		 * io-wq context and there may be further retries in async hybrid
+		 * mode. For the locked case, the caller must call commit when
+		 * the transfer completes (or if we get -EAGAIN and must poll of
+		 * retry).
 		 */
 		req->buf_list = NULL;
 		bl->head++;

base-commit: de4873338bd3e284abffa7c28b3b653244fb655c
-- 
2.25.1

