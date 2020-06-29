Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F9B20D23B
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 20:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgF2Sru (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 14:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729359AbgF2Srq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 14:47:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B409AC030F0C
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k6so17147915wrn.3
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zsJIB+sr6qcF1Cnm/Z22+LEx1JCGv/IuC3fy5e6CyuI=;
        b=m03YPK7w6/d0v32y3VemEr8yFIHEsN5r8wUiA55b9HjTW4IAEZDtu/8ewB/ujsrMqk
         Zrj2JRe3WwMR+9YYQBcTB2rP2N12/eGboDhaj1xTDNQ2jQg4lJJc35EsZLnssMrCrp6E
         +xZLbqvYWj93dL0n2CIRfhGPtuOSHrdKseHIfWZnZsLu4tn6DKCCoXS2V4Jdgeo1ZR6Z
         CEpHENrOS911AxbQyjSAmprQitK+B94do0W62YKdZA88bNKyIJEUHqweW9OZq8HyuYh0
         A9ZxUZwSr8KNROzV3iC1YN/oTsZA2nHVY3xSpYtkjuaLrlTvv5CzfHAubXP8QNPq4aB2
         krrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsJIB+sr6qcF1Cnm/Z22+LEx1JCGv/IuC3fy5e6CyuI=;
        b=i4WPV9yFODKL0fpaJWW0aFxDgsfWKlL+vrBik5WBfSd2C+ripZLt2BZYduYEFGljUr
         JC2p2SqIDKLmziZmN0SIVmjhPPBa5upRlF4R6KhhJg1DgZWfeno18mnDLH7HmOHq201C
         bLAf/MaVIc0MJsAcs/8f6jQTkzWu5m3QQYLIo15RVE7aw1KM22d6cQYLywH8iLkEmrDi
         oHjsv12AMcmKKpgUJWFx70+MqnCiLLCgYQN7Us1BRN6PUH9bXpa79yEPOwUowi+mG2qA
         XX0KKW7Wq3LTL9fXEwJhinHpHJDFeFhDG3cjrAEdMEwPtPqbqEpJug36VvsZbxTWwruP
         FmfA==
X-Gm-Message-State: AOAM532aaH5ZK1czoPRLQvcvqmZ/Ld2PDd+KpiuvGkE+ZFPBwykdfk3r
        ngjb8w+uvr7Q2av+1N5opYbQi98x
X-Google-Smtp-Source: ABdhPJwDu7h3z677Rp7RoKzPExCY43tKOV1Eze6Fa4eLLo/dcXdGarIfurp1Ap6YRgbouctEvvQkpg==
X-Received: by 2002:adf:b6a4:: with SMTP id j36mr18007355wre.260.1593447627506;
        Mon, 29 Jun 2020 09:20:27 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 2sm282333wmo.44.2020.06.29.09.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 09:20:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: don't pass def into io_req_work_grab_env
Date:   Mon, 29 Jun 2020 19:18:40 +0300
Message-Id: <52993246c2877df208cef47ea576ef3ea7ab911c.1593446892.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593446892.git.asml.silence@gmail.com>
References: <cover.1593446892.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove struct io_op_def *def parameter from io_req_work_grab_env(),
it's trivially deducible from req->opcode and fast. The API is
cleaner this way, and also helps the complier to understand
that it's a real constant and could be register-cached.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 013f31e35e78..ecee44a97c29 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1101,9 +1101,10 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-static inline void io_req_work_grab_env(struct io_kiocb *req,
-					const struct io_op_def *def)
+static inline void io_req_work_grab_env(struct io_kiocb *req)
 {
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
 	if (!req->work.mm && def->needs_mm) {
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
@@ -1161,7 +1162,7 @@ static inline void io_prep_async_work(struct io_kiocb *req,
 	}
 
 	io_req_init_async(req);
-	io_req_work_grab_env(req, def);
+	io_req_work_grab_env(req);
 
 	*link = io_prep_linked_timeout(req);
 }
@@ -5232,7 +5233,7 @@ static int io_req_defer_prep(struct io_kiocb *req,
 
 	if (for_async || (req->flags & REQ_F_WORK_INITIALIZED)) {
 		io_req_init_async(req);
-		io_req_work_grab_env(req, &io_op_defs[req->opcode]);
+		io_req_work_grab_env(req);
 	}
 
 	switch (req->opcode) {
-- 
2.24.0

