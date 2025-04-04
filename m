Return-Path: <io-uring+bounces-7406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A402CA7C172
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6317D3B8F8C
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811A820B1E6;
	Fri,  4 Apr 2025 16:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bFXHnCNU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC20120ADD5
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783673; cv=none; b=OPSQAv2YpBLIW8EwR6SI7MtNl9+29/9NnyG3PGSMi1f2g0hrsUuLYi6dkPu5T+ZP6fzm/pLhgGXZefcd2sJrFWGNP5ZIMDJi+2q8nqdFzOocJC53lGCo7e3JU/yEmN98pjxGaqVtb9WMAwFnS4fUzRc0nAe2UVL+1hy78pIMhUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783673; c=relaxed/simple;
	bh=5y+2BsX8Un6kP+AA8e0DO1Wa27hBqYXKRko/IGKIUOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tp9tCiJ6r0SyNjfKw0Cfu2wTJZnIfpfDpJdLODRIyPWoxcdL2e6TftOVx/HUoCPe8EAaznYmQt5b9P6LgloiPoYjU+YmoUsTCuKTV36j+jiec9S3s48/ZvOeSccUVC86sB/RV2sYyR7un3sQFu5oHHQNHTBu5JSoA7M2Q4RsmMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bFXHnCNU; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e677f59438so3516214a12.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743783670; x=1744388470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMM5qhvjL8gczQPyq62vkmefgWGt7CIYLJ+nMX+wd/w=;
        b=bFXHnCNU562uKSvbcR69eeUV3l7dCgsSIdNnCRNT/5AGBDJedOb7lHRaBghWpIn6Xd
         9Ql03rnX7bTThi+iBv0w9Bu1vu2PTg2sGaQ+6DLQBH+ethTR5OEcRtM46ypJ5EiPqIDO
         HBDSyHLNvojB0CKLF0BkD+V9EAwE8is7kbSM45RSx4xv24df8AfQZdIEtbboP1Wg6DN3
         cbONXeGrlqp+I8t6ZjyF7Q+957G5xIXZU7xRKyHeNv4lnH1Q2n8y9w0Hsrr5loGTKN9L
         7vVFUnt3vq32ur+uqpXPBo19FPLuhlXqhEmtQsMsn/caqHPeMLXSBgVw18fbEfFNKEZa
         UD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743783670; x=1744388470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMM5qhvjL8gczQPyq62vkmefgWGt7CIYLJ+nMX+wd/w=;
        b=Fc++upwv8AR6QUJF+Khe+80Fo0TUNL36k9xDPm7uZHJ0pvIIbwZJSQBg6kRWpMdeuS
         u4CIf2CwUrf8+MWmAq4VqmwLJBnFQFqrbSCFcuaSjOGxMU4gD0MTC+0NpvdwK1Y+xRYh
         I9aGgogvl8H5hjTMI1yrawvJcBndhB7BCPqNzkgHsjFtwqQ6lRhxvad6aseXau0f1uVk
         /3g52gZ9Oy476h9OwhQgEmJCTDonGgKcceAeyADrjuO+6QsAFnwnUDwLiCnVgzNT3W5Y
         Ut4FiMifVO1wndI15xubBCvlziop79GosjmIRtD0KJhCcbT/7dsX4RdFI1aW9DDjevAq
         xBBA==
X-Gm-Message-State: AOJu0YwWZaxCyditG9Bry+ySOhSIR1wDk7piHj/1iU/llY+ELb/41U5j
	8nv9iapE09YiNT2hrvsp7VD0GB0pMQVk0biJozfDpXBHfmPmLcb281K+mw==
X-Gm-Gg: ASbGncssvtTedC9i7PIE6OhYLJFk/+jt1wOoUPt4ki4y+mfJgkZYPvsx9htbxX+2cth
	Po/e6X025djLCouNiXvvjDGLptrZmNwDFikZCoy5JD6MJ76O+SxPvmPw8zh1uABLcp4KtgxyAf0
	XhA7T9aOZ4TUtYOYl+MDXk/vj0RaTDbcOCefXliQNNUzoTs6zIKlVGxySUtkYH+gSM+VZL+s8P5
	FpykAX1qAiFx7qo3OWSE7l4VJibq0q1k1lvM4h6KlocnBG0IqkZ1ER6+VNSZNMaLZVmP9jvpu33
	JQ4DPrGG4fIWjFGgs6MbNCMOhe7Q
X-Google-Smtp-Source: AGHT+IG74HDo6IN0gy3Pz7rnvR8lm361TUACaEWj38MMdiWE8oDRbhhA7YilrOJDd/O5x9vSetqgug==
X-Received: by 2002:a17:906:6a1e:b0:ac6:f6ea:cc21 with SMTP id a640c23a62f3a-ac7d6e9fe32mr277373766b.55.1743783669526;
        Fri, 04 Apr 2025 09:21:09 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0184865sm273316066b.124.2025.04.04.09.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 09:21:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: early return for sparse buf table registration
Date: Fri,  4 Apr 2025 17:22:16 +0100
Message-ID: <11655e617b90ee11bf95bf59b2cdc433d9448056.1743783348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743783348.git.asml.silence@gmail.com>
References: <cover.1743783348.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need to do anything after io_rsrc_data_alloc() if the goal is
to create an empty buffer table, so just return earlier and clean up the
rest of io_sqe_buffers_register(). It should be particularly nice with
IORING_RSRC_REGISTER_SPARSE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d5e29536466c..958eee7b4a47 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -867,28 +867,28 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	if (!arg)
-		memset(iov, 0, sizeof(*iov));
+	if (!arg) {
+		ctx->buf_table = data;
+		return 0;
+	}
 
 	for (i = 0; i < nr_args; i++) {
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
-		if (arg) {
-			uvec = (struct iovec __user *) arg;
-			iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
-			if (IS_ERR(iov)) {
-				ret = PTR_ERR(iov);
-				break;
-			}
-			ret = io_buffer_validate(iov);
-			if (ret)
-				break;
-			if (ctx->compat)
-				arg += sizeof(struct compat_iovec);
-			else
-				arg += sizeof(struct iovec);
+		uvec = (struct iovec __user *) arg;
+		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
+		if (IS_ERR(iov)) {
+			ret = PTR_ERR(iov);
+			break;
 		}
+		ret = io_buffer_validate(iov);
+		if (ret)
+			break;
+		if (ctx->compat)
+			arg += sizeof(struct compat_iovec);
+		else
+			arg += sizeof(struct iovec);
 
 		if (tags) {
 			if (copy_from_user(&tag, &tags[i], sizeof(tag))) {
-- 
2.48.1


