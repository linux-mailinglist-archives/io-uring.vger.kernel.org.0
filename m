Return-Path: <io-uring+bounces-10605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BD5C5919A
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 18:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E356F4EDF95
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 17:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D77D2264D6;
	Thu, 13 Nov 2025 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EwiCDDcG"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D2B30CD88;
	Thu, 13 Nov 2025 17:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763053605; cv=none; b=QmTvX5V8diRBUvEHZBxzkh3aUY9xrj39sXjGifWjVXK4ErVY4ANuNC0hrXUbD6YFR9X54mNySDC3RzVnl9i16G1ObOU0vqJqQ6phh5BjPsa9PFGfSr7pv4OFadBVf/Uj057cdiJrRWsRzSGuz2o/zKQfXIp5VP/Vsho20H+wra8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763053605; c=relaxed/simple;
	bh=/zjIPPD4KOrimJ9udWn5qaVwvi8DLUkMqY51ffRhLZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y/Na2kvmp0iD1aw3A5IpcNhp2iUwyHtvcOKqfb1sKZEAmQbRiCORAQE/+Nu46q1VtatidbniKF317yBsJOmjELfyDd39KSfIjtcGxy9OrNYLdgwHwQz23F4rkH9ZxzexhxlIOZtT1pNHBle34SzFfgtkyDLraCy/xgHmBc2NbIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EwiCDDcG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=vn+kIjooTlqcRMqAM0AeTlCeev9sPeS6FSp/2JfIncE=; b=EwiCDDcGNX1Rpo3PPE5w1E7S62
	MYPOdAoyx77G5rgbratLxcyXGADYhEV2pfADWE0VTS+I1WmTcTx78lvfRZi3JMBhwGlPokSZdszZi
	FiSaF0pFcLILkntsy+VkVEXGh2Fz2RxYzpxIBNUomJ5EWS2Sj4tAnsjw4zFFjjF8gzlcOLhwzMGA0
	wBEyboELB0h6IoRqof3QI2eCXD+FuaxABCDB+Lw5dx4B8xiZrwFPU1cVAzLkK4dGHBHuvMbjjQ2jO
	AiE684ItIy36zevm1AeyZ6Tfut3s/i7nS0FLv+UIOm+kpSh7CCBzNgDy+Ns9JRgU0e/0vh5qrxjwb
	o60eeZ3w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJamM-0000000AqMr-109a;
	Thu, 13 Nov 2025 17:06:38 +0000
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
Subject: enable iomap dio write completions from interrupt context v2
Date: Thu, 13 Nov 2025 18:06:25 +0100
Message-ID: <20251113170633.1453259-1-hch@lst.de>
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

Against the vfs-6.19.iomap branch.

Changes since v1:
 - do away with the iomap_dio_is_overwrite helper to hopefully clean up
   the logic a bit

Diffstat:
 Documentation/filesystems/iomap/operations.rst |    4 
 fs/backing-file.c                              |    6 
 fs/iomap/direct-io.c                           |  184 ++++++++++++-------------
 include/linux/fs.h                             |   43 +----
 io_uring/rw.c                                  |   16 --
 5 files changed, 101 insertions(+), 152 deletions(-)

