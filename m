Return-Path: <io-uring+bounces-268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6840580AE29
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 21:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12C021F21237
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 20:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA02039877;
	Fri,  8 Dec 2023 20:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cw8xjWie"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4D347A41
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 20:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0902C433CA;
	Fri,  8 Dec 2023 20:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702068318;
	bh=nNnS0sGRKfFtfAKPBTuf6pFAXucCEspupSCxs2tklJc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cw8xjWieWv8lu61gGJbxN9vuASj0K6HwrIdya57Zh4M0z6Jow0jKY9NSzlDv+Hbj+
	 5985E48EZa8uMYBQ7GehFktPBhonBaIbWVmTz37JRLNClmyBPAXVfaQCX1G+duqhN2
	 iBEUt7qjXlqKW1Wo+FIUTBGQaa5Qn2OInoHtyGQhHpivu5+XyFUmeMMek1AxIk/QoF
	 wOKREgxyy/Zwm5Mai3wQX5Ibu9gdyLD4cPSeRHTIGXd4duZjj2AGisvE4i+sNyEKIL
	 zatg1L/PS2PrY1vkYTHy3HwOGrlIyIxusm1EPGmc0DHWCTVjV+/IsUXV6f8+dmj/Gh
	 OICT3CSX5BhfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87FC1C04DD9;
	Fri,  8 Dec 2023 20:45:18 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.7-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <9ab83827-12a2-4e63-a557-ea8a837a988a@kernel.dk>
References: <9ab83827-12a2-4e63-a557-ea8a837a988a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9ab83827-12a2-4e63-a557-ea8a837a988a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-12-08
X-PR-Tracked-Commit-Id: 705318a99a138c29a512a72c3e0043b3cd7f55f4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 689659c988193f1e16bc34bfda3f333b11528c1f
Message-Id: <170206831854.6831.6683209216043678884.pr-tracker-bot@kernel.org>
Date: Fri, 08 Dec 2023 20:45:18 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 8 Dec 2023 10:48:48 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-12-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/689659c988193f1e16bc34bfda3f333b11528c1f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

