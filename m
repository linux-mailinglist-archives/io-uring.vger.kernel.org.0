Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CFC12D35F
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2019 19:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfL3SZg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Dec 2019 13:25:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43093 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727571AbfL3SZg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Dec 2019 13:25:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so33424578wre.10
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2019 10:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NdKMJR04HFIYXG4fWVw9V/B5syfQZiMOL+WyxbMF7sk=;
        b=lyCpJraccIfre4HhX4QGYKLAbveI5KpndIjgRKKufCz38wtsCPMeycXtq6RrT12SE+
         wJ14ZMOUAdLIENOHwl66WSiZe3aRAl3LB7eUxCxgnfpUkDCsBpb9qhQTNXdMUI226gxW
         gzizk/2/pN9nshRkVqxHLtni0kGeKn2Qnbg/EBYvcucx26g7bjEbh36i+mDInMTaS9Wl
         jTKuJbmrrugmqJ5hP3DjspGNlKIvB8rCsu0LpQHncC9Hu3eMLRxaiO9Z+LGKMKEYuUGK
         dVxbLEoGnC92mMf18cRu5ZJjrFe+vrNjvKLIZnfjz5MmC0xYDDpJZvkx+oGAGnhJ+EVY
         qieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NdKMJR04HFIYXG4fWVw9V/B5syfQZiMOL+WyxbMF7sk=;
        b=N+y1CVp8gLFcAh8mlk4MA2bVJni/cPDaa6vASHpm1HGPfEESdI1QYbav6FWHRQtDtp
         PaKZ21XD34pHV89jzZum6zfx1ErINdBFbF+CVyuZke48F42LVXwIkzZ7jVyLbUfIKFfO
         ahZCUCNI9MlZ2pyBLEy5198XTJb2MSKx0bpDbtqthzNpnnAlIGrPkocSEP5QZucsEgh3
         vWmx9kNaODofJxeF8jXB4ghawPMzSich441mPJyWO6zINbBUqTBDavdrYUm+F4wpJ1SM
         ZCWB1AOulCcshvyHYW/g1zJxOD+j5F7O44o/sdduuSROCde9THFwGRtlal4aAj2goiIg
         Qigg==
X-Gm-Message-State: APjAAAUCtSCZhmuL9krVEIYjnjA4ZY/sNFNKOcvFle+FNC2CotXUQe9g
        Y0Ggj+EcjwiQ9NCOke0ttE9oUXXb
X-Google-Smtp-Source: APXvYqwMwgFiEeyMC4Rza2fNSDMMYI9cv7iTb2kGI+1zI6aKNyS1i0oWsGWPL0mGHwOjYaNQmU25Aw==
X-Received: by 2002:adf:e5cf:: with SMTP id a15mr50880639wrn.140.1577730334674;
        Mon, 30 Dec 2019 10:25:34 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id u24sm231590wml.10.2019.12.30.10.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 10:25:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: optimise commit_sqring() for common case
Date:   Mon, 30 Dec 2019 21:24:46 +0300
Message-Id: <5f61617ff3347304948d46c5257cc52581f527fe.1577729827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1577729827.git.asml.silence@gmail.com>
References: <cover.1577729827.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It should be pretty rare to not submitting anything when there is
something in the ring. No need to keep heuristics for this case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05d07974a5b3..642aca3f2d1f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4506,14 +4506,12 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 
-	if (ctx->cached_sq_head != READ_ONCE(rings->sq.head)) {
-		/*
-		 * Ensure any loads from the SQEs are done at this point,
-		 * since once we write the new head, the application could
-		 * write new data to them.
-		 */
-		smp_store_release(&rings->sq.head, ctx->cached_sq_head);
-	}
+	/*
+	 * Ensure any loads from the SQEs are done at this point,
+	 * since once we write the new head, the application could
+	 * write new data to them.
+	 */
+	smp_store_release(&rings->sq.head, ctx->cached_sq_head);
 }
 
 /*
-- 
2.24.0

