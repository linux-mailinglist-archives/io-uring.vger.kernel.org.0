Return-Path: <io-uring+bounces-2266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9693290E185
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 04:06:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF44B1C22814
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 02:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0ECF51B;
	Wed, 19 Jun 2024 02:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e3RHyTlw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xPkKGoUv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FDfVsnSp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jCB1ezqR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D332CA40
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 02:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718762805; cv=none; b=YcG33XIefzlLN6xaSQj9viyxhiGgp4rVM61vNDM5eCF/ii8K+W3RQUtNFZ/0ybw/8c8+fXDCfIjvNZ4ZGpsv/pXF4WRy9bgg0u+EFF9zgNVSB91QK5YUnDs1NAMVEViiGxu/rNuF8lhWKEUv/7YeMScmW8N0yV3MeKH86e36cBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718762805; c=relaxed/simple;
	bh=o4HqAZPzczMh59IJz77XoJm7PSdxWj2yYn75kUrEur8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kH9AXrahhSUem9hozyKceIP0/Cd7MOZPCjYgliqfRi/QsI18iiTS3z0Vfb6gbWs6E8Z0Y+DaRQiGUWzC8NgIG025oJty9L2uKSBn4q2pOKPqLKkLeJbnZGlAihuI6oQK6rNpEzQdmkTynyPTt29u3ySQAN2Np0SR1UP3os8LRZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e3RHyTlw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xPkKGoUv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FDfVsnSp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jCB1ezqR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EEB761F7B0;
	Wed, 19 Jun 2024 02:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718762802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hKtaoBU+L32HhmXj5EEXm8XaqoQoKrrwsHq7dBzGL+4=;
	b=e3RHyTlwLWWbkj9GEvPIL7NkEuYdf2HOIPHXCNMiQx5iD2vC9ktdHIar9vJTnDyck3B20N
	F0vun/nzW9zvdE/Qvy0ju7d7v5wq1TQcEYxfXM4kL2TPJaMCQbgx0o5b2GEFXkCcLFdg1D
	9P0MaVYGhbqVilAHra9gukwrHZ3TOUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718762802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hKtaoBU+L32HhmXj5EEXm8XaqoQoKrrwsHq7dBzGL+4=;
	b=xPkKGoUvbV5izAouMjT2jEICNrm8e9OvnB+uTRUM0R+QAkarKmFhUJrKkRVsJS0u3CmxKE
	U3XzXCFU0Tcbe5Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FDfVsnSp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jCB1ezqR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718762801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hKtaoBU+L32HhmXj5EEXm8XaqoQoKrrwsHq7dBzGL+4=;
	b=FDfVsnSpB+MHLoN2BJWSrotjLs6SYmrytXtAWkPnFi4CO0CDsZER70HsS+CdN1VCNCB039
	HkUxOapD/MXuQ8eozYt0w1jwZgCEQyoFG4px+YH3/MBVBFaA974oAsbHXElbmyLyJkWPPA
	KVoffgtjvH7aEP1/Z63x0DCxTNzYEPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718762801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hKtaoBU+L32HhmXj5EEXm8XaqoQoKrrwsHq7dBzGL+4=;
	b=jCB1ezqRVHiIbJRGoYcuq2A5YQiLOhXINF1td7cZUA2DwykLLC2I2fJASIS/XAYGni1FnA
	4MQSE5KY9xmSPNBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B481113AAA;
	Wed, 19 Jun 2024 02:06:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NOyPJTE9cmYtNgAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 19 Jun 2024 02:06:41 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 3/3] io_uring: Don't read userspace data in io_probe
Date: Tue, 18 Jun 2024 22:06:20 -0400
Message-ID: <20240619020620.5301-4-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619020620.5301-1-krisman@suse.de>
References: <20240619020620.5301-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EEB761F7B0
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

We don't need to read the userspace buffer, and the kernel side is
expected to write over it anyway.  Perhaps this was meant to allow
expansion of the interface for future parameters?  If we ever need to do
it, perhaps it should be done as a new io_uring opcode.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/register.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 8409fc80c1cb..a60eba22141a 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -37,7 +37,7 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 {
 	struct io_uring_probe *p;
 	size_t size;
-	int i, ret;
+	int i, ret = 0;
 
 	if (nr_args > IORING_OP_LAST)
 		nr_args = IORING_OP_LAST;
@@ -47,13 +47,6 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 	if (!p)
 		return -ENOMEM;
 
-	ret = -EFAULT;
-	if (copy_from_user(p, arg, size))
-		goto out;
-	ret = -EINVAL;
-	if (memchr_inv(p, 0, size))
-		goto out;
-
 	p->last_op = IORING_OP_LAST - 1;
 
 	for (i = 0; i < nr_args; i++) {
@@ -63,10 +56,8 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 	}
 	p->ops_len = i;
 
-	ret = 0;
 	if (copy_to_user(arg, p, size))
 		ret = -EFAULT;
-out:
 	kfree(p);
 	return ret;
 }
-- 
2.45.2


