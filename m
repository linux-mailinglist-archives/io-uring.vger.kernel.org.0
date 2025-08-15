Return-Path: <io-uring+bounces-8976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA82AB280D0
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 15:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 508191BC500D
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 13:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240BF2C187;
	Fri, 15 Aug 2025 13:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+O3IcDl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA86B319855;
	Fri, 15 Aug 2025 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755265694; cv=none; b=bluQ7DTcjKN7ArJ9f7EuZeb1q0ibqmny7BVxZ75is1k6SCwhHWyLOfI9K9ParW8XzTi4kl9Oag04DzGu0b64k8dlHCYtliEWYJEDge4d1ivnE6bM0AFIMnZEoyRltwXZnw1dZ9HxW6CT7liUJbTPZa+2oZoScKcza/WwzvjGpMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755265694; c=relaxed/simple;
	bh=9GC8YNSryycAQy4pjU6uW/vxIebpz36D+MB9zTU1Y7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYVo9w4JKIRshGhMe4HXBED32BbX8aY8k2O6BHEHyNsz5Ifsg04TLZrF1M78HKnDMwpz1BLAW5ZaGoo2hrFEx8RiI5ENchUwwtC9hrg4n577zK+ZjIFfANdd8pvO3+ptptNB2Nyiqx4101PfCk9TTUmPBiRHThBERfarv941LI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+O3IcDl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A338C4CEEB;
	Fri, 15 Aug 2025 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755265693;
	bh=9GC8YNSryycAQy4pjU6uW/vxIebpz36D+MB9zTU1Y7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+O3IcDlZuxz7EVXg4wj/MnBKp6ESsHHF5NDyujoyG8wFiJTu/oewW7OVFNTMsOEF
	 tzZ61JzVvclwxAZo5IR7fH6rFnpiAppIII3c1CQDkwzvQIwHoRZNOnBzPusV1lyuHH
	 FTrgGOwSmmGAH4wNyzZ4VNGysVJbq9M80R+DM7wcppfzh8OzVAbQ5qwidm1HqaIWCj
	 gDMP/5ntStlRgW7HMHL6MxXxDS0IeVwBPg2+qPf1yZYzAv0/T7QEc64sxn4pwCuicn
	 QCIIxQ6ooBl0xgdw6tlSVaQ88pLXUDBWvleRgJhC3G23yDSgFUVt/QVYWwfxy6Yl4H
	 6AcJCNgApyUOQ==
From: Christian Brauner <brauner@kernel.org>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	linux-nfs@vger.kernel.org
Subject: Re: (subset) [PATCH 3/6] fhandle: do_handle_open() should get FD with user flags
Date: Fri, 15 Aug 2025 15:47:58 +0200
Message-ID: <20250815-reihum-trennen-aca5a78bde2e@brauner>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250814235431.995876-4-tahbertschinger@gmail.com>
References: <20250814235431.995876-4-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1233; i=brauner@kernel.org; h=from:subject:message-id; bh=9GC8YNSryycAQy4pjU6uW/vxIebpz36D+MB9zTU1Y7w=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTMt5rhtfqpYbrF+tYS71DZgml9cw76Xb/ok9CQ8WzJw /67dvtfdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE0ZHhv8+2SXNuKq6a8ztW 94Xanp5w3WKP9k1ha+z7d3nxdkZ65jMynPrucFr/cHvAxU1Tj05w6H480XiuKsOSOWIvdB2Ot8x ZzAgA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 14 Aug 2025 17:54:28 -0600, Thomas Bertschinger wrote:
> In f07c7cc4684a, do_handle_open() was switched to use the automatic
> cleanup method for getting a FD. In that change it was also switched
> to pass O_CLOEXEC unconditionally to get_unused_fd_flags() instead
> of passing the user-specified flags.
> 
> I don't see anything in that commit description that indicates this was
> intentional, so I am assuming it was an oversight.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[3/6] fhandle: do_handle_open() should get FD with user flags
      https://git.kernel.org/vfs/vfs/c/b5ca88927e35

