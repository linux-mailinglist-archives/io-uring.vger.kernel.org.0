Return-Path: <io-uring+bounces-7380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44695A7AFE9
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 23:04:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1506A1629B4
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 20:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A875025A623;
	Thu,  3 Apr 2025 19:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2GXLyLfH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YNmVbSmG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2GXLyLfH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YNmVbSmG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5651254877
	for <io-uring@vger.kernel.org>; Thu,  3 Apr 2025 19:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710177; cv=none; b=pF1iYcVEZJ+O6mnrGIo2HMXrqSH6B6eoVDvYj+rkTY8I855klHCypCrI26nwHDikzegT4893P9HOnMAhSXAEOyh87n4Xdx1beMIaFzM6whVa0m6a/kIERdHb1DmhJOUcnyNAPeKbZs8uRxRS+LEFAyLAsgvy8N4FWfMG8dVX3IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710177; c=relaxed/simple;
	bh=wQQSroiO+2Anp0hYg0betnfaREmugjBdVGyZEaMaFNY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G16/bT9V+3eU5xDVNZFqKyp9fXGxaAAmlD4pKEmBlh/dky9XR25PLO6mUpdmzVd+aFzwRe1vp2UbyV3VzoGcZ0FaD2VBtSDRNfH1M9VsAuPo4nSgBK7MLzp+UG27y1ABZTzMCOnmAMx7plYsvfU1Pua/kyCLHGLfkUgvhUyzU1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2GXLyLfH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YNmVbSmG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2GXLyLfH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YNmVbSmG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D152F1F385;
	Thu,  3 Apr 2025 19:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743710172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mrXHUxDrzRHebZPZsnHja139LhyFykeGWvO1UgI8n+Y=;
	b=2GXLyLfHoF4oNS+VisH+e+kro9HFBganZX1VgGGHNnJCPWmUyqFVcX42vv2WwWSTYinwZV
	SoF0vIKRSAyrf5jinNXOCUzxanaGafLlqFpUHD+iO23ZjRgcdp3zvpwhra7YqToUS0G8Ot
	tkyDdwNFt1Ua6FZiA7SICqmvSRmDq+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743710172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mrXHUxDrzRHebZPZsnHja139LhyFykeGWvO1UgI8n+Y=;
	b=YNmVbSmGEX/L6kBigbDLOiRoXEZ3nsz54+XXoZoy2krJw4i9ahYXy2Nq2UXl2FbELf/I1i
	LiNupbO2Pw9T0yCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743710172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mrXHUxDrzRHebZPZsnHja139LhyFykeGWvO1UgI8n+Y=;
	b=2GXLyLfHoF4oNS+VisH+e+kro9HFBganZX1VgGGHNnJCPWmUyqFVcX42vv2WwWSTYinwZV
	SoF0vIKRSAyrf5jinNXOCUzxanaGafLlqFpUHD+iO23ZjRgcdp3zvpwhra7YqToUS0G8Ot
	tkyDdwNFt1Ua6FZiA7SICqmvSRmDq+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743710172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mrXHUxDrzRHebZPZsnHja139LhyFykeGWvO1UgI8n+Y=;
	b=YNmVbSmGEX/L6kBigbDLOiRoXEZ3nsz54+XXoZoy2krJw4i9ahYXy2Nq2UXl2FbELf/I1i
	LiNupbO2Pw9T0yCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9823313A2C;
	Thu,  3 Apr 2025 19:56:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yY4OH9zn7mdFNgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 03 Apr 2025 19:56:12 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring/sqpoll: Increase task_work submission batch size
Date: Thu,  3 Apr 2025 15:56:05 -0400
Message-ID: <20250403195605.1221203-1-krisman@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

Our QA team reported a 10%-23% throughput reduction on an io_uring
sqpoll testcase that I traced back to a reduction of the device
submission queue depth when doing io over an sqpoll. After commit
af5d68f8892f ("io_uring/sqpoll: manage task_work privately"), we capped
the number of tw entries that can be executed from a single spin of
sqpoll to only 8 entries, before the sqpoll goes around to try to sleep.
My understanding is that this starves the device, as seen in device
utilization, mostly because it reduced the opportunity for plugging in the
block layer.

A simple usecase that showcases the issue is using sqpoll against a
nullblk:

fio --ioengine=io_uring --direct=1 --iodepth=128 --runtime=300 --bs=4k \
    --invalidate=1 --time_based  --ramp_time=10 --group_reporting=1 \
    --filename=/dev/nullb0 --name=RandomReads-direct-nullb-sqpoll-4k-1 \
    --rw=randread --numjobs=1 --sqthread_poll

One QA test machine yielded, with the above command:

SLE Kernel predating af5d68f8892f:
 READ: bw=9839MiB/s (10.3GB/s), 9839MiB/s-9839MiB/s (10.3GB/s-10.3GB/s), io=2883GiB (3095GB), run=300001-300001msec

SLE kernel after af5d68f8892f:
 READ: bw=8288MiB/s (8691MB/s), 8288MiB/s-8288MiB/s (8691MB/s-8691MB/s), io=2428GiB (2607GB), run=300001-300001msec

Ideally, the tw cap size would at least be the deep enough to fill the
device queue (assuming all uring commands are against only one device),
but we can't predict that behavior and thus can't guess the batch size.
We also don't want to let the tw run unbounded, though I'm not sure it
is really a problem.  Instead, let's just give it a more sensible value that
will allow for more efficient batching.

With this patch, my test machine (not the same as above) yielded a
consistent 10% throughput increase when doing randreads on nullb.  Our QE
team also reported it solved the regression on all machines they tested.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/sqpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index d037cc68e9d3..e58e4d2b3bde 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -20,7 +20,7 @@
 #include "sqpoll.h"
 
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
-#define IORING_TW_CAP_ENTRIES_VALUE	8
+#define IORING_TW_CAP_ENTRIES_VALUE	1024
 
 enum {
 	IO_SQ_THREAD_SHOULD_STOP = 0,
-- 
2.49.0


