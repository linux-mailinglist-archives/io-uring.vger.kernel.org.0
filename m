Return-Path: <io-uring+bounces-5503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A139F3C0A
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E42C164E6E
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378CF1D45F2;
	Mon, 16 Dec 2024 20:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kAiayW3l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Jf6b8rNz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kAiayW3l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Jf6b8rNz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E931D434F
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381991; cv=none; b=pCTM7CCGpqpEO6Pmq3fYGBY4tD1SeZPHUgCnySS3Ws53+JqMMLTZFxA7GRgCLV4IrzHoaDy5t/pi0vPbATFKXZDuFP3p9o/lodmSefwbHuRrgW5Kfm3kRckk6Onhk+nQMYQEfpHiP2ipLevA7ltifU0F6RXiJhcOCdkBnd5nK0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381991; c=relaxed/simple;
	bh=eKmTenzsjDa9AyTJprUvtNfpcY4RZJh8rLp8pr7ocUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hG8wUytKvikUgaUXMzuEcb9//XWyCSAZPeVFU1Gip2HAzdZawWkcI/AeQSc+p0RWfknewLw/uJUH/3hd2x9shdNCTGgqf4e1TjpXIdRiO8AaAbZPeoJBCmN7+kMrG4smM+Rdb+8giItihoy1q2WqpN2WLr9h68P+VJyh+3QNYzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kAiayW3l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Jf6b8rNz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kAiayW3l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Jf6b8rNz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 870E91F37E;
	Mon, 16 Dec 2024 20:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734381987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yM4E++QMx6GuseBwerzzRzJi6bqTTfo1+njNuLPbQI4=;
	b=kAiayW3lE6WURQkFXHZZHUkm8f0G6Zp0E9VlYIOX7y/H3THgi1GZyjgJYHTzAwj8rlrFE7
	jevJM3D9xvRzLJytBK5XULQjBUw669Szh/MoOOwPMMkbHV285nHScXHpojRf1xYx9wny+v
	IkuWhcjHpauLpZEVNJ4/aAswPnFqFCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734381987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yM4E++QMx6GuseBwerzzRzJi6bqTTfo1+njNuLPbQI4=;
	b=Jf6b8rNzgkWRqAragjPk+avgF48b2QLVJkLCqOZJ9lKqf7lqJVBhQoPIdSASrkQLYkV0oP
	bWVQQ9yr9GbcfjCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734381987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yM4E++QMx6GuseBwerzzRzJi6bqTTfo1+njNuLPbQI4=;
	b=kAiayW3lE6WURQkFXHZZHUkm8f0G6Zp0E9VlYIOX7y/H3THgi1GZyjgJYHTzAwj8rlrFE7
	jevJM3D9xvRzLJytBK5XULQjBUw669Szh/MoOOwPMMkbHV285nHScXHpojRf1xYx9wny+v
	IkuWhcjHpauLpZEVNJ4/aAswPnFqFCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734381987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yM4E++QMx6GuseBwerzzRzJi6bqTTfo1+njNuLPbQI4=;
	b=Jf6b8rNzgkWRqAragjPk+avgF48b2QLVJkLCqOZJ9lKqf7lqJVBhQoPIdSASrkQLYkV0oP
	bWVQQ9yr9GbcfjCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2AECB137CF;
	Mon, 16 Dec 2024 20:46:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iaAJOqKRYGfSZAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:26 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 0/9] Clean up alloc_cache allocations
Date: Mon, 16 Dec 2024 15:46:06 -0500
Message-ID: <20241216204615.759089-1-krisman@suse.de>
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
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

Hi, Jens, Pavel.

I sent this v2 originally during US thanksgiving week, so I'm resending
now under a more suitable time, rebased and retested on top of Jen's
for-6.14/io_uring branch.  It keeps the changes requested in v1:
renaming the allocation helper and introducing a callback instead of
zeroing the entire object, as suggested by Jens.

This was tested against liburing testsuite, with lockdep and KASAN
enabled.

For v1, please see:
  https://lore.kernel.org/io-uring/87plmrnstq.fsf@mailhost.krisman.be/T/#t

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

 io_uring/alloc_cache.h | 13 +++++++++++++
 io_uring/futex.c       | 13 +------------
 io_uring/io_uring.c    | 17 ++---------------
 io_uring/io_uring.h    | 23 +++++++++++++++++++++++
 io_uring/msg_ring.c    |  7 -------
 io_uring/msg_ring.h    |  1 -
 io_uring/net.c         | 35 ++++++++++++++++++-----------------
 io_uring/poll.c        | 13 +++++--------
 io_uring/rw.c          | 36 ++++++++++++++++--------------------
 io_uring/timeout.c     |  5 ++---
 io_uring/uring_cmd.c   | 20 ++------------------
 io_uring/waitid.c      |  4 ++--
 12 files changed, 84 insertions(+), 103 deletions(-)

-- 
2.47.0


