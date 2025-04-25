Return-Path: <io-uring+bounces-7721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A282CA9BB87
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 01:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD06D1BA67E4
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 00:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5E0288C8D;
	Thu, 24 Apr 2025 23:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFgGRM6Q"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6E820CCDF;
	Thu, 24 Apr 2025 23:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745539190; cv=none; b=AlOlaIOcocTFyL19EinGXa4iYkjMdhM67aEl5O3y6R3qcTIHDhVQh9KKidfbG8CDzppOgRX3mPWlemqGwGWNjZYM1yUKch1DVaiso8RBDkAGd9CeiSIc1QNFppJn9PYe5MiigoWdi5AnHhj079fWOAiR6zfK1oxSMLeQYsTI8kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745539190; c=relaxed/simple;
	bh=uxkWEhvEgjBl6+I8KJLSIovkjWIVOEjUEOCh39u1z3k=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=dZUhmHyV4dPuYRmtJpus3tx4uwM6YlbloaC3FGo+qKdHkLEPVfgfFHkRDkQAKnCtlOzZZcUXacV+n3m3/Zzrim+mBxfKO/vq4x1rFL4lTN2u4+A/q5tECrH/dtdlaJbUPKcoFwmtQfUWloGnldcTKgBSl50eaJehWLxkrQClLfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFgGRM6Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7ACC4CEE3;
	Thu, 24 Apr 2025 23:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745539190;
	bh=uxkWEhvEgjBl6+I8KJLSIovkjWIVOEjUEOCh39u1z3k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZFgGRM6QbzeSdwwFR+7RNV+Y5bfTFD+NctRfb4wervVFG/LXp8wnWv0t2CbeIdi3h
	 XXGcUnqRYTZmyapJdM1Yul4l/5retcr/1KvcAq8Hs7t0EGt+BJ02tdPxFBkl94PDv9
	 qNN8LYMErTMlIB63G9PJSc7EOs/wEO7lqcPh10cnUHTzmSNfuet5ZmTIokfjXBxS9n
	 4T4uynO1EH43sUwGhNOp8bVHeeA5lba4JnaUTypTEAnFAsID9XdpEAC6/Ad70UEU0e
	 GcDlDsQTB3XiSzsHTfQeIMOpuqmPoZ7mPGXQ8AtM72Rs7o/wzsolEyGbFdPE7zQ6Vl
	 U/X+KCtLmdv3Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EADCF380CFD9;
	Fri, 25 Apr 2025 00:00:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] selftests: iou-zcrx: Get the page size at runtime
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174553922875.3525507.18267700755622543899.git-patchwork-notify@kernel.org>
Date: Fri, 25 Apr 2025 00:00:28 +0000
References: <20250419141044.10304-1-haiyuewa@163.com>
In-Reply-To: <20250419141044.10304-1-haiyuewa@163.com>
To: Haiyue Wang <haiyuewa@163.com>
Cc: io-uring@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
 dw@davidwei.uk, axboe@kernel.dk, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 19 Apr 2025 22:10:15 +0800 you wrote:
> Use the API `sysconf()` to query page size at runtime, instead of using
> hard code number 4096.
> 
> And use `posix_memalign` to allocate the page size aligned momory.
> 
> Signed-off-by: Haiyue Wang <haiyuewa@163.com>
> 
> [...]

Here is the summary with links:
  - [v1] selftests: iou-zcrx: Get the page size at runtime
    https://git.kernel.org/netdev/net-next/c/df8cf32413fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



