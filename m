Return-Path: <io-uring+bounces-7384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB46A7B258
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 01:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA5EF188224B
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 23:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F311C8613;
	Thu,  3 Apr 2025 23:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwlbHv6u"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28681C7008
	for <io-uring@vger.kernel.org>; Thu,  3 Apr 2025 23:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743722242; cv=none; b=Gqb7uPdrIXnfxSYQAYu2CdzaSnIw9YwzLRZHxXwCUaIEKUpFRrLZFol6eMe6km6ZnNINAAwlKXaz8LCW6xJEglgf/ZCvqL9WPlcsN3tLil+4G7U4t3hYFa4ejRsZyIInm4QmShhavF/pPQ+ArZnA6yXywGxrN744/0N0og6sS08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743722242; c=relaxed/simple;
	bh=LEH/IMR7a4wOWqD6N0kq9myyloeA7mWNhtvE4QioYIQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Pd4gG89vAa1+HntbVyfMmyiOlr07r7i+/KivK8+6Kzn3/s245HRZAVEWhCUcOJ8scdL8/QyknG90gxtKJ0ExrCXBLN0f1U/0BMGERr7bnhtwMjI73qIbvhwqsyGk29jU978oMRwmlfaQgwHmt9Dpv0TbqJUzU6+kCo9aae4yprE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwlbHv6u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B668AC4CEE3;
	Thu,  3 Apr 2025 23:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743722241;
	bh=LEH/IMR7a4wOWqD6N0kq9myyloeA7mWNhtvE4QioYIQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BwlbHv6uCKCvXTjRaF8nvWKV4KXNgx5kchlpKxIW9pEiKGB63j2F+M7f/nsulOM6D
	 A6l4eVz4Hht/S0fo3eACIm6Fv6JmItunSFSpbLLqGPdIrYIQlGvuefM6r7CxxS5UB9
	 0zwcwt+m8ubgAHbdHlnFyXWFE8w1JdmtZeboz3W6yj/8OK4P5EvMu6uccD09qv7bz4
	 SzRWM6NeTyDxN4uX+BZEKwyBAhwgrCNJNa5Nz0W7pxNEUEeTgQm36PKKY6oR6f2K89
	 TwNZwIFFOgSQykFuA+Vi3qajU1lBTJkqcgFyuauaRJEdckithGYmN92uALCxNsaAc/
	 zg0JtiINsMrQQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB1C1380664C;
	Thu,  3 Apr 2025 23:17:59 +0000 (UTC)
Subject: Re: [GIT PULL] Final io_uring updates for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <2f74c42b-7f6a-4d04-b7f2-e0ca5eb33ff4@kernel.dk>
References: <2f74c42b-7f6a-4d04-b7f2-e0ca5eb33ff4@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2f74c42b-7f6a-4d04-b7f2-e0ca5eb33ff4@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.15-20250403
X-PR-Tracked-Commit-Id: 390513642ee6763c7ada07f0a1470474986e6c1c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7930edcc3a7e2166477fbd99e62d2960f63cd9c9
Message-Id: <174372227842.2716716.13383232048547258009.pr-tracker-bot@kernel.org>
Date: Thu, 03 Apr 2025 23:17:58 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 3 Apr 2025 16:23:10 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.15-20250403

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7930edcc3a7e2166477fbd99e62d2960f63cd9c9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

