Return-Path: <io-uring+bounces-12477-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJwyKiUcomnqzQQAu9opvQ
	(envelope-from <io-uring+bounces-12477-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 145D51BEB78
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88016309E2AF
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4501547AF73;
	Fri, 27 Feb 2026 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="OPb3jkTm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC1A36A017
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231710; cv=none; b=m8fygKTf10DsJJtc1d/VVYCZ8w+czg00MDuZC3gDRHZsrMPdBSaZD0XyGK7RaE+KbsXGxE4uPGFCQq+qAY/htjPF+OzF3CFSa4N9CDv/FcgO/8gijkq5cHe8zbBtbYTHQMQXU2JpjszjK54ObIJTolec8e2qhCo5hzd8OmacGcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231710; c=relaxed/simple;
	bh=mZRg9aJ/vT9KGxR37N9gh9XV0GFWpQmAWSI7PzYmIhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9/8fsQi5Ia4veCrqhpMxFfmq87MNZwb3dRiFM5c2qxfoQppFkkhaquwe/z+gGRm0rRsyWOu1+AvojGwRErIp/tietjltpN4/OE1v76tumOo69lAbnhk1u16CEPvluzEUs8fXeMQi+XhG5eYxJPDRsnNyss+HGVXJnGIf+eqtNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=OPb3jkTm; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2ae3a007bd1so163075ad.2
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772231708; x=1772836508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVH9fXQsVA7juGOEz+1dE42o2vyEutyAkezbvq+KUlE=;
        b=OPb3jkTmEXXLtcPxCUrNGX64Mbsybraq0N6cFAJ18tF37G2/MXJV/9V12QETppXROe
         rHKH7JrhEeM7tVBMqVSdkfLIm7xKEkVd2V+eTIlPPO8SNGr0YXvpGoqljx9vkkLhOSn6
         b+Z1/GjTYhrwRr+k+SK1bn05M7R2O+e93YSScgudgXQ/U/F56ScmqE2WfJZS1WCZX+uH
         TTHH+QpQLnDsz5+FZSujlKXC31LbbwxHxxrf+j7wFnafcESYUG2yHpa+eFa5DP3BCNCj
         NWN5I+Y/f8lFPojDZuIvm/1PsW23wg4WCvK7PdCl+8e3xDPikbjn17WggLcmuodAK1l0
         2tAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231708; x=1772836508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qVH9fXQsVA7juGOEz+1dE42o2vyEutyAkezbvq+KUlE=;
        b=tJvgOIv0hlV7WsVxvBU8rylEZ/LIbhDXFjhP/3dbACQQbQn+8WPP2cNyzuHjO1jBl3
         ZLJLuRuFj283n5vXEww35EQ8DtMfJPSVO2Dibi3jdnuWWtEIbbVX/CP0ErcryHPXdiYX
         ZZyCnrw+crw4IWnODXty35yw1Lg5H/SF8FrXCcc25OHRhHM/LNxOADTcxfGRbfSJixFS
         DgKK17bGzFwkq80+MhJD5KgFVYrC5IhHVV3f0n+am6Zlqs5Z9HANFxElg+piCsD5DtXQ
         QDiAdI4+V3ArA5pbl+g/LQl2bQ2pXJJOPi0EWbw5MTrbxBt7hE52Od8NP/Bo0ADQMRgJ
         mQBA==
X-Gm-Message-State: AOJu0YzGuCDBzM6lwwqDO0HNaGdwdr9kapKbW+FUZa7449eoA1PVZBkc
	s8hovTeWlL8Le4jU+YmgGdIqcdGD/jH9Yn4VdXn5QlD7rtRTBFRmkrBRifWfk040AQ0R0e1yI88
	nVhVgsl7D3kTd5t7cXoyJcAlFiLLOwVqTV9vR
X-Gm-Gg: ATEYQzz1a1JeUrC5M9VeaACv3KGOfjvAOTW7ULA8gXTMxVspaCD5lXRqmg+Tz5OfRtf
	THvV1ziJ9BcFtzfRkgmH7D9di7H81tPdSkU7EOYHNqsCxx9tSTdkt3vJEwMLmA2mo/DTgK/c/li
	ecPb/Nap80OYIqDxBOwxsW0Ss+l5Bqyj11j7RWCCk35JuoZCiqhTp94aWZ536WTKywtVjv7c8kW
	6LclwxJPiAZJekjYYUU/hWjhv7eJfut8CquNQRaKuNm+av3ifZo5UlS0eWYsRKsAvZ7lT3dnwyK
	ScjUKwz4pjXW0PeAOZrdzQGFsEmCzzUxMQ2L1E9V7VJthXzG9YleYpxi8LNrqdw6cNBQZM7pasx
	bHVX15MYpnziWv9LRV7iAaQS6bxpSg/NvjNu0DqB0YnIpK4OOtRLOCQ==
X-Received: by 2002:a17:902:e847:b0:2a7:cbe3:a6e3 with SMTP id d9443c01a7336-2ae2e3e0d9bmr31622965ad.2.1772231708194;
        Fri, 27 Feb 2026 14:35:08 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2adfb5eec86sm7901965ad.41.2026.02.27.14.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 14:35:08 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id E9C1534179D;
	Fri, 27 Feb 2026 15:35:06 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E5700E420D8; Fri, 27 Feb 2026 15:35:06 -0700 (MST)
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
Subject: [PATCH v4 2/5] io_uring: remove iopoll_queue from struct io_issue_def
Date: Fri, 27 Feb 2026 15:35:00 -0700
Message-ID: <20260227223504.1162421-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260227223504.1162421-1-csander@purestorage.com>
References: <20260227223504.1162421-1-csander@purestorage.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12477-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 145D51BEB78
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


