Return-Path: <io-uring+bounces-6454-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BC7A368BD
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 23:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E96C3B30C4
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 22:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D461FCCEA;
	Fri, 14 Feb 2025 22:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDnYXizi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6D01FCCE8
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 22:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739573648; cv=none; b=ui41gvARkY/wxZBr6Rzj2qJ1eJ8hbB8HiBhxU9pSnlrgGIr/KklgCD06uUL/47nIYcpsZ9Dnum2+2D2PtMcpH/zDbS0me2TsJm3QfPEDnLoPFfHHUrcx82/l+pqf7H640uGhAo94m3OPPTLeqbdeLhI1os7caSg6+Hk0fxxwutI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739573648; c=relaxed/simple;
	bh=AAK1yTQ9lnJp73+48A+C8Ha/ogbF/kCtpRmzmiX7lpY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Vj6A995liKS2IKwDELFMzoKq6LwOnUr+pO+yFQafeWaXgiDuRkimvM7QWyAVTJee/rS/TrfLtOOqtC+PS2gcCQM9w2XiC85Cyqx1jiYUW/64YKAXChhVsXCN8ac9jcIfr6LKCEdS6j7Q65dfpPbem7sZXiOPqUKfWg35CUn6nPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDnYXizi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73287C4CED1;
	Fri, 14 Feb 2025 22:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739573648;
	bh=AAK1yTQ9lnJp73+48A+C8Ha/ogbF/kCtpRmzmiX7lpY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fDnYXiziL4VrFMrij3s4JhOKJQ36mSoPEAbYd5WcVKNNShREpFD7O3OiIAh5GoZ2r
	 HEYyenZx3BKu0Drlh5KgUigyA1IdyoBG6TX2CR3TyWavkQGURp9gWGCEKsAylGEB4e
	 pHxKi2tTjWHFp58PPYPHc2NIPysMmulRTj6EDtdx6apiR58vBsM6hs5WduyTZ+5lIM
	 mRwyWrgQ6m9Kt/lLzVimJIlkCCMi1g2DpVgnoOa7/FLnNyMv/IXZw4p41DeJTI5a3+
	 j126x8O0hvM9A9xw/6bhDIwFlLNoLsFky2jlt+C/GBtm/f/h+8VvSgXIkIZ5x8mfht
	 QdiPQHOh1ASZA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C9E380CEE8;
	Fri, 14 Feb 2025 22:54:39 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.14-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <e18f2a29-be98-4d08-8d83-5370e01d6d7e@kernel.dk>
References: <e18f2a29-be98-4d08-8d83-5370e01d6d7e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <e18f2a29-be98-4d08-8d83-5370e01d6d7e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.14-20250214
X-PR-Tracked-Commit-Id: d6211ebbdaa541af197b50b8dd8f22642ce0b87f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ea717324741471665110b4475a52c08a56026a9e
Message-Id: <173957367782.2130743.3355553780265323370.pr-tracker-bot@kernel.org>
Date: Fri, 14 Feb 2025 22:54:37 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Feb 2025 10:28:32 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.14-20250214

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ea717324741471665110b4475a52c08a56026a9e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

