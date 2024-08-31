Return-Path: <io-uring+bounces-2991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CB6966F34
	for <lists+io-uring@lfdr.de>; Sat, 31 Aug 2024 06:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E3F31C21D1C
	for <lists+io-uring@lfdr.de>; Sat, 31 Aug 2024 04:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFBA678676;
	Sat, 31 Aug 2024 04:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FsD6nLXe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EB52E630
	for <io-uring@vger.kernel.org>; Sat, 31 Aug 2024 04:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725077512; cv=none; b=GFLnL8jhZHK5Vb3gD9aGnxEFkc9NXikcwFA7et8Omp8OwpISp/EcFxmj8dQF6jTWI24vM6a3WLncJEwyHbmmvOI1OdQ9vWtCffZWMPs/M6ZigMx0lS4tjEME0ewGj4ddFrA0j1uHuMTUf8gyRFdmaKzrZN8kyaj5YjSIiWiu4n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725077512; c=relaxed/simple;
	bh=4ljOLgPXrMtbp2BniPfxSoqSz+QMG4keF+1ux2Q2t6g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LXA+YD7umusC6OZryfYZr/9g1QQTexy8Z36VnO9Bh/uL70J/CAInqeuYuFZVDLXNog3caJfpa4NaSCJ8Vlo5dnMCfSDlyt+mQnKaTMzuUy238d17+X69S7XGzFHzT8mO+K4r6+73R4jbEEOTnv661QvwbZuIFwgnJclt+XrZlWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FsD6nLXe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EBAC4CEC0;
	Sat, 31 Aug 2024 04:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725077512;
	bh=4ljOLgPXrMtbp2BniPfxSoqSz+QMG4keF+1ux2Q2t6g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FsD6nLXeCAXCTM6QSoHWFhOtFMqm3dGU+X+sUW1cwIkQfEwGGnaVvR6WqVzpwNo9k
	 2azoZ1VtOyrVYlaFoqVPT6A/oBBRIKglq5hoGE/kGSz6yRN5bwx3FVlC6UXS7cxtUy
	 HDfc2RRWJ8xNlxYzJH9++D3tBLQ74LUo4DwW5mOCAg2LaE2JeVVbgONtBSOBAV5odL
	 EB9xO8D/gMc9dWftWKuZpdE0uTGySxn+nzTHjQCPSulTJBciGPLzG5xOhh+C7KvkJ+
	 PENSIKHgjFk7u80PxIkMqZPCAVMvDpyOWBnPIWlCQe9JWZ5X5sivK8KO28H5RnZc0a
	 hvW1amkR/g01Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB2953809A80;
	Sat, 31 Aug 2024 04:11:53 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.11-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <791375ed-d460-4fa4-81da-fffea554de2e@kernel.dk>
References: <791375ed-d460-4fa4-81da-fffea554de2e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <791375ed-d460-4fa4-81da-fffea554de2e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.11-20240830
X-PR-Tracked-Commit-Id: f274495aea7b15225b3d83837121b22ef96e560c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ad246d9f04aa037f8e8bbf8573c9af527114cead
Message-Id: <172507751259.2790816.13854526886156943618.pr-tracker-bot@kernel.org>
Date: Sat, 31 Aug 2024 04:11:52 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 30 Aug 2024 14:31:57 -0600:

> git://git.kernel.dk/linux.git tags/io_uring-6.11-20240830

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ad246d9f04aa037f8e8bbf8573c9af527114cead

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

