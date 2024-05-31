Return-Path: <io-uring+bounces-2051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C228D6CF1
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 01:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F6D71C23072
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C01812FB02;
	Fri, 31 May 2024 23:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjFE0gqY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D1B12F5B1
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 23:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717198832; cv=none; b=Slx/CIJ655jELYuN7EUJ8SOx/PuLPWH+PZlacsSFT/K4xXWV34Fdsti9YA7g+QZfkTJM73d0ut5Z0fRMAsFDs6o2xmofY19luAuwywaH41wO5dxH/cPLUvmX+MLxzoWzLrUbTTQmDCMOjPtM/gOKz962NSRqm9Oum4pKV/a2fDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717198832; c=relaxed/simple;
	bh=N4D6Z3hRVVP0fPA2kxaSgzuf8B7CH0LHo4TUNYlb1y8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=U8FEPIAt5w6YjuaZWXdQiBIUuzFNk3NXEYyeBZL5XmQohh5gALmqmKXvBIxYv1Aay1wMyvAEDy7un8le1GfzU+Z2R6w8CBbXSi+3gTSqK9t1kT7ldBySp8R11L6PUq5Notzek3a4/RVE15FBu3QSU9G59bjuxNVglLDp0K/81ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjFE0gqY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C89AC116B1;
	Fri, 31 May 2024 23:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717198832;
	bh=N4D6Z3hRVVP0fPA2kxaSgzuf8B7CH0LHo4TUNYlb1y8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WjFE0gqYNlJFYGGgFpoBzaaNUg31evd+1s1uwJ2e29ORtt1fVjiSJ2txJ5013cwx2
	 fUOJSc7HACHWNT9UdQQC1Ng30eEm2KJLvb5MR61HAsVdvTJpuKsTDXURhT81bkefzS
	 71Vuevb6JSq5FhPuuv0/46wAPxPK0w3l1juv9d8ka4ioERTtzFAZKPxERn2OhdFcU2
	 Vd9TavUjFH3kIYthnaQgFG/eFw07Fe2kDIlLHwtPOfuEqtViXMUrz5AyuXhg8WlC6F
	 jTWACYLLvFX2C0MYAG1lgVzkoFP6MVahe/Lfc3/4pIR+AkRtaS9KLeutjcK5OnYZ0s
	 0oxNHfcpg11ng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52F96C4361B;
	Fri, 31 May 2024 23:40:32 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.10-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <d59d3b10-823d-460b-bad5-fae40b43e14f@kernel.dk>
References: <d59d3b10-823d-460b-bad5-fae40b43e14f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d59d3b10-823d-460b-bad5-fae40b43e14f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.10-20240530
X-PR-Tracked-Commit-Id: 18414a4a2eabb0281d12d374c92874327e0e3fe3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6d541d6672eeaf526d67b67b5407f48fe0522c6d
Message-Id: <171719883233.1891.18283403183126827243.pr-tracker-bot@kernel.org>
Date: Fri, 31 May 2024 23:40:32 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 31 May 2024 08:29:50 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.10-20240530

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6d541d6672eeaf526d67b67b5407f48fe0522c6d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

