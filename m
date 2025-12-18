Return-Path: <io-uring+bounces-11176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E7BCCA2AF
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 04:25:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B04C300E795
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA0B22A4E1;
	Thu, 18 Dec 2025 03:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.b="WbsDjvYV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-m49200.qiye.163.com (mail-m49200.qiye.163.com [45.254.49.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581C823C503
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 03:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766028307; cv=none; b=YEpbXMWikb0lIitxlYo6dV2Y7zlfrtRfq/Ob9rF7SZa1847P75/9UTgPEJeA0IRS7Gp0Akov+E3O8RY+nkfylQk8FZvfRPeUJeidnxrVPUrVkXPK8kVOc17MlNg+rs4hdr+YuGrfLJaod99DdppUh95YXmfHV/4OIntFV+jGRrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766028307; c=relaxed/simple;
	bh=ZO0OumQCBl4d5h8TJmhAJiBSSzk0MUSvy29lYqqASy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipqaNfl6ckD8oB0ThA/K1lw2q3orpqZ9Ga1RfoWdzgKM6gerrNMt77BIYG+rVxme0Ev8FpV12hr4RVbXEkn3cMqBtfavLKU1eHXVSQ+cFTstuWuHka+0Sh3vU3wKQvO+BAHelPbuIVZMVGiLIuPk/0AFfVxav8ArKSPNvnc6Eww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; spf=pass smtp.mailfrom=deepseek.com; dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.b=WbsDjvYV; arc=none smtp.client-ip=45.254.49.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deepseek.com
Received: from localhost.localdomain (unknown [111.119.196.70])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2dae7a9e8;
	Thu, 18 Dec 2025 11:19:43 +0800 (GMT+08:00)
From: huang-jl <huang-jl@deepseek.com>
To: ming.lei@redhat.com
Cc: axboe@kernel.dk,
	csander@purestorage.com,
	io-uring@vger.kernel.org,
	nj.shetty@samsung.com
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use single loop
Date: Thu, 18 Dec 2025 11:19:42 +0800
Message-ID: <20251218031942.130778-1-huang-jl@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aUNmrSVkZEMk7xmF@fedora>
References: <aUNmrSVkZEMk7xmF@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b2f787a5909d9kunm33306bdf6814e6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaGkJNVk9JTEofSENCSUtPH1YVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKSkpVSkpCVUpCTVVMS1lXWRYaDxIVHRRZQVlPS0hVSktJQk1LSlVKS0
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=WbsDjvYVI6lIXlJro5Utnm3/vcv87yPnb2EVrWftBz6LdgejoG2cQzKkpdC5zQ04Eitg8tB4bQDl0uWRfSDB7sn6zFSwGV/tM4QjGZH230uuoUkDvsg/7OsnScJiKO6vtarXdkOxgOLlkIZ4F8cNQKr2iLaAnJMwwJUHhsYiHKs=; c=relaxed/relaxed; s=default; d=deepseek.com; v=1;
	bh=ZO0OumQCBl4d5h8TJmhAJiBSSzk0MUSvy29lYqqASy0=;
	h=date:mime-version:subject:message-id:from;

> ->bi_vcnt doesn't make sense for cloned bio, and shouldn't be used as multiple
> segment hint.
>
> However, it also shows bio_split_rw() is too heavy.

Sorry, I'm not familiar with this area of the codebase. Perhaps need
someone else to provide more valuable suggestions.

--
Thanks,
huang-jl

