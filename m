Return-Path: <io-uring+bounces-427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 362AA832369
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 03:41:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC0E4B231D5
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 02:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723A0D51E;
	Fri, 19 Jan 2024 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMp+Or67"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8B24A0A
	for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705632021; cv=none; b=VEuvtNkpl0vB2RFL/emNp1kpPleiZSLBIcEIk3HKAO1RS0KJrQ7UBrZocvFxBZEcv4/S85hZX2C21e6BT1gHRbGKyK0rPqhDybsgaTggbV9+wqJpOgDoE7j/fgdnOVwGFTfgB9ygH7f3+df2KcQxzWR0PK4GrH5cSE63TccKjDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705632021; c=relaxed/simple;
	bh=8GMuLhbYSXL55F4J1OrXUwbIUGZpbI86mTQJkUdXiQs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LUkCLogdwm/CjlIq5nHFoqB93kwZ9xjH9nkDEkncHaj2Lvl6wnYFTazzn5xeT4xrRRQZTwebMKYlGNn3Zn4ZjNovxLXb4lK/NCu9HZX5PophUuOIZR1KlpcIP8v7M7/K0C2/R+dGXtC/ekGhdChibHc+xxNkswUFR0+lNsTzCes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMp+Or67; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29191C43390;
	Fri, 19 Jan 2024 02:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705632021;
	bh=8GMuLhbYSXL55F4J1OrXUwbIUGZpbI86mTQJkUdXiQs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WMp+Or67GY1Fy8VibfsYRhWjjek1RaoBMMkey1b9kmlHDnMBwgB/QZsX63pmJrkpj
	 zChJzx4sPLzXNORNQdyCnzq875nxfs0cfL4BHnuAh7k8PSysxKuuNKIUAxRs/oHTQu
	 bZ198Mm6XQMWMavVqzeXKSH8lzyJUJQ6dXvOQ5y0kDLsfTssQJXjPnbDp+E6FXPGQt
	 2EqrGmeVB1hS8a0mY2EOGyVUfdjqT8w9pbwHMoRLWGRMNgpBv4MaMb2em4BFdMFi2S
	 tXskhXQGKaes0NJKNtgTOcL8RvFrYsgzJFGg+4en1+PNXTZzf2NXYzl6trgTlFt8W6
	 0YpRjeEMG+W3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17D81D8C970;
	Fri, 19 Jan 2024 02:40:21 +0000 (UTC)
Subject: Re: [GIT PULL] Followup io_uring fixes for 6.8-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <e0d9841c-0ff8-4cd4-a0d6-dab694598b8f@kernel.dk>
References: <e0d9841c-0ff8-4cd4-a0d6-dab694598b8f@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <e0d9841c-0ff8-4cd4-a0d6-dab694598b8f@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/for-6.8/io_uring-2024-01-18
X-PR-Tracked-Commit-Id: b4bc35cf8704db86203c0739711dab1804265bf3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e9a5a78d1ad8ceb4e3df6d6ad93360094c84ac40
Message-Id: <170563202109.16016.11450807770478138742.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jan 2024 02:40:21 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Jan 2024 15:05:26 -0700:

> git://git.kernel.dk/linux.git tags/for-6.8/io_uring-2024-01-18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e9a5a78d1ad8ceb4e3df6d6ad93360094c84ac40

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

