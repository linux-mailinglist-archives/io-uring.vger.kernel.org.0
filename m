Return-Path: <io-uring+bounces-13593-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id lVeeEc84H2qZiwAAu9opvQ
	(envelope-from <io-uring+bounces-13593-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 22:10:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B460F631A94
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 22:10:54 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JHnuP2x8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZBjTIke7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JHnuP2x8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZBjTIke7;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13593-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13593-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E6E93062A8A
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 20:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CB01F78E6;
	Tue,  2 Jun 2026 20:03:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D399B175A79
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 20:03:42 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430624; cv=none; b=nihE1bdf/yGRpYP+wpgSsW4zF+bnt7hGep7LGJbt/uP4xcw7daFmuu/1RG4zcU+BILfL2nUmd6sB1DYM/J5T4oNAmyQeV+fYWjSyc4psSBDgjq1DX9PVOUlfeO/0g5gCSuUt3xitgcmM3SHBsKB7F6KdU5syaGxt24SYoSk907M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430624; c=relaxed/simple;
	bh=hzib2oODrLpyy2S2nfIa8ghwFwovuGPiVm8xyHAHCnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAMbmSPxwcas0pwH//sb0J62FhdhWJnhKRSKGrziroPMmTbIP3YRHHi+0ZzxEqa6OUJbku4J59qaQfrPT+1SCp13m+HvdoOjuzegfOZXrdvChtVIJS19U2df50fe8xzvzq9Dl/MYriB4osxN3staGUXmfJ5kv+GtHgjm2J4pOOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JHnuP2x8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZBjTIke7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JHnuP2x8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZBjTIke7; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B75746AA7C;
	Tue,  2 Jun 2026 20:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780430617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmhT/91e2dtpX4XcDRUREJ+v6Ypghhrk9gUNmRUcC4c=;
	b=JHnuP2x8Tn/Pi+9nYXB0zsV1G6OUEaA7XeXzctD8bROZ88+ctkbCHRm1xY+MAizS8ix7AM
	gpoyWt6BLAOcQbgeNTmFs50NCkn+/aKGcmygJrDZ8ET3kOXS8uVPJw7mxyigvT36EizU2b
	n2vXl160DNS8IR/SOODTMGejVOb8r30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780430617;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmhT/91e2dtpX4XcDRUREJ+v6Ypghhrk9gUNmRUcC4c=;
	b=ZBjTIke7UPm4hk/wr4KHSI5HlkEi5ySOxeo59chmbuDwvAevcah6RANBNf0Pr2d1m3jPXq
	x7tns/dj4EgN/2Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780430617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmhT/91e2dtpX4XcDRUREJ+v6Ypghhrk9gUNmRUcC4c=;
	b=JHnuP2x8Tn/Pi+9nYXB0zsV1G6OUEaA7XeXzctD8bROZ88+ctkbCHRm1xY+MAizS8ix7AM
	gpoyWt6BLAOcQbgeNTmFs50NCkn+/aKGcmygJrDZ8ET3kOXS8uVPJw7mxyigvT36EizU2b
	n2vXl160DNS8IR/SOODTMGejVOb8r30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780430617;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmhT/91e2dtpX4XcDRUREJ+v6Ypghhrk9gUNmRUcC4c=;
	b=ZBjTIke7UPm4hk/wr4KHSI5HlkEi5ySOxeo59chmbuDwvAevcah6RANBNf0Pr2d1m3jPXq
	x7tns/dj4EgN/2Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C38B779A7;
	Tue,  2 Jun 2026 20:03:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +crAFxk3H2qjMgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 02 Jun 2026 20:03:37 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 2/3] io_uring: Remove async_size for OP_LISTEN
Date: Tue,  2 Jun 2026 16:03:14 -0400
Message-ID: <20260602200315.1761983-3-krisman@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602200315.1761983-1-krisman@suse.de>
References: <20260602200315.1761983-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.79
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13593-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:from_mime,suse.de:email,vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B460F631A94

OP_LISTEN does not use async_data.  Remove it.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/opdef.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index ffa28224cc8f..a6215ee95a3f 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -515,7 +515,6 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.prep			= io_listen_prep,
 		.issue			= io_listen,
-		.async_size		= sizeof(struct io_async_msghdr),
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.54.0


