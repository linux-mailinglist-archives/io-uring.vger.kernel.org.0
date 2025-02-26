Return-Path: <io-uring+bounces-6786-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C63A45D64
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:40:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69AB6169C18
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447512153D1;
	Wed, 26 Feb 2025 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwrqWEqY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738762153F0
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570048; cv=none; b=devLdtTGy1qb/btQHEiUr4wE/9ap/JJfjdAqzZgnxgAIhivdWNCrYyHH/la2cQbMOqU5o4clCHWc2tSKt1VIshh63Av1CYJatak0wLx7yTdSLLaOHVLAGDSjtM4Ch+bVeWOW7bh/vziQ0Wdb1qm2XnxoB24myRixaJRL7WcfNvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570048; c=relaxed/simple;
	bh=K5wqmtjAIu1Q8YZOIlGwSGOozfn6OjTt8K3q2ZLDtzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M30iRGPXUvNGwzaoyLurk/1O9MzBdA5QZgZtzkZU7GRy4naWKsf1fHl7EsRJNBQJW1ARkj+KloDgFXSwduR8ewd+grExxJiW6Tjrkn9UvuWlq/IWUENgc4C0PPNto5KS8dMt7BAs1kH2j6SFZHqayMadrP+dS1cGIufya4XyU+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwrqWEqY; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5deb1266031so12185504a12.2
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740570043; x=1741174843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AY/GD7BWTRCQXLBYMXkRaYEXNHAXYnnP2VHqb/Vhtds=;
        b=iwrqWEqYjbhlKrJqM4JVN8+4JmTfr3qfK+s1xEDfo9aulyiOTwDrhXYFR0OQDw1Eeu
         uAPSJKlXqNaaljDu9QfRtV7T9Ngpg81IfxF1n7fVTzS4uxGVwmbYrAfLcTejw7rjVcvV
         jaQj+MdT51X3eR+8hQY1LDU7ghIqyWVMAXO2Asue8+Kwq9ykCNwTXbURpC8r93IJDPiG
         lUBbh14XOG5WIUi0Gix1z/yeS4FTKX+NTCKRDDMcgY85vtfL8ZxlXLkQv7N8Zd1nhh4F
         vW0ZWUk9iwou+Ny3bAFvIPOf+ggWMlmG9NWFqhbXxY29VNa2cnkduls7LlRS2Nng4+T4
         7NCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740570043; x=1741174843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AY/GD7BWTRCQXLBYMXkRaYEXNHAXYnnP2VHqb/Vhtds=;
        b=cLT+3AJ6zNuNLuQbhoEOHCotTJo58WQjgYbzRijmCu3zZR4BjZks/Ck129T4WNTSGS
         Z4XkVwjJDF1ZibevN8z7vyzpKVlLF2sttgtnJkMjiViZNK/rOHx+J/kkaXXn8FJDAWzl
         2T4/SPbBIzspheXcJvVkkSUowjfbAEgtxPjlEoE7bCPcghlTB7POXx4ONbYWYQngSHBN
         yOlCBhYfTRicAUPhP4VGvmjECPvwwPWwBL4YJey776e6KbYQI6b06dpf2jnEkqTJVXZa
         KTAd3GPmL8nw3u6hUv5lCDVkat/w9RitAmP8mBf1ZRDfWLkennWGurGCqzDvlozwTQ5V
         1D0g==
X-Gm-Message-State: AOJu0YyHyZVsJ3AwwCSODSH+ThAwFg8w18i0v8c50amIH7MfZ2wFXk5g
	eeta9pOGn03t6ry3QlcDschEq7FgibzHPvfu99dfaZK9Ae8o4Ua4zOr3PQ==
X-Gm-Gg: ASbGncvLaMDwzii6880wJx+/PWlNJUosjiTkGt3iUZxvpxOIbaoR86+2DXFwPjR135g
	FO5DKiTicz/4OzXBMcTtlC3qHRmuQ8mQJnyl361JwVVZ9bQkg2BzgM/Y3ZJefOiX+0L4OOOzEs7
	TVnZFfqiBOn5KV/hCsJnicwJ4LtqH8RbAVe/X0VoO3Ux0gzcKyN2dd6ZFwxEETfXUd/a+P6e8Ym
	dKTn/D8p21fxR19wBvcxKsBd1uhRheE8dsGConkmWubG3VwC9eJ3iZReZByYopW1IRdiGOcliWq
	dINvE0SKfA==
X-Google-Smtp-Source: AGHT+IEtMmUSLZ/lUbTw2llTTM5a3LvsgSq+V6tAAH957GCmzdrtEXwfvZ3n7eSWj02wXIMuRNmVcQ==
X-Received: by 2002:a05:6402:518f:b0:5e0:51c0:701e with SMTP id 4fb4d7f45d1cf-5e0b7254f98mr21055638a12.32.1740570043245;
        Wed, 26 Feb 2025 03:40:43 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45b80b935sm2692418a12.41.2025.02.26.03.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:40:41 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 7/7] io_uring/net: extract iovec import into a helper
Date: Wed, 26 Feb 2025 11:41:21 +0000
Message-ID: <6a5f8c526f6732c4249a7fa0213b49e1a3ecccf0.1740569495.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740569495.git.asml.silence@gmail.com>
References: <cover.1740569495.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Deduplicate iovec imports between compat and !compat by introducing a
helper function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 62 +++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 34 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index de2d6bd44ef0..da6c828b9985 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -192,6 +192,29 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 	req->buf_index = sr->buf_group;
 }
 
+static int io_net_import_vec(struct io_kiocb *req, struct io_async_msghdr *iomsg,
+			     const struct iovec __user *uiov, unsigned uvec_seg,
+			     int ddir)
+{
+	struct iovec *iov;
+	int ret, nr_segs;
+
+	if (iomsg->free_iov) {
+		nr_segs = iomsg->free_iov_nr;
+		iov = iomsg->free_iov;
+	} else {
+		nr_segs = 1;
+		iov = &iomsg->fast_iov;
+	}
+
+	ret = __import_iovec(ddir, uiov, uvec_seg, nr_segs, &iov,
+			     &iomsg->msg.msg_iter, io_is_compat(req->ctx));
+	if (unlikely(ret < 0))
+		return ret;
+	io_net_vec_assign(req, iomsg, iov);
+	return 0;
+}
+
 #ifdef CONFIG_COMPAT
 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				  struct io_async_msghdr *iomsg,
@@ -200,8 +223,7 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct compat_iovec __user *uiov;
-	struct iovec *iov;
-	int ret, nr_segs;
+	int ret;
 
 	if (copy_from_user(msg, sr->umsg_compat, sizeof(*msg)))
 		return -EFAULT;
@@ -229,21 +251,8 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 		return 0;
 	}
 
-	if (iomsg->free_iov) {
-		nr_segs = iomsg->free_iov_nr;
-		iov = iomsg->free_iov;
-	} else {
-		iov = &iomsg->fast_iov;
-		nr_segs = 1;
-	}
-
-	ret = __import_iovec(ddir, (struct iovec __user *)uiov, msg->msg_iovlen,
-				nr_segs, &iov, &iomsg->msg.msg_iter, true);
-	if (unlikely(ret < 0))
-		return ret;
-
-	io_net_vec_assign(req, iomsg, iov);
-	return 0;
+	return io_net_import_vec(req, iomsg, (struct iovec __user *)uiov,
+				 msg->msg_iovlen, ddir);
 }
 #endif
 
@@ -271,8 +280,7 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct user_msghdr __user *umsg = sr->umsg;
-	struct iovec *iov;
-	int ret, nr_segs;
+	int ret;
 
 	ret = io_copy_msghdr_from_user(msg, umsg);
 	if (unlikely(ret))
@@ -300,21 +308,7 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 		return 0;
 	}
 
-	if (iomsg->free_iov) {
-		nr_segs = iomsg->free_iov_nr;
-		iov = iomsg->free_iov;
-	} else {
-		iov = &iomsg->fast_iov;
-		nr_segs = 1;
-	}
-
-	ret = __import_iovec(ddir, msg->msg_iov, msg->msg_iovlen, nr_segs,
-				&iov, &iomsg->msg.msg_iter, false);
-	if (unlikely(ret < 0))
-		return ret;
-
-	io_net_vec_assign(req, iomsg, iov);
-	return 0;
+	return io_net_import_vec(req, iomsg, msg->msg_iov, msg->msg_iovlen, ddir);
 }
 
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
-- 
2.48.1


