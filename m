Return-Path: <io-uring+bounces-5369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E098B9EA30B
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:44:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97481666D9
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB6321505D;
	Mon,  9 Dec 2024 23:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AqwmO6HW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0FEB1wWI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="T4anTrCr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1NOCiV1n"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C838619CC33
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787869; cv=none; b=Ne4Uc3ZK9GQf+YyFd4Yean1AVy5L0EzKl0iWnVT9drJiUuEt/uquYnyrJPFEn9FCx2d41M3dHUaOWdLy+6+mrgKoxg5mULRvrRi1hSVZIOmK+hQVq0DF7hYXPUEdFsDdZ2BfPM9yFNW2XIR28VF4JbB8t3LEaIFClt6TJoXeFZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787869; c=relaxed/simple;
	bh=rIQRSe3abg/qm4oFX9AL5KsGQt87ck+zsif/Lrkwn7o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F0vs7EGgFTDTFkhJ1kyrwUPBLCeDuG9FdwSQ3018a3ZlLFSb7O7LqMtFifMz7pwaVNueMrTpGw1FlRFf9ia3LxGaXvt9QEkU8oK2/fJrzeGKxuhK2PlVqFxhlFI7YBhmxX3EJi9WX3oNWGWPGbhbn14gJ5gQdAjM2sPh987VIdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AqwmO6HW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0FEB1wWI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=T4anTrCr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1NOCiV1n; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B50B21169;
	Mon,  9 Dec 2024 23:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4DX+yzqeiOOdD2FclzNyn2xkadw7/+d4muMwYd0FfNM=;
	b=AqwmO6HWn2+q5tJM6mS+pHqizj/77cTj+Pn8LWv1bkSUl8iNQ9fPtaPYdicSihhPyfzTDE
	GwkrnrJD2g3n0bHOyv4zhzK1l739qUOUcI9orw3m1MgWHjpuo0LiVMzkt7MxNr5/t2lH0G
	aJdN9fAIpnjt+P8RwVSWKPnGHt7hruo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787866;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4DX+yzqeiOOdD2FclzNyn2xkadw7/+d4muMwYd0FfNM=;
	b=0FEB1wWI1k6aBt3bE+0PsCAqC9smX8NpooypXxStgUJux4nFgpU/NkuS9SmIIcGZ5H6IdQ
	GbV1A9FlF9+wf+DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4DX+yzqeiOOdD2FclzNyn2xkadw7/+d4muMwYd0FfNM=;
	b=T4anTrCrMrwFH7ITog1HsDScX4bOXhv9ppJfFvl1o6mkk8l1pt2tFALGJVN7F4/QKs9ecZ
	iNidrSRgQVygAQnSHo06F7IUuBoU5XSpxdb5uEB2tmgS1WAvRlKTwL4zW6MCvvsy4J3+Ls
	Tx2YgD6IMqdTRA3gk7Hw27uw9d2DC7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4DX+yzqeiOOdD2FclzNyn2xkadw7/+d4muMwYd0FfNM=;
	b=1NOCiV1n5BIHftfRMDoCP+SPHjTGgnRVYTDZehHNgm2KziXfpp6Hvun4tvqtR6WQZ3oZ4x
	C8y3Ww4cLZGL3tBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4D63138A5;
	Mon,  9 Dec 2024 23:44:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g5wSKtiAV2cwHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:44:24 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC liburing 0/2] IORING_OP_CLONE/EXEC support and tests
Date: Mon,  9 Dec 2024 18:44:19 -0500
Message-ID: <20241209234421.4133054-1-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-1.28 / 50.00];
	BAYES_HAM(-2.98)[99.90%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -1.28
X-Spam-Flag: NO

This is the liburing counterpart of the  IORING_OP_CLONE and
IORING_OP_EXEC kernel patches.  Please, refer to the kernel patchset for
details.

manpages are missing.  I'd like to settle down on the semantics and the
RFC stage before writing them down.  Will of course make it part of a
V1.

Thanks,

Gabriel Krisman Bertazi (2):
  Add IORING_OP_CLONE/EXEC support
  tests: Add test for CLONE/EXEC operations

 src/include/liburing.h          |  25 ++
 src/include/liburing/io_uring.h |   3 +
 test/Makefile                   |   1 +
 test/clone-exec.c               | 436 ++++++++++++++++++++++++++++++++
 4 files changed, 465 insertions(+)
 create mode 100644 test/clone-exec.c

-- 
2.47.0


