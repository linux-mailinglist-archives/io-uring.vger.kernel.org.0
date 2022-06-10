Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21142546118
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 11:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344532AbiFJJKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 05:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347155AbiFJJKD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 05:10:03 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE93289F06
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 02:07:57 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654852076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=faVsmm7SshsrJAyY/i6h9TMbvPwTJcP4C9gciMxrHYQ=;
        b=pvViecOYa7Lae6ATQhgwKELYBKbmMdt2pEF84TrhFGa6fv+Bi64hpBNDOdIr/yPnpqeAFF
        Q+tmqM1FF2ApM/vV4Qpzo53woDrmrciUcupUJyP/1SjQwOkq1ODCLT3KtPpBiGzs6CHRCk
        ZfegqXxVkqSU3R/+Dm+2FsuggujPKDA=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5/5] io_uring: kbuf: fix bug of not consuming ring buffer in partial io case
Date:   Fri, 10 Jun 2022 17:07:34 +0800
Message-Id: <20220610090734.857067-6-hao.xu@linux.dev>
In-Reply-To: <20220610090734.857067-1-hao.xu@linux.dev>
References: <20220610090734.857067-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

When we use ring-mapped provided buffer, we should consume it before
arm poll if partial io has been done. Otherwise the buffer may be used
by other requests and thus we lost the data.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/kbuf.c |  9 +++++++--
 io_uring/kbuf.h | 10 ++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d2b2b4728381..0680b63af1d2 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -49,8 +49,13 @@ void __io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	 */
 	if (req->flags & REQ_F_BUFFER_RING) {
 		if (req->buf_list) {
-			req->buf_index = req->buf_list->bgid;
-			req->flags &= ~REQ_F_BUFFER_RING;
+			if (req->flags & REQ_F_PARTIAL_IO) {
+				req->buf_list->head++;
+				req->buf_list = NULL;
+			} else {
+				req->buf_index = req->buf_list->bgid;
+				req->flags &= ~REQ_F_BUFFER_RING;
+			}
 		}
 		return;
 	}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b58d9d20c97e..9ecb175e60a9 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -58,8 +58,14 @@ static inline void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 {
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return;
-	/* don't recycle if we already did IO to this buffer */
-	if (req->flags & REQ_F_PARTIAL_IO)
+	/*
+	 * For legacy provided buffer mode, don't recycle if we already did
+	 * IO to this buffer. For ring-mapped provided buffer mode, we should
+	 * increment ring->head to explicitly monopolize the buffer to avoid
+	 * multiple use.
+	 */
+	if ((req->flags & REQ_F_BUFFER_SELECTED) &&
+	    (req->flags & REQ_F_PARTIAL_IO))
 		return;
 	__io_kbuf_recycle(req, issue_flags);
 }
-- 
2.25.1

