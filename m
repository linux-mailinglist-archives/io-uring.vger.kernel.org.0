Return-Path: <io-uring+bounces-10775-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 738B0C82ECA
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 01:24:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3D61C4E027A
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 00:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AA21C5F13;
	Tue, 25 Nov 2025 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CwRrdkm4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jl0AO7ac";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0HBchCJ3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="66AeOOf3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA521531C1
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 00:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764030247; cv=none; b=RdkY5p7/uaeAoIQgEwIMij8vsZiuCdZDOV9WpHJNsFVHhtrbSQOReg67F5AaHZTf83TWO8KWle+xpnvDPZj73K1oFt8U0crMw4G2T+VRgzfzlHr+VhhOK+VttFKPSo3ZebxTELTSfyoP5HifHZf208O7K/uFiZv8gzeqd+XpoVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764030247; c=relaxed/simple;
	bh=fPc3agFs3tcDUZrmmv9NdN0pIRjVDB/V0mOklTZ6o6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q2QeJYVlqUT/zCGbQmka3GwKzOnXM2sc03j9rCXNwLqWwVW0gEpbDA/RiqDqZJ4/ubTKWYzks5yLNRtO9pBEmO42FkI4Na0tPqpXUVRd/h4VJmzaLNKbW8XV2xW0c82nOE30BkghcN3LLS86PkHLTYDAzU5Snmv/oeAImZSpGNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CwRrdkm4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jl0AO7ac; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0HBchCJ3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=66AeOOf3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0618D5BCD8;
	Tue, 25 Nov 2025 00:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764030244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LYq9OMdK9juDC0DTGp4Je/6H/iWodNVnJc2cSQ9hB7U=;
	b=CwRrdkm4p3MstD5rSq0UcpmaUqQEiy3/5jUmW/Th5oydkHs6S0Igf7LbF4BQzXHMUVBR22
	xb/deo8yShVGJEZ/oaAHNqolpOkXLcQS2Ta+pU2MSl2RqyxNmfB6hZSnDufVCgo+inSTR4
	CIhWrV2a4DQ06PqjfJ079juK4OV1wwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764030244;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LYq9OMdK9juDC0DTGp4Je/6H/iWodNVnJc2cSQ9hB7U=;
	b=jl0AO7ac2gO0us/i87Muz6imJSeMR3Asa7ZI4diDP78v8avvrDgFAyHRMLfCJg8nkLBDTl
	QDxIFdo4n4MCadCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0HBchCJ3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=66AeOOf3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764030243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LYq9OMdK9juDC0DTGp4Je/6H/iWodNVnJc2cSQ9hB7U=;
	b=0HBchCJ3EX99monIRtC7GbvMOatqrCqSmgUhjxicdiFKZcf6O/8ypQbSj3tEPQydCn96AH
	2Yc/CQoI+lxXruZjzBLm/dDLGc+DM0rB5o4kvhioUZMsPPeKwKGkPXqyy0KqCN07Rny5+W
	fsuoFijz7Sp9vxCFdGn5vxPOdnAZ8TE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764030243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LYq9OMdK9juDC0DTGp4Je/6H/iWodNVnJc2cSQ9hB7U=;
	b=66AeOOf3dhZyIYF2k1GT4Y4yeUDn890qsGWWK1GnjMro5rURZGdWaRmJvmXsUoQeVyLypF
	RQOYErU6zuS9N7AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B80393EA63;
	Tue, 25 Nov 2025 00:24:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vm3IJiL3JGl6QQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 00:24:02 +0000
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
Subject: [PATCH v3 0/3] Introduce getsockname io_uring_cmd
Date: Mon, 24 Nov 2025 19:23:40 -0500
Message-ID: <20251125002345.2130897-1-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0618D5BCD8
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Since V2:
  - Comment fix (Kuniyuki)
  - Move sockaddr_storage into callee (Kuniyuki)
  - Add r-b tags
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
CC: netdev@vger.kernel.org
CC: io-uring@vger.kernel.org
CC: Jakub Kicinski <kuba@kernel.org>
CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Kuniyuki Iwashima <kuniyu@google.com>
CC: Paolo Abeni <pabeni@redhat.com>
CC: Willem de Bruijn <willemb@google.com>
CC: Simon Horman <horms@kernel.org>

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


