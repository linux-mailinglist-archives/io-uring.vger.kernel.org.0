Return-Path: <io-uring+bounces-188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3EF800066
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 01:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E304DB21165
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 00:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D98633;
	Fri,  1 Dec 2023 00:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EehTV34I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E1FD7D
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 16:40:49 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-50bce40bc4aso1626029e87.2
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 16:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701391247; x=1701996047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IucjSlaP6FuzeHx615x/W2K2FBNgUt5/NJII3nf6WWY=;
        b=EehTV34IewS2nYbV8/OidhTNB8AC3em7EyjhVgM1K5Y4ibdU2YpT6oeoq1s/h6xCPL
         tr6ETWIYe+0h5Q6tIm7/Y22gBD7bVNiMTzo/uaKm8Z0ktdIP9ErbPNk+0FdExRok9Na2
         ixA4umaphM2XzPE4khf99mD0v3O5c/Y+LUwAwpWWa+wfu45y7HXhkRnW6QGehfjPtx4u
         wqP6ppTcEa5MVvZNlASH+jlH11kGSgOtMBLmuf16gUPE/c6BZJATkSQgRV5aXEf2jWed
         1tnYTN1GYYOPs3OLLXAIpvl9JKIUjTwoPnHXG5cDO0SPLlkBECAdtAjx3KJtZxe/EcGH
         qEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701391247; x=1701996047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IucjSlaP6FuzeHx615x/W2K2FBNgUt5/NJII3nf6WWY=;
        b=afpfOi8pcYHnxKqgNZts6h6uAW3RjhwS6wDmGUFZ2ZIeZghpZGdJt4bZU7K7o2nrKj
         Uy4w3TyFyojXE0zwtItyp92lQEvXdKo5hPLyjx5w0X2Jhi7lt1rDby8XN6ixj0wyn2Q8
         7MMlBdjcfl0XvefU2Ij5+VAm0sy2OnLgCYNLjtYYEIyyfT3FaKlLCaydllPIRNhUa2Dh
         eOOGyyjLGTYJFXJC7vtopq2g+qIPO1nCkLbF+nCZGwoofbbrrJuXI6wAKSrbVVqvD/IC
         cYwy7Dfwox+mEd5cKvFRqSQJQbJkXnHNYC8fDJIHsbKwDaxoIDFCInYzRG4bRn1L2GHn
         WkgQ==
X-Gm-Message-State: AOJu0YxXmt77PVfbXMCTnx6OvBlHjFa8eijmzKoQuLipaP1BozPOMuGz
	D7qoS2Uw22iqhOZFlze4jBCx7uWdGXo=
X-Google-Smtp-Source: AGHT+IHSGss9JC6pKatY/to24ku/DcCQ+ga6UJn++zCaq6VAE+ISjr4RiiHpVGP9qhjN9SnblECOrg==
X-Received: by 2002:a05:6512:31cd:b0:50b:d34a:209a with SMTP id j13-20020a05651231cd00b0050bd34a209amr289176lfe.0.1701391247233;
        Thu, 30 Nov 2023 16:40:47 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.191])
        by smtp.gmail.com with ESMTPSA id ca25-20020aa7cd79000000b005489e55d95esm1059139edb.22.2023.11.30.16.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 16:40:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 2/2] io_uring: optimise ltimeout for inline execution
Date: Fri,  1 Dec 2023 00:38:53 +0000
Message-ID: <8bf69c2a4beec14c565c85c86edb871ca8b8bcc8.1701390926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1701390926.git.asml.silence@gmail.com>
References: <cover.1701390926.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At one point in time we had an optimisation that would not spin up a
linked timeout timer when the master request successfully completes
inline (during the first nowait execution attempt). We somehow lost it,
so this patch restores it back.

Note, that it's fine using io_arm_ltimeout() after the io_issue_sqe()
completes the request because of delayed completion, but that that adds
unwanted overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 21e646ef9654..6212f81ed887 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1900,14 +1900,15 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		return 0;
 	}
 
-	if (ret != IOU_ISSUE_SKIP_COMPLETE)
-		return ret;
-
-	/* If the op doesn't have a file, we're not polling for it */
-	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
-		io_iopoll_req_issued(req, issue_flags);
+	if (ret == IOU_ISSUE_SKIP_COMPLETE) {
+		ret = 0;
+		io_arm_ltimeout(req);
 
-	return 0;
+		/* If the op doesn't have a file, we're not polling for it */
+		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
+			io_iopoll_req_issued(req, issue_flags);
+	}
+	return ret;
 }
 
 int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts)
@@ -2078,9 +2079,7 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
-	if (likely(!ret))
-		io_arm_ltimeout(req);
-	else
+	if (unlikely(ret))
 		io_queue_async(req, ret);
 }
 
-- 
2.43.0


