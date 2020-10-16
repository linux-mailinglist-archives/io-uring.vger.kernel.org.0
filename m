Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBA5290917
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410533AbgJPQCi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410466AbgJPQCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFAAC0613D3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h4so1773553pjk.0
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kD3LFOV0aWodyJxHZ2ZGxlgwSC2ygFvIkyQtGWPV4Dc=;
        b=ttHAy607hxlhNjJ9hb0q0FNRy6A2+DjM1GTQYoCc+HClVjb2RmLp0Mr3Ru3DS3B1Fy
         5RpFxoerNyXamHYR4Y0b2X7A1RVIpzmvRTWDP6u2nlvZUR64BAoIWKWXjBwmjMkxFwPk
         Gl283L3q1DzH7iydh/YtZzzTkZNOgVHLFXDVBbcG8uD2/djEdCB+b/62D1N3163NXqc6
         XXxyTGQ1hq0p0S5UKkci/W9ue2IceMHkGSeBtT3LsYlcydpnVSwSNiI1SC2o+h/LWaX3
         Dd6AH3LOvnyudqPQH6nQ4gT39kNDympjf3DY0Ty8W7uMsQ4ZFxQuwavJNm2svCuXleNA
         riXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kD3LFOV0aWodyJxHZ2ZGxlgwSC2ygFvIkyQtGWPV4Dc=;
        b=I1WgeTlZMnJzF2EisQZw8lADS3B8e8J8hONVGKzgHV6xjm5wIIJkVyDalEaajT1AoF
         ULG9dvxSUt/lmOZMGb6CWtjQIqGmmnEaMtLJ0klYxpgI5WNmfgufC4DWGrX8TOcN4EmO
         RiLJ7sEk0fGsebZtoxW0LfbK110CIiQh7p6YQYUyzJHhyOCqNl4jvu15/AlB7nS4lTo9
         zMEVPCiIbRzshtrc4sJgw7Ce0rJ6VXZfvwRkOiUnoawxYxA4GNShj6WgA0SlO07tJV3L
         ETB8D5sjfSlBAMvF3iPNTJuVp8nOUOYWwgd5IJKSn0ARGQ6VGGDljSe85Sss/LYlL2go
         Wfeg==
X-Gm-Message-State: AOAM530CstSiZXpWpCBPivnCtd+fCGQwfsR5+5p1o4ruG7kA+Nw8aGIy
        uMdwEkaV3YkNSDjfSY2c1SLJSIVgVKRQI/hh
X-Google-Smtp-Source: ABdhPJyiFe1gwJljXJzujFbF254Of3Bp0WlUpRu8IXmChukMhoLXYPiVlduHLcWtXpo7YPX2bMbZ6Q==
X-Received: by 2002:a17:902:8bc4:b029:d2:8cec:1fae with SMTP id r4-20020a1709028bc4b02900d28cec1faemr4916848plo.23.1602864156242;
        Fri, 16 Oct 2020 09:02:36 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/18] io_uring: don't put a poll req under spinlock
Date:   Fri, 16 Oct 2020 10:02:12 -0600
Message-Id: <20201016160224.1575329-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Move io_put_req() in io_poll_task_handler() from under spinlock. This
eliminates the need to use REQ_F_COMP_LOCKED, at the expense of
potentially having to grab the lock again. That's still a better trade
off than relying on the locked flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 60b58aa44e60..728df7c6324c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4843,10 +4843,9 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
-	req->flags |= REQ_F_COMP_LOCKED;
-	*nxt = io_put_req_find_next(req);
 	spin_unlock_irq(&ctx->completion_lock);
 
+	*nxt = io_put_req_find_next(req);
 	io_cqring_ev_posted(ctx);
 }
 
-- 
2.28.0

