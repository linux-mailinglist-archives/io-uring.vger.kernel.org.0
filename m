Return-Path: <io-uring+bounces-12187-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFD/G8+YjmnXDAEAu9opvQ
	(envelope-from <io-uring+bounces-12187-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 04:21:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DECF132A31
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 04:21:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF18B3076521
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 03:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFB923E330;
	Fri, 13 Feb 2026 03:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EYXE7yL0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE651A76DE
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 03:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770952891; cv=none; b=kRN6/IoJaHCyTYcfvyeUvfzrx0UgCBloIJQwAAX9Mro+HRGhwEFbzcsQtDek1U004iDj1RiYJm0C88tlHSO1GHEQp7JKEiomW3DdQPVkm92UCPsBffAm7qmhmXiy3Tchddwq12Hh288JMqgJrQkEhcAXGKOZbsdKMMUeV0XO1s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770952891; c=relaxed/simple;
	bh=SK7lNVVt3R3qPwh5gNARbgazIAbuys8j5HASsZvezDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVQ2cIui0hianOjVHqKyTzwVbogbqPT+N2rMbrm2ajqQi4BLmo2vsZdVox9qvHArhVR3f1KXlpDRUT9HMgstqEGBeVTPJeZ1Ha3lpC5TfvJRtPc3q837dXLffNmKWT3/GPbGmW7MCJN9KUGNHGVwVV0VWYl8tx4+FJsjvbipWO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EYXE7yL0; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-649ddc91c05so77160d50.0
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 19:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1770952888; x=1771557688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrpUavd9Jn1m5PTul6V14FFmKgASSL32mDcwIWu9GWA=;
        b=EYXE7yL0kLb2SsEfTXJ9oUwwVGzbTtyqyIrAFq6W4osN+hhUH55vm0r40JMXBj+g+4
         qA/eQ8GdPuYr1XncRRtEaBNonMsZAYlWIlJuU449ghqbgckfnshqFOoUkSnzJ0v8FcPc
         a4QTlbVXrPwWPHso2y+HxY8zNJTBAG0gPpViZ8UWMYa4aX3VE4kx2ahDMJ9/O8naiejg
         qN6sVAi5LXnvwGzUMNBS9OIO5DAEbDoqEGYotSDiDIphY6rhiZOQZPfLnaH8uSwc8lCe
         fUKhBaLx0yf1rCthfeKigiDZEVy1ZDRtO76AV5f1sw26ayLu0zHEPeSPRcUW9tNCjFuk
         mecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770952888; x=1771557688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XrpUavd9Jn1m5PTul6V14FFmKgASSL32mDcwIWu9GWA=;
        b=lqQaR9aKA+3r6qlRP6h0zyVm7Gzx8EfK03M/d36WgSOGx+Ki+2K4TLEw6wdozwkuLK
         1Q97YnH0bjT/28RSPESrMH8wg6U8cEYRwJIs9nWz+lZnM9saPeVa7R6M42qEHUyFIlUl
         TyGCe+Xaq/GJarhgYAlvsQ4xGhhcK9kKvf81b/tHj/tDGn/kM7EMJAtbwf13lObz+S32
         YckFO9XhodgI8VtE+QaX383s1tTirJT6kL14IbLAHG5kl12UROHlmIfUpD6pOH49GRQ+
         3fqH69fRu+XulxJWBL3o+PuN2h8Y4Jaf5xmeLYTeQkxnfcg+R97SfFNMcy6L8b/TZTnb
         +ztw==
X-Gm-Message-State: AOJu0YxpBJMm6Cf19hmSQH2AbfqpCrWZrhpVihf8aEeEtDx9ObZgdnVF
	RZvkHSG18zREIm6vThZT7DctFR03HaK4nLwetXhgdaQ7LAe8JMWgz7sqddwoeNSWcpzbofHbrP3
	C3UApohhf+/LZ7h/HKLoOUCyKVyO//VvPkFwm
X-Gm-Gg: AZuq6aJQI8emwa6LaNdLGIE640UTAMXOUMK5LZVIYmU3/kIhT7zfATESG4B48NZ9dIY
	rTNp26oGVTRFkNDP2EG7y6YkSq0Lf0JwEvJh8OTj1IGvujV1HWbJmE/0Prj/Das9KZme4+2uTVn
	2p3OTHWqWa518B8Zn1IDPGBaMihjCYp+bxaLzWtehwRLNVGL4lvsZXahhTBkxWDowBN24FpjUzW
	ltx+JLWD3CP5icF57+IQ+BLTm/LVZotGY6oAJaDK1jGbFUdVvWY3S3llUyBRr00pgdZirFSJMKD
	D4hc39aqNPK5yjbUNBrQUV/tRPX9Xu22K0gvGVCXGYWif0vNIAKU5PFYU9HhraCrJ/GZnTIRktu
	8vpU1u+3W6AOGGeKkOd2xxvB3yCr5Guih6VhEZjijWFODyq5ZRUSA9Q==
X-Received: by 2002:a05:690c:c509:b0:796:228c:ed96 with SMTP id 00721157ae682-7979e6be482mr7685947b3.0.1770952888296;
        Thu, 12 Feb 2026 19:21:28 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-7966c2328fdsm6537797b3.14.2026.02.12.19.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 19:21:28 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id AF4A7340705;
	Thu, 12 Feb 2026 20:21:27 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id A9CBFE41DCC; Thu, 12 Feb 2026 20:21:27 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 1/3] io_uring: add IORING_OP_URING_CMD128 to opcode checks
Date: Thu, 12 Feb 2026 20:21:17 -0700
Message-ID: <20260213032119.1125331-2-csander@purestorage.com>
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
	TAGGED_FROM(0.00)[bounces-12187-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 0DECF132A31
X-Rspamd-Action: no action

io_should_commit(), io_uring_classic_poll(), and io_do_iopoll() compare
struct io_kiocb's opcode against IORING_OP_URING_CMD to implement
special treatment for uring_cmds. The recently added opcode
IORING_OP_URING_CMD128 is meant to be equivalent to IORING_OP_URING_CMD,
so treat it the same way in these functions.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.h | 6 ++++++
 io_uring/kbuf.c     | 2 +-
 io_uring/rw.c       | 4 ++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 503663d6fd6d..0fa844faf287 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -528,10 +528,16 @@ static inline bool io_file_can_poll(struct io_kiocb *req)
 		return true;
 	}
 	return false;
 }
 
+static inline bool io_is_uring_cmd(const struct io_kiocb *req)
+{
+	return req->opcode == IORING_OP_URING_CMD ||
+	       req->opcode == IORING_OP_URING_CMD128;
+}
+
 static inline ktime_t io_get_time(struct io_ring_ctx *ctx)
 {
 	if (ctx->clockid == CLOCK_MONOTONIC)
 		return ktime_get();
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 67d4fe576473..dae5b4ab3819 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -169,11 +169,11 @@ static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
 	*/
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return true;
 
 	/* uring_cmd commits kbuf upfront, no need to auto-commit */
-	if (!io_file_can_poll(req) && req->opcode != IORING_OP_URING_CMD)
+	if (!io_file_can_poll(req) && !io_is_uring_cmd(req))
 		return true;
 	return false;
 }
 
 static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index b3971171c342..1a5f262734e8 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1252,11 +1252,11 @@ void io_rw_fail(struct io_kiocb *req)
 static int io_uring_classic_poll(struct io_kiocb *req, struct io_comp_batch *iob,
 				unsigned int poll_flags)
 {
 	struct file *file = req->file;
 
-	if (req->opcode == IORING_OP_URING_CMD) {
+	if (io_is_uring_cmd(req)) {
 		struct io_uring_cmd *ioucmd;
 
 		ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 		return file->f_op->uring_cmd_iopoll(ioucmd, iob, poll_flags);
 	} else {
@@ -1378,11 +1378,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			continue;
 		list_del(&req->iopoll_node);
 		wq_list_add_tail(&req->comp_list, &ctx->submit_state.compl_reqs);
 		nr_events++;
 		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
-		if (req->opcode != IORING_OP_URING_CMD)
+		if (!io_is_uring_cmd(req))
 			io_req_rw_cleanup(req, 0);
 	}
 	if (nr_events)
 		__io_submit_flush_completions(ctx);
 	return nr_events;
-- 
2.45.2


