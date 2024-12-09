Return-Path: <io-uring+bounces-5367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6EF99EA309
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B4EE2827FB
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2A619CC33;
	Mon,  9 Dec 2024 23:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wGeQB70L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jpola4jS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wGeQB70L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jpola4jS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E9619F489
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787838; cv=none; b=aznx2/YPrGzVTaAIyOmkbE5XXHkyA/wQKCxxfo3AzTEZkW6uKpJCEuWzBoY3hP/xuvQHCYTT1mByB53U+1eGhNfkFZ6VzlyiW4C4WapCmqbAQFpYTAaPlaZwvLbGb89Va/ScX3v78koPwyqw+k7BLuqGDalcb79GJAR0VFBqSew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787838; c=relaxed/simple;
	bh=scEKmaGxi657XGNenKsYFdKGUY57N3w6Qa6m7C+H5gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTd03NC/VzboFS2Mq5SgpMU4MdizzOmR9bpBk90jQTIAKqBqA4OWV1BSdB9cXZkCc1IyvsFJR3nY+Z/1ViZxqEfkL1anMSHqOgmDMka9DgHLF9rVuSXP8Y5feARdF4v7Vj4P0HmAlQC/4jEXibD7QJXqK7iMxZ/2Lu1gSJgj2uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wGeQB70L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jpola4jS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wGeQB70L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jpola4jS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B61291F441;
	Mon,  9 Dec 2024 23:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YcqAmNjyH/UH/uoc+/N1aN7cUyorhNWqXFxf2TcooWQ=;
	b=wGeQB70LNaEfcAzt0g3tfYP2P/IDmdNSohn22X/ThaEJ+h9eU9hrTHVkwszQxlAk+I0C1d
	vhHHFsPKB25cBU2P9jPIVrUQg+vgf6TG2dUx+FfKL4E0qoCNrilq1LMso2whdc+l82hYbO
	/IOiFV7ltQcwlsmine4NfBgODbY5OW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YcqAmNjyH/UH/uoc+/N1aN7cUyorhNWqXFxf2TcooWQ=;
	b=jpola4jSFybti1MbUZgPy82FnQ7zrPmvJ6X5f6CN43UHtZGu4NK0AoeYbuYvj+dfYQU5Rt
	n5pGe7hH0U3B1cDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YcqAmNjyH/UH/uoc+/N1aN7cUyorhNWqXFxf2TcooWQ=;
	b=wGeQB70LNaEfcAzt0g3tfYP2P/IDmdNSohn22X/ThaEJ+h9eU9hrTHVkwszQxlAk+I0C1d
	vhHHFsPKB25cBU2P9jPIVrUQg+vgf6TG2dUx+FfKL4E0qoCNrilq1LMso2whdc+l82hYbO
	/IOiFV7ltQcwlsmine4NfBgODbY5OW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YcqAmNjyH/UH/uoc+/N1aN7cUyorhNWqXFxf2TcooWQ=;
	b=jpola4jSFybti1MbUZgPy82FnQ7zrPmvJ6X5f6CN43UHtZGu4NK0AoeYbuYvj+dfYQU5Rt
	n5pGe7hH0U3B1cDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E9F0138A5;
	Mon,  9 Dec 2024 23:43:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vfUMGbqAV2cdHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:54 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 8/9] io_uring: Let ->issue know if it was called from spawn thread
Date: Mon,  9 Dec 2024 18:43:10 -0500
Message-ID: <20241209234316.4132786-9-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>
References: <20241209234316.4132786-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

IORING_OP_EXEC can only be called from the spawn task context.  Pass
that information via the issue_flags to let it be verified by the
IORING_OP_EXEC handler.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/io_uring_types.h | 3 +++
 io_uring/spawn.c               | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c141ffec81fe..8717259ba715 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -38,6 +38,9 @@ enum io_uring_cmd_flags {
 	IO_URING_F_CANCEL		= (1 << 11),
 	IO_URING_F_COMPAT		= (1 << 12),
 	IO_URING_F_TASK_DEAD		= (1 << 13),
+
+	/* Set when issuing from spawn thread */
+	IO_URING_F_SPAWN		= (1 << 14),
 };
 
 struct io_wq_work_node {
diff --git a/io_uring/spawn.c b/io_uring/spawn.c
index 1cd069bb6f59..59d6ccf96f45 100644
--- a/io_uring/spawn.c
+++ b/io_uring/spawn.c
@@ -52,7 +52,7 @@ static int io_uring_spawn_task(void *data)
 		req->flags &= ~(REQ_F_HARDLINK | REQ_F_LINK);
 
 		if (!(req->flags & REQ_F_FAIL)) {
-			err = io_issue_sqe(req, IO_URING_F_COMPLETE_DEFER);
+			err = io_issue_sqe(req, IO_URING_F_COMPLETE_DEFER|IO_URING_F_SPAWN);
 			/*
 			 * We can't requeue a request from the spawn
 			 * context.  Fail the whole chain.
-- 
2.47.0


