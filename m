Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC28042DDB9
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhJNPOX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbhJNPOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:16 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A732C061779
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id m22so20715190wrb.0
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8PdPxuGXZ0TCoOkJWhxNcwz7HYEcTy9Z8cmoAm+CkWk=;
        b=HPsMdeNvAkKxQVmxd01BQepkQ8UtvL5WrQyci5Y/sPDl/e9jGnmMUpbZc1eVHwztAs
         2+Tz9WJFKbs95LMM7lCo1hVDSs1lyvDdOy9tO7ePmGOhO+9znYCSwNXvC5wmodLu5AqY
         dC5mlSvIED/4lbSuCDid9+ho4EibEbBbotd4KEgLzZS9kWEcQQvCXVk+m5YNveX9dRto
         Chj3pDTe64OpU86G0zqiYvs5aF1z4sKbtKzuyCTzTgYoECtgvPpvC/M6OIL7Ub3uIVLP
         yZt4IdtW8Bf0PYLyd+u7bPjljoJl0lGh3qq+2op9nAKr5TJCcUCt0y8guoUPD4vMiCzo
         aanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8PdPxuGXZ0TCoOkJWhxNcwz7HYEcTy9Z8cmoAm+CkWk=;
        b=PgzM9uhImrUwGob5qCCrmwraFjQML+BC2hvm+AGGszv70Mc9r96LyqcrPS6M/AzDfS
         9u0IIdfjpPt1svuHw+MVhD1AFJuv4qsLi8EXPxJx5WO0CDf3IdnPl0WV+FWQNKMUZvIH
         tyvbPR5esAS/tDwGDgFn76qdmW5k10dufkb48ZwQlS0lP0Wwg4SIRJxir9U1gBo8n73m
         0HIKUFYxgt6wc2fzg9tqVAWdAVLynOnCKlP2OteXMpMGCzHc9I+KyzIrFmULYafbpyJh
         85yWIaXdFErSe4ZWA9A7ugHk08IolB0hEw5OdxL9wN/KjoMgEkJpvxxdGBTfZEZQWw15
         xF4g==
X-Gm-Message-State: AOAM532VR9wqO55QYUQskeIQSMvzIvW0a/EdvuBd87QUfhkb6gsQcSI9
        7uq7av02Wa0kglwQHQvHs75zj5BIBhA=
X-Google-Smtp-Source: ABdhPJxUWIc+KNDVhcbBRIT/4PUPlj18cVU0ZBNLODirejEfVhojDiIcX6qvtzd9sirQAXj+kkgpVQ==
X-Received: by 2002:a1c:9d50:: with SMTP id g77mr6337615wme.58.1634224269349;
        Thu, 14 Oct 2021 08:11:09 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/8] io_uring: prioritise read success path over fails
Date:   Thu, 14 Oct 2021 16:10:13 +0100
Message-Id: <c91c7c2da11815ec8b04b5d872f60dc4cde662c5.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rearrange io_read return handling so first we expect it completing
successfully and only then checking for errors, which is a colder path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 561610e30085..6e1d70411589 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3449,7 +3449,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
 		goto out_free;
-	} else if (ret <= 0 || ret == req->result || !force_nonblock ||
+	} else if (ret == req->result || ret <= 0 || !force_nonblock ||
 		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
-- 
2.33.0

