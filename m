Return-Path: <io-uring+bounces-12524-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICXfFwDJpWnEFgAAu9opvQ
	(envelope-from <io-uring+bounces-12524-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CED1DDCF2
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 33392301252D
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 17:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913A842F553;
	Mon,  2 Mar 2026 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="dPY+CUXn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B4A42982C
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472565; cv=none; b=emKqL/bRIaiL89GZUeQVcW1M9JvgMwZO4fP/XddUTX1L4VbKwwuT4MHaCcNjiYRdbF1nGVgYceJ1JFOMBIV17IFuSEuLckR3NJtR9EsA+9eHjHg8JjgBR6rYH5E+YRHkwc4eikOnd9blgS+Twu45zMcNfIfM0ocr4cotVMRD9SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472565; c=relaxed/simple;
	bh=NBvNotESp7kUasR2rqxc9z9U7+RvFpA7PAQQGkHDOZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1QVVrtQ4hpCkTUXD7pxdJ2/JDi1H2De6ibTDQfBv5ACGB7E9EEamUXHZCrCwbw/7xbDtI1OUcBjSAywDPKqidU2uYFfnS8gdBlpXeuA3gcUhmM07FJayymNBuk0RLqZyvhrw4eIFUKbG3Rzl5CHHnQzvyPWRqX/dMKB0k9B4WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=dPY+CUXn; arc=none smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-c629a31d1d0so325970a12.1
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 09:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772472563; x=1773077363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YA4oP39D1EwOno4AkPegcttVQHiaILWd3dC9XNEopg8=;
        b=dPY+CUXnAnAP93i0m2sogrKJdOcv3PfhHRonzPORJvAXbcJSuuK28VFLW3HA0+Va0v
         J9cs/lNv9vtrZfHbQNNAvmpcgYHE5+S5IJZiQFOGSsPwejH4TI6Gs8OUdQpF6swm5J2N
         FQK5ASiNUXjew4TwMHoeHEHHUSJXsb9pOckSo+0nPzA6d0ukoOhS8Z5jnlwqkp/vqKbB
         maBr7q85RYZXyBnUkMn7/j97WvzntNcNBvAFr51rhFGZLCyJT9MQOhVX8wiLuAYUdDkF
         CTfm/PJO9/TGX2s29+JjwYef1CYcWWfps5vsVe0owNBj2/7973i0BubNNWl/VdHr5FQn
         0Byw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772472563; x=1773077363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YA4oP39D1EwOno4AkPegcttVQHiaILWd3dC9XNEopg8=;
        b=FoI6qEDZs2jQYE2JZcoJECFgxIOb80GghUsuOS19u0IfIvdHZidHjwfb3U+YG+yxEk
         EH68iRA7DCDuZY5LR/3kg3SXCMW6UkWboiou2KuQSH0u9wlVHqqw6iKTCfeGjRDjFXOH
         GNLt257PsqjGKuRrzpf4xV8t/ZZg8wX+/s8tBjDo/BdHz4rDhKhZK6qkLKeJQCWmwmSj
         aeIfZf98uL6yEok43kugfxY6TgLs4TXUDm48fCcpvnMf8WXq9TqbR7X64tEnAgAeFTYb
         00lBSrszvN7kVM8pSJcSOU3IwiD8lcnkCNtFhklSztrmJ+BmZBOSFJPmNPIApuOy+dyy
         M2yg==
X-Gm-Message-State: AOJu0Yx8jFhEfPgHrSIMEyW76P7rol0zMoZXe7NjmZynE+MPIzuO+1u4
	oW7SxWTiUOiKfGJaY2tX4UTcDQ394abKOzcbbtHiGi/RzxcokAmZHG/JpAafw2boM4uc4u6e2Up
	Ypg9/VSn4ZhWe8VUqGwTG6PJNqSiDLRYZ4ETQc9QS5QLhnx77tX4F
X-Gm-Gg: ATEYQzxPvviyRYZLfastnsKq1dkvZsBGPWFU6FYsV0bK8zs8qY5rkr8wtuhKW98SXvv
	e2CQjuQfAPP1D3O/TrsKeqCXz6R1o368CLIXlzzqxQ4EryKCB4TUQA94rFYcZ8DKUJJRiI/q1r9
	GfnZxOneEmj0m458rdKBL2f0Tms5Qy5p73hBTGdhsHPQbbbaIQASTcVp4Esb1eBnb1waUiaH9k3
	c9xurIwcPSLqvf8RT2o1koTf9rhM7FTPd3/XI/WBCNyeVqcOHdFyJHtALihOYEJhBiWQrUloTf6
	ULUsoTqwfSdJKD7INA2aPfvTqlf0t25yzoN/nqZeJqi8fo7+0f2373YYnq8S+5Yq01zk8D1slYg
	0VtFtLmv4s3KfJEdKCn4C73D3q0k7YEoSpaHfoho=
X-Received: by 2002:a17:90b:3949:b0:359:95ec:5a2f with SMTP id 98e67ed59e1d1-35995ec5c72mr1230896a91.6.1772472563254;
        Mon, 02 Mar 2026 09:29:23 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-359939787dasm287026a91.1.2026.03.02.09.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:29:23 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 2FE0A340199;
	Mon,  2 Mar 2026 10:29:22 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 2C3B1E41FBD; Mon,  2 Mar 2026 10:29:22 -0700 (MST)
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
Subject: [PATCH v5 4/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Mon,  2 Mar 2026 10:29:13 -0700
Message-ID: <20260302172914.2488599-5-csander@purestorage.com>
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
X-Rspamd-Queue-Id: 48CED1DDCF2
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
	TAGGED_FROM(0.00)[bounces-12524-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:dkim,purestorage.com:email,purestorage.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,samsung.com:email];
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

Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
requests issued to it to support iopoll. This prevents, for example,
using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
zero-copy buffer registrations are performed using a uring_cmd. There's
no technical reason why these non-iopoll uring_cmds can't be supported.
They will either complete synchronously or via an external mechanism
that calls io_uring_cmd_done(), io_uring_cmd_post_mshot_cqe32(), or
io_uring_mshot_cmd_post_cqe(), so they don't need to be polled.

Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
even if their files don't implement ->uring_cmd_iopoll(). For these
uring_cmd requests, skip initializing struct io_kiocb's iopoll fields,
don't set REQ_F_IOPOLL, and don't set IO_URING_F_IOPOLL in issue_flags.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/uring_cmd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b651c63f6e20..7b25dcd9d05f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -255,13 +255,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |= IO_URING_F_CQE32;
 	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!file->f_op->uring_cmd_iopoll)
-			return -EOPNOTSUPP;
+	if (ctx->flags & IORING_SETUP_IOPOLL && file->f_op->uring_cmd_iopoll) {
 		req->flags |= REQ_F_IOPOLL;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once */
-- 
2.45.2


