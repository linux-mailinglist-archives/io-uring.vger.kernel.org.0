Return-Path: <io-uring+bounces-8722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3094AB0AAC2
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 21:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7846A168986
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 19:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6490D1B0F23;
	Fri, 18 Jul 2025 19:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLDBlyFC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4005016DEB3
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 19:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752867458; cv=none; b=sS+UzfKAPHdXZWf1hU2nEHT8FQSlNJ5Vist6gCe52M8gDwd1gA/gePWpYfiJo4gzd21PgGG1L30s0hRoQAJQiRCJg7LNGUBjxCsFzY1z0Kz5cEfzhPBHSLxWJj8XOUZ8EAYx7UPBFMHjF4vAAaKmlxsuzeypkUOPjFWBcUV9eX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752867458; c=relaxed/simple;
	bh=Gy89B8eBPYqTjZYZxBZcqYcBkWuRE4RdtCdTAIjObFc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JuGAg8HF0Cy84tYFJrlkIYFU6ozTML83Wu4uZyngq3aPSRvCx7NlrF5mt/163vfqcGzDrXx9KazYhaHaR5u33UTZ49rDLFkcF4DbrIygi77eSTyc/ArZ5hbTvbtfe0GTdP1y+2LWDjw7pa/R2RhDdHTGDaSYVZPrdyWgXIctPwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLDBlyFC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C09C4CEEB;
	Fri, 18 Jul 2025 19:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752867458;
	bh=Gy89B8eBPYqTjZYZxBZcqYcBkWuRE4RdtCdTAIjObFc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VLDBlyFC9XRarJyOSEPFNhBoob6grJOb2dDYH28rDciRcuK1FtOOds0hFJZJvpVMq
	 7yzceYKBRr7gXc+FijNLge6bAWz1VGXhtHnlk1xFPv8VqcPMyQbhgoXETKyXFTm73H
	 Z+O4Buwp4fQqDCqwmNWNKUDh/nKBzjeWB5j+a62wIGsiadIMIlWpp72EbHoCodve+7
	 lEFbc+bbob+M7ZITTpoVcl0haTOREXtzfYZ5iNLaQuOFzOJPGigHKMSnYDIbK8rJR/
	 6TzZog9Tse6YURxJoVM9KnXjc5PMBhl9pSYKA6wtwbLyuzmY91PGsXej0seMM9n3jE
	 6REVciuMQmXNw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF09383BA3C;
	Fri, 18 Jul 2025 19:37:58 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.16-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <7c756cba-904d-48bc-99c8-d21f47db1c69@kernel.dk>
References: <7c756cba-904d-48bc-99c8-d21f47db1c69@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7c756cba-904d-48bc-99c8-d21f47db1c69@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.16-20250718
X-PR-Tracked-Commit-Id: c7cafd5b81cc07fb402e3068d134c21e60ea688c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e347810e84094078d155663acbf36d82efe91f95
Message-Id: <175286747762.2773756.15185404253147416628.pr-tracker-bot@kernel.org>
Date: Fri, 18 Jul 2025 19:37:57 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Jul 2025 10:53:03 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.16-20250718

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e347810e84094078d155663acbf36d82efe91f95

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

