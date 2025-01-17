Return-Path: <io-uring+bounces-5948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DE2A1479D
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F042E188D26F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 01:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95ED82E40E;
	Fri, 17 Jan 2025 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUXtOWtI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7A32D613
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737077970; cv=none; b=FxE2/mdqh7ekw1VwvRwx4d0KKOH2PSqaNiW2cLCDVo+DvsYclQgpWFyEN0a43wcwEqqs9EyaLp2Etm1dPTjDtNy1pCG9A7BmERTRM8LKQ37a9n7lo2M4aOaYFEFkvh0hm1+BLJ78tKbsAVKMCTLoQ7OZzk55MWDbf2Ii/jdm6Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737077970; c=relaxed/simple;
	bh=PmkhnXPhZ3cEOqEZJzS5MlWjZleCCru0sj3Xw61X4SU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ioV1T5XT2s2kVmwub8OQ4yOwJxtCLsTexhfwiHkbBd7Os6JoRYhd+yFVqEkL3F4Nsq8NbbtS5Ru3FP4E/Hz8FeURTMBt1Nkw3kufhM1r35ZrCQdx29JLqGN6/sTvDlMPws6TJfwgpLtHa1DxdLuBOHxJC0ku8wzM2xmjJysSynY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUXtOWtI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF6FC4CED6;
	Fri, 17 Jan 2025 01:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737077970;
	bh=PmkhnXPhZ3cEOqEZJzS5MlWjZleCCru0sj3Xw61X4SU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JUXtOWtIC7K2D9L2VaGrGm3Cpt1rNGIg4BtHfrjMuvXHFWb6PpnT4yaRhkS3qBVXL
	 YMCaG719My5tgig2aK10MKuikdMtxM+VpZcET+yK8je2s4MC5QdXOynbjFcYGAPBXc
	 IWMQ+QcH7kbXvp3ZATqCglkGB5gF6GNBjzV+F5TeTzx/2TJ2t49wUktFi7UTTefAFO
	 kcyWd8v8N6mfrQJO/5Uvl2NjQfQOIr9pJFHjIb1WrxhbLcpvhpwxVPz+SgVfEBST+5
	 dixGn2LKCawWMBYU76ISfjtaoSl6yHi0otFXL2umw7Jv69GkOto6E6gCssLweXO296
	 Q/6l9rSobBNaQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B0087380AA63;
	Fri, 17 Jan 2025 01:39:54 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.13-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <4194f9f4-07fc-431b-9af1-5888c07193ba@kernel.dk>
References: <4194f9f4-07fc-431b-9af1-5888c07193ba@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <4194f9f4-07fc-431b-9af1-5888c07193ba@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.13-20250116
X-PR-Tracked-Commit-Id: 6f7a644eb7db10f9993039bab7740f7982d4edf4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a634dda26186cf9a51567020fcce52bcba5e1e59
Message-Id: <173707799325.1651717.17622177516182154332.pr-tracker-bot@kernel.org>
Date: Fri, 17 Jan 2025 01:39:53 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Jan 2025 17:06:47 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.13-20250116

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a634dda26186cf9a51567020fcce52bcba5e1e59

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

