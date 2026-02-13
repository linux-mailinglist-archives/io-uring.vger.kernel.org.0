Return-Path: <io-uring+bounces-12186-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CDnvBsiYjmnXDAEAu9opvQ
	(envelope-from <io-uring+bounces-12186-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 04:21:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73EBB132A23
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 04:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 66086306ECBF
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 03:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9922623183B;
	Fri, 13 Feb 2026 03:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="BAq4MNg0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f227.google.com (mail-yw1-f227.google.com [209.85.128.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724D11AF4EF
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 03:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770952891; cv=none; b=ldH5jUzae6W8vm1wTKHT8QYo/qbmeWhXT3LLNsll2Jz/OQsR4RAmEzAU4a9juehAqFHYWunjrbjH2vQ0Oqb8waKv2iZaEqJghijnq+vz2wghRvhM6kWnwvcv5xS8axYaJt326Y14XZqIHoY79WpiuEIlQpbzTNhQRU5TvInI66A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770952891; c=relaxed/simple;
	bh=lZe3fxg+VQ5lhyCBMGop87GGnO7ejMyIhE9/3qGM+vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiFcloZbISnxND2OhMq6KoGgG2GusGCA0sTNwMk4t/aS84kHoorSrTxbqIcjv0L0J3ZO4HNBKiks1/GUZ/KttEeoGBB9/BB46esAQTHpFwknMxzj2wMg6vla5sKip9cHrkQpuVqLDnJT7yPLSJ0ecmRtH2vBLqx8IrV/ZcpgQ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=BAq4MNg0; arc=none smtp.client-ip=209.85.128.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yw1-f227.google.com with SMTP id 00721157ae682-7968b6f6dfdso837317b3.0
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 19:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1770952888; x=1771557688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HDAVuczYme2L/3ZbykT5XhXGRZz1afWAoembS53B+4k=;
        b=BAq4MNg0mKL6GrhnFpnoIoHPtbzZWwLOpvaJUubnl9L/FZqztJtKJ11fZh9UQDEZvB
         fsdLb4Y32VCdrsRzRNYe/eJLORY8KjoHJM52tRaV7/oyg4FUHhn31/+8M/4Utx3jjx+0
         3hdXPMhQdlLukGtqQ2T2vGbfWqQhGXobUllEPVX8ozOasbP0/t2iwqoC5JjMlOzdZYj8
         kCs5crCwyG1GnJUHye2gal0xoIXgo7dcU9xET4Wl+Zdxh5ffy5xc4ysgBh1fyDvhjtfD
         axOV8SYCk0ChcFT4p6KwVAXJfeeWS7e1nDc6Ap38NZ7vpqQRmYBaaYlMpKVEhD0o6yKV
         YIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770952888; x=1771557688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HDAVuczYme2L/3ZbykT5XhXGRZz1afWAoembS53B+4k=;
        b=tKtxloe6YAwGdPIPopABHMVX+jzAzDcyfYw8QItAYjVwhLxNgmdZ5BvF2f4wAlo5hV
         7WCwUlOjGHGDreKERS3dzosqZg3/yMT8xMZEgf9Zv4kb9nY0itvH3SBVyawyHruTkPub
         fNQ0SxoWu3PfyZGa1jK95/a9kGodOtPaKTWw1RDx3gVi1kshOvrCK+JF0VeceiM864N0
         EkZnZayAlg1+Q03nsaqGPb3kr8ia7TbeRspaUhMgJ7wMdYCZqaHF/kTkPklAAJp1g5EP
         BThYrSI5cwEmt6zPAR8H9KOjUzQ36LITSNeGOz++86j9M7tBqTatVHdJxvXfrAVAkDen
         H/kw==
X-Gm-Message-State: AOJu0Yy7g4Ia84zeEtvrupeHmWvCY7hJadLPHJ7awOAGyq33t2GbxLVf
	sUPRfuoDDGWcGg9uC5YCkJYOs4/7wgd7Wyx7UnYS7Ba80v6NbhI5DMN94eb+pf/0n40OYxlCY61
	3LKs2vUBTnU98kZsryoorMU4ECFKFFKwkIecc
X-Gm-Gg: AZuq6aI24S0LK1d6dTP33DgJiVA0yuu2w95K8Ug/E1y0Sloxn0REXqZpcJIydkzJP4q
	dFuSwUxFB4+UQdo7ezVQ4ZBZqk3RG7RDUy/sTPeqUkkKI6Yf5SYTAMN4DVFgOwNk3XyKjzrgxPM
	j5dJE5ufQbsQqPwVviTv3QXhLnJ/HCxSlk4XjxblXQe0W7CSp2JrqGPGGjD+RNj5JhcL2THUADX
	Ux5a5Vk2/A650r/YP9itDaGtT4X2LczrQkl1QXDRRRgVuGmZG7ZtrMFa6TEz/SC90pArrNOpjAu
	PvDvbSSq0C8CzAs7yAaZDvzl2/0Yrvo/mf6vgVR+vK3YWPIOjVAbU95Z0p4Ht8F1j2FbY3jE7F3
	xtwb66t2IAlfPmXOVXJL2+Spk0PhQ21EVUGh9jEDIlTmvjdyuZTOgXw==
X-Received: by 2002:a05:690e:bcc:b0:64a:dafd:2d5b with SMTP id 956f58d0204a3-64c14d8e089mr1001606d50.3.1770952888480;
        Thu, 12 Feb 2026 19:21:28 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-64afc969f13sm637387d50.11.2026.02.12.19.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 19:21:28 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id E0187342181;
	Thu, 12 Feb 2026 20:21:27 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id DA782E41DCC; Thu, 12 Feb 2026 20:21:27 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 2/3] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Thu, 12 Feb 2026 20:21:18 -0700
Message-ID: <20260213032119.1125331-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260213032119.1125331-1-csander@purestorage.com>
References: <20260213032119.1125331-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12186-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,purestorage.com:mid,purestorage.com:dkim,purestorage.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 73EBB132A23
X-Rspamd-Action: no action

Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
requests issued to it to support iopoll. This prevents, for example,
using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
zero-copy buffer registrations are performed using a uring_cmd. There's
no technical reason why these non-iopoll uring_cmds can't be supported.
They will either complete synchronously or via an external mechanism
that calls io_uring_cmd_done(), so they don't need to be polled.

Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
even if their files don't implement ->uring_cmd_iopoll(). For these
uring_cmd requests, skip initializing struct io_kiocb's iopoll fields,
don't insert the request into iopoll_list, and take the
io_req_complete_defer() or io_req_task_work_add() path in
__io_uring_cmd_done() instead of setting the iopoll_completed flag. Also
allow io_uring_cmd_mark_cancelable() to be called on these uring_cmds.
Assert that io_uring_cmd_mark_cancelable() is only called on
non-IORING_SETUP_IOPOLL io_urings or uring_cmds to files that don't
implement ->uring_cmd_iopoll().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c  |  4 +++-
 io_uring/uring_cmd.c | 11 +++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c45af82dda3d..4e68a5168894 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1417,11 +1417,13 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret == IOU_ISSUE_SKIP_COMPLETE) {
 		ret = 0;
 
 		/* If the op doesn't have a file, we're not polling for it */
-		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
+		if ((req->ctx->flags & IORING_SETUP_IOPOLL) &&
+		    def->iopoll_queue && (!io_is_uring_cmd(req) ||
+					  req->file->f_op->uring_cmd_iopoll))
 			io_iopoll_req_issued(req, issue_flags);
 	}
 	return ret;
 }
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ee7b49f47cb5..8df52e8f1c1b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -108,12 +108,12 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 	 * Doing cancelations on IOPOLL requests are not supported. Both
 	 * because they can't get canceled in the block stack, but also
 	 * because iopoll completion data overlaps with the hash_node used
 	 * for tracking.
 	 */
-	if (ctx->flags & IORING_SETUP_IOPOLL)
-		return;
+	WARN_ON_ONCE(ctx->flags & IORING_SETUP_IOPOLL &&
+		     req->file->f_op->uring_cmd_iopoll);
 
 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
 		cmd->flags |= IORING_URING_CMD_CANCELABLE;
 		io_ring_submit_lock(ctx, issue_flags);
 		hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
@@ -165,11 +165,12 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
 			req->cqe.flags |= IORING_CQE_F_32;
 		io_req_set_cqe32_extra(req, res2, 0);
 	}
 	io_req_uring_cleanup(req, issue_flags);
-	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+	if (req->ctx->flags & IORING_SETUP_IOPOLL &&
+	    req->file->f_op->uring_cmd_iopoll) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
 	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
 		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
 			return;
@@ -255,13 +256,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |= IO_URING_F_CQE32;
 	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!file->f_op->uring_cmd_iopoll)
-			return -EOPNOTSUPP;
+	if (ctx->flags & IORING_SETUP_IOPOLL && file->f_op->uring_cmd_iopoll) {
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once */
 			req->flags &= ~REQ_F_IOPOLL_STATE;
-- 
2.45.2


