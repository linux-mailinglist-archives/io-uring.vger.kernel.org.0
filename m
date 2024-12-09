Return-Path: <io-uring+bounces-5364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8EC9EA306
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55C3B282A5F
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A38B19CC33;
	Mon,  9 Dec 2024 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mc/fg45i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CrGI6lmT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mc/fg45i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CrGI6lmT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E26224884
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787828; cv=none; b=J0sTDR5DruziyFoO8MERm0NsSJXau6lHv2UUm0BlXhLtD2trYAULPAJ710rOKbV1VfpM8xDf1VJH2e2050O8l+qFOrK5BVN+o2y/9UPpa0Df1DhzLHm4LGOrD4lZtTnHnZdwe7mr5harPuB/RY2PZkYTKBqZJLoTiC5U6gYJRck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787828; c=relaxed/simple;
	bh=1jYQPV9ra2EM/MhroklMXILykTrmQpioT10qh6BvbBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvPZ3QOX2NnvCQej67l3y8c1/Wu5Z1CBXi5/BGSuWtLk4zZo+rnBOYZMvhp3YXroxDpuLpk7TTDkcb7qxEwpBU3L6ha9/GsRXJWZclMVkvUny/TG+O2s4i9bGK0/NG+htfDJ3CqUGVn9uY5pO8yiHN4XMrC2WV9jzDIgYOPc3dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mc/fg45i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CrGI6lmT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mc/fg45i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CrGI6lmT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C88DB2116A;
	Mon,  9 Dec 2024 23:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4DQQpBobIu3LkkIaHLFXR6ZvazdJk388nx1TFnhoSI=;
	b=Mc/fg45i5II871hQDDhIyN+HCHLjh8i0hr0RGe1jYT9CPJTjOsPLT5YSNPtzDPc6mqdOOq
	SiMMjMIvlK4UWNF5CHNiSP7L9ZrsGtn3BcwvbiNP3bgXVX14Ol4J2p0VB+WnGULgjBH5hL
	xOuBX5rS8N7u4kCRc+VMjuwGaxOxsVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4DQQpBobIu3LkkIaHLFXR6ZvazdJk388nx1TFnhoSI=;
	b=CrGI6lmT698Nr8yOhbaZNg5gDCigONAIPcOwbE4kTkG9UxQmwSc8gpdzz/CcOHruTSX0lq
	olaqv8OFU0hJLbAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4DQQpBobIu3LkkIaHLFXR6ZvazdJk388nx1TFnhoSI=;
	b=Mc/fg45i5II871hQDDhIyN+HCHLjh8i0hr0RGe1jYT9CPJTjOsPLT5YSNPtzDPc6mqdOOq
	SiMMjMIvlK4UWNF5CHNiSP7L9ZrsGtn3BcwvbiNP3bgXVX14Ol4J2p0VB+WnGULgjBH5hL
	xOuBX5rS8N7u4kCRc+VMjuwGaxOxsVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4DQQpBobIu3LkkIaHLFXR6ZvazdJk388nx1TFnhoSI=;
	b=CrGI6lmT698Nr8yOhbaZNg5gDCigONAIPcOwbE4kTkG9UxQmwSc8gpdzz/CcOHruTSX0lq
	olaqv8OFU0hJLbAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 786B3138A5;
	Mon,  9 Dec 2024 23:43:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qLsSEbCAV2cNHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:44 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 5/9] kernel/fork: Add helper to fork from io_uring
Date: Mon,  9 Dec 2024 18:43:07 -0500
Message-ID: <20241209234316.4132786-6-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>
References: <20241209234316.4132786-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -1.30
X-Spam-Flag: NO

From: Josh Triplett <josh@joshtriplett.org>

Introduce a helper to fork a new process from io_uring.  This is
different from the io_uring io_worker in multiple ways: First, it can
return to userspace following a execve, doesn't have PF_USER_WORKER set,
and doesn't share most process structures with the  the parent.  It
shares the MM though, allowing the helper to do limited io_uring
operations.

The sole use of this is the io_uring OP_CLONE command, which prepares
the ground for EXECVE from io_uring.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Co-developed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/sched/task.h |  1 +
 kernel/fork.c              | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 0f2aeb37bbb0..a76f05a886ad 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -98,6 +98,7 @@ extern pid_t kernel_clone(struct kernel_clone_args *kargs);
 struct task_struct *copy_process(struct pid *pid, int trace, int node,
 				 struct kernel_clone_args *args);
 struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
+struct task_struct *create_io_uring_spawn_task(int (*fn)(void *), void *arg);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, const char *name,
 			    unsigned long flags);
diff --git a/kernel/fork.c b/kernel/fork.c
index 56baa320a720..fa983a0614ce 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2757,6 +2757,25 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 	return copy_process(NULL, 0, node, &args);
 }
 
+/*
+ * This is like kernel_clone(), but shaved down and tailored for io_uring_spawn.
+ * It returns a created task, or an error pointer. The returned task is
+ * inactive, and the caller must fire it up through wake_up_new_task(p).
+ */
+struct task_struct *create_io_uring_spawn_task(int (*fn)(void *), void *arg)
+{
+	unsigned long flags = CLONE_CLEAR_SIGHAND;
+	struct kernel_clone_args args = {
+		.flags		= ((lower_32_bits(flags) | CLONE_VM |
+				    CLONE_UNTRACED) & ~CSIGNAL),
+		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
+		.fn		= fn,
+		.fn_arg		= arg,
+	};
+
+	return copy_process(NULL, 0, NUMA_NO_NODE, &args);
+}
+
 /*
  *  Ok, this is the main fork-routine.
  *
-- 
2.47.0


