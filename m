Return-Path: <io-uring+bounces-2805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B937955237
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 23:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2795286FA7
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 21:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C461613C9CF;
	Fri, 16 Aug 2024 21:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q44EH0zV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B2C129E93
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 21:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723842452; cv=none; b=KNjOZ/Qcl9fQYgAfLH7Oc5UjIpB2Cgv0TCoAAeVr4u2i67/MLfMrxvKL6jK9UNQAJGJ4+hb6cxJdYbUGquUWCbS0q/PjQijo4vqX3JpWkJtRZhIb6ags0Ck3w12d/EoVkGV7HGh64EETuVBCNLFMoLiAVeywc+C4znba20paK44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723842452; c=relaxed/simple;
	bh=18mAXKjxgyOctfp/xZP3PWjoTyqNP1sTXq3mkimZguc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VTdacUV5aDfXuuPGAcJ/dr7igYiCJozhkOINfI0qSmJE9xlkpiJi1DD+FQxFhoOi/kESLXPMk3mYM5UKENwFYJfkBam83RhMO2hYp262K+ic1cvg1kEBUcwy+8eq9MaP88N8ZIOCVuRzkJCg9tId89IAn9qABvg1N47xjj8RRfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q44EH0zV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27321C32782;
	Fri, 16 Aug 2024 21:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723842450;
	bh=18mAXKjxgyOctfp/xZP3PWjoTyqNP1sTXq3mkimZguc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=q44EH0zV2u2qPM56fN8Iz21e2DN0zXuxzqIw+qmIGHCqkegpdON+XwgROpugSpqFJ
	 aHCMHlsMcuDESzGuW0GL4HSQ4YGIpZAU91O/BhLVJdh04FFxt1P3DTvR7+NdcGaLGI
	 WreisbyO/sMlnnXYGTsbO6xogKLUEhX3ZhbnT0efq9NsfM/JF+HWZoPUUy/F/+5f19
	 XKT5G7rBCg8unl1VzARTV8M8tf7UXHVjJDs2IDrhnU1POzTBj1X+/JEVx/jhAXmNUP
	 hpWq4vqKAac3HDMZqniVXI7g4Pber/hVLGYFK1FZXW+1ezyJU7I3EoH7KWMvWNKrhR
	 UVGRVOhu8JnLA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADB4E38232A9;
	Fri, 16 Aug 2024 21:07:30 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.11-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <7d38d674-e5ce-4311-80ba-d9c8e267c414@kernel.dk>
References: <7d38d674-e5ce-4311-80ba-d9c8e267c414@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7d38d674-e5ce-4311-80ba-d9c8e267c414@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.11-20240824
X-PR-Tracked-Commit-Id: 1fc2ac428ef7d2ab9e8e19efe7ec3e58aea51bf3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5ac744cdddae82916d4cd35d962d3f47065e68a
Message-Id: <172384244925.3626293.1252701328960652076.pr-tracker-bot@kernel.org>
Date: Fri, 16 Aug 2024 21:07:29 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 Aug 2024 13:00:38 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.11-20240824

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5ac744cdddae82916d4cd35d962d3f47065e68a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

