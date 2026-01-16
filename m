Return-Path: <io-uring+bounces-11758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6D9D2D7CE
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 08:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 36E79307888F
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 07:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02612BE647;
	Fri, 16 Jan 2026 07:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OrLjk2oO"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0313E2BE65F
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 07:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768549616; cv=none; b=pVDKOV2Sm10DbYcFbs4yrEGzj5eptqP+afNwdFrQR2HsDjEeZBikzQbBhq8wHQDuz6/9YBmg6K1rk8IprBzsgIF7o7CuDOP+DjC44Y1RKY6U+cd8Dl21tIB6Gveyn+8+AlT6xZK3KJrK9htY+p9bkIHFRwDN7+57aMitpZ8I0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768549616; c=relaxed/simple;
	bh=LjeHfjmsD9t+ZZBERvrSAQj1waljXxwnYgBLBs19gcg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dGmpuJVg6eITsP29jSoV2dmPjhoFRn7nUpsLNBbb43AGiAWHr7SFctPXIkha/tVaRQC8GmeTcNbcqYcnhzx7acB6pk8PSxp8ZpVRI1StC5v15ooDlRzkvOnoV7V42g5ctHAuSdpl0jHZ2V0JE3bhRJaYqUC/i9i7ndaY5SWYBM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OrLjk2oO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768549613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Uw5SQo76I/dUoQRmEd0OyonqVhtHtUJXX1WXGNe3MCg=;
	b=OrLjk2oOIJ1atRw6/AyYhR6gKc3ze5W42R44lk5/SLLlhwWl4fiQTwuOXvh3+5jCcTKEvT
	qq8G6a5T0HFgmfASOJa7im1APhBYIiihxrasGuPiAJhPdgqp7uNIlVEFQYyXWM4VLyNlY2
	zxfcbwrgdb05fr5Qcd7xzEUe6VQIoLM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-MBclx_u-PRKJq80N7d865w-1; Fri,
 16 Jan 2026 02:46:50 -0500
X-MC-Unique: MBclx_u-PRKJq80N7d865w-1
X-Mimecast-MFC-AGG-ID: MBclx_u-PRKJq80N7d865w_1768549609
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D3601800359;
	Fri, 16 Jan 2026 07:46:49 +0000 (UTC)
Received: from localhost (unknown [10.72.116.198])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 74E031955F22;
	Fri, 16 Jan 2026 07:46:47 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/2] nvme: optimize passthrough IOPOLL completion for local ring context
Date: Fri, 16 Jan 2026 15:46:36 +0800
Message-ID: <20260116074641.665422-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hello,

The 1st patch passes `struct io_comp_batch *` to rq_end_io_fn callback.

The 2nd patch completes IOPOLL uring_cmd inline in case of local ring
context, and improves IOPS by ~10%.


V2:
	- pass `struct io_comp_batch *` to ->end_io() directly via
	  blk_mq_end_request_batch().

Ming Lei (2):
  block: pass io_comp_batch to rq_end_io_fn callback
  nvme/io_uring: optimize IOPOLL completions for local ring context

 block/blk-flush.c                  |  6 ++++--
 block/blk-mq.c                     |  9 +++++----
 drivers/md/dm-rq.c                 |  3 ++-
 drivers/nvme/host/core.c           |  3 ++-
 drivers/nvme/host/ioctl.c          | 23 +++++++++++++++--------
 drivers/nvme/host/pci.c            | 11 +++++++----
 drivers/nvme/target/passthru.c     |  3 ++-
 drivers/scsi/scsi_error.c          |  3 ++-
 drivers/scsi/sg.c                  |  6 ++++--
 drivers/scsi/st.c                  |  3 ++-
 drivers/target/target_core_pscsi.c |  6 ++++--
 include/linux/blk-mq.h             |  4 +++-
 include/linux/blkdev.h             |  1 +
 io_uring/rw.c                      |  6 ++++++
 14 files changed, 59 insertions(+), 28 deletions(-)

-- 
2.47.0


