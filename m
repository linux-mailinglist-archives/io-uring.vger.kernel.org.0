Return-Path: <io-uring+bounces-2100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A63EA8FBC5E
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 21:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D76101C2506A
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 19:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415A214AD2B;
	Tue,  4 Jun 2024 19:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jJMltWwH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7DB14AD20
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 19:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528410; cv=none; b=h4BEdlAWQc+kldybr3h7WULnUVqtujhTmWrHJc91yja5VYxBP2IyXfjgeONlL3p9qq5oYfAoAlEqWFsl9iw5UpDhM4VCjpJRjD7U2kZzHpfT7xixzME1t1CYv6MHc1gNowsbEnl5lJM+NZxO61aqfOynXaI7n++4egchMILx2Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528410; c=relaxed/simple;
	bh=OR0CnN2UkeymA99yO1fBYAaowi0El/TSdyC92Zt4N4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPmy/K7DHmI+5cpQP1V+BoAZhbLr0vvO9AVzmkbwcAAiiiwRn6PGr0siagkOG7i3V6Akq3JjyDiSvnf2Qnzfr/FmFFMgVW7FitGuI8ECKzfpO0KG4VQ9nZYRiLdQh5HOByjE0Cd3R0kEsy7pwjKFpWuFMj+Io0662gAZ/tp6Sd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jJMltWwH; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2c2083b004fso569861a91.2
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 12:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717528406; x=1718133206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8AftqVlYD0e2UfGEa2RUz3rAXs2L3XRzDeiOK4ao4k=;
        b=jJMltWwHSNjGnbSZF/hFFfqrRhS3VGU+cGdWfWReQV8jwq8XNICrX/OKBQxDTOAJ/j
         l3TsFRzYW5ZsyldTSszGTq87hzi2/6SAeC4qTrEPN2YLwyx0ByzRh6DAlaCbVYp1dPUw
         YU9qKmRcDtSeyxiDJ08Jk7QcedWrLD1+ZZyq59usOnJtOGlChcNpY/tr+hOVyX6ojwGA
         WLk7fHv87Asg9i33k+jLnQR1fmjDfw84xeAHkS7kMSifJKUN64j3fdrd15xIVmKbtlUm
         SBdPeiVzwVkC705yEhvAHlF8K7oYw97I4COS8EgPgAVNoaccLhGNyPauIqZ97UBeZWY6
         qJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717528406; x=1718133206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8AftqVlYD0e2UfGEa2RUz3rAXs2L3XRzDeiOK4ao4k=;
        b=Cy3zI/nbPCaQtjdwDK+6jZeE9zfOUoF/tmnraHEpPtvFDp6KO+5EqLlPl9DuNucz4I
         s3CvZeTnQBJt+PLHlXnKLW0I+LICeLiavQ10+22k7dpIfnU8yhDQyWO3pYRhG69gzSBH
         yT6aqhoAp1dhNRGEw8mB0FbRbxxPiEvOsdbVySuMa3Du+WNXWOBvGWHp5IVxtXjy41wh
         zTjw+BRGL17CIQ6o3sNCQgvBb76AwtUZGYGkifPCeRFOCO8ROD+MjZZkIWNCjJEz6j1I
         vsdSx1il6B7roGnIY5vSULCHMzBKbs7+zPyYptiaZbxjxDLcAqOmdknye99/GOW72R+R
         lqmw==
X-Gm-Message-State: AOJu0YwqSHxoALLaX03Sku1CeMu2b/2wqHIdo9W+yibf8G8buv9/9S0l
	LX6BMpxH6ClA5rmG1J+KSaKVKOe6zuQufnyZc2/7Ej44ppjHQjzPlNu8VQlLDK0pQipl17p2kuW
	4
X-Google-Smtp-Source: AGHT+IE0gEAziTrxxww6sLqkZC+Gf4/6tC+yCuRoM/4nl28djr4Ol3nNA5jgsVonHsJjMdc9zCETgA==
X-Received: by 2002:a17:90a:12ce:b0:2c1:a06c:c6ac with SMTP id 98e67ed59e1d1-2c27de60e56mr361621a91.3.1717528406358;
        Tue, 04 Jun 2024 12:13:26 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1c283164fsm8960265a91.37.2024.06.04.12.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 12:13:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: consider ring dead once the ref is marked dying
Date: Tue,  4 Jun 2024 13:01:31 -0600
Message-ID: <20240604191314.454554-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240604191314.454554-1-axboe@kernel.dk>
References: <20240604191314.454554-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't gate this on the task exiting flag. It's generally not a good idea
to gate it on the task PF_EXITING flag anyway. Once the ring is starting
to go through ring teardown, the ref is marked as dying. Use that as
our fallback/cancel mechanism.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 9 +++++++--
 io_uring/io_uring.h | 3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 841a5dd6ba89..5a4699170136 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -528,7 +528,11 @@ static void io_queue_iowq(struct io_kiocb *req)
 	 * procedure rather than attempt to run this request (or create a new
 	 * worker for it).
 	 */
-	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
+	WARN_ON_ONCE(!io_ring_ref_is_dying(req->ctx) &&
+		     !same_thread_group(req->task, current));
+
+	if (!same_thread_group(req->task, current) ||
+	    io_ring_ref_is_dying(req->ctx))
 		req->work.flags |= IO_WQ_WORK_CANCEL;
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
@@ -1196,7 +1200,8 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
+	if (!io_ring_ref_is_dying(ctx) &&
+	    !task_work_add(req->task, &tctx->task_work, ctx->notify_method))
 		return;
 
 	io_fallback_tw(tctx, false);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cd43924eed04..55eac07d5fe0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -11,6 +11,7 @@
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
+#include "refs.h"
 
 #ifndef CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -122,7 +123,7 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 		 * Not from an SQE, as those cannot be submitted, but via
 		 * updating tagged resources.
 		 */
-		if (ctx->submitter_task->flags & PF_EXITING)
+		if (io_ring_ref_is_dying(ctx))
 			lockdep_assert(current_work());
 		else
 			lockdep_assert(current == ctx->submitter_task);
-- 
2.43.0


