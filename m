Return-Path: <io-uring+bounces-2541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 485FF9394E7
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 22:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0497D2831A7
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 20:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29EE83770D;
	Mon, 22 Jul 2024 20:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpnzGD0D"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067D9381B1
	for <io-uring@vger.kernel.org>; Mon, 22 Jul 2024 20:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721681102; cv=none; b=qbcQTscgo2quB8+ze4Xve9p+uFVQQkeOov0mGfIniHtG7QjBdPyWhX4hXF5pl98O/U5bNEsZYNWPom+iqeeOzHWg2C1yYzfBJdQTYvVDs1qW/NMkL+iek1xIJDMU8VvsbaEQOlPY8VBYi9piwD0d2Zvzzffa7iJ5PfJ7a9cWZfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721681102; c=relaxed/simple;
	bh=bix0g6t7sIIu/CJ44wXfH7P+rd3qe0wsY8MVwrp/QpY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uurNwSIcbLybPRO07Ml6h9wvAPcVRKAIJh+cr/SvcJFCNQTmYsoZtVX88Q0ARHl+hWomqxPybI7wpoU9ImzrtyhddNroMOOFNEztbjk+9Kw3hwQVK8vSRjqwe+dyZGNtbzv3YlurG5CgmTxzKfEka/72tCSi2wmlzwMb09csy00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpnzGD0D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB1AFC4AF0B;
	Mon, 22 Jul 2024 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721681101;
	bh=bix0g6t7sIIu/CJ44wXfH7P+rd3qe0wsY8MVwrp/QpY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jpnzGD0DnVrGRcpPE7hTZnJPdW2NQbmfvsBTB44p0KzNr+RcNXwp5OaYtfZSyjT1k
	 1+A+U2Sb41LqfFHbEQWF9DasNDZuuQ7bp6HqoGoK9QvQfYhUKjvbkEQ3Lvy2I6D3HQ
	 VUJ0upj+WXX0PphSZu4bghCWqZhO0G1PHz/RXPcRZbqeRwXenRA/x7J2xFkE2+k9qb
	 ZBVFGaQc5dBLAgp39muXmFfJyGSDMeOxLldeiXnNLX2zLKuf4q/QvnWPMm/s21V709
	 D15K55rhIIaM8aXsY6FIxbeA0EiN72DhPH/92qC9FhPtYTatn8upCQbm1ovnnoACdf
	 tiCeY9df7aQ2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D07F4C43443;
	Mon, 22 Jul 2024 20:45:01 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <3b4379ca-3504-4afd-aa51-a00f1d6022e7@kernel.dk>
References: <3b4379ca-3504-4afd-aa51-a00f1d6022e7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <3b4379ca-3504-4afd-aa51-a00f1d6022e7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.11-20240722
X-PR-Tracked-Commit-Id: bcc87d978b834c298bbdd9c52454c5d0a946e97e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9deed1d5f82cf30308027f9f604a95ac7ffdbe19
Message-Id: <172168110184.32529.18216048289277989296.pr-tracker-bot@kernel.org>
Date: Mon, 22 Jul 2024 20:45:01 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 22 Jul 2024 07:59:49 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.11-20240722

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9deed1d5f82cf30308027f9f604a95ac7ffdbe19

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

