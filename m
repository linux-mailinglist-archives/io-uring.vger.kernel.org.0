Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA63438347
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhJWLQb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhJWLQa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:30 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D4C061764
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:11 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 193-20020a1c01ca000000b00327775075f7so6774046wmb.5
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nDtQGtWfh+iw8zr1xrNsc4d73v0eXvetRj6DBf9xLro=;
        b=JlqTwWiZMWfZkJaZT0ul3aFIXggVk6zzRyPToqSOp71KRfoQrJmkT49D/ZX/298dgh
         hrw6jdGEHjPmihgSOJYkhpDq+gBlIpj8N8JHsQbQvj1/+mqD9rnCRuSDcdC0R4Sd7+/d
         vtIbVhmDyep+ogke27S00JgLUpHXGvqr0Jj0nb47RdXsM0W0B+vhLomcCcbUwXHb+eEy
         //f8DvVdxHkvJ70PeNON9qYWFHSKSfyOwMe0HN1bepfsDIk5SlEfboR48BzpnKhfiw6G
         4VVkuj/37zwJrXewmwSIx1QE+t5pb7UXUUlsFOyzccKLQl+uGch8Ne2YpWWf61OvwQp0
         pNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nDtQGtWfh+iw8zr1xrNsc4d73v0eXvetRj6DBf9xLro=;
        b=FUgkbrjmZlA9l2mHcYtD7RO3O+rRG2OyqAHIuB1i0J6r/1xNSUOTMVzXs6HKqGvFrN
         OLodZi1SxC2BVO7fxY7OzWo42GxVR4MxUvk9Ey+uAWQoNiZoDfKB7B4Ji5JQ0KimGSN4
         et0pRyTSPfNI41DuX+IVcusv+hDlfOnGpNcMxB8P2aytHunIhGqli8rrHDXx/wcrfhKt
         GqrQtmA1W7RCv8u5FVE6omxCnFFpBZKraJS7Zlhv7ePAIf0Yn49Plu+k3l6UvKsRH0no
         Q9hgyDUC930ZXk8MY3WwSHhXtY4QLcpBmSGA9sp4VQekauPZtQgStDTZpiE+gWXfWCts
         4fVQ==
X-Gm-Message-State: AOAM533nYrldYI+AjmaIFiSvg6bCSSdvjEvAI3+oHsdrJ8YkBItgr/YJ
        NioQYsKq+P51/0M783d3X+11g5UkleM=
X-Google-Smtp-Source: ABdhPJww66tv+R7QpmDChaN5eqyLjumO1sPRaLJCTRo9EJHvmhlnzFISYFz64BxQxw/ye55sERh0rw==
X-Received: by 2002:a05:600c:4f42:: with SMTP id m2mr35230969wmq.82.1634987650324;
        Sat, 23 Oct 2021 04:14:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/8] io_uring: clean io_wq_submit_work()'s main loop
Date:   Sat, 23 Oct 2021 12:13:56 +0100
Message-Id: <ed12ce0c64e051f9a6b8a37a24f8ea554d299c29.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do a bit of cleaning for the main loop of io_wq_submit_work(). Get rid
of switch, just replace it with a single if as we're retrying in both
other cases. Kill issue_sqe label, Get rid of needs_poll nesting and
disambiguate a bit the comment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 736d456e7913..7f92523c1282 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6749,40 +6749,24 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		}
 
 		do {
-issue_sqe:
 			ret = io_issue_sqe(req, issue_flags);
+			if (ret != -EAGAIN)
+				break;
 			/*
-			 * We can get EAGAIN for polled IO even though we're
+			 * We can get EAGAIN for iopolled IO even though we're
 			 * forcing a sync submission from here, since we can't
 			 * wait for request slots on the block side.
 			 */
-			if (ret != -EAGAIN)
-				break;
-			if (needs_poll) {
-				bool armed = false;
-
-				ret = 0;
-				needs_poll = false;
-				issue_flags &= ~IO_URING_F_NONBLOCK;
-
-				switch (io_arm_poll_handler(req)) {
-				case IO_APOLL_READY:
-					goto issue_sqe;
-				case IO_APOLL_ABORTED:
-					/*
-					 * somehow we failed to arm the poll infra,
-					 * fallback it to a normal async worker try.
-					 */
-					break;
-				case IO_APOLL_OK:
-					armed = true;
-					break;
-				}
-
-				if (armed)
-					break;
+			if (!needs_poll) {
+				cond_resched();
+				continue;
 			}
-			cond_resched();
+
+			if (io_arm_poll_handler(req) == IO_APOLL_OK)
+				return;
+			/* aborted or ready, in either case retry blocking */
+			needs_poll = false;
+			issue_flags &= ~IO_URING_F_NONBLOCK;
 		} while (1);
 	}
 
-- 
2.33.1

