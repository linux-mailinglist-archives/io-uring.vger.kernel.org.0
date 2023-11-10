Return-Path: <io-uring+bounces-81-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D8A7E826D
	for <lists+io-uring@lfdr.de>; Fri, 10 Nov 2023 20:28:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 062791F20F12
	for <lists+io-uring@lfdr.de>; Fri, 10 Nov 2023 19:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D6C3B28A;
	Fri, 10 Nov 2023 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCkDOaTv"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923BF3B287
	for <io-uring@vger.kernel.org>; Fri, 10 Nov 2023 19:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19F7DC433D9;
	Fri, 10 Nov 2023 19:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699644533;
	bh=Z+QihD8wri0pHLdNYIiNpA0I3CARZ5eBCu2VXEsab+w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pCkDOaTvGXGM3LiyrB2hXaLvhAKQigMo4fRM7aViBfcBvYEFbza8W6CDqUYKKXChM
	 zBsILnxq6N1HagdKAvTh7S6qgjdhLeZHkI5KLdIMgDeSuuPWyZgYr5qvy4wMru6ewH
	 R2L08jk6v2DCQfqBj0wa2vStTlCqowxXNEj13XSpixr5Bn2xGx7zqrTwEq1hKJ48a0
	 WE/et6xC15R0BVikT7korHkhb4IjL9/RPFeMcEVJqdzRNDez0zptov/7mKNAs7iqYY
	 kv8Bt9fegQXp5clIcRJ0D8HInEJlxP8p5EUhKjn3SXMTCfUXQ2B4NIAID0rHij7Oc+
	 6/eP6Vh6yExpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 080EFC4166E;
	Fri, 10 Nov 2023 19:28:53 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.7-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <d0e69261-4d09-422c-a5f9-8a1015da0466@kernel.dk>
References: <d0e69261-4d09-422c-a5f9-8a1015da0466@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d0e69261-4d09-422c-a5f9-8a1015da0466@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-10
X-PR-Tracked-Commit-Id: e53759298a7d7e98c3e5c2440d395d19cea7d6bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b712075e03cf95d9009c99230775dc41195bde8a
Message-Id: <169964453302.4685.12243487500199419275.pr-tracker-bot@kernel.org>
Date: Fri, 10 Nov 2023 19:28:53 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Nov 2023 10:32:51 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-11-10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b712075e03cf95d9009c99230775dc41195bde8a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

