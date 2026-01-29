Return-Path: <io-uring+bounces-11977-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cMtGGT7be2noIwIAu9opvQ
	(envelope-from <io-uring+bounces-11977-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:12:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3C5B5342
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 63A623006B41
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 22:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A88326922;
	Thu, 29 Jan 2026 22:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZfGjjc2a";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oeajPHpO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZfGjjc2a";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oeajPHpO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5733936A011
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 22:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769724728; cv=none; b=bsPPj9nDzOzH2WqMWLyHjCMTBsIZMRfJN79Ke1ytIfvmBez3cRRmNcUNQngPQByGY87uQ19kNEkC15krwMbNKGptyDfK9B8K3VoyErKCSr+edK51Ho8QNJeyE0MUwogUtLCMfrKn5MnREzfBLcdE4VDwbrl89JafZ4k8pOnJMiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769724728; c=relaxed/simple;
	bh=mTpljjn1BStxgbWqjiikIwtQQEwd/DpI2ldSnoHBaLI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NQSeJBXC5CL/PgWnSO+jKuA4xyr/Dza5X0Yy5uCkb2Mk9flJH/XGXQlyhgEpMNIvSpncQErBBaf72HlhRYPFgNBDtSX2fIRXUlaemDY0ry1ETE4GMq3X0zwHzGIEtiGRf7KqKf4840FSVgvWEsPSY0j/kKQIpi7bfSqyHJyVJfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZfGjjc2a; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oeajPHpO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZfGjjc2a; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oeajPHpO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B24815BCF5;
	Thu, 29 Jan 2026 22:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=ZfGjjc2aM4bFahKNUOB/B1FzJyZy7SAKy97LdrJYti9LxebQtgjxsk77Gk6JTsI/MKB5uA
	vObmTPyZRHuhNiGGGuZkNjm7HOGpYD/sXbQNzuL1li/yUm2PAMqwmNo0Ey8gFOETPq8yMx
	LAPvXNPwheEK36vFyOJGfvYY31x2Inc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=oeajPHpOiuGa2yxIAsoB8410i7RA2T6/Ay4f+3uyPHpxAsqZ/dgPQvpAqWxOL6MhUbDOis
	IfG3YpJzGPfZk4DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=ZfGjjc2aM4bFahKNUOB/B1FzJyZy7SAKy97LdrJYti9LxebQtgjxsk77Gk6JTsI/MKB5uA
	vObmTPyZRHuhNiGGGuZkNjm7HOGpYD/sXbQNzuL1li/yUm2PAMqwmNo0Ey8gFOETPq8yMx
	LAPvXNPwheEK36vFyOJGfvYY31x2Inc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tfjqObhbTkkqPhq1xp1ApOV91NVuIjaXLWyEZcqVtxU=;
	b=oeajPHpOiuGa2yxIAsoB8410i7RA2T6/Ay4f+3uyPHpxAsqZ/dgPQvpAqWxOL6MhUbDOis
	IfG3YpJzGPfZk4DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 590943EA61;
	Thu, 29 Jan 2026 22:11:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YYokDyHbe2kDbwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 29 Jan 2026 22:11:45 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Subject: [PATCH 0/2] Introduce IORING_OP_MMAP
Date: Thu, 29 Jan 2026 17:11:36 -0500
Message-ID: <20260129221138.897715-1-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11977-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,oracle.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux-foundation.org:email,kvack.org:email]
X-Rspamd-Queue-Id: AE3C5B5342
X-Rspamd-Action: no action

Hi,

There's been a few requests over time for supporting mmap(2) over
io_uring. The reasoning are twofold: 1) serving as base for batching
multiple mappings in a single operation 2) supporting mmap of fixed
files.

Since mmap can operate on either anonymous memory and file descriptors,
patch 1 adds support for optional fds in io_uring commands.  Patch 2
implements the mmap operation itself.

Note this patchset doesn't do any kind of smarter batching in MM.  While
we can potentially do some interesting optimizations already, like
holding the MM write lock instead of reacquiring it for each mapping, I
wanted to focus on the API discussion first.  This is left as future
work.

liburing support, including testcases, will be sent shortly to the list,
but can also be found at:

 https://github.com/krisman/liburing -b mmap

Thanks,

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org
Cc: io-uring@vger.kernel.org

Gabriel Krisman Bertazi (2):
  io_uring: Support commands with optional file descriptors
  io_uring: introduce IORING_OP_MMAP

 include/uapi/linux/io_uring.h |  10 +++
 io_uring/Makefile             |   2 +-
 io_uring/io_uring.c           |  15 ++--
 io_uring/mmap.c               | 147 ++++++++++++++++++++++++++++++++++
 io_uring/mmap.h               |   4 +
 io_uring/opdef.c              |   9 +++
 io_uring/opdef.h              |   2 +
 7 files changed, 183 insertions(+), 6 deletions(-)
 create mode 100644 io_uring/mmap.c
 create mode 100644 io_uring/mmap.h

-- 
2.52.0


