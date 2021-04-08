Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841AA35793F
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 02:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhDHA7J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 20:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHA7I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 20:59:08 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829F0C061760
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 17:58:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a4so253316wrr.2
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 17:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=syC+GdFnCob3DTPUkWMFswmoy6bCsfBnXBIXr4QmVCw=;
        b=hoBr2cmT79mbESp4t1BFF8fCLGPz1OyU3SqbfUH0ZbQCwEt84KjU2DjTXWaPC1tP7J
         kq9OPzpf4wY6KOO4brMVdilUPszUnHnb27gshIbaNqQzQPdIwmG2F84LXZtiqoDnQfDZ
         +GQEHi5+u8RJzVjCWeuyT+Ci8vsIFZoM3YXJjGhMzxslJnRdg2/5Nm3l95BnnW5QAofS
         9+R7LMfd6AgAcIJaZegNv0HqLoEMvYHjznMnqQF8ugT6FkMMTiAQ0mNJU+5D8c+2EKHh
         hgzYOhR6BHIkWrjDkkud6z5/K1At6H8ZM8oNf2sL+Dz7RRYYl8cQ5Fvyu2Y40AJDfVbu
         J75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=syC+GdFnCob3DTPUkWMFswmoy6bCsfBnXBIXr4QmVCw=;
        b=YpLj37IxMUgEJ/EE/3MSLsBduuJdTW1rWvl1vvG4UmU7DJSSl5hnleFJLg+SqBz+se
         h4mZzfmUKWs92Yo6P28h7G3FRd+zZawEIaWFHL25vM4yFp2Azf2c4IngzgtzCh4d61E0
         GAQT6VuMf6s2eWEkomBpatlPFOm67ISRJZC1hYrkPNSdZxwhkOKxRLCPmSaMF4ifBfoa
         APf7Dlqjhx+rCFfL5NYZk7yAwCE+NTOEIbf/QJLiiqP0DLQOriUOl3GzCBJ/XH45Gk51
         SvY18VYNUE70z9MtLVnJfXUumU+auKyeHi1P7Udw3pFfBzR5dWMZ5l9btiylRMTxpsNV
         r5SA==
X-Gm-Message-State: AOAM532MHqRHEMdrTnZeSOfVTAVIc+ybVV9wwwkTy7oZnWMObpuNxeEd
        j6Ee3nzNuEG0flCvt401UhxvSDMPysZOVg==
X-Google-Smtp-Source: ABdhPJwW39HuROTlwbKkuVJcacMfwrd2njkgD8JuELK6lrgADbrAKi//+UOsfptQuM6PHRMVAKlX9A==
X-Received: by 2002:a5d:5082:: with SMTP id a2mr7482641wrt.267.1617843537367;
        Wed, 07 Apr 2021 17:58:57 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id s9sm12219287wmh.31.2021.04.07.17.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 17:58:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: fix poll_rewait racing for ->canceled
Date:   Thu,  8 Apr 2021 01:54:41 +0100
Message-Id: <f6d92429952fbcb27eed4236238564d84e0f26cc.1617842918.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617842918.git.asml.silence@gmail.com>
References: <cover.1617842918.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

poll->canceled may be set from different contexts, even async, so
io_poll_rewait() should be prepared that it can change and not read it
twice.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de5822350345..376d9c875dc2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4897,15 +4897,16 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	__acquires(&req->ctx->completion_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool canceled = READ_ONCE(poll->canceled);
 
-	if (!req->result && !READ_ONCE(poll->canceled)) {
+	if (!req->result && !canceled) {
 		struct poll_table_struct pt = { ._key = poll->events };
 
 		req->result = vfs_poll(req->file, &pt) & poll->events;
 	}
 
 	spin_lock_irq(&ctx->completion_lock);
-	if (!req->result && !READ_ONCE(poll->canceled)) {
+	if (!req->result && !canceled) {
 		add_wait_queue(poll->head, &poll->wait);
 		return true;
 	}
-- 
2.24.0

