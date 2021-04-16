Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2B7362538
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239695AbhDPQKt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 12:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhDPQKt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 12:10:49 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D9FC06175F
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 09:10:23 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id s16so22930059iog.9
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 09:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p1lf0RytVKxoGVmAArkAb0vVwEytUzibppFcElbnwHE=;
        b=VZE447OkmH7xNqVDEV6cZhvo81I3aISxvBoPW6bHN4qiG6y6DVWIGgZokcvHzN/+Gz
         2dlbjfoBxY/G/Vmi1nfUpRssZVxwhgwZz2/fZcEViDyc0DWmpudXYS9g3VyqG/m5/hZx
         GJoZbBieIiiCQDG81erEc4lgMBueQYHTuxxRw7Q8OfhUEqJ8zesIeftzCJlCkCgdIs9U
         5WBp9gasN44KJ80EnmN5118zW4QE1C8OgKhRgIiyR8o1e43JeMkjJAWBz1hAX2kmd2ko
         bR9ntqCXLU3RndwjC8gMlzggr30txsKzmnY5cSyVt4D8aJKvLBJdFGUNsirg5mOq0OFq
         O/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1lf0RytVKxoGVmAArkAb0vVwEytUzibppFcElbnwHE=;
        b=NSlBUwO9KEjigqtCfFNRgyxnXl7OaRSpnt+30lp1ughQaufO8+G/pCvkk9Dvig6CWS
         TR2SKwm9mzcu27R0XfNg/z6v8y3CivIsbO8maqpuGxAgxkNLSj/upXIQUQU+1k6UJox6
         f7F+GQAtlP2cTbS7h8b0hntA5CZLRKok6Xwu8xWHGDyAZNO90kARh6LCeHhYGVD9gCW0
         UlmivJs47SzQCk/cFZH+/hH00WyEvSV0FXJgLT2cRYasNzVLsOjiOf2Iv+I17UKUzqt3
         98t8WxPNk6QONDufZ0aA3tcwxgwlkwMX5eKy8qAI8YBYWFAtEId5X0x/LUReD/zB69Ej
         NEeA==
X-Gm-Message-State: AOAM531roHw9vJMEPLJ7oqk+dGKXMsixVtZK+VgCo911G14s8+TKb1l4
        ye/h/2DuI9nCEvmyL0FaL/ba1cCTTxkwLg==
X-Google-Smtp-Source: ABdhPJz1zPvKVRPAQIjOUhvkyYTKzf3qVbAzRl1EJt6sQOTvU37EzKWgLi5BQUXPRYfDk+93aPK/vQ==
X-Received: by 2002:a6b:3b08:: with SMTP id i8mr4073367ioa.36.1618589422869;
        Fri, 16 Apr 2021 09:10:22 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f13sm3024641ila.62.2021.04.16.09.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 09:10:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: put flag checking for needing req cleanup in one spot
Date:   Fri, 16 Apr 2021 10:10:17 -0600
Message-Id: <20210416161018.879915-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416161018.879915-1-axboe@kernel.dk>
References: <20210416161018.879915-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have this in two spots right now, which is a bit fragile. In
preparation for moving REQ_F_POLLED cleanup into the same spot, move
the check into a separate helper so we only have it once.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4803e31e9301..8e6dcb69f3e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1598,10 +1598,15 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	}
 }
 
+static inline bool io_req_needs_clean(struct io_kiocb *req)
+{
+	return req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP);
+}
+
 static void io_req_complete_state(struct io_kiocb *req, long res,
 				  unsigned int cflags)
 {
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
+	if (io_req_needs_clean(req))
 		io_clean_op(req);
 	req->result = res;
 	req->compl.cflags = cflags;
@@ -1713,10 +1718,8 @@ static void io_dismantle_req(struct io_kiocb *req)
 
 	if (!(flags & REQ_F_FIXED_FILE))
 		io_put_file(req->file);
-	if (flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
-		     REQ_F_INFLIGHT)) {
+	if (io_req_needs_clean(req) || (req->flags & REQ_F_INFLIGHT)) {
 		io_clean_op(req);
-
 		if (req->flags & REQ_F_INFLIGHT) {
 			struct io_uring_task *tctx = req->task->io_uring;
 
-- 
2.31.1

