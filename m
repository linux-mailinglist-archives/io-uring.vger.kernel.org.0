Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0DF22B4CB
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgGWR11 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 13:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGWR10 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 13:27:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D611C0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 10:27:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id y3so5933984wrl.4
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 10:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NG7vCjYb1LcKrWeQDQlvv73achXw9OQ2ceqjm+4dOhg=;
        b=jNfs1Pq7Uaue3k+WiThy/G9+34duf/Ps1DWIOyfUOV3v1o4MKfikeDKPA7Bo2H2trV
         GHAOYmZ1FYK2U60fgoyp0YwO7wcoYkovKgL5r6WJSIHRSBBlhPHIE+CDqJM8RG+a/g5x
         7jXhUx/9bSlPMephK3kMS+mYdhjraaPXSB2fuX1N1AmatlvmpaycuXIg0o2uT8F/KwEz
         ToqwEO7yeJMRSJBzJJvVYYc/Krd9u3zqWfXlaqNeP6eP63GFPLoHnS1K/3YI0r5VdBdt
         uSSHXxCWYAY9HZ9vBaGpdS/w5mGTwPDRjkfJw/wKu7oNwFhar9FLI3ZvsI1zKT/Kc2iQ
         CVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NG7vCjYb1LcKrWeQDQlvv73achXw9OQ2ceqjm+4dOhg=;
        b=cS6Xbk2dJRyDZuOLzAK1Ey/0SlcqGcSfF+fpVJDFC8/2tM4t7FUUUAb6nwv2ICIZeI
         2mzaI5gf98j6BhQmbQi9xwEM9LzbsNvueTN0TYOod/cOpjnRMsoW67ayz+0F7r71xWec
         RPzFdWeDIbTE6yTEXW7VWAqEyVozQnJmO7kaNj3wB4WiMAGIedQ8Zgrq8PQkrH5KcUo8
         U0PmUuIZgbsnKwqWdXFzj9NNCFtbjFtWliQbsUn0orv6Nsoqp0PKUNjPmZO9rw6IVS95
         y6fFtzzsZh7n2TKj2YtB7wTGVpSou/uBsqqTtUjtHWaLICzRB+Dl3XFCm11+4Jwa55Lo
         MJqg==
X-Gm-Message-State: AOAM530tNpuMulZjp7J6eVAmfZML+Ega0ojFBaV7WOTOC+oP4mi4LtlP
        9XmXRp+AcCaFxEQqac2AP6o=
X-Google-Smtp-Source: ABdhPJx8FcLsG09lWovGCHdNQlPFhG5/WEYM6OMzQRiOA6IlGJFQhDgPqZ/twnAnZRTgdZGq5nwvcQ==
X-Received: by 2002:a05:6000:11cc:: with SMTP id i12mr4967018wrx.224.1595525245212;
        Thu, 23 Jul 2020 10:27:25 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id t2sm3976230wma.43.2020.07.23.10.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 10:27:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: don't do opcode prep twice
Date:   Thu, 23 Jul 2020 20:25:20 +0300
Message-Id: <a6e5b41074701feedae465bf26d4006315ca5c23.1595524787.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595524787.git.asml.silence@gmail.com>
References: <cover.1595524787.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Calling into opcode prep handlers may be dangerous, as they re-read
SQE but might not re-initialise requests completely. If io_req_defer()
passed fast checks and is done with preparations, punt it async.

As all other cases are covered with nulling @sqe, this guarantees that
io_[opcode]_prep() are visited only once per request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cda729de4ea3..bb356c56f57c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5438,7 +5438,8 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
 		spin_unlock_irq(&ctx->completion_lock);
 		kfree(de);
-		return 0;
+		io_queue_async_work(req);
+		return -EIOCBQUEUED;
 	}
 
 	trace_io_uring_defer(ctx, req, req->user_data);
-- 
2.24.0

