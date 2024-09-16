Return-Path: <io-uring+bounces-3205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E4AF97A0A0
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 13:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8097D1C22D35
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 11:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4623E156C72;
	Mon, 16 Sep 2024 11:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gwW7s4Ld"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A674814E2ED;
	Mon, 16 Sep 2024 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487944; cv=none; b=jj8OkquliV8AOd+/GX6/WT2ZPXslXUAoV4bw2+1e0cILk+Egi5ZyNWPklrWQ5MXKnWHV7W4uYhncVAQHByEunjcQikvWxTyJAt+pd3fTU7sB83FPYohKC0G0PQ5RSE/+Y4dDrwSGtT2gZGRaZaVwePc7F9heU6ZFc0g5TCFAZ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487944; c=relaxed/simple;
	bh=jO7kh7dHQZ8nK/1968rh2dA2uuSIOUaztvITGhwA9Rc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aUeLWlVyy4aE5Gub4wWqOIQ/Z+Fu1JOoOMMx5BNdGblxRVOeVFJFo4ugPZV212nqvxYyRstYV+buRZ8wMOkphoi7VlBTmCj6IwhR/VQpZT7S+7i64lBo7OvtfwDv9A79hLrJX3Tf0GfNuie3IaBYFkFnoxeRnNJ9APelM0f+gZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gwW7s4Ld; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65ACC4CEC4;
	Mon, 16 Sep 2024 11:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726487943;
	bh=jO7kh7dHQZ8nK/1968rh2dA2uuSIOUaztvITGhwA9Rc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gwW7s4LdTy22wtBjJNmnpUCNxHswHTElzEwMk5Sb6994CyGF2OXQAWY0/R2teRr+z
	 eK9sr/adXR5UT62xa6suNWcKxrJfpxbvCWhM8mngAoZE+v+7Y9hKENjHHNSjdr1OIB
	 47k0xQ7ksDZeu8Xr55xrMgZEBDJM+tO1HTHG/pYiv3EKXU1FBS2v440QxKrnfE+gx2
	 vR663y0eo/EfMTji1NQ3PbWkPHXLBkkcakeV19bjSatN0kTFQ5gis5W6Yr46lpDpsy
	 tQn1zBmYSNjwjV0VKHnbFVYmi6w9cCyCYHHJbEuBN6t5QEqDqNcR5Zp/bJez26biCQ
	 QLO2zLQKCG5ig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id A3F073809A80;
	Mon, 16 Sep 2024 11:59:06 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring async discard support
From: pr-tracker-bot@kernel.org
In-Reply-To: <a672ddb6-a141-47a5-b7f4-f992b4dcbb88@kernel.dk>
References: <a672ddb6-a141-47a5-b7f4-f992b4dcbb88@kernel.dk>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <a672ddb6-a141-47a5-b7f4-f992b4dcbb88@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.12/io_uring-discard-20240913
X-PR-Tracked-Commit-Id: 50c52250e2d74b098465841163c18f4b4e9ad430
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: adfc3ded5c33d67e822525f95404ef0becb099b8
Message-Id: <172648794536.3670563.18442123757942385561.pr-tracker-bot@kernel.org>
Date: Mon, 16 Sep 2024 11:59:05 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Sep 2024 11:02:24 -0600:

> git://git.kernel.dk/linux.git tags/for-6.12/io_uring-discard-20240913

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/adfc3ded5c33d67e822525f95404ef0becb099b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

