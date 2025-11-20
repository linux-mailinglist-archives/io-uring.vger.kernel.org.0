Return-Path: <io-uring+bounces-10709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C5168C7676A
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 23:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EF3603560C6
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 22:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A11533FE12;
	Thu, 20 Nov 2025 22:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2EG7pENg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1+MNZEAI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2EG7pENg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1+MNZEAI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9057C2FE567
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676837; cv=none; b=N8rd/Ot/qdsKTRiiorNgx9830X7ADk5OUxPZDonG+X+ei585mPNYJhAM6r4rKOcNI5BBcKHQlPgLRGJiCIYwZn6/RVYWxGIIEQEK6MGCoEdUEvVp9ooJvo+CV1JPxHPCqhDfq69iuFhjef8DJn6kghTQUY8JfobNzUTeZ5MUl/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676837; c=relaxed/simple;
	bh=yAljkqUT/7D5hHc2zDfu8xBgUycw4xA/RhBKULFUYs4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=phecEkU21qQmMGVYz1XaTZzxpxukfPndFpMT9AFU4WjfSVaNCIKvPoFQwjcKJmQPyFJePQDvKUGZwyzoHnQDxnZQzJNEQh7m0xAHLlhcykjsXs7z1c33p/qiz8ZCGikbNv/ITcYeaHzfl9J9nAa9iQgUeeoeANKKbNmozRhR3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2EG7pENg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1+MNZEAI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2EG7pENg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1+MNZEAI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 844472124B;
	Thu, 20 Nov 2025 22:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763676833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J6CDDxiPVkZ0VhWBQxRX9OAQIe0/ce73Ilzk1WyivHo=;
	b=2EG7pENgDuMQL+aN+FYU3BG3NVwf+zXWiuPvXNpbV8NwgN7khjicWQkN8DCGLZqUVaUX3G
	RTVYYWyIqORc3kUqoNrByF8Z2ZnHJnxLhmWIE9Lugn6MZJgDVOks8UZSL5vA/mkTELCrR3
	JU8I3ZDaWf2s9DvEpQ09KUpzHZ2LOgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763676833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J6CDDxiPVkZ0VhWBQxRX9OAQIe0/ce73Ilzk1WyivHo=;
	b=1+MNZEAI+eVxR5OdhSw7TblKFrxRLGL3o/xEGCq0h9e6PYbv7GZdIoUIsDlVGcBTtPMInh
	GuFoUXjfh5XEUCBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2EG7pENg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1+MNZEAI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763676833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J6CDDxiPVkZ0VhWBQxRX9OAQIe0/ce73Ilzk1WyivHo=;
	b=2EG7pENgDuMQL+aN+FYU3BG3NVwf+zXWiuPvXNpbV8NwgN7khjicWQkN8DCGLZqUVaUX3G
	RTVYYWyIqORc3kUqoNrByF8Z2ZnHJnxLhmWIE9Lugn6MZJgDVOks8UZSL5vA/mkTELCrR3
	JU8I3ZDaWf2s9DvEpQ09KUpzHZ2LOgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763676833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J6CDDxiPVkZ0VhWBQxRX9OAQIe0/ce73Ilzk1WyivHo=;
	b=1+MNZEAI+eVxR5OdhSw7TblKFrxRLGL3o/xEGCq0h9e6PYbv7GZdIoUIsDlVGcBTtPMInh
	GuFoUXjfh5XEUCBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D9043EA61;
	Thu, 20 Nov 2025 22:13:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KDxwBqGSH2mUBQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 20 Nov 2025 22:13:53 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: 
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v2 0/4] liburing: getsockname support
Date: Thu, 20 Nov 2025 17:13:38 -0500
Message-ID: <20251120221351.3802738-1-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 844472124B
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

This is the library counterpart for the kernel support.  Also available
at:

https://github.com/krisman/liburing -b socket

---
To:  Jens Axboe <axboe@kernel.dk>
CC: io-uring@vger.kernel.org
CC: csander@purestorage.com

Gabriel Krisman Bertazi (4):
  liburing: Introduce getsockname operation
  test/bind-listen.t: Use ephemeral port
  bind-listen.t: Add tests for getsockname
  man/io_uring_prep_getsockname.3: Add man page

 man/io_uring_prep_getsockname.3 |  76 ++++++++++++++++++
 src/include/liburing.h          |  13 +++
 src/include/liburing/io_uring.h |   1 +
 test/bind-listen.c              | 137 +++++++++++++++++++++++++++++---
 4 files changed, 215 insertions(+), 12 deletions(-)
 create mode 100644 man/io_uring_prep_getsockname.3

-- 
2.51.0


