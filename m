Return-Path: <io-uring+bounces-12521-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIrMHfnIpWnEFgAAu9opvQ
	(envelope-from <io-uring+bounces-12521-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8DF1DDCDD
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5161F3007529
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 17:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8B442EEAA;
	Mon,  2 Mar 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="N/6xq2qk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752504279F8
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472564; cv=none; b=mg5Rr160Sjv77tvahgfDAXlh7h1iKzw60eYr/d3DL0Sz7Wc1Q30TcA9qhsr+vsR66tk/Y+38Vz3oxqOHZ6SQ10wi0+RMdC3NKY5uhHsyvbdrisy8LFZ2Mq5T4z7QRFu06yBjlS1ftMIQEjOwpUX0fbgW/FzcqyDgIGgHe94Jo28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472564; c=relaxed/simple;
	bh=mZRg9aJ/vT9KGxR37N9gh9XV0GFWpQmAWSI7PzYmIhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vc+itFpg+hUJRioJT5lPV9cqhbrhUL2jEa9vMB82l0JM0G2577+x50inp2z0z3w0PPcP3732PIKZUPqDDGHoAHJggraw/4kRTIUixMAZUFB+HB1OOKLh5yBg/SASXMYSVtyYHleHPksDdTNgAT9O1GwymTYtxTWjxo8M8iTwkMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=N/6xq2qk; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-824ba13c49eso242562b3a.3
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 09:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772472563; x=1773077363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVH9fXQsVA7juGOEz+1dE42o2vyEutyAkezbvq+KUlE=;
        b=N/6xq2qkrtExtQSZN0gFAwb2sYl8vKAs/zM+B6ok/seGbGtB2OCmNemofhZztUXpJt
         sIEAUjmYxscGST04cpu18EAdgsfj5Y2VKfle4ujB4GsvadmTpcBNyKD7BQz9cq1quAoX
         PmAhO99AnamEypVz3tGSVogl3g6RgDZHz3SdDOkixMBy++Ut/Ls0xXEdq9Ul9GWcV83/
         rAQ0+bhi1fIhQIc9CSDAuAPWMKPxFoDMvg6yce3BUM7lNKDJe3EmTr5dl0AlReIeScOv
         oU1vKpJTtRyG4jmD8lMXDLIfPExVl6sPb0lEe0tRkbNroMA0ixULNi86s8FkpUalHJfH
         v9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772472563; x=1773077363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qVH9fXQsVA7juGOEz+1dE42o2vyEutyAkezbvq+KUlE=;
        b=NZB2SnItcShPXR0km4AjC1Hc7uNY1a7RMPMHLwMPeNpJEZfe9hZqjboql5YAmcukhP
         udrryIOLjS7rLKmSp2Oh3AEzeILJV/wKhNaQFz/SyiEouau8Yfv4iSMDNmT8WZc8yZJA
         erGUCmG3/MOYRZcIWLSd3/SRyb6Cr9bijGyB7pHuZIxyO+CS4jcd80wAbbbl5jskc6/J
         ODXROYEbJn4DYJ9CuOZ+0e0/e65ippAWQT2NqJ2n+4qXkikbWPPWSKSXeokaaza0oX9m
         6d9AIro0wAx12GtmuLw54t3EvRo+l5LxnUtQhR17/FhzD4DPwtDMrw1HJnS00ctcxpVX
         3yog==
X-Gm-Message-State: AOJu0Yz1rOjtekbDc1L4qxYv49wPAULpvEthNtWcVeKZ9csbvOZLjWsB
	ew8CjDwiDNBgvfFDnnTuTRsWsN0nkawj9/qRUB2hc7XAAltb/ttwVRp9fxSt+YRBy0uJBOaZIL2
	DNUYFh+bukAFETpFlTiJ/+RHKkvbT0u2ibbrd
X-Gm-Gg: ATEYQzzNktr6nnNRpd8nVn77dHHf0zMhXaUcNJUMNVcm7WyIU/D+VTeqR1x8PusvNYl
	o8nM8detvcJUXAoz0lJt0VTaqbkhnINqBtlubRFLNOA0uWoIB+VPAzLPRyZKc9jLIL2fTebR0k/
	ByuvrEVbs2ELWNGM7hEKs2XgDsOrW7kKRkR6BN9cEHJPLtvyPH+snp1YbYBNbRX/25ksQyiV5ks
	aQ/DBpnKPj36dibPkSXHyxMLQ7zv5Ft1QDEbyLkChPocj9+XPbOel3sflgX3up6cz5Xe/c0nnzw
	RJd4KFGPS9dPB36BqrURbMFs7rRNma67/pCWBw9flMMXfTEkrvr7YIhO+8+SlzhGmO4kpjvroOU
	MGdPYjlUMehTe4n/FnkosbLQGRSgt5sQG58+M0a7pfXEym02VMweipg==
X-Received: by 2002:a17:902:ec84:b0:2ad:c1fa:ceee with SMTP id d9443c01a7336-2ae2e4fe432mr94384075ad.7.1772472562651;
        Mon, 02 Mar 2026 09:29:22 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2adfb16ae40sm16178815ad.13.2026.03.02.09.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:29:22 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id C2CED3404C4;
	Mon,  2 Mar 2026 10:29:21 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id BED93E41FBD; Mon,  2 Mar 2026 10:29:21 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v5 2/5] io_uring: remove iopoll_queue from struct io_issue_def
Date: Mon,  2 Mar 2026 10:29:11 -0700
Message-ID: <20260302172914.2488599-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260302172914.2488599-1-csander@purestorage.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF8DF1DDCDD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12521-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:dkim,purestorage.com:email,purestorage.com:mid,samsung.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

The opcode iopoll_queue flag is now redundant with REQ_F_IOPOLL. Only
io_{read,write}{,_fixed}() and io_uring_cmd() set the REQ_F_IOPOLL flag,
and the opcodes with these ->issue() implementations are precisely the
ones that set iopoll_queue. So don't bother checking the iopoll_queue
flag in io_issue_sqe(). Remove the unused flag from struct io_issue_def.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/io_uring.c |  3 +--
 io_uring/opdef.c    | 10 ----------
 io_uring/opdef.h    |  2 --
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e7f392e962bd..46f39831d27c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1415,12 +1415,11 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (ret == IOU_ISSUE_SKIP_COMPLETE) {
 		ret = 0;
 
-		/* If the op doesn't have a file, we're not polling for it */
-		if ((req->flags & REQ_F_IOPOLL) && def->iopoll_queue)
+		if (req->flags & REQ_F_IOPOLL)
 			io_iopoll_req_issued(req, issue_flags);
 	}
 	return ret;
 }
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 645980fa4651..c3ef52b70811 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -65,11 +65,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.vectored		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_readv,
 		.issue			= io_read,
 	},
@@ -80,11 +79,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.vectored		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_writev,
 		.issue			= io_write,
 	},
@@ -100,11 +98,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollin			= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read_fixed,
 		.issue			= io_read_fixed,
 	},
 	[IORING_OP_WRITE_FIXED] = {
@@ -114,11 +111,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write_fixed,
 		.issue			= io_write_fixed,
 	},
 	[IORING_OP_POLL_ADD] = {
@@ -248,11 +244,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read,
 		.issue			= io_read,
 	},
 	[IORING_OP_WRITE] = {
@@ -262,11 +257,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write,
 		.issue			= io_write,
 	},
 	[IORING_OP_FADVISE] = {
@@ -421,11 +415,10 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_URING_CMD] = {
 		.buffer_select		= 1,
 		.needs_file		= 1,
 		.plug			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_cmd),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
 	[IORING_OP_SEND_ZC] = {
@@ -554,11 +547,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollin			= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.vectored		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_readv_fixed,
 		.issue			= io_read,
 	},
@@ -569,11 +561,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.vectored		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_writev_fixed,
 		.issue			= io_write,
 	},
@@ -591,11 +582,10 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_URING_CMD128] = {
 		.buffer_select		= 1,
 		.needs_file		= 1,
 		.plug			= 1,
 		.iopoll			= 1,
-		.iopoll_queue		= 1,
 		.is_128			= 1,
 		.async_size		= sizeof(struct io_async_cmd),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index faf3955dce8b..667f981e63b0 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -23,12 +23,10 @@ struct io_issue_def {
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
 	unsigned		poll_exclusive : 1;
 	/* skip auditing */
 	unsigned		audit_skip : 1;
-	/* have to be put into the iopoll list */
-	unsigned		iopoll_queue : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
 	unsigned		vectored : 1;
 	/* set to 1 if this opcode uses 128b sqes in a mixed sq */
 	unsigned		is_128 : 1;
 
-- 
2.45.2


