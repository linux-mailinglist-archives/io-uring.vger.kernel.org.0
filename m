Return-Path: <io-uring+bounces-5362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F479EA304
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:43:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7A0C166750
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6428119F489;
	Mon,  9 Dec 2024 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OjxvoOXz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5jjwGkpz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OjxvoOXz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5jjwGkpz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9144319CC33
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787825; cv=none; b=PgHW+ylBVFUMd2UB+J/MxdMmk1IfNZwSiUsyqTikbsTHo9vn1Vi9k6OEGmdVP9lvHLvcohKbzq+cymdAiddhUv3xW/0scIK4fiXcLf/hJo/f30ckhN9RJbZufAXgLonJqlUu2KLX5MPeRdSPmNn5Ru1wJTyqrCdTyIGd+No3tuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787825; c=relaxed/simple;
	bh=7WiAwSMqn6f2YhAW5KClFtBpFySRM5IPd0y9KRJ+Bl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7DQzbHaEdgvdEHY/BF9jpfOX0zvRy2k+JeEHGYU+cpuXnMozoIwqMp5H/XGtqjPpI9abg4Q5vLGyCPDEkPWCkQrvaXEt7pkf6UB0wmKuMsquo7oqHzYc7OjqM7pgOvUBe+XMN1wOxtx1RFIeb/E9/9ZyWq0LDadwj+HDpLDox4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OjxvoOXz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5jjwGkpz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OjxvoOXz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5jjwGkpz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3600821167;
	Mon,  9 Dec 2024 23:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmwiFgfEKmj5mgLbJsV7RDzLy8r1bxL8DEoPgRwrGNM=;
	b=OjxvoOXzLDUjaXRza2epQx3dU6N7/BPuYYiQwVJY4Z2/tGcKqxV7K0r8CzGse6TJXAGIjk
	N8684bJC+71fkaAr6k+yiMn3SB5M41R2kag5vqhRo1va+jmo/qieUo+jVLEY03ESA2d4F0
	crdkrjysuom2agFj5QCN66nUwBta6vE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmwiFgfEKmj5mgLbJsV7RDzLy8r1bxL8DEoPgRwrGNM=;
	b=5jjwGkpzuiRU7iicJ8fleqMLo47KDKBpw8LGxYovv6Mg0CIqRHf5UwfTpPtk5XmAkCVqv1
	HihIXc1r8jTrbLCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmwiFgfEKmj5mgLbJsV7RDzLy8r1bxL8DEoPgRwrGNM=;
	b=OjxvoOXzLDUjaXRza2epQx3dU6N7/BPuYYiQwVJY4Z2/tGcKqxV7K0r8CzGse6TJXAGIjk
	N8684bJC+71fkaAr6k+yiMn3SB5M41R2kag5vqhRo1va+jmo/qieUo+jVLEY03ESA2d4F0
	crdkrjysuom2agFj5QCN66nUwBta6vE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmwiFgfEKmj5mgLbJsV7RDzLy8r1bxL8DEoPgRwrGNM=;
	b=5jjwGkpzuiRU7iicJ8fleqMLo47KDKBpw8LGxYovv6Mg0CIqRHf5UwfTpPtk5XmAkCVqv1
	HihIXc1r8jTrbLCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1946138A5;
	Mon,  9 Dec 2024 23:43:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MALALqeAV2cAHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:35 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 3/9] kernel/fork: Don't inherit PF_USER_WORKER from parent
Date: Mon,  9 Dec 2024 18:43:05 -0500
Message-ID: <20241209234316.4132786-4-krisman@suse.de>
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
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -1.30
X-Spam-Flag: NO

Clear the PF_USER_WORKER bit of new tasks, instead of inheriting it from
the parent.  This allows PF_USER_WORKER tasks to fork regular tasks.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 kernel/fork.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1450b461d196..56baa320a720 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2228,6 +2228,8 @@ __latent_entropy struct task_struct *copy_process(
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
 		p->flags |= PF_KTHREAD;
+
+	p->flags &= ~PF_USER_WORKER;
 	if (args->user_worker) {
 		/*
 		 * Mark us a user worker, and block any signal that isn't
-- 
2.47.0


