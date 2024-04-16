Return-Path: <io-uring+bounces-1568-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1404C8A60B8
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 04:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 457971C20C6F
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 02:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ABDBD512;
	Tue, 16 Apr 2024 02:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZnfO4Zcx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9YtJHmam";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZnfO4Zcx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9YtJHmam"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1FDBA42
	for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 02:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713233475; cv=none; b=KiibMUuMiwDzuM/QaNZ5O0BsKyie1KD4vJOX0JyutiM5cJNJfmLvgL9UjU+mJelmbyGbwDVmnLBnvTxVqjq1Vu/ksP4FMVcJy+bHMyeUU4a9li7MQCoxuKjBLB5lLqet596cYzZqfZYlHGYuB1GZ2owWAH6PIydF18LRo8DeSsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713233475; c=relaxed/simple;
	bh=octNNAG+ro+uzmGugssjZE9qzOAnd6mYmMs/uMxBSRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fD3RX3Yocs6XzdPHb4VWck+xL+qlTdPoqXPh9JYJsxbAZwqNvyx0mlwGDDuVHqKIBxmmZZAuIiZB1SweSLr9M4PMijio0uHgdg4u2iQoWvs3ryRJ7jQCBIKXcJa9Q5J5xup3P6nXGc9aomeE5+3Xjg4ZFdXRFchhnq8eJ0f1q84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZnfO4Zcx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9YtJHmam; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZnfO4Zcx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9YtJHmam; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DA2233DDA;
	Tue, 16 Apr 2024 02:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713233472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey3OUeYkohPOlghPl0r3kMV8MnLlnHUwhfDp1j1bBN0=;
	b=ZnfO4Zcxjrg99roVjgOVIDhj+Gy+8ClGv8Wq9sTt0gCWMN/QQ/yzlBk88K95L4ufhMgkkt
	qnj8LrVKYR3yVM/ygZoyhp/HORRGmF9umyQ5tHmd0EvFDprs0NsmVxK4Qp7GrMkKZBXQlX
	OsSyvnUhSl5WumxVhGB5s0O2cxEeO+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713233472;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey3OUeYkohPOlghPl0r3kMV8MnLlnHUwhfDp1j1bBN0=;
	b=9YtJHmamSJO+xseIEZ4CbYymZpkxtpAohgu8UdNfDM/07WRo7EXkqRbaeUhqdD6DX89IqA
	y3xHYcjPgWTf/FBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZnfO4Zcx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9YtJHmam
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713233472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey3OUeYkohPOlghPl0r3kMV8MnLlnHUwhfDp1j1bBN0=;
	b=ZnfO4Zcxjrg99roVjgOVIDhj+Gy+8ClGv8Wq9sTt0gCWMN/QQ/yzlBk88K95L4ufhMgkkt
	qnj8LrVKYR3yVM/ygZoyhp/HORRGmF9umyQ5tHmd0EvFDprs0NsmVxK4Qp7GrMkKZBXQlX
	OsSyvnUhSl5WumxVhGB5s0O2cxEeO+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713233472;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey3OUeYkohPOlghPl0r3kMV8MnLlnHUwhfDp1j1bBN0=;
	b=9YtJHmamSJO+xseIEZ4CbYymZpkxtpAohgu8UdNfDM/07WRo7EXkqRbaeUhqdD6DX89IqA
	y3xHYcjPgWTf/FBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8E5A13931;
	Tue, 16 Apr 2024 02:11:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BefALj/eHWbJeAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 16 Apr 2024 02:11:11 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 2/2] io-wq: Drop intermediate step between pending list and active work
Date: Mon, 15 Apr 2024 22:10:54 -0400
Message-ID: <20240416021054.3940-3-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416021054.3940-1-krisman@suse.de>
References: <20240416021054.3940-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-0.83 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	BAYES_HAM(-0.82)[85.00%];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 1DA2233DDA
X-Spam-Flag: NO
X-Spam-Score: -0.83
X-Spamd-Bar: /

next_work is only used to make the work visible for
cancellation. Instead, we can just directly write to cur_work before
dropping the acct_lock and avoid the extra hop.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io-wq.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 318ed067dbf6..d7fc6f6d4477 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -51,7 +51,6 @@ struct io_worker {
 	struct io_wq *wq;
 
 	struct io_wq_work *cur_work;
-	struct io_wq_work *next_work;
 	raw_spinlock_t lock;
 
 	struct completion ref_done;
@@ -539,7 +538,6 @@ static void io_assign_current_work(struct io_worker *worker,
 
 	raw_spin_lock(&worker->lock);
 	worker->cur_work = work;
-	worker->next_work = NULL;
 	raw_spin_unlock(&worker->lock);
 }
 
@@ -573,7 +571,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 			 * current work item for this worker.
 			 */
 			raw_spin_lock(&worker->lock);
-			worker->next_work = work;
+			worker->cur_work = work;
 			raw_spin_unlock(&worker->lock);
 		}
 
@@ -1008,8 +1006,7 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	 * may dereference the passed in work.
 	 */
 	raw_spin_lock(&worker->lock);
-	if (__io_wq_worker_cancel(worker, match, worker->cur_work) ||
-	    __io_wq_worker_cancel(worker, match, worker->next_work))
+	if (__io_wq_worker_cancel(worker, match, worker->cur_work))
 		match->nr_running++;
 	raw_spin_unlock(&worker->lock);
 
-- 
2.44.0


