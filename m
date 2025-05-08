Return-Path: <io-uring+bounces-7918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C04FAB0230
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 20:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD83C1B60122
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 18:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FA9281523;
	Thu,  8 May 2025 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j7tGPOA6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cux2VOhp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j7tGPOA6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cux2VOhp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8701538384
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 18:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746727936; cv=none; b=LyOUIBQYka2hVfRCWP+rBP7nPS6nn8NTVd4E0fe6afSHlXXkHO+FXCnzPpVxvkXrY8k4FzLrBz8Rpig9/y/DhEYdti+sqXKUuDM/iPK+NR5IsoObOn2ybpA5tKvNwaqe7qUui7gbzzCyKILpFNz7ocJMEAyxLD+/wp9ot952oFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746727936; c=relaxed/simple;
	bh=fzY+fQyfxpulI4WAecMRSJvl5lyUV0ZIh8+zJcFc8iU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FSb7IzNc8DUB4LIyUHDIRyF+7WBW1y5NBZGpdmov8zoAZegStb4REDQbwOapAUWtJsfHmlAXBU8zQ4HYQqbC18aVnlVjSo+LhwwD1gVT+S0KL9dhLRkPV9RJ01Zw/BxcuJQ4GLblJf2Sve1axdhWS9t5xxsz+bI0Fe+17kEiFtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j7tGPOA6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cux2VOhp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j7tGPOA6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cux2VOhp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EF381F38E;
	Thu,  8 May 2025 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746727927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Y5qr6rxqsUlzjEZHPpb8pTqr4CoBUfkqn96vcskDN0Q=;
	b=j7tGPOA6viCRnS8fxnJfRPmlW6/z9IHiOltMDChNYs0mRLqlT3y+wN3eOGLhFQaY1F57+B
	FnzX1GBMob84oJS8ocHUGP3uBB9EHV7GlLRjMTHg9fz3r1hdOjpPInj9BPnAi0Z/yyjMmK
	v0HbM1iR/zGXpfJsptmt6rV7wgsG9EY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746727927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Y5qr6rxqsUlzjEZHPpb8pTqr4CoBUfkqn96vcskDN0Q=;
	b=cux2VOhp6bZ48r9xXjvDgryx7fhq7LVoQ01dQ43XB7exRrRqWybWA80MnYMhjbzd3VkOTq
	iCF5MGpI98KKkgDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746727927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Y5qr6rxqsUlzjEZHPpb8pTqr4CoBUfkqn96vcskDN0Q=;
	b=j7tGPOA6viCRnS8fxnJfRPmlW6/z9IHiOltMDChNYs0mRLqlT3y+wN3eOGLhFQaY1F57+B
	FnzX1GBMob84oJS8ocHUGP3uBB9EHV7GlLRjMTHg9fz3r1hdOjpPInj9BPnAi0Z/yyjMmK
	v0HbM1iR/zGXpfJsptmt6rV7wgsG9EY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746727927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Y5qr6rxqsUlzjEZHPpb8pTqr4CoBUfkqn96vcskDN0Q=;
	b=cux2VOhp6bZ48r9xXjvDgryx7fhq7LVoQ01dQ43XB7exRrRqWybWA80MnYMhjbzd3VkOTq
	iCF5MGpI98KKkgDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3385113712;
	Thu,  8 May 2025 18:12:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zMWEBvfzHGj0BgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 08 May 2025 18:12:07 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring/sqpoll: Increase task_work submission batch size
Date: Thu,  8 May 2025 14:12:03 -0400
Message-ID: <20250508181203.3785544-1-krisman@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
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

Our QA team reported a 10%-23%, throughput reduction on an io_uring
sqpoll testcase doing IO to a null_blk, that I traced back to a
reduction of the device submission queue depth utilization. It turns out
that, after commit af5d68f8892f ("io_uring/sqpoll: manage task_work
privately"), we capped the number of task_work entries that can be
completed from a single spin of sqpoll to only 8 entries, before the
sqpoll goes around to (potentially) sleep.  While this cap doesn't drive
the submission side directly, it impacts the completion behavior, which
affects the number of IO queued by fio per sqpoll cycle on the
submission side, and io_uring ends up seeing less ios per sqpoll cycle.
As a result, block layer plugging is less effective, and we see more
time spent inside the block layer in profilings charts, and increased
submission latency measured by fio.

There are other places that have increased overhead once sqpoll sleeps
more often, such as the sqpoll utilization calculation.  But, in this
microbenchmark, those were not representative enough in perf charts, and
their removal didn't yield measurable changes in throughput.  The major
overhead comes from the fact we plug less, and less often, when submitting
to the block layer.

My benchmark is:

fio --ioengine=io_uring --direct=1 --iodepth=128 --runtime=300 --bs=4k \
    --invalidate=1 --time_based  --ramp_time=10 --group_reporting=1 \
    --filename=/dev/nullb0 --name=RandomReads-direct-nullb-sqpoll-4k-1 \
    --rw=randread --numjobs=1 --sqthread_poll

In one machine, tested on top of Linux 6.15-rc1, we have the following
baseline:
  READ: bw=4994MiB/s (5236MB/s), 4994MiB/s-4994MiB/s (5236MB/s-5236MB/s), io=439GiB (471GB), run=90001-90001msec

With this patch:
  READ: bw=5762MiB/s (6042MB/s), 5762MiB/s-5762MiB/s (6042MB/s-6042MB/s), io=506GiB (544GB), run=90001-90001msec

which is a 15% improvement in measured bandwidth.  The average
submission latency is noticeably lowered too.  As measured by
fio:

Baseline:
   lat (usec): min=20, max=241, avg=99.81, stdev=3.38
Patched:
   lat (usec): min=26, max=226, avg=86.48, stdev=4.82

If we look at blktrace, we can also see the plugging behavior is
improved. In the baseline, we end up limited to plugging 8 requests in
the block layer regardless of the device queue depth size, while after
patching we can drive more io, and we manage to utilize the full device
queue.

In the baseline, after a stabilization phase, an ordinary submission
looks like:
  254,0    1    49942     0.016028795  5977  U   N [iou-sqp-5976] 7

After patching, I see consistently more requests per unplug.
  254,0    1     4996     0.001432872  3145  U   N [iou-sqp-3144] 32

Ideally, the cap size would at least be the deep enough to fill the
device queue, but we can't predict that behavior, or assume all IO goes
to a single device, and thus can't guess the ideal batch size.  We also
don't want to let the tw run unbounded, though I'm not sure it would
really be a problem.  Instead, let's just give it a more sensible value
that will allow for more efficient batching.  I've tested with different
cap values, and initially proposed to increase the cap to 1024.  Jens
argued it is too big of a bump and I observed that, with 32, I'm no
longer able to observe this bottleneck in any of my machines.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/sqpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index d037cc68e9d3..03c699493b5a 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -20,7 +20,7 @@
 #include "sqpoll.h"
 
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
-#define IORING_TW_CAP_ENTRIES_VALUE	8
+#define IORING_TW_CAP_ENTRIES_VALUE	32
 
 enum {
 	IO_SQ_THREAD_SHOULD_STOP = 0,
-- 
2.49.0


