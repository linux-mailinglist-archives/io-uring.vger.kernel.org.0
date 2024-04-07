Return-Path: <io-uring+bounces-1445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 398E289B4CF
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E80DD281694
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 23:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39BA446B7;
	Sun,  7 Apr 2024 23:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8JtKFhf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4112B44C66
	for <io-uring@vger.kernel.org>; Sun,  7 Apr 2024 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712534108; cv=none; b=Xipu/ahnEGHHkBalB+SaIRaByWvKMXmO818JbEavZml1ipqifQTvBaGv81g+itnBYAa4pXTrD9ewnk7ho162mRapOEjr1tv/GfAZEvKd/GdTBiBMxLigGM7GT/TOtj/kzfO29rKrPHeQuUN33bAp1bbJCho0/xl0oOWPHOqHHhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712534108; c=relaxed/simple;
	bh=3kCMH0ACLdTS384DAuk8JFWQo3UjoeGuJU/v6ENx5Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9mrPND9DgJR52Gerv3VC2zfiXbGeYPEwzVIlfaICCaklu3smojXrzcpNzfJnIn2SQh9pZnAWZGScWXeuETWYEiCXmYlkL705J084NWeBXBByzYYt2ZXsgj9kI1dMfIgc1aM3pE4c0dqCbzWfw5pkh3FqFXu8OT+JMZpf3ofoY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8JtKFhf; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-343c2f5b50fso2535348f8f.2
        for <io-uring@vger.kernel.org>; Sun, 07 Apr 2024 16:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712534105; x=1713138905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4K5QLsSxtlQn1+0iQwF6GjQQdcTbU/MIQGGYaNQpeY=;
        b=k8JtKFhf31iDHPBoWxz7O0PzZNsLPIXHKIVfvepo6Fn3SLIIseeH5D88REeI9VcSdH
         HxLVk6SP2aN2kMPYPj5/PbeQLE3Wh8GXBCWcC4/vU59yeG3fSaIcT5V8bPsilqNvfMz7
         cIyXg68X1piuq+tuaBzUqoDYOgYYsUHiuQ+U1V7YBsvnZCDJLkK2k+8WHuezOiLbGwcq
         rXfYGnJCg/9ZZL7k+u45btJP248pTDw5HCSViocHT4oH3Q7U7rcgMK44pCaYacp+Mq4m
         8u/mgUp/L3BiKk90pXedqiQyxjFPS0wrQshyLNwhOppWx92nIZYR04U/rAfzX526W+ie
         zz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712534105; x=1713138905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b4K5QLsSxtlQn1+0iQwF6GjQQdcTbU/MIQGGYaNQpeY=;
        b=BMm+ouNCWbmBELfvzD4n/Nxz5kFw0kCoODmtfmXWBE5+tpI5dof7E20CvM5IfD+qmQ
         SSEkWCZpVSqFFFym6TMiYvOnvrn+T5H9VjvZvRnjmd8mPEWkBqX627tEJpEc8LClgn97
         VLj+7HnQYhhC8ShEQMKeQ/LHB6UvAO0R6aUXZWaAV7LOgCZLuyKiHQ7eGxtxew5D4QJB
         mNe783smWxO3gazukhwtLxT4Jxo0/r3NJZNigEKNMbnPW3baLOd1AMh2b+jPWKpdHCHa
         HIsYl1lg+mRnk+Sz4CcsciD8Tof5QKcqa8O6p/jFpwe8evsdLOLaR5C6tMXGTnY+8BtY
         2QTA==
X-Gm-Message-State: AOJu0YwU0gZUcO6RQBZDHGc23Vo02sWRGdU5ysEQ61qMQuf0jPhhXg9e
	yOsFDDzpheCwoQLsvHeLZjTJexxIKB+Gt9t5f6FbseRyMdJo+AJ18RhKIWX0
X-Google-Smtp-Source: AGHT+IEB5qvaYzJcPbXFLsgtIzjJR5GXaUbiIO0RDzAVJontetwlz4FkkFA7T4rWtj8ItyJ2M0Ns4Q==
X-Received: by 2002:a5d:64ec:0:b0:343:98da:ad8d with SMTP id g12-20020a5d64ec000000b0034398daad8dmr6233829wri.46.1712534104993;
        Sun, 07 Apr 2024 16:55:04 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id je4-20020a05600c1f8400b004149536479esm11302917wmb.12.2024.04.07.16.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 16:55:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 3/3] io_uring/net: set MSG_ZEROCOPY for sendzc in advance
Date: Mon,  8 Apr 2024 00:54:57 +0100
Message-ID: <c2c22aaa577624977f045979a6db2b9fb2e5648c.1712534031.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712534031.git.asml.silence@gmail.com>
References: <cover.1712534031.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can set MSG_ZEROCOPY at the preparation step, do it so we don't have
to care about it later in the issue callback.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f97014566b52..5e153a3f89b1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1051,7 +1051,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	zc->len = READ_ONCE(sqe->len);
-	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
@@ -1168,7 +1168,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			return ret;
 	}
 
-	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
+	msg_flags = zc->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		msg_flags |= MSG_DONTWAIT;
 	if (msg_flags & MSG_WAITALL)
@@ -1230,7 +1230,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
-	flags = sr->msg_flags | MSG_ZEROCOPY;
+	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
-- 
2.44.0


