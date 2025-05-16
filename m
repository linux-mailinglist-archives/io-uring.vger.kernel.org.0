Return-Path: <io-uring+bounces-8010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8EEABA343
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9858C3B762E
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9507427FB06;
	Fri, 16 May 2025 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlrffWm1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2B827C864
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 18:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747421793; cv=none; b=Xo3NZntqNHLM5rcidt0eFl6vMQASxvP16ccLR0wYFf8j2AjiSt2rPj0wus+gq+3Z+lLzFw9cq1fz4rHC2NggCAZwAA/TkO9COTTH2NigaNxXnHdKuu/q+igomtLCaqe7LNbC2H+dI6+pLQH3elqTQFEkV2K/QBkQSWjUUAjTLlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747421793; c=relaxed/simple;
	bh=ntaqyFBOiL56Knp+LRv8+2pU3flHPNohKRc5qhQke8E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NsyrGGzKt+UU4+Zacj6X9uXXGdGJuDL+IKOpxSgzivaoWGR6x5Fe0/Xy4xShVGSX5PE0aQeqUzK3DRiVLLJQAhky4roIdrv+POclytWjRDcsDgEO2KoM26gZZ7DAzQO5YyUKsAXWIB9VcPUSzBNMiXPclj1dQOBi9cdfFlX4wmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlrffWm1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD12DC4CEE4;
	Fri, 16 May 2025 18:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747421791;
	bh=ntaqyFBOiL56Knp+LRv8+2pU3flHPNohKRc5qhQke8E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IlrffWm1EseKuQyuMjQzxvJotACr8mMd3w4qkGLxDTRsSdQhWZCNeZt1Z8rpYdTVR
	 DNKc+IBLsoIU7kTkonx1evHxjr+qSseArqMFSWShJnc8zUOqt8moOPiaAPdZWWRGlo
	 QIqc7x8yvkTryhrwsFzrG/DAqh/FGWQBVb4LNcycWqmkAG2GZxNPh5iBNmsWHgq0Lo
	 LHMzakutTKM7HHE+UPLytfuYyG+sLSb6IN5PIcjTLF3dcvTqnlT7L0OY/tvd8XSp8R
	 6ukYs6D6mpaUNRStUqDUyoZkLIh6MuQlFoKIvidLJtxfNwQkrdr2LlYff08PzVgcEr
	 ukUBSERSRPg+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EADA43806659;
	Fri, 16 May 2025 18:57:09 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.16-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <a27ba3d8-e12b-4d0a-919b-6874c2b3b3b4@kernel.dk>
References: <a27ba3d8-e12b-4d0a-919b-6874c2b3b3b4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a27ba3d8-e12b-4d0a-919b-6874c2b3b3b4@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.15-20250515
X-PR-Tracked-Commit-Id: d871198ee431d90f5308d53998c1ba1d5db5619a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e2661da1b302c7c80ad2306bde4d324956cff26c
Message-Id: <174742182864.4031545.9534400675348593171.pr-tracker-bot@kernel.org>
Date: Fri, 16 May 2025 18:57:08 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 May 2025 07:23:20 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.15-20250515

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e2661da1b302c7c80ad2306bde4d324956cff26c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

