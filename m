Return-Path: <io-uring+bounces-13878-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id LmoCLZyyRmpZbwsAu9opvQ
	(envelope-from <io-uring+bounces-13878-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 20:49:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 30CE86FC4C0
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 20:49:00 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b="KQwdarM/";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13878-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13878-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AE7A7301CC73
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2026 18:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C9F35F8D2;
	Thu,  2 Jul 2026 18:48:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2C33101B6
	for <io-uring@vger.kernel.org>; Thu,  2 Jul 2026 18:48:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783018134; cv=none; b=bBOLS7jgkAnHDiTKUnnGJaPwHTIsu9ynTevRBpjvwoC/j+VPMfmOo/nElv4dAFRB/fk+G4AH+qq35qlUggob/asHVEXOABJiSlfLeZoq3m7YEqZzZ4lVdOY80Ue+w5uUkl6LFFkEIR+J6eYPKHBq64TbIjxsL2Km9LpIUsleL5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783018134; c=relaxed/simple;
	bh=V+7Gt3CZDhsW4TSp1W9bJ90FRFXFbId7Kh06BbBmB8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FZZ4pezSkjFTQ8OLF+ESLylH9uSkHYlUQWHd575h0a6Khrj7wGmiitwhGq2LBDZlcrAfe0a2qlnWzgjreCdxVp4Zh5Ijk2gPENE5s0A4Jw9PH+fG2Lj4dhItu7UpIwDWm9WjNf0RaB5z4yf59iaufxlMLVGM/3OyH8o+p6kdLsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KQwdarM/; arc=none smtp.client-ip=209.85.221.227
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-5bdbe85ee42so112200e0c.1
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2026 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1783018131; x=1783622931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0VvMtvthBp4V58lofOCm8gLwEVfcZch3cWP8ElqDffk=;
        b=KQwdarM/FFC6EQmSJ4Jf0WkKvNdSYfJ1TKnwqJPYaJzhAwPAhf7Xozq4Ovtr0Uy/Qv
         82aA/Y9NcAfLWACHGl1dDzwMLD5SAYn3vDcD4LBEqX3s6gRAtlZa2eK3j0lllH5kj2Hm
         89pVCWdvUwhdJ6hLzaNDrefogs71bm4L1YUHDamhTVfSyL3WBr6EZK8ucIgqdgoMnzKz
         0ESwYw4Xx2gggOOeu0A/gvjR1Gsq+tgckAf53h70ZqWhQBy/tEYeiB1pil1G9zdNvJ9p
         UclOP+JLvmAo1QCilYdZeATilAO3xMeoT782DgknmX0LqwZaMMC6LNHqKdEZX4l8JlIS
         en0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783018131; x=1783622931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0VvMtvthBp4V58lofOCm8gLwEVfcZch3cWP8ElqDffk=;
        b=Rd8l/jlfAdk3YK6Bm73gDHH8XQImI17VH07wh+1mhHTxvggx1HWMa2CZhTBJ/k87z2
         ArRiTF167UdaO9fTmdnRvoChO2FFgkc5oK0H5MNM1n6B38bQ3iDxlrIwq7MMSNXg702P
         /SMvmDxdSabPU2dAnk7PShvmJ0rKnn1z6ama6ktEHwHNH64OAzqUkZ3ZDnEBMCr+N14d
         LqZhvXt8VdkfqkCryzF3zPfggNXPA4c5eoln4NzCXQc5so9ZFtk0JWcOi3FI9dXIYze5
         XHnR74f96Ln4hWfZqS/pL7jRpW8tkKvlJzgDR/FaXip/0Y5KB97liMeofEH0YhFwnLjG
         83wA==
X-Forwarded-Encrypted: i=1; AHgh+RqX2pImuiiUuDVrx8AB/+qmFfev8X+wILi9W8MQO0W06rqhJWsu2dbXJChDYO/C2K5iuDnlNsiX5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6VLhGdLLJDOTI3JoTFsjdizXU2OJn7ANBfySCraI3w84lIUcL
	3l+Mth1eYk5hIV3mC9QV8hH+iO/dju3S5Mzdbu56enyWm50unSXUX65JdWuD4v+/0CQueCmjm0c
	mC6kRraWs6M57STsl2fJdhR8b5+4cc0tKQruT
X-Gm-Gg: AfdE7cmAZf90MgJMEvtGfrHhcFRbmZ4j/l4wsE/hyaEl4OgEbm8za7dwVlbT+1dhfIh
	US0bCGZKzYiMsEYbcbja9kPpDlB66LpOeHiL/1ZZtEJ7qwo7/VDjyU9mkBkwrP9fBGQvQxVPdf1
	+PU3APHZ/4HQrNP1sSSnTaf7gs/YAcpoBKIyMSmhsqqI1PTT69TTG/viVmnmvnOde+46t3VzuiE
	giCx8V5fglFEo/VFX6ygn+0J1MAiEU70YZW+yvFrX1s4Gqo7V3BnLk2hwnTSSOg9OauSjZptDfm
	pYEQ9pd9MWQFNJfCXDN/ljE3nBSAXiuqdRox9ArZtigNBnC8gRbzVyNZ2ddKhIRLFfxmhS2LyGs
	Lb4kB2bW6733u8TbQzAL1LGOVu7ml2OQRwAWXOtbe16s=
X-Received: by 2002:a05:6102:54a1:b0:602:b87a:3524 with SMTP id ada2fe7eead31-73dab826936mr1084266137.8.1783018131362;
        Thu, 02 Jul 2026 11:48:51 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-73e1c2b71c0sm287081137.19.2026.07.02.11.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 11:48:51 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (bond0.slc5-n17m28-k8s.dev.purestorage.com [IPv6:2620:125:9025:20::a31:41f])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id B1E0E40345;
	Thu,  2 Jul 2026 12:48:50 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 9BD0CE40832; Thu,  2 Jul 2026 12:48:50 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/uring_cmd: skip io_uring_cmd_issue_blocking() task work
Date: Thu,  2 Jul 2026 12:48:45 -0600
Message-ID: <20260702184847.1709378-1-csander@purestorage.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13878-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[purestorage.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 30CE86FC4C0

io_uring_cmd_issue_blocking() is only called from blk_cmd_complete(),
which is already a task work callback. However, it queues another task
work item, to call io_queue_iowq(). Just call io_queue_iowq() directly
to skip the CPU cost and latency of the redundant task work proxying.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c  | 13 +------------
 io_uring/io_uring.h  |  2 +-
 io_uring/uring_cmd.c |  2 +-
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1279e27c2c6d..4c83a94b4bdc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -405,11 +405,11 @@ static void io_prep_async_link(struct io_kiocb *req)
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
 	}
 }
 
-static void io_queue_iowq(struct io_kiocb *req)
+void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx = req->tctx;
 
 	BUG_ON(!tctx);
 
@@ -433,21 +433,10 @@ static void io_queue_iowq(struct io_kiocb *req)
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
 }
 
-static void io_req_queue_iowq_tw(struct io_tw_req tw_req, io_tw_token_t tw)
-{
-	io_queue_iowq(tw_req.req);
-}
-
-void io_req_queue_iowq(struct io_kiocb *req)
-{
-	req->io_task_work.func = io_req_queue_iowq_tw;
-	io_req_task_work_add(req);
-}
-
 unsigned io_linked_nr(struct io_kiocb *req)
 {
 	struct io_kiocb *tmp;
 	unsigned nr = 0;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cb736b815422..dfe26a9c21bf 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -193,11 +193,11 @@ void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_tw_req tw_req, io_tw_token_t tw);
 __cold void io_uring_drop_tctx_refs(struct task_struct *task);
 
 int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
 				     int start, int end);
-void io_req_queue_iowq(struct io_kiocb *req);
+void io_queue_iowq(struct io_kiocb *req);
 
 int io_poll_issue(struct io_kiocb *req, io_tw_token_t tw);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 7b25dcd9d05f..5525267d2e03 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -324,11 +324,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
 
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
-	io_req_queue_iowq(req);
+	io_queue_iowq(req);
 }
 
 int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
 			  unsigned int issue_flags, __poll_t mask)
 {
-- 
2.54.0


