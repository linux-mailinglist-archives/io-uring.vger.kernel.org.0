Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23D92335EB
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgG3PqF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729997AbgG3PqD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:46:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A22C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id bs17so1534582edb.1
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1erUX3jejIaxwOAtt+kP1fEG8b/qpjNCHxbYf9oWeko=;
        b=bhTrv+2x0TmlgKY2uiXlcxu3iwRPcSnV5KYWJdWpllVWKVgxoh5inpbOHvnsJ7/ymA
         /cjJWeLnHYEF+mfJcXsKrwpFs8UyLLycC3G7XvconhKb+QFjOi1tkV7pbYBQdJY9V/0R
         XxOdUYqMzOdNmOH4dHB93hPggNaCgeUyEpEsc+WV3d2wGVcpKEOwT9hr7296moi9t5L4
         1eX/jJwIaQmTSftrq/avZ95JqwNAYe85qkl3vexg4ZOSNVb4eAKMBDsmtHXH6FdIxNW5
         PjwtamLLrnVdDOKDx4v8fzHzyjUehLFDuHInwlqKUzkfyuXE+PY9fe9gmArSrd0owmhD
         hJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1erUX3jejIaxwOAtt+kP1fEG8b/qpjNCHxbYf9oWeko=;
        b=RwS3IRdFQzSCUP+OlEr9ViLvQ93FJpOEFt0xiwN4mTCOpRxC+JkVU0qQXbpviVNLMM
         ytNt9w1WQaAiMNBWdmm/52gIWSM8aFCa7wMU/6ki2QD6XAZVH2Y2tmF8sR10YZKE21Mp
         3QnfF14UHuJLmOYUiIRDBaBbn6laXizOat8GeXWDyY34ww4yKBUXX/v90JixHkB51SUg
         zaEXToGcXFUFAu7NZgpqJKjHBPzkSDLwH+VIIAigUFwEfAHZnr0hR3dkCL5PXYj6fROt
         8q8t1Q83ox1j++LR4bKLksFuPM/5MKapJvS4TihRFR8dqfGQeQNWPoimIW4ZBtydBHoI
         TGpg==
X-Gm-Message-State: AOAM532XbbOk5kfDXf7vtm0xIp8b2/q0ptnykKy8s4FohcJF80qSTegD
        rJ/4BaK4EW+oB7lXQ2qsXzhNNm5z
X-Google-Smtp-Source: ABdhPJx+9FFszS/58rD1Xwttsm5ySWR80PA3kuVGv+7LbTnydkN01mj8soEI5VGaIkriYfuh1og+uQ==
X-Received: by 2002:a05:6402:3ca:: with SMTP id t10mr3201773edw.298.1596123961488;
        Thu, 30 Jul 2020 08:46:01 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g25sm6740962edp.22.2020.07.30.08.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:46:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/6] io_uring: deduplicate __io_complete_rw()
Date:   Thu, 30 Jul 2020 18:43:46 +0300
Message-Id: <571f3037d6b7fa885dc075e56224cafcdfd68eaf.1596123376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1596123376.git.asml.silence@gmail.com>
References: <cover.1596123376.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Call __io_complete_rw() in io_iopoll_queue() instead of hand coding it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 86ec5669fe50..11f4ab87e08f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -891,7 +891,8 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
-static bool io_rw_reissue(struct io_kiocb *req, long res);
+static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
+			     struct io_comp_state *cs);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_double_put_req(struct io_kiocb *req);
@@ -902,8 +903,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
 static int io_prep_work_files(struct io_kiocb *req);
-static void io_complete_rw_common(struct kiocb *kiocb, long res,
-				  struct io_comp_state *cs);
 static void __io_clean_op(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
@@ -1976,8 +1975,7 @@ static void io_iopoll_queue(struct list_head *again)
 	do {
 		req = list_first_entry(again, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
-		if (!io_rw_reissue(req, -EAGAIN))
-			io_complete_rw_common(&req->rw.kiocb, -EAGAIN, NULL);
+		__io_complete_rw(req, -EAGAIN, 0, NULL);
 	} while (!list_empty(again));
 }
 
-- 
2.24.0

