Return-Path: <io-uring+bounces-2931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A86C095D9F3
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 01:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF4611C2182E
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 23:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F831C8FB0;
	Fri, 23 Aug 2024 23:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnXQxUMB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06AE1C93A8
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 23:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457320; cv=none; b=KsXRn85Luc+lgooX27yAQ/gzj/k50dNGZnKWEp4NERppdW0+JNg2YgB6F8MWxUyBB3vkoJlDveHeHtHRlpOls5UoyFh8QEhRR3OdD5IzvniMOQsrfeH3UtO81ppCeWhGD/yrWrie4cEFXs9SFSCo1BZBGro0q9LfBH/qjZttEbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457320; c=relaxed/simple;
	bh=vZyLQ/F6PLwTnxpE78ARAhPgnpgAxvOEEl3tgkNDDE4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hMk3bNaz1/+eQ1It+O95CYHRvZDXWjgS3ZRs/FGnyfFj9J2tByZKMSVNOJF0PnVwq6dn6BVD5KcLlMKpmpsTZ8QsUsaYsATmxYHaGfpyg3o1KvoRxHIrZq/09fbyibUbr2AD1dmMExLuVwKLbcEV3Dx879WtoGvAWjCI33rUvrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnXQxUMB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF74C4AF0B;
	Fri, 23 Aug 2024 23:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724457320;
	bh=vZyLQ/F6PLwTnxpE78ARAhPgnpgAxvOEEl3tgkNDDE4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AnXQxUMBP1B3LGeMTZ5kbsBTfr60ciLUHYUehDxwCvvs1JLC6KglYe9FtODj0qzjQ
	 2w7hUIklFqlRJxt5MG4U8U220X6gIX735yR3vkicNPbWRR69FnoQUUOdtGbtiYOUpY
	 YtT1R4YhdBqOhgEkdTW7633RM+XKA7yO7z0nCkZ5XY2zr1tExJAg7oPMSh4inpjAaw
	 mERrj/avZ3w/a0Yl7ey3rYkqmH4fj80sAuSpj4EDExfcNlb88WV2YX5UxHXiY4t+42
	 vbsDeXz1OorYXBGOfhVe8TDsgWVmdzk5ej+5DmQCQvSAt7xiUIFJlWX+KvKmXIYyvo
	 INFDrxvenCJdg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE09B3804C87;
	Fri, 23 Aug 2024 23:55:21 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.11-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <e1c82466-845e-4a68-888e-43f6916ed5e2@kernel.dk>
References: <e1c82466-845e-4a68-888e-43f6916ed5e2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <e1c82466-845e-4a68-888e-43f6916ed5e2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.11-20240823
X-PR-Tracked-Commit-Id: e0ee967630c8ee67bb47a5b38d235cd5a8789c48
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 489270f44c3fc2fb8d0e5d102ea08a90e93ca135
Message-Id: <172445732037.3115107.1281048660318184499.pr-tracker-bot@kernel.org>
Date: Fri, 23 Aug 2024 23:55:20 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 23 Aug 2024 09:11:40 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.11-20240823

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/489270f44c3fc2fb8d0e5d102ea08a90e93ca135

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

