Return-Path: <io-uring+bounces-9258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B124DB31A11
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:46:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E571B642A54
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 13:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F0A2C3261;
	Fri, 22 Aug 2025 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGOQVC2B"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BA62FF17C
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 13:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755869810; cv=none; b=AU750OycBEEtmcWofdeBOSq9NaqJBw5O5JnHm6UC39MVeaI4ExOFeqRE4W4j6q9Dk5qvxH24RoQ7I4geJqv30tL8XX09SO7gaob7KqA7kO9TFrKvSgJOlPEl3rA3oVyfhEWtV4hsmsFSxd+ZbN88EPn7NxRcrn4Sy1DTg6sJk20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755869810; c=relaxed/simple;
	bh=YdQ2Armk3Ow8nw/BHdcQz0FHuKu/N0URqwvlyMW8Jxo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=U/7ku7IZlTu/+OWKg5V49qTHVDJcRxC6XGm/PAukWbyQeF4HzKYoMKO/0O5e3AUte9MeaKH1VI2PElNE19BfRUiRXm9opBJqssT+FmhwtB8yGKyf6ztH4DX/WP/mgApFn8PBsVFfGS5HVKm6oNKrH1MIb/NamgpC9Op5UOsA47Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGOQVC2B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9507C4CEED;
	Fri, 22 Aug 2025 13:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755869810;
	bh=YdQ2Armk3Ow8nw/BHdcQz0FHuKu/N0URqwvlyMW8Jxo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QGOQVC2BOYZIvBtXnlbVX5BPGp3G80R+63ztyE6MBGy7iSHnvcjKOzl1HUuLBxX+U
	 q3qfV6jsjo2vaSgrkNFxU5OYdjrbimlZ0ZL8kmmPI2Wf8xixJZAh9tGGbdA2jC/cWX
	 H0qOMGvb/bFYoYmizKhZusEmuWRGZaoj/xWBPRRXV2i/9uhPRSPt1rgfLeFM/nAb6F
	 62W3Mvo1oz1myxCmDUyMFy5K7QoPUosU/YT1yJv7bOxKj48DsnKxUOcISMTUVZGAN+
	 keYdlbx68Ze+cV1RGWGeTV6brtgO2V1uaW4Bt92E0YV/9494ytPtScHxtpPxeyvb66
	 k4rHXRXkJMOeg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB169383BF6A;
	Fri, 22 Aug 2025 13:37:00 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.17-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <9eda00d9-2316-49c4-bdb7-af1e20546e7b@kernel.dk>
References: <9eda00d9-2316-49c4-bdb7-af1e20546e7b@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9eda00d9-2316-49c4-bdb7-af1e20546e7b@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.17-20250822
X-PR-Tracked-Commit-Id: e4e6aaea46b7be818eba0510ba68d30df8689ea3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d28de4fc0aaa8db6c0163e37c6d4d07f062a08db
Message-Id: <175586981952.1831455.12276304545734486818.pr-tracker-bot@kernel.org>
Date: Fri, 22 Aug 2025 13:36:59 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 Aug 2025 07:17:15 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.17-20250822

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d28de4fc0aaa8db6c0163e37c6d4d07f062a08db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

