Return-Path: <io-uring+bounces-4814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A39079D2560
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15766B21F1B
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046131CACED;
	Tue, 19 Nov 2024 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IpGPHmFQ"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF659460;
	Tue, 19 Nov 2024 12:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018601; cv=none; b=RpjN/qOK9cruhBfV7xdJIBt7SN0DLQqIuBTHuGcrKInRs5G3yMyJSmMBp+DHQK70w76b6bhF9lXkhkYrT+3gPK2y1f/15q62bZ/mSR8Z5NVaA21ffMj8LrhYeP4YWi/AwcTxkc6ngLxXeMr3O1PDz15Z1RHSv8PEQ7IYz7LvAW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018601; c=relaxed/simple;
	bh=INlRsuc9tUvkx0k0TEZx6F0XIAXsPiluvWXzuBvZh68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j2Q+RaliiN8qSrk15uACGgCJLqyMr244ujFMCB/6AdN7s82GYTx4yC6hYl9cmbByGMysvnqMiSWbLnqydGAkPvVPM+rZvYG7lrBAxHgeuJAB3caI6NVVDSrJajuSl9ncJ6ugo5XaTIpbKbAYAePegWbuviWULlzIIksyBGC5I0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IpGPHmFQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=i3Xl2HhaNwGkbKVGt0Kc10inPZf4kOM60z2ZPtXlPtk=; b=IpGPHmFQDaafcrq9Nd+wv22xd3
	UJxjahLYyIKwwQhWZtAYCrNxEhHH05ThEe70niWoNVtvoWAH4ZJcrRRE8TjbNYHc3wyUfcNVH5lZq
	0BPuCzbhp1XWG6Qz+V4wgS5IRASJHegBDXyNnTVGszl1r6lLPe9XqGfdkedq5mVvI5ZN7rCp1wHZ2
	sx8a1NIYmcGBoRWC5z6qBvbjuzRbzMrZ6KkLbmjdRSHK7dlYZTpsOVAb9RT58xGX2lo/od0bCaVcA
	uo1rFdkr/OxSzKgAt2+YRs9gK/UEHlqLQNFlt6DKEK5d4Y8k2ZEi5ZlWg3XnZOaqRErFAGY+2oe4I
	BBPfH1NQ==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDN9n-0000000CIro-1RHM;
	Tue, 19 Nov 2024 12:16:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: support block layer write streams and FDP
Date: Tue, 19 Nov 2024 13:16:14 +0100
Message-ID: <20241119121632.1225556-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

as a small interruptions to regularly scheduled culture wars this series
implements a properly layered approach to block layer write streams.

This is based on Keith "Subject: [PATCHv11 0/9] write hints with nvme fdp
and scsi streams", but doesn't bypass the file systems.

The rough idea is that block devices can expose a number of distinct
write streams, and bio submitter can pick on them.  All bios that do
not pick an explicit write stream get the default one.  On the driver
layer this is wird up to NVMe FDP, but it should also work for SCSI
and NVMe streams if someone cares enough.  On the upper layer the only
consuder right now are the block device node file operations, which
either support an explicit stream selection through io_uring, or
by mapping the old per-inode life time hints to streams.

The stream API is designed to also implementable by other files,
so a statx extension to expose the number of handles, and their
granularity is added as well.

This currently does not do the write hint mapping for file systems,
which needs to be done in the file system and under careful consideration
about how many of these streams the file system wants to grant to
the application - if any.  It also doesn't support querying how much
has been written to a "granularity unit" aka reclaim unit in NVMe,
which is essential if you want a WAF=1 but apparently not needed for
the current urgent users.

The last patch to support write streams on partitions works, but feels
like a not very nice interface to me, and might allow only to restricted
mappings for some.  It would be great if users that absolutely require
partition support to speak up and help improve it, otherwise I'd suggest
to skip it for the initial submission.

The series is based on Jens' for-next branch as of today, and also
available as git tree:

    git://git.infradead.org/users/hch/misc.git block-write-streams

Gitweb:

    http://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/block-write-streams

Diffstat:
 Documentation/ABI/stable/sysfs-block |   15 +++
 block/bdev.c                         |   15 +++
 block/bio.c                          |    2 
 block/blk-core.c                     |    2 
 block/blk-crypto-fallback.c          |    1 
 block/blk-merge.c                    |   39 ++-------
 block/blk-sysfs.c                    |    6 +
 block/bounce.c                       |    1 
 block/fops.c                         |   23 +++++
 block/genhd.c                        |   52 ++++++++++++
 block/partitions/core.c              |    6 -
 drivers/nvme/host/core.c             |  151 ++++++++++++++++++++++++++++++++++-
 drivers/nvme/host/nvme.h             |   10 +-
 fs/stat.c                            |    2 
 include/linux/blk_types.h            |    8 +
 include/linux/blkdev.h               |   16 +++
 include/linux/fs.h                   |    1 
 include/linux/nvme.h                 |   77 +++++++++++++++++
 include/linux/stat.h                 |    2 
 include/uapi/linux/io_uring.h        |    4 
 include/uapi/linux/stat.h            |    7 +
 io_uring/io_uring.c                  |    2 
 io_uring/rw.c                        |    2 
 23 files changed, 405 insertions(+), 39 deletions(-)

