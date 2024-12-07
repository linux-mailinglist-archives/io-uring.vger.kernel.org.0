Return-Path: <io-uring+bounces-5294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA5B9E81AF
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 19:54:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AFD6281DCA
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 18:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E1714AD0E;
	Sat,  7 Dec 2024 18:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZlAf2N0k"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9DC75809
	for <io-uring@vger.kernel.org>; Sat,  7 Dec 2024 18:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733597669; cv=none; b=CpKOPE8xKlhkxSlwKkZOREGUvZW1+mC7Ytyb6Sojzks8CcmZFn/b25zG7Hf09vgxUi5rCSz6p4q1JIN7EiPd5l+f9AXyFftvI+7iSuHd2i2Gk/PFmC+FP5X3Q13nfMDFoCoh9Af3pbk/mdsRYicv/V6A9gl84ZmJUVirIhdKlVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733597669; c=relaxed/simple;
	bh=akxG7V19bKKKmXxgd1cTkIGSi0dwzEOe+47/42ZYGps=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bvKhlxlAvWR9jAsNcNMWK95A9zhsbGLjOWNiRpNT4kNc+Vwx3h5Xn8NI0YC6Nh/DjGZZkcI7zeqvuW/KugnIPq78O6DIY4OZTM+g+WMk5ud6vafgtUkxKqYhcc8W+UkJITKwyQ7acq/ZXuygUN96lrndJ6FJmxavtOh5FSk6BX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZlAf2N0k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E50DC4CECD;
	Sat,  7 Dec 2024 18:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733597669;
	bh=akxG7V19bKKKmXxgd1cTkIGSi0dwzEOe+47/42ZYGps=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZlAf2N0kaFY9mHsneJV06526NnJb9B4l4oFk/K1Xz8RJN4zXZAKKmLpFPwGakKnba
	 htZttnniU9+DJBGhCOVQXkeWhKSLemPKaEM/rmjrlEoMKP9tg4mZSMw2ISUVEL6vnn
	 QHXzhG3nXbZtnLAkiO/3XFB604oHxF4XI/XzSU1+xiKas3enVjnFWH3g49eIZq7aWG
	 HGYuAFCKGtHAgqlBmSqOKyKGe6WiMyOKk7rnoI4vnJbjugArOfExDg4PrnKibqCB+y
	 u1wCa4EphLiVIZ+vq25lExsFw9uobxcVQAkzKGbOAE6T/uim9Wdf0CUqbeCK+K4+Hy
	 CzRWIgT/jGN+Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70BF3380A95D;
	Sat,  7 Dec 2024 18:54:45 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.13-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <56e8e005-6c33-49ef-8ce8-deb852ea5e84@kernel.dk>
References: <56e8e005-6c33-49ef-8ce8-deb852ea5e84@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <56e8e005-6c33-49ef-8ce8-deb852ea5e84@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.13-20241207
X-PR-Tracked-Commit-Id: a07d2d7930c75e6bf88683b376d09ab1f3fed2aa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa0274d261cc50af416883effdab505fad400485
Message-Id: <173359768411.3037814.3017941482070230700.pr-tracker-bot@kernel.org>
Date: Sat, 07 Dec 2024 18:54:44 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 7 Dec 2024 08:11:03 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.13-20241207

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa0274d261cc50af416883effdab505fad400485

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

