Return-Path: <io-uring+bounces-1955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3D18CDC41
	for <lists+io-uring@lfdr.de>; Thu, 23 May 2024 23:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E2D01C209F8
	for <lists+io-uring@lfdr.de>; Thu, 23 May 2024 21:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D375433C9;
	Thu, 23 May 2024 21:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qpC+xVud";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GKxiSx2T";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kTLFYkl+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EiL6UcvX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B022E5579F
	for <io-uring@vger.kernel.org>; Thu, 23 May 2024 21:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716500734; cv=none; b=HQ0WH9EKH9KRRCKGxigntHVdgvbCiLXHbRZVOxlI+mr5oqUyIvrMwtoQptrOrXU8VhXz+uvivQ+qm7BCCJI+QixBlMOc055amp49B5rNybYLxChd9w1WteQ3LZXdSB5VETfbTaT1sIXJQMqARcyET+nzYCV/h1qXylT3irNuVp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716500734; c=relaxed/simple;
	bh=yfcEPAAaCKhBnztj0nE2yzlI6fk5K9q4GEj4aqBwWhY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sfeUeWxOjfD5t/WM+2Dc8XZaosfOs52D7DadxbTGaP+vDNFZhAqRPUzHPGReuI/JFmPjt17/oJ0AFY1me6y2CaKRoG2SXiuQx3poaP8pwowChg04adrsJX2ZX1vWLxneEai/Ow9HJWDbRnR5/OzVJ6k5WoABJJ8Dwcgc4dAwq4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qpC+xVud; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GKxiSx2T; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kTLFYkl+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EiL6UcvX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D181422DC3;
	Thu, 23 May 2024 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716500725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q5SyXxZekpfUGoYNddvNWn9mauXsn4I4YHrU8sPBZ5Q=;
	b=qpC+xVudqvLy162AHi+XI/tu01VAIx+kVFIUW9O1hE8YEUakwW5U7vsvkv9HrvypJsop4w
	9D2kcnA8j9YS9OfrKZckb44EXn7pJq160DyTJRvA2rnEQqrNcN8aEp/nzEqs2O5ufDk3WN
	LRgK6mZwNxw5LR7t18STOVr0AZAWyZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716500725;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q5SyXxZekpfUGoYNddvNWn9mauXsn4I4YHrU8sPBZ5Q=;
	b=GKxiSx2Tbe9C3k8cTEbKfs+XCRH2IOv65vm2KYABfF++GS8VSyMGI1gE/Nj7rMrmlUnZTT
	qMipTNWr/oTJpdCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kTLFYkl+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EiL6UcvX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716500724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q5SyXxZekpfUGoYNddvNWn9mauXsn4I4YHrU8sPBZ5Q=;
	b=kTLFYkl+KTKCx2vJwm2VSE62m4VnoKyhkp0URku/MiWq05NHfmW5tKhEDVa5CRvJf9h0BX
	pi2BRnmQ3y0qrVXFYgF29de0kAKH48QinnfpcW7BS6TNdK1FxrSjXA7dyTsoLTvb8+M+B5
	Mo0JruQOs0HHOj/Qb9qKyDvgv6DC9Sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716500724;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q5SyXxZekpfUGoYNddvNWn9mauXsn4I4YHrU8sPBZ5Q=;
	b=EiL6UcvXTyhtx57YSQRn0qJXdeK0IHs9uMExM4KfbQit+t7lGcWPXWz5M+GY//ErzZK4v7
	FbP4nQ779tC4EiCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9811513A6C;
	Thu, 23 May 2024 21:45:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qpT2HvS4T2ZYOwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 23 May 2024 21:45:24 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring: Drop per-ctx dummy_ubuf
Date: Thu, 23 May 2024 17:45:17 -0400
Message-ID: <20240523214517.31803-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.11
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D181422DC3
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.11 / 50.00];
	BAYES_HAM(-1.10)[88.17%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email]

Commit 19a63c402170 ("io_uring/rsrc: keep one global dummy_ubuf")
replaced it with a global static object but this stayed behind.

Fixes: 19a63c402170 ("io_uring/rsrc: keep one global dummy_ubuf")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/io_uring_types.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7a6b190c7da7..91224bbcfa73 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -373,7 +373,6 @@ struct io_ring_ctx {
 	struct io_restriction		restrictions;
 
 	/* slow path rsrc auxilary data, used by update/register */
-	struct io_mapped_ubuf		*dummy_ubuf;
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
-- 
2.44.0


