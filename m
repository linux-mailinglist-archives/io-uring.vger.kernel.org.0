Return-Path: <io-uring+bounces-5620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69B069FDC19
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 20:16:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D54C7A12BE
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 19:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7013E18B46A;
	Sat, 28 Dec 2024 19:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsiWO3vh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA4A1791F4
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 19:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735413367; cv=none; b=MpgNK3f6Iya9+rJNaCfGn1o6ghOYW3b8V6Msme/PCEMgFJK1Dz1Jue068JfqP3EETUSKLV4vFMC5ZzlG2uR9p7CU1AB7d/05rHJzdnPsGjePjF5pz8ZJgqAir+vWBU6HFHPddI3ql5/KfFc3bENuXvoaFIDPJfsZLWbA17hkW2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735413367; c=relaxed/simple;
	bh=Wqiw/e/rokw4JcYKxYdEn1+7OHtwMH+bQ3/Y7rTNxXY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JPVwelceU/mKDQg0TxkpmOxiRod6SABPxoWH0Fcz2IrndqNNtY088qbyx2rD5UxLxuCFdgx5QHqUoXmNEHsE2NHDglJotBMMYMHgrLFf2zEJNaPAybjATMiFOactyzSHdQggf5GnrT/Rz0ebyPg2kfU1vKL8sRy5EZ2arWRzq04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsiWO3vh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECC5C4CECD;
	Sat, 28 Dec 2024 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735413366;
	bh=Wqiw/e/rokw4JcYKxYdEn1+7OHtwMH+bQ3/Y7rTNxXY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LsiWO3vhZ1JQvja16CfyQ7+BUUEi1ovgAvezSSQxOT1niQk7ULxjwqTD6Q6/QYnKg
	 ZZQHQow/LEFFx0EVMx599f2wf6UhCo+48CMdGisv2s2Dq8vsuNgLHQIEjFG/sN1cnz
	 m+5dO0etKY3lgwVrwDWTVATAGvYpVdL5PXIXBKPeKt6axy3knleRWj2nm0IlOVvTnF
	 2sOyJSz1quwLK93KYONeJb93znDY8iTHdl4VWZTeeAAy81UDl1HetfKfXT8sZ8UVOW
	 jaJl2eEjZQn8uk7RFXWQv+/5I/EKJJPX63y1zKDInGBhWW3SxOqwTuVH8XCiQV8DCR
	 MYb/7N7W+/KaA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 711F93805DB2;
	Sat, 28 Dec 2024 19:16:27 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.13-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <74951781-647c-4de0-9d4e-5485cf9f36af@kernel.dk>
References: <74951781-647c-4de0-9d4e-5485cf9f36af@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <74951781-647c-4de0-9d4e-5485cf9f36af@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.13-20241228
X-PR-Tracked-Commit-Id: e33ac68e5e21ec1292490dfe061e75c0dbdd3bd4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d19a3ee573e31d74d5d13595ec515660ac8a3800
Message-Id: <173541338598.748444.6849339433531658357.pr-tracker-bot@kernel.org>
Date: Sat, 28 Dec 2024 19:16:25 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 28 Dec 2024 09:30:51 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.13-20241228

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d19a3ee573e31d74d5d13595ec515660ac8a3800

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

