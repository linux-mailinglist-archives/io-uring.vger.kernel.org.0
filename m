Return-Path: <io-uring+bounces-5143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB289DE7AD
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90DA3281728
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BF119EEC7;
	Fri, 29 Nov 2024 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqQruVIA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC631199E89
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887249; cv=none; b=fu2gfy1wtHELEd7h6bg6iU+8bQbqJnJLMFM9hl2ItB+TJwR69OK1HyZeqZfnF3BRaHSZQvcYmRc3lNqVb6LK48SbCTdHypu4yCCeHiN2xaABUdvJuGXYIJYTFh8HMom48kf031d+X3RMqNMZ5kQSRIVwmhJHP5BkNDHQs//lqwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887249; c=relaxed/simple;
	bh=iqfLB8sficjS/V1C04y/Ou0SPGoNKMo8hL1DOmsxXA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksi1awDABaRKEkBHmLu1phS7kAEtzCxj/C9R2jFleZKEIPIp2hX4m3LInn3RJDboTPYF8Z9W3yy1pYFbk10ibjH/LcD9RAZWQpbL7MJl2hga44FsBUms43QEnqtLsjC5DjLv42axTdg8PEI3rlgqlM+9l4yC1qt7n3TWY2mF17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KqQruVIA; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso230067766b.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887246; x=1733492046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KpTM6PFXgXiDtw0Mod4ajmUlWu7jNN1si4S9/CIBNRg=;
        b=KqQruVIA+IOBSQolFTq+9GjsGD7rM8lJY9EJAP/HQ7NpoXS5PZahcL3ObhXU0f+2a0
         ipROwUsrNEQ1yO1aTPTN+TZOlCPSfU4/mZvYkjk1bKp9LQa2lNEtNRVvMATKVwX8mFYO
         k79cl6lPrKDavOGoNyYjzrWYjUkE55NW0yxI9o98kXHe6O5pxJ+XWmgBwx5s77figiBb
         3ZJbfcdGTLX+aZr8nmwm0P7SDFfigFWaD2hd3jT6TYnKXiC7wmnPxvj6x5ccdx0l+plR
         lg7nSebYuqATYqwZCxiWcf6j1B3jJOciZ1Hvgmx9ZBiLxqWDlo+5AOeJjCx6za2prR1m
         2Vuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887246; x=1733492046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KpTM6PFXgXiDtw0Mod4ajmUlWu7jNN1si4S9/CIBNRg=;
        b=CCnBSqZ5ceXNZunQc1iuWOu9yWLmMyDbaK5hXl0vM8uG98C2Ow4W0q3LXxYA90ax8h
         sx8FVakQJFBGAC0ycfSaO4VAn1NieoFX5Rf5yNLqkAwK7cU1qQCgJqo01Fre2yjStskS
         Vzt8xJeREem91wD5dW6i6kGUEjG9CdLsx16zglwu1ja7OdJK4bLnsqK8zOSOBkKjOZts
         FmSCFhfJOB+K4Hsxm8/+y9SLfgWmZJyF1kpp4CjZ4bK26VecwEY6RH2jwnfFx1hHH5/V
         R780so/xJAhOxGWXUYFgFigy43mmAUuOhiA7SFZKxgE+8UGb98becPTyc36/npOVC7GS
         dh5A==
X-Gm-Message-State: AOJu0YxEGWYGxhDAYSwAvUKGpzw7XmJ6vAA6cXxrON+xftlmzhdjDRaQ
	j871BeA3YOajPbyjxBYPTTuKXpIABYV0Rq0JL7+0tXP3LkHOPreJc2bpXQ==
X-Gm-Gg: ASbGncs4mJ2nLeT5Rs6Bdzh9sjNCRfb2KWdHG/yWrlnb2i19oZYqtofISfpfRvFcHXj
	Cq9y+dhrI6zNwOIVA4oT8YwtvlGz0QQlgfb0igzi7g8UqBK4yXVKBIqKJDnX56isvsOoz9byxbs
	6RWHYTbVMjJQaww7HWZtCjjy6jbqru3/zJ6AOrr8amhIaxGT2xFXcdpMH8xU50hBwirpd8TsMeG
	kLZzEG+xJniwn77cFrb9GaG/6DGmZDGnAZPG+MFgA74GmQUZeIWffKsk92AxNyt
X-Google-Smtp-Source: AGHT+IE6siFo1oMQ5z2s5n2TnNosIgHmxu1kOmt+oxSesA1vEM2wGQKBK1+W0JyyztNsHaX4+VU0+A==
X-Received: by 2002:a17:906:3cb1:b0:aa5:3663:64ba with SMTP id a640c23a62f3a-aa58104414bmr902482866b.43.1732887245676;
        Fri, 29 Nov 2024 05:34:05 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 12/18] io_uring: pass ctx to io_register_free_rings
Date: Fri, 29 Nov 2024 13:34:33 +0000
Message-ID: <c1865fd2b3d4db22d1a1aac7dd06ea22cb990834.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation patch, pass the context to io_register_free_rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 5b099ec36d00..5e07205fb071 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -375,7 +375,8 @@ struct io_ring_ctx_rings {
 	struct io_rings *rings;
 };
 
-static void io_register_free_rings(struct io_uring_params *p,
+static void io_register_free_rings(struct io_ring_ctx *ctx,
+				   struct io_uring_params *p,
 				   struct io_ring_ctx_rings *r)
 {
 	if (!(p->flags & IORING_SETUP_NO_MMAP)) {
@@ -452,7 +453,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	n.rings->cq_ring_entries = p.cq_entries;
 
 	if (copy_to_user(arg, &p, sizeof(p))) {
-		io_register_free_rings(&p, &n);
+		io_register_free_rings(ctx, &p, &n);
 		return -EFAULT;
 	}
 
@@ -461,7 +462,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	else
 		size = array_size(sizeof(struct io_uring_sqe), p.sq_entries);
 	if (size == SIZE_MAX) {
-		io_register_free_rings(&p, &n);
+		io_register_free_rings(ctx, &p, &n);
 		return -EOVERFLOW;
 	}
 
@@ -472,7 +473,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 					p.sq_off.user_addr,
 					size);
 	if (IS_ERR(ptr)) {
-		io_register_free_rings(&p, &n);
+		io_register_free_rings(ctx, &p, &n);
 		return PTR_ERR(ptr);
 	}
 
@@ -562,7 +563,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 out:
 	spin_unlock(&ctx->completion_lock);
 	mutex_unlock(&ctx->mmap_lock);
-	io_register_free_rings(&p, to_free);
+	io_register_free_rings(ctx, &p, to_free);
 
 	if (ctx->sq_data)
 		io_sq_thread_unpark(ctx->sq_data);
-- 
2.47.1


