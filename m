Return-Path: <io-uring+bounces-12579-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YAEoJrsfq2mPaAEAu9opvQ
	(envelope-from <io-uring+bounces-12579-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 19:40:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 022D5226C8F
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 19:40:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0DC5530AF671
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2026 18:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034D636EA84;
	Fri,  6 Mar 2026 18:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMGOHZIT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53E236E474
	for <io-uring@vger.kernel.org>; Fri,  6 Mar 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772822295; cv=none; b=OxDfquLkEAa+p7muxhBy3OzGgnvpPOenwZ4gQVgPHWz1TdJ4c7n/2SrOHcyNMc4rsEnI+2ots8r2We2JvV8MCXnBDD7KWLlu8Jrnagg9d/fM6E5Z9xgDmkwlJAhjKPyVVMsCOUVY8GpvbXA2J+v5nxL5cqsnSWNMq0V6DefYCgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772822295; c=relaxed/simple;
	bh=fSzwT6TbmGmuH2yJK8xflnu4uKEIBDSH9fRqpxZHgGw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RM9RCX7Q7HXOPSMGupeTzx7BQ6uQZzFmH/DthoHbVOL4XtjZ4x5CukrjptlK7iwQZDhFGil04ySG7jXjZCJPROLQAtpvZ6dhOli/OON+ISIzRmW30O8ZiYqn4iBvEEVfYlQifNjFm2qEUIS+BumDImGSJuCc+J5FEr9vUTiBVsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMGOHZIT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BB7C4CEF7;
	Fri,  6 Mar 2026 18:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772822295;
	bh=fSzwT6TbmGmuH2yJK8xflnu4uKEIBDSH9fRqpxZHgGw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GMGOHZIT4BVQtoqz48miM/u6OnXS5j4OfJ+z1QO0VGkAwnUMMz2hWOaOa2OG4Ds/Q
	 Kt4o6TPpDrvkXbsE/lsgRUFcKRHcoFyeyawToGUhU10NgEub/0+A+l0NCKs/A1oyN/
	 blyN+3HsAzydxEjRPEkEdHZaBxwhtMiIBcLHT8gNr72bvmJb91LlhrE9ab1P0aK8PO
	 r7BsAzyvzlr83oiKqx2VH/8SJlvDn6oJFFWskBycJqynLSJac1xTng1n33UGQae0ao
	 h2D5U/hPcUS+mQO/c9eXxdCvT4L9FYtXc404R8MO7zXncMqin7SNEGCtiS6x9XVS2+
	 Z3WWxCPxsyCgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FEFB3808200;
	Fri,  6 Mar 2026 18:38:16 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.0-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <f6932cf1-66e0-4278-ab58-37a368b0c5d4@kernel.dk>
References: <f6932cf1-66e0-4278-ab58-37a368b0c5d4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <f6932cf1-66e0-4278-ab58-37a368b0c5d4@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260305
X-PR-Tracked-Commit-Id: 531bb98a030cc1073bd7ed9a502c0a3a781e92ee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ad66a34cce2c5a6532ac0b979fdf58677193c67
Message-Id: <177282229478.7628.3187536964468973490.pr-tracker-bot@kernel.org>
Date: Fri, 06 Mar 2026 18:38:14 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 022D5226C8F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-12579-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.988];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

The pull request you sent on Thu, 5 Mar 2026 19:38:21 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260305

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ad66a34cce2c5a6532ac0b979fdf58677193c67

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

