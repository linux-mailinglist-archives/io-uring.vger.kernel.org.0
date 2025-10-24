Return-Path: <io-uring+bounces-10205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7BCC0812B
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 22:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0E603A50D9
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 20:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CE32F5A1B;
	Fri, 24 Oct 2025 20:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEAWWD6b"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A032F549C
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 20:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761337969; cv=none; b=rM/1nxnRyTxIkdgSIKjdEK73t/INIOH8+1aTyz4wET/IIdwhFdn4bpEMvnPHS/juPoBAjjS/aMC6VO6bKSRBrY51UxtMh41iQHx+GvUyz2CAeLi6Pwv27yeOAfWyQTxg5AFK7l55tvPK04rz09iFElivSCtDUnL9vcBGyeqacgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761337969; c=relaxed/simple;
	bh=btsJYZa+95bqRea96G8qoMIFz43Hr3uQT/3OrV/l5m0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=N9e6cRT9s/GdXumvDIlkHg5l5bHVHLQd0yt8AJ2hbOtRJOK1HgPKEI+Qu3pizfTHrhflmNoYGWmY67Gdp6aw6vaCOsHo9dzhoqIofXQePMkVJSNn/5gkgC9paES+PlSncStS4c9+32lRMKeR0Z5Rcilk+tX2p0nLr0aPQc4cJJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEAWWD6b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12D1C4CEF1;
	Fri, 24 Oct 2025 20:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761337967;
	bh=btsJYZa+95bqRea96G8qoMIFz43Hr3uQT/3OrV/l5m0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qEAWWD6b83XXRnfZR+LkkXMzp699wJpg+be2eo7A7QJFhWXApTh/7xT5UPElk3o9V
	 dMu4GM4Vye3LLPRoOSRI7i2YkGnV3MpmJjbeIxmawRSMM0zIem0WOaXze++QtTPTPU
	 sR9/7MYwpDFYHplZG1q2XZCvluCSNcGQc1HC2lV2DRlJDrs15wfmpEqNyWhh8drC5z
	 Ox1PRWl+xcFsHBQ0PBr7yw8F36k3Bkt5PhEWkT1xwC5HuLrbjsEBJzAK3wRED2RY0x
	 XdLeYCsRMoz4rz0lYxdbDLOnD6Wm/IGdXqBvaKvmGFeObuAbfto5cU586vjvRJm4wL
	 OoLiv1zEybK/A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD5A380AA4F;
	Fri, 24 Oct 2025 20:32:28 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.18-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <32011c0c-7c43-466b-99a8-7fc3a6b661ac@kernel.dk>
References: <32011c0c-7c43-466b-99a8-7fc3a6b661ac@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <32011c0c-7c43-466b-99a8-7fc3a6b661ac@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251023
X-PR-Tracked-Commit-Id: 6f1cbf6d6fd13fc169dde14e865897924cdc4bbd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 812e7eb2b0741bb4a94f2b8c9b789ba5d693eedf
Message-Id: <176133794750.4053949.460084440001626350.pr-tracker-bot@kernel.org>
Date: Fri, 24 Oct 2025 20:32:27 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 24 Oct 2025 07:58:09 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251023

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/812e7eb2b0741bb4a94f2b8c9b789ba5d693eedf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

