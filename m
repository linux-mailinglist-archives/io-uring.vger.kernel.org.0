Return-Path: <io-uring+bounces-10410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C90C3CB8C
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB1FD625A24
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F311333A01E;
	Thu,  6 Nov 2025 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/5sfAlE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26658343D8C
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448525; cv=none; b=cnhQR3I43i9no5SIOVzb9tLJvQBEmz3tIfCll+4upDJvt51VtC6yQk93JLtr42joBQh45XC+p9Zl7q0ywvxhG9cAPyFKWsq92j9feUdVb9x73Xq9QIHtTKl+pmX0M5PicSnhSDGm48ClNZBr4t2ypubp2IP/UrguG4t31VK1Drg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448525; c=relaxed/simple;
	bh=9NTgZ0t8r1n8LHywCbqbCz3C6KDyDILzg+rJ8UBMHlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/VwH7s6nJ4G+GYnEb74iL170leqmUa+84426GSoscKivLsW+niB6f/9O/9yRPQg/lg8ubag7hB4w0Wi7UiPJrAKLylQvj3lN6c9JtzymV/8k+OLRutzEePfJ2Z2aR6tEgdQMINQ3H+LdDkKqWuUHLSMfXamTTKKB6sFxMkBOjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/5sfAlE; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso1346367f8f.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448522; x=1763053322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1eLDIq5oKOvnJ1TCypbeZpzu2T3xtBvZAslpRzCVyiA=;
        b=C/5sfAlEfmL5TabZpAQEiVr5RIahErezveLK53+uUqc0mfUFrCgMsOJQzCmRFxjENZ
         FJflRqt241K2nuA8GzWfKsH7uUInP+RUzW+ebKLW6P6HvTdlK2T22EZUUvSmWyjBPW4O
         BxfwjUJS3yTnTvvGC/wbzGksrqyQLLFDRqr+zCWwksYdn6/HSaIZCjgEA+BQ7dgVWuOk
         HeB6vSF0vKCVcD7Y96HBeiEGLgmB4to+Otrl20z/hyWWrSC4AMwumxsJtzo+MHY+oVQy
         js6465oZNQSqhBy0uloc5/evmMWlJdJiweEjfbX2hHdwW+TJaai5Z+Rqp0RanHcefd3L
         3pxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448522; x=1763053322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1eLDIq5oKOvnJ1TCypbeZpzu2T3xtBvZAslpRzCVyiA=;
        b=imT5GbffTrCum7a3u6IVKCbHsP3Gl11sSI+AKIkMR0yhVRtYOEIjjYI/yo6J9lMnRl
         WGp3BFG07VnvCkvtE+TKqR9wqXR4tGeqgFgTnyHscXD2mBLOKuxAr7fSO3uyc9LaJD0d
         WGhZsL06m1ey4pkT1cN6HAvdWaGYXYdB3u+QxOZd4RfDiu202FAVloRqKrdfKpsXodak
         IDms4iXML74KvBgm/jL84z1hCuGKHHbj5fuwIiZlRPO7fUNy0GEyRA3yC5Egk+KZU44I
         rYXMCM65+B1EnAf0vmVPc+ygSRMRML0P1alLDoWz7vlPjZc3Kc7G7ntX7e+/v0Xsji3k
         gR8Q==
X-Gm-Message-State: AOJu0YxG981XqsATPLpo0ztwuZMMYjKvRrmullzaaquub/lVm8iWcIZd
	BfHz5Y2BZ41qxw+tfkaslA0ec44v0znD7Mho2tZPOa8wZo6wnBui9dbsAMp6Mw==
X-Gm-Gg: ASbGncsJOQoAaZmctxrY/0vfmg13Rkaj/dVevLuAbPuBtb6k/3GrI/CETr3EqI5sgRS
	Mg0opINva1OaSQj4Erh7GuOSpl3CMQ0vGRJCrnnficE/ET+zLt/wvgvPSsEtg/JrOeAIyGuKOrk
	l905M6hXk7H9W/GooYHO2REj+zTOJmPs+XIYuShO3hE4+SfsgtQleu+wZQvUBs1eDr4WV4P9nPe
	IN+asduEgXO+NyylaNWPg++49U42XvimREGc3OJsrhJYyiKypH0t6lNc58D2/VtBkUn0CBar9vc
	YO84doUQmaK8UFnHgUAfeKr32WKoP+dhoMXzJCxslTSorYtDwWpyFADNm4WlNb0gSG7VZ7Li20r
	J6IzNQlGyjZ2XenoI0xMJ+Ag/0yaydCTlmGCNYgQo4Cq4CdVeiDAiU6EA/3CxW1bMwWV0XaDLUX
	zBRVviTyQkrSyfCg==
X-Google-Smtp-Source: AGHT+IEswRR7sfavsACyXEhSJe+me/m48A3KqconbzqtoEhn/4QMsu8HRqfehXidU8LLRBLBpTy5Cw==
X-Received: by 2002:a05:6000:2c0c:b0:429:b963:cdd5 with SMTP id ffacd0b85a97d-42a9574b8d1mr313506f8f.5.1762448521564;
        Thu, 06 Nov 2025 09:02:01 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:00 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 02/16] io_uring: pass sq entires in the params struct
Date: Thu,  6 Nov 2025 17:01:41 +0000
Message-ID: <bcbf78585db0ffe72be4753a2fa208e14b7158b9.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to pass the user requested number of SQ entries
separately from the main parameter structure io_uring_params. Initialise
it at the beginning and stop passing it in favour of struct
io_uring_params::sq_entries.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 +++++++----
 io_uring/io_uring.h |  2 +-
 io_uring/register.c |  2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f9f8ffcdad07..eae1ad3cd02e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3484,8 +3484,10 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	return 0;
 }
 
-int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
+int io_uring_fill_params(struct io_uring_params *p)
 {
+	unsigned entries = p->sq_entries;
+
 	if (!entries)
 		return -EINVAL;
 	if (entries > IORING_MAX_ENTRIES) {
@@ -3547,7 +3549,7 @@ int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 	return 0;
 }
 
-static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
+static __cold int io_uring_create(struct io_uring_params *p,
 				  struct io_uring_params __user *params)
 {
 	struct io_ring_ctx *ctx;
@@ -3559,7 +3561,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		return ret;
 
-	ret = io_uring_fill_params(entries, p);
+	ret = io_uring_fill_params(p);
 	if (unlikely(ret))
 		return ret;
 
@@ -3698,7 +3700,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~IORING_SETUP_FLAGS)
 		return -EINVAL;
-	return io_uring_create(entries, &p, params);
+	p.sq_entries = entries;
+	return io_uring_create(&p, params);
 }
 
 static inline int io_uring_allowed(void)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 23c268ab1c8f..b2251446497a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -136,7 +136,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 
 unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			 unsigned int cq_entries, size_t *sq_offset);
-int io_uring_fill_params(unsigned entries, struct io_uring_params *p);
+int io_uring_fill_params(struct io_uring_params *p);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
diff --git a/io_uring/register.c b/io_uring/register.c
index 1a3e05be6e7b..0d70696468f6 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -416,7 +416,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	/* properties that are always inherited */
 	p.flags |= (ctx->flags & COPY_FLAGS);
 
-	ret = io_uring_fill_params(p.sq_entries, &p);
+	ret = io_uring_fill_params(&p);
 	if (unlikely(ret))
 		return ret;
 
-- 
2.49.0


