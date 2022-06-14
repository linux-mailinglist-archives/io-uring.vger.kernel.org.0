Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E155754B0B2
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbiFNMeE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244265AbiFNMdm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:42 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62D64B411
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:46 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n185so4556318wmn.4
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CCQsCTUyQprcqQdLzZjdfjxbl316XgfMbO5tlRT3XQ=;
        b=JuD9WnmYUsWoW1ZJczovNjH2Wqh51+TEM+Zmaw0XNnFPByMhEuHzwTcHYdyScbxLlo
         UrP5SwI4WrQzDXuGhjiKJO5bjYdkJwhbvw8jySYoVYTsDBnkoqn3DqCQ/kaMa8WK5HVD
         sDE153HUbQdvwMUo1G8N1QyoY0xw3WpuFzWfscyzBKdMkiDh+9vXA1AAwI3JLQk73xGf
         LjGr09jFyU8ALhUhuzDuVWWxkmTCL1xQkRDVjuJEph5QFw0hROkMSRDWaGuUDkUEF+TE
         yjRQJe3BVEEoc8lG8H+pGSaNstEFuHulQSNKGFABytZmurOMQXb+QGQpO8TP/8osP6fP
         j2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CCQsCTUyQprcqQdLzZjdfjxbl316XgfMbO5tlRT3XQ=;
        b=ZFwxgRx259BHS0g5BL0h+LS4B5+mJtPj5jTzB5OyeZXlq1IAM2G9Q8NclvX1BLvtt1
         8LjsH7eCAtTyxRbd2Nw/MhCRtuWUE6PQAnZxf8zqmXghzxdgZ2jIcYlYHvdRA7hWRhpi
         Hp4FvEOV7x0nDp+8umowXMfozvKOH9zzFrrbRGUlNmHCA2sQtmJmDJBshM3E2NkJGEzf
         mCcQCzyhXied/c8T/SfKigjU/1EidFH3TCnonlvZ3O/Zp1zABYYchw7QqBeJofS0wd4R
         7cW1vFEU7keQ7WXAoTYjHqBjg04rW0uAu0olNrQCgrgk266hbSc1JYT6k7WuQVFHGqT1
         zUmw==
X-Gm-Message-State: AOAM53039LnVGPZQZa6nVnSBbewD50N7RcYSOHsbE1xY6gPSKLN2sj+Y
        Cht3u2pISrZmhdCS6KGP6W0fF//M7zhXgQ==
X-Google-Smtp-Source: ABdhPJyYMaMqjh/UKNWiBJX0HsHj+9YVK9PjmxM3z/0bwuxh6HMjMa09Q6ULhgNThsLE2EaH7agQ3Q==
X-Received: by 2002:a05:600c:1c18:b0:39c:4f19:c37a with SMTP id j24-20020a05600c1c1800b0039c4f19c37amr3937284wms.69.1655209844882;
        Tue, 14 Jun 2022 05:30:44 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 08/25] io_uring: don't set REQ_F_COMPLETE_INLINE in tw
Date:   Tue, 14 Jun 2022 13:29:46 +0100
Message-Id: <ea29d3eb2f3cc135193f02312ba329a171ad3e07.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

io_req_task_complete() enqueues requests for state completion itself, no
need for REQ_F_COMPLETE_INLINE, which is only serve the purpose of not
bloating the kernel.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2efe6bd16e07..8ce8d2516704 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1864,7 +1864,6 @@ inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	if (*locked) {
 		req->cqe.flags |= io_put_kbuf(req, 0);
-		io_req_complete_state(req);
 		io_req_add_compl_list(req);
 	} else {
 		req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
-- 
2.36.1

