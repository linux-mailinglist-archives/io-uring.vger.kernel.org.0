Return-Path: <io-uring+bounces-3827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D88209A4606
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E9F8283DC0
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD00320408A;
	Fri, 18 Oct 2024 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OPh1lluy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713C22038D8
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276796; cv=none; b=h8H+yx5xOh1mxRLBlTMAGw7V6tW+WquJ8VzyKN7AulpJeR0l88E7klcWjV+UmxRkuPiJa+yorXKNuv7G8sRond5jTORIQOKWyqvx/EHSVul6wBY2KQ9ujL53PhwfznSY47RPv+4J/mq+ooaZ9F+lKwDu1d/uj5wTSYwWIhLy0O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276796; c=relaxed/simple;
	bh=3zAf6cZsUKDjd0U7E/gViTKnNsdT3j6Sf7fwClyu8E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2HGyLLMWBPJC8dNnpCQ+Zm5YBqUmg8OgFXfUam6iiNeKANq/Eh6Dsm3T3ANdQTGnuAMELI3X2NdJMIi/o7Iusqf9aemmRZTQM0IaUyFq48vv6SnXAxDc6BbFTTqMuzvwwDhIg6/VtCuedwlCbaA6coF+1wwAC97VCdW6Xti20s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OPh1lluy; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a394418442so8122535ab.0
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276793; x=1729881593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWz3IDfZkv8mUSaTED6HeCh+NfgGbCeSvdWGpFVpBBA=;
        b=OPh1lluyQQuLDMH1jDYUKhXoljruN/nxKPmfeuGSbMFzefuv6n4E1azCERMnpPvsm3
         jGwiK7JNkhcDyQUiE32Spc/R2FGDuwxPUC4bUQ/JJsQ8Z06q+s31pWrH+GQmo44b6/T/
         Vv7zY9UCk1OWISNXeTmCNryv8OsaGzcemvFBeEjW0socHprMMgsF2TgYQeAwhkSJ7rmC
         phAGWkWxpcglWdbWJHEFtNKcnB35M5cudBzPQKm70CqbH0BIVp0bBkBXIpv52R0PBH0z
         9SvZPcXzH8a1wxP3ChS828NM7K8s7sX/oNo5r319+mgKXKMU1Y/nbvjDyxA5ZedIEeGx
         vb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276793; x=1729881593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GWz3IDfZkv8mUSaTED6HeCh+NfgGbCeSvdWGpFVpBBA=;
        b=Q2QH+zwK0yWvJ43i5HOKBNpITJQpPQLDrjas5AOZ9cSpW4kLVv8Dz/V2Wr9mVzsc2f
         2O9p+883kJM7+HWYfwp2EB8HqqegMw+NpR3OLJjX0jIJeHzM5Pcf5Md7WdMQrvJdI0/M
         pBwvizK3gmFrDaRJ17+8x9FJAXItM7etY+NlI6QAOhkzc6LFZD8TTMYBo4MIyOkRPgCg
         dbr1KkSxPTkGH7p8Z49irVlzipEanKUB28nSSjlUax8DDzy5P2uaR+4Nj5JX2wLIIxbr
         IJSjqcMKc8jv0ZgnGa3F0HB0z/OcaG0CNgj2uZOa7XAoefqNF4EsDg5Fh0Qnv8k39tWx
         iD6g==
X-Gm-Message-State: AOJu0YxCRH4HVvlDUhhXGHpTDSUyi5XB3SIWs6SSB9TJIvBw72qov5we
	AKBuBnhLlFOm09M6GWGKoCwh/lYoBUJB1CtDWExkxXeKG5RrqyxlWX06Ue5k1LbWoZi0BtkTS60
	t
X-Google-Smtp-Source: AGHT+IGFbNnE4RlllvoK21FrFJpJZSsqLWpCtuwcWrJVqcgo6/5wygdbYNhkH0wb5KJdeTOrKQPWbQ==
X-Received: by 2002:a05:6e02:1b0d:b0:3a3:94c5:e178 with SMTP id e9e14a558f8ab-3a3f40c2b8dmr27385035ab.26.1729276792881;
        Fri, 18 Oct 2024 11:39:52 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc10c2b424sm534387173.98.2024.10.18.11.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 11:39:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
Date: Fri, 18 Oct 2024 12:38:23 -0600
Message-ID: <20241018183948.464779-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241018183948.464779-1-axboe@kernel.dk>
References: <20241018183948.464779-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's pretty pointless to use io_kiocb as intermediate storage for this,
so split the validity check and the actual usage.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 39c3c816ec78..cc8bb5550ff5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -211,11 +211,10 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		struct io_ring_ctx *ctx = req->ctx;
 		u16 index;
 
-		req->buf_index = READ_ONCE(sqe->buf_index);
+		index = READ_ONCE(sqe->buf_index);
+		req->buf_index = array_index_nospec(index, ctx->nr_user_bufs);
 		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
 			return -EFAULT;
-		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
-		req->imu = ctx->user_bufs[index];
 		io_req_set_rsrc_node(req, ctx, 0);
 	}
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
@@ -272,8 +271,10 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_mapped_ubuf *imu;
 
-	return io_import_fixed(rw, iter, req->imu, ubuf, len);
+	imu = req->ctx->user_bufs[req->buf_index];
+	return io_import_fixed(rw, iter, imu, ubuf, len);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
-- 
2.45.2


