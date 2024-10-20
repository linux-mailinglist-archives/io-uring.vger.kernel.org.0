Return-Path: <io-uring+bounces-3840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5599A51D0
	for <lists+io-uring@lfdr.de>; Sun, 20 Oct 2024 02:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 762031F21EAE
	for <lists+io-uring@lfdr.de>; Sun, 20 Oct 2024 00:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86FC563D;
	Sun, 20 Oct 2024 00:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGIfV8/Z"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4CE8F58
	for <io-uring@vger.kernel.org>; Sun, 20 Oct 2024 00:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729385951; cv=none; b=erlXke5gfyeYt7tvRcTHSVF0Ux1DFAWnkfBR6xfOeXlOEnUY51lL3dgtufUGs/cG4tmESVxc/BhZBOEQqSZ8Qe4x8IAoBLSHgWNY0q5bG0N5u9J2zhLLeuiXkBurKl7ptqjeV41Ui5lBd0cbnFWBDjyh5oLOsR25eU0OgX1DwKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729385951; c=relaxed/simple;
	bh=JsK3PHMIknVatyGWyEyekuGXA8F2WSbfusPPND8g/3c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Xne/cnVZ66rNpasTbjbjNrczgJkYJP0EzafrSkmZ6nR7F/esvK6PHZ+PHzSonoagYHxRQc7e2yUS3PYfeEsCsyfdlsMvLQnn7kacvm8VFtELk+DXy6R/Dqm0VMDA2l4LGnGNPFfAuVQ/1oGQwAo5cMOHbA4XVldLcvzBcPPh1Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGIfV8/Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3420EC4CEC5;
	Sun, 20 Oct 2024 00:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729385951;
	bh=JsK3PHMIknVatyGWyEyekuGXA8F2WSbfusPPND8g/3c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WGIfV8/Z8GlmDYde19wIUtF50YwzE93KLv5sAjo+BVdYtxRAghAiOSsbw9LE0VhwD
	 vKugV3TghypXAxsu/SaKmTS4DE5muYOrxAY14igUDOL1hCUycmhfNhVADqW21n7iTw
	 I565USIRIkBMK+4VIESFmIQYDqh+fEUj9Ls8ozSB4BLClOcK7e3p37YEa23QTN6a8w
	 kP0W0n7LQsrsDdFr+9E6La0vIFuCKLk3izC6/VZowBQ+j/a0FCIzwQ2XOpKcKbo6cw
	 wHX3UCtCFrbqjHVQXx+rcOVyAHN0IQe1DTjC7yGDRQGKTH6sle+eVA+TuL3Q56yMJ2
	 cPInDPeeVrniA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F6F3805CC0;
	Sun, 20 Oct 2024 00:59:18 +0000 (UTC)
Subject: Re: [GIT PULL] Follow up io_uring fix for 6.12-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <46257b01-db4d-4454-a1db-9e528bb8097e@kernel.dk>
References: <46257b01-db4d-4454-a1db-9e528bb8097e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <46257b01-db4d-4454-a1db-9e528bb8097e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.12-20241019
X-PR-Tracked-Commit-Id: ae6a888a4357131c01d85f4c91fb32552dd0bf70
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 715ca9dd687f89ddaac8ec8ccb3b5e5a30311a99
Message-Id: <172938595680.3503243.12025969900445849271.pr-tracker-bot@kernel.org>
Date: Sun, 20 Oct 2024 00:59:16 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 19 Oct 2024 15:54:45 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.12-20241019

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/715ca9dd687f89ddaac8ec8ccb3b5e5a30311a99

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

