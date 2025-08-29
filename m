Return-Path: <io-uring+bounces-9478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDDBB3C104
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 18:41:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0975717738A
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D3933438D;
	Fri, 29 Aug 2025 16:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krQKTVZs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E99732A3CE
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 16:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756485589; cv=none; b=sop1QklgH8yStIFpSd/9oOjr9arOGtU8NIR0auYkmDkXyZaVxgr1nADOtKl/Mc4fwfNpsKWbpvZHPhlNIJ4viLbeiKCQg042VIHvvGvkUO4nnNwbb7pVZrmmVPOwl+FnHWr/YyTht0cL5kBSj8EXn/bhQt/FpZRd1g0Lz7hkLRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756485589; c=relaxed/simple;
	bh=MCtyYMfXk3pk8UIum0ukoJSZ6kf22R6HNGyJn1Eo7fY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tPx+9+StgDZ7M8J9lHbwF1rYWojAICeXnrCZaCirf15bKi10SPteCZBJ6RrkHxLRa8iM19oSioluCj6/JuvFp9JJIMkuSV2ATUaA1AG4Q86edqXH/tYchGJsfriGqwcQlyvYz4luLNVmu3ZRnNhl0jdb39013yxin92OQVSkxVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krQKTVZs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A78C4CEF0;
	Fri, 29 Aug 2025 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756485589;
	bh=MCtyYMfXk3pk8UIum0ukoJSZ6kf22R6HNGyJn1Eo7fY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=krQKTVZsRqcBPEHsdwuc0HYuqNFT/u3w/syje7J8qwDriOE3O5eXDB+ignljJ1h32
	 Jjsvh8uazeidZUsT0Om5I/PsKg+mTpnLQtR6AuTC5x+YLbBb+3vdznwFBiv1GkocnV
	 x3LqcYo0ETPpa+CIu/MRZG8AN3NSeiKo0EOx9dq4tM0ltvqswyn8ioe+jQSXnRgyth
	 pTYosJ4qCaKarYgXtqt1dZER2ptSiBI/zw8zs1HeOw6RAg+T59LNKDm9dd+ppjj2jo
	 t2JTLvacwDtltpugG0V3ZW3RiFBmzLLgRQ7JlnxTv2hZRGDrq++7v2Tzq1WCtdTHB3
	 wpIOReCSxfa/w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D21383BF75;
	Fri, 29 Aug 2025 16:39:57 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.17-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <6a3bb8be-140e-4ec4-b903-683c43115992@kernel.dk>
References: <6a3bb8be-140e-4ec4-b903-683c43115992@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6a3bb8be-140e-4ec4-b903-683c43115992@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.17-20250828
X-PR-Tracked-Commit-Id: 98b6fa62c84f2e129161e976a5b9b3cb4ccd117b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 220374ab2be5a05dc5e35c9a5337698c942916e1
Message-Id: <175648559586.2275621.1055651783197745133.pr-tracker-bot@kernel.org>
Date: Fri, 29 Aug 2025 16:39:55 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 28 Aug 2025 19:27:47 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.17-20250828

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/220374ab2be5a05dc5e35c9a5337698c942916e1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

