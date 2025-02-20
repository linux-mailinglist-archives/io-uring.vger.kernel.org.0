Return-Path: <io-uring+bounces-6573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BCDA3D4A2
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 10:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E4153BAD11
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 09:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D2B1EEA47;
	Thu, 20 Feb 2025 09:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlZHx+HQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EC91EEA38;
	Thu, 20 Feb 2025 09:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740043322; cv=none; b=tW6H3il01xtS1+Hb/ddGJih3cWHEnykn64E24xiypve8F75kFEDy95xVMNSbz9jrZwjOCL1DeZQl4u4HeKh993UyRVACKXB7WUpRAk5t+txJetT822Ec4C1QxjippdZUT4Ikfc4RsvK8e4V3Eur9+W3dXUSPJ0VZ6zZy2hrVwmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740043322; c=relaxed/simple;
	bh=8FtZj4mHFAToS9A33uaPVb5k9Zc1e6PIwcbdBChS7+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jojelWhwrKFlU27Q+2Sp1XktTokaHnOq6M6SKYgn+1oLWrV3NV9aiBQFxLYID5EwSmL3HFzxC4xuYeV9zZGYObOw5u3LKjAjtnDQbnAvDny7TwIMaj3Tvah8EHmiiHfDYpPjA4QGDV17CucDA6PfywFYjQtUwjtv2O1iiNtdaSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlZHx+HQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6998C4CEDD;
	Thu, 20 Feb 2025 09:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740043322;
	bh=8FtZj4mHFAToS9A33uaPVb5k9Zc1e6PIwcbdBChS7+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlZHx+HQ5eDfBF+RvhG1FMixLiQhMOIrPSuWF9Hvs5sYqJiWGRQtXbh4fSMsvTQij
	 tqhDxPyaQpp7IgyOyHliTzPH5hFl9Weq9NMv0aD1u8lbFEy7Ml4SJTQu1IHmPmXsak
	 3eCEgJUSu8h4xZqvDnjiw7ljuFJC3WbIQ7ZJQkXbQbFME2hdXQKGEkHMM/f+37wWh/
	 ail4UxHXV/dfYhTHrfP7bn/IazHoDN5UJAaTnX6h7v3UPgsIZVDGflD41I+LxtFGAg
	 zWGhyPGCzaQvX7xCymn1mK61i/hCHgXBZNJQn13NkEmli5WTbHAtf9kqCeShs+R/bC
	 DwmyBEN4jMsAw==
From: Christian Brauner <brauner@kernel.org>
To: io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	asml.silence@gmail.com
Subject: Re: (subset) [PATCHSET v4 0/7] io_uring epoll wait support
Date: Thu, 20 Feb 2025 10:21:53 +0100
Message-ID: <20250220-aneinander-equipment-8125c16177e4@brauner>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250219172552.1565603-1-axboe@kernel.dk>
References: <20250219172552.1565603-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1711; i=brauner@kernel.org; h=from:subject:message-id; bh=8FtZj4mHFAToS9A33uaPVb5k9Zc1e6PIwcbdBChS7+Q=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaRv+2IyV+ve7aMtPf88Ki2uzzWa1GfkVLXYSmE9e+vD4 hmvHnV+6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIchojQ8uc0pKM71drpayr mE6sVlS625Da6P0l7NllJa0px23KHzIy3CrJXV5nv3urw13tn7pez25JNB4MdleX9OLYYv/w25l FPAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 19 Feb 2025 10:22:23 -0700, Jens Axboe wrote:
> One issue people consistently run into when converting legacy epoll
> event loops with io_uring is that parts of the event loop still needs to
> use epoll. And since event loops generally need to wait in one spot,
> they add the io_uring fd to the epoll set and continue to use
> epoll_wait(2) to wait on events. This is suboptimal on the io_uring
> front as there's now an active poller on the ring, and it's suboptimal
> as it doesn't give the application the batch waiting (with fine grained
> timeouts) that io_uring provides.
> 
> [...]

Preparatory patches in vfs-6.15.eventpoll with tag vfs-6.15-rc1.eventpoll.
Stable now.

---

Applied to the vfs-6.15.eventpoll branch of the vfs/vfs.git tree.
Patches in the vfs-6.15.eventpoll branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.15.eventpoll

[1/5] eventpoll: abstract out parameter sanity checking
      https://git.kernel.org/vfs/vfs/c/6b47d35d4d9e
[2/5] eventpoll: abstract out ep_try_send_events() helper
      https://git.kernel.org/vfs/vfs/c/38d203560118
[3/5] eventpoll: add epoll_sendevents() helper
      https://git.kernel.org/vfs/vfs/c/ae3a4f1fdc2c

