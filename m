Return-Path: <io-uring+bounces-524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D329847AA2
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 21:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6049B1C26634
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 20:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB0A1754B;
	Fri,  2 Feb 2024 20:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0PGFcMl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2A781725
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 20:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706906618; cv=none; b=Zpfj7Pby3oI0pEttYTStPEj++bWYKej+Ii7TIHUn4UCFaQeVbeJgv8Y/t5WmDUWyDQt230r/Z+gDjcG2kHGqYZMClE5S3zS6oTQAzs7hYCa82zR3LJyE1HBPPujexeCRrTEoPDZ6WT6AGT4/WKUKe+fImYbPRQw6Hi/gdWbgv4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706906618; c=relaxed/simple;
	bh=4lNhg9gsa8XtlL90yJ37aSqq1Yf6iTGRo9tARtV/69Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HWoNi5xdve/zx6Xyc6OzhEiFd2R6hS4FK7PCiWHn//ZOkUMBxx6LvGjnGXI6MKQ1d0IJlJGjUsrSMvYhOm3beyWj9RChskzG9EjmnlGQJVakO971FDJG76/liqs6qJgFBx2AiUedsJk2++n7jiO122I5YaucFaypmFBdWNly+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0PGFcMl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 654DAC433F1;
	Fri,  2 Feb 2024 20:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706906618;
	bh=4lNhg9gsa8XtlL90yJ37aSqq1Yf6iTGRo9tARtV/69Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=C0PGFcMlZMgn5xWxdVC8mMeObtT7f1dH83Sbo37fIZ5wthUxVYViXwDVA3Lru640U
	 iAaOoysbZc0MAMjoer4Pq2Ix6hrRwdKTUPWnEbqWZvGUYA8QkLDnvOl3p0lQl5d7x9
	 9viJl8BBhbNOcnDRgsa+43OS7KB+aQnyRpbSo4CDA6gHtXmKpii0TquZTRPcagFu/T
	 wSyk8wmvc7TfL+M1PdxdH79lLdNIb4Wqr3wg9SkRZ8zkQIbg0yD90ML6eGtsh6Cd6p
	 o72XbpHvhLjRB3G8uSIWD3ceBdJRQgy5YBubv9U8EWdHbEIBQ5rdf4NseW6vkqeFCe
	 wAZjfIvDWrd7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53B9CC04E27;
	Fri,  2 Feb 2024 20:43:38 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring fixes for 6.8-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <fd1e8ec0-a2c1-4719-a493-479f1d695f66@kernel.dk>
References: <fd1e8ec0-a2c1-4719-a493-479f1d695f66@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <fd1e8ec0-a2c1-4719-a493-479f1d695f66@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-02-01
X-PR-Tracked-Commit-Id: 72bd80252feeb3bef8724230ee15d9f7ab541c6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 717ca0b8e55eea49c5d71c026eafbe1e64d4b556
Message-Id: <170690661833.32059.13880888285969571887.pr-tracker-bot@kernel.org>
Date: Fri, 02 Feb 2024 20:43:38 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, io-uring <io-uring@vger.kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 2 Feb 2024 08:13:38 -0700:

> git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-02-01

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/717ca0b8e55eea49c5d71c026eafbe1e64d4b556

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

