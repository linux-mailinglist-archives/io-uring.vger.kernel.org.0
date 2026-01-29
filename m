Return-Path: <io-uring+bounces-11979-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4COGJWbbe2noIwIAu9opvQ
	(envelope-from <io-uring+bounces-11979-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:12:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C71B5351
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:12:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1FDF0301487C
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 22:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A55369210;
	Thu, 29 Jan 2026 22:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iEHaC3CP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eOajUXax";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iEHaC3CP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eOajUXax"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F317326922
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769724772; cv=none; b=j/vPFOq2BWNDeWht43m3BTJiHIBCdS+ljVq5X57LvTQOz4t8nZzdDF3phQzzLlIO0LBzBI2iADviqNzikCAvIz7f9DVr22HgSZSe+LMsBqM6g80xof+yr+kqY5EI0IVFHfXdZfDbOTakXNnFfWcL/84bKzJnYogbqKVXKkbRKzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769724772; c=relaxed/simple;
	bh=1pVl8PVc9NHqa7Q4zYThNHbxC19/T7IURqh9mGGib7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BgmZcTJEnqZlgxCpVb6KPlbhmCl7Yn7M57XTtYH0ATDvvSbdsjbd7WZS9PqEPi/3J8URHGcQ7DClR1S5HOnEsJ/HYQFNkld6dxvztgxyjGjBMZ7FeZSZbZD1S+H4LHWOcf4jW26nu/rx+uhAhX+xsEHMPImlPbSOD1AoupXok5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iEHaC3CP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eOajUXax; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iEHaC3CP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eOajUXax; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 507A15BCE8;
	Thu, 29 Jan 2026 22:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D87K9QKiivntGAq18GZnsXVPZHbkP2PLatmGzLjRnhU=;
	b=iEHaC3CPUa1Y7MOe8TcacKp7bucWDkJlfUUydUqUoEkP3Eq2fzn8YGZy1e7a37OnJdA4uI
	9j4aeLKoKG7zqSe1o7ht0IHhYllGCPkLynYwa7LuHwsoO0oKUvCIcScNrmOibwoNcGkB6s
	VQOrL5o5i2Hjd/Ex/o3XwENJgBbCIK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D87K9QKiivntGAq18GZnsXVPZHbkP2PLatmGzLjRnhU=;
	b=eOajUXaxfVovRdV9SoYagDsM/YW153Pm5f/ZMmX3GxJSh20n27Astbi/CV3ug/sL9lXfNT
	4okdCCxO/14a2qDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iEHaC3CP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eOajUXax
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D87K9QKiivntGAq18GZnsXVPZHbkP2PLatmGzLjRnhU=;
	b=iEHaC3CPUa1Y7MOe8TcacKp7bucWDkJlfUUydUqUoEkP3Eq2fzn8YGZy1e7a37OnJdA4uI
	9j4aeLKoKG7zqSe1o7ht0IHhYllGCPkLynYwa7LuHwsoO0oKUvCIcScNrmOibwoNcGkB6s
	VQOrL5o5i2Hjd/Ex/o3XwENJgBbCIK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D87K9QKiivntGAq18GZnsXVPZHbkP2PLatmGzLjRnhU=;
	b=eOajUXaxfVovRdV9SoYagDsM/YW153Pm5f/ZMmX3GxJSh20n27Astbi/CV3ug/sL9lXfNT
	4okdCCxO/14a2qDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 039D33EA61;
	Thu, 29 Jan 2026 22:12:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l6XyNVjbe2nGbwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 29 Jan 2026 22:12:40 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 0/2] liburing mmap support
Date: Thu, 29 Jan 2026 17:12:34 -0500
Message-ID: <20260129221236.898135-1-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11979-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.de:mid,suse.de:dkim]
X-Rspamd-Queue-Id: 27C71B5351
X-Rspamd-Action: no action

Hi,

This implements IORING_MMAP support.  I'm leaving the manpage of this
patchset, at least until we agree with the API.

Gabriel Krisman Bertazi (2):
  liburing: Add support to IORING_OP_MMAP
  mmap.t: Introduce IORING_OP_MMAP test case

 src/include/liburing.h          |   8 +
 src/include/liburing/io_uring.h |  10 +
 src/liburing-ffi.map            |   2 +
 test/Makefile                   |   1 +
 test/mmap.c                     | 372 ++++++++++++++++++++++++++++++++
 5 files changed, 393 insertions(+)
 create mode 100644 test/mmap.c

-- 
2.52.0


