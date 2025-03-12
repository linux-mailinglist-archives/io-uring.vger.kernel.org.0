Return-Path: <io-uring+bounces-7058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9B5A5D84F
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 09:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C53B3B3C29
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 08:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD83F23278D;
	Wed, 12 Mar 2025 08:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRbA55BK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0651DB356;
	Wed, 12 Mar 2025 08:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741768576; cv=none; b=TEd/5et2p2mrKe/Hna1NQXFYYgju08mqu6CaH3GOFt4ONo6UnlPxjbwGmtaUAFr8ApvcXiWV5QXNvG6J1kbjabS7wOWQnUnVvcA3EhAvkQvg3q+dVRURnjJB8BjWlavJYZ8eRhUEffLJG/6EvveKclWZja9xZpGN/2/8wU5NooA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741768576; c=relaxed/simple;
	bh=rAnPETvJ1xWsUR/LEodaT72moPokpP2sjBnMZ54f35U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q9a5wUvSwiCKu8QRW4iGM7ooFa1D4iFSTrQG2y57n3f0nvghWsn7XL+nQBV1wWTQ+ZvUf68r8lhpnE6L6sxXv8HuE5tYKadPJC29nqlyS2WvCQsvJvpo3Iub4kXaMysTT7Nk8szGwESo4XQmgLGCny+FiVG1Xs9QVSOrrpsOnDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRbA55BK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9511DC4CEE3;
	Wed, 12 Mar 2025 08:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741768576;
	bh=rAnPETvJ1xWsUR/LEodaT72moPokpP2sjBnMZ54f35U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRbA55BKdEP2X00NG+FMCqNQ7hjGMlhWXGYiB76VnY5W7+Z0XJhLa+J3TsIrE2tMX
	 GGcYg4KK5ZNkqpwP51pKaHYS5zo1HtxpFhHLBMOy5bt+yl2ccP3MdCw3UzeKJlJENl
	 QzQF+iM5vTSCE5xsoUciSvrCMhR0mEObkYf5dSFpv+oAtYwp+tr54DlOGSZkVIZPpQ
	 VOlRJBEBhsZh1pW9rF1aekQM0HNuk7g2Gwsf65CNaai5lzDdy1N/RCPZSZLxNz2uZg
	 rzShVnYs6FSYdDXH9LwwDM2dO+vmlBjP2iSVBzfjt4Aj6/eLnsE09fKT2bZoe88meF
	 56J+Y6R+BUZfQ==
From: Christian Brauner <brauner@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	audit@vger.kernel.org,
	axboe@kernel.dk,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH] fs: dodge an atomic in putname if ref == 1
Date: Wed, 12 Mar 2025 09:36:00 +0100
Message-ID: <20250312-zwang-farbbeutel-a4c031fd05df@brauner>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250311181804.1165758-1-mjguzik@gmail.com>
References: <20250311181804.1165758-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1101; i=brauner@kernel.org; h=from:subject:message-id; bh=rAnPETvJ1xWsUR/LEodaT72moPokpP2sjBnMZ54f35U=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaRfdC8/qhb3VNT6qUXTrfW2pXzzhRMVM/8d1xfcvDjhR eizt+c6OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZieoDhf+0mrRVrZW9OuGA6 t+7I5S1lhpOtbirMLRV1XS4/panBYj/Df+8Psku+MP/luc937fHuO88eBvfc2lyy6P7OaVE3vx7 ecoMBAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 11 Mar 2025 19:18:04 +0100, Mateusz Guzik wrote:
> While the structure is refcounted, the only consumer incrementing it is
> audit and even then the atomic operation is only needed when it
> interacts with io_uring.
> 
> If putname spots a count of 1, there is no legitimate way for anyone to
> bump it.
> 
> [...]

Applied to the vfs-6.15.misc branch of the vfs/vfs.git tree.
Patches in the vfs-6.15.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.15.misc

[1/1] fs: dodge an atomic in putname if ref == 1
      https://git.kernel.org/vfs/vfs/c/c93617c0f22c

