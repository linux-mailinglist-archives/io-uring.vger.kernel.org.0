Return-Path: <io-uring+bounces-10797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 774C0C87399
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 22:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 681804E050A
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 21:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B89D231858;
	Tue, 25 Nov 2025 21:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zfauppJ0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CoUVyyr1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p1aLRcVg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yI2b3iIc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10762264A9
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764106042; cv=none; b=BgUUnw5205UufzvZqaBGe7O4OidQ/po6mLUzrsCC/jw4mm07UXtQiT4qzQMq+QYETTo6ifZJMLVOK/wi2hIhYbhBuzVv3+KKqqyVpzpyYai2ATd6Z1kEkrR3WwH0fL5VQ7qh0zt84pZDsPWuq08mEQefFzUYYWsLGsefwapj0WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764106042; c=relaxed/simple;
	bh=8dlZEVv9ZRsijBHf+IR0JVomSFigFlCW6CzYRMhji4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bHLq5zEjXsZuVVVN/x/FMNHRkp0NG92RmGclvcanMACuIPDYImZ2HGVuG9H0Xiz4gob3crNAsEtbCfqthHJGaiKOnsC+PoUHoyqAKnIdQerG56b4vbo0ME/lsr2l+4FgqMpn3VH0ch8yobDHVBXXbvsMHKhbEK/Rdncv4ZMHG58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zfauppJ0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CoUVyyr1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p1aLRcVg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yI2b3iIc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EAF0122965;
	Tue, 25 Nov 2025 21:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764106039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GygtVdz8EHRsIHrxQKitPD3PLjmDKi7Yk0uIAU0KtVQ=;
	b=zfauppJ0Ym61E0kA8dOHPNUAeYjNoBRqgRNZSfyJNxFMROgZjDswkpueoV4J9FxaEXpdW5
	pxNQabKU/EXOh/huP7LRdy43xeuGZ1JlSOjDRAxTdTiK2Uc5O/xBPennLb26uwvtC6eFZA
	DySsrvPrvZAc/8ygACXcBYAwkSGLubg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764106039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GygtVdz8EHRsIHrxQKitPD3PLjmDKi7Yk0uIAU0KtVQ=;
	b=CoUVyyr1owdnfUmNml7/Y9a6eDFkiQzckbsYQzsJouz+mAZysQajujDZDIDF07SC7EBeCu
	uH7qrKt/24odyBAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764106038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GygtVdz8EHRsIHrxQKitPD3PLjmDKi7Yk0uIAU0KtVQ=;
	b=p1aLRcVgyJHTR1Co96QDSX24yQSjq1XwH6hWa7OfIk97O0fwjbR7To/ornMPKws1s/RTrN
	UU5Bm6TpZZJsUNz67tJ8SDjLJmBzE+EVVgYN8LS83kFCKsv7kccqGstSg6I5vdk9ExJh1i
	RlOV2pp/IZ4/LLGs/R9mU+obrzsBxuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764106038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GygtVdz8EHRsIHrxQKitPD3PLjmDKi7Yk0uIAU0KtVQ=;
	b=yI2b3iIcOiuZSh02orJqE8nLtDCkz65I9CtQeSZIy3AWVauNHr3ETFoBdDHFOX1MZTfQIX
	O89lNXC4wuEir0Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADCC93EA63;
	Tue, 25 Nov 2025 21:27:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id weExJDYfJmmXdwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 21:27:18 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	csander@purestorage.com
Subject: [PATCH liburing v2 0/4] liburing: getsockname support
Date: Tue, 25 Nov 2025 16:27:11 -0500
Message-ID: <20251125212715.2679630-1-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,purestorage.com:email,kernel.dk:email,suse.de:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Since V1:
  - bind-test.t: use client socket used when doing a getpeername
  - Use the new io_uring_prep_uring_cmd to define prep_cmc_getsockname

This is the library counterpart for the kernel support.  Also available
at:

https://github.com/krisman/liburing -b socket

---
To:  Jens Axboe <axboe@kernel.dk>
CC: io-uring@vger.kernel.org
CC: csander@purestorage.com

Gabriel Krisman Bertazi (4):
  liburing: Introduce getsockname operation
  test/bind-listen.t: Use ephemeral port
  bind-listen.t: Add tests for getsockname
  man/io_uring_prep_getsockname.3: Add man page

 man/io_uring_prep_getsockname.3 |  76 ++++++++++++++++++
 src/include/liburing.h          |  13 +++
 src/include/liburing/io_uring.h |   1 +
 test/bind-listen.c              | 137 +++++++++++++++++++++++++++++---
 4 files changed, 215 insertions(+), 12 deletions(-)
 create mode 100644 man/io_uring_prep_getsockname.3

-- 
2.51.0


