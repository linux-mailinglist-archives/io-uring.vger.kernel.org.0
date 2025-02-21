Return-Path: <io-uring+bounces-6616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7845A3FDA7
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:42:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BED191891916
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7A8250BE0;
	Fri, 21 Feb 2025 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rd5L0N4S"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB1B2500D0
	for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740159711; cv=none; b=PBTkeXmS8hFZZ5zcJaizVoZpjhDLCBtLKva57R177sgLG2vV06hGD6rMHXpb9jazyRLg9x4MobOTrEBGiRYnQlrf2b+hVd/52RLIxk4EEf1XNdhdnkJt7S3E3hbVWijvPKg6oP7mz24SKr5C+fpahmCCCBoIM+TVG8yJLK6+Bm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740159711; c=relaxed/simple;
	bh=6PkffDJusCCu0SoKFzD0W5AqM0ig3dcu2DE2h+IopF0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=diDOSYI/8mB+K7B4vYmcuxzz658mMr880Hr14n/UYbiHA8aGbzGlxR0StiF46qvc0XhDlcVr2nW8/Dq3MkjQ6XqTVWran19eD/pB3YVibCitNvybrP4mUvPoIoXhgxiUvHfewOgFOS1oS+mNFZfQr9ms9o5BCzsUbsC5DLLmX4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rd5L0N4S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB1DC4CED6;
	Fri, 21 Feb 2025 17:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740159711;
	bh=6PkffDJusCCu0SoKFzD0W5AqM0ig3dcu2DE2h+IopF0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Rd5L0N4SfIAVkj20LwXPkhSDHFkUGvkgzHtIJywacoa0UZKKYe3fKhCALv9qYW7T8
	 3E7GTIa+suzCkUtKlJ4qPT1XU0jJNX/JkIJA/uxPAfG2QVVyZiAHa3acLLS/6xBsvK
	 RD/p2j5MJAfsFc5U12mJdKR2l4Pdgc4jYOk2Fd75LyOiz7wna3QMVyUGsjig9JFZBr
	 Nua2XRmw3MQ1jfXbaonRexYynMuF6Yb7cl3DvvtgACMAHELKg+rXgdFBmPxGwsOuLa
	 cJatFMtTA0axcjscbfQoBPQOv7UQiKEMF8ZHPW85WRh7owVvjjkQgyKyp/gz+8NEfj
	 9mGQrCba9uAvA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF35380CEEC;
	Fri, 21 Feb 2025 17:42:23 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.14-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <12ab89dd-5bcc-4d94-ade0-3856a1f35ec3@kernel.dk>
References: <12ab89dd-5bcc-4d94-ade0-3856a1f35ec3@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <12ab89dd-5bcc-4d94-ade0-3856a1f35ec3@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.14-20250221
X-PR-Tracked-Commit-Id: 4614de748e78a295ee9b1f54ca87280b101fbdf0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f679ebf6aa9b42d0edb5b261e16dc7b1e3c3550e
Message-Id: <174015974262.2152716.9101822471181681977.pr-tracker-bot@kernel.org>
Date: Fri, 21 Feb 2025 17:42:22 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 21 Feb 2025 09:46:48 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.14-20250221

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f679ebf6aa9b42d0edb5b261e16dc7b1e3c3550e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

