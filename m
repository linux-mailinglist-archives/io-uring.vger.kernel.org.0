Return-Path: <io-uring+bounces-13482-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gC1qFduxEGpWcgYAu9opvQ
	(envelope-from <io-uring+bounces-13482-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 21:43:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A92B65B98A1
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 21:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1CC453016EEF
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 19:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C54349CCB;
	Fri, 22 May 2026 19:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyyMm4hy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A003D357CED
	for <io-uring@vger.kernel.org>; Fri, 22 May 2026 19:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779478754; cv=none; b=LW5H27NHpAj9Y2DKrpi2dYWpmxgr3ff6jwWRSeoPu0W4/rKIt3UUoaFoM5aMYbeOXD+hCXlaYBb7xdYqL/6Nd+pVITTMCq3zI97UYTB11z4pgVIK1kbvsqvxNnG3968al4k/RhY9wvheuuCr/59chVBPZSgEdGCESueRO4Ktz8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779478754; c=relaxed/simple;
	bh=Rnb6sCGmE2+AePMKOkF/S4FUG/dHdFiS/zb3G0oZDRE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Bqz4e8pPv1eMh8f62x9dvAxY8pJdOAy/oSJEffih1DAdYT0JsbeMOYaTn1GWJxzrEUl44fBl33jqVoDRQusANNPLBG/X4PFjjjLX0Wldjzj4XsFaisrAgmhtGaNK3H5m5zek+sIq6qUXJfwEd+w9g/KUvTMmaZ00pzLifX3TyZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyyMm4hy; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888331F000E9;
	Fri, 22 May 2026 19:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779478753;
	bh=BrjrP2/DFj7iGcW6MBpJebgjDopcoshiB1FkTdNM3Tw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=KyyMm4hycFBeYRCeRE8yeGn9QdTOD0a7ZN1O1pa5NopmtHoz5J5HJ4DAFmwJnCWGW
	 arCAenNos5D2Wk3JWU3ebWA2bQJHoNa745L/8B5xPSGxXuF5eka/Jx4zLmBLFl/T90
	 M3Ocdx7chcG2soHlQAxoIvchZEl/1eEmBH/w680BSS5D5XP5k55Bxt7/Pb9WAHpdXL
	 TamGMdx6zZ89QmXYxOnc7PnsOCLWWJqK1Eg+jzRgRBzhbHfdmHb+GIlATBJRa9MadS
	 NVlBOutNwKEILtaSmWtkuDOMWvNVdy2dpF2Nwbhn/MzzniKajlT1tcHGOfvfQbAFDu
	 /HwsmmkdbcCEg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0B9D3930FBA;
	Fri, 22 May 2026 19:39:23 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 7.1-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <a2fc1873-e68c-45ad-a8db-c70eb2c9c5a8@kernel.dk>
References: <a2fc1873-e68c-45ad-a8db-c70eb2c9c5a8@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a2fc1873-e68c-45ad-a8db-c70eb2c9c5a8@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260522
X-PR-Tracked-Commit-Id: e97ff8b62d4690c69297f0f6de874f0564cc01a4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dbae42cfa618abc57f0bc3c28cc140292f4f7410
Message-Id: <177947876232.1341212.4146526189439515899.pr-tracker-bot@kernel.org>
Date: Fri, 22 May 2026 19:39:22 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-13482-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: A92B65B98A1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The pull request you sent on Fri, 22 May 2026 09:50:57 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260522

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dbae42cfa618abc57f0bc3c28cc140292f4f7410

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

