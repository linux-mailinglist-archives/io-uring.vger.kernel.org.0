Return-Path: <io-uring+bounces-891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B65B87890A
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 20:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EA8F2816B7
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 19:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C94884206B;
	Mon, 11 Mar 2024 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FxE9q/5L"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48863F8F6
	for <io-uring@vger.kernel.org>; Mon, 11 Mar 2024 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710186175; cv=none; b=TMEYRrRR03KowzhNOJUL+HkcpxqOYDcQ5usv8S9jDB/rHp0spJ5SQgjPs1Rb9tCe8tfagzQ/yVlwnXJOYmHToBHamXA4fEHVFYijFeVCXfV+9Q3iLLTpSeuc0l74nzacPoA/mx5CO+bRKNKuru6PepGDIMbNPkEk2vqDcxILdwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710186175; c=relaxed/simple;
	bh=2koIicF9HKHUQBYYWKTyQg+HmWWztM3mJDWfqwnwAd8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bd6UAEgABEuQ7c5KmyVI/OMJfE9Y3ylZT7kzOf5jtVxl2UZbBJykJgmnJNJRO5BLFyt77wbIjeU698cgN9WCa8nX9L7StkcSf/SQ0b+UFaed9OV12vjWH1JH39PsPsfkbSyIJiLjEJRgKfeKqyuH3AMiHknMyIN7BubUyj0025A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FxE9q/5L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8690FC433C7;
	Mon, 11 Mar 2024 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710186175;
	bh=2koIicF9HKHUQBYYWKTyQg+HmWWztM3mJDWfqwnwAd8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FxE9q/5L0rxfRUv3j8QgbcjJloeffIcGqZs7S6FEQGkYJVepLelRtBvOCf3DsFXrS
	 NAiuQ4bqfJRYOj2vWGWTg573vSKHfFw1OypY/+rvS/h0dHNg8XYJ3QUpmiUNfoDlFs
	 F0Wi71Cgd6lWNyRbLirWwbLpHOLeGNB7Z5rVPckQmNWSWF4JqM3+d5XbrJioiW810E
	 8SIuqogxe5gEiDmC38fEomSYefcbDfDajuabMKRNt6s0KhuHLzDiegalW7XHpJjxcr
	 sW/CsOB38r+2UGKztzhUKoHfDnO0r64eJW5F2y4YFwamCoAWunfJBHNZZB9+olV9TH
	 r2LZTVw6/Q5Hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75247D95055;
	Mon, 11 Mar 2024 19:42:55 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring updates for 6.9-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <08c119f9-de23-47de-98cf-9fd30c614f85@kernel.dk>
References: <08c119f9-de23-47de-98cf-9fd30c614f85@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <08c119f9-de23-47de-98cf-9fd30c614f85@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.9/io_uring-20240310
X-PR-Tracked-Commit-Id: 606559dc4fa36a954a51fbf1c6c0cc320f551fe0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d2c84bdce25a678c1e1f116d65b58790bd241af0
Message-Id: <171018617546.28701.3866737610241624331.pr-tracker-bot@kernel.org>
Date: Mon, 11 Mar 2024 19:42:55 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 10 Mar 2024 14:00:25 -0600:

> git://git.kernel.dk/linux.git tags/for-6.9/io_uring-20240310

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d2c84bdce25a678c1e1f116d65b58790bd241af0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

