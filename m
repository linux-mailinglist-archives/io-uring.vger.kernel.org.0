Return-Path: <io-uring+bounces-8115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E04AC4409
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 21:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A43E189B28D
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 19:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B1616419;
	Mon, 26 May 2025 19:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYjzRPfu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32951D63C5
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 19:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748287144; cv=none; b=PaK3lQ+lTqIqyUYGO7rCc4sGHmUGcw50YxJDsf+k/TrRIan2R0DZ7paeJ72w3nm9Y9uD+1dXdoBx3oitQpe00fRPhKxyEQ2ECCB2TVhAL6clXCOO99o4JdPuv2gzyQWSD2woS2WuzAWc3ZCd+y6bnrHmTX87tQi/8XaFcTc/Quc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748287144; c=relaxed/simple;
	bh=9XiymMonCxGSN2xwIyErCop9n1PAMB2agz5RWDmkA/Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PzaEs50dp7UgLlMtO7GkjSCA45DnJxqYD4X5a9ql1ZV0OYLQ+frXjRuu6IOn8BJfW0fBq8KTis+rRsKb1pMQR1P2o08wHBKy0ia8JlLggjdnNQ/ZOx6waXJ/yIWR/el0C17M5TjOz6EB8UjCCxcTqfV3t+Tq3OLbmJ0KbnGLNQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYjzRPfu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E07C4CEE7;
	Mon, 26 May 2025 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748287143;
	bh=9XiymMonCxGSN2xwIyErCop9n1PAMB2agz5RWDmkA/Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZYjzRPfu3Y8SrWtCaWC6iQh6Sv1/RgmcShhOOaH13ZdziItmfqcKDKJWZIKVtvse0
	 II4dsFU82ZKM/jW6cq8i4gaaRTqvb6Jfk0vF0RvUlwr1MAHMy5nBeZt9sfyzFckS+7
	 INKK+J3SRmpyL+fBqUy8Hi7fvtRQAKgqq+FEqVswPnFfqtcjXhteOwqhP6Lbl+dfre
	 eqtEaKRqx7PF/71hVBS4hZeYzml6MVq6wktC6L9hsBSfiW52wJKH+KeCUwxxFjENag
	 pRuDMqNgpRfxkIHNBzemZdPsg8y2g9comKxbEqnHke3GTfYPskxv0XLx/PyZ8Fhw0n
	 gsjOCXnkdGXkA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D2D3805D8E;
	Mon, 26 May 2025 19:19:39 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <1849db19-119a-4b1f-8ed6-df861d7d9c8f@kernel.dk>
References: <1849db19-119a-4b1f-8ed6-df861d7d9c8f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <1849db19-119a-4b1f-8ed6-df861d7d9c8f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.16/io_uring-20250523
X-PR-Tracked-Commit-Id: 6faaf6e0faf1cc9a1359cfe6ecb4d9711b4a9f29
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 49fffac983ac52aea0ab94914be3f56bcf92d5dc
Message-Id: <174828717786.1020600.11481186279957343391.pr-tracker-bot@kernel.org>
Date: Mon, 26 May 2025 19:19:37 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 23 May 2025 14:45:14 -0600:

> git://git.kernel.dk/linux.git tags/for-6.16/io_uring-20250523

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/49fffac983ac52aea0ab94914be3f56bcf92d5dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

