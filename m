Return-Path: <io-uring+bounces-18-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AED47DEC14
	for <lists+io-uring@lfdr.de>; Thu,  2 Nov 2023 06:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90BF61C20E03
	for <lists+io-uring@lfdr.de>; Thu,  2 Nov 2023 05:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848421C37;
	Thu,  2 Nov 2023 05:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOGe+Iz2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618191C20;
	Thu,  2 Nov 2023 05:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B769BC433CA;
	Thu,  2 Nov 2023 05:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698901260;
	bh=acJj6QFcIDiHpvL6RASrOmVS0BORK7CIFOgwimaCzUw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GOGe+Iz2zczVZ69TSqNEe/oPunTip9BQfNJtQzlDddzOtSQkRE8a11bEmlDNgSNgC
	 xI9vOafsfx+2SIvXkpX9SvZZWQ8FSEXUz2TwZxAvmfmtuPqJdzULBQKBE9DumXweXg
	 0gjcLrtyugAr1lVddezLYV1ApKwhKX+W84lZ6+ijELAspUNsyvYztZ0g80RSIBxcq0
	 6kDQ+tIWlV4Rxv8R4sPgBj07ABHPsYoYd1xfHfKnUPhuFTj6YVPd8F2riDU3iPoYEB
	 sWcYvq41OUkNsbABptxiqQ3ALs2hYlV96a9p7L7lJYNWQiky9SzE37/42YKSMNnTJX
	 Za0q7VFH2RVhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D4E6EAB08B;
	Thu,  2 Nov 2023 05:01:00 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] io_uring support for get/setsockopt
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <169890126064.18253.12714422524953116222.git-patchwork-notify@kernel.org>
Date: Thu, 02 Nov 2023 05:01:00 +0000
References: <7a0893f0-bae8-4aee-9e05-7c81354fc829@kernel.dk>
In-Reply-To: <7a0893f0-bae8-4aee-9e05-7c81354fc829@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: torvalds@linux-foundation.org, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, leitao@debian.org

Hello:

This pull request was applied to netdev/net.git (main)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Mon, 30 Oct 2023 08:36:04 -0600 you wrote:
> Hi Linus,
> 
> On top of the core io_uring changes, this pull request adds support for
> using getsockopt and setsockopt via io_uring. The main use cases for
> this is to enable use of direct descriptors, rather than first
> instantiating a normal file descriptor, doing the option tweaking
> needed, then turning it into a direct descriptor. With this support, we
> can avoid needing a regular file descriptor completely.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] io_uring support for get/setsockopt
    https://git.kernel.org/netdev/net/c/f5277ad1e976

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



