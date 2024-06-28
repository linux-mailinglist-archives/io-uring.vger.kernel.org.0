Return-Path: <io-uring+bounces-2375-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2677891B42A
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 02:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5DF628394F
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 00:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1511310A0A;
	Fri, 28 Jun 2024 00:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EjB5gck0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4538200C7
	for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 00:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719534960; cv=none; b=mfgmjlMsta4f1klofSsnxZildC/bMPQSlHEARZkeSAyW+ceT4kboEjux3U/iVFlJF8NhEUpfamQsG5Zm6BcRWqLK+zgv59SeMU6MKURHbRtpVObl59Gi58y0PjjQpOKEdpIxZyO0DA+4Df9enOGuCU/62QMdVfuC7klFc6XNfiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719534960; c=relaxed/simple;
	bh=Tg9wPxuIKCzxWSZjpCuFWjKkvst+J9Z7TOlLJKCcyqg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ej0nT0fF6U9ENZQic5MofZIbfa2xQvwsuHB5casG4siJx6MClJH+rl3RYUPxGGhYaS5rQ7IC3w1S7906quVtoW5J8LpD4EH6gMtSfwv9gk6HIf9W1o9co0r652zmJOD87HpqhR2NFuV/Q2lIok7HLh0RWnxZY/FY2Qi4fZIiu/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EjB5gck0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E9A2C32789;
	Fri, 28 Jun 2024 00:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719534959;
	bh=Tg9wPxuIKCzxWSZjpCuFWjKkvst+J9Z7TOlLJKCcyqg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EjB5gck0kLc1OUOWmVqVRBiGoMkdbdzV76dxBWmlTFsVBMq/Mk17NGs4HJmAU2lYt
	 Za2dUnGTGBos/9xDPiMnLfUSF1chrzA2uEhYhjpQgJh39Os8OaHrI5wPQCxsosWid5
	 yfJEMPzOF/h8Ycd7ZQPNTYxLL7WeJe+xlVj5sm8W8TaypLTsVo0XbdTtj+DoXHX/7U
	 fqCgS8NkK8AKP4SwGPX3eH+XjRL3VD3Zu8KWC3TEanZTITMFJjjOXyR1hy2/CdO318
	 6VBr6Ka7+4VeQ+JT7pnCxG76LA/Inv975XNjiZ69askkbuNVeikQ4Aua+CLFjJk/ic
	 Wn2K+IU2Pl0QQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84ED6C43335;
	Fri, 28 Jun 2024 00:35:59 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.10-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <2f83d5f9-29a8-4d61-a14c-3ada09cf2d2a@kernel.dk>
References: <2f83d5f9-29a8-4d61-a14c-3ada09cf2d2a@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <2f83d5f9-29a8-4d61-a14c-3ada09cf2d2a@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.10-20240627
X-PR-Tracked-Commit-Id: dbcabac138fdfc730ba458ed2199ff1f29a271fc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f47788b3326150a4a3338312f03d2ef3614b53a
Message-Id: <171953495953.15056.13917420750024647813.pr-tracker-bot@kernel.org>
Date: Fri, 28 Jun 2024 00:35:59 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 27 Jun 2024 11:55:03 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.10-20240627

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f47788b3326150a4a3338312f03d2ef3614b53a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

