Return-Path: <io-uring+bounces-8919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD162B1F268
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 07:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE6FB18C4D62
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 05:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFEF1B0414;
	Sat,  9 Aug 2025 05:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrYxCLQv"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8005288CC
	for <io-uring@vger.kernel.org>; Sat,  9 Aug 2025 05:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754718855; cv=none; b=s1YbHGLp8NzUdMKwliqwpT8M1EivANPA/uOlORiuhcHjeIKh9aX9dgDPuUvo6Qz1N/4CnXw11FuAuT/bmAgkTbO/pIKZRoOHk68IrK7ObqAo1YAA3VV7NEIfHNhwqbGV4f33Ue/sKzZ2hM4PXa4zXJWjejoj2fCoQS8WhWyC9FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754718855; c=relaxed/simple;
	bh=s3yNgm3J49q9sTUVNxPaaxCD9llTs8dJDUMCy3irVi0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Q56HTMNb7Sva3V0n81Qux/PxJzCzHvjeN5wuY1eBvWk9XohOLt47J4WHv0AdqPI9TdMsI0QqAtrBtcUzS6vyywHX8Y+amimkuAz5+T5q7CZD60IfFaOmmOlaSL+xb0/BTj+XuQGs9BQyIY8JNkUx3+Xj2ThOq7HKwhl8Zm+Qdgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrYxCLQv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78B0C4CEE7;
	Sat,  9 Aug 2025 05:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754718855;
	bh=s3yNgm3J49q9sTUVNxPaaxCD9llTs8dJDUMCy3irVi0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JrYxCLQvy6QifiQxUs0Iv4Tm9FO0Y+I2lBCuliMzmLyNwkqT7TGOqY8j1930aRB5K
	 ki1/oqcAYzl1R/aPspePLEPqtlJslB09uzY1Omair4sbFPcthgwx73E7GGrkzayGfL
	 Vy3ftF899crC79BhJv1m95qyx66uYOcH91wT4hnD1HbcQiFbDbwU3Fu2tVDs17qjaf
	 KcPyS/4JXNVz/Avdn2Sqd3p+r7hgzN1v/OEff5u4uDTCT1WnK0JlV48uLpPXUUu75I
	 3C4O0eCokwd1ZlcRiqRCNZJwvx5DJgvqzqs0P9lWn/SUT9AIoW+5P19mdfe2UqtR0P
	 8Nuheb0sXP/Eg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB178383BF5A;
	Sat,  9 Aug 2025 05:54:29 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <5ae36e4a-8839-4bb4-bd66-24367f161683@kernel.dk>
References: <5ae36e4a-8839-4bb4-bd66-24367f161683@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <5ae36e4a-8839-4bb4-bd66-24367f161683@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.17-20250808
X-PR-Tracked-Commit-Id: 33503c083fda048c77903460ac0429e1e2c0e341
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 24bbfb8920d4179775a0255e97566ddb45c33328
Message-Id: <175471886854.391257.8609448747962600718.pr-tracker-bot@kernel.org>
Date: Sat, 09 Aug 2025 05:54:28 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 8 Aug 2025 11:13:46 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.17-20250808

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/24bbfb8920d4179775a0255e97566ddb45c33328

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

