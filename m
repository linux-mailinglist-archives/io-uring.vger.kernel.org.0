Return-Path: <io-uring+bounces-6525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 965BEA3AB6A
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A265173D9B
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E6D1D5CE3;
	Tue, 18 Feb 2025 22:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="QDQ50ZsL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D04C1C701B
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739916106; cv=none; b=m+OCTFBjYnaEN+tarqO6LdxUsyRJEI2M5vACOQajIJj46xQl9liaZ2J7TZxCNp/jgSyLlHKxiowR91htYx2MxpEZt7gGKNxyMElZF2xaX+MTPgRt2LbzBj+XUhZN4mARHktcjDl/IIUC2CcYeblnlg5jLlqXStC34pbNzJ3iF5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739916106; c=relaxed/simple;
	bh=nBoWU3+DWLHvBK++LtK+tqnpWIBKU2BFtAP2zUqTfOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTXiKg5oViPJPcBrVKjnIjH5dycxfhzZ+3JtgPt0U+8daUdOqJRjmRaJDm92gR6v7AVd4rrVyS3pYBQZ2YY7AcT5u86eIEm2BDBIMW6Azn5j2dOMWdox7rwlClGcJW7SZXWhYN8gbH15H90FB+MzOr1pMeq42z3ER9Wr17i+FKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=QDQ50ZsL; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fc20e0f0ceso7806579a91.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739916103; x=1740520903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2IslT3YuiEU7iZyJVnV/hcP9Zor4bYpNa5m5cjTKws=;
        b=QDQ50ZsLQPc4uC7y3NRngS2fYWROjBsvXE+elx/6eWMmlpz8CqXi1rt57CzGheUHQU
         2TVSX3m7fTlVULuX90lusiBXoc+141UE/T9etP6i3o5SghnaHtbQd0mnRQG1TMTjqZ9o
         UULzzCVdpRrohhBRcVgjgUoEwkoUw4/RVnUaAFqQXxjG9IyLQPvF/Yfp071IBF2IuDDn
         zUnt4bN5dcnfC9EF4KYEoMV0ANm84UFE8/JRno4dv9Twh0OdXeObhL8Ti8fyKfDdudtf
         HjvpfyhkZSEiSn8pR1P67uMeCHoDMmWB2LQYSfMbW2l6htCZ7WIi9u0lfYKSlAggkwpK
         MuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739916103; x=1740520903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2IslT3YuiEU7iZyJVnV/hcP9Zor4bYpNa5m5cjTKws=;
        b=Qg0fRqAsYywdYwQHwJ2yEoOC5of9bu/qG7g3awF0bGMKXDyCguVDbYccMO5rQ8mXWg
         rutLMjOEP4xb/lahSwG+YDwPv1IsGJS7wvvWwVQUkJvQVtHEorcSFZMk7oC3iqymw7tw
         UXoW5wzsCcgwwOUwGKS1pOxwqTuMZYdF/UcN0Gd+124KqKq3lUc9Uhgge9JHRsiHMtC4
         XYPaCThTU2UCXeN/YFPMDPrVTO4hIgeMaYKJqWDjKJaL3wGBx4QTQ1NvWKl5uTcagAq4
         +XGherfg4qohhPJuGptIYeG7Ufwu4bxZKVBNmj65nudIa59TBPD/w5QuUb41tmu6F881
         TV+g==
X-Gm-Message-State: AOJu0YxL2DbrCnlm3CNQ11c2UQuIqBLiFkv+haj4ulJpghRXFEyZf7LR
	JS1UM83UHicQ+T+1a9qlKFUUtMUIrHON1Z4mcUwP/1PpjfjGc9fRDcbPm4gaU80qnmMxIRLFE8P
	R
X-Gm-Gg: ASbGncsm+tIY2wR9OdWq6yjsp4fZzr2Lpap8Et94PLrDkE9zQSydrUNe8vfvcGQVSIA
	sG8mZRXWy96Vj3YLJwCqgtjFGot1dBtwv+KZEcb+tGj3L/E64AKC4v58pmJOq/8jtU2H07zqqyo
	BjjMgS9vfY3IuAKipq8KL1mTPUL+RPS0d5nL9zG1zmoayZb2li6QFUEvEZYS4q7R9R0WL9aNjH2
	dqJW9sdGFj6OfBHKF0d4YbiL2W499+gcpo7jPBa5efmNb+/TUar3LLetXw1IMvqe/KkMsf89oQ=
X-Google-Smtp-Source: AGHT+IGAP9HxUHN9WtFGAaADlSkgC+Wq6FK0DkgieufwL9d+iMSDDwSeUi2rb5yAEwA9GnTExJ7aOw==
X-Received: by 2002:a17:90b:3d0f:b0:2ee:c918:cd60 with SMTP id 98e67ed59e1d1-2fcb5a39f7dmr1715793a91.20.1739916103562;
        Tue, 18 Feb 2025 14:01:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:c::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98cfd19sm12723656a91.14.2025.02.18.14.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 14:01:43 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v2 3/4] zcrx: add basic support
Date: Tue, 18 Feb 2025 14:01:35 -0800
Message-ID: <20250218220136.2238838-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250218220136.2238838-1-dw@davidwei.uk>
References: <20250218220136.2238838-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add basic support for zcrx with a thin wrapper around
IORING_REGISTER_ZCRX_IFQ and a struct for the refill queue.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 src/include/liburing.h | 12 ++++++++++++
 src/liburing-ffi.map   |  2 ++
 src/liburing.map       |  2 ++
 src/register.c         |  6 ++++++
 4 files changed, 22 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 49b4edf437b2..6393599cb3bf 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -132,6 +132,16 @@ struct io_uring {
 	unsigned pad2;
 };
 
+struct io_uring_zcrx_rq {
+	__u32 *khead;
+	__u32 *ktail;
+	__u32 rq_tail;
+	unsigned ring_entries;
+
+	struct io_uring_zcrx_rqe *rqes;
+	void *ring_ptr;
+};
+
 /*
  * Library interface
  */
@@ -265,6 +275,8 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 
 int io_uring_register_napi(struct io_uring *ring, struct io_uring_napi *napi);
 int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi);
+int io_uring_register_ifq(struct io_uring *ring,
+			  struct io_uring_zcrx_ifq_reg *reg);
 
 int io_uring_register_clock(struct io_uring *ring,
 			    struct io_uring_clock_register *arg);
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 968ccbc67366..fe14adb6d83f 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -227,4 +227,6 @@ LIBURING_2.9 {
 } LIBURING_2.8;
 
 LIBURING_2.10 {
+	global:
+		io_uring_register_ifq;
 } LIBURING_2.9;
diff --git a/src/liburing.map b/src/liburing.map
index 264a94946e90..d1661d9d61f9 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -113,4 +113,6 @@ LIBURING_2.9 {
 } LIBURING_2.8;
 
 LIBURING_2.10 {
+	global:
+		io_uring_register_ifq;
 } LIBURING_2.9;
diff --git a/src/register.c b/src/register.c
index 0fff208cd5f5..99337d13135d 100644
--- a/src/register.c
+++ b/src/register.c
@@ -422,6 +422,12 @@ int io_uring_clone_buffers(struct io_uring *dst, struct io_uring *src)
 	return io_uring_clone_buffers_offset(dst, src, 0, 0, 0, 0);
 }
 
+int io_uring_register_ifq(struct io_uring *ring,
+			  struct io_uring_zcrx_ifq_reg *reg)
+{
+	return do_register(ring, IORING_REGISTER_ZCRX_IFQ, reg, 1);
+}
+
 int io_uring_resize_rings(struct io_uring *ring, struct io_uring_params *p)
 {
 	unsigned sq_head, sq_tail;
-- 
2.43.5


