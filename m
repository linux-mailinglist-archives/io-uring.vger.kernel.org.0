Return-Path: <io-uring+bounces-5363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 797039EA305
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EE531880636
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74DCE224899;
	Mon,  9 Dec 2024 23:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rpQ8OQq4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QPmhPkeh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rpQ8OQq4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QPmhPkeh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C112F19CC33
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787827; cv=none; b=GiSiGKOoVcRLdhkGlEvswMdHUv/jCIVsv6ISAWSMrrJY1KFWUbIPkXsntdf76D3Iw4BbNBGrIC8VebjkbNQSBcdh336TzxNSdaY2xJyUM3Q6HAzWnq/LITmKc1+TGYaPiJyJQwitv2q7tzWNIlIQXnsnX1EKMUAgenswtjohPYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787827; c=relaxed/simple;
	bh=yNCefphhrCJUgjWR1/w4gUZj4xy6wrr7e65axKubdtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR4lAnHUuTn4BsgJm9LZ4k7qyYrMtCISkY3/iqJt/XqQWbzyV+djw062Efuf/b7KDgVuAHQHT6X3aptvaiPokwJ0ayA5KGl0l2l6Rr/c4LKVy5aBIcIuiG2KnwCUJpChdYNROLFDvmdPnjmalDOLg5CUBt+WnVWpIlT/FlfQVmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rpQ8OQq4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QPmhPkeh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rpQ8OQq4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QPmhPkeh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 40AB321169;
	Mon,  9 Dec 2024 23:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5NZRMfY90YeRXV2eif4+vXPKFkifHojq7doQsTfdpE=;
	b=rpQ8OQq4Cc3umeYJLpRc6IRcuX8sWtFckbaFRpWW7YYPwT44NUQzFXsIF2Y+iEEL2fIdn/
	s75YlRypp/MtFT9+7SACeSG8nRh8rdX+n3f+8eVykk5m8B39nGj78sFnSoaSqqmPzsQYE7
	Q86zELYRNlsiuTDnZrpk7shvwPfn5+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5NZRMfY90YeRXV2eif4+vXPKFkifHojq7doQsTfdpE=;
	b=QPmhPkehg6EU4A+XkcmzvxvbbR4Ot7g4vLGrDSiRz2yH83sCwuAEkqzzNlGKj/idqhQRbK
	7JfonM12a+qPOyBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5NZRMfY90YeRXV2eif4+vXPKFkifHojq7doQsTfdpE=;
	b=rpQ8OQq4Cc3umeYJLpRc6IRcuX8sWtFckbaFRpWW7YYPwT44NUQzFXsIF2Y+iEEL2fIdn/
	s75YlRypp/MtFT9+7SACeSG8nRh8rdX+n3f+8eVykk5m8B39nGj78sFnSoaSqqmPzsQYE7
	Q86zELYRNlsiuTDnZrpk7shvwPfn5+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5NZRMfY90YeRXV2eif4+vXPKFkifHojq7doQsTfdpE=;
	b=QPmhPkehg6EU4A+XkcmzvxvbbR4Ot7g4vLGrDSiRz2yH83sCwuAEkqzzNlGKj/idqhQRbK
	7JfonM12a+qPOyBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0649E138A5;
	Mon,  9 Dec 2024 23:43:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dvvCNqmAV2cHHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:37 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 4/9] fs/exec: Expose do_execveat symbol
Date: Mon,  9 Dec 2024 18:43:06 -0500
Message-ID: <20241209234316.4132786-5-krisman@suse.de>
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

In order to allow it to be called by io_uring code, expose do_execveat in
the header file.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 fs/exec.c               | 2 +-
 include/linux/binfmts.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 98cb7ba9983c..1a03ae5b9941 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2023,7 +2023,7 @@ static int do_execve(struct filename *filename,
 	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
 }
 
-static int do_execveat(int fd, struct filename *filename,
+int do_execveat(int fd, struct filename *filename,
 		const char __user *const __user *__argv,
 		const char __user *const __user *__envp,
 		int flags)
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index e6c00e860951..baec14dfb7ca 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -141,4 +141,9 @@ extern ssize_t read_code(struct file *, unsigned long, loff_t, size_t);
 int kernel_execve(const char *filename,
 		  const char *const *argv, const char *const *envp);
 
+int do_execveat(int dfd, struct filename *filename,
+		const char __user *const __user *__argv,
+		const char __user *const __user *__envp,
+		int flags);
+
 #endif /* _LINUX_BINFMTS_H */
-- 
2.47.0


