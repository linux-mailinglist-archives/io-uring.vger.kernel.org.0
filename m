Return-Path: <io-uring+bounces-2548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5BA93A9B8
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 01:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23F65B21202
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 23:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20EC114884B;
	Tue, 23 Jul 2024 23:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g94jyIUe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WMPhKPym";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g94jyIUe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WMPhKPym"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A9613BAD5
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 23:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721776662; cv=none; b=nJHLICKcgGz1SrjEXyihZCTGDpF2uP1gWAp8W4ZBOKPNQZR5uSMVj7sGa5F2mDs4crQyRTlNnSFSMJfjs/vDMvtl/FagZbGKgluQfS39HWvGn1QaazHqyN22OVal66pTZh+4snDOhmCSPJy7TWVXSLrUByroz6VGy4nDTRewTDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721776662; c=relaxed/simple;
	bh=3K3ULnfGKy05bsDkFnGdQXG8S0jrhRFj3uHwDVrFpdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PGj17mW0x5H8aZLGC8g9c70Zyf0HCyDy+Rblnsf8FOH0sqEeP24c+HNE2aJtB2JA79QrajIYts8rTAzhsTdyGByg2QiPhZrTjOQovQ8FaiEZrjdQFDfCNhMyl9ge7PGdcBqj3Rnp2hA574iwEhicUyz3sPT8ZcZpEepdbLEO+CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g94jyIUe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WMPhKPym; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g94jyIUe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WMPhKPym; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 195AE1F454;
	Tue, 23 Jul 2024 23:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3oyt/jp5Xf8481kEebzKvhbNYtKUW0OehpZBbdRTJQk=;
	b=g94jyIUei1UxOkTkUtmKTV+sQgiEORrQRR1ZtfnpeOiLAxw1BEufQ78t7+27UPrOcnI9TM
	mCkTlqex8dcOsKUgYtqNPTsj7qASsb6XkM2uSz5r12GUxY3MntIt4TSmb5rTn+/PqGNNvx
	wR/QY9WEh2Dri3umPodn2ZyT03UFACM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3oyt/jp5Xf8481kEebzKvhbNYtKUW0OehpZBbdRTJQk=;
	b=WMPhKPymeCvRT/NCAF2iTj4V/i1tmP9/fATVYjWFKAuIY7//F9zxJrkwwt7ZJnzhUAutuW
	V3I1zbteIMwYBaAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g94jyIUe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WMPhKPym
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3oyt/jp5Xf8481kEebzKvhbNYtKUW0OehpZBbdRTJQk=;
	b=g94jyIUei1UxOkTkUtmKTV+sQgiEORrQRR1ZtfnpeOiLAxw1BEufQ78t7+27UPrOcnI9TM
	mCkTlqex8dcOsKUgYtqNPTsj7qASsb6XkM2uSz5r12GUxY3MntIt4TSmb5rTn+/PqGNNvx
	wR/QY9WEh2Dri3umPodn2ZyT03UFACM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3oyt/jp5Xf8481kEebzKvhbNYtKUW0OehpZBbdRTJQk=;
	b=WMPhKPymeCvRT/NCAF2iTj4V/i1tmP9/fATVYjWFKAuIY7//F9zxJrkwwt7ZJnzhUAutuW
	V3I1zbteIMwYBaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D386A13874;
	Tue, 23 Jul 2024 23:17:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c0eELRE6oGa/UgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jul 2024 23:17:37 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing v2 0/5] IORING_OP_BIND/LISTEN support
Date: Tue, 23 Jul 2024 19:17:28 -0400
Message-ID: <20240723231733.31884-1-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [1.69 / 50.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,suse.de];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spamd-Bar: +
X-Rspamd-Queue-Id: 195AE1F454
X-Spam-Level: *
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: 1.69

This is the v2 of userspace support for OP_BIND/OP_LISTEN with wrappers,
manpages and tests.

Beyond the requested fixes in v1, I completely rewrote the testcase to
avoid pthreads and introduced more test cases.  It also ensures the
testcase is properly skipped for older kernels.

Gabriel Krisman Bertazi (5):
  liburing: Add helper to prepare IORING_OP_BIND command
  liburing: Add helper to prepare IORING_OP_LISTEN command
  tests: Add test for bind/listen commands
  man/io_uring_prep_bind.3: Document the IORING_OP_BIND operation
  man/io_uring_prep_listen.3: Document IORING_OP_LISTEN operation

 man/io_uring_prep_bind.3        |  54 +++++
 man/io_uring_prep_listen.3      |  52 +++++
 src/include/liburing.h          |  13 ++
 src/include/liburing/io_uring.h |   2 +
 src/liburing-ffi.map            |   2 +
 test/Makefile                   |   1 +
 test/bind-listen.c              | 381 ++++++++++++++++++++++++++++++++
 7 files changed, 505 insertions(+)
 create mode 100644 man/io_uring_prep_bind.3
 create mode 100644 man/io_uring_prep_listen.3
 create mode 100644 test/bind-listen.c

-- 
2.45.2


