Return-Path: <io-uring+bounces-1567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9778A60B7
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 04:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C84241F21A9D
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 02:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD48BA42;
	Tue, 16 Apr 2024 02:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DOaVh4wq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LgnDUmwN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DOaVh4wq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LgnDUmwN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B5CD512
	for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 02:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713233470; cv=none; b=tszb6u2pD2Rhsw0HZASyj8zBx9m6GP0GkSZxMyQXiOOGbe4DPIUL7U/ZrH628zHUO970K5ShrNJtCTY1pUIu3InErTixxivxUDelJqTvbjNzVILebD7EZY0my6JzU/HpKVPwLWi5mJgBVpWDp0nCraCmcknmpT9DqxfthMTPBjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713233470; c=relaxed/simple;
	bh=cv/MfRFsnVBzNGwAQ3AqkJXd3YBpriey2P1ihTRqKs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOGuSDQtcns5OYXv9ofrEWiX8sMrbePMd/A+YOES2QQEnQYeoWRJ2l5gDLPd2xsDQJagyQ2+/uFzXs3ckWM8pOg7X+mCKcFIu8Q6Fdc+YdynuDQ12CovheOXxQQ3LDNXCSzoupukZhq32xEfzUyalOcsbvji4sYALbuURAQGH3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DOaVh4wq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LgnDUmwN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DOaVh4wq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LgnDUmwN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F37F320486;
	Tue, 16 Apr 2024 02:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713233466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VaSLhlMhaIJs0ScQspEdDBLzE3aR79/9pWxfgBmvJXA=;
	b=DOaVh4wq3UJ988+Mic0bx2Ro/ucFL1qcCSiikSucEjaG3+CcM0Ugnna4q+XJF5OBiqkXH4
	f5qB0g3RJc5vD0mIA1tRghELV96h6yM5KekoU7pS8mnxlMPmFDE+58Zg2Dt4yBBlH16yQv
	Qgt9AWhKKfu3S34exnbxCegOonnH9+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713233466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VaSLhlMhaIJs0ScQspEdDBLzE3aR79/9pWxfgBmvJXA=;
	b=LgnDUmwNZtTbhyXGbgwSNGUQfquKwlreS7f4+7wr8lsdeF14DNV8UNZpMJAk07ksSBSYij
	tqYGArNDmR62pBBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DOaVh4wq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LgnDUmwN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713233466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VaSLhlMhaIJs0ScQspEdDBLzE3aR79/9pWxfgBmvJXA=;
	b=DOaVh4wq3UJ988+Mic0bx2Ro/ucFL1qcCSiikSucEjaG3+CcM0Ugnna4q+XJF5OBiqkXH4
	f5qB0g3RJc5vD0mIA1tRghELV96h6yM5KekoU7pS8mnxlMPmFDE+58Zg2Dt4yBBlH16yQv
	Qgt9AWhKKfu3S34exnbxCegOonnH9+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713233466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VaSLhlMhaIJs0ScQspEdDBLzE3aR79/9pWxfgBmvJXA=;
	b=LgnDUmwNZtTbhyXGbgwSNGUQfquKwlreS7f4+7wr8lsdeF14DNV8UNZpMJAk07ksSBSYij
	tqYGArNDmR62pBBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C89113931;
	Tue, 16 Apr 2024 02:11:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bc71GTneHWbDeAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 16 Apr 2024 02:11:05 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 1/2] io-wq: write next_work before dropping acct_lock
Date: Mon, 15 Apr 2024 22:10:53 -0400
Message-ID: <20240416021054.3940-2-krisman@suse.de>
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
X-Spamd-Result: default: False [-0.17 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	BAYES_HAM(-0.16)[69.55%];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: F37F320486
X-Spam-Flag: NO
X-Spam-Score: -0.17
X-Spamd-Bar: /

Commit 361aee450c6e ("io-wq: add intermediate work step between pending
list and active work") closed a race between a cancellation and the work
being removed from the wq for execution.  To ensure the request is
always reachable by the cancellation, we need to move it within the wq
lock, which also synchronizes the cancellation.  But commit
42abc95f05bf ("io-wq: decouple work_list protection from the big
wqe->lock") replaced the wq lock here and accidentally reintroduced the
race by releasing the acct_lock too early.

In other words:

        worker                |     cancellation
work = io_get_next_work()     |
raw_spin_unlock(&acct->lock); |
			      |
                              | io_acct_cancel_pending_work
                              | io_wq_worker_cancel()
worker->next_work = work

Using acct_lock is still enough since we synchronize on it on
io_acct_cancel_pending_work.

Fixes: 42abc95f05bf ("io-wq: decouple work_list protection from the big wqe->lock")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io-wq.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 522196dfb0ff..318ed067dbf6 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -564,10 +564,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		 * clear the stalled flag.
 		 */
 		work = io_get_next_work(acct, worker);
-		raw_spin_unlock(&acct->lock);
 		if (work) {
-			__io_worker_busy(wq, worker);
-
 			/*
 			 * Make sure cancelation can find this, even before
 			 * it becomes the active work. That avoids a window
@@ -578,9 +575,15 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 			raw_spin_lock(&worker->lock);
 			worker->next_work = work;
 			raw_spin_unlock(&worker->lock);
-		} else {
-			break;
 		}
+
+		raw_spin_unlock(&acct->lock);
+
+		if (!work)
+			break;
+
+		__io_worker_busy(wq, worker);
+
 		io_assign_current_work(worker, work);
 		__set_current_state(TASK_RUNNING);
 
-- 
2.44.0


