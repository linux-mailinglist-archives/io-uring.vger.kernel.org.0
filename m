Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752363499F1
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCYTFa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCYTFH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:05:07 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA7EC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:05:07 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x7so3358176wrw.10
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=smBRFTmzeUQhHTORW5iWTs1GKNI56+IdAETNxO3GMOA=;
        b=fzqj5r4nE0t5mpOYLMB9ZXjmeLNVqc+0XXICZKlkzOqXU1EH2v5mRpz+4BMV8SediX
         2ied2gCFR3FhOiEH5NaJVCw76xoy0jP4DdSJtmzC6cDMsQQQ5atWo9JoR1iNFEwuAAxP
         mkg5d2wQ1oIiEzuquSOeJ6hVPr/iDUj5ncLVcr3RwaqqGoNyRPUJ3P5oB8uv7JKrQm29
         yiBxvSLNSRyfrTHc+J2+uEC3ET4svUl4eZFY8i9mDcPgfERE0YVdY8ck4UhFgh+jvInl
         uvE0zB9nM60a2rB0kdMG3w7j7DJgPveSlTJpc5GzDvAl5a/z8QygeiKxHo3zXPKDjPFQ
         9T+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=smBRFTmzeUQhHTORW5iWTs1GKNI56+IdAETNxO3GMOA=;
        b=ETNPjmR3fo8ChjuICvPDkf46fkizbJ0tuP0ewfzgJwanOdC0s1tpwUOwGuIMuW/if8
         J+n43YIvAGU1uYPhMH3DqskDLyV4SdJNEWpWtuD1uV3A471DNjy+8eOQWKGaebLEzhft
         8aelbfFYARBkl5fFCDnGUaUXZyz3LUUH1hwgZEuu7D3ZW6JPsYZ1bPrEv/a2jmuKZdAm
         I6S7g32lzhp/DHFCWTjxz+vxizQgUFPWKsx0aAhvFXw+0rE77Js8G2WKqWZkD5CHuTce
         faxJuUmJVHXEbII9Rhfh3dwCgf0wlBzS0hRwlydKuEmzddx2viEK7+rBMAA9XheY3dbv
         A+Mg==
X-Gm-Message-State: AOAM532HYXGsti0n0slBMu6xhVKCfvoG/xoWixCP9zETDKHpmuTDB4LE
        GoJ7vj3O9bheIoExpjXNgaA=
X-Google-Smtp-Source: ABdhPJw6SMSlEhyko76X/ea8y1agCYX+8Vm9XWewQj1ZkOrqVFWx333ccVlTJ0XexIjZn9op23pB2A==
X-Received: by 2002:a5d:6103:: with SMTP id v3mr10347010wrt.375.1616699105963;
        Thu, 25 Mar 2021 12:05:05 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id l6sm8337925wrn.3.2021.03.25.12.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 12:05:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: maintain CQE order of a failed link
Date:   Thu, 25 Mar 2021 19:00:58 +0000
Message-Id: <36aefcc157acd204e895e8d063f78f0c53a4ecd0.1616698825.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Arguably we want CQEs of linked requests be in a strict order of
submission as it always was. Fix it.

Fixes: de59bc104c24f ("io_uring: fail links more in io_submit_sqe()")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8df982017fa..947c9524c53a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6459,8 +6459,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
 fail_req:
-		io_put_req(req);
-		io_req_complete(req, ret);
 		if (link->head) {
 			/* fail even hard links since we don't submit */
 			link->head->flags |= REQ_F_FAIL_LINK;
@@ -6468,6 +6466,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			io_req_complete(link->head, -ECANCELED);
 			link->head = NULL;
 		}
+		io_put_req(req);
+		io_req_complete(req, ret);
 		return ret;
 	}
 	ret = io_req_prep(req, sqe);
-- 
2.24.0

