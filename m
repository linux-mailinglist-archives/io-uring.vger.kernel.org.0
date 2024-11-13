Return-Path: <io-uring+bounces-4650-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A259C765E
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 16:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15DA31F22D52
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 15:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56544770E2;
	Wed, 13 Nov 2024 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n0+N44EC"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EB170821;
	Wed, 13 Nov 2024 15:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731511261; cv=none; b=BXbC6l2kRvognHfdJte8KSSBV/UeSQEntQjAZ++E/YXEz64I+gBSOb2jGfkmDMhCsecXGJZbKKmizRGd97z2jce2TmY7UHFhMTOTVrYaVclljJ1zIOGKF3mL8iv1D8j8wT/E7aGIifqfwSO+xAZGKpwdB21IFi5Yh26ISQethP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731511261; c=relaxed/simple;
	bh=PQf+ORgVZ62CsqD+2hHn9OlRq5homWIcAYI8WK6p6zM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VN2cA5uW40qOZ32SkJoE+ouXoVPADZjA56KJDAhV+jePgC5yqS8tMkGKxjOvi8XgbUQ++lGxXzPozDAjrXBv61PMI5BBQpR+4ennaDuv9xLjh4RiEy87CbuMpgemeRFlIulIkbMmLbB2HuPPR0OcknWT2Y1Pl2kSolmPL2vECxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n0+N44EC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=q8dgTHK6/kDNMr//ddeMG12Og5G3zPkIrgOfI02e9nU=; b=n0+N44ECQ2em4BQ6kYXTMVFUgm
	3uPZYzacztyfu5dmzmb/PC5KIqkPvScVQ+cDqxCtRsag5r45nXDZU4db4jhZdUZJplCJSh+9Y7/Kp
	62wtVn+D3Xe4p52wiuPFY6lPRFc4XqVDu+MELPO/2hENWMmf0MS8ajAK3MaAuQSYeqi+gvU871EjP
	BHeQ0TFmMVN7syIiiGVqUVzO7nHxEE3f7Dr3orxSa8fFp2s7R7JuJvqQ5yR+EL6N+9V84k83k1Z1I
	5a7denfVMkbw+R6ieze9KHccSimDUDk3SpvxJLkOD5F9GBdbcAYrQtFeIxND0YpQOrHIQZxrJZwh4
	HYGg6SQA==;
Received: from 2a02-8389-2341-5b80-9e61-c6cf-2f07-a796.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9e61:c6cf:2f07:a796] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tBFAs-00000007HJX-0EfT;
	Wed, 13 Nov 2024 15:20:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org
Subject: don't reorder requests passed to ->queue_rqs
Date: Wed, 13 Nov 2024 16:20:40 +0100
Message-ID: <20241113152050.157179-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens,

currently blk-mq reorders requests when adding them to the plug because
the request list can't do efficient tail appends.  When the plug is
directly issued using ->queue_rqs that means reordered requests are
passed to the driver, which can lead to very bad I/O patterns when
not corrected, especially on rotational devices (e.g. NVMe HDD) or
when using zone append.

This series first adds two easily backportable workarounds to reverse
the reording in the virtio_blk and nvme-pci ->queue_rq implementations
similar to what the non-queue_rqs path does, and then adds a rq_list
type that allows for efficient tail insertions and uses that to fix
the reordering for real and then does the same for I/O completions as
well.

Diffstat:
 block/blk-core.c              |    6 +-
 block/blk-merge.c             |    2 
 block/blk-mq.c                |   42 ++++++++---------
 block/blk-mq.h                |    2 
 drivers/block/null_blk/main.c |    9 +--
 drivers/block/virtio_blk.c    |   53 ++++++++++------------
 drivers/nvme/host/apple.c     |    2 
 drivers/nvme/host/pci.c       |   46 ++++++++-----------
 include/linux/blk-mq.h        |   99 ++++++++++++++++++++----------------------
 include/linux/blkdev.h        |   11 +++-
 io_uring/rw.c                 |    4 -
 11 files changed, 133 insertions(+), 143 deletions(-)

