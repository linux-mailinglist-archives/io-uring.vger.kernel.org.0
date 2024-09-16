Return-Path: <io-uring+bounces-3206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC38F97A16E
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 14:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B6F31C23271
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 12:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE5C15749A;
	Mon, 16 Sep 2024 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNgBA9AS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB8B156C73
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 11:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487952; cv=none; b=P5NZpHMwy6gKWzmC9LKq1dAC51RCnBNzZbqHOK4wshYy5DWCDf8Qx7uPGXpJxVGZ/MWglzhVRZg0pgw8fXKLFE2sLq535X3RHsyXHXWmRKVeinoHNDUbUKwTvpiBfBFcZWfNP6H7aGx2vpzYeKLj9kOUtUjDK5V1LUNcC63m8WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487952; c=relaxed/simple;
	bh=4gqeG7Y5PpXuCpp5pSNg2pGr9qr1P0UTq/gnu6eHWgw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=W5uMreQj+Z7vgu17ndaVZDsflE37/vbGSndlgIzgAM4Qqi6wjOW/6dJ6VsQcKegJfdenFNiMb9VV7dX9oicvxYvsKT46pXSCJs8q66IvT+uAZ04lKHzmUgoOvNdHAkZr94gRM9OeB2+ZLbNXam0dKuo6+7yYLrIT+qKMPcLgTC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNgBA9AS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A17AC4CEC4;
	Mon, 16 Sep 2024 11:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726487952;
	bh=4gqeG7Y5PpXuCpp5pSNg2pGr9qr1P0UTq/gnu6eHWgw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZNgBA9ASIfDjoERgEBL10PETdccvkr3b8x+9JuhHqc4/MeXOR2WOY1Y8T4rkCLC5+
	 sfi69/N3CfRAKdwH0SV3zVTOZTYfX3xKrKeIzy4QDE7p48NdwIVfk4+sySSU3COpjD
	 qH7HwbmrObdRPZHVIqNxUWUsdCArJMdRZOggf6th3ujMzAyHOeTodEmIX/UlFo7ip1
	 0goJaUdjJ1fC5lLKPKafbq6wnsFyaTYGfmCbI2t8Ss/nTE8jiXxKjRKzpZ2XwuV/Im
	 LsfAOblKuSVcO4NBzUZhuVF1aytt1BbOhIsCXG0D4oJECmy6sdhrHgpZWHxx3jPjSk
	 yqKRPtmmxiuWw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 717673809A80;
	Mon, 16 Sep 2024 11:59:15 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aa117c13-193f-479d-a0de-9fca9bfc00a8@kernel.dk>
References: <aa117c13-193f-479d-a0de-9fca9bfc00a8@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <aa117c13-193f-479d-a0de-9fca9bfc00a8@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.12/io_uring-20240913
X-PR-Tracked-Commit-Id: 7cc2a6eadcd7a5aa36ac63e6659f5c6138c7f4d2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a4d319a8fb5a9bbdf5b31ef32841eb286b1dcc2
Message-Id: <172648795410.3670563.676061230555642439.pr-tracker-bot@kernel.org>
Date: Mon, 16 Sep 2024 11:59:14 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Sep 2024 11:02:06 -0600:

> git://git.kernel.dk/linux.git tags/for-6.12/io_uring-20240913

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a4d319a8fb5a9bbdf5b31ef32841eb286b1dcc2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

