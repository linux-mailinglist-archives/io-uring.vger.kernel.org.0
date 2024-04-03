Return-Path: <io-uring+bounces-1381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D24889758B
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 18:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FFF0B26E79
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 16:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C8214C58A;
	Wed,  3 Apr 2024 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kmpw9VEc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cAgMgdzH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37251152177
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712162676; cv=none; b=Xjljk1fdYxkx9gZGpHfkpPIVYFPdywStpzWbcpc2Ic6NIMmg3VXXMmR+gxYxCSvxCBuEPquHHYAiqkZBH9B8kAxlxVvtNvCRKnUSs7jvudA/W4kwoxMlCKIeDA2gUNF/tPWpFvQd/e0F1sjyot2Fb99JQp+eiHpYslwrAufpdVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712162676; c=relaxed/simple;
	bh=mf6WDk+p+Q+bkZEOrmdMRBOd2SMl94sVv6L3v/RukDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHqiS2aGRvFx27J90/0elt37EEMyqfYjulUMe9Vz6Rk2bwpwcsVlxJ/7C0EwB/1LlCvykEJSyXfFDQ8bI3+sH1CDw4hmCiB/+kzsDVw+sPCAoimP1PbAm1rbC46SdM5icqzg571Iiv9Tzd7QX5QsBdvDm+J7j3oeaYxUK4yQYek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kmpw9VEc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cAgMgdzH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6840B372CB;
	Wed,  3 Apr 2024 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712162673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rnlIMOgyjedxbuGtf6UojFR/wNZLP3anfAI92FG4OKY=;
	b=kmpw9VEcxzrLo10XLDic0zEFeT632FZOSVH7Jt4A55VFXP9vpZfw6a+7spF13Z8Bm+qKNm
	APFImvfBrZm+y4+aGMnwLTA+qv3IdcqqlV9Kw5i8wchm+FDcdZDvm+FluGKbiDQeSrzHRe
	xzo3Lx6RxowgjF63JbIZMGswtUVnvNo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712162673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rnlIMOgyjedxbuGtf6UojFR/wNZLP3anfAI92FG4OKY=;
	b=cAgMgdzHhSiiTtPOO6rVwKDCKBBypo8OyEf8fGpT5Y7muVUyJG4Zb1Ur7doCgFL8ZJ1phT
	9Aswr4idQbKZvZBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A20C13357;
	Wed,  3 Apr 2024 16:44:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id JkBNAHGHDWboDQAAn2gu4w
	(envelope-from <krisman@suse.de>); Wed, 03 Apr 2024 16:44:33 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 2/2] man/io_uring_setup.2: Improve IORING_SETUP_REGISTERED_FD_ONLY documentation
Date: Wed,  3 Apr 2024 12:44:13 -0400
Message-ID: <20240403164413.16398-3-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403164413.16398-1-krisman@suse.de>
References: <20240403164413.16398-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 5.31
X-Spam-Flag: NO
X-Spamd-Bar: +++++
X-Spamd-Result: default: False [5.31 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 TO_DN_SOME(0.00)[];
	 DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_IN_DNSWL_HI(-0.50)[2a07:de40:b281:106:10:150:64:167:received];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.08)[63.85%]
X-Spam-Level: *****
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6840B372CB

Document that IORING_SETUP_REGISTERED_FD_ONLY depends on
IORING_SETUP_NO_MMAP being set.

Closes: https://github.com/axboe/liburing/issues/1087
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 man/io_uring_setup.2 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index f65c1f2..888e82b 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -325,6 +325,9 @@ file descriptor. The caller will need to use
 .B IORING_REGISTER_USE_REGISTERED_RING
 when calling
 .BR io_uring_register (2).
+This flag only makes sense when used alongside with
+.B IORING_SETUP_NO_MMAP,
+which also needs to be set.
 Available since 6.5.
 
 .TP
@@ -690,6 +693,10 @@ was not, or
 was specified, but
 .I io_uring_params.cq_entries
 was invalid.
+.B IORING_SETUP_REGISTERED_FD_ONLY
+was specified, but
+.B IORING_SETUP_NO_MMAP
+was not.
 .TP
 .B EMFILE
 The per-process limit on the number of open file descriptors has been
-- 
2.44.0


