Return-Path: <io-uring+bounces-2083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B90B18FA6C1
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 02:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FB56285A63
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 00:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93177182;
	Tue,  4 Jun 2024 00:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NO+XPkv2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zKe9g8kc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NO+XPkv2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zKe9g8kc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C6D20E3
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 00:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717459470; cv=none; b=Co86l4gQ1Q2/7U0dY4B2gywDZwQ/NkUp+RIB2ZcToWvFWa/xZz9Yhhisaa+PqD89lhrIOe8LaHQI38TJG2CG0pq4WOVgk4OGR2YeNOe4ykdzWALgN1OTItIdsCNrwIK3Uqw1PVs548VIWUEIkUVeaUH+ZsuQggF6nlImRe6UIEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717459470; c=relaxed/simple;
	bh=PUHhAPdHZnVCAisyRA5rjs4GHhqfTk9lveNiXXLxuLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l5561jmwBQXb21iPFxTuLL7kcYSvVVu1n9P2i3E8MmTu83ZklWhVliqiC5T0Y0hSyQDwyvNoZ6m0qtD5XFKkm6PnfkknkP3gMBSOQ6paom2e5cH0ecjOOW+4jb/lX+f1y+G7ZRp+orJN5P+ZJXBuaKDhO3TpNZi8XjD+zkKbwOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NO+XPkv2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zKe9g8kc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NO+XPkv2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zKe9g8kc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1AFE4219EA;
	Tue,  4 Jun 2024 00:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HpVwnpGFwX6F8uLo9r/P9p+kOFbUNq7zwkNnw394O8M=;
	b=NO+XPkv2ij0C/mvWVRQk/+Fvb8ast6tbRHToEqX4kDJxOupe22AlTfsC1K8ZZC9QgexesQ
	1N9ttYC0I0T4XT2iQk0iJbrjWd6kIeXfqeBVjUM+dDSUh4Lo+9Sq7fLvkKn1XiDBedqYuV
	gbIeEPqU7mWDqvRtKUebES+VPTSwlKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HpVwnpGFwX6F8uLo9r/P9p+kOFbUNq7zwkNnw394O8M=;
	b=zKe9g8kcgO2uXTBU19pNwIIPtXP7j/hVSRfm0bOztpO1ePoBR4PK0SeSNODHWxUhPRRp9V
	qn39BnmoEyBtvNBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NO+XPkv2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zKe9g8kc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HpVwnpGFwX6F8uLo9r/P9p+kOFbUNq7zwkNnw394O8M=;
	b=NO+XPkv2ij0C/mvWVRQk/+Fvb8ast6tbRHToEqX4kDJxOupe22AlTfsC1K8ZZC9QgexesQ
	1N9ttYC0I0T4XT2iQk0iJbrjWd6kIeXfqeBVjUM+dDSUh4Lo+9Sq7fLvkKn1XiDBedqYuV
	gbIeEPqU7mWDqvRtKUebES+VPTSwlKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HpVwnpGFwX6F8uLo9r/P9p+kOFbUNq7zwkNnw394O8M=;
	b=zKe9g8kcgO2uXTBU19pNwIIPtXP7j/hVSRfm0bOztpO1ePoBR4PK0SeSNODHWxUhPRRp9V
	qn39BnmoEyBtvNBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D47AB13A92;
	Tue,  4 Jun 2024 00:04:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id df0HLglaXmZ1CwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 04 Jun 2024 00:04:25 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [RFC liburing 0/5] IORING_OP_BIND/LISTEN support
Date: Mon,  3 Jun 2024 20:04:12 -0400
Message-ID: <20240604000417.16137-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.89
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1AFE4219EA
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.89 / 50.00];
	BAYES_HAM(-2.88)[99.49%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

Hi,

As promised, this is the userspace side of the IORING_OP_BIND/LISTEN
patches.

I decided to write a separate test instead of integrating in
i.e. socket.c Let me know if you prefer I merge it to some existing
testcase.

Keeping as an RFC for now, until we have the kernel side ready.

Gabriel Krisman Bertazi (5):
  liburing: Add helper to prepare IORING_OP_BIND command
  liburing: Add helper to prepare IORING_OP_LISTEN command
  tests: Add test for bind/listen commands
  man/io_uring_prep_bind.3: Document the IORING_OP_BIND operation
  man/io_uring_prep_listen.3: Document IORING_OP_LISTEN operation

 man/io_uring_prep_bind.3        |  54 ++++++++
 man/io_uring_prep_listen.3      |  52 +++++++
 src/include/liburing.h          |  13 ++
 src/include/liburing/io_uring.h |   2 +
 test/Makefile                   |   1 +
 test/bind-listen.c              | 231 ++++++++++++++++++++++++++++++++
 6 files changed, 353 insertions(+)
 create mode 100644 man/io_uring_prep_bind.3
 create mode 100644 man/io_uring_prep_listen.3
 create mode 100644 test/bind-listen.c

-- 
2.44.0


