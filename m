Return-Path: <io-uring+bounces-2646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C849464F8
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 23:22:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 070B01F228BD
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 21:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815E954660;
	Fri,  2 Aug 2024 21:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4Phg31K"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF2849634
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 21:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722633724; cv=none; b=VK5BLxkDI/jgbRXYZQyukck9cTRmf9Vwe+PxHLqML1ONNEtMcl/XdAeb7PNzUpX/4uDkuzvnMZqKnt+XF3L6knMf9mDtWuoNW3Lnp55jNdBYQWWFqiUKslJfUQhVjrrWANuuOFjDFdUPNFdaBBxl57Yv+sTJvZmeQi9Q6vpAwhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722633724; c=relaxed/simple;
	bh=pV68bxNs7zuLqtu87o8cruP681hq3yOET634vTFlDXs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nnxmjhnYnaI+0prZezkoAqNjfMZWCqb8nx778pfjHzrsFgsyXYCsdkFCE07YIc3LPahJAJpg2snUIWuznm5Qqvj+HTSoH6Pf25SUrf4WOjXf7PgBEiKvsPklxGWDW2s5sUyEoqB9hFvA7VYCRWvApA1LbAFAD4vQ32ZxrbrerXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4Phg31K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0B6BC32782;
	Fri,  2 Aug 2024 21:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722633723;
	bh=pV68bxNs7zuLqtu87o8cruP681hq3yOET634vTFlDXs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=q4Phg31KGPEseqgkUNNTsTx8dc/LY0/eRLH8Ep3EBMG6g79p32jGEBz48hmGar3T0
	 fJcad6Sx83rnGl46QHyRlHfEENBNrbxtjAYdjEDOUs5hNU0KRxVrfNbR1/N2XLZNtX
	 hBIAx5k5YNpu5/z0dcHeTl2p1bciVTf/Kb0fr4HOTbfgwVxaP+ikbfQiPwl7npbnOM
	 DeD3zJp1jAlayswiIRmPJIvPLwNn300j5yJjHcSB2VvTqRITRL/fDpDFH1oIkbbExr
	 SGnpxE7BZeGeasgRvCs/MU3N2Ofox0Xkkjy2L1gGbb8Lf2zcJPIDbaE76J3NsSiYPP
	 ljkM3khfIoi0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E78E6D0C60A;
	Fri,  2 Aug 2024 21:22:02 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.11-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <acefe232-8ea3-4961-9d27-67222d5d9e16@kernel.dk>
References: <acefe232-8ea3-4961-9d27-67222d5d9e16@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <acefe232-8ea3-4961-9d27-67222d5d9e16@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.11-20240802
X-PR-Tracked-Commit-Id: c3fca4fb83f7c84cd1e1aa9fe3a0e220ce8f30fb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 17712b7ea0756799635ba159cc773082230ed028
Message-Id: <172263372294.21514.7009712852462247392.pr-tracker-bot@kernel.org>
Date: Fri, 02 Aug 2024 21:22:02 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 2 Aug 2024 13:29:58 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.11-20240802

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/17712b7ea0756799635ba159cc773082230ed028

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

