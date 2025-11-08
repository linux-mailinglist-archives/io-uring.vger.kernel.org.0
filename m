Return-Path: <io-uring+bounces-10458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E758C43145
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 18:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 01C984E7B4C
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 17:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7CB6229B2E;
	Sat,  8 Nov 2025 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIDxUw8G"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CC725771
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762622140; cv=none; b=YXCbkjVXBpTL6TGdImRsZhHCHEIlRataJouSaVgYQ1nUUR43/JKaYvXk3LHOR/LkgQIgP0drhqAkbYuJ1rzvH8tE8lHMSg8KvmvinqYHsFS2359owi7HRoag89ti9MTq5Wm5pyX4qyKr2jC5XrKl34PALTz9uOX1MqdSKsyVClE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762622140; c=relaxed/simple;
	bh=bXhgwHEDQZffe8ipER/dpZj8nwb2DO1IDQGFv5fJ1oQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iygeWXxC95EtNJJGa5qyG55oxGd1zG2OjkrxBgw81fPcsUPo0mzlA2QwGmdUIvqrF3TuJAOT1vrH/8ULTgB7roi3RbMg9HgPKQ3vITyhy5UiYLuvIwRS68USIL1+wav6BqVko05/u9jJWnWHi8ff9orrQjBq2ZPevttczJ2m54o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIDxUw8G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69832C4CEFB;
	Sat,  8 Nov 2025 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762622140;
	bh=bXhgwHEDQZffe8ipER/dpZj8nwb2DO1IDQGFv5fJ1oQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MIDxUw8GHfuqYjZ5Az2WThqWyM3JKZ7Z2JVT+Sb39pJjkn22u5UaWEw3tQAJ/wMO/
	 sVY2rV2dUlO/7TUKcqi2ioyO/F/akKQhLiMQJoqrfrQT992qDBcr0pNW3NWxajYjNi
	 /uyWneHWrI/JUey5t2PSKYXbEm1AgqJDnmKkwPaHuTB1P8+66ySudeBhON+3uVMlEj
	 s9KWGarMz/USahhLlVJiihxAUxiKT7BP94HyFNd6EfDCEX1KqI9XnVa28pZMz6ykQj
	 KpwKN5cAN412+sBIPWflzQt1vdAxeCBVzszA9iYYDKmSwtevgJX+5aLFDIfJf+wZrV
	 Te274K+YHiVYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 710533A40FD5;
	Sat,  8 Nov 2025 17:15:13 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.18-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <62289a4d-089c-4f3d-af83-74b50a929025@kernel.dk>
References: <62289a4d-089c-4f3d-af83-74b50a929025@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <62289a4d-089c-4f3d-af83-74b50a929025@kernel.dk>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251107
X-PR-Tracked-Commit-Id: 146eb58629f45f8297e83d69e64d4eea4b28d972
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3636cfa745e6a4ff0142e29068750439059867b0
Message-Id: <176262211190.1365123.4874045517527416214.pr-tracker-bot@kernel.org>
Date: Sat, 08 Nov 2025 17:15:11 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 8 Nov 2025 05:12:15 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251107

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3636cfa745e6a4ff0142e29068750439059867b0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

