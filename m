Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63391D6792
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgEQLDk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgEQLDj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:03:39 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADB4C061A0C;
        Sun, 17 May 2020 04:03:39 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id h188so5497412lfd.7;
        Sun, 17 May 2020 04:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tf6aUm2aDuFG+hLIypQmHMnKFy/TkQcplzpKMuoB/JQ=;
        b=oQygXhr8IrST0MPEj1CqVNvPH7lRqdPQFgKc+eH+g2xHhN8uXtZQSs5OFm89yandoQ
         VqXWtw5TH4Je366HsJlfE+JBFERSGSLGhwv+6MRKrzdzwSDo/3iWOvHTItnIQrLAkIts
         TTEvrikDQ/m71LV6Brvw4N/q1WXwIGq22+nDFCxfQxnOmWfhWMFMLt+sujt0zn8mYqyi
         R3UCrAjy9zFMa/ssLSEgGBbHoPYwnJdgf+4jgQZeV698HkGn4qnKmjRty6msMJSAs8bI
         PpJC5BqG7L1IClPUt7ecL91N2piVt5i08sV3SORn83D392M3toPoUL4580ih3Lr8um/N
         Ycfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tf6aUm2aDuFG+hLIypQmHMnKFy/TkQcplzpKMuoB/JQ=;
        b=s/NM1SpqSdouan/JGabv1eSUxLtwSQkPtis0ecGvMzwZxMdns4y2yIfBz8XX21TRFz
         6KwluV6CvZh1mBfnXuVw/Me/hX++LlMzxmy3381N9isz3zOtoisVgwbAoqhkltokr4bE
         B2gahglh1E9qtLbP42oLRvxIRIDRV+vBdh0HM/7JTGhzfo8piclMGHYcnGLRIw0pvysk
         GeMKRfEx8QK2I+zYG+8cicspaOiwHElaFB77w7aA9q4LgSE26Dh0Ok31CpRLV9ubaaDu
         wDb15td/B5CUpy1Kt7KlR3suLZG4XXn4GcaPG+nGaCxXhxdnUFEJ69rMHyjuEePVCKtD
         mMlA==
X-Gm-Message-State: AOAM530NcoKzXx2A2qSieJl95/+B/Hw9hcuK5kKkumC2ofU2BkuohlUc
        iVKAigXRwqBPsYKwXraud/Y=
X-Google-Smtp-Source: ABdhPJxPaqzKSuXHOYyYbsoD4bVTxzPxeE8UoiCEpFMxqQXyWs3VRgzZSVNyKziTYbC2AWHvsviivQ==
X-Received: by 2002:ac2:4304:: with SMTP id l4mr8130303lfh.87.1589713417528;
        Sun, 17 May 2020 04:03:37 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w25sm1080333lfn.42.2020.05.17.04.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:03:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix FORCE_ASYNC req preparation
Date:   Sun, 17 May 2020 14:02:12 +0300
Message-Id: <04738fd6d68c70df097d78539856e66986831e7f.1589712727.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589712727.git.asml.silence@gmail.com>
References: <cover.1589712727.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As for other not inlined requests, alloc req->io for FORCE_ASYNC reqs,
so they can be prepared properly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9e81781d7632..3d0a08560689 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5692,9 +5692,15 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			io_double_put_req(req);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
-		ret = io_req_defer_prep(req, sqe);
-		if (unlikely(ret < 0))
-			goto fail_req;
+		if (!req->io) {
+			ret = -EAGAIN;
+			if (io_alloc_async_ctx(req))
+				goto fail_req;
+			ret = io_req_defer_prep(req, sqe);
+			if (unlikely(ret < 0))
+				goto fail_req;
+		}
+
 		/*
 		 * Never try inline submit of IOSQE_ASYNC is set, go straight
 		 * to async execution.
-- 
2.24.0

