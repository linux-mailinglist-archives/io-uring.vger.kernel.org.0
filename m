Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0A1121EE9
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 00:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfLPXW7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 18:22:59 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34684 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfLPXWv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 18:22:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so9325991wrr.1;
        Mon, 16 Dec 2019 15:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bJT8BZMKY+4LtUFBwM7+89YKrqMnh5a1Z/Gu4jEAI0w=;
        b=Rv5G5GYcS5ClPxGsvrbSSVtdkuVaItVEwva6m3jblFyfvGzzzfu5zXIzth8JkVPiPn
         2mZS8n+WTgP/pXErx7QA/J1VkMGm5p7IVt0uSTnJrnqxk7JmiaIuPQVe+JUONzcIgTyJ
         DhGU8nMsHWszmffPHp32X7p0TP4INjtZGQXSoIDrMQkON7A9UlcIhowUEq44ZyRbBx5T
         dUugavmxIPEzDh73Wq0TCDR39CRusjufqh90O735U5d5W5evXUVRmOrflNFccKS6wd8O
         E8eRomxQc4u3MLJqfWcQW6ZokLWBLO+q0q+tVA4tHkSj2wr6xN4+ZNgoI2v0bjY3Xtl0
         5Xsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJT8BZMKY+4LtUFBwM7+89YKrqMnh5a1Z/Gu4jEAI0w=;
        b=X80NiQIkeOn3kd6UUNS96gPbEgbgL5KSWSS/Hei8Jlh+SDjNLJiE/ZWmS/KJdZjnhB
         IxddE6S1r8GJyuqQc7sXk6Z7aQHKf+wQLFSWr8zMmMHoWdDzMT3OgtLcABsnOKry+B8s
         mTn0gW1hqWONpA2+wUFCFl+q4Xrg8mKd/hpMdMNMPioN0nE9rdS0HekC28aI9z2XiJ0o
         t31Ors2dgpHJwkYyC7OLt5rH4IDqkxqJqg1UCjLnhq/aJ02mR7z7n9lrk4OKLq2EUL5C
         B5mNTRGAfp/o0gM4imdPSYcVfcpDL33dI30J89f1zV55cdr7ndeh+0xImFRH1A/RWMVe
         Z6Vg==
X-Gm-Message-State: APjAAAW97xN2V4+v/F4HdmzaoPDsodThueDSkCw69Fv59MbzrUIt0G3q
        HOBQ+volNuiQRqEC6IKvjgdafZW3
X-Google-Smtp-Source: APXvYqyLWRL0gw9awHOfybwPmP0J/udGpHUNnzBbgnyNZmViLSkgRKuPJB/KhlYMy7hVSutAov0olA==
X-Received: by 2002:adf:806e:: with SMTP id 101mr34571130wrk.300.1576538569698;
        Mon, 16 Dec 2019 15:22:49 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id 5sm23526167wrh.5.2019.12.16.15.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 15:22:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io_uring: move trace_submit_sqe into submit_sqe
Date:   Tue, 17 Dec 2019 02:22:08 +0300
Message-Id: <df3d579a80a4afc2a08fff2e238626e5a76bfdd3.1576538176.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576538176.git.asml.silence@gmail.com>
References: <cover.1576538176.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For better locality, call trace_io_uring_submit_sqe() from submit_sqe()
rather than io_submit_sqes(). No functional change.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 96ddfc52cb0f..bac9e711e38d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3375,7 +3375,8 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	req->user_data = req->sqe->user_data;
+	req->user_data = READ_ONCE(req->sqe->user_data);
+	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async);
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
@@ -3569,8 +3570,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->has_user = *mm != NULL;
 		req->in_async = async;
 		req->needs_fixed_file = async;
-		trace_io_uring_submit_sqe(ctx, req->sqe->user_data,
-					  true, async);
 		if (!io_submit_sqe(req, statep, &link))
 			break;
 		/*
-- 
2.24.0

