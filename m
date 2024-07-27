Return-Path: <io-uring+bounces-2591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5428093E15D
	for <lists+io-uring@lfdr.de>; Sun, 28 Jul 2024 00:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1685B213C1
	for <lists+io-uring@lfdr.de>; Sat, 27 Jul 2024 22:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6967F3B784;
	Sat, 27 Jul 2024 22:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ssd18I/B"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4563A37147
	for <io-uring@vger.kernel.org>; Sat, 27 Jul 2024 22:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722119901; cv=none; b=foogqXQFxaUr7HqGriVPS2NfCB/aWFRR/bj7rJhGOWi0O6fg78QsWCXQFa5GWEMi8qF6VqZIWKYoAvvU5Y2/y3ft82ACYxabtvN/U7/gaSTfB5KCps2QKPxqigWAhGbO2TTIq6On5mSbuxMBhxXJoE2vwKVWowt6u7Bkv9k5wzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722119901; c=relaxed/simple;
	bh=RYTeBGOLIS8roIBYnbolWaic67ZxB4j/3CoTLT9b1zg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Xhpgzt+sFTfyxNsP81EW/RAQn+6XQp9uHZQQZz+ZZ3TimPjGaGtPGZzwmuQwh/GwSqx123IgrA8oPLyhSjifTZCJWoZ3t7gNG8d94ecOLuCSlbW6BFpHqInkldVcQCkBzyGDNh2jxdLR+lBJTGuc5NyuzStp04inhftMnBB65ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ssd18I/B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 232A1C32781;
	Sat, 27 Jul 2024 22:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722119901;
	bh=RYTeBGOLIS8roIBYnbolWaic67ZxB4j/3CoTLT9b1zg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ssd18I/BKWJjG8sc0WpZClYGTKRKGWBblg9XPwgKN1zE2u7ulV+BLK+gNm4cN6kcf
	 CCTLQjfsKv54MGx9Cau/2U20wj1/mA2STxxkeNmaXPDhfiZPDbz7AI9zDJ4NaHnqgq
	 KnbRrjaXfTr8nYTq6Y3jfFpY2xpCmnUvjTn3Ygm1u8faVYiDlyzskDLTsCli3HguH9
	 R0ysQOm1AdHVAJ6O2ujvUeIPl5jvRhWkeYPrsDFC5HNZ2sgLNtwt0tpcHO5L6AWsGk
	 xCBHpDM72K2xq+Dut/9RSQRs7/XPTQ7lbEit9TQUEGarrG7wIwmrAVn1SNZJpVtJJ0
	 n/XsfCexzFquA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A148C4332F;
	Sat, 27 Jul 2024 22:38:21 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <0b085a98-80a5-43ef-9b6b-2508b4c70959@kernel.dk>
References: <0b085a98-80a5-43ef-9b6b-2508b4c70959@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <0b085a98-80a5-43ef-9b6b-2508b4c70959@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.11-20240726
X-PR-Tracked-Commit-Id: 358169617602f6f71b31e5c9532a09b95a34b043
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8c9307474333d8d100870b45af00bfeb1872c836
Message-Id: <172211990110.30387.5630002148998350997.pr-tracker-bot@kernel.org>
Date: Sat, 27 Jul 2024 22:38:21 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 27 Jul 2024 07:06:53 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.11-20240726

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8c9307474333d8d100870b45af00bfeb1872c836

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

