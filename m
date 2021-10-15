Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E31942F7BF
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbhJOQMV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241151AbhJOQMS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:18 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AFDC061768
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:10 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e3so27129880wrc.11
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N0+SAdaJJw6z7CHZxNHDnL4TkGKNw0IKKn/SnL6jyxk=;
        b=Bz9vzk4t7O1AKHp92jglU/+eNX8tRHcWiSIBPCiIKXv/Zrv3vyUKITXvxz+tPxKbVk
         baKcOFvp7OB75DjuHXKHpEgt28f2+lhCEtHDGCjFKQdBATr6TNR4dho5xUWZoCG+8OIU
         tdEHfzEcX45txTX8ke+Dw3R48gI0ti2mRtgR4mPzS/+PfZaPeuVvYG6vStPIGDq00sGm
         Jy7os2mbQClEL32IAirR/sg2obxzIWIRQCnyoej0lJkwysl748piCHBvcKaW14rywpSD
         vRSynXt9GMtQ41SSLekgiCFAAKRFA98koBpTtBTicQ7pf8lUi3FlXLJ01SeaaBNe4OSm
         nAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N0+SAdaJJw6z7CHZxNHDnL4TkGKNw0IKKn/SnL6jyxk=;
        b=S+qnPlr6bVExkYZMHEa4FaapMZpRfTde+8gXU2UBB1PkhcId7Vj8ANpLuhRNXnSFKG
         7E2jCqgT7vBBExkY13Dpyn6dWQYWpzC+1xtsuEX6riT9AQPFDZMJWP8Avmsvl0vzHvPL
         pMSGgX9C7CkYIZ75GW0w4tRc2N6BuhdQTjN2MKSV5hcA2EaEezzWlWzZw1AOtIz1OlpO
         Mu2OUrbwnY0wquH/UFQRR8XIqXufEWULVUZh9xIsWWdSijaWis6Pkv5gqEVsQuDz55Bv
         +QQ6J0Ec3ZwcbfLfiNhRZuix3HVnJ23Dfm3LUeOsqzQobISh31DOWI++SvALabwhEUhQ
         BNJA==
X-Gm-Message-State: AOAM5306X3cWx+B7RU+l9QyBQ2v0PCoQ5aoXTdHVWQSECwPO6jdzTYzO
        RbANYJEMsJWGp0IwLi/63r30yxoXPgk=
X-Google-Smtp-Source: ABdhPJwDz9b8+LlHAAiJNcXEzit0Mk79Fr7RKMGxIl2pec8J806QmD7/nGmKb0XR8iXjEhiuC06qJQ==
X-Received: by 2002:adf:a413:: with SMTP id d19mr15765805wra.246.1634314209336;
        Fri, 15 Oct 2021 09:10:09 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/8] io_uring: clean io_prep_rw()
Date:   Fri, 15 Oct 2021 17:09:16 +0100
Message-Id: <2f5889fc7ab670daefd5ccaedd99416d8355f0ad.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already store req->file in a variable in io_prep_rw(), just use it
instead of a couple of left references to kicob->ki_filp.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 64ef04c9628d..ce9a1b89da3f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2835,8 +2835,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		req->flags |= REQ_F_CUR_POS;
 		kiocb->ki_pos = file->f_pos;
 	}
-	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
-	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
+	kiocb->ki_hint = ki_hint_validate(file_write_hint(file));
+	kiocb->ki_flags = iocb_flags(file);
 	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
 	if (unlikely(ret))
 		return ret;
@@ -2861,8 +2861,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_ioprio = get_current_ioprio();
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!(kiocb->ki_flags & IOCB_DIRECT) ||
-		    !kiocb->ki_filp->f_op->iopoll)
+		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
 			return -EOPNOTSUPP;
 
 		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
-- 
2.33.0

