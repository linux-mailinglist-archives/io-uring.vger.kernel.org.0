Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742F12FBA89
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391639AbhASOyq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394334AbhASNhP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:37:15 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6911FC061575
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:34 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d13so19718989wrc.13
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kmSr8vLdDCfJBmwTzc0q2+OiG+xkTEsTnRhNlFR8m7k=;
        b=sh26S7CwjdmEALgTj2OsEs7NCkgoJUC4wJI4MjLFjTWbHN9m2dMCw9EJJcZml5+9MK
         mNgzkObrlj3GulgU5AXzXSBwtDN0uqa5Wa20HwmKGPlJph/i35EPZVtMV7/xdSUtXzFu
         T4v/Pyy6xf67tlnY9yc2lYxLd5hLij/OgEr7nvSPZIgYvYMAbkiwguHJ20Lq/A6x1y2d
         LEm4oDpv5ZPVfWbVAJSbjMuT7G3f4yxfruwSclgkxkGGim5WW/u3fiFkIxsCSlXcuBF7
         uiim2O7Ue1CLWeDI4PgAjWra89h9efLUCLMyyKJ7CMQ3uSV+N3Ssa5w5++Lc2MHg/Z/U
         Cs8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmSr8vLdDCfJBmwTzc0q2+OiG+xkTEsTnRhNlFR8m7k=;
        b=WLaguRcwrHj5UxMdxiD7erqagEORkdoTUc71Ari4e003v6LwX3mqjrPx+BnxAkdBPk
         fzgPYq15jWtAyUYFk85XxLlgkk2k7K3dQc5HrADQZXdHVvPAQHUm9IB5yUJBdKtKZJbk
         mFgJbM6NGaqs/kVWzftyd0wmqkc0udFyPRKSqCDyNL1Fo6SuD++kdP/zJidnZwNHEJfY
         J2AgoVG9kFNZjPAbpTdNK2QFewzZOF6rj5+qAMPb3mTJWZiJ/+U4MQV6vI0UDz7h7hSO
         MH3z5zJY0fLXm0mQbNcqMDfSe69rykJ+ANB9lxsM5kstbwVLU5GQDwHMUVRyC3fPzhFY
         HUbg==
X-Gm-Message-State: AOAM531DfYUiV7iRvXAdpbLcxyv2gj2kYohj4tzEoisvtXKjPv54xqfZ
        fvEz9k44HWXwhKPgDXmCQNU=
X-Google-Smtp-Source: ABdhPJwLLt0hCCLvJkr0F9uiIu2hwRAKYsnq1u3gZEKrR1B8dJNduUsLL3LD1BfOFhGq5gPtEwVylw==
X-Received: by 2002:adf:f5c5:: with SMTP id k5mr4605336wrp.286.1611063393044;
        Tue, 19 Jan 2021 05:36:33 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/14] io_uring: optimise io_rw_reissue()
Date:   Tue, 19 Jan 2021 13:32:34 +0000
Message-Id: <c0da843b0707e793e6a8a9ffc52e8d7eb8a2d37f.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The hot path is IO completing on the first try. Reshuffle io_rw_reissue() so
it's checked first.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4bcabc51fc5a..7f4bc5092b5c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2713,12 +2713,13 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 static bool io_rw_reissue(struct io_kiocb *req, long res)
 {
 #ifdef CONFIG_BLOCK
-	umode_t mode = file_inode(req->file)->i_mode;
+	umode_t mode;
 	int ret;
 
-	if (!S_ISBLK(mode) && !S_ISREG(mode))
+	if (res != -EAGAIN && res != -EOPNOTSUPP)
 		return false;
-	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
+	mode = file_inode(req->file)->i_mode;
+	if ((!S_ISBLK(mode) && !S_ISREG(mode)) || io_wq_current_is_worker())
 		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
-- 
2.24.0

