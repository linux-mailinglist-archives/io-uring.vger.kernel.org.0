Return-Path: <io-uring+bounces-11947-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GPCIKAAFeWk3ugEAu9opvQ
	(envelope-from <io-uring+bounces-11947-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:33:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3532D991F5
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A2EFC3031F39
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BF2328246;
	Tue, 27 Jan 2026 18:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="abhcqOeH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7462D328253
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538802; cv=none; b=dYKXCDu86n0iqrIfRco2jNIC3AScuge9tgh4bmWduo57Qw24dc6qcRgNp4qze8eddYcvub961iIpvxeh8qUZIFMPSU666P0jhWTjkdmAJGnDKA1eNSDKIGUCjJH/Yw2/T+3d6Jc10jaXrSmJ0iId9vXj3xTHDLgjDhWNXvoQaWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538802; c=relaxed/simple;
	bh=Izuujja65li7M47y59O7hoaC2WNuHD1oDxrLjSFueqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjemNrAsTgfRK/S3htHqQXkTzyg/IuU4ldbTNdjANFXblwWsZc72+PaKr+aMREJORqSYPejATGV4HviYL/XPRJPlsMv29e/yIEyVz5MAcIcC1oZ+gJPWueeRLoGeJ+qrVhiAg/0R48I0Q1ysbQl+EC26E15oezUTJ3USD+6VxlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=abhcqOeH; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12336f33098so5207783c88.0
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769538799; x=1770143599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSomEv/U88XAttduCJZ2/ij9ZRPQjub2vgRQspMsE+M=;
        b=abhcqOeHZ7asnSgWBDBELY9IFqIbyNvg5972fZ+tXCD3YuaYGz6iqYEThhBGDHaN2S
         jcYXgaHwP1GDXtR33N956/VqpE+0AkoIcdDVr9wiqcCQAdixgDTX1Den+ChnqET2dRr0
         VdAVhwyLKQSnn36S7Oum4wLpavLWdVsXyNsHt/zThwsbyblFs+nvstIp82uWeWzwCfPD
         8tAotdEJONIOYhvlfVro19i8/hZ6RTDV0CjFJLsSwVn8dEJfKd43xvixy9NF4hvyqTBj
         PIbeHjYKlD3ZWW4jW6y8RdKCtlSN+W1PZqNyLySxImSyCoyD5sE++MMvMEx2VaAgZarU
         Zj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538799; x=1770143599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JSomEv/U88XAttduCJZ2/ij9ZRPQjub2vgRQspMsE+M=;
        b=WYFx6a7PwM5GdB/cO/5PmYYhHUjZj0vw38oUgBxwg21E3jRnMi6RZTttWXnZMhSNue
         1GOyrar4QFN5N2kopKHzAtDu+iYtnsVcTUqbagqrb2FUjaD7eBYWtJTpZyPsPqvOmSbu
         0f0XMhxMxWxd9+xuNBVis8CWNwLoWmWbzjEwrqwsgVgiRHLi2OHWGOQDiUodkexWywVf
         BNh6AOPwIrXAKr5q7+sLdatKWiTDiKgoLPG9CywD1wU462A5TvSIDnY7Dox0/PjM0xHi
         1MOgx+FfwMvkysMSW1MlrN3aAgc9ve33ZCbmQRuFMHlWC9XqLwfF+4U8NyvapUuuLNcs
         03QA==
X-Gm-Message-State: AOJu0YwKnb+CXtAfG72dx0m5sVUeZcVwgeH5Eiq8n2HdKxC6ELEppk9+
	clYSGthypT2yALMCeYLiNpEvnLXYe0SwEREbKnn20tkyfXxXZSSuCSwNhob1quwqVYNk+3F/gjH
	hslJw8ak=
X-Gm-Gg: AZuq6aIvtG7Sv9nK7vj66bjsJXWkQzKYtBQDI+bEFVplkLPPMRCeYitn9h+ccS7jgE0
	Sf6bmMJELfkmh+H0xyCeAUCKP++CL3Iydqw69jvB7RcJkeKxx1Oz7Z/RUm6wd+rDEdDonOwqJ0n
	NuStV7BN6T7gzpiqhmaRR7Y3Ije9aROv8gQjfzeesYplcVPmby1s2UXwxlW5PQ//L+WRAjJkb2n
	/eNaKkygJ6z/+FElVCmmLLf0voo9KF0LIDta0yRQKhtWUD/dT5BjICDzdJ4X+mVoA8WTSDHEre8
	YnOcKY0Un+Xiave2D+M+A3k1CFzbWl809FAfrd8ml8cqTFAzGzxjtPlqK8z3SR9uE3Mo7zYHGtk
	pv7CZo6EW3LnOLGBXmOlnctUdbkruQCb4o4ZSZlmXHD6UOhPw9C6rqKIEVle3ycxWxwhKg0YCRD
	+Xh6HqGA6wxsoEl4fKGfOjPDHFi5S91nz2kFzMZPgb+rDSWWAOpBgWDmCwTjpp3kmHIuQtF+Rb
X-Received: by 2002:a05:7300:8183:b0:2b7:1c58:dc8e with SMTP id 5a478bee46e88-2b78d93cfedmr1197716eec.17.1769538799003;
        Tue, 27 Jan 2026 10:33:19 -0800 (PST)
Received: from m2max.corp.tfbnw.net ([2620:10d:c090:600::cedf])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a7bd05b1sm670139c88.3.2026.01.27.10.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:33:18 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	cyphar@cyphar.com,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] io_uring/bpf_filter: allow filtering on contents of struct open_how
Date: Tue, 27 Jan 2026 11:29:58 -0700
Message-ID: <20260127183311.86505-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127183311.86505-1-axboe@kernel.dk>
References: <20260127183311.86505-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11947-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 3532D991F5
X-Rspamd-Action: no action

This adds custom filtering for IORING_OP_OPENAT and IORING_OP_OPENAT2,
where the open_how flags, mode, and resolve can be checked by filters.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring/bpf_filter.h | 5 +++++
 io_uring/bpf_filter.c                    | 6 ++++++
 io_uring/openclose.c                     | 9 +++++++++
 io_uring/openclose.h                     | 3 +++
 4 files changed, 23 insertions(+)

diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
index 4dbc89bbbf10..220351b81bc0 100644
--- a/include/uapi/linux/io_uring/bpf_filter.h
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -22,6 +22,11 @@ struct io_uring_bpf_ctx {
 			__u32	type;
 			__u32	protocol;
 		} socket;
+		struct {
+			__u64	flags;
+			__u64	mode;
+			__u64	resolve;
+		} open;
 	};
 };
 
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 889fa915fa54..ff723ec44828 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -12,6 +12,7 @@
 #include "io_uring.h"
 #include "bpf_filter.h"
 #include "net.h"
+#include "openclose.h"
 
 struct io_bpf_filter {
 	struct bpf_prog		*prog;
@@ -40,6 +41,11 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
 		bctx->pdu_size = sizeof(bctx->socket);
 		io_socket_bpf_populate(bctx, req);
 		break;
+	case IORING_OP_OPENAT:
+	case IORING_OP_OPENAT2:
+		bctx->pdu_size = sizeof(bctx->open);
+		io_openat_bpf_populate(bctx, req);
+		break;
 	}
 }
 
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 15dde9bd6ff6..31c687adf873 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -85,6 +85,15 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
+void io_openat_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+
+	bctx->open.flags = open->how.flags;
+	bctx->open.mode = open->how.mode;
+	bctx->open.resolve = open->how.resolve;
+}
+
 int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 4ca2a9935abc..566739920658 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -1,11 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include "bpf_filter.h"
+
 int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 		     unsigned int offset);
 
 int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_openat(struct io_kiocb *req, unsigned int issue_flags);
 void io_open_cleanup(struct io_kiocb *req);
+void io_openat_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req);
 
 int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.51.0


