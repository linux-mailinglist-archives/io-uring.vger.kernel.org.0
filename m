Return-Path: <io-uring+bounces-2219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B042909291
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 20:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA90CB234F5
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7121A0AE5;
	Fri, 14 Jun 2024 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T60iJ1+M"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC3119CD0F
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391137; cv=none; b=o4D0B4eKE0b2AGGa7hQ2i61g4E3xHY41b4JpxLou7k8su6djQo1cJSVg4WOmMUuRyIKMUMu0C+sLWR2hdp9fX75CapieKWfPAfRKurDHVHxmBOEmQJGSJj3GpO1Dsm2Q1JsjJhLmkERCyZ/rtfvXRDpYRpIUm31Wt+WVrosSTKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391137; c=relaxed/simple;
	bh=6uLsx1YVJMHUifE2nIZYRMspDimcz4I0NUqY5JmK9jo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fZUnUdPkn2uRYTNX5xsvoc/st06eply/i6LJ/f4Gh/pMgp6thLW6gI6PrSwZy/KiTijQqQQp6Z3A+ndxUcGX8StmE5ZFUqaeNume0Dbbdq2q23+R3qUJ1xoSEiJ03L+nHk6sVQR8lF4GTMDGYdSc+AwsUr6NfivnU74jeWL+6Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T60iJ1+M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 079ACC4AF1A;
	Fri, 14 Jun 2024 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718391137;
	bh=6uLsx1YVJMHUifE2nIZYRMspDimcz4I0NUqY5JmK9jo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=T60iJ1+M5E0wC1qXmigSNVgfkAnI++e78LwXA6wjtqPVPLPJHt0B/QC/gsvO+yQ+L
	 KIenaTJZiKwXmPE/E8vv2vDq2yeifVjqLE6VXZjlEX9sftNbGYY8JJNk0Jher/7Yf/
	 URWILT97kDr3i5OD5VPzGvA2kwrbFxt/A5sQIln6pVirR+gRoZBroUjgTwUflTIrsq
	 jOjbg5KwPSA5n5KmreGA1Wf8qoG97a9e4hniCHZAC56x+LmmhyIX6iC4D6cVU7o/F5
	 tLSzwMcptvkEDi18QGlBKc49IG1DA2kvNkNSeZ0XJcZ5OILaGj9Ya5rwetwEh1l8OO
	 RyEPfI0pjtG4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F38F8C43612;
	Fri, 14 Jun 2024 18:52:16 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.10-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <ae3d160d-6886-47a3-9179-de6becf0af38@kernel.dk>
References: <ae3d160d-6886-47a3-9179-de6becf0af38@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ae3d160d-6886-47a3-9179-de6becf0af38@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.10-20240614
X-PR-Tracked-Commit-Id: f4a1254f2a076afb0edd473589bf40f9b4d36b41
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ac3cb72aea010510eaa1e19ab001a0d28c6eb4ab
Message-Id: <171839113699.28657.4847083972853013748.pr-tracker-bot@kernel.org>
Date: Fri, 14 Jun 2024 18:52:16 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Jun 2024 10:06:19 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.10-20240614

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ac3cb72aea010510eaa1e19ab001a0d28c6eb4ab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

