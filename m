Return-Path: <io-uring+bounces-7285-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5AB1A75256
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 510121712C1
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 22:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9931F099A;
	Fri, 28 Mar 2025 22:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tU461rBn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970DD1E835F
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 22:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743199829; cv=none; b=TFoZeAIjie0HHHP3uBDw8pNq09ZW42wbA1iy3u1bimg4M+ljspQ0CVEMf6CFDG6zXrYwNCqiursBCqhflcO3mcHrjnF043Gi7pbe8s8l+zHe6eCC9dVuwGrtRMdXfFTE39hHIm0mjEioBwOeuMj1Rp53wT2aMSYynASlfhp27UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743199829; c=relaxed/simple;
	bh=XYAjvU/bKxnA5U8ucTaceH+tPiIqnHFFcSx9fbwIUAY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LjrnZhwCRVkF1thanbKzkInCQz8xNAvrIbAzCR/D7xTNZKhYB6W4sp93e0P7QZ672zWgrc3gVpBtLZHv5f7iqFzS8qeeiYzREfKvzSRH51VpyHm1gTe7biziXxB/MevP+BT0UfbynuZjJwsmyS8FY6D42GYcWSPC0JHqV98emD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tU461rBn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7921DC4CEE4;
	Fri, 28 Mar 2025 22:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743199829;
	bh=XYAjvU/bKxnA5U8ucTaceH+tPiIqnHFFcSx9fbwIUAY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tU461rBnyhCknDpH/JPf7+TLyozdIk8FZBuno/09SavhmUha/jCDiiduwtIVG/su5
	 /JA796wPjiLLFMoEfMen3zJNdr9ExtLHTDSK6/RjKq5us5rWWC5aumOvkIAmi6TuOP
	 50gKlzTH+ivmvHWqFZ4MKS6oEL9hjitTDY4B2Z+LAnZPF+HfnfbYk0/We01qUprZ52
	 FoAmKaKFCatxcnXTHTfdnVcleIbp4jhiNO1fl3HBBbgIJaWpcnbkPxNoGgl6jCI1T+
	 zCqGVPFUcQwAgzjk9n7etpf7CTl+nJ6Kfim/m/QTy8wO3vtTGbZ7SF1z0bsOF46Hdz
	 VOkZ3ggc7XCaw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3446E3805D89;
	Fri, 28 Mar 2025 22:11:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring epoll reaping support
From: pr-tracker-bot@kernel.org
In-Reply-To: <3ad3c346-1415-45bd-bcb2-2f9b46164f30@kernel.dk>
References: <3ad3c346-1415-45bd-bcb2-2f9b46164f30@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <3ad3c346-1415-45bd-bcb2-2f9b46164f30@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git for-6.15/io_uring-rx-zc-20250325
X-PR-Tracked-Commit-Id: 19f7e942732766aec8a51d217ab5fb4a7fe3bb0d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6e3da40ed6f3508dcf34b1539496bcccef7015ef
Message-Id: <174319986566.2977572.14810897991710218628.pr-tracker-bot@kernel.org>
Date: Fri, 28 Mar 2025 22:11:05 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 27 Mar 2025 05:47:56 -0600:

> git://git.kernel.dk/linux.git for-6.15/io_uring-rx-zc-20250325

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6e3da40ed6f3508dcf34b1539496bcccef7015ef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

