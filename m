Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAECF5F2D08
	for <lists+io-uring@lfdr.de>; Mon,  3 Oct 2022 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiJCJUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiJCJUN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 05:20:13 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76FD1403F
        for <io-uring@vger.kernel.org>; Mon,  3 Oct 2022 02:20:12 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u24so2179776plq.12
        for <io-uring@vger.kernel.org>; Mon, 03 Oct 2022 02:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=v3bDIOv0Q4yRux6aYympLWXPfJSNdoJS4+UYRhghm9g=;
        b=oYAY48QBfm6bQBDl5iTN6BGATGvt6sYBb4w+ezlvVz/V4LgUWMlnJs+McqP6PLe67+
         W+m5wVhMlIMRx8kzQ4ha3adHi8SCqU7oBwE+al2RGYzK9chr+ZHJMf8DI4Ya9Lyb0CQi
         ZgBRRtJy8igJgQweyRAe4QTqBPeoUPKtEBGv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=v3bDIOv0Q4yRux6aYympLWXPfJSNdoJS4+UYRhghm9g=;
        b=AAEPW+FjFWubzpBm8dteH5OE1aZIX9XQ75qNejtu4MaVvNzSz0HPNeKAoEe+346Gog
         nxqU9exMFGtACTM5WhOfwMf74JDBwz8WzYv8jNMpJQyYsqsUgQ0YW4xEIxBXo295hTEB
         9juDSVekueugjna8i3nem4fiQCun5B+6Yh81W07gO317Jkj29qTQMlqAZmMzFdr24c+t
         wNcfuC7Byb4RSIwgae3Amee81z8K1x7D2xQezLtOIBj95sYocrzytQtycC66oqC9xvE+
         f0vcPnqdME7a7Y3cRwXBxA8sJwzHWMsXc/7Mxv4knRqZIitLecCCymBjw4WrXmBv/KmO
         Bfhw==
X-Gm-Message-State: ACrzQf3nEuSJ3feaKN3S56nMBoCfF8AGwOcXHgm5nc7DfNtyBZhMTAXE
        g1hWkZM1dJOTvGw54zV7c7p/vA3dbZDIpA==
X-Google-Smtp-Source: AMsMyM5IWdENzAQ2PoF0SXqrseBiKSmiBy0I1Rl5me/CV9YYHcuYcjtIKOMyWT3nsDO5uImLb+5DaQ==
X-Received: by 2002:a17:902:c412:b0:17f:127b:fc30 with SMTP id k18-20020a170902c41200b0017f127bfc30mr5698141plk.93.1664788811969;
        Mon, 03 Oct 2022 02:20:11 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:8462:b523:6413:75ba])
        by smtp.gmail.com with UTF8SMTPSA id n7-20020a1709026a8700b0017bb38e4591sm6708827plk.41.2022.10.03.02.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 02:20:11 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH] io_uring: fix short read/write with linked ops
Date:   Mon,  3 Oct 2022 18:19:23 +0900
Message-Id: <20221003091923.2096150-1-stevensd@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

When continuing a short read/write, account for any completed bytes when
calculating the operation's target length. The operation's actual
accumulated length is fixed up by kiocb_done, and the target and actual
lengths are then compared by __io_complete_rw_common. That function
already propagated the actual length to userspace, but the incorrect
target length was causing it to always cancel linked operations, even
with a successfully completed read/write.

Fixes: 227c0c9673d8 ("io_uring: internally retry short reads")
Signed-off-by: David Stevens <stevensd@chromium.org>
---
 io_uring/rw.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 76ebcfebc9a6..aa9967a52dfd 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -706,13 +706,14 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	struct kiocb *kiocb = &rw->kiocb;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_async_rw *io;
-	ssize_t ret, ret2;
+	ssize_t ret, ret2, target_len;
 	loff_t *ppos;
 
 	if (!req_has_async_data(req)) {
 		ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
+		target_len = iov_iter_count(&s->iter);
 	} else {
 		io = req->async_data;
 		s = &io->s;
@@ -733,6 +734,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * need to make this conditional.
 		 */
 		iov_iter_restore(&s->iter, &s->iter_state);
+		target_len = iov_iter_count(&s->iter) + io->bytes_done;
 		iovec = NULL;
 	}
 	ret = io_rw_init_file(req, FMODE_READ);
@@ -740,7 +742,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		kfree(iovec);
 		return ret;
 	}
-	req->cqe.res = iov_iter_count(&s->iter);
+	req->cqe.res = target_len;
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
@@ -850,18 +852,20 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec *iovec;
 	struct kiocb *kiocb = &rw->kiocb;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	ssize_t ret, ret2;
+	ssize_t ret, ret2, target_len;
 	loff_t *ppos;
 
 	if (!req_has_async_data(req)) {
 		ret = io_import_iovec(WRITE, req, &iovec, s, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
+		target_len = iov_iter_count(&s->iter);
 	} else {
 		struct io_async_rw *io = req->async_data;
 
 		s = &io->s;
 		iov_iter_restore(&s->iter, &s->iter_state);
+		target_len = iov_iter_count(&s->iter) + io->bytes_done;
 		iovec = NULL;
 	}
 	ret = io_rw_init_file(req, FMODE_WRITE);
@@ -869,7 +873,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kfree(iovec);
 		return ret;
 	}
-	req->cqe.res = iov_iter_count(&s->iter);
+	req->cqe.res = target_len;
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-- 
2.38.0.rc1.362.ged0d419d3c-goog

