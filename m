Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E054934367B
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCVCDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhCVCCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:45 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B811C061756
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:45 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j18so15011892wra.2
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IFgwJUXv5Si+NCG7DDhZmROrk7E7s0vE/gfft1pH9oo=;
        b=vXKAixzxYpYogkNLI2UFDDtZF7LTYizglU5saK4Kwj71iMGJDjRN09tdoolCUYm3UU
         FEeRoSpSf6Pdazf405ejn2s5SQ4zC+mpZIH78Um6nppM5hkTyBs9pLN9Hyzi8djuRlBm
         VXmfI4GoGvof0swGEnI0RGn2Mq6yqyOJXhVzmnf5CPLn77uRpufeHMRd24UkYFdcHlxQ
         30YcqwyhQum2vldKdn+HkXJ1K0939whCQ9DRPbV53WUv9Nyc1sV5mnGdq/nMzWzBLtRN
         I3Hmsz2cUSR6fqqe+Tvf9I2cG8bRDostS1krR042QJEXDdTZt3oc+ONToJ6KMlj1Dg2B
         Z1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IFgwJUXv5Si+NCG7DDhZmROrk7E7s0vE/gfft1pH9oo=;
        b=QTERmBKDLEWUuyK10mEZZ/Prdj2t+UespqqHS1i+lyOCtgAzbHmVO2beJrDB8LQ9gZ
         YUGL0XF4BN73s38u06h5fF7G8LobVsiBs5vdxz2lX7ww7pJxtnSPbOhnSk2esFDgPUyf
         Mr4icySTXc4p/XAh2y7f7PfRUbgoTTGDR33oFpek1jjhKRAb+tXy+1vT3O/dLE2KmYJh
         Ikv8Wns3UAO0JQzq9UPfhkrMptQ08dKnZEaJeboMfjzhspl1qsfl2hPTfUxr5SZGVFuu
         HNURPRdIwVzK5AXS5IU3LjTz1P7jDrwgEFyqtloEn9m4e52+jjCiZxCJfVGSxW5WRLo2
         5pvA==
X-Gm-Message-State: AOAM530FZORYt38Yt2Jmlrpo6BPk7gr/1BwSXmgAflAKbgn7yZUHsgks
        ongjMUS2lnZBM9NBgIYM5hnj9KzWOD0AOg==
X-Google-Smtp-Source: ABdhPJxz94X/tb+v0oYzS4gYYWuXmqtEDtisaYVYVy2/UXrYQqKgHe2UL5rGv2KJM89PQynlvES/mQ==
X-Received: by 2002:adf:fbcc:: with SMTP id d12mr15543726wrs.151.1616378564088;
        Sun, 21 Mar 2021 19:02:44 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/11] io_uring: don't do extra EXITING cancellations
Date:   Mon, 22 Mar 2021 01:58:25 +0000
Message-Id: <f2aba1075b5b23be428f8e7e2f6dc529a5667783.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_match_task() matches all requests with PF_EXITING task, even though
those may be valid requests. It was necessary for SQPOLL cancellation,
but now it kills all requests before exiting via
io_uring_cancel_sqpoll(), so it's not needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5cba23347092..080fac4d4543 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1077,12 +1077,8 @@ static bool io_match_task(struct io_kiocb *head,
 {
 	struct io_kiocb *req;
 
-	if (task && head->task != task) {
-		/* in terms of cancelation, always match if req task is dead */
-		if (head->task->flags & PF_EXITING)
-			return true;
+	if (task && head->task != task)
 		return false;
-	}
 	if (!files)
 		return true;
 
-- 
2.24.0

