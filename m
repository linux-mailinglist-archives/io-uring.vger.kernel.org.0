Return-Path: <io-uring+bounces-12845-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEhQEY0Nw2lKnwQAu9opvQ
	(envelope-from <io-uring+bounces-12845-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:17:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E3731D3F0
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B1ECA30C2D85
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 22:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691E0239E6F;
	Tue, 24 Mar 2026 22:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ll53svyS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D38F3148DD
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 22:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774390522; cv=none; b=JaXh/EK+2aWZRzLtvC7OZwzxsWLk658yZRWCiVzkCvIuY2PbB4ki5e+CWClT7USl9VpVV40SsiHj2v185I58isd4s9f4paKXXxkO4255dWmog14lHe0mV//eAoWYcBobF+XNryhIXITV/16LevXrDt16Wz2uGTMefeLq5SsXNUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774390522; c=relaxed/simple;
	bh=d5YExv8Y+Lk8RnkmcqoroYnjWltvpPz2KtOBqvpPcL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0FBZIFNR+rNzyezdPOoTPszisJFqzR5j4rM4FIvBYym0oCdIZr76kaNUQjf3wFrMn9I8N3pDABNqaMOLCuhuFaBDzG+o5gEKl93He806a1e5rt91JxPlhEX5g3ptCzHDyXRcWl2XC8zpKZKJjzC8hHTC2oUhos5DqTHhDqDQaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ll53svyS; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35c05d7e0e9so977667a91.1
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 15:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774390520; x=1774995320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUS3bIrREsve/w2+HfX/jvGNTrwIj9OvdptgT8AMvDE=;
        b=ll53svySpwZFwaqStRceMW39kXlfV5hKLFa7Z6hZGRCAXNAvkqjzuJuzSgCqn5R1x2
         8CAj0U5YfMM2E6PBFYE/NJIXZQsKb16aLhowQ0FFGjZ/0HVED9n4b7B6Kpv9lt0Kp4q4
         RgyqL9VAB/n7GdLqe1HEbXaXEivV0IN4UEOdyrEtV/WuFF2m+i+9/7MRS/PLn73QvZx1
         3TwVKNDf6tWAJBDDgQyxGpTXuPoafIxUiPha5oK1QPKd45DGiSH0She2effikKGrMnog
         J88dpdbUXunHxzgaNew9mK9UPU/C13ngRygh3MkjMgpU7gcWMgAIBcY8iA54/aXZYbZt
         RnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774390520; x=1774995320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MUS3bIrREsve/w2+HfX/jvGNTrwIj9OvdptgT8AMvDE=;
        b=fbNyt9W/nm3m2EkZRY7YMAhqj8+zzY3v/lFJT9yiTmS+NdsdPp7pZmARAnbucQ4M1h
         ATu/8CgSChDdXrACnerN8LrSbvQafqGXB0Ohqbox7n4gTABm5yb8AGozFLTC4Zzn2U5w
         tmnUsEIH2TvR61ZamCxAf551P0ZEtT5Z2Sx/vgPtAkhBL3NbF/w7or9g0jd9vBki4GWv
         8m9O0TaoY7PbGjYR06Sgl9s5zapUa0/rtwHeeol3xy1ZGFGOuksULeZ/WR+foTAoiIVE
         +9F4jIwQUzFe3q25S/U9cDVA1ZNHyAYrtCA57F+zjjXXIaBZ3dZiPetBdo6mqD2eeuzm
         hi4A==
X-Forwarded-Encrypted: i=1; AJvYcCWCr3O3MECJ0cRdEaNB1oXIhMSW0u7rRIP6+z/UV1jgctSmBQdhfXUrVGeJ+990AjOT8KE2I7M6Fg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJOB5vnY9qEtH6lfS8mixlunJdCU/yjZW/bNiJXaFRdb3bHN81
	O7kg7gRFryLAff+T16jn27+K7VS/2HQy0OGLxf4PeFkOsjKG2jzlsYEz
X-Gm-Gg: ATEYQzwnjzV59zmZtl2CxSySdywZV10IwMwRYjAizjUeRrWjccZTxf544mmTHKwvJ0B
	4Ndyw6m0WXJ5vIHE5TCzamGRlPBk9TDAWVgZBdY1gg72PF1AgFF0B2nV2ueb/lTp8bcVKyYNR6D
	iuPHuobp3RvoMtxY3G6uP6x9NW3kFQ5ch1RS9Ky1XgD4VaPNBhc8GOcO6Zy/ddbArIGJ6UPfJnK
	Xh+M3TdJtTwgk4+z09fMCaZ3fMPILELJyWs+QC6CayTYh+jqeAJAosQGDFWLnQZ/fZMHv4EsJIC
	0c6XtCNaAJcS/Q06rZtmov23tXwuHi8jV4sNMWEd24UjNT3QJPTQpIwBNsLY1PV6GQoiDpttK3c
	sgI2NcikoYziqmWgTs6CibrsWAjUPRJQMQZbePDYcyIEexq/D283yf7e1MOZmdbwQcf5NPkMgu8
	Ueb4+F27iENe3O33Xm
X-Received: by 2002:a17:903:2f50:b0:2ae:593c:48fe with SMTP id d9443c01a7336-2b0b09e6752mr12315305ad.13.1774390520602;
        Tue, 24 Mar 2026 15:15:20 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:b::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08355f994sm157879805ad.36.2026.03.24.15.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 15:15:20 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v3 4/5] io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE
Date: Tue, 24 Mar 2026 15:14:25 -0700
Message-ID: <20260324221426.3436334-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260324221426.3436334-1-joannelkoong@gmail.com>
References: <20260324221426.3436334-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12845-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B3E3731D3F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Rename IO_IMU_DEST and IO_IMU_SOURCE to IO_BUF_DEST and IO_BUF_SOURCE
and export it so subsystems may use it.

This is needed by the io_buffer_register_bvec() path for callers who may
need the buffer to be both readable and writable.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring_types.h | 5 +++++
 io_uring/io_uring.c            | 2 +-
 io_uring/rsrc.c                | 2 +-
 io_uring/rsrc.h                | 5 -----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 328c3c1e2a31..0f41f9351a78 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -44,6 +44,11 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+enum {
+	IO_BUF_DEST	= 1 << ITER_DEST,
+	IO_BUF_SOURCE	= 1 << ITER_SOURCE,
+};
+
 struct iou_loop_params;
 
 struct io_wq_work_node {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 16122f877aed..b5debc615657 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3215,7 +3215,7 @@ static int __init io_uring_init(void)
 	io_uring_optable_init();
 
 	/* imu->dir is u8 */
-	BUILD_BUG_ON((IO_IMU_DEST | IO_IMU_SOURCE) > U8_MAX);
+	BUILD_BUG_ON((IO_BUF_DEST | IO_BUF_SOURCE) > U8_MAX);
 
 	/*
 	 * Allow user copy in the per-command field, which starts after the
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 039e3b30ff60..cf5638406a0c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -820,7 +820,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
 	imu->flags = 0;
-	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
+	imu->dir = IO_BUF_DEST | IO_BUF_SOURCE;
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index cff0f8834c35..8d48195faf9d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -23,11 +23,6 @@ struct io_rsrc_node {
 	};
 };
 
-enum {
-	IO_IMU_DEST	= 1 << ITER_DEST,
-	IO_IMU_SOURCE	= 1 << ITER_SOURCE,
-};
-
 enum {
 	IO_REGBUF_F_KBUF		= 1,
 };
-- 
2.52.0


