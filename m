Return-Path: <io-uring+bounces-12342-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EM3IbJIl2m2wQIAu9opvQ
	(envelope-from <io-uring+bounces-12342-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:30:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F17E0161340
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:30:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DB262300EC94
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 17:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A1034F48F;
	Thu, 19 Feb 2026 17:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JXFjHLR0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE50A340285
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771522222; cv=none; b=d1p7UvkWGMHv+oPAzK0Y7xwPfrGNYqvZMVW5ZyaWYy4V2hEKv8fUNZNwJx/QLuU451XMN3TbSp+eNrMfwdot18UK2m3Gsf06CZMyp4s+HBWJV2K7l/p+0XXLzBznxGeB6mcatl2ngmIs8YPX5TAPHs2md0eqTmalkP0iSF69mJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771522222; c=relaxed/simple;
	bh=EHWMm11e5TVx8NT/hLERqyUnuuxjz5z5bCiInE9uL2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYxJg5nsGWKJEBis7xbXqT8L7QW86liKJA4KvSU+LAeY3PlONtGGYzqh7dUpV/3icfW1T5vy8NxqDt1EcOFjwFHWpphfOpUzvXZKeHlHknzjEmwDixMcF4jpn5tMny2Ai4Cdhhvk5np398YJPpQCd9IdxlS3n8i13dEqz9wMiEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JXFjHLR0; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7d189de4577so185900a34.2
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 09:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771522219; x=1772127019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUz10elldwZxLQFWq4Cian3B5sXmfA0qWI2X4aUf25A=;
        b=JXFjHLR063h4L5tjwNs8uYxHU286SZspY5lF/MD98wCxJvBBdHA1l6rhWyg3evuJkO
         HdijMqrariyHEvmzN3eiaSZskL5TD8B0BvNGznB94kOOK5+C7o8xZCbUYyZX1iwbDedj
         QJ+WQTcsb2RJR1i7HMb62LXPuPAq4z5PT5UwgjsnxofY9DbqyOptRg74pymPRmkj9JnG
         CkykRGN478oMdUU8j/Q5v07ACZ5N1QgMIEz1d9+FotbgOGIP0csShcwn2jyHjEldKQ5F
         coL7pUSgI9yoScL8II/CyZixlgLhY54pwOMrVGxTKCxK93yYy33RPlVRw5mOnmrU9QDm
         7rRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771522219; x=1772127019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CUz10elldwZxLQFWq4Cian3B5sXmfA0qWI2X4aUf25A=;
        b=FkWPw0HpWR/3EwP8Eslq0tAmBHzs22sZ3QKCb1uNze0c/YOVqb0EVMYlPqq/ifY646
         1Yrd5y644y8tkvYOb/OfcLzrjIHzrqmrWf7dg9J9KCSpyzxqpO+dm8Vufgl5YusKdFeR
         gb7Sg9qWENRLLiY6gtudzifd6U5RMQlrTYVNlMnsvlddbeVgd9G0LsUs2wnXBHQZwYjs
         hWc0lica7o30wntFeijK8QT4EtFscYStPr/eSy3rndheA8zNR9Rp1E3gdjZ1a9XDJl3x
         u6HrHB59+UOzXJ/s2x+o0czhFOuGnY5vf1HQ+wqO5VDEEpLRB8NKYfKc11rMa54U6qdT
         1egQ==
X-Gm-Message-State: AOJu0YzZBE1yI4wSRAhRVcWoTnezfduAgdLUTZsdJvyDGkNSbLDQAkc+
	Qtvj9gIyRPtPrpGE9Uxc2HX5vgWL7LA7jw1XRRFUrK4FILAGkgeSkTSVmHg1nGyv/6PVW6un2sh
	biltIM2RUBBi3DcJfWWgYadmDz4ZQXdpBOKoQiBlFew2sGmU9MybD
X-Gm-Gg: AZuq6aLjwTGJ42g+HRNhkfTFVG/hwSL4y23zlFDO/62kB8S8VRy5WUFhtn/MHOsdB+D
	2XjSi5SJOE2J5G5W+29eSubbze0ut+uUeEmxZ/X+YNcRer0KG1bqACf4ngwbzRPd19ck81F61s4
	zGjy7n7NktPuytDIrFi0AtqYWw6t8zg0QzynlAkfdBll+X6Byg+V7FMluQNV3a18d7QRCKbovsO
	svDsvhTjPfR12aeLWLFjrL+7YM9Mj8QVtoyoBl5LUIFYZEJrKRutcMzggyCmqNutNfB5tIHrivH
	g/P6JjZ1MWFglEt1koac7uXe/s6g+TXb3DBWrB/TTwqQl40bUGDj1NRbvRYnPPQH6OiFeqQkL8t
	ozT0oQMOhKNSh9G0hLK5zUK0wTksE8KIZQDya3C0=
X-Received: by 2002:a17:90b:2cc5:b0:356:1f2b:7e9b with SMTP id 98e67ed59e1d1-356a6e38413mr14529793a91.0.1771521785723;
        Thu, 19 Feb 2026 09:23:05 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3589d81739csm95093a91.4.2026.02.19.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 09:23:05 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id EA2563420F0;
	Thu, 19 Feb 2026 10:23:04 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E3B5AE41AE3; Thu, 19 Feb 2026 10:23:04 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anuj gupta <anuj1072538@gmail.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 2/4] io_uring: remove iopoll_queue from struct io_issue_def
Date: Thu, 19 Feb 2026 10:22:25 -0700
Message-ID: <20260219172228.429479-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260219172228.429479-1-csander@purestorage.com>
References: <20260219172228.429479-1-csander@purestorage.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12342-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,gmail.com,samsung.com,purestorage.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,purestorage.com:mid,purestorage.com:dkim,purestorage.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: F17E0161340
X-Rspamd-Action: no action

The opcode iopoll_queue flag is now redundant with REQ_F_IOPOLL. Only
io_{read,write}{,_fixed}() and io_uring_cmd() set the REQ_F_IOPOLL flag,
and the opcodes with these ->issue() implementations are precisely the
ones that set iopoll_queue. So don't bother checking the iopoll_queue
flag in io_issue_sqe(). Remove the unused flag from struct io_issue_def.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c |  3 +--
 io_uring/opdef.c    | 10 ----------
 io_uring/opdef.h    |  2 --
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 43059f6e10e0..2be46e11e1a7 100644
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
index 91a23baf415e..4b3fb19b0cde 100644
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


