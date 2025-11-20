Return-Path: <io-uring+bounces-10705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BC072C76719
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 22:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8899B3478CD
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 21:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6CE02FB96A;
	Thu, 20 Nov 2025 21:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2N7a1rDb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6soJmkDk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MEhP/zIs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="biY9a4HK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C1E2E11C5
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 21:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675909; cv=none; b=nNWSrAteDUIb6Mf5dOxxgKMMJWAB2xZ0xmy83zeOSKLgGBXzErKemujsl00QJyp20HWqGzZW868VmYMMNqdGEfIrqUJHQaKnnw1CG3B+SLid/sRS/QwD4xwEuVEVV8F/88ytKTQOrY2iLPhI0FsL4N3TdX2qkR9pp/OL30tQ7Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675909; c=relaxed/simple;
	bh=HO1p6FtdKwe0IlOoxU7Ezn7FtqxZ1TXfgnQymRcHnyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yvhu3tyKQjG+uIs1eBNuMAQ+Um+NBTQqupdQKoGudNPEB4CEMN6dCD6jpCb6gLwxCFemmOl2UfPkf+ywMEfr+67S9IjTJAM8AtF9Su5brHi+DrgJhs4MrOiiaz5xgz7mzWzYcIfBY++UuWEshrw3KGn8RfTcZ/GesRFv7tqtuSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2N7a1rDb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6soJmkDk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MEhP/zIs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=biY9a4HK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9B67F2127E;
	Thu, 20 Nov 2025 21:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763675904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MRYbEybroCbmAHAM8NWYzW79+xjF1sGXPMEHm83mnVo=;
	b=2N7a1rDbtaFe+xfeUBYlyYhLmva4wv92dFOy9AiMbNNHCUZ06G3tqKYy59KtuHtiyiF6ia
	BRDqAwZBQletyislwnErVNTxpRcBeFh5JHD6IKjKltL8CcpflZ767Te4z4dUNxJFcWnHTn
	MvQIXVq2MLLBe+J7txQAAR+LjWTaSgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763675904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MRYbEybroCbmAHAM8NWYzW79+xjF1sGXPMEHm83mnVo=;
	b=6soJmkDkFsk4D+ux5sOoz1kkSHv2bzlhjkXCtMpH+dTQFgO512ZTun249Xws4gJoO/boap
	klxeUAftMzwdI+AA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="MEhP/zIs";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=biY9a4HK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763675903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MRYbEybroCbmAHAM8NWYzW79+xjF1sGXPMEHm83mnVo=;
	b=MEhP/zIs0RWad/r2WaTXQRzps/oi5E9pUoVnfmMO3EStheoyvuJyzTsd2LzRY7ruLpKHgS
	mzcGJwCGkhJcCbHksqtWvq2kp7GlVTOHtvHXRs6i20HLJOuKyrSz54dHo1phV9Qkw3zSLI
	vmwzw0Vcu+5hfufin9Ys/c6vVLtKJh8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763675903;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MRYbEybroCbmAHAM8NWYzW79+xjF1sGXPMEHm83mnVo=;
	b=biY9a4HKVZsGA7RaJlR30v94GSy2PnsoQ80ks36j4QcldQF6jOm0MyXCRZGjfvObnh/VFC
	CUZVL0OC+zu4xBAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48A813EA61;
	Thu, 20 Nov 2025 21:58:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ieQpC/+OH2nGdQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 20 Nov 2025 21:58:23 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: 
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	netdev@vger.kernel.org,
	io-uring@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v2 0/3] Introduce getsockname io_uring_cmd
Date: Thu, 20 Nov 2025 16:58:11 -0500
Message-ID: <20251120215816.3787271-1-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 9B67F2127E
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,discord.com:url,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,davemloft.net:email]
X-Spam-Score: -3.01

Since V1:
  - minor style fixes
  - Resend with (more) maintainers cc'ed
  - rebased to axboe/for-next.
--

This feature has been requested a few times in the liburing repository
and Discord channels, such as in [1,2].  If anything, it also helps
solve a long standing issue in the bind-listen test that results in
occasional test failures.

The patchset is divided in three parts: Patch 1 merges the getpeername
and getsockname implementation in the network layer, making further
patches easier; Patch 2 splits out a helper used by io_uring, like done
for other network commands; Finally, patch 3 plumbs the new command in
io_uring.

The syscall path was tested by booting a Linux distro, which does all
sorts of getsockname/getpeername syscalls.  The io_uring side was tested
with a couple of new liburing subtests available at:

   https://github.com/krisman/liburing.git -b socket

Based on top of Jens' for-next.

[1] https://github.com/axboe/liburing/issues/1356
[2] https://discord.com/channels/1241076672589991966/1241076672589991970/1429975797912830074

---
To: Jens Axboe <axboe@kernel.dk>
CC: netdev@vger.kernel.org
CC: io-uring@vger.kernel.org
CC: Jakub Kicinski <kuba@kernel.org>
CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Kuniyuki Iwashima <kuniyu@google.com>
CC: Paolo Abeni <pabeni@redhat.com>
CC: Willem de Bruijn <willemb@google.com>
CC: Simon Horman <horms@kernel.org>
Base: axboe/for-next

Gabriel Krisman Bertazi (3):
  socket: Unify getsockname and getpeername implementation
  socket: Split out a getsockname helper for io_uring
  io_uring: Introduce getsockname io_uring cmd

 include/linux/socket.h        |  6 +--
 include/uapi/linux/io_uring.h |  1 +
 io_uring/cmd_net.c            | 23 ++++++++++++
 net/compat.c                  |  4 +-
 net/socket.c                  | 69 +++++++++++------------------------
 5 files changed, 51 insertions(+), 52 deletions(-)

-- 
2.51.0


