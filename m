Return-Path: <io-uring+bounces-2354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7C89181A5
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 15:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 037901F23EA9
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922C41836F5;
	Wed, 26 Jun 2024 13:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwRXBlQU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2BC1836ED;
	Wed, 26 Jun 2024 13:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719407134; cv=none; b=JDUiuQOXvIiu5h8tPTk96BG3eQecRMf8LEBVcaSmJws1v+n5zzJn3rR8j0iOF7PZAm97GmtjZaR/X1ST8IFFwe7XrJPsCpgKCxMUVxOFTCHHI2QQ6Z7qCtEhe998tpsfm4LiGC2ABVR6oVhzrtO4Ujy1o8gd3rrzriIJsjxmN1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719407134; c=relaxed/simple;
	bh=L9sxjHFX8ft02tNJgQEXub7nlBwYh461vYlEPqWuW8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pg91RYyikaRS+AnJQKcKmwpp5Bfsfi/elwH6/x/ForWPiXD6O5Qzsn3tliOWC7xRzkmEzP+hCSUvLV7Ga/lMYtWJnddxqScCixw2/8l6Y3/fsFJYUlijcZIP1h0dGgSbFYlsOq79ad3/Y9im6ydQF7Ia70BrRIEfK03jwGgXOn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwRXBlQU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79945C32789;
	Wed, 26 Jun 2024 13:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719407134;
	bh=L9sxjHFX8ft02tNJgQEXub7nlBwYh461vYlEPqWuW8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwRXBlQUTsERI5uoFG49aP5nvfavq94uqaFY36y49nsP7tCvlxSxr0fXFrpIsI+24
	 JfhkBL2wmMjAsWP3dT1SpeH3sY+JLoXRYy/uJVbz7e08zQuLCDl3Y4nNEStnZ7J5aV
	 MbJhGHVbr/tpE80DeOWMEaIaZQenaow1/PhyDHfUC0HNAIzyuQ050NAjn93ZQqRvbS
	 u4ShL/gtdG0D8fHyFhaJWJyFvbWoEsp4n4QVUXv0nKDW2TiVixrojAnXnrgIhxPDVs
	 5qFnD8z77Lg/mA4D+TVI+7N9+V5vJoeNV3mC08uxjgj8oxJt4YhVH70dORwYjqCDCo
	 vCKCcqhLtJm9A==
From: Christian Brauner <brauner@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	axboe@kernel.dk,
	torvalds@linux-foundation.org,
	xry111@xry111.site,
	loongarch@lists.linux.dev
Subject: Re: [PATCH v3] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Date: Wed, 26 Jun 2024 15:05:23 +0200
Message-ID: <20240626-karawane-sozialistisch-7d67edb47e1d@brauner>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625151807.620812-1-mjguzik@gmail.com>
References: <20240625151807.620812-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1278; i=brauner@kernel.org; h=from:subject:message-id; bh=L9sxjHFX8ft02tNJgQEXub7nlBwYh461vYlEPqWuW8s=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaTVCIm+EjTwCvN76r61cCerhL/M8sgXElyP/I/uOrcre pdQrkp4RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERu/2VkmLX2bZ7nhZiG7aaT 9lSFOU7rfmty+U+1jbXchHsBRgfCJRn+ly3bvnPne1+py7e4JbesSHi87cj0oGspE67Nq7woUfa xiQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 25 Jun 2024 17:18:06 +0200, Mateusz Guzik wrote:
> The newly used helper also checks for empty ("") paths.
> 
> NULL paths with any flag value other than AT_EMPTY_PATH go the usual
> route and end up with -EFAULT to retain compatibility (Rust is abusing
> calls of the sort to detect availability of statx).
> 
> This avoids path lookup code, lockref management, memory allocation and
> in case of NULL path userspace memory access (which can be quite
> expensive with SMAP on x86_64).
> 
> [...]

Applied to the vfs.misc branch of the vfs/vfs.git tree.
Patches in the vfs.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.misc

[1/1] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
      https://git.kernel.org/vfs/vfs/c/33b321ac3a51

