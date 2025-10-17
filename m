Return-Path: <io-uring+bounces-10052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C3CBBEA7D1
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 18:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8CE465A4EE3
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 15:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80D2330B0F;
	Fri, 17 Oct 2025 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrkVpMzo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39B2330B00
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 15:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716522; cv=none; b=PvJayT0vc9zw2WjMDDm133opU58OC9XCJGGZoCT1dp/C2uhsM+fucPuiK238ltRNkhvI7KzFYzNCILJRUDTyTQI6Th/Qv3vBHXN/BZGRWkNS8yRMRkzDHfP7mW0FCFjYnULoVhIZ3Lu9kaLp0Fkn8RYz9thbmH5EPY6foNU98ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716522; c=relaxed/simple;
	bh=A/Xk3T8YMhmC27b22Ruog696NWI5H3GcE5DZ5+CPDg0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CJmVI9e1rzDU2kdJ5pVcSBdWa01rjfHPBCr3GlSe+ZRCQwgDDfhM8I2RJUOhUuyxSPVDfNB/4ZEBByLSy+p6G8/wkbCFSawUwuAtsls0d+Cu3/qiYp+nWhgyV60C4wG+dFBjtIJIHjGDOMuqRbM1XI3aLGFDfde0mVKIVMBS0Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrkVpMzo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B79C4CEFE;
	Fri, 17 Oct 2025 15:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760716521;
	bh=A/Xk3T8YMhmC27b22Ruog696NWI5H3GcE5DZ5+CPDg0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YrkVpMzorwkda2jiqplVLyFF6L/2um+uT86vwrEGlGHPqvfZxUwmoAhc2TPfTB8t+
	 AdXR/+pCOl/H25tIEpl3RphDZsOIkXFaJUXCq4rvfU2ec4a8giyxCO9r6GoBDc7y3k
	 zu4X04E2jblO5/fsCqBIJFxscXnm0/BU2SKaFLI6sArLXtC4zrwMELsLm9IowcfiyS
	 icGU6avaAGysJGUw7agG79pNUMEiZXqWtg1BiUd87y6592Lo2hGm94P5vzgcIJIoL7
	 mMNeRInJyf+BjXra1mSX1QeHwvYu9gMN3vGIsu6vRWHkdaBHsAv/S9xNcGWBr6QV5H
	 bKIswb2w8ceSg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70DCF39EF97A;
	Fri, 17 Oct 2025 15:55:06 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.18-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <24ba2aad-762e-4fa1-bbf8-2956999a65c5@kernel.dk>
References: <24ba2aad-762e-4fa1-bbf8-2956999a65c5@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <24ba2aad-762e-4fa1-bbf8-2956999a65c5@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251016
X-PR-Tracked-Commit-Id: 18d6b1743eafeb3fb1e0ea5a2b7fd0a773d525a8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f3b6e91f7201e248d83232538db14d30100e9c7
Message-Id: <176071650518.2681700.11354624076846666348.pr-tracker-bot@kernel.org>
Date: Fri, 17 Oct 2025 15:55:05 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 17 Oct 2025 04:26:14 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251016

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f3b6e91f7201e248d83232538db14d30100e9c7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

