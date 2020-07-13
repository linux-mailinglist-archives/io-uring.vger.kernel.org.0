Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C885721E115
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgGMUBU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgGMUBU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:01:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DA5C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:01:20 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id f12so18789889eja.9
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+h28eF3ERoKPhmMKhCQzSmuFDmQE3IHdR9JmiuYja3w=;
        b=ao1hVQu3KB3OXMWLD+9Dt0BZbvjDbuumih59kEsbXuN3LbiiEN1Cm0PsvmpDoxpGWW
         tDWdPw92sRUcPeX4DkDX+L5tObCDmyBXs2SdEgYiI4cGHJL9O4fL+M9RWph3y5IH/RnF
         FtOXsVv8xLnD0/XmnLSTZo89XOtVGutoef6Ao6K5/RdHQ9+S9pH88fGjbKjFhoqHbdv9
         TD0Zxhl3tn1M9KGwl4OtezMFRcBxfDFrKrtPYpjiTlsS29o5C/7dlpX9K+RLb8hzFH20
         76k9XzJezRoocKoAjJxFLzQSvytlrotYvd/n2fDEs5fvRHB3VNO1newmA0Gf8jCThfrV
         a8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+h28eF3ERoKPhmMKhCQzSmuFDmQE3IHdR9JmiuYja3w=;
        b=G/jYDx8Jxo5tpo1mwaPczf/UXrm7UQTSh9ojRRTPKBBZhgIn2dRkb7T1jwvMDorgFZ
         tYwNo0qIFrRFjCDbV4XgFHLpJSRBiMB9enqJY7/cRTM3HH2BDDGWvmq6QQjT1QFCOZad
         P9nrnS4ts9Ybmt/84MZMyWsfk9nOu/N/WU9bB0Z72HZAk5vBmfbLJAhe7nOt0SfEWPK6
         wcUomxgd/yQ9p1+UHKbKXI0apS6HTYgwrtkY97/TmkKG9xq5ENJUewsFVBZXMveXc4/Z
         mn4Yd0HS0ePxRHp0PUvj6kNFs4UleN3zxfmsjnBuLX0x6xEk5xGuLHKQbEIpHB0nBc8U
         1QkQ==
X-Gm-Message-State: AOAM531GYfyQEkElohtDOC1c6RZkOjR/6bvg3+ujocq64oZ3AVs/md0J
        l20c0n6ELiYp+nAh0WbEEFGkjLDT
X-Google-Smtp-Source: ABdhPJwp9ISvm5i0q6OZBXjUxu1qGBdoS/o6v9iFFuHjg+pN7HN2KJ0Z9TDK0ZduopxWMs0d3in/Vw==
X-Received: by 2002:a17:906:6b0c:: with SMTP id q12mr1362390ejr.525.1594670478726;
        Mon, 13 Jul 2020 13:01:18 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm10520408ejp.51.2020.07.13.13.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:01:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: simplify io_req_map_rw()
Date:   Mon, 13 Jul 2020 22:59:18 +0300
Message-Id: <c160bf8b12b16c100d9e308a6643d5eb56f7fa1a.1594669730.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594669730.git.asml.silence@gmail.com>
References: <cover.1594669730.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't deref req->io->rw every time, but put it in a local variable. This
looks prettier, generates less instructions and doesn't break alias
analysis.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6eae2fb469f9..d9c10070dcba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2827,15 +2827,17 @@ static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 			  struct iovec *iovec, struct iovec *fast_iov,
 			  struct iov_iter *iter)
 {
-	req->io->rw.nr_segs = iter->nr_segs;
-	req->io->rw.size = io_size;
-	req->io->rw.iov = iovec;
-	if (!req->io->rw.iov) {
-		req->io->rw.iov = req->io->rw.fast_iov;
-		if (req->io->rw.iov != fast_iov)
-			memcpy(req->io->rw.iov, fast_iov,
+	struct io_async_rw *rw = &req->io->rw;
+
+	rw->nr_segs = iter->nr_segs;
+	rw->size = io_size;
+	if (!iovec) {
+		rw->iov = rw->fast_iov;
+		if (rw->iov != fast_iov)
+			memcpy(rw->iov, fast_iov,
 			       sizeof(struct iovec) * iter->nr_segs);
 	} else {
+		rw->iov = iovec;
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 }
-- 
2.24.0

