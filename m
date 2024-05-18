Return-Path: <io-uring+bounces-1936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A21DF8C91D1
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 20:07:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A19F11C20C4A
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 18:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347D745BE3;
	Sat, 18 May 2024 18:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJkADqsH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDD93B298;
	Sat, 18 May 2024 18:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716055630; cv=none; b=TbFm0Hlg1MFrSlAyCF5ZAs7LSbtFnUBipKe85K4Tm9tFWaqTwk+R2CM1ZOfcloLEyNPRO53dJ3vvmBrqvxeICpWR64SvxfUcZka8Hom8CQ+KF9AHxzTjfZHBMvlcCRQPpTKDJAbUSH6nOGDisn6YVe4RMnWbrkKp/zDnNNlUd3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716055630; c=relaxed/simple;
	bh=BoUImkzjXR4L1RpWF3f+PTjWPw5fV41hI2bYOvbRpwo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MPL1x0QL/uw5kzNDHhT7h+SS7W/xFrTrPlPrO9Ic7pAnwx3s/2TeFWQelq/KYWW7OZdLwr29iB8f1H2K+SQq8p3NtbJ08qEaOcXICE3VEANCnkTN+sDT9EkW3ZG1l0bV/IWKIYQH/zuRRZO/d9zwmo1jdOoWLEnuHPYrjNNjo4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJkADqsH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E20CDC113CC;
	Sat, 18 May 2024 18:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716055629;
	bh=BoUImkzjXR4L1RpWF3f+PTjWPw5fV41hI2bYOvbRpwo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JJkADqsHGr73IZlZrvauSHyyKmWhyoi/azrPXH9TUci2GYKiTWXoCamswF79Mqw/n
	 P61hpBSKN+hZJSS+PSisLz2puVW06gtvBIcC6Az0JR5iN+ClYcgPN2PYqKjZYEYM1n
	 8JadVUBf27bYYGDcPA0ulNL7oFWim/Uvh/HMn/tdqZGHEEiMfHib9fpMRCQlS+iBWf
	 E+9KPvZojAVAJe4Sk50AKsYf6CRRdi2GpE0d18QWlqQ8XLs1+6BgDoiqU6kitWCmxt
	 sH4UVm/UNTWH8btsmt1wgcCR6iA0HfZkNUOBTTXkGZ8nlx5CA0054lWGUL6h4mUz2D
	 /yfj5c/zhErBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA18FC43339;
	Sat, 18 May 2024 18:07:09 +0000 (UTC)
Subject: Re: [GIT PULL] Enable IORING_CQE_F_SOCK_NONEMPTY for accept requests
From: pr-tracker-bot@kernel.org
In-Reply-To: <8c707a5f-2e33-4f5a-99a0-89a194625bcc@kernel.dk>
References: <8c707a5f-2e33-4f5a-99a0-89a194625bcc@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <8c707a5f-2e33-4f5a-99a0-89a194625bcc@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/net-accept-more-20240515
X-PR-Tracked-Commit-Id: ac287da2e0ea5be2523222981efec86f0ca977cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 89721e3038d181bacbd6be54354b513fdf1b4f10
Message-Id: <171605562988.7011.3621169131172561049.pr-tracker-bot@kernel.org>
Date: Sat, 18 May 2024 18:07:09 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 15 May 2024 20:38:49 -0600:

> git://git.kernel.dk/linux.git tags/net-accept-more-20240515

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/89721e3038d181bacbd6be54354b513fdf1b4f10

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

