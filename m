Return-Path: <io-uring+bounces-10793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0B1C87336
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 22:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3A1E23527B0
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 21:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40612FB0B3;
	Tue, 25 Nov 2025 21:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oTSvLs3D";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eDLK+Odm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FW7WnyNW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SVHJM5eQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2BC2EB86C
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764105502; cv=none; b=hUhidHlItiRqO9keyTIHG9x2/kkmZvieY9CGQZEM/X20S6WlUDpSrhoTUZ63EN3NyzqMkstGQoYASVY0WIOWko7UvjnEn4PMQ8uBQf6aaR2vU90n9j05RsNMfTF6ctbNTVcMhamysPCUVyEP4xwxQguLcXf4lEDaiK/cZaPipMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764105502; c=relaxed/simple;
	bh=Uq0ebvFY65zDQbd0LhyiTvfXg7+fFlT4E3vrr2nMAok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iu6My9Qi9j0E46hM9MoQhjlXmAc8tWEPuHgz9b77utO82dpoF/HydkJqbCVvn7UhtDj9Qu/1/wQXrDmyM1Ov+Yc9Abb9vK1r/d7eLKyETavnVxvm7cJepzY8mDdQ0/ZQEbkB2+LXfJJH4nNFGXJi9qOhc3iNAyD0bQzxXNOUk1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oTSvLs3D; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eDLK+Odm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FW7WnyNW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SVHJM5eQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB3135BD61;
	Tue, 25 Nov 2025 21:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764105498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+2Y8L07i5LGOEPun/oAkBB24owr4gUgZW2r0AKASQ1U=;
	b=oTSvLs3DD6PxbIroge9tTc/sYfIH5WQK9jzFzUckFq7adQViYAyz+F2S4J/Rx4r7Ua+XjJ
	kiAwZM6kJy+a6SM6VtwCM477TUzDiAwTCZ+dYO+En2Q7Pc8yorKaOg2Dlc4K6DauWlZmTq
	y+BPp6D5JLYJ39ZdJzzLtWGZI7JARvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764105498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+2Y8L07i5LGOEPun/oAkBB24owr4gUgZW2r0AKASQ1U=;
	b=eDLK+Odm1vQNUnfX/+o+82l+W2XfwgIwpQBAiXiU2obllTlCu0Xh/GJzO+UhGjWHVwutrN
	zcfv3zArfmxQdeDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764105496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+2Y8L07i5LGOEPun/oAkBB24owr4gUgZW2r0AKASQ1U=;
	b=FW7WnyNWuOsf6/vDgdmZ6JoYMcb7ikfhlrf/Al1aXIdVF+JDk9do2TvkxXnYQ1zDJdbmtX
	AigW0HcFf7Bq/klXxoYdqX8+Vj0Igp0YcqJfrnyquTIw8ptsvJrV5JLS0/iIOIkTS/fiBG
	N08XeS4OBwDcU6uCk8wL8XYSdAZdIIw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764105496;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+2Y8L07i5LGOEPun/oAkBB24owr4gUgZW2r0AKASQ1U=;
	b=SVHJM5eQ+OnAXRaefvngdvhNukdClnxyAm5r8cWXBSotA63iSCF6ldz1XJD083JASGdqEn
	LcIovvdJUBjodyCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F9FD3EA63;
	Tue, 25 Nov 2025 21:18:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NY2YHBgdJmlqbwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 21:18:16 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
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
Subject: [PATCH v4 0/3] Introduce getsockname io_uring_cmd
Date: Tue, 25 Nov 2025 16:17:58 -0500
Message-ID: <20251125211806.2673912-1-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Since V3:
  - Fix passing of 'peer' in io_uring side.
Since V2:
  - Move sockaddr_storage to do_sockname
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

 include/linux/socket.h        |  6 ++--
 include/uapi/linux/io_uring.h |  1 +
 io_uring/cmd_net.c            | 22 ++++++++++++
 net/compat.c                  |  4 +--
 net/socket.c                  | 67 +++++++++++------------------------
 5 files changed, 49 insertions(+), 51 deletions(-)

-- 
2.51.0


