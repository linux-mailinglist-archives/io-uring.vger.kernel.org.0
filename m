Return-Path: <io-uring+bounces-7447-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E6DA82E15
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 19:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C2443A71A2
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 17:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F061CF8B;
	Wed,  9 Apr 2025 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T45+D8aT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A1726FD9F
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 17:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744221462; cv=none; b=T1mi+UwpKzO9J2TjJAKJeMRx0imcUxUVuBLIGO03KfVLe+DljLdtOE9RmRxS7qKD/R8FCLkg8ie9wkgHhGeh5hi4grNCz5b52dzL+kZLUCoaN6O594Ch88si2v52Wn7TQTiiFGP9EEoXri/LElnMm6Pku81606EDfIyUZz9KYXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744221462; c=relaxed/simple;
	bh=D93MXlyE83gH7b/+2MeumQN+zMPy/X5bGRoXtfDmOZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Opk5eS6F1qZDQcHWQQkiSE8uXoUGadUhRfBzw2tRTxuDHsZ3nF82P5/HuzByAT9crZcoln5jPfZsdDDoqFFEX/YzgJaWGWYQ54W+oYs1CJ3PHnu0H47j0KXeNfb242yUiBRW/hcRAu5aKcbvvr4n5ADsZ6YWEXZPXdbKEIkhh4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T45+D8aT; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39bf44be22fso4766232f8f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 10:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744221458; x=1744826258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o6zreQrPgZgTz+QK4DDJ8nPg7PQBQrTwib+41L1EUAs=;
        b=T45+D8aTcvqGlkwJJtEB5RyF187Tx0F64SVJxxdWfsSYtYrdAORHFTwPpPXedXBDvu
         ci1yULZEhGO9YoHCegJ5SWF9Hc6dwkAl9jYUTMG2KiWuvVVGbgW74CDzlf2mSrHuIjCR
         cxWiu+Rt1Smg5jHJZlCIyC9GE6N7jmVFdmMXumvcFecWfCwOD+NOnWzKdAOvcY/AY8M7
         HBc7Tn1AcEL2IzQFYBQuOF9aLmZUNl1gcYWP4I3FcBXYac9zjtrrGIq6XQEVi0CU22Ev
         lDYAK8jQav6CU2/JIDJxqI/MLSowcxAtZz2kggi40cebffZx0f9657jojxBIJJyaLbpS
         7JOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744221458; x=1744826258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o6zreQrPgZgTz+QK4DDJ8nPg7PQBQrTwib+41L1EUAs=;
        b=rYRw6/Z/xhxnQvVu8ymX4teCjJLGDi7wMxEyq8vixtjaI3fth6fs2UcyDm5CL7akHN
         I+W7lM+ubN7neKOggWOrOwzW809kYx/sQrLikaG+q6pHerhrSm9D5HvOpJcnV03aOUR5
         Hsu03H0WY7T25dzHsa11eUFTCaMLmZcOxqRJz95SyhFY65PHqf35FE+KO8B5cRhlCeqh
         qxx6yU78f2MX/ylwN+6MqPItroX5Xz0N98rpn3yDxg1FDL/vU2QemykCeHUkUSSgcVuU
         QuDGoYGmNPDkEYgEiDJI0IJubucWhYKpFI3jNkghbfzogHdwvv1qG0rjeAw1DG6wEua9
         lcEg==
X-Gm-Message-State: AOJu0YwqlcJKcmqTy5TG7Q/lcmiqKaK5gvVyqccsXDvPxSsaa/sZH2vi
	lbqqM8hAxuIBU/PjGH+i67of+c70WU9TCQKvmLVGLZ3uf+JA9V/aaHxjqw==
X-Gm-Gg: ASbGnctwF7fuCdxfyitDF+K+fhe2JcU9W5qIHkQyypICKz/w6wYCK0Yco8b/snKSiXz
	b3OabuMwfYhkSQulVk+DblD6sprBEjHzF5q1eF5AhG7J3ukqsgS7iEkj5gv80LK2dXbys5Gf0Lq
	/oQ9JxPfQ3RYZLl9C8D9hJZnMrA52U40LvhbLACrp1OmRczoBOGFFofpx8cgVMQGq4tMJPgqQi7
	MNCTqwdaCcbqwoGEeOefMIcjX9j/+C0HQ9gOIOZb1KGlQ3UE391vgH5aphff4ZKCUpWXO7UxbP9
	F3PnaykewrZMYpm1df5RllONGx6/z+EVnYYomLoZeV7mS8nBGNIyhtm4+GvBOqwd
X-Google-Smtp-Source: AGHT+IFIE41kFkd3zJkELwPFPkmOrVNMHdByF1XBAIXmNns4cESTwtZ/MgxU68oHvLGhV7KhLPmSfQ==
X-Received: by 2002:a05:6000:240e:b0:391:300f:7474 with SMTP id ffacd0b85a97d-39d87ab60d5mr3575884f8f.18.1744221457831;
        Wed, 09 Apr 2025 10:57:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d8938a808sm2291470f8f.53.2025.04.09.10.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 10:57:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 1/2] examples/send-zerocopy: add data verification
Date: Wed,  9 Apr 2025 18:58:35 +0100
Message-ID: <86a0ceded6a54e1580a17bd549b1059326ae09f9.1744221361.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744221361.git.asml.silence@gmail.com>
References: <cover.1744221361.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 50 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index a50896c6..b0f2a76a 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -58,6 +58,13 @@ struct thread_data {
 	int fd;
 };
 
+enum {
+	VERIFY_DISABLED = 0,
+	VERIFY_SEQ,
+
+	__MAX_VERIFY,
+};
+
 static bool cfg_reg_ringfd = true;
 static bool cfg_fixed_files = 1;
 static bool cfg_zc = 1;
@@ -74,8 +81,8 @@ static int  cfg_type		= 0;
 static int  cfg_payload_len;
 static int  cfg_port		= 8000;
 static int  cfg_runtime_ms	= 4200;
+static int  cfg_verify		= 0;
 static bool cfg_rx_poll		= false;
-
 static socklen_t cfg_alen;
 static char *str_addr = NULL;
 
@@ -198,13 +205,30 @@ static int do_poll(int fd, int events)
 	return ret && (pfd.revents & events);
 }
 
+static void verify_buffer(struct thread_data *td, char *buffer, size_t size)
+{
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		char d = payload[i];
+		char e = (td->bytes + i) % 26 + 'a';
+
+		if (e != d)
+			t_error(1, -EINVAL, "data mismatch");
+	}
+}
+
 /* Flush all outstanding bytes for the tcp receive queue */
 static int do_flush_tcp(struct thread_data *td, int fd)
 {
 	int ret;
 
+	if (cfg_verify == VERIFY_SEQ)
+		ret = recv(fd, payload_buf, sizeof(payload_buf), 0);
+	else
+		ret = recv(fd, NULL, 1 << 21, MSG_TRUNC | MSG_DONTWAIT);
+
 	/* MSG_TRUNC flushes up to len bytes */
-	ret = recv(fd, NULL, 1 << 21, MSG_TRUNC | MSG_DONTWAIT);
 	if (ret == -1 && errno == EAGAIN)
 		return 0;
 	if (ret == -1)
@@ -212,6 +236,9 @@ static int do_flush_tcp(struct thread_data *td, int fd)
 	if (!ret)
 		return 1;
 
+	if (cfg_verify == VERIFY_SEQ)
+		verify_buffer(td, payload_buf, ret);
+
 	td->packets++;
 	td->bytes += ret;
 	return 0;
@@ -391,6 +418,11 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 		unsigned buf_idx = 0;
 		unsigned msg_flags = MSG_WAITALL;
 
+		if (cfg_verify) {
+			for (i = 0; i < cfg_payload_len; i++)
+				payload[i] = 'a' + ((i + td->bytes) % 26);
+		}
+
 		for (i = 0; i < cfg_nr_reqs; i++) {
 			sqe = io_uring_get_sqe(&ring);
 
@@ -515,7 +547,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:Ry")) != -1) {
+	while ((c = getopt(argc, argv, "46v:D:p:s:t:n:z:b:l:dC:T:Ry")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -570,9 +602,21 @@ static void parse_opts(int argc, char **argv)
 		case 'y':
 			cfg_rx_poll = 1;
 			break;
+		case 'v':
+			cfg_verify = strtoul(optarg, NULL, 0);
+			break;
 		}
 	}
 
+	if (cfg_verify >= __MAX_VERIFY)
+		t_error(1, 0, "unsupported data verification type");
+	if (cfg_verify) {
+		if (!cfg_rx && cfg_zc)
+			t_error(1, 0, "verification doesn't work with sendzc");
+		if (cfg_verify == VERIFY_SEQ && cfg_nr_reqs > 1 && !cfg_zc)
+			t_error(1, 0, "sequence verification invalid inflight number");
+	}
+
 	if (cfg_nr_reqs > MAX_SUBMIT_NR)
 		t_error(1, 0, "-n: submit batch nr exceeds max (%d)", MAX_SUBMIT_NR);
 	if (cfg_payload_len > max_payload_len)
-- 
2.48.1


