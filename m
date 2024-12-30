Return-Path: <io-uring+bounces-5634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 244CB9FE671
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 14:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D65C5161D85
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 13:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C291A8407;
	Mon, 30 Dec 2024 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHMHF86i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5651A840B
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735565390; cv=none; b=nDZoADNHX/7/emcrlMbo3Be6rvFYDYlxoz1Xj8IxKKTEVjetmFAqoZtB8/x3urGDEm9y8SBqw2urWbLhm0WUPRtFbK/A5U/x1BpOOT58Yjqc7L6MpCE9zgVEucgeBNlmeVShifrY/nb8MiAD9Xae6APAD32fBij5PSqMkSRJrKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735565390; c=relaxed/simple;
	bh=IDD18nfOacHH6xthKMwD+JSo1KFKeCmsSiilhvik5R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0Z+yIJWAhGGs6KQN3VJAklR0oMZ5ChXQWQ1Ml2oG8F46g4PK0Z46azdAVNg0RPIHyYrHZtDU2EjNRXXQgFznQ3DuTDXIIAGfitoMz6J/Jec8GPgv74MRbAKaqMEqAPpj6zPocXgEQwquhW88TmVKpSX7NxrJJS29/kcYnKBOJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHMHF86i; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa6b4cc7270so1317955666b.0
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 05:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735565387; x=1736170187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyT+dmpD0OjpuzQVnEahu3gllLOIz9gM7y0hDq3JK58=;
        b=aHMHF86iWi/oc/mZiE0RlmkUqwSzuuwD0Hrg4mXrx176y3EfTxrz4Yuau8dEb2oehB
         en/fo+jtZkvN0IF+JAOgIzvOblmxSZvUyZD+0MD/ZcPxwu7zV78DA2cIXgeq+WjS8Jlm
         WfvOx0kYvFXwqCM6s5jojBG6O4NhhBEfhGwk4OJdxSIq7nqglVeSCbAKev/ojwVpJ6a7
         ugYtX9t1SfSi4wry783r1QHnVOHNdMfKRKZHVKhmpCj8T6F/ZmUR4AOFjxayMIRubDGb
         XTv7afrSaUQ4Q42SM4vLOzsonzC0gzyZ5pAZT6oy0tJxSoVraKOAccd2hnBwUyAXNkZd
         qC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735565387; x=1736170187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nyT+dmpD0OjpuzQVnEahu3gllLOIz9gM7y0hDq3JK58=;
        b=Qbm/E8ILrfoc3TwA3Bh8bx8+hklR/59UCpkXoc4hp21m/Hfte2V/W+0y21LLSwnSkH
         uTH3l0F/c9Bmw1g4qwtPsNAYuygDeojFgMKkVE9RzBQqU55WQ2l/x4tpnqppO2cHoEA1
         HLP1moxVRrNlbcUK41cCf4d2uM3S3cymHhwUJv6waelvdneQgrO1Na7fgAdVRNSECRTO
         FASDTtRTQwV1156nk8qh5gSTDWfc15BNyrFOdH8IetgIYoOfCYLsbXn0eMlSz9M39rka
         Lq3Fihj/z/hpiCKSpoZ+UpA/iHSKiUpTfLkaahPGBsiJvQQGnOTCwsGDuIArYdp22OnH
         4Taw==
X-Gm-Message-State: AOJu0YztnIi73ilrQsJz79ger648N+tmih5GV/sCkTKy9vOCUeWbA7uv
	KVYn1nnD35ebfU5ayNACIf1Q0MtKsKWARbFXoRG6ynPjgyNgGeNuKvHq8A==
X-Gm-Gg: ASbGncu4JNXbyPT4/ogUL15fkwZsQHrKXWXHML8RjRnJe1RoMR82KjbHTHZjon1BtK2
	XEdY9Y768jicPZq7/h8PpV5OF07Py03TTYENh1jJXS+Jk0Xjd6sOl/OAeKU6eYASsJXFAZ82ADY
	iIDNuYuXfKg3QWKpDO52U0kibaLRV7S8ybRFmWDp4kyfj8DlPeuJVkkHp5qiiJcKuUbwdpQAz5m
	zLk2qTaD8N7TSPvJDm4eQW04qtgoVtF3LGUZ8o+YHv+1JhL0rU/AoEafxmy+fYPxJsDDw==
X-Google-Smtp-Source: AGHT+IEMoC+fgEDZrp6dJmyI5ozwoogttigIrd2SEoYzMt7Yfx2NSCd9OAH0Camo+Kzhn82C4pFG6Q==
X-Received: by 2002:a05:6402:35c2:b0:5d0:ea4f:972f with SMTP id 4fb4d7f45d1cf-5d81dd9af30mr73089455a12.8.1735565387302;
        Mon, 30 Dec 2024 05:29:47 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.209])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679f35csm14694286a12.51.2024.12.30.05.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 05:29:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 4/4] io_uring/rw: pre-mapped rw attributes
Date: Mon, 30 Dec 2024 13:30:24 +0000
Message-ID: <ea95e358ce21fe69200df6a0b1e747b8817a6ec6.1735301337.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1735301337.git.asml.silence@gmail.com>
References: <cover.1735301337.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of copy_from_user()'ing request attributes, allow it to be
grabbwd from a registered pre-registered parameter region like we do
with registered wait arguments.

Suggested-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  4 +++-
 io_uring/rw.c                 | 19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 38f0d6b10eaf..ec6e6fd37d1c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -112,7 +112,9 @@ struct io_uring_sqe {
 };
 
 /* sqe->attr_type_mask flags */
-#define IORING_RW_ATTR_FLAG_PI	(1U << 0)
+#define IORING_RW_ATTR_FLAG_PI		(1UL << 0)
+#define IORING_RW_ATTR_REGISTERED	(1UL << 63)
+
 /* PI attribute information */
 struct io_uring_attr_pi {
 		__u16	flags;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index dc1acaf95db1..b1db4595788b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -271,10 +271,17 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
 	size_t pi_len;
 	int ret;
 
-	if (copy_from_user(&__pi_attr, u64_to_user_ptr(attr_ptr),
-	    sizeof(pi_attr)))
-		return -EFAULT;
-	pi_attr = &__pi_attr;
+	if (attr_type_mask & IORING_RW_ATTR_REGISTERED) {
+		pi_attr = io_args_get_ptr(&req->ctx->sqe_args, attr_ptr,
+					  sizeof(pi_attr));
+		if (IS_ERR(pi_attr))
+			return PTR_ERR(pi_attr);
+	} else {
+		if (copy_from_user(&__pi_attr, u64_to_user_ptr(attr_ptr),
+		    sizeof(pi_attr)))
+			return -EFAULT;
+		pi_attr = &__pi_attr;
+	}
 
 	if (pi_attr->rsvd)
 		return -EINVAL;
@@ -294,6 +301,8 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
 	return ret;
 }
 
+#define IO_RW_ATTR_ALLOWED_MASK (IORING_RW_ATTR_FLAG_PI | IORING_RW_ATTR_REGISTERED)
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      int ddir, bool do_import)
 {
@@ -332,7 +341,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		u64 attr_ptr;
 
 		/* only PI attribute is supported currently */
-		if (attr_type_mask != IORING_RW_ATTR_FLAG_PI)
+		if (attr_type_mask & IO_RW_ATTR_ALLOWED_MASK)
 			return -EINVAL;
 
 		attr_ptr = READ_ONCE(sqe->attr_ptr);
-- 
2.47.1


