Return-Path: <io-uring+bounces-2322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2B6912F3A
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 23:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85BB3B25376
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 21:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF58617B42D;
	Fri, 21 Jun 2024 21:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qPstFIMM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7B416DED5
	for <io-uring@vger.kernel.org>; Fri, 21 Jun 2024 21:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719004150; cv=none; b=CGK9EHhsnF5iUXOaSBObdCzWcEU+32zyYUvjopTHktShtFkunkrS9JTe28KjGL/SecpfRiu8U2sHxPZDGJyI1N3nrh3O3iIElmXIshOelQLFpUcTw4RIEcsvm8EwZaGTLD8syaycsS2tJyM4AzVXPENf6vXlXggYPnfH49hJrZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719004150; c=relaxed/simple;
	bh=ObzMml0YDcojm1qUBSmAavSD1vEBMrc8kC/6xNfthE8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RxVHRVslktUgVKcwCz7tuwwxtGqD6nmzzZBzD/f2aZXSUZM61vzuFbu+tDmeawaiDHp3z+02yOZLH5Gmgbtq/Qtw5zkktOS56DfRy924kQvr5AgHwB9EsNmQEL7jvwki0vKJAvHZvLFBOojn54KNWu5rdqtnxb53Qepytb6ZkCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qPstFIMM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50BD4C2BBFC;
	Fri, 21 Jun 2024 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719004149;
	bh=ObzMml0YDcojm1qUBSmAavSD1vEBMrc8kC/6xNfthE8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qPstFIMM8GqYAh+PFhk1jkxngijp1+FZISwVlky5evrTVZSY5JtQXxt7iwfbduE8s
	 zg3HX5yd8hrJZPoANVTluTlLeOgUZJL0615iM2nlXmJRpSKbwgg4dFNVtqWCj18nHc
	 dR+pne77zZBfMSRgcScxkAEQUyzLfP5zKbjWypkLBsPYI8lKFpQyHofTK/bM00DxCH
	 58KRnngzEO3BpZuV/uXgVzVwmMSolNsoRol2/dcTEiO6ErCLzhtB7ac0dxS/XPuiqI
	 +wnkYyy2lIIP99QJ+ARB2WIkQck/PEI2/6nwPFfhUkTQ6v9Alug4T8ET6TU0vhIOhO
	 YPbRE5OSP+N8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47413CF3B94;
	Fri, 21 Jun 2024 21:09:09 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.10-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <83d246af-25b2-4ac4-a7f6-57988e6ed145@kernel.dk>
References: <83d246af-25b2-4ac4-a7f6-57988e6ed145@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <83d246af-25b2-4ac4-a7f6-57988e6ed145@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.10-20240621
X-PR-Tracked-Commit-Id: a23800f08a60787dfbf2b87b2e6ed411cb629859
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a502e727965dbd735145cff7ec84ad0a6060f9d2
Message-Id: <171900414928.4758.9192568178231047537.pr-tracker-bot@kernel.org>
Date: Fri, 21 Jun 2024 21:09:09 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 21 Jun 2024 10:12:52 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.10-20240621

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a502e727965dbd735145cff7ec84ad0a6060f9d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

