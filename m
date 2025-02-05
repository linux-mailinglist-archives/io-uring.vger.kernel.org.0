Return-Path: <io-uring+bounces-6268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F563A28961
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C66D718883D2
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BCE22A80B;
	Wed,  5 Feb 2025 11:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Khg0/mv0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670E322ACD4
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755414; cv=none; b=ucz/ChFjjEFQTh909IIKupxYHsb5X7UxNEfGU45P8k1cGS+2FuUymmrHbD/G8U+VWDduo5rPW8bCGRbuHJ2T5CQ+Bl24J5mcAEf7T1eVllaVztjUKmTcV8LjLDMqtzXz02eN6SCgtFepDfQmLc5+B085r+gc0zxgHl62ukqMwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755414; c=relaxed/simple;
	bh=iaw6TIBLlPMBaodBJtkdRTF4CRl/fopRKMMhD3NaP7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcwOtfeZOIYUzEjNG4eCYc+JTMGfNXz75tSi3MaaFB4M0kfckh4H0l/wTeah79AtfZC+Bdcnng3pQpp31w9DMVTnkMO8BzAJkYZhdIcq3bpSSjULw3nrVb94UQ9B3bM4gm8GxPY51758RSAZdaTq5ltzZqlT1ZhATVSzQ0OpzAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Khg0/mv0; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-436249df846so45733935e9.3
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755410; x=1739360210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHXTHoM8l2ZmKFgYXPBLo6mbwPh89FeyMs6aOYQdBMc=;
        b=Khg0/mv0NneRvqi/bD3VFXBGH2UAszysI66FlJT2JtxMvQ+EXyj3m7ye2cY3ZofQDT
         Tf26YvYzL9OJ9kbt/p+4WvWDGhPhmjHQ/WiXBOkgAOZc31iXnqE4J9I5MLfCNvE336xn
         fod+Q6f2rcX87g3d5h7OiCmEbfuiCi5xSAn+KepsqESO9zYcA/HIyeeqL1ee5Q5YTGZv
         /5OeBYXJQVja4MaWASDdNOambbtvIBiHzZKEPf4xWXpIHtrbQX4+FJYeSk4t/kobghhN
         Q5WxIwLPY5nmjreN3j0qbWBO4IJNlW7Q5lGlCiyApK4EL65LaUmXM3Agi2aZjTgWnDtN
         KImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755410; x=1739360210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eHXTHoM8l2ZmKFgYXPBLo6mbwPh89FeyMs6aOYQdBMc=;
        b=oqoN710BmqqILtDFSQ6i6I192zkTDXggl+o3/s3r+9lWZvJ2R5QHVNwvzYYQkEMFZf
         mqJPMEV71RBq3cl2uUmlCZWlQTBSaOzLRmvC/afYJvmiUPjTdF0/ns55vZz2UTcv9Dsa
         6PQ2iClKVmZ6+it+wkpUX3moN7V5kbhyEMdk0WyEk1VCvJCX3MQ3/DEOHaSgMN7Mtor7
         0t7aZAmDyyc0VYJJRINGpLmJcSf+Bvi3/hBR9PNKLJlt1rBZ0uelXfIG+UMrhPhOpKUd
         tUxa7T35uHbrhBuEZcTjyfiVHjCZ68p/EUezHdtVFrRNqkJPHVhvt15do8nLMrp0nnzk
         7uJQ==
X-Gm-Message-State: AOJu0YwJZJanJgpDnSRIVxmdE4dn4iQCwM6E30psqfgydkuSa3aT96pl
	q5KXTk+NM4uyfcobzOVt2ioIkEgl+AAF+nTpFx0Wbey5efUT+XLYqTa1Dg==
X-Gm-Gg: ASbGncsDXVGkDZpjoRUlpGZ8gC/RYxasma2vfk38hwhkLJFgtjH4ess/SwIQKugSEC8
	PANNsPCLO5nY+spv7JWyA88rnKxv7DXh4d5eQjUklS0thNdoF3JPH67xQGGgWY5y3o65ZwyHmf2
	/2cN+iP2DKgt05PKsDnOS5F6QGbjb2fj5/MPI0sf9hQ8ZFe1a4It2bSnhvdbC1mzVPYQshdJJ/i
	mOMVwbB3ttg8KEOVTJy5rB1+hIsJHTH7KuAAGBUsZsbwgQ04vfk7Y6IErbzqZ9iEncB5XaYJx7R
	iUX1hoOImYwgvvhOFDxZFDn7Is8=
X-Google-Smtp-Source: AGHT+IF5lKj1gvYfwQ6QbPjxTt9korXkWA3k++sXEiuGM6O092Oax29zRJdj0YVFDsxGgF2v/DDLXw==
X-Received: by 2002:a05:600c:198b:b0:436:5fc9:30ba with SMTP id 5b1f17b1804b1-4390d5a46f1mr18339015e9.29.1738755409934;
        Wed, 05 Feb 2025 03:36:49 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:48 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/8] io_uring/kbuf: move locking into io_kbuf_drop()
Date: Wed,  5 Feb 2025 11:36:44 +0000
Message-ID: <530f0cf1f06963029399f819a9a58b1a34bebef3.1738724373.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738724373.git.asml.silence@gmail.com>
References: <cover.1738724373.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the burden of locking out of the caller into io_kbuf_drop(), that
will help with furher refactoring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +----
 io_uring/kbuf.h     | 4 ++--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6fa1e88e40fbe..ed7c9081352a4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -398,11 +398,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		spin_lock(&req->ctx->completion_lock);
+	if (unlikely(req->flags & REQ_F_BUFFER_SELECTED))
 		io_kbuf_drop(req);
-		spin_unlock(&req->ctx->completion_lock);
-	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		const struct io_cold_def *def = &io_cold_defs[req->opcode];
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bd80c44c5af1e..310f94a0727a6 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -174,13 +174,13 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req, int len,
 
 static inline void io_kbuf_drop(struct io_kiocb *req)
 {
-	lockdep_assert_held(&req->ctx->completion_lock);
-
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return;
 
+	spin_lock(&req->ctx->completion_lock);
 	/* len == 0 is fine here, non-ring will always drop all of it */
 	__io_put_kbuf_list(req, 0, &req->ctx->io_buffers_comp);
+	spin_unlock(&req->ctx->completion_lock);
 }
 
 static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
-- 
2.47.1


