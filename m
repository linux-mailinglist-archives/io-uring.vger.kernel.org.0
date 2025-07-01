Return-Path: <io-uring+bounces-8550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C76AEEB31
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 02:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AED417E0F8
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 00:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0763DFBF6;
	Tue,  1 Jul 2025 00:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcSh5PdI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D742FDDBC
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 00:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751329173; cv=none; b=hgGll3w9k/21t+2cob3UF9ntd30Nxif28NzIwdCY89zhYfOBC11msr6baMGnxki1MAdvS/AuTz2e9YeDif6AtMuYo4+eeA/oqY+DMrMta1Q2AyD7oyvteSMceC7+yBVibOrcKNqM5d4n4OB09614ReLOTqJE9AbYnOG9oKMa6k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751329173; c=relaxed/simple;
	bh=+7Ok6r9Cdw0PG58JKP4EaGvSGxBSadwlJYVDD+0WXg4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=T1QUgtzUSPHG3ssJ3DrC3KwLNBSaLtDfsCFivuIlqXm6reyD+ndN147VRiTmw4Qgvwpfg8QxfTL+OY6opBxfvlfM52OzDXEHNcUCWQfZJBdsJVyA7M6r/4+3YfX0fLzI4QgtpqAumz+Vt0DLGCb4MU1wOkJJhSKcYv264J9a09A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcSh5PdI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601F9C4CEE3;
	Tue,  1 Jul 2025 00:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751329173;
	bh=+7Ok6r9Cdw0PG58JKP4EaGvSGxBSadwlJYVDD+0WXg4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lcSh5PdIzGv2M5mkCyq2YtJVeg+/Es3EsVbsG59cEVxeZAhE1pOwKo14l9BlRH1uj
	 Luy8LjS5ARxLX+mFHJPGcPk8P2mthGklxzvYuk267ncnMfQ3U3EZjCUkyysl1/zyJf
	 frw8w8MGRMDNhOfgb+9bnHH8YeCkzhqkANbZRZ0+uW21jlDxKSh5C/+MMP+xUyLxp0
	 sC57gRfTwhACZ6KRjByp/Ukt5eoZ/srS6zOVLyBqvDaSW4F9PG+eUwZT4CZbPqTxNg
	 YI3SvCatbfluNCkHVn7aLQZ61703wIUMBA3yoLf2h7Rnh2IV1Ev7RXR16a4IY6/9am
	 gQKqQNqOnjp+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADC8D383BA00;
	Tue,  1 Jul 2025 00:19:59 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring work-around for S_IFREG anon inodes
From: pr-tracker-bot@kernel.org
In-Reply-To: <c80c82d7-5727-4b8a-b995-2de1d5733103@kernel.dk>
References: <c80c82d7-5727-4b8a-b995-2de1d5733103@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <c80c82d7-5727-4b8a-b995-2de1d5733103@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.16-20250630
X-PR-Tracked-Commit-Id: 6f11adcc6f36ffd8f33dbdf5f5ce073368975bc3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 66701750d5565c574af42bef0b789ce0203e3071
Message-Id: <175132919818.3616005.16325326137048655357.pr-tracker-bot@kernel.org>
Date: Tue, 01 Jul 2025 00:19:58 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 30 Jun 2025 15:17:54 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.16-20250630

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/66701750d5565c574af42bef0b789ce0203e3071

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

