Return-Path: <io-uring+bounces-13258-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNMOMOFK/mllowAAu9opvQ
	(envelope-from <io-uring+bounces-13258-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 22:43:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB264FB93C
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 22:43:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E97043011354
	for <lists+io-uring@lfdr.de>; Fri,  8 May 2026 20:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2231E3FBED4;
	Fri,  8 May 2026 20:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmDeEt41"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38543FBEAA
	for <io-uring@vger.kernel.org>; Fri,  8 May 2026 20:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778272991; cv=none; b=Quux+rSfFtuS/lS2dQNY39l9NqEO86T5ggBsO/HRbDTQpKQLb4IWB20gqniHYR8fbJ9qZgbMLxISeA8xRJF/qyL/4V+TDyexfHpaMUHBSwyJ9qPkL3mqr2ILtrqE+9KUEmNXeMRr6kwPtCcvy3VS/MFJ/5AephsKcyvXoygeWws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778272991; c=relaxed/simple;
	bh=Wv4ulKxjcDeO1lFT3znmqJ4GLGT3My1dipYke0rhyGY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lfeyMg4X+RlrEUjBw6H85iTev/BtdcfcMu81SUJMBT66wGzvrjD/9wsYmx/AC/j2Pgb2J/hKy0ISrmO7cKoB3O8ifxpW4y5zsHFBe6eaL5AWZcnrYD8AU95t2FoyWUNbtW4lqFT6j6yFpmVTX8VaQ5vBw+KrLT7NtCzvluSqo7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmDeEt41; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E10C2BCB0;
	Fri,  8 May 2026 20:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778272990;
	bh=Wv4ulKxjcDeO1lFT3znmqJ4GLGT3My1dipYke0rhyGY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GmDeEt41wOyUiSopdkg24c1Q1yNOV6piIPB+Axa8+4DhQh3S4CHRXpbETvL0x8mja
	 O93t74hgTZ/5q3nXSERx8Sh/cZip9tN5w0K+yO1K/nuiKveFRH7xlQPigBAHjVRlje
	 fvYz6vLJPwpCeDlf26dugXF4sTcdh5McmP3KkImyxfcE4zCWztNUVNBgjE0SBqktef
	 rHHxOKXSum7RUrH1YrL+xBekrBma21fks2fd0NfqnbPfD04sxppDl6JQ78F3FGK9G2
	 2kvt3Xp87fhkW0UVmTPvAdJnWt5n9mccFOH6SSY6urWtXhBnoGEZMWeeRd8fSIXjdZ
	 PE+UU6N/ltRHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CFD538119C3;
	Fri,  8 May 2026 20:42:20 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.1-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <db32ecb0-b37c-43b2-a8ab-cba6713b3e67@kernel.dk>
References: <db32ecb0-b37c-43b2-a8ab-cba6713b3e67@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <db32ecb0-b37c-43b2-a8ab-cba6713b3e67@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260508
X-PR-Tracked-Commit-Id: 45d2b37a37ab98484693533496395c610a2cab96
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8be01e1280912a84f6bcf963ceed6c9f13ba1986
Message-Id: <177827293907.841904.3011271410560530078.pr-tracker-bot@kernel.org>
Date: Fri, 08 May 2026 20:42:19 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 6FB264FB93C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-13258-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

The pull request you sent on Fri, 8 May 2026 13:19:14 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260508

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8be01e1280912a84f6bcf963ceed6c9f13ba1986

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

