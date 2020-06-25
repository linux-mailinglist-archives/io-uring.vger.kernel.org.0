Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDC0209C03
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 11:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390025AbgFYJi7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 05:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390914AbgFYJi5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 05:38:57 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C781C061573;
        Thu, 25 Jun 2020 02:38:53 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o11so5108191wrv.9;
        Thu, 25 Jun 2020 02:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tL+FccFFqTcjb6bX8W92TsCzve7bd5pnKbHcClrHQeo=;
        b=iBLx1e595CFGQ48uN3nqRC6WkwIPgviwk9WfjP1KItpDcz9ZEqi/H8Dc3pOxjeDPTl
         zyEJ3No8KWVhy/sAb52Ei9sQXk1+CCoVcppLYQLJcIT0RtnUj5+gXyl1WLmta7TNYwkr
         Fc6HfIv2k+i6Eb1OGnOCoTupEwMTV5i2tRS+6Xi5R3aBusN4LVI214jadpCPWAt8fBzG
         yfBGGwZ/bvnk/ux8XfJTnAsAxiMySsvRvsP+wF+u92Cf2RG37AGIo7jidwFDlGFIHp3u
         LBMQsmgCrCk3PMCVt2eWRrumU4dmyAjkA7slxXOQZ3Lixc0/Z5YjTOXWP2eXWLvCtNxe
         HEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tL+FccFFqTcjb6bX8W92TsCzve7bd5pnKbHcClrHQeo=;
        b=UbL8FRT1/tizqusklBoLqrnURrD1z/89wnXELqERkt096OqBSnl6rlKkC2flfv6xpd
         jiLZypFV5xUyxqXmPhpW2rfdRnSLXEAJrvPbmljpoehrOPdASoUWd20OFehz44GLaraZ
         L0ZcnWG/0don8J4RBtvZnQRkWRcnKnxgHsgKLQyrUBad0t4Nx6WeLTj15ENZz6xEo9mE
         hkGIi6QzzctoMR/u+xlmAmxVZHVZ2tuUQYQ5qz/RnlfrSUQ7rWtWCZIChvDPqCExH1BO
         x3i37reHE63VJInZiGlFYJRybwv4H3OPx37tR1EFgPK5WevyRpIJ8SF+fCnraepHZ7YD
         0qeg==
X-Gm-Message-State: AOAM53241GaXGOR/MSQhfxdvoGLVIkd8IWzTlSH3zz5UKw+NteBfVaze
        5YuSGanET60VoLCDwRZLuhE=
X-Google-Smtp-Source: ABdhPJwTFNLKPPWpa8fcIIXfh+INu7ov2YZ1nsEDCT5rGZgyNLc1gB+G8ozIFYRz1OD4vji3vJOA/Q==
X-Received: by 2002:adf:e90d:: with SMTP id f13mr6332217wrm.146.1593077932079;
        Thu, 25 Jun 2020 02:38:52 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id v5sm11067282wre.87.2020.06.25.02.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 02:38:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix hanging iopoll in case of -EAGAIN
Date:   Thu, 25 Jun 2020 12:37:10 +0300
Message-Id: <22111b29e298f5f606130fcf4307bda99dbec089.1593077359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593077359.git.asml.silence@gmail.com>
References: <cover.1593077359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_do_iopoll() won't do anything with a request unless
req->iopoll_completed is set. So io_complete_rw_iopoll() has to set
it, otherwise io_do_iopoll() will poll a file again and again even
though the request of interest was completed long time ago.

Also, remove -EAGAIN check from io_issue_sqe() as it races with
the changed lines. The request will take the long way and be
resubmitted from io_iopoll*().

Fixes: bbde017a32b3 ("io_uring: add memory barrier to synchronize
io_kiocb's result and iopoll_completed")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c686061c3762..fb88a537f471 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2104,10 +2104,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	WRITE_ONCE(req->result, res);
 	/* order with io_poll_complete() checking ->result */
-	if (res != -EAGAIN) {
-		smp_wmb();
-		WRITE_ONCE(req->iopoll_completed, 1);
-	}
+	smp_wmb();
+	WRITE_ONCE(req->iopoll_completed, 1);
 }
 
 /*
@@ -5592,9 +5590,6 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file) {
 		const bool in_async = io_wq_current_is_worker();
 
-		if (req->result == -EAGAIN)
-			return -EAGAIN;
-
 		/* workqueue context doesn't hold uring_lock, grab it now */
 		if (in_async)
 			mutex_lock(&ctx->uring_lock);
-- 
2.24.0

