Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75ED142F7BB
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241153AbhJOQMS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241141AbhJOQMN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:13 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1000C061570
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:06 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l38-20020a05600c1d2600b0030d80c3667aso2761104wms.5
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9LRRk3P8xJ/zVohAQnorGmXWzslU2pGVYToKYUr0gNs=;
        b=deGwahL41oJFzqTHHogEyxmgv1hYgwIhRmgTQHOyz47U09Tk2cVZGfK2CoKIuJURJN
         q3SC6cVp1zoWJ9H1XmGMb72m0flQlsoVc/eaj9FAsYzSW47pjZsf/921ERN0J52PxHO8
         X0dkG12J0mNglgWK5DcT0gWM/x0SBvvzNl0kx2OZwo8cfjpzml8Bcjc2vw8DS+4y8+2r
         /S1RnVKB9yobBY39Bp16F939MZee5pZPou0Diakzj5mjfnybWaZz9wi3BfEmZ+C6f+zX
         fcX2UwOnzwBjJB3aGsX81PM3hyeagbHwCcm1q/mtyHzV1ZW9op56MEFHSAKAsCJVQod1
         smfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9LRRk3P8xJ/zVohAQnorGmXWzslU2pGVYToKYUr0gNs=;
        b=N4mSqcgD3jdDwyO0G+Mp174kl03u88Xq+8kTAmh4SOm66Xa38El4CoykmVvp8Q0o1h
         MsltVYSP3z9IkHsdbxBEqCwDDKsRy4cpe9TRvW4J0xjmkxwulqk5saX2IRlvE5ZyKwSL
         uXimqethHY0dDwBoYfTl4ljC6VIO4VE7KZdEVnlmVTc/8oKNM6NXdeZAgttY9+06W0nx
         QMq9LyRtnLc8J7nHfAnZ+kGJVj6xTXlrpaecxwS0hMYAi4meR3wOwnUvXSh5p42TWUX8
         HzWY+eZ02kFCZHuKR4gdBOpZmlZH2wvPt4pvTDIkd3E74/J2QMPEJtjA4PsznbUl/z3/
         krSA==
X-Gm-Message-State: AOAM533ThU/vZtNlx8sldT86qB4F4JqY9bPbKhzMZrzHrWcwJRF6gff7
        YDzuqSFsoeWwJhastzeA4+SjS7gQpfE=
X-Google-Smtp-Source: ABdhPJwr0COP61QPFLf1pZHY1eZ8fht4oVWbtwm1sitNiR/NsSAYheaodVCvbEh+NiyHhqwCU9kSTA==
X-Received: by 2002:a05:600c:2041:: with SMTP id p1mr13367640wmg.145.1634314205099;
        Fri, 15 Oct 2021 09:10:05 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/8] io_uring: optimise req->ctx reloads
Date:   Fri, 15 Oct 2021 17:09:11 +0100
Message-Id: <1e45ff671c44be0eb904f2e448a211734893fa0b.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't load req->ctx in advance, it takes an extra register and the field
stays valid even after opcode handlers. It also optimises out req->ctx
load in io_iopoll_req_issued() once it's inlined.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9796002ff9d..c1a00535e130 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6591,7 +6591,6 @@ static void io_clean_op(struct io_kiocb *req)
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	const struct cred *creds = NULL;
 	int ret;
 
@@ -6718,7 +6717,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret)
 		return ret;
 	/* If the op doesn't have a file, we're not polling for it */
-	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && req->file)
 		io_iopoll_req_issued(req);
 
 	return 0;
-- 
2.33.0

