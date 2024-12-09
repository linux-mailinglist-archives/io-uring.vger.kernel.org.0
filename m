Return-Path: <io-uring+bounces-5359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D007A9EA301
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD47616671A
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49DFD19B3EE;
	Mon,  9 Dec 2024 23:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H3RDFSRj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FgylPE9F";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H3RDFSRj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FgylPE9F"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D1F224884
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787814; cv=none; b=Z90TYNZxYr1uWzzt46lY2Eh8xt/XLGaicm5j5p9VvtJuuEpsrAP6D6GOJzpivhQGiAiS7tfiXIvC2sP8/8cm/KTkQrmd+tOUgyAJy6UwdM4SieC27BA8g/eOlt3Id1Qm6Oby/XjR7U/bvNxQhATVx8baB5Q4n5Nri4RnrFzphKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787814; c=relaxed/simple;
	bh=PReUK/sHd/nI3MqI7F9tQRJN8nEpWdpge5O3TSkSv2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GvvuU8cLkb+ZoRnpFk8FHw5wgEFn4albJUr3+zanSJtDMoMH1VBWTyJysBfrcCaUVqVUwmJqp2Q7RbcOd4QStNXtjrKjEBUKDtBXb7GXDROQ78Aqfj2SkxbGD0imCOZO7akgI77qsMsjPO3bqJrPTVfLUte6KjeXtSK3YsiPbQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H3RDFSRj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FgylPE9F; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H3RDFSRj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FgylPE9F; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8EB211F441;
	Mon,  9 Dec 2024 23:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FzUNWkjuvzUcs4Ldep1waUEr0DKlwCOGYzTvQbM1LBU=;
	b=H3RDFSRjJigXzA1Pq5i3qxIfal0OWTC6lxbVJ2VmUCdjv5Gg76tOvvPs2efV/zzscBa2W/
	rPQhOM8cQIRCsPtA1jB+aQDO8vdVAFtdo3llWFeGLch14KKrvKQSJqwRCRXRAvo5uyJZPj
	KPTiqWSL0gq7MX3yARlwagmGTCFn75s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787809;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FzUNWkjuvzUcs4Ldep1waUEr0DKlwCOGYzTvQbM1LBU=;
	b=FgylPE9FYBuJPRjWs7SlqR/1c4dte4SjE0hXhYDgN8Nsa+7CqIC/F4p+aNld7Khh6cst36
	HG93uhzEmbaKZDDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H3RDFSRj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FgylPE9F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FzUNWkjuvzUcs4Ldep1waUEr0DKlwCOGYzTvQbM1LBU=;
	b=H3RDFSRjJigXzA1Pq5i3qxIfal0OWTC6lxbVJ2VmUCdjv5Gg76tOvvPs2efV/zzscBa2W/
	rPQhOM8cQIRCsPtA1jB+aQDO8vdVAFtdo3llWFeGLch14KKrvKQSJqwRCRXRAvo5uyJZPj
	KPTiqWSL0gq7MX3yARlwagmGTCFn75s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787809;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FzUNWkjuvzUcs4Ldep1waUEr0DKlwCOGYzTvQbM1LBU=;
	b=FgylPE9FYBuJPRjWs7SlqR/1c4dte4SjE0hXhYDgN8Nsa+7CqIC/F4p+aNld7Khh6cst36
	HG93uhzEmbaKZDDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53D87138A5;
	Mon,  9 Dec 2024 23:43:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d5hhDKGAV2fkHAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 0/9] Launching processes with io_uring
Date: Mon,  9 Dec 2024 18:43:02 -0500
Message-ID: <20241209234316.4132786-1-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EB211F441
X-Spam-Level: 
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -1.51
X-Spam-Flag: NO

During LPC 2022, Josh Triplett proposed io_uring_spawn as a mechanism to
fork and exec new processes through io_uring [1].  The goal, according
to him, was to have a very efficient mechanism to quickly execute tasks,
eliminating the multiple roundtrips to userspace required to fork,
perform multiple $PATH lookup and finally execve.  In addition, he
mentioned this would allow for a more simple implementation of
preparatory tasks, such as file redirection configuration, and handling
of stuff like posix_spawn_file_actions_t.

This RFC revives his original patchset.  I fixed all the pending issues
I found with task submission, including the issue blocking the work at
the time, a kernel corruption after a few spawns, converted the execve
command into execveat* variant, cleaned up the code and surely
introduced a few bugs of my own along the way.  At this point, I made it
an RFC because I have a few outstanding questions about the design, in
particular whether the CLONE context would be better implemented as a
special io-wq case to avoid the exposure of io_issue_sqe and
duplication of the dispatching logic.

I'm also providing the liburing support in a separate patchset,
including a testcase that exemplifies the $PATH lookup mechanism
proposed by Josh.

Thanks,

[1]  https://lwn.net/Articles/908268/

Gabriel Krisman Bertazi (6):
  io_uring: Drop __io_req_find_next_prep
  io_uring: Expose failed request helper in internal header
  kernel/fork: Don't inherit PF_USER_WORKER from parent
  fs/exec: Expose do_execveat symbol
  io_uring: Let commands run with current credentials
  io_uring: Let ->issue know if it was called from spawn thread

Josh Triplett (3):
  kernel/fork: Add helper to fork from io_uring
  io_uring: Introduce IORING_OP_CLONE
  io_uring: Introduce IORING_OP_EXEC command

 fs/exec.c                      |   2 +-
 include/linux/binfmts.h        |   5 +
 include/linux/io_uring_types.h |   3 +
 include/linux/sched/task.h     |   1 +
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/Makefile              |   2 +-
 io_uring/io_uring.c            |  27 ++---
 io_uring/io_uring.h            |   8 ++
 io_uring/opdef.c               |  18 +++
 io_uring/opdef.h               |   2 +
 io_uring/spawn.c               | 195 +++++++++++++++++++++++++++++++++
 io_uring/spawn.h               |  13 +++
 kernel/fork.c                  |  21 ++++
 13 files changed, 279 insertions(+), 21 deletions(-)
 create mode 100644 io_uring/spawn.c
 create mode 100644 io_uring/spawn.h

-- 
2.47.0


