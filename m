Return-Path: <io-uring+bounces-10189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9069EC07134
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 17:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AF5BF563EAC
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396AB32C944;
	Fri, 24 Oct 2025 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Exu5YHt3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EGJ/rA8y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Exu5YHt3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EGJ/rA8y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ECD32C326
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761320954; cv=none; b=nCsI6u3z1k+9U9nAbam6MXiXIbSWSriCM6NAcbSastZ3acqa8z5q4yJT2rlmCy7sveD8lbD9VKkv9F2Mgi3J1fLliI8PLeRbzW9crCeUFznpiXey5cwfrtf/BofeLUSgLvOBMErB+qv1wTLSsBpPaIZ6Bxxo+iRXZH2lnnBKH2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761320954; c=relaxed/simple;
	bh=Un3L1wqF4UGfqtkW1OlEk25lj5yegT80m7JiXFyyJ2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eqicqMQ3j5zkdPp4hzcsEzrmepWnQud1scIp2x5GkAJ3WHQTk3XGoQU6IZW0+RcftNUczuHUW4qWvdbdnh9qNepvI4/i26PDH4jmsCRyRjacZqJZ7Cy2izA9PCCoSJGk4qayB5iiYCWt5IaJOLHWMnm3rMnR89TqOJrQhnniK/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Exu5YHt3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EGJ/rA8y; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Exu5YHt3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EGJ/rA8y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 776F0211A1;
	Fri, 24 Oct 2025 15:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761320950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zYPzmJ6MohpWts8bH9BulWX/Z/407Zz6EjRW3pGOweM=;
	b=Exu5YHt3MLc/sTKovs8F7IVOiXw24pMv0AC+Xg9/0GqGoWet1lGzkrr2k6kYjtsg0Ppj4M
	uQv3Ya0Wfq9igLQ9Vm5jYYX/5ZojgQ9kPVlUqPc+S4vA/klb8i11svLaswWgWIssGqFUY8
	DQQMqLCfPklHY6W0oCEmxZ8td+Efa0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761320950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zYPzmJ6MohpWts8bH9BulWX/Z/407Zz6EjRW3pGOweM=;
	b=EGJ/rA8yONB/LU/vJlnHYKB9C/fi/un1L58sbZp8S/RyRKqQdW6JbMEIYASuU/W4eoTnUj
	2kMDIzsppXa9cMBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Exu5YHt3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="EGJ/rA8y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761320950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zYPzmJ6MohpWts8bH9BulWX/Z/407Zz6EjRW3pGOweM=;
	b=Exu5YHt3MLc/sTKovs8F7IVOiXw24pMv0AC+Xg9/0GqGoWet1lGzkrr2k6kYjtsg0Ppj4M
	uQv3Ya0Wfq9igLQ9Vm5jYYX/5ZojgQ9kPVlUqPc+S4vA/klb8i11svLaswWgWIssGqFUY8
	DQQMqLCfPklHY6W0oCEmxZ8td+Efa0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761320950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zYPzmJ6MohpWts8bH9BulWX/Z/407Zz6EjRW3pGOweM=;
	b=EGJ/rA8yONB/LU/vJlnHYKB9C/fi/un1L58sbZp8S/RyRKqQdW6JbMEIYASuU/W4eoTnUj
	2kMDIzsppXa9cMBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AA52132C2;
	Fri, 24 Oct 2025 15:49:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wbOUBfaf+2j+EAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 24 Oct 2025 15:49:10 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	netdev@vger.kernel.org,
	io-uring@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH 0/3] Introduce getsockname io_uring_cmd
Date: Fri, 24 Oct 2025 11:48:57 -0400
Message-ID: <20251024154901.797262-1-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 776F0211A1
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
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 


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

Gabriel Krisman Bertazi (3):
  socket: Unify getsockname and getpeername implementation
  socket: Split out a getsockname helper for io_uring
  io_uring: Introduce getsockname io_uring cmd

 include/linux/socket.h        |  6 +--
 include/uapi/linux/io_uring.h |  1 +
 io_uring/cmd_net.c            | 24 ++++++++++++
 net/compat.c                  |  4 +-
 net/socket.c                  | 69 +++++++++++------------------------
 5 files changed, 52 insertions(+), 52 deletions(-)

-- 
2.51.0


