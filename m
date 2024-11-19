Return-Path: <io-uring+bounces-4790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1FBB9D1CFD
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99AB1B23626
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172A61A29A;
	Tue, 19 Nov 2024 01:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kB2l7/oM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E558682D91
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731978596; cv=none; b=sWitnZQ3LofyGIC8y6xH5p/lc+ADnegfgNuQwFtxbMhZ38cjDf9dZf3EdRt6L1TiaP3A4dIlK+7lzCtvpzHgSWkEnNhOXZi6qhfm13+k90cAvBuGjKEwCa9GyyfRUcbhsWiTEh2kHIJkVX1iWlPEHdY/xiK24ULjoPyj7WUm5QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731978596; c=relaxed/simple;
	bh=26LXCaGXhkNN//SS7UGYb82/oME9rBfjCdZJprA2G8w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=n93qGrNvLDq1fmYj/jJqAMIVknkRZLQgwHuFG1Itw0X4H/GTAkYv/XOzYYrNeMrkjmAZzHjwHtrSk6sQMyNhlWVoaAa8BiIbLdSZhQwJhJ/IWMRo1AyT/fCTdE7RYzpOCzIualhOvyiTozuM99Kc5x7tJjcLBMAtUMoYWI0cBeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kB2l7/oM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F11C4CECC;
	Tue, 19 Nov 2024 01:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731978595;
	bh=26LXCaGXhkNN//SS7UGYb82/oME9rBfjCdZJprA2G8w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kB2l7/oMNv/T/Fe/qgw8smGjHMtjGHbRyurWEapq+CkpGVLVoqakCoM0i4rRsOnlv
	 oA8ZFtMxCbebAE3oIvPrXDCgRol0lkb4Xaz2pgFsSIFZ1rixDqK/l/IK/4bLWxl9rU
	 mQLONOrmERy3w155O80CwHA3V+bKQbiILdGO1OOGftFYPUxTJK3JFlRSgkcVoTL176
	 wO73D+K07K3ZSnlZgIL+6d/0RWW9FNiSpoptb6Ox7L1mc77OiEe3gKWNbq83jvkHDO
	 mTe1lCxVxAtSf2T3K0evzPDuIIhWRqhntwB/esCPCEsnoJy4+NoxvVQqzq+oUu5l3U
	 jVqGfnGt30HpA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D3E3809A80;
	Tue, 19 Nov 2024 01:10:08 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring changes for 6.13-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>
References: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.13/io_uring-20241118
X-PR-Tracked-Commit-Id: a652958888fb1ada3e4f6b548576c2d2c1b60d66
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8350142a4b4cedebfa76cd4cc6e5a7ba6a330629
Message-Id: <173197860713.48692.4555392326939864025.pr-tracker-bot@kernel.org>
Date: Tue, 19 Nov 2024 01:10:07 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 18 Nov 2024 07:22:59 -0700:

> git://git.kernel.dk/linux.git tags/for-6.13/io_uring-20241118

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8350142a4b4cedebfa76cd4cc6e5a7ba6a330629

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

