Return-Path: <io-uring+bounces-5668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C8BA010F5
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 00:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FC94164B4D
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 23:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E38D1BEF6C;
	Fri,  3 Jan 2025 23:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGBFbpko"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016944A18
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 23:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735946535; cv=none; b=Ye4hrPgo8pxZmfHDAVZB6z9nonBZiXmxWDDLFKZzrFHzd74cdu4betkaqTEzIAMigB2ddUJHFuyrvUVPHdr+CCMRY8nEuvtI0rxYRrZDLZ5VTtByfnULF1Q0BMilxbAnBjiYNUylCtw18FvYiHKdWBjzR48pJexoJ3ZKrLJGrWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735946535; c=relaxed/simple;
	bh=ddM8r3NFZMEundoLop8ZmxlQmYrrXw9nbeJUTtHWSzs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hgHvFttecMu/wCbofSsiWEehdK2efwhE7lOt1pcIfvMg9ewQBFTsbzwp28JVba1t1p/pEqwTT6MVT29OEahVzU3RWeer8Q8GSTedzUYmzNZ+yBE0o7vAdqXYAN4cUZng+31QbGUhPDh6OR91lyVUQDGuOQNJUOdw9pzAc3GrE7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGBFbpko; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC5BC4CEDD;
	Fri,  3 Jan 2025 23:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735946534;
	bh=ddM8r3NFZMEundoLop8ZmxlQmYrrXw9nbeJUTtHWSzs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DGBFbpkoYJbTJiVBNSyTImh3yAzH97RU2lxAZx9drpLrtbCD4lCBC0M4sPo3vl376
	 mDN10obgDQ39VoPIdG39ZP5fajFh5pjHPrwRtrt30av6lYUHKiNilSs0re9V5CeWCO
	 yA5u/WnTA+Ib5GJzRua4yDRRLfy/u+eKvnTKmcmAhvAcqAJ59vAwP3rRO2l1D+GPcE
	 8/pMRgicUa3LygLowoUkL59TVQkFxcI27U3NDiT2ID5b6k0P4OXR6i3wswJiazbtT2
	 E/xusgyoSUOKguY6YUnCxRcsfgLpQufTj3QjRfL0HMNYzIG+EKv5A75p8IwRww2U1+
	 FOYvBeD19sAjg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70DB5380A974;
	Fri,  3 Jan 2025 23:22:36 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.13-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <af2442f7-b26c-4584-a267-d0ca85580a92@kernel.dk>
References: <af2442f7-b26c-4584-a267-d0ca85580a92@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <af2442f7-b26c-4584-a267-d0ca85580a92@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.13-20250103
X-PR-Tracked-Commit-Id: ed123c948d06688d10f3b10a7bce1d6fbfd1ed07
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a984e234fcdce25a276be882c799e5fda1b32812
Message-Id: <173594655500.2324745.11842495501403871866.pr-tracker-bot@kernel.org>
Date: Fri, 03 Jan 2025 23:22:35 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 3 Jan 2025 13:03:32 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.13-20250103

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a984e234fcdce25a276be882c799e5fda1b32812

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

