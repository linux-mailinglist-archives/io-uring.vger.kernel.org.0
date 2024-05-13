Return-Path: <io-uring+bounces-1892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9173E8C48EB
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 23:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ED38B23CBD
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 21:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF048612E;
	Mon, 13 May 2024 21:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgELcRpU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BDB12AAF8
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 21:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715636024; cv=none; b=nrUXc0w0SX4yowN9HG1DGg2P7YFktq7w5zp8CeiEGDD0Fq01XP/ukBpEvD4GmiSPReEMHAWVqfV4XlyV7XHx3aW2HhZCL0YRS/ZCoklY9KqHZyZO7EIxzNRoU3CP2n7C2I2uB3/LohG937cvTY2cGNyCsSMWlyDAu3/k0r5x75E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715636024; c=relaxed/simple;
	bh=8DNmwEwWKESYxllOIt083LlezJvMZPTXIOY3RV+8kDM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cQ5nghX1JbNMYp7frVycvAiMLRHcK4NFRI1D8JXUiabSdG1jTzTPk0gwTUpv/BLMsJjVCigSqD8EwZoKZ0I0GL2jZe1UljMy+TwNmOSxZiIiWotK0qYSk7tGrSdf4V/1L6nb0SmnXH2sDbvUETmJjv+JPL8k3ZGfY4j5a0SaQNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgELcRpU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0464C113CC;
	Mon, 13 May 2024 21:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715636023;
	bh=8DNmwEwWKESYxllOIt083LlezJvMZPTXIOY3RV+8kDM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VgELcRpUMJqjF3tbmLCfR4kw52BS5gpw1fqCxBuoAUjhknI4Pzoj3IuTPXYr4wwX7
	 lOkjCG2XqNyABprHx6Ov2L1C+e++4kJV8PCDZiWJ4PGgIB5ZUEhARwUIhT8ctcmFeC
	 WOFZznrmXZsXwHgn2/G+6iolgvBsS14cYTRw7EuGe1Xaiu3yEMbdwh1yYs04o0PENP
	 0QsedkQM61DCbITC84KpGYMaeWP+cnfJJyv9saGia+818Cw/hw1Wwo8eOW7vYCpAxe
	 wfLAxBssS0hM5mBus7YaSCFs+gD07DGrf2gc6V/FcFYl2VwgfDXVsEmjVh/0MsI+Ma
	 3kzhpIwoD3iXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5DB9C433F2;
	Mon, 13 May 2024 21:33:43 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <fef75ea0-11b4-4815-8c66-7b19555b279d@kernel.dk>
References: <fef75ea0-11b4-4815-8c66-7b19555b279d@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <fef75ea0-11b4-4815-8c66-7b19555b279d@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.10/io_uring-20240511
X-PR-Tracked-Commit-Id: deb1e496a83557896fe0cca0b8af01c2a97c0dc6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9961a785944601e32f185ea696347b22ffda634c
Message-Id: <171563602387.15304.1649146647239433122.pr-tracker-bot@kernel.org>
Date: Mon, 13 May 2024 21:33:43 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 11 May 2024 08:02:55 -0600:

> git://git.kernel.dk/linux.git tags/for-6.10/io_uring-20240511

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9961a785944601e32f185ea696347b22ffda634c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

