Return-Path: <io-uring+bounces-10442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5304BC40C15
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 17:07:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 642743B0D4E
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 16:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B64E2F362F;
	Fri,  7 Nov 2025 16:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGI/MghP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A532F3614
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 16:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762531586; cv=none; b=cx97jripbFgQBouYUYC7H26X0InsbBIOhulgQmE8c1obzqYIaMgAZg+O6PPptJvb8F3IQfQdPrD/0o1meW+q6Uq4MG3sRF35397e4brBwLXr5ytJYNwSrmSLJ3KZOkN7UvMTUVrmBVMJGoepRAoazPNAWColAlOjadXmanYa3Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762531586; c=relaxed/simple;
	bh=c0ZUD7OKBd7k8aR1sFhpK6xxOyBLPAyVXEWWXliatag=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sDCMcPUZJZaBxGJ2DV8QP5GBGdA7E0OcFDf5fWdficfVwyofJTF692rK4MXLvWvSvs4YvBJJF2jrIq76PCc0C1oAbroKjgp8aI+oIJFCjUhP3z1OYtQalZDBIE9gHYggekwmgnwXgxtn6uKPy7VW0ZNeNMyQUp02CosNxOkhEeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGI/MghP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47C4C4CEF8;
	Fri,  7 Nov 2025 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762531585;
	bh=c0ZUD7OKBd7k8aR1sFhpK6xxOyBLPAyVXEWWXliatag=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VGI/MghPEOU+tgDx2docaeUqlg3VA1jUTvJEJSWTXgEWJSDKXb2Itnk8Gfj07+7/g
	 rk5kszkbjuwZ4W/eCVv5Ab3qOg9Yf8pJZX9QpYEd1QYgr/lmmbWEmdN/R1274rIk2X
	 Dx9nB+AjJlYUNIEteZKpxb5uSZJxYfEnBXaYmrwwhV0F0NdWC428X8SxkLUkwEm/On
	 qk08zSoGV7+x7f3ePow4g3k+z094qkTH9hczeYYgdSUqjqfcfYeex7gAFfJ41rBM/m
	 qh9An6eSFA7Ybl6M7GIUYvH1LmZqLtw8KufylyDeFCmKzGHcp9a3y4UqcAcmrW+Hfz
	 lvJN9rS4xYLzQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70EF739EFFCF;
	Fri,  7 Nov 2025 16:05:59 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.18-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <005ffa7d-e86c-4432-9806-8449b9de0b37@kernel.dk>
References: <005ffa7d-e86c-4432-9806-8449b9de0b37@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <005ffa7d-e86c-4432-9806-8449b9de0b37@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251106
X-PR-Tracked-Commit-Id: 1fd5367391bf0eeb09e624c4ab45121b54eaab96
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9dc520632a0dd3bdc37540528040771a96bdc8ff
Message-Id: <176253155807.1077315.3851372365925176694.pr-tracker-bot@kernel.org>
Date: Fri, 07 Nov 2025 16:05:58 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 7 Nov 2025 04:32:55 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251106

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9dc520632a0dd3bdc37540528040771a96bdc8ff

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

