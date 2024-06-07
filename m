Return-Path: <io-uring+bounces-2142-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E50900E90
	for <lists+io-uring@lfdr.de>; Sat,  8 Jun 2024 01:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2C751C22052
	for <lists+io-uring@lfdr.de>; Fri,  7 Jun 2024 23:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8746713E8AE;
	Fri,  7 Jun 2024 23:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b71UlFhF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF50B64E
	for <io-uring@vger.kernel.org>; Fri,  7 Jun 2024 23:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717804260; cv=none; b=HQqOzwB1b6FMNtanHt9S+JTgFP4njG6wYRHjx8jtwR/gfQqXX+h1fmKXZ9gDVQmpL3/6lx/COm5VMJUI75nowMPsephBIe2bUq9Gh9ItVx7vYelfZb5ilVi/su2sdI2D8bch6e6Y0mNkKcBc5FnA52Q3pcgaKy0bMKxD+vU7ggc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717804260; c=relaxed/simple;
	bh=A7YuuSc06UoryK6K5KIW7bDHyT0dv0+vbpp/48gZGVk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=k7M5BwqII8nqK5WVxPxd5SSfEpJn81I2DOvRWdaTLQS3G6N5rYersiIHGtPhfENUuoJGFl2h+fuqi4IvhQ5quxtBy9DTG9odn2/jwwD5UWJV/UBcpicHomE7oD7TPLDLW5SevtcgWWS5GRnEtxMSagoRFbIh3VzTXy0cg8i6B40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b71UlFhF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30E8BC2BBFC;
	Fri,  7 Jun 2024 23:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717804260;
	bh=A7YuuSc06UoryK6K5KIW7bDHyT0dv0+vbpp/48gZGVk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=b71UlFhF+u4U7DfFRF1rii61I1gn2gbedLgd7cQhlztDHzaJQRJrMQs6v10qexFWj
	 dDMhAnn4m3OJCE9gVxiXEzyvDErp3dgjlE701m2R2j8BgPyCt9wDTOiijPyQKItceH
	 DU+iE4hxXr4M8iSfB2HnQQB3AnGkTAsMeMMfDxIekp9XxzTMTJH8aAn+24CAKsqhcI
	 10ORLPDW/7cRc6uc4grDkbc70XsfgMYuYNBBeiZZXJlgFRTgouKt5MMbxVYIM1UAwp
	 WnBXlbAL9Jj2ExSofBEJkSx3AS62/XWAy+kSBD+ps1XEo1U99YaEQwmcv9BNjsg+TV
	 yfiD/HPZkeaAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 26950C43168;
	Fri,  7 Jun 2024 23:51:00 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.10-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <ab15af52-d76f-4c68-bc22-12b41860106a@kernel.dk>
References: <ab15af52-d76f-4c68-bc22-12b41860106a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ab15af52-d76f-4c68-bc22-12b41860106a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.10-20240607
X-PR-Tracked-Commit-Id: 73254a297c2dd094abec7c9efee32455ae875bdf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e33915892d8871b28d17675fecc1b5b36b0d5721
Message-Id: <171780426015.23085.155404008445154866.pr-tracker-bot@kernel.org>
Date: Fri, 07 Jun 2024 23:51:00 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 7 Jun 2024 09:55:17 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.10-20240607

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e33915892d8871b28d17675fecc1b5b36b0d5721

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

