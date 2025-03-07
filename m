Return-Path: <io-uring+bounces-7029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8720A574E7
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 23:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A365C7A8626
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 22:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6188257449;
	Fri,  7 Mar 2025 22:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQE6AhX2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23B5256C90
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741386586; cv=none; b=flf71hDYyxTJ2c+Rpi89faWlO7T/OZSSv8XmSwkEfSI3LG79SkVFPGjlhZDu2Ur6ZCEgF4fnlGo4AGGOjIf7YOvSY0Djd/9O+NprH7xtVol1zCBWLFKEMFovEr3XOGqAykr3LMqQ6ypoXP/fjSnlVKgxPHGCCge1PKYM57H8uK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741386586; c=relaxed/simple;
	bh=QZG3dhDCLLDDukUgWBAN30rPHvBo2M7CAlw5yroPoYI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WnVZpWDvuGdym3n9WEtmkykpQ2N1E7wwlNpf/Ywp1fe/p1dQL9psYxUheyU69Ae5PdhFAXGc1QELfBFnyoUMNq1h04W6wFN+QrgoUGAR7fdrvKqWocA8DNELOrY7AKMiOiJ8Ht5dsqy+EzqYIWgg9bzdMxZJeucNK04U34auxw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQE6AhX2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DD5C4CED1;
	Fri,  7 Mar 2025 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741386585;
	bh=QZG3dhDCLLDDukUgWBAN30rPHvBo2M7CAlw5yroPoYI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GQE6AhX2Q9nCp9RUlGrZv0eAPuMoOhPIpWYEdFsSqpY8uR0sfMoqsoI3WiU0CuaQN
	 htaIK7iVX02zc5GwGCpD1ijUyAaCjKVt5hW+tQxJdHUaZvNqatE0HKBdFlcXUrSmya
	 gR211+DChEH5L6eIzKIGtNgK15tMe0aoKLmq+gEWzRCoo1JEa+yLRqGcwdyMDlj991
	 bDKmWOhz2JwHM6OrXM7ytj11l1eH36BOQOHphWDsv6nmDHYYLrJ+0XgSWnb5+OISd2
	 BvSmgOTIPDd8Q0es7TIaVas8dyFUgXgsmK8X3KWFNebbbMJeTSgM5/zFYCaLWiDEZW
	 0EQSiDpHITztw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ECB70380CFD7;
	Fri,  7 Mar 2025 22:30:19 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fix for 6.14-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <00a11162-3ae8-4873-ab6d-e0b119095e82@kernel.dk>
References: <00a11162-3ae8-4873-ab6d-e0b119095e82@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <00a11162-3ae8-4873-ab6d-e0b119095e82@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.14-20250306
X-PR-Tracked-Commit-Id: bcb0fda3c2da9fe4721d3e73d80e778c038e7d27
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d53276d2928345f68a3eb7722a849fb4a0aa2ad0
Message-Id: <174138661855.2506268.13724339972096030125.pr-tracker-bot@kernel.org>
Date: Fri, 07 Mar 2025 22:30:18 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 7 Mar 2025 07:23:39 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.14-20250306

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d53276d2928345f68a3eb7722a849fb4a0aa2ad0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

