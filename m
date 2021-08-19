Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15253F18A1
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 13:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbhHSL5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 07:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238314AbhHSL5m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 07:57:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A281C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 04:57:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q10so8727241wro.2
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 04:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CRkvq3telrpr6hxGGdeX3W4YqqWMyRJOha/VXH8cBpg=;
        b=vTRYROdI8XVN9a8dc66SLtk+gGxiCtTnkk4knuDuLmKbqZJ96dZbdC+uDG07YmE5AR
         vEHAy9q/g45ecplJXzYmAqb7BABkCZb2ms9hhmLAlFlXciUY0wr2K0zvPR7T7eugPI+S
         xhqW/drDHI7cYJEVb4VBNfi21YxSiPgIR5/9BfesaY/9owYgDSI7RflOurnGzMt2D/qr
         bx4QvSY8MnRzL9e2Rc05SpXqaNIWysAMgN1/fm/ClNMqT5wQv6xnS9XIYvbgd0yhSt0I
         2iYjeKVp083aiag3yTi737sc5GAMBSgl9ldIcTfYipibn6D6b7w6KAgReeye26JtXTpA
         yEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CRkvq3telrpr6hxGGdeX3W4YqqWMyRJOha/VXH8cBpg=;
        b=TvuRhz5LQsOQO7SmgGCeySek3kiTzcD5C6KEMIXrqzuIJVVgNQpM6yhX4HPo0howwa
         DvAVj0d17VT+fGiDbCkOamPntk7DXhdvijHx+MxzMhXbYxKwiURA5PbY86fDgroIuYO2
         pcR4ukJ3Hxvz15tglmFMujEXW6U7by5m60g78C9iad+bgX0F9N3mTCECZjCRLAjbHAY1
         uSa3AUKlVaBkfljb9SMdyAvMCfifi3jcXlQBloJGQmArfAmYYS/RBETuGRqy4Ee0pi26
         Mh4VSP+LVJfJ1UOK8VS54LOD2SHkDh4+DMDp1Y62JMugDI7sprAC9qtaTR8aGnbnhTDB
         Oh2w==
X-Gm-Message-State: AOAM530OluCTkdOBbeVBsLnPEwcqsUe5x2mQxekv80I/0dQ/yXNOPxwP
        sp5ZgUqpWOQoeARfmdqKCJ0=
X-Google-Smtp-Source: ABdhPJzFXJN7kLGsDjuXGJgU28iZS099suVGwonDMHyAEuRHHUD8BI6/ubUelrpOwujHeD2BPQdUUw==
X-Received: by 2002:adf:ab0e:: with SMTP id q14mr3406436wrc.171.1629374225186;
        Thu, 19 Aug 2021 04:57:05 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.21])
        by smtp.gmail.com with ESMTPSA id r10sm2700906wrp.28.2021.08.19.04.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:57:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: dedup tw-based request failing
Date:   Thu, 19 Aug 2021 12:56:26 +0100
Message-Id: <6c53c885259f976832b8f77843061e396c200565.1629374041.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629374041.git.asml.silence@gmail.com>
References: <cover.1629374041.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_task_timeout() closely follows io_req_task_cancel(), so remove it
and replace with io_req_task_queue_fail().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bdab831a1185..581c994a4e4f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5529,12 +5529,6 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static void io_req_task_timeout(struct io_kiocb *req)
-{
-	req_set_fail(req);
-	io_req_complete_post(req, -ETIME, 0);
-}
-
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -5549,8 +5543,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 		atomic_read(&req->ctx->cq_timeouts) + 1);
 	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
-	req->io_task_work.func = io_req_task_timeout;
-	io_req_task_work_add(req);
+	io_req_task_queue_fail(req, -ETIME);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.32.0

