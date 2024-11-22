Return-Path: <io-uring+bounces-4990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CC39D6554
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B452B21BA6
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DAB185935;
	Fri, 22 Nov 2024 21:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y7QfelMU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gizN3A5t";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y7QfelMU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gizN3A5t"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A5B18732B
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310161; cv=none; b=oHRrLO0FBHTRx9koF7qJkFb7vL1o2nqUC5NFdXKoQnuKbeQeD8z+teHmeZsmsmwj75Xm99zE766WBCmQ+nWRMKXzMd9ohN31kR+I/AVqITFvJugHmjh/Zkm9z/MkG1nQY8mu/HnAZJU0olBLvzK+oAtfzhMac/K2CRWSrJz3Yjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310161; c=relaxed/simple;
	bh=Te9tHP0Na/69MYhdLEXBUMgoWKA/h0G/jTQO2I0H89k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XVk2vtAbV/fab4jOu9akBmMKZvdISwm5WLWRSGudHc0bDawKRippIZavKnCzCZxfkLjbllArYGju/XWvDQ5B9uNfBhyr/plNIguFtHIT93Rs8Zt/k39lMD9Dnq40L9U1REQAepBQK5ZiNGOkyzgM46SyKjUnYSwIEg498eB4Ks4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y7QfelMU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gizN3A5t; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y7QfelMU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gizN3A5t; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4531E1F79A;
	Fri, 22 Nov 2024 21:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mPV2CwX9dHwOEmaVPa5eaNlJ4EYDAcgbd0iVGnNYLSE=;
	b=y7QfelMU/1Bbq+X2gj2+Cuef5uuZwV2Oh2O6otsYRu95NOi8zz+TSRKXyKa0NjjhGiRKA4
	IFEvB7Z/vUsUVnm4yCCQqigggovDkEPftsy4bpqxwjrpptjINJzaYQUlHifGTgMZMtCvjm
	y0IT3OjgQ3d9uhI6cndn3YeKJ0mi1qk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mPV2CwX9dHwOEmaVPa5eaNlJ4EYDAcgbd0iVGnNYLSE=;
	b=gizN3A5tv7+oyZqk8qAQt6F+TXBoaxZr3o+6086GvvoTMJ3VtaVJqIN8MqRsCp1xG8BFgK
	qRMxu4Xhso7AQ+CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=y7QfelMU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gizN3A5t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mPV2CwX9dHwOEmaVPa5eaNlJ4EYDAcgbd0iVGnNYLSE=;
	b=y7QfelMU/1Bbq+X2gj2+Cuef5uuZwV2Oh2O6otsYRu95NOi8zz+TSRKXyKa0NjjhGiRKA4
	IFEvB7Z/vUsUVnm4yCCQqigggovDkEPftsy4bpqxwjrpptjINJzaYQUlHifGTgMZMtCvjm
	y0IT3OjgQ3d9uhI6cndn3YeKJ0mi1qk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mPV2CwX9dHwOEmaVPa5eaNlJ4EYDAcgbd0iVGnNYLSE=;
	b=gizN3A5tv7+oyZqk8qAQt6F+TXBoaxZr3o+6086GvvoTMJ3VtaVJqIN8MqRsCp1xG8BFgK
	qRMxu4Xhso7AQ+CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0854213998;
	Fri, 22 Nov 2024 21:15:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l3NoMYf0QGewXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:15:51 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 0/9] Clean up alloc_cache allocations
Date: Fri, 22 Nov 2024 16:15:32 -0500
Message-ID: <20241122211541.2135280-1-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4531E1F79A
X-Spam-Level: 
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -1.51
X-Spam-Flag: NO

Hi,

This v2 of the alloc_cache allocations has small changes, renaming the
allocation helper and introducing a callback instead of zeroing the
entire object, as suggested by Jens.

This was tested against liburing testsuite, with lockdep and KASAN
enabled.

For v1, please see:
  https://lore.kernel.org/io-uring/87plmrnstq.fsf@mailhost.krisman.be/T/#t

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


