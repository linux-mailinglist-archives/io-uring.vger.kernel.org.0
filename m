Return-Path: <io-uring+bounces-4791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB299D1D33
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3ABE91F22666
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C60B278C76;
	Tue, 19 Nov 2024 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WZUjrNa3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dyQ0PrK0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WZUjrNa3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dyQ0PrK0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7682AD20
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979355; cv=none; b=kGqOI2hcHxl6qevpKGxwf2xx/XhzU+T7oxPzUkw7aygZByS2BVywq8uZYJ3mA/UQJYuabQIQ3+ACduFg3ahGZ69/fRhiKzoD7md8nVvSgCcEypM4d4cWZ/MJbBBiWZqYiTxKlfso701fC3B1feOY1oDWXtmsXLQeOV8iHQnSB6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979355; c=relaxed/simple;
	bh=hTNkrsmdug6rpfG37rOvY6d4HG++zB0V2i3x1R70oJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GxVzkaRcWKOLWfwocRJ/bZI4PEBNTP01rQISTGdG9Ac7TF0aO885AQnwxf3V2aHyZkiR/88AaC3d6UgoCPf+0GUvrPVoqC2d908K1vHlUWj+Yl57S3HDYIrLErSFtCInV+T662Mj6RIbvwD5XRH8K65bdNrHEb02rd2Z814Flrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WZUjrNa3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dyQ0PrK0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WZUjrNa3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dyQ0PrK0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D3701F365;
	Tue, 19 Nov 2024 01:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Bk53F8kzoNQ0uOS/JMVvILULlSn+S1Ofm9Io0mGLLWk=;
	b=WZUjrNa3jyHAhnaJ7gWSxt+enDBPcsIeq0NFhT2LnCjNn9SAXveiZAZugJzcM+c+ykkfTm
	rwirlYaU2V1oFC+H6LWAKSL4fLbagGsH+yMC+ob1bMqUo1DvHbb6CiAN6xYV/1ZSmssuzR
	bEcp1j5rVPPjQj2mdIYwsSPohCKvrAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Bk53F8kzoNQ0uOS/JMVvILULlSn+S1Ofm9Io0mGLLWk=;
	b=dyQ0PrK0dClIDh+Yx3utDBMVeOXzKZhZQ3d3g6fuFdemGfRycbpVr2ElAUObYiA/PHVlmV
	owkankBSCsP5sKDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Bk53F8kzoNQ0uOS/JMVvILULlSn+S1Ofm9Io0mGLLWk=;
	b=WZUjrNa3jyHAhnaJ7gWSxt+enDBPcsIeq0NFhT2LnCjNn9SAXveiZAZugJzcM+c+ykkfTm
	rwirlYaU2V1oFC+H6LWAKSL4fLbagGsH+yMC+ob1bMqUo1DvHbb6CiAN6xYV/1ZSmssuzR
	bEcp1j5rVPPjQj2mdIYwsSPohCKvrAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Bk53F8kzoNQ0uOS/JMVvILULlSn+S1Ofm9Io0mGLLWk=;
	b=dyQ0PrK0dClIDh+Yx3utDBMVeOXzKZhZQ3d3g6fuFdemGfRycbpVr2ElAUObYiA/PHVlmV
	owkankBSCsP5sKDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D39A31376E;
	Tue, 19 Nov 2024 01:22:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FriDIVfoO2ecLgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:31 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 0/9] Clean up alloc_cache allocations
Date: Mon, 18 Nov 2024 20:22:15 -0500
Message-ID: <20241119012224.1698238-1-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

Jens, Pavel,

The allocation paths that use alloc_cache duplicate the same code
pattern, sometimes in a quite convoluted way.  This series cleans up
that code by folding the allocation into the cache code itself, making
it just an allocator function, and keeping the cache policy invisible to
callers.  A bigger justification for doing this, beyond code simplicity,
is that it makes it trivial to test the impact of disabling the cache
and using slab directly, which I've used for slab improvement
experiments.  I think this is one step forward in the direction
eventually lifting the alloc_cache into a proper magazine layer in slab
out of io_uring.

It survived liburing testsuite, and when microbenchmarking the
read-write path with mmtests and fio, I didn't observe any significant
performance variation (there was actually a 2% gain, but that was
within the variance of the test runs, making it not signficant and
surely test noise).

I'm specifically interested, and happy to do so, if there are specific
benchmarks you'd like me to run it against.

Thanks,

Gabriel Krisman Bertazi (9):
  io_uring: Fold allocation into alloc_cache helper
  io_uring: Add generic helper to allocate async data
  io_uring/futex: Allocate ifd with generic alloc_cache helper
  io_uring/poll: Allocate apoll with generic alloc_cache helper
  io_uring/uring_cmd: Allocate async data through generic helper
  io_uring/net: Allocate msghdr async data through helper
  io_uring/rw: Allocate async data through helper
  io_uring: Move old async data allocation helper to header
  io_uring/msg_ring: Drop custom destructor

 io_uring/alloc_cache.h |  7 +++++++
 io_uring/futex.c       | 13 +------------
 io_uring/io_uring.c    | 17 ++---------------
 io_uring/io_uring.h    | 22 ++++++++++++++++++++++
 io_uring/msg_ring.c    |  7 -------
 io_uring/msg_ring.h    |  1 -
 io_uring/net.c         | 28 ++++++++++------------------
 io_uring/poll.c        | 13 +++++--------
 io_uring/rw.c          | 28 ++++++++--------------------
 io_uring/timeout.c     |  5 ++---
 io_uring/uring_cmd.c   | 20 ++------------------
 io_uring/waitid.c      |  4 ++--
 12 files changed, 61 insertions(+), 104 deletions(-)

-- 
2.47.0


