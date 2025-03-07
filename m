Return-Path: <io-uring+bounces-7024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3446A57084
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 19:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32598189B060
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 18:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0550221ADCC;
	Fri,  7 Mar 2025 18:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nf23HyAH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FBC19ABC2
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 18:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372111; cv=none; b=qCh57+6MBN6wtWAsjTXjpv91Y29MAxuVFGAOhHdbhdB9W+wP+2K2XgffMP0SN1VYxZWVOUh9sMm0cHFYY3Wt90oT/M0la9Ng5QG3Oe57yRzPRAOqEO5nC9W4D1aICNJjYciipsc3FyI+Ev154Zjs+A9CnyE3UsPiM8Qg7r+gKtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372111; c=relaxed/simple;
	bh=ekUvtFH/SfQXgIHgfIYiXK40M2zqG/dda6QIuokadQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqMUsBPxphG7Pgx8u/4IgvAfUX+6yXcnO3UF7+Ro1Yen8aBKnRgKv7LTk3+fSuI8N17qOfcEvSP82ZIRA7Zd4RUVlKxy9RbOfE/H2kB4jAwE3d1pa3zJx38nzmFgp6skdzipSDl1AQS+OxmD5xbD6Re8OU+Q32HwENzXPBFSAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nf23HyAH; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e60cfef9cfso878695a12.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 10:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741372108; x=1741976908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rwjHxuGNfHhbmaESXrubOfAJtb+l3BJVFh0Fi9idhfo=;
        b=nf23HyAH7mKrLoNXwhYWnrsJpubH5HklOpN/T0LKsmpvh1Lj62jG9/9Q1ZWRyR7N+r
         sGXRw+9Kb96X2KXY50qcfKMsY8zS3Rcj9rpIoAMtp84YlhPss9r1LpYlYLKegKTlgtwh
         HCHuuHeRgnlMod4G6ubbzHJxKR0KUQaIhvFjX+00ChsD6OplpOzwZdyz0hldxNaQykes
         RnTJ/2I4uEofqMK2N01zM0fH1KrV8xz9cSjCfxMeP0u8Xe6w6oynzN/gZmQ6TCABbbZD
         WAMwyaLSj6El6F6y/B4YnLRGqQbBJeagTUbvBZ+AiQMgjgDOfZprnRqpaF3U4wlaBMrS
         3mnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741372108; x=1741976908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rwjHxuGNfHhbmaESXrubOfAJtb+l3BJVFh0Fi9idhfo=;
        b=nCdwtZLjF4sc3rDwm/7bnuWZmZl+Yvoaw7l2WnFodyTnJCTSRHV2xbruKtBwM3uWnn
         OCDLt04iOxegYQ1F8ZbhFYfPMO8aigoOC11hEAA+UrcP/IfetCNKSmB+MqY590o/Svfs
         kjwDk49g/OeOZ1FyWoQpqSQ3Q2uPviRbvlnqubqL6BRjuyUovD8xr0VxmZWMntYGe5I/
         rh8gKdKcRhgjem7x9QQbLlop4PPvq0IfxvSROLEuEmyxwahHI/PE7qjdqVGBNXJn/Csz
         ciIYvm4sRtTF0wRZ07BdtXBp7qoVz7xz7OKSXfEZ3oSEUZ/H+c/MaHQtB1Lp+XNZdhA3
         fN0w==
X-Gm-Message-State: AOJu0YzvzOiIx5QmwdCl4m1CYD7VQFVSGAxDDfdVgYH3o3fIHCM+xgsf
	hlJ+GteBIg4ffs0cWJuyii8iQc9vdRssEExchL89tK/66r66xkXfPJe42A==
X-Gm-Gg: ASbGncuHNalEFdbzb+pptTGF7E0LQc286/Oiz0yPvO3UgjSKl/ColQ6d/oRCzKfnbxs
	9Qtgq0JYuKARvcoVO526IIIvdRjqxvt2y7XsWzGYzQWBv4yrNkNhPHgB3GDYfdCx8thE71lfzIw
	0b4rJ233aV28aeNAF8uqbgBxwX/RQRC6Io6bZtTNG4xjg13DqtSI5niBU0UulLq8bXRFhT+qD9N
	T29eqsHayiYWnJaPKVlcvKBF4DHvTt33VGvGbO2cDuOW322CdmF6neIysX9XuEt9jxOmTDSFgfB
	c6FtHOkhqodfwSn3rj7KSYk/Fjq08Jm2gkFNXlRAWsJdBaTfrkkQG0dPzg==
X-Google-Smtp-Source: AGHT+IE7ye+INdTsOZPTwhfloDrjww+f07DIiJ7qJ4vC3k60FLRKLcExplaYLKCExgU6ODun/TmzFQ==
X-Received: by 2002:a05:6402:1ed3:b0:5e5:9a2b:167a with SMTP id 4fb4d7f45d1cf-5e5e22da458mr5671162a12.17.1741372107714;
        Fri, 07 Mar 2025 10:28:27 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.206])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c74a9315sm2883230a12.46.2025.03.07.10.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 10:28:26 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 2/4] test/sendzc: test registered vectored buffers
Date: Fri,  7 Mar 2025 18:28:54 +0000
Message-ID: <272e2179217c7ed32d0113411c5d7db652f60f3a.1741372065.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741372065.git.asml.silence@gmail.com>
References: <cover.1741372065.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index c8eafe28..680481a0 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -69,6 +69,7 @@ static size_t page_sz;
 static char *tx_buffer, *rx_buffer;
 static struct iovec buffers_iov[__BUF_NR];
 
+static bool has_regvec;
 static bool has_sendzc;
 static bool has_sendmsg;
 static bool hit_enomem;
@@ -96,6 +97,7 @@ static int probe_zc_support(void)
 
 	has_sendzc = p->ops_len > IORING_OP_SEND_ZC;
 	has_sendmsg = p->ops_len > IORING_OP_SENDMSG_ZC;
+	has_regvec = p->ops_len > IORING_OP_READV_FIXED;
 	io_uring_queue_exit(&ring);
 	free(p);
 	return 0;
@@ -448,6 +450,11 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			else
 				io_uring_prep_sendmsg(sqe, sock_client, &msghdr[i], msg_flags);
 
+			if (real_fixed_buf) {
+				sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+				sqe->buf_index = conf->buf_index;
+			}
+
 			if (!conf->iovec) {
 				io = &iov[i];
 				iov_len = 1;
@@ -619,7 +626,11 @@ static int test_inet_send(struct io_uring *ring)
 			conf.tcp = tcp;
 			regbuf = conf.mix_register || conf.fixed_buf;
 
-			if (conf.iovec && (!conf.use_sendmsg || regbuf || conf.cork))
+			if (!tcp && conf.long_iovec)
+				continue;
+			if (conf.use_sendmsg && regbuf && !has_regvec)
+				continue;
+			if (conf.iovec && (!conf.use_sendmsg || conf.cork))
 				continue;
 			if (!conf.zc) {
 				if (regbuf)
@@ -637,7 +648,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (!client_connect && conf.addr == NULL)
 				continue;
-			if (conf.use_sendmsg && (regbuf || !has_sendmsg))
+			if (conf.use_sendmsg && !has_sendmsg)
 				continue;
 			if (msg_zc_set && !conf.zc)
 				continue;
-- 
2.48.1


