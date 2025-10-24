Return-Path: <io-uring+bounces-10193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F0DC0715E
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 17:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D43B93A2282
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30C1314A84;
	Fri, 24 Oct 2025 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lAH+ebxC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Sa8rIuy4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YrcXVQvI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4zQSAPzj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD923D7E6
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761321110; cv=none; b=h9BgvAwCfANE5m3eJ62h2C3K4+/QBeI+h/7hsXkZTZHd1X5o0I7BYbK9gj3Bbv3JLEZIpdsMsxqKZQKYiJN+grDCgq/IodgegG1zBj7eta7DlPfEv3o2hNdbj/9gnAsPbnnImsSsPgdbwZKWiJ6JDiWqiAfAAVEsJFOFBEPcBco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761321110; c=relaxed/simple;
	bh=S9OemknrFJyyVAIq/SMHNKDuhmj0mbm5ITqgK9Tb2UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TdAWS5rfYohsYQMIhNryzGv1dwNwUajeidOl0Mi47V0HJwP9QhOKNX+AOSuF1f4pquFVr2YiQuMV7VHgIcnmtk4NikJy6/tuAf82lCwht+z57Y7m+APutSf4LxifvAPDZzqlvXKw59T+nGGpGbzBtr4I3STM28hk8WF8EzCjwRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lAH+ebxC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Sa8rIuy4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YrcXVQvI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4zQSAPzj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E9BDD1F38D;
	Fri, 24 Oct 2025 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1QdUZVNjF+uVlEIahV2sN0xQiZm8bzzhlQywWoio+gc=;
	b=lAH+ebxCfYIZ3hU9FJQUU4zS/PmHnpV8adK8duUwWTDEYOmE4CMfzzsRpuyEuwksyjzoHj
	zVv39hCR22nae/js8Iaj1Er2xpbC0hjJIx2ThnBGJHjb5DlzuaWf9Z4RAhvUXkv+Chi4ux
	6276Xhb50HX/k2srVET66KbQcovMfXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321107;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1QdUZVNjF+uVlEIahV2sN0xQiZm8bzzhlQywWoio+gc=;
	b=Sa8rIuy4FZbHl4w3qxAyRPRdjTk0wh1RRUDq5PvjsNlk6/30Vu1V6U7VaejBV2tJts5kL/
	QCnF0munh9Mv3fDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YrcXVQvI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4zQSAPzj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1QdUZVNjF+uVlEIahV2sN0xQiZm8bzzhlQywWoio+gc=;
	b=YrcXVQvI8sV1pR6jkXJfcvSWkEZlxpXWrKqAVR/tk/QL0ENkCQi6JxG1dqCuLLTDlbWUIs
	3isLr2oxM/t6CN4slcJewkeE0tcOexrwmXQUsPXVi3hofPNkED0vj3b4U3tzDO/Ry6wxOT
	MyLIIiB2eDUIJYwztnM12+KTOsZoEmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321106;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1QdUZVNjF+uVlEIahV2sN0xQiZm8bzzhlQywWoio+gc=;
	b=4zQSAPzjQsb+RzICwORuv3gGeUdeOL0dAz6a9OgyKb/4+yMkKK3AC1Ci+pBf1LIsVqB6PU
	JX6IE+ksR3OO1eCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95F93132C2;
	Fri, 24 Oct 2025 15:51:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B2CYF5Kg+2gIFAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 24 Oct 2025 15:51:46 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 0/4] liburing: getsockname support
Date: Fri, 24 Oct 2025 11:51:31 -0400
Message-ID: <20251024155135.798465-1-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: E9BDD1F38D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01

This is the library counterpart for the kernel support.  Also available
at:

https://github.com/krisman/liburing -b socket

Gabriel Krisman Bertazi (4):
  liburing: Introduce getsockname operation
  test/bind-listen.t: Use ephemeral port
  bind-listen.t: Add tests for getsockname
  man/io_uring_prep_getsockname.3: Add man page

 man/io_uring_prep_getsockname.3 |  76 ++++++++++++++++++
 src/include/liburing.h          |  12 +++
 src/include/liburing/io_uring.h |   1 +
 test/bind-listen.c              | 137 +++++++++++++++++++++++++++++---
 4 files changed, 214 insertions(+), 12 deletions(-)
 create mode 100644 man/io_uring_prep_getsockname.3

-- 
2.51.0


