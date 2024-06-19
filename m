Return-Path: <io-uring+bounces-2263-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BEE290E182
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 04:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 419331C22814
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 02:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CFBE541;
	Wed, 19 Jun 2024 02:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ps9R84Ey";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pK8u3Umq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ps9R84Ey";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pK8u3Umq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7DD1A716
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 02:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718762796; cv=none; b=kc5OQMkR9iiVQgOju0vAmcyL2cKuVJT0YmXT4EmgBA2goohcqI3ndMGGB6XoKqdroP4rkyG1muJMEtWIMtkoLvQ/W9L5Nd7WZ3M97Q94AKFEodjFF58VGaduKNbQJxWEpv5GPCJieEgdyduvxsfNLccZXIfxfAuLJ9aEjH9GHc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718762796; c=relaxed/simple;
	bh=jp6Xw64m7i9qTw9pxE3mZHlgvLtYIJdtYqizHLYHqF4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kAR9nVaKGeUOuHC94/ovQKi+hiTKlGmQWmJ58Z7LCCxM4JuasG05h/FXVgEPmbMxHsbK9Su9OZPmU6TF7FxnBkbvOANTy3QKNBQ/Uzp3Ap73jD4heP6eWh/oG0xDxLj2XRBzTTHAqNW6yqEMBAr2LSYttiB4Od3daK8pWH5pX1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ps9R84Ey; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pK8u3Umq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ps9R84Ey; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pK8u3Umq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F2AD21F7B4;
	Wed, 19 Jun 2024 02:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718762793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3/d6UowfaCkMtUEqHjaaOG4gY2iaFEdVrpOLYF8dc8E=;
	b=Ps9R84EyEoULWBTBW5n6cpZas72CMvLWBmkltvucskpmZIX7xJpUIxzCYVLUtwCsBOlDFT
	+lfCe+6rkpMIObB9C/hmzR+vs03TEjGG1R89t4Sph75Yzsqnwi+y6gpfvrtenCxwr9fJcv
	tKDJHUwmAxpNniq20dXVAzWU+2lrMw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718762793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3/d6UowfaCkMtUEqHjaaOG4gY2iaFEdVrpOLYF8dc8E=;
	b=pK8u3UmqcRpi2LYdymSvXRsH0MiZDlFZt6FNCFEPpNlzy0roy5rdrnoC0fiE9qfeBBv6KL
	Q0LH3xIae7N0YgAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ps9R84Ey;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pK8u3Umq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718762793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3/d6UowfaCkMtUEqHjaaOG4gY2iaFEdVrpOLYF8dc8E=;
	b=Ps9R84EyEoULWBTBW5n6cpZas72CMvLWBmkltvucskpmZIX7xJpUIxzCYVLUtwCsBOlDFT
	+lfCe+6rkpMIObB9C/hmzR+vs03TEjGG1R89t4Sph75Yzsqnwi+y6gpfvrtenCxwr9fJcv
	tKDJHUwmAxpNniq20dXVAzWU+2lrMw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718762793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3/d6UowfaCkMtUEqHjaaOG4gY2iaFEdVrpOLYF8dc8E=;
	b=pK8u3UmqcRpi2LYdymSvXRsH0MiZDlFZt6FNCFEPpNlzy0roy5rdrnoC0fiE9qfeBBv6KL
	Q0LH3xIae7N0YgAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0D5213AAA;
	Wed, 19 Jun 2024 02:06:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ngCFJCg9cmYPNgAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 19 Jun 2024 02:06:32 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 0/3] io_uring op probing fixes
Date: Tue, 18 Jun 2024 22:06:17 -0400
Message-ID: <20240619020620.5301-1-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F2AD21F7B4
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Hi Jens,

I didn't know this interface existed until today, when I started looking
at creating exactly this feature.  My goal is to know which operation
supports which modes (registered buffers, bundled writes, iopoll).  Now
that I know it exists, I might just expose the extra information through
io_uring_probe_op->flags, instead of adding a new operation. What do you
think?

Anyway, this patchset is not implementing that.  Patch 1 fixes an issue
with the existing interface. Patches 2 and 3 are small cleanups to the
same path, since I was already looking at it.

I tested it with a !CONFIG_NET kernel to have some disabled operations.
It also survived the liburing testsuite.

Gabriel Krisman Bertazi (3):
  io_uring: Fix probe of disabled operations
  io_uring: Allocate only necessary memory in io_probe
  io_uring: Don't read userspace data in io_probe

 io_uring/opdef.c    |  8 ++++++++
 io_uring/opdef.h    |  4 ++--
 io_uring/register.c | 20 +++++---------------
 3 files changed, 15 insertions(+), 17 deletions(-)

-- 
2.45.2


