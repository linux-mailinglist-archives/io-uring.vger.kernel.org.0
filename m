Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A0F333D83
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 14:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhCJNSK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 08:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbhCJNR6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 08:17:58 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63450C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:17:58 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id 7so23315156wrz.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3jKbj4ZUfin+7x3b9Q4ykkkOtDj12yS5Il8w4Ftckes=;
        b=mL55TUQiJEWQCPT85vtjd+kOlMh9PvwclR7K5c9PMcfI2aVGD4uoQ1BIalk8HSVcpE
         Tb6wQLtniHf2kfzvhBRkbDAyrCsC9l4CsQXhP6+i8COh4l6YoRMOolAjX5GmHXr+4Ahd
         0Mkb4UyGJ3CBzB4mwFzsSDuq9Jrvs9z/Lm3UIveIUGQ+QxksI6NM1AbZf1+4VnNUoIzL
         MFAQXRcLBGc3DStjVCq4ssAThX+pTVdm+B7sbM8SJh4ivwGTfGy0YpK50ipqWWk2Cx5I
         HD1GZ6HZuW55AQWkyxqVkRHPNftHs9dXgTp56uCKkGkZsQbt1ocvHuHyp0PJtAYRyJlX
         x/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3jKbj4ZUfin+7x3b9Q4ykkkOtDj12yS5Il8w4Ftckes=;
        b=cQhnBE76uWJ6VGe5eRvLwJEoJs9zQZoTXwBU59exF6f15oxO8XM/GLqyumrXr9ukYw
         wm/1N8/QtPTjaQZd0unlaz2r4utj/4L243s6DXk/kjoYCnIrknLXhGP40I055yDs0Mro
         I4gtcJNRtAQ6fuS46vra9g9UkEC/qnwM3HZ41kChTWtxwe9WH4ktYCKM1vdKkxPbiYKX
         DQt9CphV05Zx9V7ndrT3eaMmxBzJXEhpf/Jmpjrb2r6qJ2SfszBD0YdI5qyfpJqtnBvH
         FXSkjQE55RnKApajGim+kD7QqqVDiEv6hPGP0YN1l6MO1gbxb2snsP9PFff4PHJfFJzo
         lu/g==
X-Gm-Message-State: AOAM531+ugmbNooS2RU3FXkINaS/LWMmMdvRAUdAQ2KREcxWzAEu+6YT
        Yt7zpI4CFliwWWqpyDEfLME=
X-Google-Smtp-Source: ABdhPJxYsWYE/whWjH2WmgMQy8bCs4VfuMbbvDEFe0vEaehfCOaGfhXXRe7cEPAroryQwArtmlA4QQ==
X-Received: by 2002:adf:d84d:: with SMTP id k13mr3658171wrl.164.1615382277093;
        Wed, 10 Mar 2021 05:17:57 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id u63sm9328004wmg.24.2021.03.10.05.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 05:17:56 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: fix invalid ctx->sq_thread_idle
Date:   Wed, 10 Mar 2021 13:13:53 +0000
Message-Id: <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615381765.git.asml.silence@gmail.com>
References: <cover.1615381765.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have to set ctx->sq_thread_idle before adding a ring to an SQ task,
otherwise sqd races for seeing zero and accounting it as such.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 896a7845447c..0b39c3818809 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7827,14 +7827,14 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 		ctx->sq_creds = get_current_cred();
 		ctx->sq_data = sqd;
-		io_sq_thread_park(sqd);
-		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
-		io_sq_thread_unpark(sqd);
-
 		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
 		if (!ctx->sq_thread_idle)
 			ctx->sq_thread_idle = HZ;
 
+		io_sq_thread_park(sqd);
+		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
+		io_sq_thread_unpark(sqd);
+
 		if (sqd->thread)
 			return 0;
 
-- 
2.24.0

