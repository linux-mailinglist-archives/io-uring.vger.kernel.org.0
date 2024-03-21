Return-Path: <io-uring+bounces-1185-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EBF885B28
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 15:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41B16284CB4
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 14:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110D11E534;
	Thu, 21 Mar 2024 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Noey6o7q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9E884A51
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711032524; cv=none; b=qtCfJTgeUNUI/Uqbd4WXWDWlmszbJ8bjIyKSNm2A+sLoKtaa0HE6oYUoU500Ao5qUnhmDoe+x6ZyYRTMksfUoPmQ1kIhUMo4ZG9I6Mu00boEXpBwDgYxED2Y8Om5FLs6KEBkpF6bvJQyal42szo9ALeWDUNg/wkAE4es18gEBvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711032524; c=relaxed/simple;
	bh=5YqocHr5mxuGOr5Z0D+Jj5Z+RZ0wDYj67RIhWvHLoys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBTJ/Mo/I/4LnHzRv9r3NFX/zpEJt+0olxVydN/dO915gi2NC5JkPlDf7S8hgh5wI+mvxzUL/PI5phdYIPrb5nwpHXNoadteJ3uWI1m5R+6HC6OZzHZEW6yepEm4M8BOl3rWQqeApFNraWai5HXemc92nuZp6nF9rNOw7flmOpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Noey6o7q; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7cbf1751c8fso4618739f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 07:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711032521; x=1711637321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRbXBnmBssLCefthvGjqIke1i8J8DEDsrgn5OvhdPnw=;
        b=Noey6o7qlnScjTreK13c3Ghf4/1J12c4dDhWf0NHizfSc5Y9QpO1GbCycpkK1hOfEA
         OT+c12DoKqmD4D7aOTgf2eRq8I4kGko9GeP8CqK6JCDvkCJGgq4SFs1SrNne2OvvqVy2
         qEM0nL3A2bTwUo03lGuZgm1ZGLxPDNATu7J4diHl9D6czHEvCL2vD/fLJyiApWXF/LAi
         Ioeznh6HttjMj56H6uuvsMgOIlfa3S4TZ+DP5EHk/+Durm5tMHJqVVMyt05+AQT0Oumq
         hDBr1Q/z+HpEmdzZTgV38z6paFvQ0LGtOUUczlXF02ac6txg/Y+wjYF8+D+wzpY3C665
         wCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711032521; x=1711637321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRbXBnmBssLCefthvGjqIke1i8J8DEDsrgn5OvhdPnw=;
        b=gBFjM8mbM03cWahSOThoN8Slkm64hHzO+1Y3V7L1qIwt78Scmp72fipl4A0Wptisr7
         oCwGwuUL2e6dtsLQ1hrySBAnLBe+OldmNM61aogk6esVbuwx1suiy747/SUF5qwPv182
         LYIR75/qDcyMKAcAMSqX5kKe7BbpQ4YMmeEcfNkeBry0bnvPOZGBT6kcrNZqELJXxJCO
         pHhYfwRVFKIR2V2QfjqTUlCSlt3/EN60olOqCZP5RVH1ukbrwARzxSTXRHHFrY3715nM
         oAI2J5lW8wxUynL6yqsVBaDk+D5RWJa0PlopNKDbv+Z1TE0MQ5WczpeNlE9wFUbVUA5S
         VAtQ==
X-Gm-Message-State: AOJu0YzPgCqDT+No8UX0n2vvM8yyirjgL2O4pM2lXdw6JaMtPCCfa3m7
	1jk8wfN4oYHcO9omaPNnTsRZBj42NIYPlCs8+xwZU5MB1kREfl+UkgFMf4RLKxcKLqHFS4bgwuV
	t
X-Google-Smtp-Source: AGHT+IGLr9ZRVq0bYPMZavk/itpNjmFngKhn1FK3E0kH3rTwb1+1/ZdzN3m7BdEOvV+YO0lzI5eXyw==
X-Received: by 2002:a05:6602:5c2:b0:7ce:f921:6a42 with SMTP id w2-20020a05660205c200b007cef9216a42mr8072439iox.0.1711032521000;
        Thu, 21 Mar 2024 07:48:41 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q20-20020a02c8d4000000b0047bed9ff286sm250835jao.31.2024.03.21.07.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 07:48:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring/kbuf: protect io_buffer_list teardown with a reference
Date: Thu, 21 Mar 2024 08:44:59 -0600
Message-ID: <20240321144831.58602-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240321144831.58602-1-axboe@kernel.dk>
References: <20240321144831.58602-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, just in preparation for being able
to keep the buffer list alive outside of the ctx->uring_lock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 15 +++++++++++----
 io_uring/kbuf.h |  2 ++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 72c15dde34d3..206f4d352e15 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -62,6 +62,7 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
+	atomic_set(&bl->refs, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -259,6 +260,14 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	return i;
 }
 
+static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	if (atomic_dec_and_test(&bl->refs)) {
+		__io_remove_buffers(ctx, bl, -1U);
+		kfree_rcu(bl, rcu);
+	}
+}
+
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
@@ -268,8 +277,7 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		__io_remove_buffers(ctx, bl, -1U);
-		kfree_rcu(bl, rcu);
+		io_put_bl(ctx, bl);
 	}
 
 	/*
@@ -671,9 +679,8 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!bl->is_buf_ring)
 		return -EINVAL;
 
-	__io_remove_buffers(ctx, bl, -1U);
 	xa_erase(&ctx->io_bl_xa, bl->bgid);
-	kfree_rcu(bl, rcu);
+	io_put_bl(ctx, bl);
 	return 0;
 }
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index fdbb10449513..8b868a1744e2 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -25,6 +25,8 @@ struct io_buffer_list {
 	__u16 head;
 	__u16 mask;
 
+	atomic_t refs;
+
 	/* ring mapped provided buffers */
 	__u8 is_buf_ring;
 	/* ring mapped provided buffers, but mmap'ed by application */
-- 
2.43.0


