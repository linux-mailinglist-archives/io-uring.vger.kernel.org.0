Return-Path: <io-uring+bounces-3608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58E5A99ACC9
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 21:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88E191C263D3
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 19:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2331D0E31;
	Fri, 11 Oct 2024 19:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnDUSiwg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADA71D0E2F
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 19:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728675248; cv=none; b=ZDyAXwp1naD2tTCwLjcjilrFWCQ6RKsUokYG9uze9TyBW04DxfmZLp3DU6lQWcuny9HPir4mhAMJZ3OWGQAH8lFytQKdyb7WrQWGFK1BGzt/iIoS4gitbCdo3QccLqpcFdYyQtoZ/QsTacyBA/q/fWjPIsg+2FD4fVGqFUCz4eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728675248; c=relaxed/simple;
	bh=fHpGsPPBuHXXdiGmm47jtg3zowcTa4FagH/HNCKdI1k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=elGEwAkHZihqipmmofURtkj4OW3USSS9iYnUo5Rewdwb+R/enj0q+0QS5uHsSYCvJmvT1MKZgV0B9+SnyFGrmwiqXRsl1MRdJiZEgcWg9Xqa0kWyUOtofUwcRe7teBsaGb4bdCBvaW/BVyjVpUYuV2+3H0zU6ch5NJz5MwfVaVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnDUSiwg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9B6C4CECD;
	Fri, 11 Oct 2024 19:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728675248;
	bh=fHpGsPPBuHXXdiGmm47jtg3zowcTa4FagH/HNCKdI1k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lnDUSiwgZtosHS+/RaW4XAj59nPN1pGfBqj7QqrpmxyKTpyUPv125Y/hkjYrnZeEc
	 b6PXBu7pCa2irLXr4MwBJm9T0+Q+/Scmgzz9daSGPeXVbwVleuNbacq4lDWtpb4TL6
	 WpVPWL2V12Aaw6tOTGuCDASbyVthbXGQA7m1PSpV3tE7MvVWB6eBaDkQGEEDWeY+mn
	 31LMnSqQgoQZqdTjfqxBeQ+Z4se7T8/XvwlPTor0HSIJXUnqvxmVPo3XDmzIe/0NK3
	 tVrgP9Oht5uj0zn5bX7FO6IwnDOWYGOzb+NbvQ1Sr47uW6iDg82V127NT1JEOnEgYl
	 pc1vR0pIXC85g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70EA038363FB;
	Fri, 11 Oct 2024 19:34:14 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.12-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <da0401d2-0479-4115-ba5b-185f25ffe4b6@kernel.dk>
References: <da0401d2-0479-4115-ba5b-185f25ffe4b6@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <da0401d2-0479-4115-ba5b-185f25ffe4b6@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.12-20241011
X-PR-Tracked-Commit-Id: f7c9134385331c5ef36252895130aa01a92de907
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9e4c6c1ad9a195f28ec3d3d5054e25f6bdde87bd
Message-Id: <172867525295.2975359.8579728254519545926.pr-tracker-bot@kernel.org>
Date: Fri, 11 Oct 2024 19:34:12 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 11 Oct 2024 08:54:35 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.12-20241011

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9e4c6c1ad9a195f28ec3d3d5054e25f6bdde87bd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

