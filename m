Return-Path: <io-uring+bounces-11025-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D29CB895C
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 11:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B413330202C4
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 10:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDB23168F2;
	Fri, 12 Dec 2025 10:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThpgGhe8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EE311C06
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 10:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765534333; cv=none; b=SeAEks6u/MaTcRQK2Ndl3u0T0L1ZGgt/hI4UocqM2FbD+mZSL5AyQuf7QTz6kcP1fHPHYI7LfdeM+S+QAJjz/mqgyGIsMGZ92OT96hBqEm6CGNyrobaC/1H38bLVLgZB+tW4jUvhe9zEHiEEYn4pOioH0qrYiqMa1Fc2ZXyyki4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765534333; c=relaxed/simple;
	bh=Rxv2e2Xv+/A6AaDKRTHhYVDLH5NZBg8BCFv2HkkSKyM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PanDRDdfUTctRujXAIdV6jDws3VrFgD1nFqQpqfqKG7Sis+jxMj+2tE9kf2BBWNDxUWePRfSaVTneAI0wZmre2eDAw91kLwC1szhztFw/g7pb6daR8vbkRJuL6v5l9cceska3o3aIyna98vfpHDW7sbeHqFEiGuhVXDwurq5BaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThpgGhe8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2C8C4CEF1;
	Fri, 12 Dec 2025 10:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765534332;
	bh=Rxv2e2Xv+/A6AaDKRTHhYVDLH5NZBg8BCFv2HkkSKyM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ThpgGhe8Iqkq0rmnoNMzyPpJtEFzgkajNCvLIRLDmdnWqAuK+3PjY1emMhbJsb7jX
	 8w9mceYaZ2uPFcW9AAB342ir1OlbHBgtH79OcjvNK2bRnQ0DNi7wEOmWQ5sdiCYpgo
	 DAAMDCtrENa4+rwAPp1cvRN5E1AEkSNJdNQooJqOjAgv3bX/uvqwMy2rgxCyNnVI1y
	 OcHDbp3G+jN3uP8L6ixWToiE/9Rda8R78fL4M4yCw8SctTi4vSnlUeghecAtDPqfFT
	 vuGgtfmo2PJXKO3RCrD2JXyecA9k5nSPPJfxa2z6OMTvqjzJpTN4JGc/nXG8zttDke
	 fjOYIbi/Q/njg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B69B3809A90;
	Fri, 12 Dec 2025 10:09:07 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <b78bae2c-2b09-421c-a8e1-8ad3fff21045@kernel.dk>
References: <b78bae2c-2b09-421c-a8e1-8ad3fff21045@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <b78bae2c-2b09-421c-a8e1-8ad3fff21045@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251211
X-PR-Tracked-Commit-Id: e15cb2200b934e507273510ba6bc747d5cde24a3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 14df4eb7e7faeecec1eaa88febb6a27308a470f5
Message-Id: <176553414582.2108206.16413474613873809881.pr-tracker-bot@kernel.org>
Date: Fri, 12 Dec 2025 10:09:05 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 11 Dec 2025 15:38:38 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251211

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/14df4eb7e7faeecec1eaa88febb6a27308a470f5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

