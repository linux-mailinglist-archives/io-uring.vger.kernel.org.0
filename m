Return-Path: <io-uring+bounces-7727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD70A9D12E
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 21:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B25A97BAEE5
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 19:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8C71AA1C4;
	Fri, 25 Apr 2025 19:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+IYH9Ic"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DC212B73
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 19:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745608184; cv=none; b=LjJIIBAwZCqzRYfj94UhpZiBW47DN1nRkPRUgrawisDH6HRRuviypvlR6aTGsWm1pzo5yZUEbkbtVtZ2MDecxAg5ho2xCw4mqzXEThLE2/kd6SFULBOpvrQy7HQF5c5CrdtVymvmmTfJF6LTUT5obaKQ8yP75WMha2heVP5kmPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745608184; c=relaxed/simple;
	bh=A4IYzI/TX/HAxQ3TOTa0UcLVbjTo79L/uJHwcxrqKmk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pNEhEoCDq8iADeIY9F2n+ImGsYfvqGJDN8240cMOTK6A8wrVWRtAGJCBAWA6sHtCHtoxlDN7R+v3PkUcTFFqUUzlJC/nL4UPkq8u8xIzTuTHN30uZioEmuEFUmb0pM8GjqIKOE/Q/cSlOepGq3uR0O0aQR5AzCcV4eqLmRfO4Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+IYH9Ic; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E95C4CEE4;
	Fri, 25 Apr 2025 19:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745608183;
	bh=A4IYzI/TX/HAxQ3TOTa0UcLVbjTo79L/uJHwcxrqKmk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=h+IYH9IczMcu/B9z+T67GxFhU05cL3hSYWbWhlsTIP0jWl0URrwyeihLJS0vDtSbM
	 GbYS97cq+lgA73Mg9jZBvQZHVd2LJdLDPDOGAaZh5HSAXhWNDVn48agVYzaTrIEzVK
	 szcPQm6ybS11TDYfXU1qQOku6TMgujGj0UTmc5rxTE8pFKS4DhsMhzLZauXGiA6idE
	 f+TQXja+FY+hfrRhGQn9y8gzTIkwg3bpAucI9H9pjBxMysr/b4v0hW5N0DbTvJVgBm
	 5IN5aJSYIxhVduDIz2aESuq+aHb0iMmpMUE0JI2vKeIsyfhaPf9VcJzPEo8wjXL2lN
	 qYm2APdOJfuzg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE3E7380CFD7;
	Fri, 25 Apr 2025 19:10:23 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.15-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <e393e036-2d3a-4636-834a-094f8364ec94@kernel.dk>
References: <e393e036-2d3a-4636-834a-094f8364ec94@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <e393e036-2d3a-4636-834a-094f8364ec94@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.15-20250424
X-PR-Tracked-Commit-Id: edd43f4d6f50ec3de55a0c9e9df6348d1da51965
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0537fbb6ecae857ee862e88a6ead1ff2f918b67f
Message-Id: <174560822241.3807073.429409021282516402.pr-tracker-bot@kernel.org>
Date: Fri, 25 Apr 2025 19:10:22 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 25 Apr 2025 10:45:39 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.15-20250424

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0537fbb6ecae857ee862e88a6ead1ff2f918b67f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

