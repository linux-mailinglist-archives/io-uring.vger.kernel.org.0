Return-Path: <io-uring+bounces-11357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 587E9CEF4DB
	for <lists+io-uring@lfdr.de>; Fri, 02 Jan 2026 21:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2ADF630124F2
	for <lists+io-uring@lfdr.de>; Fri,  2 Jan 2026 20:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B7D2773E9;
	Fri,  2 Jan 2026 20:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNq7bq9K"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D4A241103
	for <io-uring@vger.kernel.org>; Fri,  2 Jan 2026 20:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767385352; cv=none; b=V3ybiueCduNVozzTingie2lU6Kec3y2z3uSjyACIFZw/OQDJMx9oTS0tsyC/CSpm1GW6bh267QdohvFiCQ20RedGDIJGCqxJFgnorvkhkaQuCrZti6tI7sZ1jilSMZUeeJrPHE82wXJ2VrD9v5oTL5G+ChSNOSwpVQOGlq9xTaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767385352; c=relaxed/simple;
	bh=Bs56puaaPVTTcada2Ezk0GobDnwHK2VZ16hPo/C6ZQI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OtA5hT33BXaA1hU2SbHybzyLbcUKwKKoWhqVLToKqSR1kyG+RItJ2MRHaqtEVOdZv3uLfV72gyTuRY4nssKxb36fZ18UtibgwevYwyvZUra6lT7CYd7OQ3oRvSZzRk3UuRsdvju16cgSnbdZ/+qLPJ45+9hgOWDr4EYbAn6QUNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNq7bq9K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E893BC116B1;
	Fri,  2 Jan 2026 20:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767385351;
	bh=Bs56puaaPVTTcada2Ezk0GobDnwHK2VZ16hPo/C6ZQI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hNq7bq9KYHWlogGCjRJVyQAuxl+aGyVRVAbrOY9j4Ge0semWgCuwof9/Pj7RJDLMI
	 4VtHcn9zS3ErNZ0h/mrT8sjBAb01L/gYy+XGt5MrIQLr7vSewFW53GhYTxjCMqX3bY
	 U5Ab5GoXArjpeINe+MXIbvuxuh8il28so5S50940rot26Fc5UM5PW0ZYLMdeXK2XrT
	 5yRv8xu6ofMr7r3VzepW0HqqX2XfGOhkoqkYplmsMvWhM2EP2HcIP6mx+0dHJ6LaEJ
	 4r8cW6v+gLuh2zmyMkJIIaC17ya8Ju24qkUcfGMbr2HoXJrnt1qgBISWCTKXA/Lbak
	 8ZMe1hEHfoimw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B83A380A962;
	Fri,  2 Jan 2026 20:19:13 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.19-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <787b104b-ffe0-47c7-9f8d-513847bcf6d3@kernel.dk>
References: <787b104b-ffe0-47c7-9f8d-513847bcf6d3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <787b104b-ffe0-47c7-9f8d-513847bcf6d3@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260102
X-PR-Tracked-Commit-Id: 70eafc743016b1df73e00fd726ffedd44ce1bdd3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 509b5b1152181447bb001f7beb0a852530ad2a74
Message-Id: <176738515173.3999225.12131989484748898357.pr-tracker-bot@kernel.org>
Date: Fri, 02 Jan 2026 20:19:11 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 2 Jan 2026 09:08:54 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260102

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/509b5b1152181447bb001f7beb0a852530ad2a74

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

