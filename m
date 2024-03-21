Return-Path: <io-uring+bounces-1183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5039E885B26
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 15:48:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08757284E7C
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 14:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA57D84FBE;
	Thu, 21 Mar 2024 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qN5uL6cq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFA584FC5
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711032522; cv=none; b=EAjdERRPZax+LoKaZsNXvMxe2tvlxXzCJk2XF27SZGojsoAE82/J4KjsFh5eVuaSqjSh5d4y0PMWdeLDEArMgKXVwF3SvCq8GYg3DOU65lB96Vxp0afNABUvDlWU8rXGpZhPyKJ9SC8sZCvK+VM568dVWtOXOPGG0St/XuJHuqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711032522; c=relaxed/simple;
	bh=8G3QN6wuHYeuEtMo+UdWrxs8c//P5kJMH+4+MKrhbiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ixnm/JuPPZUjVCyGl/wXLSoGOJcwXC/bDGX8Lg4YYLcjKRoAPhePTeT5PFJqQO7cVCuFa9TxFKMi2Obl0rKEEA3pkLgtvh5hnWzHMhKPyTbpjoEH/vWc++Uie2AAwFhhZLbaqdmTZl/e1nVTLlW2sulkdjIRhLfOmh4eYTZDjPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qN5uL6cq; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so13371439f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 07:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711032518; x=1711637318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtvzBKul3lnX4UwRp+DUDb1X15hTCGMb7+BkwEEbcgU=;
        b=qN5uL6cqpPCygyBrdkrd0q6bSxYhOOglaYFax5gxsKPNivjpmGZnuEwOYnepWsaL8y
         CZJ5roXhbvwCK73fdwkYHzjW5HHIy+vYIsrZQmfwIOo9H53wtq3a8FYRhVLvxUtmsX3w
         nllvq7KDZd48llscMqOe4904BJ0rwj1xQHLLmZ3NVRNKBNHILD/8mCoxoclWxD+SpFyC
         v6vZWExTokh6qFXSbjKY2r27WfULqHRXqtNj0pSfo5gy/m01Tkz88apcmCsNq/2QBsqL
         n3kFSlxXKlnExJk6vLl851VXvf/K+td/CyYNv8JNLX91S7KZxAWdYgmEZf2EkEkYa7Ka
         iIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711032518; x=1711637318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtvzBKul3lnX4UwRp+DUDb1X15hTCGMb7+BkwEEbcgU=;
        b=VJA0uU86Kp9dmKYgMtaxm1NhcBAqFnH13F+YgSUeaCPGXXMk2Oqjp6y/cT8qIs3n2+
         ddXO1cm0CtoHpnN1+onz1CWceDUuXQHtTxGzXcuNqCezLvCKVSPa2HXgGEQr3Gy5BhXO
         DAM7TX8/HrIJQ3PWE2RGlbG6g27XixIZNhDiKTDB9kXYMqoZWh1aXdRPX48OnjQ5zLE1
         cg+d+nMvbp1ARhlq4UI/crQWJrg1Fn277cN4TbYk8bmVF83DMAQ3xqep2021KR0QObkd
         gL5TYxHBt/JWyi93AhqZ9gneQfN0KsSzXt394BZHL49YAyCvy65pvrebhoVU+bJlDr9R
         TFhA==
X-Gm-Message-State: AOJu0YypOh8Np0hecEDNTfd9Rr8+UY5jxt5iSwxEIWys8nXIodswTuHX
	hyURt/WKw1wMb4s4uiohu24LYAIPDuCTG1HIX72nPMWhsZMcnMOeNtnVbVueallolFNBrj8Kyun
	z
X-Google-Smtp-Source: AGHT+IHS4aXAc4FzRfTRMxRpDOOku9f6Q0tfupcvPbyj5lHg/eCzBdEbVNE1o3Y5Qp0F5l84+dx9XA==
X-Received: by 2002:a5d:9b87:0:b0:7cf:272f:a3af with SMTP id r7-20020a5d9b87000000b007cf272fa3afmr3125763iom.2.1711032518046;
        Thu, 21 Mar 2024 07:48:38 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q20-20020a02c8d4000000b0047bed9ff286sm250835jao.31.2024.03.21.07.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 07:48:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring/kbuf: get rid of bl->is_ready
Date: Thu, 21 Mar 2024 08:44:57 -0600
Message-ID: <20240321144831.58602-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240321144831.58602-1-axboe@kernel.dk>
References: <20240321144831.58602-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that xarray is being exclusively used for the buffer_list lookup,
this check is no longer needed. Get rid of it and the is_ready member.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 8 --------
 io_uring/kbuf.h | 2 --
 2 files changed, 10 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8bf0121f00af..011280d873e7 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -61,7 +61,6 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
-	smp_store_release(&bl->is_ready, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -721,13 +720,6 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 
 	if (!bl || !bl->is_mmap)
 		return NULL;
-	/*
-	 * Ensure the list is fully setup. Only strictly needed for RCU lookup
-	 * via mmap, and in that case only for the array indexed groups. For
-	 * the xarray lookups, it's either visible and ready, or not at all.
-	 */
-	if (!smp_load_acquire(&bl->is_ready))
-		return NULL;
 
 	return bl->buf_ring;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 1c7b654ee726..fdbb10449513 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -29,8 +29,6 @@ struct io_buffer_list {
 	__u8 is_buf_ring;
 	/* ring mapped provided buffers, but mmap'ed by application */
 	__u8 is_mmap;
-	/* bl is visible from an RCU point of view for lookup */
-	__u8 is_ready;
 };
 
 struct io_buffer {
-- 
2.43.0


