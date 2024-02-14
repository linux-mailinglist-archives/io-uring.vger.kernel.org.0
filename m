Return-Path: <io-uring+bounces-603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 612EB85539C
	for <lists+io-uring@lfdr.de>; Wed, 14 Feb 2024 21:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A24D2921B7
	for <lists+io-uring@lfdr.de>; Wed, 14 Feb 2024 20:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9498313AA5E;
	Wed, 14 Feb 2024 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="l8bfU7SB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3C81292D4
	for <io-uring@vger.kernel.org>; Wed, 14 Feb 2024 20:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707940954; cv=none; b=j2xHq7zKdbE48exxTFvaUn52vX704HN954UZARopu2S83HXvQJoJoTDX7VwHeUN9I9CjLPKiqLZ8k+PYuULsFqq738Kzbh0mksE0xOPmFWnyafnJthTn/+Fy1Fw26nbp8SoiglGY4VJwMUHx15mdZDfNUwpvZPmu4qaPIrmcWQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707940954; c=relaxed/simple;
	bh=NpexSpJ0XqnJmp6isnSOQ/5wpumawnqKyRqa9aV++GQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Ey/UE/Klp3yZ31xgmmrijNnlrcXYG7t2Ab4ZLAiJ7htIrQIbi4b/cWq5W7bKMqIl7mkiGJry9rjgcFy6OhoZEkjdVtbfW8dRvjrOgXXHPAtm9fMUJoobvXaMmAmuV53p4AUwDLKIJlVmVuhJpRwVUrzizYUsoaQzFrVaJOokG7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=l8bfU7SB; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso1311839f.1
        for <io-uring@vger.kernel.org>; Wed, 14 Feb 2024 12:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707940948; x=1708545748; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XEQXx7Y35Qf8D7TyG6uRzyuGKFruUVm/oc04P25qS34=;
        b=l8bfU7SBvcGjdMqg4a+uyqljmXsamnYxRjfCPySpmh2GrkGheqFUw1qBbUCw6X76vV
         B+zrnbcDCmE+NXYlg9PH1MjSf7NnS6Ap6dNkrkLL2Jvu3tZO8fiohMdN3ndSDf0g5ZhT
         NiKvcowqzHax59jtlCiv9UBCnCKN4UVm97xvJjVQBXxjayCrPUqI33ywW/fdZzW/gqdp
         +qheyT/qqa1m9XWtnJCQRNa45ayo1CnJba3QQcIfyz4rc43eQYFyAqCb5NvzSgHrKQnm
         7L9SLb0UALidERTXZ/TP5e9vw+U+Alk/RMUxjIcZWguMi6L1RjAb7SLTt76kuHgFbxJT
         mPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707940948; x=1708545748;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XEQXx7Y35Qf8D7TyG6uRzyuGKFruUVm/oc04P25qS34=;
        b=k3GJtKgaR1J+hqQ4ihLIkER2jHKXfL5TVLgmxgOmBhPmXMj3LZYaAo/7CltYkrhzej
         nk3yXpyX8PzKG6KbIR6gvwIkHtj2tGhPtC0X4OUOp5ly2WcLfwhrnRYt/sSTPyqYQPf+
         pMlDgdBRxSsfCp7M3u23uIrmbdLZnyMOoSG1Yse/S0Hc4l4WN/7I4e/be5qlxVNUgdEP
         jbXMRiz33bLryJvWFvEEAVCObW7yDCl/yXQ41Uj1DqbB0eQ8vWGO/CuJgSXZIDpo1riC
         gno3c7P9IP01KAhHMq6zNoRq1qf83CSyeAfZttTIggchNoJlGCBNcsdRHgvhYnl6C0G7
         jsxA==
X-Gm-Message-State: AOJu0YwNAn3F9ZihoWtxrsiNp+l2c+FuPz+miXo38ptyoFbVsXw8oA+r
	/YTQryI3vpj/47NLOxvlg+j/QyrDa3MuwUb+HYyLME5cMl4ltivWg4oxyHZcLkVmMoIwnbNtFqS
	H
X-Google-Smtp-Source: AGHT+IFwInWM0cHcHfzqVOnHN3k41EFleOd7kIG+Brio7ef31RgvOEkg9LDIYCLgr4lv2ZFybhyvVw==
X-Received: by 2002:a6b:ec1a:0:b0:7c4:8398:ac64 with SMTP id c26-20020a6bec1a000000b007c48398ac64mr2856245ioh.1.1707940948636;
        Wed, 14 Feb 2024 12:02:28 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k20-20020a0566022d9400b007c46318b9ccsm1819117iow.14.2024.02.14.12.02.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 12:02:28 -0800 (PST)
Message-ID: <5ebc418d-9a35-472d-91ed-a402cd86d4f2@kernel.dk>
Date: Wed, 14 Feb 2024 13:02:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/napi: ensure napi polling is aborted when work is
 available
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

While testing io_uring NAPI with DEFER_TASKRUN, I ran into slowdowns and
stalls in packet delivery. Turns out that while
io_napi_busy_loop_should_end() aborts appropriately on regular
task_work, it does not abort if we have local task_work pending.

Move io_has_work() into the private io_uring.h header, and gate whether
we should continue polling on that as well. This makes NAPI polling on
send/receive work as designed with IORING_SETUP_DEFER_TASKRUN as well.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b25c2217c322..844a7524ed91 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -122,11 +122,6 @@
 #define IO_COMPL_BATCH			32
 #define IO_REQ_ALLOC_BATCH		8
 
-enum {
-	IO_CHECK_CQ_OVERFLOW_BIT,
-	IO_CHECK_CQ_DROPPED_BIT,
-};
-
 struct io_defer_entry {
 	struct list_head	list;
 	struct io_kiocb		*req;
@@ -2479,12 +2474,6 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	return ret;
 }
 
-static inline bool io_has_work(struct io_ring_ctx *ctx)
-{
-	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
-	       !llist_empty(&ctx->work_llist);
-}
-
 static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 			    int wake_flags, void *key)
 {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 1ca99522811b..6426ee382276 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -448,4 +448,15 @@ static inline bool io_file_can_poll(struct io_kiocb *req)
 	}
 	return false;
 }
+
+enum {
+	IO_CHECK_CQ_OVERFLOW_BIT,
+	IO_CHECK_CQ_DROPPED_BIT,
+};
+
+static inline bool io_has_work(struct io_ring_ctx *ctx)
+{
+	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
+	       !llist_empty(&ctx->work_llist);
+}
 #endif
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 8ec016899539..b234adda7dfd 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -122,7 +122,7 @@ static bool io_napi_busy_loop_should_end(void *data,
 
 	if (signal_pending(current))
 		return true;
-	if (io_should_wake(iowq))
+	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return true;
 	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
 		return true;

-- 
Jens Axboe


