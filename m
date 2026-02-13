Return-Path: <io-uring+bounces-12183-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WH6jKwt8jmmJCgEAu9opvQ
	(envelope-from <io-uring+bounces-12183-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 02:19:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 295F0132388
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 02:19:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5700A30B4FB7
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 01:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A562206AC;
	Fri, 13 Feb 2026 01:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uieO19aA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556B321D3D6
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 01:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770945495; cv=none; b=iUK+E6yH85Wp+jPToKAxQ0w50+ojoa7QIL7u1m8myclCkleYv/dkgy0DmDr1d5oKbm1XVOqn4ijpCSoAAFY1mVTet2dV3nI4OBQzk+hr8f6fgnFDtqpxEUrcALNyoi4oVwwZePzUZtpmi0KjyxUCMKbDYNkvfL3eDYdGXiQlwdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770945495; c=relaxed/simple;
	bh=+FE2c6TLgcsynx2HfVj7Gd/I5dGfRxQWw6/iZ+TX1fw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=C4aY+TdL2y6H41WZnmy+gTlESz5pVGeBJUTzs5M0LIyg/smYZCpoeMtLs/CvmcQxA0zjfVzNlPgYubwCDC1lGaRuy4gsOSYzPZFosWjj6VYdwxqf5zOsITaWPadGDN6ms12aHh1rUosMbUnDvAgoqAIafWN3KkwW9PvMNNu7dS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uieO19aA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A78FC4CEF7;
	Fri, 13 Feb 2026 01:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770945495;
	bh=+FE2c6TLgcsynx2HfVj7Gd/I5dGfRxQWw6/iZ+TX1fw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uieO19aAtfGWkJ/nXSj3+2K/YepJY1CIhjJ2jlASXCH8UF20i3e+C7lkCrsRYPOEE
	 hzbfSX1Lhkzu7mYY8w4yNez+rGJd8Gc+RU7vANLpZp/um1aQjHfeiYQq0p7nNkJAMP
	 hPd5yA1KqNSApt3vt1MGkqMlHVbc8btvR8Mn8l/SZ9bOpQSpAg2sm36ZqHHf6tVGD8
	 dlvJKsWjjpPJ/y/sNn/CBpCU6wqBNKAQ4YcXis6xqvRo/ijCwQ0+Bm4ZJxSMPZiQhB
	 /ZV/+O2tQ5hmtqQE/HopsXw6HmK4H7Dsi028TUoRi74XNcywvfAZOOtgPkLQvKPw3o
	 25u5WBvy/2svQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8524F393108D;
	Fri, 13 Feb 2026 01:18:10 +0000 (UTC)
Subject: Re: [GIT PULL] Large buffer support for zcrx
From: pr-tracker-bot@kernel.org
In-Reply-To: <7eff267c-a76a-43e1-87a5-d92148abdc7d@kernel.dk>
References: <7eff267c-a76a-43e1-87a5-d92148abdc7d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7eff267c-a76a-43e1-87a5-d92148abdc7d@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.0/io_uring-zcrx-large-buffers-20260206
X-PR-Tracked-Commit-Id: 795663b4d160ba652959f1a46381c5e8b1342a53
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 041c16acbafbdd8c089cc077c78e060322dde18c
Message-Id: <177094548920.1792804.18170191503775084803.pr-tracker-bot@kernel.org>
Date: Fri, 13 Feb 2026 01:18:09 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12183-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 295F0132388
X-Rspamd-Action: no action

The pull request you sent on Thu, 12 Feb 2026 04:22:38 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.0/io_uring-zcrx-large-buffers-20260206

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/041c16acbafbdd8c089cc077c78e060322dde18c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

