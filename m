Return-Path: <io-uring+bounces-7549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D51A93B31
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 18:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF1A719E08DB
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 16:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52993524B0;
	Fri, 18 Apr 2025 16:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrTQl6Uu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBCF2CCC0
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 16:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744994718; cv=none; b=e42YPHCGM0+ZIT/hkU1bCUKNVz/otdHVkto4pGc0E7WvwXYmOt7FkNItlga8XQsLjDQFs3KyFCAjHeZvN8tl+KQ7vBMH+7B8oX+1zIsM8townneqLZ27AfDKN8YYplyYOBLqUpJG+DbKmGeTMjGLiiup0ubMzR1PZJMKwTofY0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744994718; c=relaxed/simple;
	bh=yiIi3wMahqKtsdGHZhVOXb3iADa4pSambwxydEXIn08=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cHO4aoMaQRbfrzJC91fcqrtHxxRRSRumbNaI9yFT0MVDmkBxLuLFJtiQ+9NfikBlkZ3v0/3iTJPS+PUd52sYqSs/ID4e/OSG9FDBBHT9IZb3t8s1bi2+zNvgP6pYCrUFBa5/X9YL8WtBLhC9tZxTdiqJOWZPvuuVXYPoWFEZPak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrTQl6Uu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDCCC4CEE2;
	Fri, 18 Apr 2025 16:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744994718;
	bh=yiIi3wMahqKtsdGHZhVOXb3iADa4pSambwxydEXIn08=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rrTQl6UuuVTH7p/QzaZCAu3sc2YFIVUo8IiQG160o1wWHlT9dFsfB/Y0HhAFlqm+/
	 HEP8lm2NxyuGWNIdBYx5IoZj21jNwu1dXETZKnE45itJ4APZkavEiWW9KjaspYkLT2
	 sD4YSLgQYxaVQmp3TDbWSaR3C65nRSoDeST31SBlNIbNqHag77MoeGEPrhvpfFT5FG
	 GlMMxvdwVm+oJnrkPrkgq6xVbbWLWbLzLpUxfKw6pbJZi1yReBmp3r0y7mByssqTOZ
	 od93zJyyG9bwdwA8ZbfqQ6UujlUvTu7Wg09LTr4eoi26cbvcnF40Q0b0SXzX/yOBsU
	 XD95CLOUdj+Aw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70FCB3822E07;
	Fri, 18 Apr 2025 16:45:57 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.15-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <a88f9dd9-5bcd-4103-8df6-3dd8d29288e9@kernel.dk>
References: <a88f9dd9-5bcd-4103-8df6-3dd8d29288e9@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a88f9dd9-5bcd-4103-8df6-3dd8d29288e9@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.15-20250418
X-PR-Tracked-Commit-Id: f12ecf5e1c5eca48b8652e893afcdb730384a6aa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b1011b2b451c8b6d16be6b07f44f22a0a0dd7158
Message-Id: <174499475605.267730.413938516791117812.pr-tracker-bot@kernel.org>
Date: Fri, 18 Apr 2025 16:45:56 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Apr 2025 08:46:02 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.15-20250418

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b1011b2b451c8b6d16be6b07f44f22a0a0dd7158

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

