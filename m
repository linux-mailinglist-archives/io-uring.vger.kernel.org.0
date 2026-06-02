Return-Path: <io-uring+bounces-13591-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id gqKsOtQ3H2pZiwAAu9opvQ
	(envelope-from <io-uring+bounces-13591-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 22:06:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 59CF3631A19
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 22:06:44 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uD1b7mnO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=E4b63943;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uD1b7mnO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=E4b63943;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13591-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13591-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4BD0A30B735A
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 20:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BB6282F1F;
	Tue,  2 Jun 2026 20:03:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5CD175A79
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 20:03:30 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430611; cv=none; b=FxHyghlRR5pwPAPUyJ5cJXKL10ATDS8h/VQq9Nab/zKkfVLyV6a3n9JSrdC6GRANkzZofmboMotaXXUibjVmjvs1s+fF7Wh8kRZW3cizZl16FzGoTu+BrFAHesgIH/R+XMxI7nvhNS85wN3r7e+12mb9cPbKsS+3VwVSOC0C7XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430611; c=relaxed/simple;
	bh=H8om9NmZJXaIEx1Vmi26eCcpd0CSnDOckiSh1WGIL/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S99LPYow3leG6v/C0LSMfNpD/hv5SzgW3X7t4Ayloufoq40brS8YOP0/fGVSkTJ3gMiHiZibpQps24hi3UtpCx2iHoAgfj/kMhy4F212Q8MWn37k1uGZk5GUCij94h9ItxsOVkqK0tI54eUPoOWtgLJj853ns0VB1NnZ32h23bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uD1b7mnO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E4b63943; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uD1b7mnO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E4b63943; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BBA9A6AA7C;
	Tue,  2 Jun 2026 20:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780430608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Nx04XYNRaxN3FBRGiXr2vjB8O5Hdpp8SjFI+UstssoA=;
	b=uD1b7mnO1Y391dvA+DpWEicxzarAPiO9ql72ufesk9M6bSI5AjAkSwZENuYEB6zLYZl6uT
	bpf2N3zl4KV+89ah6Lgxp7qMvtPdf85iS4iRzFFkzzjHWZwZ2pTUaDKptdzSO+WqxGR+aM
	74Dctsj55XeUw1pBwekt7Ab5bjGVFdU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780430608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Nx04XYNRaxN3FBRGiXr2vjB8O5Hdpp8SjFI+UstssoA=;
	b=E4b63943xg/4y7Wt98hdICdmmqENeD7TWdv4v4G23rhcNdgSqDH3N6OqqN/pTHGd1Alpml
	oOLYIJHSpjHjkPAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780430608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Nx04XYNRaxN3FBRGiXr2vjB8O5Hdpp8SjFI+UstssoA=;
	b=uD1b7mnO1Y391dvA+DpWEicxzarAPiO9ql72ufesk9M6bSI5AjAkSwZENuYEB6zLYZl6uT
	bpf2N3zl4KV+89ah6Lgxp7qMvtPdf85iS4iRzFFkzzjHWZwZ2pTUaDKptdzSO+WqxGR+aM
	74Dctsj55XeUw1pBwekt7Ab5bjGVFdU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780430608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Nx04XYNRaxN3FBRGiXr2vjB8O5Hdpp8SjFI+UstssoA=;
	b=E4b63943xg/4y7Wt98hdICdmmqENeD7TWdv4v4G23rhcNdgSqDH3N6OqqN/pTHGd1Alpml
	oOLYIJHSpjHjkPAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A5E7779A7;
	Tue,  2 Jun 2026 20:03:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hrVkDhA3H2pDMgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 02 Jun 2026 20:03:28 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 0/3] trivial cleanups to net operations
Date: Tue,  2 Jun 2026 16:03:12 -0400
Message-ID: <20260602200315.1761983-1-krisman@suse.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13591-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 59CF3631A19




Gabriel Krisman Bertazi (3):
  io_uring: Avoid msghdr on op_connect/op_bind async data
  io_uring: Remove async_size for OP_LISTEN
  io_uring: Drop wrong comment in OP_NOP

 io_uring/net.c   | 15 +++++++--------
 io_uring/net.h   |  4 ++++
 io_uring/nop.c   |  1 -
 io_uring/opdef.c |  5 ++---
 4 files changed, 13 insertions(+), 12 deletions(-)

-- 
2.54.0


