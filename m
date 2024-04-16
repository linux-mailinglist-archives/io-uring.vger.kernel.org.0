Return-Path: <io-uring+bounces-1566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4AC68A60B6
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 04:11:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B21C1F21575
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 02:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05939DDBD;
	Tue, 16 Apr 2024 02:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Vn0JdB7r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EliIELxh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Vn0JdB7r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EliIELxh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E2FBA42
	for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 02:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713233467; cv=none; b=H4F7htL2znMm6FTJ/amRj6nBEsFLKMxBrr6PYFYk+WBQxcOH5z2ZvF+6a4rOiYdyvh9SpluC3ac8XuWBCb+IV5Rl0A2syBIxxYf9gGz7654bswnZ2wGUU94JtWujGY32ymTKLUCOf6KA8SjgVkMw4sJG6mKgJgz0triWF2b1Rdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713233467; c=relaxed/simple;
	bh=U7i9iHazGrXwt35yf3BxNIrg16+COg04yp/5T0OIpbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z5WIxzVjwNHNsoeNUHDOY5T9kOZh/pDu2Zj6o3ey/ZCr5b9JTYXleStD4ETb7B2v8klcVqUYRJaRVi1h80HPJCyuFW1rz1zbY6bQjotGrTdnlBG2V1vCRjoAzf0x70hZ+r+H3iUIgweKZfijdm8joS+MX7fVMFYMpTbY4x5w/p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Vn0JdB7r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EliIELxh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Vn0JdB7r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EliIELxh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B25625D60A;
	Tue, 16 Apr 2024 02:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713233463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9YOEgQNhI4zC88jS5ZGfgsJHxhG8RwdEL92s9hjrUM4=;
	b=Vn0JdB7rLxfw2+TEa3DC4kCvtZ/lJFEYnvBuw77OuPLEK9ri5eDwMr8yVyUyR+a6RKi8cQ
	XZvZpCSn0PR7hCZ7spl+rRheZ4glppnEPYSxQa1jTQ5/dpUrrls3dfLPcNyHEoybJNpTJv
	t43XkyIBDTZelZr7zj6sda/Pzli8eh0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713233463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9YOEgQNhI4zC88jS5ZGfgsJHxhG8RwdEL92s9hjrUM4=;
	b=EliIELxhsrOMhaJ18ZJ+94BftqHJwKe6y6lPsaz7H0l/wxKaW2vBti8m7PsdeS8NRGaF0H
	mwH7BRePIS94nbDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vn0JdB7r;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EliIELxh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713233463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9YOEgQNhI4zC88jS5ZGfgsJHxhG8RwdEL92s9hjrUM4=;
	b=Vn0JdB7rLxfw2+TEa3DC4kCvtZ/lJFEYnvBuw77OuPLEK9ri5eDwMr8yVyUyR+a6RKi8cQ
	XZvZpCSn0PR7hCZ7spl+rRheZ4glppnEPYSxQa1jTQ5/dpUrrls3dfLPcNyHEoybJNpTJv
	t43XkyIBDTZelZr7zj6sda/Pzli8eh0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713233463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9YOEgQNhI4zC88jS5ZGfgsJHxhG8RwdEL92s9hjrUM4=;
	b=EliIELxhsrOMhaJ18ZJ+94BftqHJwKe6y6lPsaz7H0l/wxKaW2vBti8m7PsdeS8NRGaF0H
	mwH7BRePIS94nbDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F74013931;
	Tue, 16 Apr 2024 02:11:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RJAVCzfeHWa5eAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 16 Apr 2024 02:11:03 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 0/2] io-wq: cancelation race fix and small cleanup in io-wq
Date: Mon, 15 Apr 2024 22:10:52 -0400
Message-ID: <20240416021054.3940-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-0.03 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.02)[51.86%];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -0.03
X-Spamd-Bar: /
X-Rspamd-Queue-Id: B25625D60A
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Hi Jens,

Two small fixes to the wq path, closing a small race of cancelation with
wq work removal for execution.

Thank you,

Gabriel Krisman Bertazi (2):
  io-wq: write next_work before dropping acct_lock
  io-wq: Drop intermediate step between pending list and active work

 io_uring/io-wq.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

-- 
2.44.0


