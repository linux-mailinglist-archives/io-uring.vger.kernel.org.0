Return-Path: <io-uring+bounces-1412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB81A89A1CD
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 17:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 656EE2818B7
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 15:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFFE16F85A;
	Fri,  5 Apr 2024 15:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DE7J21/M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE8916F901
	for <io-uring@vger.kernel.org>; Fri,  5 Apr 2024 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712332217; cv=none; b=Nm8CQb7voEX5DgjfmK+oXcyRlCuKV1NrWsXUcECLrkhH99/zZYhzObkfZQTudWJ7Tcnc7HOLEjtGuFwvOSH7z7UCB1I241h1gGveOCJoWbl5RlIKRFPY68tgtvSAn2WGvejKtS7VUW892+9jeVXmNTRQWjhXgrTVYPx0yUJAuBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712332217; c=relaxed/simple;
	bh=7oALiLajvRVhDyG5FY3/RAJ0HrbZAI6k6shViVT7YLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mhj1zCw19Zf94um/q6lXEc3Mg5jsWQFX0NQLjv8owLh1NFNJ6XoUI7GyjqaUlfPViOvU0685/tqTdqpljzNe9e96rmwrbjlNYG2uK4cFBxg5cQ72c5SJxFo3T6VWXWVSED32e953uCSts117iXDN36Y469Tu1eVUKAA8qvrB8d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DE7J21/M; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a51ae869113so48165666b.0
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 08:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712332213; x=1712937013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7nnkNMcai0DLhA6/2LRzuS5PCHUKa84UwC0Mph9cl+E=;
        b=DE7J21/M75349hgilB9yZglwd7qabP/X2ksM3/GYSF90MlDZOJw6TfnqbShRk64tp7
         tXJoDFHYk2y+PxKjOhWgcUbrythXT+KhYZQJ5XJqe6HOCoAu3nS6Ufu1aST8h/nBXK3m
         tBsA7DaBJOBtGMMkratOARcZBRTXK4qPCaiNq9SIrj2OuJ1foiEp3hhz08UaBgGsIrYv
         6PfB/S1sDA17d1nP85oweoS8rRAypaLx39J9I5eqGaKm7OKuU75a4mVuucEmZmZLzWRU
         yRLAgLz0RI7Tssz9Qe+Bg4fzAUtdUuQfHLUBcU6RVkA3fC8mw/x6SXw9xde4nGae3ga5
         6Aow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712332213; x=1712937013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7nnkNMcai0DLhA6/2LRzuS5PCHUKa84UwC0Mph9cl+E=;
        b=W/SgOpwrLsisZ5zPWA0zUaxA1aACdh4rW9tW1d6EOCpWDYhjbGb/6hx4GMBk6AYrjp
         c0O1PNMvq1lwa1w3VqZdhT/zc9V79dFzEtxat3Ra5R9OorjWBLElVGfKkdG1fLiMnNB5
         ypggGFIX/buorz+ArqGYdnfK/OUg+OBWNanCRXkJvRHQzcaAasALHLeUUUh1hBaINHHj
         NUsdIaJNY6jHFnkxBfF1TymYawJYQeN4sVYV7f5oqALU55FZT6JUavzYsjdo/I0xjL3I
         dZMTd3Xz13N7ZcM2AHNvgT/btIrvxmPjGctpqq+0Rgw9zsF47TDPEpelpLVoNXgbbRal
         EuLA==
X-Gm-Message-State: AOJu0YwqN57r//mVsM9n8ANbvOPBw+5/K0uFBSwv5hO3wqhjAx2zuTHb
	a0XZd80bjLvb6FrBNVKNt1UllIBXlaaaUvs+NY/scrhc4ZDelISZh2s4lmKG
X-Google-Smtp-Source: AGHT+IGKmG+lPuAjjllQizcCvtBAuharT0T+gQN6KwtZxQUjdrIEPdDkKsykS2XcN3ygROWADJnCWg==
X-Received: by 2002:a17:906:16c9:b0:a4a:3d08:bd7b with SMTP id t9-20020a17090616c900b00a4a3d08bd7bmr1373130ejd.26.1712332212812;
        Fri, 05 Apr 2024 08:50:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id lc24-20020a170906f91800b00a46c8dbd5e4sm966105ejb.7.2024.04.05.08.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 08:50:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-next 2/4] io_uring: turn implicit assumptions into a warning
Date: Fri,  5 Apr 2024 16:50:03 +0100
Message-ID: <1013b60c35d431d0698cafbc53c06f5917348c20.1712331455.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712331455.git.asml.silence@gmail.com>
References: <cover.1712331455.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_req_complete_post() is now io-wq only and shouldn't be used outside
of it, i.e. it relies that io-wq holds a ref for the request as
explained in a comment below. Let's add a warning to enforce the
assumption and make sure nobody would try to do anything weird.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b7f742fe9d41..c84650b0f7f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -931,6 +931,13 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/*
+	 * All execution paths but io-wq use the deferred completions by
+	 * passing IO_URING_F_COMPLETE_DEFER and thus should not end up here.
+	 */
+	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_IOWQ)))
+		return;
+
 	/*
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
 	 * the submitter task context, IOPOLL protects with uring_lock.
@@ -948,7 +955,10 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	}
 	io_cq_unlock_post(ctx);
 
-	/* called from io-wq submit work only, the ref won't drop to zero */
+	/*
+	 * We don't free the request here because we know it's called from
+	 * io-wq only, which holds a reference, so it cannot be the last put.
+	 */
 	req_ref_put(req);
 }
 
-- 
2.44.0


