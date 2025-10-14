Return-Path: <io-uring+bounces-10004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E71DBDA357
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 17:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 158BB5027E0
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44702FF170;
	Tue, 14 Oct 2025 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jR7lmeeg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22FA2FE07E
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454109; cv=none; b=TO8bOFImJa5eHgx1YnRSXR+wSC7c19rC9OYL2AO5S3W+w6ThsfX+1n62mBu4m0CO/Fz0FznVep+TZyNwZXmLRLAfAnLas/4JPsHKfOjU/QuEnw6obdarbBrg3cHMLQymMjqi0HpGGKX4XZrpQnJSNOrX9Kj82WL6MYu/Y/HT8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454109; c=relaxed/simple;
	bh=YtcQTTC0REa/jh6CNYL0CMMXriWM+2IwF5Ic9tyMd+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ow/zG4cvZZ7SK+KCAxJbz/mGu+SCRSaMABTQjxuXZ1cQnEky+YqkZnUogae/wabMg9ox899tAJWnEVUambQlE7rlZTeUwMfVxYd07KtcWF+dbSCX/WZl5YbFmAQPPmEQTizz0m68VAbX3SKFuNmOBwTR2JN5vT2z6549yU8fsq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jR7lmeeg; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e6c8bc46eso36461025e9.3
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 08:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760454105; x=1761058905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9RqR9qSnrD73VuwUQUQmULg2N+WeCXlrB3p8dDCgN2o=;
        b=jR7lmeegB4ywxyiM0v9x1onOTuiJ55tMt7MIEVDCdEZatTWqcvE3qwOMhU/5ppylSp
         ztj644ASXSouwabJNtBB7dIvC+iEFvrVL+gmM/tNhjiujo84H/eJVJAtkZ173ZbrsPLk
         6GcdQYIuX+h8gfDFnXOPdfnEtOROYQsgXx0B8WngEA6CAzMTcJ0/9T3kOCQHKwHjzaBU
         kGE3iyLkcbLYZf3Uybfl7Kzhr3U/EtHSFwA63vAS+aUweLX24TkFp3+6cQuJbh9ybGyZ
         hyqQXeiAnA5I9PFm750Awdtdni+ucaVA78LkZOUgSGvdapDHP5ZMoRrSydwYggQ+boWA
         856Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454105; x=1761058905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9RqR9qSnrD73VuwUQUQmULg2N+WeCXlrB3p8dDCgN2o=;
        b=Yf254R0iJL+jucW8sQ23MdcieL5rsQ0DUQg6oDsvDHhU+Xi/f3QjTTWLwB512yX+Di
         WBbo1Ji7XQCJqAD6o5SAcv//cezjswziMNfmq7mYUymcj1FloK3ai9lP6sGaU06+DdOc
         x/niia7lDOpZa+XIK9TI9cCbHOaEg7bEec9pdR3EPNI+1+9ic4qrB13iQEabBvgM/P+/
         wUckEJ8k3dO3hk8wy7Jev9hSDTVFzIb99moSafyn2OkM5IITHsKcdP9FNNzxWhD15Ns4
         R4N8E5RPX+rwvr1p25CKx74+GoFIA1dGF9jb9o83iqkwr1cBWZcex+64NgN8rTyjhgWU
         Mg5Q==
X-Gm-Message-State: AOJu0YxR93hNvcKiJG1dFZ/veCkcbINhXGc2QEC0/NWG33jkkJdw2iRt
	Ua8fkCOOWvF744Rru+YX9R94ee0DRfpKk81VauLjDyk4u9Berfwbupa6t5dbEw==
X-Gm-Gg: ASbGnct70Cnwu0VqO/I3WQrUfP7BSpPtI/8NNX7DZsluAsYTHMsORFzMSAFMt05yayU
	NAXdOF6x9j8DAp6GpxwBp64yUTwVI+36WHT6uoQNATkh6WkA84MoePDRXZePT5W4ONwYwIX+egi
	dwczRYotRF0vEp4cyD1FamSwhSBB+OPhAp3fdYLgX1sGe93mBrxfA1DfxtTFqJ/LWfVop9JHEfS
	0XeF3CnmBBibR5GBhG/UEFpd07nDSXBwUmxoaJpqWMNs6LzQ8Li36s2zRSqXIJtpul8Da/vKtpm
	R4v108mSUv22tHPknQJTddVis1EVUFP07OUR1gVDm3Lk2KcupJkemgJaoJFZXot9WY6eRAE1+dP
	92+zEu/cVBGgep5RKdnY/3/M1
X-Google-Smtp-Source: AGHT+IH6OECmuSw30yCaLvEFnYwzE9Q8HqqS6goikN0gPwEVNB2dUJ+qBzhsFfmsY6metwcuKSwbQg==
X-Received: by 2002:a05:600c:1e85:b0:46e:39e4:1721 with SMTP id 5b1f17b1804b1-46fa9aa261amr169617365e9.12.1760454105251;
        Tue, 14 Oct 2025 08:01:45 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4983053sm243910975e9.8.2025.10.14.08.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 08:01:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v4 2/3] register: expose a query helper
Date: Tue, 14 Oct 2025 16:02:56 +0100
Message-ID: <00b81f907a11d467bb51995f0b59fdb1bd85c1d4.1760453798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760453798.git.asml.silence@gmail.com>
References: <cover.1760453798.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose a simple wrapper around IORING_REGISTER_QUERY to users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 2 ++
 src/liburing-ffi.map   | 3 ++-
 src/liburing.map       | 3 ++-
 src/register.c         | 7 +++++++
 test/ring-query.c      | 7 -------
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 3d4c6422..7eab7e42 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -359,6 +359,8 @@ int io_uring_register_clock(struct io_uring *ring,
 int io_uring_get_events(struct io_uring *ring) LIBURING_NOEXCEPT;
 int io_uring_submit_and_get_events(struct io_uring *ring) LIBURING_NOEXCEPT;
 
+int io_uring_query(struct io_uring *ring, struct io_uring_query_hdr *arg);
+
 /*
  * io_uring syscalls.
  */
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 4bf4fd51..6eed3f9f 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -253,5 +253,6 @@ LIBURING_2.12 {
 } LIBURING_2.11;
 
 LIBURING_2.13 {
-
+	global:
+		io_uring_query;
 } LIBURING_2.12;
diff --git a/src/liburing.map b/src/liburing.map
index 0c4888e1..92c2af7b 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -132,5 +132,6 @@ LIBURING_2.12 {
 } LIBURING_2.11;
 
 LIBURING_2.13 {
-
+	global:
+		io_uring_query;
 } LIBURING_2.12;
diff --git a/src/register.c b/src/register.c
index 93eda3fc..7265dcca 100644
--- a/src/register.c
+++ b/src/register.c
@@ -513,3 +513,10 @@ int io_uring_set_iowait(struct io_uring *ring, bool enable_iowait)
 		ring->int_flags |= INT_FLAG_NO_IOWAIT;
 	return 0;
 }
+
+int io_uring_query(struct io_uring *ring, struct io_uring_query_hdr *arg)
+{
+	int fd = ring ? ring->ring_fd : -1;
+
+	return io_uring_register(fd, IORING_REGISTER_QUERY, arg, 0);
+}
diff --git a/test/ring-query.c b/test/ring-query.c
index d0aa396c..e266b4a9 100644
--- a/test/ring-query.c
+++ b/test/ring-query.c
@@ -27,13 +27,6 @@ struct io_uring_query_opcode_large {
 
 static struct io_uring_query_opcode sys_ops;
 
-static int io_uring_query(struct io_uring *ring, struct io_uring_query_hdr *arg)
-{
-	int fd = ring ? ring->ring_fd : -1;
-
-	return io_uring_register(fd, IORING_REGISTER_QUERY, arg, 0);
-}
-
 static int test_basic_query(void)
 {
 	struct io_uring_query_opcode op = {};
-- 
2.49.0


