Return-Path: <io-uring+bounces-9735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29463B53050
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF6E6486A04
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFB131B13A;
	Thu, 11 Sep 2025 11:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKmOSrRj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FCB31B11E
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 11:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589909; cv=none; b=rhOxcmZ2EK8ZiAnE8rRdwYC42gkk7z2jrXdJF373BcV+Yu/8yJk22PqG/Op3F2tG6rZzEcW7QAwPgk5QXLo6PT3H0moIonilJrKZBPj76h48Ucnje9AeoAMPAZn1t6yVTegce0q2dqCEtYOKzG5UR+ujCwbqUX7w0O5GVS12Ag8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589909; c=relaxed/simple;
	bh=2OGEj8yQ34dGyfyJrk6YAjl9MDSeEyuFtIoXM3Ku8Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxX1SSpuBcVCFo5pvrGjJGWuvdTLE8qNtZx/nHxb3Gzl0OsF8VrwfduANEMRnF5/2MOgbVEiI1B7TYTpuojwxNv/8BgD/RCNBC7HX7/bLJuP3tJ5yXl78a2ZgXWueUECLiAeboBiloO37y9nEj8F8esnvx7q8AKhh1voZyz5aRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKmOSrRj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3e07ffffb87so333596f8f.2
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 04:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757589905; x=1758194705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmBUR0Pzpune9MDbE9zm+Zdl1Qifj8BhZ1/8vQ8xpvA=;
        b=LKmOSrRjkJIAVk0LMAmiXMnzr6nb6Ah/WXBoseReVuXO2WtJAz2pItyUf7MWq7Rptj
         TP2OQfAw00O9CV9/zZuBZZXhPa+toDlHh3zkyuiJ3gLF/8UltgFKvOFVsV4X7pO7Qlmt
         gTn4cAs0/YcEEcCIJg+Ow26SRClBHAtD4CaHlHls2UlTiePSKM5ygCeSkrrRzNQJLFRv
         merG1r8K+JFXB8hNIadoNGhsrbn79Qg1UsJ8bGzbJBD0rpKz/zmQha7S7Go9qam2KBWM
         A6A+mOVAmp4U+2OFvwztysThNra0qyt0S09VP+JtXy5IbccofzoJ0bJlEv2OIUWwSDJI
         ZwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757589905; x=1758194705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rmBUR0Pzpune9MDbE9zm+Zdl1Qifj8BhZ1/8vQ8xpvA=;
        b=dQa2Krnkj4uKEFdIPancX/9h0Abk4No30CQ1dzpnmo25NShg/Owavsnw9lUXtKvEKq
         YkrCaXApKlP4W+9GTWUmz6QPuFoa5vIOLy3i3phYhBipBJMNBJmv6INcExAnwnUh3/iN
         8tWSC9K3cJ8UopfayR8XWDBLzHk7ofu/nJC3VoSFb43izUsQt4Cjaf+CyW5PPMXkHDNb
         A0iCODjGsXR1kaMM8cwQrdMOmIYf8P6BwauhwrZJgCArZ+H5xUbYyWMDYemBXsfnieI4
         fQCHIPxkbIJEBrAQKTrlqwOwIVfNWWcq81pSHtvu8Ru9AG9aAGg7TW29JPxID6XlXu18
         wa2w==
X-Gm-Message-State: AOJu0YyISxHkrh+Yu16TfZ4I64Sl8/+ZH2i+KnU6w5gc9Ya50b3+pz4P
	w6WoaL0tROUmCiAwvFreyL9C3kOryrpW7PYaItWvCz/o2LDYzMZYueYUQF/NOw==
X-Gm-Gg: ASbGncsjQ5KWKaHxB8HxIQIKh73qM26GAMqdkLNRoszK5xSRoY1wOcLMINstT+w5RFZ
	VeaD+E2ZvNn8xzfqKrWV5C4c/sWaid6PenX6levLfo1BZLROdWSGR9uO2TxPgxWhmmSIeT1nlx0
	jGirKeM7xxe5BEKrRJnPPmhpgYpD1OlqsSqbJhlh9Kjgh6Eq20m89WorsT+xYgdAobI7rCeML9r
	9l2JVcsk+T/4snD93NEwzhxr/jkzT/K/12PqTO5aJfj0I/qauvSWqiPZHGzjvMagassoqYxSCxb
	A8CxkexeAjYNpMCz5AyHzFSphX0X3A0ITL5rgNeXyctQZ+qKi3Wv23Ng4A96O9wkf6VFgbNT0XN
	0KTam+Trx/EnQSDDn
X-Google-Smtp-Source: AGHT+IET/npFH9ns+/LBqXI5M7hO2shug9ZIubF+ss9BmtxoqZu7Wo597pX8hY4rae5JDrjn4nDyIQ==
X-Received: by 2002:a05:6000:24c5:b0:3e7:615a:17de with SMTP id ffacd0b85a97d-3e7615a1b81mr1368220f8f.47.1757589905500;
        Thu, 11 Sep 2025 04:25:05 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm2095608f8f.53.2025.09.11.04.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 04:25:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 4/6] tests: add t_sqe_prep_cmd helper
Date: Thu, 11 Sep 2025 12:26:29 +0100
Message-ID: <21f6f3285b300bfe116003902c2902d226213de3.1757589613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757589613.git.asml.silence@gmail.com>
References: <cover.1757589613.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/helpers.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/test/helpers.h b/test/helpers.h
index a45b8683..7dafeb17 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -126,6 +126,13 @@ int t_submit_and_wait_single(struct io_uring *ring, struct io_uring_cqe **cqe);
 
 size_t t_iovec_data_length(struct iovec *iov, unsigned iov_len);
 
+static inline void t_sqe_prep_cmd(struct io_uring_sqe *sqe,
+				  int fd, unsigned cmd_op)
+{
+	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, NULL, 0, 0);
+	sqe->cmd_op = cmd_op;
+}
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.49.0


