Return-Path: <io-uring+bounces-8073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B51F2AC0D55
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C491D7B8D3D
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 13:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B33928C03A;
	Thu, 22 May 2025 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bjTjcLD1"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7843328BA88
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 13:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747921863; cv=none; b=MUfo10L+LhhVb3jBTlCxk2pzRaKHiOi89UJ309oIJK++tQui7NGB7SF3yDOyg993BsN5mbVJVuFElI0e3t0BkbfmsPEJYZMGxgSPAfnN+Ffw5wNES9vDWbDHR4Hqov7YpY84d+H4k5XNGC7i5cntRW+IM9/sTziEsbTguNQX7dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747921863; c=relaxed/simple;
	bh=uGIhmiJdIgDsOsINH+7wWoxm+Ik49B2rfC1ih9vF/7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NdbsLDkLkCQgErYwcstUoeL4mk+EZR3LQsoev9WPInUR2aguKiNvb/iidC+gyAWUnx6PIoBH1SZjdzF3p0CDjx63iQN/Ml2Vv2A4he7nAeZZ3ogUS9QFLrq8ib8vfRoY8rsGzya/Ir++LijHv2JOHqOK6l7nPfmNubXwbi+++Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bjTjcLD1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747921860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ofri7kRCSQRU5eclb3T8mDlkKar/3KS1t/y5MqB/dMQ=;
	b=bjTjcLD1bQpdYlwOPdoJvb7x/FORydpxYZRnD9xL5VpVE+s3Wiuf9UG/JXlMmqKfCrqoIz
	mlugGgdePrEM90J6hZrrjdsdaXL5F45G5DAhfPwS5Sb60k1bJE2odXg11rzsf1y0QXY/4V
	f4+K+hSH2CspDMLrI2tcmRDjdDgv7xc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-SsZGn39fP5WNU8B71BnDgw-1; Thu,
 22 May 2025 09:50:57 -0400
X-MC-Unique: SsZGn39fP5WNU8B71BnDgw-1
X-Mimecast-MFC-AGG-ID: SsZGn39fP5WNU8B71BnDgw_1747921856
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1BD81955DAD;
	Thu, 22 May 2025 13:50:55 +0000 (UTC)
Received: from localhost (unknown [10.72.116.39])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 461B230001A1;
	Thu, 22 May 2025 13:50:53 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/2] ublk: run auto buf unregister on same io_ring_ctx with register
Date: Thu, 22 May 2025 21:50:41 +0800
Message-ID: <20250522135045.389102-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hello Jens,

The 1st patch adds helper io_uring_cmd_ctx_handle().

The 2nd one use the added helper to run auto-buf-unreg on the same
io_uring_ctx with the register one.

Thanks,
Ming


Ming Lei (2):
  io_uring: add helper io_uring_cmd_ctx_handle()
  ublk: run auto buf unregister on same io_ring_ctx with register

 drivers/block/ublk_drv.c      | 19 ++++++++++++++++---
 include/linux/io_uring/cmd.h  |  9 +++++++++
 include/uapi/linux/ublk_cmd.h |  6 +++++-
 3 files changed, 30 insertions(+), 4 deletions(-)

-- 
2.47.0


