Return-Path: <io-uring+bounces-2038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F8F8D6B52
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B122B21606
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 21:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153A47D40E;
	Fri, 31 May 2024 21:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tRpw4fYY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sj2SZszh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tRpw4fYY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sj2SZszh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CC77D071;
	Fri, 31 May 2024 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717190006; cv=none; b=BMpcqf5EQsGL9m3jXOP/pg0KkIrrCS9LdyuWo/WjaLYk2nXaTGEA/V9t5whYGSPzhxpVmguDDmB8miFengtOzLun7uCYeu+CBkl17rrgj3+uSvm/K3HjJy+jCd15LuTe5If6gvDIRd2PI1mXJeIr9SGHLesyVXTIZqVwsHobIgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717190006; c=relaxed/simple;
	bh=Oi5tGAiTcfFHWAkH7ifIo54KftIVZ90oLtsiLPHaDCc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FWmkNocI4DKPDNcihfWT9bqE6GEcNZUoQJuz8H0SbQISVqwSVhoWUzFOgjuwMoJa5e94WtFKJIfcS2TEMhAMd/zYqh67NlPxlcoA0bxHNgHVYoRYsFY/5xkdPQfpM1PaL5ykjGDwo7EqvYyBbl6JVjU04+cahmwNgUPeMDLlkBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tRpw4fYY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sj2SZszh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tRpw4fYY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sj2SZszh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FDA11F397;
	Fri, 31 May 2024 21:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717190000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=U4OJ2EIk9PTfEXMCvOcROVoGTceO00/WVwlKGUhZTx4=;
	b=tRpw4fYY1nbBGx6B+W71wJkCOxYl/24XXbc75d9moR7UXxpCtVYAKyufHX1FjyAHdFlkUQ
	9z0RAOUdSsxU6K00/o9HoN4q3KhWyJuvpx+WoLBpZLQUvR/G9bySk3dj0gCYUpOskAI02H
	FAB3UOmLuZH45b+6vLh1byXLljt47/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717190000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=U4OJ2EIk9PTfEXMCvOcROVoGTceO00/WVwlKGUhZTx4=;
	b=sj2SZszh9D203YYIwYydrUG7GMMr4irLvdnQSWOKXMNznCOKzPNKJtPymrQ9wYZT9DqZhD
	1CROps1YzlxGLjDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717190000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=U4OJ2EIk9PTfEXMCvOcROVoGTceO00/WVwlKGUhZTx4=;
	b=tRpw4fYY1nbBGx6B+W71wJkCOxYl/24XXbc75d9moR7UXxpCtVYAKyufHX1FjyAHdFlkUQ
	9z0RAOUdSsxU6K00/o9HoN4q3KhWyJuvpx+WoLBpZLQUvR/G9bySk3dj0gCYUpOskAI02H
	FAB3UOmLuZH45b+6vLh1byXLljt47/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717190000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=U4OJ2EIk9PTfEXMCvOcROVoGTceO00/WVwlKGUhZTx4=;
	b=sj2SZszh9D203YYIwYydrUG7GMMr4irLvdnQSWOKXMNznCOKzPNKJtPymrQ9wYZT9DqZhD
	1CROps1YzlxGLjDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6B05137C3;
	Fri, 31 May 2024 21:13:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ExX7LW89WmaragAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 31 May 2024 21:13:19 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 0/5] io_uring: support IORING_OP_BIND and IORING_OP_LISTEN
Date: Fri, 31 May 2024 17:12:06 -0400
Message-ID: <20240531211211.12628-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.13 / 50.00];
	BAYES_HAM(-2.33)[96.90%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.13
X-Spam-Flag: NO

Following a discussion at LSFMM, this patchset introduces two new
io_uring operations for bind(2) and listen(2).

The goal is to provide functional parity of registered files and direct
file descriptors with regular fds for io_uring network operations.  The
cool outcome is that we can kickstart a network server solely with
io_uring operations.

This feature has been requested several times in the past, including
at:

  https://github.com/axboe/liburing/issues/941

Regarding parameter organization within the SQE, specifically for
bind(2), I'm following the implementation of IO_RING_CONECT.  So, even
though addr_len is expected to be an integer in the original syscall, I
pass it through addr2, to match IO_RING_CONNECT.  Other than that, the
implementation is quite straightforward.

Patchset 1 fixes a memleak in IO_RING_CONNECT that you might want to
apply ahead of the rest of the patchset; Patches 2 and 3 adapt the net/
side in preparation to support invocations from io_uring; patch 4 and 5
add the io_uring boilerplate.

I wrote liburing support, including tests. I'll follow with those
patches shortly.

Gabriel Krisman Bertazi (5):
  io_uring: Fix leak of async data when connect prep fails
  net: Split a __sys_bind helper for io_uring
  net: Split a __sys_listen helper for io_uring
  io_uring: Introduce IORING_OP_BIND
  io_uring: Introduce IORING_OP_LISTEN

 include/linux/socket.h        |  3 ++
 include/uapi/linux/io_uring.h |  2 +
 io_uring/net.c                | 78 ++++++++++++++++++++++++++++++++++-
 io_uring/net.h                |  6 +++
 io_uring/opdef.c              | 26 ++++++++++++
 net/socket.c                  | 48 +++++++++++++--------
 6 files changed, 144 insertions(+), 19 deletions(-)

-- 
2.44.0


