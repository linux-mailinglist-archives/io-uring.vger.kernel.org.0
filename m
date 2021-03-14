Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7248C33A81B
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 22:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhCNVB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 17:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbhCNVBU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 17:01:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EDAC061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id d191so6951393wmd.2
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 14:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VVHK/W8Nbrc8VAzTVKQRM8v6corEiuXY9lPKdrMi43U=;
        b=PYtY+DUCnx7uc/h04RWqxijPLO5mssxC03sR+GvGt+ZE9gJpe/1/Wgksh+BPTFUMTr
         CMZR3hBpKdR/4gkQyIDclhKgTMepTKiTUeDoza7yXy2NfYB8uQpKAy7GJ/lBwh4a3xsR
         evgYhRIcWquIEdzrDndllLBCHDdWKDsRRscr5i+0NrthuQWJMp8vLwWm7nNuX7gvg1cC
         E+jt0qsX8nrahNXoBdbq6SMLC984l8zsoeg3EzGWtgBSjMyCTqTFtAG78aYn+ao0vDr3
         q1/oACJeeu/uhSoIOEVfmw6c/J605sPDK04eaKI1JHX+lg4TWINNIKK450/YSFowi8rE
         Ml2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VVHK/W8Nbrc8VAzTVKQRM8v6corEiuXY9lPKdrMi43U=;
        b=ExKajUar0A/411JwfWgIDKeYyGd+SD7ctVXHsenTOPVbuANsDzcCDo+Pa94ZFRB/S+
         I0PYt9ccaIDHAmkz1O7eVAHZMNpHxl6kiUydQEqEWuq/hcB6vPE6uHy3VzjAh+6YWz0E
         riO2c9wJWjhDK+soO+XBEkElwCjZXrkaBbAFD3glzynnxyFXQGhwy8A2RDlYLl2mPqgG
         1whf6eCXLhjj/crbxgayGf/t39COrbfvyELyu36Xd1rfjSFs0FghfEY36VOIyryfOPuA
         pjpwkqxzptNQewPP2M3fht+sgTyfK+WeBd7ZbK4nk95ooZr/vzMNnaAZzq6kmgvV/0rc
         sydg==
X-Gm-Message-State: AOAM531PDeCnagYg6jQPWcxG8Rxa8+qEYELINsD0A2iiVL8f5ZMpnUWp
        0A+cXoII9wL/frr3BCVVL4U=
X-Google-Smtp-Source: ABdhPJzBPsys6q0yfgQJJVbqhdXcoi4c7C3oByuv+1pBBZDd/hNE65M+dckJx7FzDe4CcrOyQXuGgA==
X-Received: by 2002:a1c:2308:: with SMTP id j8mr23842307wmj.45.1615755679226;
        Sun, 14 Mar 2021 14:01:19 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.154])
        by smtp.gmail.com with ESMTPSA id q15sm16232527wrx.56.2021.03.14.14.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 14:01:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: halt SQO submission on ctx exit
Date:   Sun, 14 Mar 2021 20:57:11 +0000
Message-Id: <04ede797f76a11cb78ca296f4a4698da02d89583.1615754923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615754923.git.asml.silence@gmail.com>
References: <cover.1615754923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_sq_thread_finish() is called in io_ring_ctx_free(), so SQPOLL task is
potentially running submitting new requests. It's not a disaster because
of using a "try" variant of percpu_ref_get, but is far from nice.

Remove ctx from the sqd ctx list earlier, before cancellation loop, so
SQPOLL can't find it and so won't submit new requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 76a60699c959..b4b8988785fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8561,6 +8561,14 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
+	/* prevent SQPOLL from submitting new requests */
+	if (ctx->sq_data) {
+		io_sq_thread_park(ctx->sq_data);
+		list_del_init(&ctx->sqd_list);
+		io_sqd_update_thread_idle(ctx->sq_data);
+		io_sq_thread_unpark(ctx->sq_data);
+	}
+
 	io_kill_timeouts(ctx, NULL, NULL);
 	io_poll_remove_all(ctx, NULL, NULL);
 
-- 
2.24.0

