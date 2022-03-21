Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4E44E331C
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 23:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiCUWyZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 18:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiCUWyT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 18:54:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C99F37DE58
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:39:03 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id p15so32741604ejc.7
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bX1FvDVDBa1U+UgruMZsksVt4HHzDKIVaybOHiGsOfc=;
        b=OAd5oPclPWs1MN07rd2BeEt700mTmcDQ5+fgBRrY8y3gosohtbWLvm8PfFxCZn7vry
         JWk7Qt7PIDRE0hb29yzT9GQbnpwkrrp/57AknmKukgEnwcFkOsPdZcOEvM0QpxJ1KXoS
         DBh2uJSQ/jrDg/sDFX0VTUhw0/tPJ4J9m01deYFd+ULRd+nckzK2pAwxCEOP2GK8Slpt
         eYldwB9b6OqMR8P3mgRzeDlqqV9lGnsT/T+jXM7By9WzAWHZmrrWACzXoidWHjQCXCPC
         LYlvVc1BSPwyN6PhCaeykA8lHKn0kti58JY7765b3TJByzxCdMU+lmA0UCUDzNkQ/buJ
         upDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bX1FvDVDBa1U+UgruMZsksVt4HHzDKIVaybOHiGsOfc=;
        b=ACbKTtac9OfkhyBenU7Jl6EH2v8Lw1LJ9qDhEHZFA4B7+z67xKBarm2IONBPKdt7Y5
         q+BL0UK4AqFZ6ePQp3MWvdjnPxvE4o6ukddH0HZO4yI5y9aufCMv87Bc3AyjE/ecQT+R
         mnFehaEKF2el+oGYApehmt6ThTmv7GQV8Wgmqeku1cc+MvqJuq3UXMtVrs4BOaC2VRsF
         PhWYKEwW1bX/LAP1T+3dsSFmrWwW5nQfFomoEQJsm8QncvDVQpgCJJYL0WN0Vhf7ELrh
         DLLCrG1l4BrBO8HvYTb+AP7p8GkJdkB06ei4WXszXNkTEG+ubmc5iHDhysc0UvicEEFZ
         Fhsw==
X-Gm-Message-State: AOAM531n7YIOUfk90MwLsJirJ0x8jjJ2d6QKQaHwN8qwpaxcdYWKpMhb
        tJHQ3FOi2TC8eZAiaUt8AuRjfTzXQU+QIg==
X-Google-Smtp-Source: ABdhPJy3jzocC4znGvoX68R1pUj//9lmtAbwO02cFfuI2qv45HKjnEbC85Fdm1gYJEvXOqjpCSvu0A==
X-Received: by 2002:a17:906:6a02:b0:6d7:cda:2cf7 with SMTP id qw2-20020a1709066a0200b006d70cda2cf7mr22039313ejc.53.1647900239020;
        Mon, 21 Mar 2022 15:03:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id qb10-20020a1709077e8a00b006dfedd50ce3sm2779658ejc.143.2022.03.21.15.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:03:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/6] io_uring: refactor io_req_find_next
Date:   Mon, 21 Mar 2022 22:02:21 +0000
Message-Id: <10bd0e564472dde0c7f8d90ae317d05356cd565a.1647897811.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647897811.git.asml.silence@gmail.com>
References: <cover.1647897811.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the fast path from io_req_find_next() into callers. It prepares us
for further changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 71f3bea34e66..4539461ee7b3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2391,8 +2391,6 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt;
 
-	if (likely(!(req->flags & (REQ_F_LINK|REQ_F_HARDLINK))))
-		return NULL;
 	/*
 	 * If LINK is set, we have dependent requests in this chain. If we
 	 * didn't fail this request, queue the first one up, moving any other
@@ -2613,10 +2611,12 @@ static void io_req_task_queue_reissue(struct io_kiocb *req)
 
 static inline void io_queue_next(struct io_kiocb *req)
 {
-	struct io_kiocb *nxt = io_req_find_next(req);
+	if (unlikely(req->flags & (REQ_F_LINK|REQ_F_HARDLINK))) {
+		struct io_kiocb *nxt = io_req_find_next(req);
 
-	if (nxt)
-		io_req_task_queue(nxt);
+		if (nxt)
+			io_req_task_queue(nxt);
+	}
 }
 
 static void io_free_req(struct io_kiocb *req)
@@ -2710,7 +2710,8 @@ static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 	struct io_kiocb *nxt = NULL;
 
 	if (req_ref_put_and_test(req)) {
-		nxt = io_req_find_next(req);
+		if (unlikely(req->flags & (REQ_F_LINK|REQ_F_HARDLINK)))
+			nxt = io_req_find_next(req);
 		__io_free_req(req);
 	}
 	return nxt;
-- 
2.35.1

