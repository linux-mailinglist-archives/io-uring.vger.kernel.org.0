Return-Path: <io-uring+bounces-7968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A72AAB5B29
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 19:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 741A14672BC
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 17:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764EF2BEC26;
	Tue, 13 May 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDDO/fs/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE5C1F94D
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157157; cv=none; b=GFKXNfR1zNcvGkjHAChtw9qDtn3sztyPa9g/ACnrI0MtbRmZ5NuLYrzzD674v7u1UyKrA3xQQWWncoW26zHNJq5wZHuzgIL64qlvyLvu05+iPmInpafNDol1qPbN4lZrg/rDeqKNFstapDkgAwlNvAv6b8se4/Bb2+qHyV6wpUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157157; c=relaxed/simple;
	bh=+Sf298Df9YustBGjYr49AzZisSIzCvjy8TZtkf2wfWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toe846e6GKTHnXGH/CHUTyH4hthwTQWbznF9WK66MGNDFK4IZDr9LlEwy6g6EzIB2BGgQu8yLVvV9PjzVz0Z9saWF4geJ4zuk2+n1cj1csMA1UALyKCwnwoWoOem0UEPM2M1BI+WCxG7lC5QAPAFk1OT7BOoLbwu23DqLcpYzpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDDO/fs/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-442e9c00bf4so13746285e9.3
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 10:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747157153; x=1747761953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQGm7FKO3LYNpy/8HimQvU3MMhsXVTdtH4OxBot09Wk=;
        b=lDDO/fs/PNtcTegn7Rtr4BRcEdW8+lMg8Cu4bKs+2XQZpDeGG3XzG/H1BlDyn0lqsQ
         CGe0Chj1DIpNofPWZkqNNpObBNw1nY66qj9CIkwKwqehxWGejyS2Vyu5JY2hDh0jzprV
         njo7CSwgn14cb9NysAN8jnWZ5MvZUhsR3mYL6yCnPmfaBviISjApeGR8Ul/yOB0TYUI1
         NY5ZJ1RiVLrJhSN/nhP+iyBokMAbCjxpC+VHqup0+1cpATqD/aQemjsm7tJQXNjcC06P
         JTZ2OA6Yw+fVVYcjgG3+tavXm4ajc01XEW0XnFFiQ2QCpzcmE38ToWd656X3HLGejdzM
         SenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157153; x=1747761953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HQGm7FKO3LYNpy/8HimQvU3MMhsXVTdtH4OxBot09Wk=;
        b=Exj7Ry3BzonALkjUvVz1CY58x9ZS71HxO9MLSPZ59KfqTzObon9qcMpd70HwWED41P
         KBfdDNAtXEkZ/U/xRnyW3lG/G29VL6CTnazCHGtZhJxo2p4C3ZZzNxBh7YIMVir2X11S
         3m2ppzaT89fiXzvMecKQBlImKycR2fGDdoOUO06MUSc7Ot9GxFd7YKlVlbRGfO0s5dqr
         Jv9s1M9SHgvJrrMjVZaEnC01dBqDu900lPTyqIakL7CfosqdhtbrZOaRU4+PGMrEoLJR
         L1lIyArDr3/qSLusunKrJ05RXbrp+Pirco8ybohIMgJtT/K/Tfpcgf8sA+LSz9hysMRK
         DmkQ==
X-Gm-Message-State: AOJu0YxS10N9aoOnll7ShA92IiFWzOIZ2As4JUqQCi2mJHGvcGK8rJ2O
	zbwC08lGJ46Sz8Rt3oVen7r/QaYebNc/doCObziPYLflNwBYImE07YA3ig==
X-Gm-Gg: ASbGncsUi6XHn0VBAijh17mcn7dq5ktGo6clPGO8BI+cu0NaGJI13m3tPSucNNBPMB8
	04TTaI8unqDr5qw4TnPzxZbKSWp5JmWglxNYrwZ6fR6zxPEAuOTNvQ2HgRkL4xiccKSZwjszTNx
	rpEDuk7ca8U7A2lJ9EeeGsTGcHsSBlDsDMKXsQL+AOhL/koG3+U1Jni6eBGn6u5ZfxlXR/szzZ3
	9XoqLF9L3+44RZrSyPdIyot7SitvHdMcghF60FKwsyoprmwgxo8w73oRNFrVdifsIYNEhl4LTvS
	MNfWIM+BNFAZwK2hK9I3HkgU7ELi0uQDrBPoBVCntzVijpSf63LExweJwoV0GYfBDgtEzZhXl6c
	d
X-Google-Smtp-Source: AGHT+IHBljc8ddofGMjt90+FOJKvZsg/NG8tHejh31x2db+T1wZrhxMe1fL51Wod+/db467x2USRvQ==
X-Received: by 2002:a05:600c:4e8f:b0:43c:fffc:7886 with SMTP id 5b1f17b1804b1-442f20d6d5cmr1787125e9.8.1747157153231;
        Tue, 13 May 2025 10:25:53 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67e0ff1sm173034745e9.14.2025.05.13.10.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 10:25:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/6] io_uring/kbuf: refactor __io_remove_buffers
Date: Tue, 13 May 2025 18:26:50 +0100
Message-ID: <0ae416b099d311ad23f285cea02f2c94c8ae9a6c.1747150490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747150490.git.asml.silence@gmail.com>
References: <cover.1747150490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__io_remove_buffers used for two purposes, the first is removing
buffers for non ring based lists, which implies that it can be called
multiple times for the same list. And the second is for destroying
lists, which is not perfectly reentrable for ring based lists.

It's confusing, so just have a helper for the legacy pbuf buffer
removal, make sure it's not called for ring pbuf, and open code all ring
pbuf destruction into io_put_bl().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index eb666c02f488..df8aeb42e910 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -376,45 +376,33 @@ unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs)
 	return ret;
 }
 
-static int __io_remove_buffers(struct io_ring_ctx *ctx,
-			       struct io_buffer_list *bl, unsigned nbufs)
+static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
+				    struct io_buffer_list *bl,
+				    unsigned long nbufs)
 {
-	unsigned i = 0;
-
-	/* shouldn't happen */
-	if (!nbufs)
-		return 0;
-
-	if (bl->flags & IOBL_BUF_RING) {
-		i = bl->buf_ring->tail - bl->head;
-		io_free_region(ctx, &bl->region);
-		/* make sure it's seen as empty */
-		INIT_LIST_HEAD(&bl->buf_list);
-		bl->flags &= ~IOBL_BUF_RING;
-		return i;
-	}
+	unsigned long i = 0;
+	struct io_buffer *nxt;
 
 	/* protects io_buffers_cache */
 	lockdep_assert_held(&ctx->uring_lock);
+	WARN_ON_ONCE(bl->flags & IOBL_BUF_RING);
 
-	while (!list_empty(&bl->buf_list)) {
-		struct io_buffer *nxt;
-
+	for (i = 0; i < nbufs && !list_empty(&bl->buf_list); i++) {
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&nxt->list);
 		kfree(nxt);
-
-		if (++i == nbufs)
-			return i;
 		cond_resched();
 	}
-
 	return i;
 }
 
 static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
-	__io_remove_buffers(ctx, bl, -1U);
+	if (bl->flags & IOBL_BUF_RING)
+		io_free_region(ctx, &bl->region);
+	else
+		io_remove_buffers_legacy(ctx, bl, -1U);
+
 	kfree(bl);
 }
 
@@ -477,7 +465,7 @@ int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		ret = -EINVAL;
 		/* can't use provide/remove buffers command on mapped buffers */
 		if (!(bl->flags & IOBL_BUF_RING))
-			ret = __io_remove_buffers(ctx, bl, p->nbufs);
+			ret = io_remove_buffers_legacy(ctx, bl, p->nbufs);
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
 	if (ret < 0)
-- 
2.49.0


