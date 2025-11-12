Return-Path: <io-uring+bounces-10525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EAEDC50E81
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 08:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 77578341A1D
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 07:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747E529ACE5;
	Wed, 12 Nov 2025 07:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UmgunZNl"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DAD27FB25;
	Wed, 12 Nov 2025 07:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762932147; cv=none; b=t61vtZKyDe0JFjih2fBSOFw/CYHdAy3wYMSnU+RZJEZcBLiNqsAL855BHy2CSWwzWuwD0GFFhk8Pj3PV8wQTgqWYzCgV/e4DCg+8stYOFZFVghwxbsaUZO1K9bMX2tnuPQnoypDx8oeG5aZ0iFn0t+mCEdsRLehNXO7WlpORoj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762932147; c=relaxed/simple;
	bh=O6UCP/G+PwFHDjWWza6+KFFbEbFZZ47xszmTk+pmq44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IJY5xQV+iQXajngFm0fKdBQQIL4u4deQ8SlYKr+YXJk4I15QCYsTqI5aHSjYzNFQCRbpfErVC6EMhdwbw0ZdMudJn9KTR4ZzeeBm81ZsG4QjupIlZUI8PABf6O8cGicxvFcj3gRtkJ1USBGOUBDhfNKtlB1KEMTsfmqBVGCo0/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UmgunZNl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=iypHX/IvTFhbd6hRQmMRGYvjYeuaIPnHVEBfhwzXUi0=; b=UmgunZNlwPQy+MkncDU67PgzmG
	o5VReWeinXTIIJa7nXpduXS0vncVLLDfA5WXnKtlQQYdADkFkE/mNlTvH0eqcZByGAgUbM9nl5JP9
	02E8uxYg4/h4np8dUYZOM+wzmsBGYiyWa4ZrnI3oTxwLSotSkXUzePr1XShlOsiTIrIV2Vgnk+SCu
	AVK57bcoWCggA7VSHg+R2W7mInC3OhRZiU5DSa7FwuzDk94ERGuJKIXHIEwS5aYeJS+blrORILeUh
	TN0pBIlGSjMwaGrjCj3mOKUFjozkLM4xoCe0EIn1G53SwGMUv6B33TL14ziJ3Lv+ZjcAzZV7BqG0X
	6ZqUaJkQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ5BN-00000008Gjj-31PN;
	Wed, 12 Nov 2025 07:22:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: enable iomap dio write completions from interrupt context
Date: Wed, 12 Nov 2025 08:21:24 +0100
Message-ID: <20251112072214.844816-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

Currently iomap defers all write completions to interrupt context.  This
was based on my assumption that no one cares about the latency of those
to simplify the code vs the old direct-io.c.  It turns out someone cared,
as Avi reported a lot of context switches with ScyllaDB, which at least
in older kernels with workqueue scheduling issues caused really high
tail latencies.

Fortunately allowing the direct completions is pretty easy with all the
other iomap changes we had since.

While doing this I've also found dead code which gets removed (patch 1)
and an incorrect assumption in zonefs that read completions are called
in user context, which it assumes for it's error handling.  Fix this by
always calling error completions from user context (patch 2).

Against the vfs/vfs-6.19.iomap branch.

Diffstat:
 Documentation/filesystems/iomap/operations.rst |    4 
 fs/backing-file.c                              |    6 -
 fs/iomap/direct-io.c                           |  149 +++++++++++--------------
 include/linux/fs.h                             |   43 +------
 io_uring/rw.c                                  |   16 --
 5 files changed, 81 insertions(+), 137 deletions(-)

