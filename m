Return-Path: <io-uring+bounces-7922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B615AB1167
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55F45984E96
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E485128F514;
	Fri,  9 May 2025 11:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nv8GN3fp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341E513C816
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746788557; cv=none; b=o7Ogs1yRhSivV9LBZHx8o5ry++1h9Jk5hDCqzS9sow+9nPR6J/F1O9wKn8yWd8geszN2FOC8gNIIbHoyHQv+joCMtJlREvzgiaN5hHMKZXJAxs8aok3xT4UpItLiOHGe9w6cyusgZpYAjT587euDztRaXh61Lr7+zUXbguliGrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746788557; c=relaxed/simple;
	bh=dhxcGBS7qX48Vf8dKorrs4XaoVAYcnz2YdJqC0XwbPs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UEBoziGIeqLhITOgpTNnp06sHrEBttBleX+/5P/zmXxnbN3AAN4aJyuc4qb1DChvqutCq5HD4cBMqntwdJb3NG2M/Lydq2myf/nsbznL3mOXwI9INmuPRD0eYXY/fDI5cc1oZZeC4KscGxKnxjd7cTI/poQtkJxQIUFTZ9boLR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nv8GN3fp; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac3fcf5ab0dso323286366b.3
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746788554; x=1747393354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JT44WxhMb5bWacoZhQOmZoYgcb69+7Ol786h4zpRPVI=;
        b=Nv8GN3fpVjeanFmSYz44yU1jjr2VXQ8X8X61q6bmI/J8Yq674mMleQHqaYOm+KHdLJ
         Bv8HAbIp2D0lJP9p18bxufcPriivziG8lPa2LWL6LFEDGBo5hyBsWIprGJVNAfv71CgW
         CZ8rGiSF1jcQSN3hbxCaYRW8Iu0UodTuys8yuXH3QXDEkIe/vABGOpUG63eDdsVCtasd
         rKFT/L3RxKgwpTr5nIjWCJsrK9lYZi1hZPfAqZKEG/6H7yW9jUqb3uxbgo1/N4NF9xTj
         lq4+awP0n5pOFXOFPvH5H3Blkd5nuUcJjEiF4zjsHO3frB6pByQEgq9NyP/6cO4bb4G3
         zO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746788554; x=1747393354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JT44WxhMb5bWacoZhQOmZoYgcb69+7Ol786h4zpRPVI=;
        b=cduIKE076wu/b7h57jV4H66Kpp6HwYen2myqElf1e4MRndsObCdJIpZvFvmXIxV0+X
         qkNy2d/dVXGxgpGi17nvm8bazMmtG6N4kNjF0/KTqwHqMf7UDU8CE93BBiuq4/leutiy
         42xmB80zOXKQeTrmWuAoSUjbM8qFNTR+YrMweMXN4C1X6AvL5WkMccnGuPLyf4p+v9ee
         CJk+Ay39HaH9My9+Ljq5sUoorlMsA45h82tO0TiE1UdG7vx3SGtDRx5Kic8qpvrsEGcD
         bwlGogLwjnF89sC4f6/D9LRkxLhi/chiRbXKnAsiGYXv0SYdSwKsTaLAIt3D0AIubIGu
         3pBg==
X-Gm-Message-State: AOJu0YwqR4DlMKhQEw4H8Z7seqVNmIhnoPBBl4R0bKfZM3YN0H3Ju97V
	wtAF5NkuUdLHkQ6DbEs9CnIiQjsMfiyL3OkrdVeDE5ajZPAiltVpO7PUNg==
X-Gm-Gg: ASbGnctAG+bw8CgcMerMnZ3bK5yooVCcpfmcjOUVixeV/tZSMbi4dD0Qc6fIo14/Pap
	6YeNa98sxQlqcu9NHO8/jslyINMtSDExtaPX0gEjEmj7SE5omIYCBGVIguAcN6Y4J2KRS1Lvq8H
	w6DZ+3r8X2UvBlhRfdLCxlgamr9kC97oRFUbp/jFk/t9aHH7CvjfCBm1Lxz+Ja5ON6ODqpE+oS0
	Z3IHSjD6hSuC3GZslEFa7orR8sMCFYSHbSsFCs8/VtRdCMuUWGk96TeGYDYdT7Z89QshHDRQthb
	bYhzp2VzK/QEj6njocUHJW/E
X-Google-Smtp-Source: AGHT+IGnzb0qvNN3beJ2qT09/yHMI7s8geZ/5AKawHwBgWcF/ENnHIT9jGY1dhrrpPE65FdlruyUVg==
X-Received: by 2002:a17:907:c717:b0:aca:a3a8:5560 with SMTP id a640c23a62f3a-ad21917977fmr270066266b.53.1746788553696;
        Fri, 09 May 2025 04:02:33 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219854c6bsm131807766b.166.2025.05.09.04.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:02:33 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: add lockdep asserts to io_add_aux_cqe
Date: Fri,  9 May 2025 12:03:43 +0100
Message-ID: <c010eab7b94a187c00a9d46d8b67bf7fcad18af4.1746788592.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_add_aux_cqe() can only be called for rings with uring_lock protected
completion queues, add a couple of assertions in regards to that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0fda1b1a33ae..13b8baaef834 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -844,6 +844,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
  */
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
+	lockdep_assert_held(&ctx->uring_lock);
+	lockdep_assert(ctx->lockless_cq);
+
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		spin_lock(&ctx->completion_lock);
 		io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-- 
2.49.0


