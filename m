Return-Path: <io-uring+bounces-8091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D810AC156E
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 22:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 585FF1BA7B31
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 20:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C674153BF0;
	Thu, 22 May 2025 20:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VkWhcses"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1761718D
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 20:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747944975; cv=none; b=I679TJY+rWbP5T7LLwwutcR8XgYdiEKDebU7++cAjnZ9ptFJ391/u09RTCQlnMiGb86ZlJoAlpqHmzFT1NlmlcMO0y4/xCwKzr6S/fBmSXwmkcCF8CfU3N6vGudfTzFMAbXbwPZlmS17ftKn7EuJq/MlU+H8gYN2+qdBL1KwanE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747944975; c=relaxed/simple;
	bh=M1k2nLDcs5BWQUVSKc2lTbSJPXFuqaeFlVawnaBJmWA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pulvl6WSiyIqAKD4muP/NHQttk2ra68l/1VzX3/a1NyJJVsruOieH/QzfhbDNRmoT9kK5lMUO3bSU1qfp9DNhy7DEOT3f+eRbEKZ/JVL2KvlqjpQ5nd3aUuC+hvor9JbyaRPnHAFB/GmqvRhy+bl81S9n0HR7EJMq+RHQhYB2ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VkWhcses; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898ACC4CEE4;
	Thu, 22 May 2025 20:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747944974;
	bh=M1k2nLDcs5BWQUVSKc2lTbSJPXFuqaeFlVawnaBJmWA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VkWhcsesPAsFBVMmvDsgG5MjcNnoIxq9fXp2jTp1BenEcSvtzy5XIZE5WY9G0TKAj
	 JpIGz2hdUZg4FP+m+K4kjkVodFJW/mu1Im+OBATN0W+dPfq426zCVFjc1ksuVIQ9J4
	 qCPwKlzs9YtMJKSpfrp2+pps4lhHgqbWEOtxvqgx4ULUVKd4c58up/PN0i5yD5lA6r
	 cJeMEFmB3nCEXjnutuS6oPziiP+5sLL53SGAIgZh3sIEmcgkf/pP42uZcfbpHepEDk
	 r1rVBSkVk6SgNozN/vu2TyQ/XZGrSfi/pshwPL5tvQttIPyXj1TpocJzX95rjFVdVh
	 qUoSRWOo2WktQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 340923805D89;
	Thu, 22 May 2025 20:16:51 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.15-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <a23908b7-210d-4037-8f86-48ceaae03453@kernel.dk>
References: <a23908b7-210d-4037-8f86-48ceaae03453@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <a23908b7-210d-4037-8f86-48ceaae03453@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.15-20250522
X-PR-Tracked-Commit-Id: 3a08988123c868dbfdd054541b1090fb891fa49e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ab719cc7f53b2b84bea96640aec1c3092870766c
Message-Id: <174794500984.3008483.2714204948401390644.pr-tracker-bot@kernel.org>
Date: Thu, 22 May 2025 20:16:49 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 22 May 2025 13:56:34 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.15-20250522

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ab719cc7f53b2b84bea96640aec1c3092870766c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

