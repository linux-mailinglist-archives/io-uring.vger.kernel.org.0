Return-Path: <io-uring+bounces-7495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F90A90C50
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 21:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32190460A50
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 19:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A386B222585;
	Wed, 16 Apr 2025 19:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PDeZFVAA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4747A17A304
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744831682; cv=none; b=Z5fHVYR5GmHMq1oaMIc9cmaSXnFIykheEDnZZjGqg7SQ4/bCm8qhbogboxvWhLVSG03YdfiwJ5lXdrMxinhy6VEC58c/W3HRHJbvU2YNCaMcLcERTvgDWfR2snnipeUnaQyVKiK3yHoroC4ArfSqMdg02r/QfaWXCm1AyWHg8gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744831682; c=relaxed/simple;
	bh=2Hx9RcJJOgRT9AAW7lwN9S4as6r7WTa4uhVSSVP+umw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=g2B4pJwWIGeWY/tf+PoQ7L6QDcOv6XJwuPVJOji6C04j9nN9xJwHkDSioCk0C2+UDhwRsZNtkiXoXVhe7jRLxKLZs+RippYN9Nf83JH/Nk0XT4sXNWBTxFQR49Y9ImD4edQMFea52cTSyBM1DDUiugtEJcJoerdv3174QQsXPxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PDeZFVAA; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85dac9729c3so549720539f.2
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 12:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744831678; x=1745436478; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNNG1MQBBussY3AuE42Ywv/1S7yi9dN3sjuK5xf43+8=;
        b=PDeZFVAA1SehpkHeSVIrxuT4FMrFWTABIk2LUU5Xe5soIfeclec8s2qcGDAD2pTa0I
         JS4yJY/V7snJ/pwSP4r6HWdTQX58KiAkI3yEIVID32Od9Wvv+i7tFC35P2Zo/lGKSOlv
         wy5Lz1sisCQFAwpYxnYjm5p0EnTUfSDdhr+NFngSTAx5UYADqTv4GWUwOu0PHVl4H/6C
         M1/02GyMT82u+7pmg5ZTe2LfcGDGRnWtzoNz3Dgmw3rF0VdgFDR0KrtJjdhhVCPylav6
         mwENRM8+q6si9C2/RbSKo8saIo9YvERF/ol/UDY79xT5jlFK10gCRJ485zdlOeV9TiPz
         /CAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744831678; x=1745436478;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZNNG1MQBBussY3AuE42Ywv/1S7yi9dN3sjuK5xf43+8=;
        b=BgDc46uGFnwmOFnjSK8fCV9kHb95Pb4qIHAeK7xrDF0kxcuVjKw31xpyUP/jrEzUPy
         InxDlijtcsRZmS8gZebXzRgFIBQ2NF9f80DPmhIWOlLdDIOmLq1j0ZAcfJljUQtitlcf
         u4KfFPjxKygUXoL4EhMtFjZ74FJgK4CD/obLJft1nrRkFj3wssprIcEMfdoQ6VZXkC8R
         tEdd3Yim9x5xVURLxil2RYiES4RG+Y4cGaqahtTLvhY/g8OiMj+gPfbPJY2i+UD70JpY
         IPTLwcoBVUYmbWdOHaZfDevG7BXlAGao1iB/job0LV+cm+t9dVplp3nLSIQelkpCyfc9
         PCdw==
X-Gm-Message-State: AOJu0YxqAyhqnzN7pwiX7rYSwLZ0NdafQuiajPMpYkAHuY2/M1FWX/xW
	88CsezFtfxF/bxSb2gwJyW0D47jn+mhroDIvZoK5pNe1tyAOp57ZvlzNuYshvHVsa8qUFcC7JCI
	5
X-Gm-Gg: ASbGnctlql9J7lnCd3AOa1RCNn9DI5pkzxD/polhomS7Znoi5VSy6c4XD9BJ8NyLrCu
	3zSF5MCvO9FZ6t9MgGtE9VDWNmvUxCGbmXNuB4o8BRgo/s9+eLtunnKJWPocDmCWahTOy58V3Vh
	H1IyJcowOrF8C3xDV4rpgbwB+3YEetlXCmDjC7ANLtWdqNcZBAMVsikxJb4bHXcRZ64CC1VFDdv
	VamGG25GPAqSgc5nG4StU0nnNq8VIzCAAQ4J1s2z97lHEqp/UxdIe8gMu27tKUBKaJrQX2mjul5
	/xc+nS3nK/vTfmwN7zXmMZjDOmYjXZZYnoC6
X-Google-Smtp-Source: AGHT+IGjW50UwVJhAsXd/ZtSGVb7oNfsqjETPvCiloU+N3gCEeiSolBXu3XTX3MaaIvyp+sgz7KR3w==
X-Received: by 2002:a05:6602:360b:b0:861:6f48:4a68 with SMTP id ca18e2360f4ac-861c4f742f3mr391391139f.3.1744831677884;
        Wed, 16 Apr 2025 12:27:57 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505d161b2sm3815622173.45.2025.04.16.12.27.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 12:27:57 -0700 (PDT)
Message-ID: <d0facdaa-04bc-4e20-abfa-f91427347594@kernel.dk>
Date: Wed, 16 Apr 2025 13:27:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/rsrc: remove node assignment helpers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There are two helpers here, one assigns and increments the node ref
count, and the other is simply a wrapper around that for the buffer node
handling.

The buffer node assignment benefits from checking and setting
REQ_F_BUF_NODE together, otherwise stalls have been observed on setting
that flag later in the process. Hence re-do it so that it's set when
checked, and cleared in case of (unlikely) failure. With that, the
buffer node helper can go, and then drop the generic
io_req_assign_rsrc_node() helper as well as there's only a single user
of it left at that point.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

 io_uring/io_uring.c |  3 ++-
 io_uring/rsrc.c     | 12 +++++++++---
 io_uring/rsrc.h     | 14 --------------
 3 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 61514b14ee3f..75c022526548 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1912,7 +1912,8 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	io_ring_submit_lock(ctx, issue_flags);
 	node = io_rsrc_node_lookup(&ctx->file_table.data, fd);
 	if (node) {
-		io_req_assign_rsrc_node(&req->file_node, node);
+		node->refs++;
+		req->file_node = node;
 		req->flags |= io_slot_flags(node);
 		file = io_slot_file(node);
 	}
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b36c8825550e..68b5f2568c7a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1108,13 +1108,19 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 
 	if (req->flags & REQ_F_BUF_NODE)
 		return req->buf_node;
+	req->flags |= REQ_F_BUF_NODE;
 
 	io_ring_submit_lock(ctx, issue_flags);
 	node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
-	if (node)
-		io_req_assign_buf_node(req, node);
+	if (node) {
+		node->refs++;
+		req->buf_node = node;
+		io_ring_submit_unlock(ctx, issue_flags);
+		return node;
+	}
+	req->flags &= ~REQ_F_BUF_NODE;
 	io_ring_submit_unlock(ctx, issue_flags);
-	return node;
+	return NULL;
 }
 
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index b52242852ff3..6008ad2e6d9e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -127,20 +127,6 @@ static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 	}
 }
 
-static inline void io_req_assign_rsrc_node(struct io_rsrc_node **dst_node,
-					   struct io_rsrc_node *node)
-{
-	node->refs++;
-	*dst_node = node;
-}
-
-static inline void io_req_assign_buf_node(struct io_kiocb *req,
-					  struct io_rsrc_node *node)
-{
-	io_req_assign_rsrc_node(&req->buf_node, node);
-	req->flags |= REQ_F_BUF_NODE;
-}
-
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
-- 
Jens Axboe


