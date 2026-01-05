Return-Path: <io-uring+bounces-11379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 19144CF5F0B
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 00:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CDCA4300CB77
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 23:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C74528682;
	Mon,  5 Jan 2026 23:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aS0NhLjv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QWpEKH8w";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aS0NhLjv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QWpEKH8w"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107F73A1E6D
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 23:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767654593; cv=none; b=t3w8VoIwXLX5Q8pirSghTssyi72+QJqIHBq9fHuOo59jsp1HukqABNXrRdcu1Kl/ZSLWo01VKPf8+/VKcbje814RdHVxVIWPydckSb78jKFhQ3MNTQxdjKNuSGE80xYcX9MITsY5XGnPVJUHNg6l2LY6ibaE+g9GEanb39JdOMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767654593; c=relaxed/simple;
	bh=rFEccHds3JCm7M8G5s3pZkyQwxxWrnKJXsam6GICqks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bGmWAV+Ftum+VlytwU2BhYLEtsVhQBW4gewLo7fBXaliQ5B5y0Qx3jJxX82fIytL95Se8lixTFP6U/fmd5UlwbMWMjQjo5FWgPoVlNNMCRD8pyye+QNZfIEH/UwHvyk72pFbN8ssxcf8fHWSGOW12UVDhX7fm4CHOUivNwdd5Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aS0NhLjv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QWpEKH8w; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aS0NhLjv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QWpEKH8w; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 04BF65BCC2;
	Mon,  5 Jan 2026 23:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767654589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EZGqd/hjiE646OdT2on4mSg7cpEtZlmlqpeKUkl9sSc=;
	b=aS0NhLjv/gu62AcdFgpkiM35IEovG4xEuyB78+QA8exg2/LfnnfTKFunMRYLxwrGBZuo3U
	pZBhidNOuo9CyIAFo4gfFlT1j6z3o6xk8bVH4IjsqsVmpY+zqfZHL69nyXi4n4/a8+fGly
	tRIkm1mRSqmTUTSEGsmr73cG/8S5pwk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767654589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EZGqd/hjiE646OdT2on4mSg7cpEtZlmlqpeKUkl9sSc=;
	b=QWpEKH8w3xvguf7IR/l4vuY1CWcZfxIMkOl5s8bSKIMHMlmH6yMYwo/sMCHWr7ZAA7VXVz
	Ub44Z576ik+1dSDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767654589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EZGqd/hjiE646OdT2on4mSg7cpEtZlmlqpeKUkl9sSc=;
	b=aS0NhLjv/gu62AcdFgpkiM35IEovG4xEuyB78+QA8exg2/LfnnfTKFunMRYLxwrGBZuo3U
	pZBhidNOuo9CyIAFo4gfFlT1j6z3o6xk8bVH4IjsqsVmpY+zqfZHL69nyXi4n4/a8+fGly
	tRIkm1mRSqmTUTSEGsmr73cG/8S5pwk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767654589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EZGqd/hjiE646OdT2on4mSg7cpEtZlmlqpeKUkl9sSc=;
	b=QWpEKH8w3xvguf7IR/l4vuY1CWcZfxIMkOl5s8bSKIMHMlmH6yMYwo/sMCHWr7ZAA7VXVz
	Ub44Z576ik+1dSDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E65B3EA63;
	Mon,  5 Jan 2026 23:09:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OfCgGrxEXGm8YAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 05 Jan 2026 23:09:48 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring: Trim out unused includes
Date: Mon,  5 Jan 2026 18:09:32 -0500
Message-ID: <20260105230932.3805619-1-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.982];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

Clean up some left overs of refactoring io_uring into multiple files.
Compile tested with a few configurations.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/alloc_cache.h |  1 +
 io_uring/cancel.c      |  2 --
 io_uring/filetable.h   |  1 -
 io_uring/io_uring.c    | 12 ------------
 io_uring/io_uring.h    |  1 -
 5 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index d33ce159ef33..bb2f21a7bfd6 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -2,6 +2,7 @@
 #define IOU_ALLOC_CACHE_H
 
 #include <linux/io_uring_types.h>
+#include <linux/kasan.h>
 
 /*
  * Don't allow the cache to grow beyond this size.
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index ca12ac10c0ae..38452ab06098 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -2,10 +2,8 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/namei.h>
 #include <linux/nospec.h>
 #include <linux/io_uring.h>
 
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 7717ea9efd0e..c348233a3411 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -2,7 +2,6 @@
 #ifndef IOU_FILE_TABLE_H
 #define IOU_FILE_TABLE_H
 
-#include <linux/file.h>
 #include <linux/io_uring_types.h>
 #include "rsrc.h"
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cb24cdf8e68..0d812042e38f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -40,37 +40,25 @@
  * Copyright (c) 2018-2019 Christoph Hellwig
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/syscalls.h>
-#include <net/compat.h>
 #include <linux/refcount.h>
-#include <linux/uio.h>
 #include <linux/bits.h>
 
 #include <linux/sched/signal.h>
 #include <linux/fs.h>
-#include <linux/file.h>
 #include <linux/mm.h>
-#include <linux/mman.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
-#include <linux/bvec.h>
-#include <linux/net.h>
-#include <net/sock.h>
 #include <linux/anon_inodes.h>
-#include <linux/sched/mm.h>
 #include <linux/uaccess.h>
 #include <linux/nospec.h>
-#include <linux/fsnotify.h>
-#include <linux/fadvise.h>
 #include <linux/task_work.h>
 #include <linux/io_uring.h>
 #include <linux/io_uring/cmd.h>
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <linux/jump_label.h>
-#include <asm/shmparam.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a790c16854d3..c5bbb43b5842 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -4,7 +4,6 @@
 #include <linux/errno.h>
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
-#include <linux/kasan.h>
 #include <linux/poll.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
-- 
2.52.0


