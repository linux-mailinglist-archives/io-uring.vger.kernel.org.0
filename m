Return-Path: <io-uring+bounces-2430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CFCA8926735
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BBE7B21C87
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 17:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F928185E52;
	Wed,  3 Jul 2024 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s4W8apJi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01F3185E4B
	for <io-uring@vger.kernel.org>; Wed,  3 Jul 2024 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720027924; cv=none; b=RuUPcriL0vNiEt4HhHKZI2SuAVMjeBqj1MizlXqZjqfbDcFCmf9LEBF5iTUKsFj1JDOyOuOPRqpFauHbJtTSWgVXxjryB9FNFfs7ZTJ6P955MONxECCAxgflwTnVFo6R4o7FRNO/b7f75cszttXu6nZk9WYH3kbuhbvfage08R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720027924; c=relaxed/simple;
	bh=uWEjbdo+KyxxXuxmMRfXrAzJdp2YZ4yrTyV4MFakoVY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hODPyQm8mw8SngNSb4YT2xoYHdF/T61CxoY2YKcjOGFu05V/GPB8CJIY0Lq39c4nigu125ZzFOIWZJ9/kPh02jz+5t7FMRcTuVdStlinzT8M89VJymcoEQbjwH5R1Tas7HQTibVS1OLTS34xtrnc2pvVYFsIsfQggVoN/AemOlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s4W8apJi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7322EC2BD10;
	Wed,  3 Jul 2024 17:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720027923;
	bh=uWEjbdo+KyxxXuxmMRfXrAzJdp2YZ4yrTyV4MFakoVY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=s4W8apJivtWUc4anZoVa87/hDtjy8CprT+CohxnVSyEcMxUgB+P4uEUDEOh5tj92W
	 ZLc0ksySZF0X+Wsxh+lCmCGoOGa9gu16gfVlXGSGL/rk+hsoh2fdbhw3LMflkMbIxl
	 rBaE+njmkDWVwW8kjgbFk/AHjQOt7OTWQ57jdyxWWSASzIMua42iQWyC5VMfrds0QF
	 nm9mDrdOsfmBGrBtkDcc3T0YjntHxjAxqyvJSXsbIUQQsziK53U6BQVvej9Bxifq90
	 WpYT0L3hJAvkePzQd5Y3q2NBnnLZeTqRGs6Pp9lVNpL1HEVZAZMyp62fWaaIrDirmS
	 l0pE3TXAMwFsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6936EC433A2;
	Wed,  3 Jul 2024 17:32:03 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.10-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <d55b363d-2bd4-48c9-b2e5-92fbae147cb7@kernel.dk>
References: <d55b363d-2bd4-48c9-b2e5-92fbae147cb7@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d55b363d-2bd4-48c9-b2e5-92fbae147cb7@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.10-20240703
X-PR-Tracked-Commit-Id: 6e92c646f5a4230d939a0882f879fc50dfa116c5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a9c6c40432e265600232b864f97d7c675e8be52
Message-Id: <172002792342.9712.4832414241469308982.pr-tracker-bot@kernel.org>
Date: Wed, 03 Jul 2024 17:32:03 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 3 Jul 2024 07:49:54 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.10-20240703

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a9c6c40432e265600232b864f97d7c675e8be52

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

