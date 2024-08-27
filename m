Return-Path: <io-uring+bounces-2959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B219611F8
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 17:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABA8F282037
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 15:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F95B1C6F57;
	Tue, 27 Aug 2024 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Axfq3bfN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00351BDA93
	for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772309; cv=none; b=jToJjf8gT2gc5gQ9/cZYZTcqSJlJNbmAu8KCRaT3HBM+XzwCdoalvqCWeQ3mKqciUTS4OnWlgTdTzmVFmtDEmE0zkv9SmbOs2ASvy1fjhn9EEjZhOUBpD053Go7rnTGzPS5fNy2NZSZNjmNOzrlWs8tVNGYClCvWwlU/6IcuS6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772309; c=relaxed/simple;
	bh=qIbW6FfeBAgiAEVPpNmmbKusruIunvSfddy/MHjgqTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkF4sAu/mSrLZiYnm6EHpMYRSsdBhksMUa24xGj0mlFY5tPIuaMCPIBwb0ZTNsmT3wtGjAz5tQ+1pIhMwaDVg1SZn86f2wTUpkuuY3Ft0zdU9kRWdO8eekzAp9HvzYtgi54fxyd42I2zM9+8VIomtrF+HUVNQuZMkG8bmzS7Qw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Axfq3bfN; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-824c85e414bso194902039f.2
        for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 08:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724772305; x=1725377105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCOM0Q4MgNqZ63rGSpWE9o76VU8Wgv7xhomNVx1Fsek=;
        b=Axfq3bfNYF0DWzhDlHaxFnENZdR7EHS4Dj8mBDAl5i+zXmvL8TTwSmp5LGO0hk7K8z
         nGTOjQU51ybqxUIgRGlTeFYLYYmQ5a0j+P0qcIGTz7FXwweAsyOt8IXKdykXsHRNq3hB
         nIwq/8AunIBiIUakRsMNPfZRBt2fXck1EL1xD7juLTokn3dEG3zD4TNldeAeOBXEDR0s
         yLhO8P/dUrwb0IPOPMNjsYjdQnJ9XaVhj6EizWDloBkbUeL5D5wrM1u8gzDW4jTHbPw7
         ezyqNJhyH7e3BzV3W5s3UnqnPrS+idjrNv95t+zae8U+so8cb71oQvWiOVWtzIAftkMH
         t4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724772305; x=1725377105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YCOM0Q4MgNqZ63rGSpWE9o76VU8Wgv7xhomNVx1Fsek=;
        b=PQ4g4Bc0gqd8AuopBeAezrhzMbccmI6HXHBv7WiEj/C9bBPuoAdWKG08rUF0UBQJzx
         7umJYaSDeHXU9RvzPgerRfokfiEGRyQzfN45viqOcVS9q/+lKWqrLTxc0f2m3ayqFga3
         Yoe30i0QFyVLF0yVajz9tfxobOLRYmOw8qiLuGKnIS/sy18LPGds1fKb/GsJ+FJ10Vvu
         b3QS3J3zKlm0KJRYDMsVDa0ZIe4P2kA2PYp6N+iynUrh1TIAYnCFexMuBKwaKkovPdfq
         6+Y4qMjnehe8PztPK3GpSMrvpiyHOJptlVNfrIP8wi4zMze3CT4UQUnhjSoe9brVNGSf
         ZIBA==
X-Gm-Message-State: AOJu0Yx/3pAhJl0fVms7esVFtQfwQy+Vz88tTdltgO0wvDRW5huOJWch
	hV9IUEpEyQ4stEeYvnwEyZGNl8pYyZU8o/TdPR+8ysnWGCrr2SxqBCR9Ae2DTPfDvCMvUDgy1Wh
	q
X-Google-Smtp-Source: AGHT+IFHjxvo9IE61KwKoCVK+H+WtTO66IlkuHx5RV38tA7zb9fRzB51Z39vNqiVZwxZB/5rHMY0iA==
X-Received: by 2002:a05:6602:3fcb:b0:805:afed:cea1 with SMTP id ca18e2360f4ac-82787376a19mr1579224939f.14.1724772305391;
        Tue, 27 Aug 2024 08:25:05 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce7106a4a9sm2678580173.106.2024.08.27.08.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:25:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] Revert "io_uring: Require zeroed sqe->len on provided-buffers send"
Date: Tue, 27 Aug 2024 09:23:07 -0600
Message-ID: <20240827152500.295643-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827152500.295643-1-axboe@kernel.dk>
References: <20240827152500.295643-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 79996b45f7b28c0e3e08a95bab80119e95317e28.

Revert the change that restricts a send provided buffer to be zero, so
it will always consume the whole buffer. This is strictly needed for
partial consumption, as the send may very well be a subset of the
current buffer. In fact, that's the intended use case.

For non-incremental provided buffer rings, an application should set
sqe->len carefully to avoid the potential issue described in the
reverted commit. It is recommended that '0' still be set for len for
that case, if the application is set on maintaining more than 1 send
inflight for the same socket. This is somewhat of a nonsensical thing
to do.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index dc83a35b8af4..cc81bcacdc1b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -434,8 +434,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
-	if (req->flags & REQ_F_BUFFER_SELECT && sr->len)
-		return -EINVAL;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -599,7 +597,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (io_do_buffer_select(req)) {
 		struct buf_sel_arg arg = {
 			.iovs = &kmsg->fast_iov,
-			.max_len = INT_MAX,
+			.max_len = min_not_zero(sr->len, INT_MAX),
 			.nr_iovs = 1,
 		};
 
-- 
2.45.2


