Return-Path: <io-uring+bounces-10933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A9FCA180A
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 20:56:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57EDD3011FB5
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 19:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC7A2FE59D;
	Wed,  3 Dec 2025 19:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KJ6o29K9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TGOgEZsw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KJ6o29K9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TGOgEZsw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED922609C5
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 19:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791555; cv=none; b=W8Mjv7pm3Q0n7YHfByEpAG+oZQmmhAmQ708xKuq0YG/OrN4ltPx1aqgfphbC75En7SdUg4IOkos8gDK5Vn393PTzCO5Bk6Iujk+DMEMgo6ntIYYhrb+VbIAG+BiThH27fmTC6DJ7GGU4YnI2yu8VGXsKSNDcm5JRMkMpANub9VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791555; c=relaxed/simple;
	bh=1BmpIM1MJjCi+TrR7/Ejc7yhJfhoZqC/dcuQ3mMC/KM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sblzhIA8I+Bc07WedvN8d9Sv7f5fVabQXK0sKxkfSEnG7ZVUO7AAt6mQtZEOOfbWvSaTv+BMFrMRhaIGzTdhnMuQoVIBNL9ROJFzE3orDsfKJXofMd4yk43TKguLPrhr+dKin1XsW1Zi0O984qkl3B2KzlyOheeiDe0IHstFKHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KJ6o29K9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TGOgEZsw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KJ6o29K9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TGOgEZsw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4E4D3336D9;
	Wed,  3 Dec 2025 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764791551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RjNyVrx2wUFzcASFyB2ebkD8YQlbwIO8KrXd91v8/G4=;
	b=KJ6o29K9HKy31RINXC8oiYHvx9onAzQBsGfwIso+IH0hQiScjhC8bc/VdXROAkzHMBSZZs
	fLX+fi+eADtmyz8pGnbu9VrDDoJOfeKON82BpgOt9k6Sw5vk1mggW6UkI0jyGO3I0LBQcq
	RjN6VsbzBqypMx3kIA1uk4sFMthc4Vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764791551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RjNyVrx2wUFzcASFyB2ebkD8YQlbwIO8KrXd91v8/G4=;
	b=TGOgEZswUs8nu9HhzmEuuawyswcUBCL9lGTVBHFMxZ0f6jQKvmPT+KJ7tDvDk9tzEYyIwc
	D8HTFJr8mcVB/ZDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764791551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RjNyVrx2wUFzcASFyB2ebkD8YQlbwIO8KrXd91v8/G4=;
	b=KJ6o29K9HKy31RINXC8oiYHvx9onAzQBsGfwIso+IH0hQiScjhC8bc/VdXROAkzHMBSZZs
	fLX+fi+eADtmyz8pGnbu9VrDDoJOfeKON82BpgOt9k6Sw5vk1mggW6UkI0jyGO3I0LBQcq
	RjN6VsbzBqypMx3kIA1uk4sFMthc4Vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764791551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RjNyVrx2wUFzcASFyB2ebkD8YQlbwIO8KrXd91v8/G4=;
	b=TGOgEZswUs8nu9HhzmEuuawyswcUBCL9lGTVBHFMxZ0f6jQKvmPT+KJ7tDvDk9tzEYyIwc
	D8HTFJr8mcVB/ZDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F37FC3EA63;
	Wed,  3 Dec 2025 19:52:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9N0RNf6UMGnGTwAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 03 Dec 2025 19:52:30 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v3 0/4] liburing: getsockname support
Date: Wed,  3 Dec 2025 14:52:14 -0500
Message-ID: <20251203195223.3578559-1-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

Changes since v2:

The main change from the previous iteration is ensuring the test won't
regress in older kernels.  This is done by installing the socket fd and
fallbacking to the syscall.  I avoided reverting to using a fixed port
because that is flaky and would also require recreating the socket.

This is the library counterpart for the kernel support.  Also available
at:

https://github.com/krisman/liburing -b socket

---
CC: io-uring@vger.kernel.org
CC: csander@purestorage.com

Gabriel Krisman Bertazi (4):
  liburing: Introduce getsockname operation
  test/bind-listen.t: Use ephemeral port
  bind-listen.t: Add tests for getsockname
  man/io_uring_prep_getsockname.3: Add man page

 man/io_uring_prep_getsockname.3 |  78 +++++++++++++
 src/include/liburing.h          |  13 +++
 src/include/liburing/io_uring.h |   1 +
 test/bind-listen.c              | 188 +++++++++++++++++++++++++++++---
 4 files changed, 267 insertions(+), 13 deletions(-)
 create mode 100644 man/io_uring_prep_getsockname.3

-- 
2.52.0


