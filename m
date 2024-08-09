Return-Path: <io-uring+bounces-2687-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8BC194D578
	for <lists+io-uring@lfdr.de>; Fri,  9 Aug 2024 19:32:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27B4B1C21452
	for <lists+io-uring@lfdr.de>; Fri,  9 Aug 2024 17:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930C426AFA;
	Fri,  9 Aug 2024 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erZn2UPK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1BA15E5CE
	for <io-uring@vger.kernel.org>; Fri,  9 Aug 2024 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723224693; cv=none; b=f3ZiwRlF7r0dJqi7J8h4derlTCO8kqyaMiJr0QABR2yY+lTEspYd4JifQMgZfUmFwcyXV0CmVy+HgokqKMwxOwbDFaO82snvMWAAsE7Enxk0K5raPxqSlopWqTlXp5r+V0I+m5EcYbVrL3u2F7xbCC3KHVGZ1QcS6JxtNCAxklE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723224693; c=relaxed/simple;
	bh=GDYQ7LByub6Oi0IkPDw0wBoX8EgCxWG9GAUkX4OyTfo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XEmIZZTUVtw+DGYScTTVNn1Rjnm3roeUFJiFmeL8VhNxqZxycFxcJ4u5SsaCBQ68tPVyPSmF71XxLL+F0y1BdaKFqH87u5vuBWc4tDLNm+lJJSCIHR0CHP2obbBcPng6YizUC3EYDlzdkt1eq5ir8wQpDbQY+XPImNrMoYoF/Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erZn2UPK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D91C32782;
	Fri,  9 Aug 2024 17:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723224693;
	bh=GDYQ7LByub6Oi0IkPDw0wBoX8EgCxWG9GAUkX4OyTfo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=erZn2UPKVMygA8Qs7famn9YBsZbuvex/ZRGdafmmK/sTGGUw3VTJRSfQstPKLPMxH
	 M4MPt/RU3+zanNBYkj0WwmW92XZxxLAIOjytP9r4LxqwZbv/R74tzmbky1iGYwfmPY
	 ILVZ3m/IbpgcNyymFom7Z5u/kmJADhTzQQ+cHjynA00C8udJm1s9lobvKzFBPQqasH
	 5M61RxhzQJACk9cKgemsN491pVRKZEn2Ct382LH5E83bOYkZ+oATSwFwGqMK5G5uRM
	 BIR/r3AY4G/JIUlPXsB5+7mhphxJkbW7tm8kFYbpMaOKZ3phLLjP/gMTqdngBN0SsT
	 r1k8xDPY7LZKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C50382333D;
	Fri,  9 Aug 2024 17:31:33 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.11-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <92988daa-9b80-4d1d-9433-0f153dc71ae9@kernel.dk>
References: <92988daa-9b80-4d1d-9433-0f153dc71ae9@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <92988daa-9b80-4d1d-9433-0f153dc71ae9@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.11-20240809
X-PR-Tracked-Commit-Id: 8fe8ac24adcd76b12edbfdefa078567bfff117d4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8828729c4435b85844a3b6da19cc7c148c59ec43
Message-Id: <172322469180.3855220.1981802189293399948.pr-tracker-bot@kernel.org>
Date: Fri, 09 Aug 2024 17:31:31 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 9 Aug 2024 08:53:12 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.11-20240809

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8828729c4435b85844a3b6da19cc7c148c59ec43

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

