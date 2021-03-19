Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18423426F8
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 21:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhCSUfh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 16:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhCSUfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 16:35:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B9CC06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so7285028pjc.2
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WjO5qPi8S3y2iymKcFKA7mv88q1ZlwyByVKxzfcHhyc=;
        b=HMgNLf/NKEMwKfolVJ7i5MX5jndII51eTOyiOsJpopN5azhuTOzRKmVvNpCE9e1o3S
         7k5dZi9s8N83kwDmaVmTiOm50g2ZDX6In1AOy6Flg/zADuw1SOvDA/0LK0yPTEZ+HEBK
         jFPoJqUvMliyWFhHpl3hwl82ScOv/nAOLRnB92EEXDV2XjQ/JEaqoII9uni1wFWrkKBU
         +syavicmdIa9UM6qFosmp+rweQf3MiQrljgzJRQoZT41QCGwrD7lBsA7U/NMMEYbHTs5
         posciRM1kUkbaDJ8auSojodOlg1eTUqk832Eou9seDsXW/xHRnfeTpmYcNg4n1vOpi7J
         QWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WjO5qPi8S3y2iymKcFKA7mv88q1ZlwyByVKxzfcHhyc=;
        b=TUOFPeJaiSKfH4+L7Tu8ICvjJps813fNULh4rpnm7c2Ya+TiAmDjiLbTt0QHHAvdtn
         KashyW3u0UzfzENaJG2KBHs2InKawcyQ4dwI7qGZLe0OwER6chAnjlBx+OmvsaiKmmLV
         QdtTSP0zklkt4zMoIB4JrM+l1sV3euW4WZbzmiqeus6GmF8B2RPQRyemjuu5o6LzTVCS
         6KKZRl3Zcvzyt7UVsu8a2HQfaZaBPAZt0+8VzTPervN4Oh1YHZR0zbprxNkofcDmXBXU
         j5S/314/rUWE41Ux+VSD3tbHP9zlGX8k8Du6m/hkubZ7XUeCh67fkKW62bxDdF2GkuDa
         tMVw==
X-Gm-Message-State: AOAM53370aQX1qi1Tv0miduZGMMbeueg6uurCVgbmaJM49NqR6SAZgd2
        F29bDALFCR86XGm0HSqO9HVGvJQzvI/Mdw==
X-Google-Smtp-Source: ABdhPJwWr+gvMWfYTt6ynuKnVzHHkh0KB5e0j8M+4o+mRsJW9qlV0EXi4oi+a+JPuWH083RkFfDuwA==
X-Received: by 2002:a17:90b:947:: with SMTP id dw7mr319545pjb.178.1616186122846;
        Fri, 19 Mar 2021 13:35:22 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b17sm6253498pfp.136.2021.03.19.13.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 13:35:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] io_uring: mask in error/nval/hangup consistently for poll
Date:   Fri, 19 Mar 2021 14:35:09 -0600
Message-Id: <20210319203516.790984-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319203516.790984-1-axboe@kernel.dk>
References: <20210319203516.790984-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of masking these in as part of regular POLL_ADD prep, do it in
io_init_poll_iocb(), and include NVAL as that's generally unmaskable,
and RDHUP alongside the HUP that is already set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c0e630a40d7..28bccb5ad4e6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4975,7 +4975,9 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 	poll->head = NULL;
 	poll->done = false;
 	poll->canceled = false;
-	poll->events = events;
+#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
+	/* mask in events that we always want/need */
+	poll->events = events | IO_POLL_UNMASK;
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, wake_func);
 }
@@ -5337,8 +5339,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 #ifdef __BIG_ENDIAN
 	events = swahw32(events);
 #endif
-	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP |
-		       (events & EPOLLEXCLUSIVE);
+	poll->events = demangle_poll(events) | (events & EPOLLEXCLUSIVE);
 	return 0;
 }
 
-- 
2.31.0

