Return-Path: <io-uring+bounces-1379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E606897584
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 18:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE0BC28D665
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 16:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB881B7F4;
	Wed,  3 Apr 2024 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LClCSBoS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ynp2GrLH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B629152DE9
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712162664; cv=none; b=Z5YdrYg8TqFpo30RCe00cqyv11F/fcZlCmAUt88Xxf0ZUXtn9jlUJdY/KnIgr9NmdpSsqjY/mwjsAPTM4wXWz/UbRvDV1ZisSJ8ZdPq1oWVyaDLj80rascB56EOZOxoRIn05QkpZUqdLPFYv/48U8erW225elXA09YWDvZF17Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712162664; c=relaxed/simple;
	bh=xyfuxe1wtGgGSjszleJ8deHJkPuiDmsVI0Ri2ax99QA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HhMmWrKvbKh0A5ON3WEzcCsdri5lCJab8RVFp5QCnMcOAareDESQPvuhEW/3VCqeuqGzGvnn29WABPJRjTpSywllK+hXZMdVQrZeY385Jh84LqkEQu8kJbaNwuChib7cdk0ZDGewoiZRcoFq2h9j53Esja+qltGkuiLd94+o4mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LClCSBoS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ynp2GrLH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B73C65CEF7;
	Wed,  3 Apr 2024 16:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712162660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xk8Wu6uEZ3YYENgvsJSF+DsMWk8tyAWYT1Ri+MSaYEA=;
	b=LClCSBoSVBBMlD4bWHz8qTuR/v0k53nxjgFQLDzklH4M1l8SggE+tCurn8Pn54OgmhL2AA
	JL/YjfaznRwkEpTk0HkRz1zMleVVNGfERP2mlzSOYaACNIaZr4tgVRuX0XeDbsJfcLUi0y
	wOXILegBX0O9vRocEchBe4UuFDRycKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712162660;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xk8Wu6uEZ3YYENgvsJSF+DsMWk8tyAWYT1Ri+MSaYEA=;
	b=Ynp2GrLHROUoDA8sTcSW0J5hspTQIuu5g1ogJuWqPiC2cm8DGDBk7wIh3/25mgutF0qspz
	XY6/UeY5fA1b7pCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 759E813357;
	Wed,  3 Apr 2024 16:44:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id kUycFmSHDWbbDQAAn2gu4w
	(envelope-from <krisman@suse.de>); Wed, 03 Apr 2024 16:44:20 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 0/2] manpage improvements
Date: Wed,  3 Apr 2024 12:44:11 -0400
Message-ID: <20240403164413.16398-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 5.38
X-Spam-Flag: NO
X-Spamd-Bar: +++++
X-Spamd-Result: default: False [5.38 / 50.00];
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
	 NEURAL_HAM_LONG(-1.00)[-0.998];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_IN_DNSWL_HI(-0.50)[2a07:de40:b281:106:10:150:64:167:received];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.01)[48.58%]
X-Spam-Level: *****
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B73C65CEF7

Just sweeping through github issues.

Gabriel Krisman Bertazi (2):
  man/io_uring_enter.2:  Move poll update behavior to poll remove
  man/io_uring_setup.2: Improve IORING_SETUP_REGISTERED_FD_ONLY
    documentation

 man/io_uring_enter.2 | 48 ++++++++++++++++++--------------------------
 man/io_uring_setup.2 |  7 +++++++
 2 files changed, 27 insertions(+), 28 deletions(-)

-- 
2.44.0


