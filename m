Return-Path: <io-uring+bounces-2264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F30C990E184
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 04:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EBF0B20ED5
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 02:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B214110A0A;
	Wed, 19 Jun 2024 02:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZE5ogQEv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uqKA9iV2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZE5ogQEv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uqKA9iV2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B7ECA40
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 02:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718762798; cv=none; b=IigEQ/W6PA6JlQU+H/TiY/8JEzmy/DSR8/AeA9mC8m/xBCWfl3qAS3pK5r+M5rvlFm4FYHsbOVhR5iaeeAjSKCBKJobiyopM5nkVtHeY+m/f3bYQsohZlXDBYVYM4O64duZKduQbr2AxPY7a+dIf2u6VrXxD5usBEKTpqHFLR7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718762798; c=relaxed/simple;
	bh=aQxfgo7l61+0/Nb248t7mAlh51V/LztIBsh+9nxLYYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWCBnaYjGDBgL2dFAG7+VlpFbiSkOz/oFtPRtfmpbp6aeY0McB56kkf9FZEqh+yRpWvVq58YQnhD053QpBSGYd9HnjjsFKyWeeKKTogiR6EzHZvljhN2gCruxwODUo+DiPzzgAWpQucT5dj/nMiVth7Na4SDrluvbPYFnFRCWfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZE5ogQEv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uqKA9iV2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZE5ogQEv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uqKA9iV2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD4042198D;
	Wed, 19 Jun 2024 02:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718762794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w+duwK6gh2vWHbc5cyD6xb9g9g9wIY5+tyLnsCB2khA=;
	b=ZE5ogQEv+8A0ufZXJjpLCckFBIVz3CnAwu+t3NgL1f5lm6P0c3MyG1hJWmX99M/rQ5hiUY
	ZvZ6dUnvz8WaA6pbo9qRkBt65Hx0gTiopTZxNL7tEALvywtXS+ND9OvtRaBCN+cwgIDi6f
	YjPnHgzx4/hnGUInU9qaJgo4wE92E7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718762794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w+duwK6gh2vWHbc5cyD6xb9g9g9wIY5+tyLnsCB2khA=;
	b=uqKA9iV2toN9eEV/TGg1AK9sKoPbM8zj+6+wxSXt23GiomGp6AKa+SeOUxUzx2FDzGwLs+
	PBTlSJPgt4GVE5CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718762794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w+duwK6gh2vWHbc5cyD6xb9g9g9wIY5+tyLnsCB2khA=;
	b=ZE5ogQEv+8A0ufZXJjpLCckFBIVz3CnAwu+t3NgL1f5lm6P0c3MyG1hJWmX99M/rQ5hiUY
	ZvZ6dUnvz8WaA6pbo9qRkBt65Hx0gTiopTZxNL7tEALvywtXS+ND9OvtRaBCN+cwgIDi6f
	YjPnHgzx4/hnGUInU9qaJgo4wE92E7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718762794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w+duwK6gh2vWHbc5cyD6xb9g9g9wIY5+tyLnsCB2khA=;
	b=uqKA9iV2toN9eEV/TGg1AK9sKoPbM8zj+6+wxSXt23GiomGp6AKa+SeOUxUzx2FDzGwLs+
	PBTlSJPgt4GVE5CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6462513AAA;
	Wed, 19 Jun 2024 02:06:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lYC9ESo9cmYYNgAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 19 Jun 2024 02:06:34 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 1/3] io_uring: Fix probe of disabled operations
Date: Tue, 18 Jun 2024 22:06:18 -0400
Message-ID: <20240619020620.5301-2-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619020620.5301-1-krisman@suse.de>
References: <20240619020620.5301-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	RCVD_TLS_ALL(0.00)[]

io_probe checks io_issue_def->not_supported, but we never really set
that field, as we mark non-supported functions through a specific ->prep
handler.  This means we end up returning IO_URING_OP_SUPPORTED, even for
disabled operations.  Fix it by just checking the prep handler itself.

Fixes: 66f4af93da57 ("io_uring: add support for probing opcodes")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/opdef.c    | 8 ++++++++
 io_uring/opdef.h    | 4 ++--
 io_uring/register.c | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 7d5c51fb8e6e..f3af2126fc7d 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -746,6 +746,14 @@ const char *io_uring_get_opcode(u8 opcode)
 	return "INVALID";
 }
 
+bool io_uring_op_supported(u8 opcode)
+{
+	if (opcode < IORING_OP_LAST &&
+	    io_issue_defs[opcode].prep != io_eopnotsupp_prep)
+		return true;
+	return false;
+}
+
 void __init io_uring_optable_init(void)
 {
 	int i;
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 7ee6f5aa90aa..14456436ff74 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -17,8 +17,6 @@ struct io_issue_def {
 	unsigned		poll_exclusive : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
-	/* opcode is not supported by this kernel */
-	unsigned		not_supported : 1;
 	/* skip auditing */
 	unsigned		audit_skip : 1;
 	/* supports ioprio */
@@ -47,5 +45,7 @@ struct io_cold_def {
 extern const struct io_issue_def io_issue_defs[];
 extern const struct io_cold_def io_cold_defs[];
 
+bool io_uring_op_supported(u8 opcode);
+
 void io_uring_optable_init(void);
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index 50e9cbf85f7d..75f8e85cf0b0 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -59,7 +59,7 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 
 	for (i = 0; i < nr_args; i++) {
 		p->ops[i].op = i;
-		if (!io_issue_defs[i].not_supported)
+		if (io_uring_op_supported(i))
 			p->ops[i].flags = IO_URING_OP_SUPPORTED;
 	}
 	p->ops_len = i;
-- 
2.45.2


