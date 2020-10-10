Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB4328A3ED
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389406AbgJJWzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731220AbgJJTEj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:04:39 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94DBC08EBB0
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:19 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i1so7586372wro.1
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pMRBN1/yDUm504Nb9ckekej3Oj3/ck3OWfiJrcb/0hQ=;
        b=He9c8tEhtmdAyPCWMDifpej2rCEYO5tYtAdEEZ+IZ6UC9g+5DK+0LNnYnlQSFbnSDd
         M5nH1WnFef9DwdmGhbGQTe0sjYJHZPaJ3yFTQ3LBXDNhcJf85N9t2l3jL7nwLmvhUrPG
         0aEyEoSV5NKPaArUwb4HTp+JkCweq26mi9LWKG8z4rfPLf68cGvwBesQJDGS0l42Sk+x
         /cre0x5dIx15phiAvvoYzPyjqpzLlCYyxwHR/T7rbkBlehpo5aSOKuJo1CjSnAOftuTv
         1Jn9jhpjoW59mwPwTa+gsWYZtvv4cZ6Jn2pjWuYY3aXPxU9MGgKt8BbrN8wQkqGClqsY
         647w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pMRBN1/yDUm504Nb9ckekej3Oj3/ck3OWfiJrcb/0hQ=;
        b=derh8hFmm1HDqz7Ta7FddpsbIkJ2YW4JtmUX+4gXMfom/++UpauJ+X3L3AlT2KoJlK
         Nb/ifv22nTJxEFGQtbw9WTBqck/bH9HQhHWUvR+er6MCAOLsUOUjoMlQZrs6GidIOZ9e
         IHyFFdo/RnTRCfxkfT+rhQJKv+PEbwHQknGByaYcSLSsdKk45jmAXEC39vCjcN5XMgla
         lFMEosMYRilb0Kbl940FtIcMOev/3wlraMHEMtv/CZ4upnLMU0rb493rUycOdbQxKQ4s
         Xv515gtUk+1iB8qJOKPcBMCezlN5Mj924LXksoYJ97sM9qfQSQGiU803MCPZNSg4vtUq
         7YeQ==
X-Gm-Message-State: AOAM531qjOwHRajUr27b0yuzbPc6Xbdxd1yYi3ySEENychKdmXhHNyP9
        yoVPTsNmrX7f6cT/s9XaZESPmzoc7Dm4zg==
X-Google-Smtp-Source: ABdhPJzqlXFk2FqbyLjMfk38I3iUGm83hwmCro9aT4wDOWHIasiWPAj40uWiJ/iJ4SWK1RkGuMIeOA==
X-Received: by 2002:a5d:410a:: with SMTP id l10mr18396449wrp.274.1602351438538;
        Sat, 10 Oct 2020 10:37:18 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/12] io_uring: remove timeout.list after hrtimer cancel
Date:   Sat, 10 Oct 2020 18:34:11 +0100
Message-Id: <e3b00372178f905e1ee5e103155314222c3052ca.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove timeouts from ctx->timeout_list after hrtimer_try_to_cancel()
successfully cancels it. With this we don't need to care whether there
was a race and it was removed in io_timeout_fn(), and that will be handy
for following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09b8f2c9ae7e..3ce72d48eb21 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5301,16 +5301,10 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	list_del_init(&req->timeout.list);
 	atomic_set(&req->ctx->cq_timeouts,
 		atomic_read(&req->ctx->cq_timeouts) + 1);
 
-	/*
-	 * We could be racing with timeout deletion. If the list is empty,
-	 * then timeout lookup already found it and will be handling it.
-	 */
-	if (!list_empty(&req->timeout.list))
-		list_del_init(&req->timeout.list);
-
 	io_cqring_fill_event(req, -ETIME);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
@@ -5326,11 +5320,10 @@ static int __io_timeout_cancel(struct io_kiocb *req)
 	struct io_timeout_data *io = req->async_data;
 	int ret;
 
-	list_del_init(&req->timeout.list);
-
 	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret == -1)
 		return -EALREADY;
+	list_del_init(&req->timeout.list);
 
 	req_set_fail_links(req);
 	req->flags |= REQ_F_COMP_LOCKED;
-- 
2.24.0

