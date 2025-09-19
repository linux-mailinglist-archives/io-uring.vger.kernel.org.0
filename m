Return-Path: <io-uring+bounces-9855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D66B8B2E2
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 22:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0C3B5A7D0C
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 20:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7B42EAE3;
	Fri, 19 Sep 2025 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9fNqzbg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E132AD24
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758313124; cv=none; b=iTkUq13sgRuomsHED0tVLMLRrhFos5uSAHimZQKQ857DlGhdj7CMDzzX/YGIGtJc544YW0HJztHWI1cvXsg/+qqsKyXxUmpIGdSr9UMvKcrxrM8HKlykal1QTcZiLTwRYUun4kQQQOnaqqH2KWFC3tPFfXpdSBF1JDomMEbhzLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758313124; c=relaxed/simple;
	bh=mKF4qDOOrSSWnCzWx5rKCloB9tkpYZ2z8/yUbsG95ik=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oIv5ef12AOxI4GhYQe7fmfz6KfuotFrT8qL0g28+OpFa8M5/o71XZzKzHiiJijVvNWoMnAWSHUAYelnCdUkcXHnqY7pvxofwsMAFRMEIbsXt1fUK6f2lmLVKhTSVrhuXbiA6Waq8gRHBd0rZN1W7RRAWxLalPEoxRscyssV/1rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9fNqzbg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC033C4CEF0;
	Fri, 19 Sep 2025 20:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758313123;
	bh=mKF4qDOOrSSWnCzWx5rKCloB9tkpYZ2z8/yUbsG95ik=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=a9fNqzbgDV2/FGTMu45BSmIRzzruuUaYUICUmaJNojc2BF3rppOfy2HDBMI4jjbn0
	 FGdkzlfc1fOXYlQSemdFMjgbhic3LACsvMlZLADUeqDossF/oZFRThDIqaHiJn4Hqc
	 saAyXNYTAFPkwhUFTzh0fHL5haUZNlhnxeQcGQpQaZIrNYJJ1dr35QD6LfiTX/CHWA
	 cikL5oU7A2SWjBSihxJsVtb5++S5eKGeeseaS9z44d3FiZ+9qkKJCaf4nEZa7y6PcW
	 w54vZm7IBXbaMJg0MKOXHxan3pPUfxh+isUvQDhSy3RDkB2llZIzOzXkk1zklA2v0q
	 ktAVVFaVoO7VQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E6039D0C20;
	Fri, 19 Sep 2025 20:18:44 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.17-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <7102d62a-bc57-4bd3-b74f-201a35c770c2@kernel.dk>
References: <7102d62a-bc57-4bd3-b74f-201a35c770c2@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <7102d62a-bc57-4bd3-b74f-201a35c770c2@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.17-20250919
X-PR-Tracked-Commit-Id: 2c139a47eff8de24e3350dadb4c9d5e3426db826
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0d64ebf676bdeeb2df99377193830f01f92702bd
Message-Id: <175831312313.3686704.8639193008172677136.pr-tracker-bot@kernel.org>
Date: Fri, 19 Sep 2025 20:18:43 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 19 Sep 2025 07:52:07 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.17-20250919

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0d64ebf676bdeeb2df99377193830f01f92702bd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

