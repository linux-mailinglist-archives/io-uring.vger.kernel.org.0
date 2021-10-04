Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3524216F8
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbhJDTFw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238863AbhJDTFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F5FC061749
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:04:01 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id p13so40764187edw.0
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z2dHhYKcMYPY1aqNaAoLEuHKm30hk+kDrKLaV4/b+fg=;
        b=SeflHGFC4osP9GCi96pYmU9ySVOQdUwuhxBAdOQMTlFwVn9BNnMNbVMdglzgyMyC0q
         DGhBF+SsUjOpqnyGBmcx3075NneDydK5mhX71MLh6+KfxuuDiNSh/qgh+3muBwi30x6C
         E6XtcS+W/YqvG6vhtOCV7+6mOuLjao8fE1ID9mjhjh3092hZUpgv9qIwKpyID3/4MZzS
         061a8jUB6rNuzYPcnhp7jAbi9KrdA9NzJ+20k5PmJEQcJ7PMzEnP/FGB3+v5nvp+plpA
         gshanjlBSq29LnJpKoWaOs2xcl2Te7D28jntu+YzGhOpAsespyL07YPP/mRTPwQ+F3mX
         uAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2dHhYKcMYPY1aqNaAoLEuHKm30hk+kDrKLaV4/b+fg=;
        b=TsjrEfmJMU23qXLFBxeFqIbWuPPMl01Us/K4yX2B32EfVR/tA7bz5pReIrnG1+uOMt
         3N0czqZM+g0TJsuuhx/o1RFXR62+qJstgxwE3vkMsEsAVv/PevXpAJQQm39b3bwl5PRj
         8r+nyy+L4DohYW0araewrYPBF1K21e51o+l7DUcpzckqnhYucymWl4HfArQDS8Q7rBrD
         m7OM3r08NDXLrAO+ebS32asENrsB/wKZ1vUyCzDR05DQUV22e0REOq0y1Sc8Zx1DDGpd
         z44aipNhPWTwfPmvlEcEDstceSr9Ceq6HYFa/1JIuvgXSYC5/seysrzSQqm3p2KyI7Wn
         TUhg==
X-Gm-Message-State: AOAM532u5gDRtpEpi2q1tc6TiyCXrnUNO/g2vGD1ijVIhuOy63ar3aDQ
        7rG+yGOyv4qQrgwEz2gXSayDUV22/vE=
X-Google-Smtp-Source: ABdhPJz7xrFbRtM2nZUCyGoaWOvLWtZP3dRoKdGA60fbr+denOAAIvUfRi1HHo+eKLUKWyMYYOyo+A==
X-Received: by 2002:a17:906:b884:: with SMTP id hb4mr18476601ejb.376.1633374239598;
        Mon, 04 Oct 2021 12:03:59 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 13/16] io_uring: inline io_req_needs_clean()
Date:   Mon,  4 Oct 2021 20:02:58 +0100
Message-Id: <6111d0221ef4b439cad401e135dd6a5f990a0501.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is only a single user of io_req_needs_clean() inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f12ac5ec906..1ffa811eb76a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1816,11 +1816,6 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	io_cqring_ev_posted(ctx);
 }
 
-static inline bool io_req_needs_clean(struct io_kiocb *req)
-{
-	return req->flags & IO_REQ_CLEAN_FLAGS;
-}
-
 static inline void io_req_complete_state(struct io_kiocb *req, long res,
 					 unsigned int cflags)
 {
@@ -1963,7 +1958,7 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 {
 	unsigned int flags = req->flags;
 
-	if (unlikely(io_req_needs_clean(req)))
+	if (unlikely(flags & IO_REQ_CLEAN_FLAGS))
 		io_clean_op(req);
 	if (!(flags & REQ_F_FIXED_FILE))
 		io_put_file(req->file);
-- 
2.33.0

