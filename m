Return-Path: <io-uring+bounces-8083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A45AC0FD1
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 17:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4726177E14
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E701C4609;
	Thu, 22 May 2025 15:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LnNnnFAm"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFD3298265
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 15:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747927258; cv=none; b=HcvQMXxDpmGlBBghT4Ombx7rbltnR8aqV1tyvv9QOA6cLRLHYtsL0Gk931hlfN/t7EBkc6b5vJamLxLzs8ZJW4GUlAfcwwQrRkqs4WqI5NlxXQ5cHxfoe9k3mZMcUAnHuAwD/K1CRGQgB5QlVOWnMFhTadf0FtnoTNbOCtEmxrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747927258; c=relaxed/simple;
	bh=5yFSgnRCoR5hzBRX4z5o/Vzs3rICy6rloKsSv5U2L9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ednrksE5I9+y+cIqkEh483bLXMfk4YhOnOnZFUDNBbwYvrl1G08C4S1TeoxiKIpzYuzF7RKKYLF6/TyH3c4cx50TsztB8tTcui7lQuw8iaAgMYtQ4fgcG57H2kxYUgLbeWxmixi4nPqmR8Gf/UgcPdB4eGH/xsE8CEPvYeWNBqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LnNnnFAm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747927255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9DIEUIVSfCSgYfBN1pN9oMgRu83Kfd7kAcmYyKh5ED0=;
	b=LnNnnFAmvav9eerafRMO6CyXqUl0T3pbmkU19gD00ErL8B6AMTu7Pi06EOIXhcW39DD2fA
	CZq7vmQu3W4mUpwALC7to3YRN1Nnz9UqWLOZoS883KcWFexZXI5C5XkwcUKPilF+D9yQ2S
	vmaDRpmzC6Gzbz3YnFKUs2RgCSCgj2M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-rU0b94KJPEaVI6gkqm4BFA-1; Thu,
 22 May 2025 11:20:52 -0400
X-MC-Unique: rU0b94KJPEaVI6gkqm4BFA-1
X-Mimecast-MFC-AGG-ID: rU0b94KJPEaVI6gkqm4BFA_1747927251
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 057E51800366;
	Thu, 22 May 2025 15:20:51 +0000 (UTC)
Received: from localhost (unknown [10.72.116.39])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0361F18003FC;
	Thu, 22 May 2025 15:20:49 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/2] ublk: run auto buf unregister on same io_ring_ctx with register
Date: Thu, 22 May 2025 23:20:38 +0800
Message-ID: <20250522152043.399824-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hello Jens,

The 1st patch adds helper io_uring_cmd_ctx_handle().

The 2nd one use the added helper to run auto-buf-unreg on the same
io_uring_ctx with the register one.

Thanks,
Ming

V2:
	- return `void *` from io_uring_cmd_ctx_handle() (Caleb Sander Mateos)
	- typo & document fix (Caleb Sander Mateos)


Ming Lei (2):
  io_uring: add helper io_uring_cmd_ctx_handle()
  ublk: run auto buf unregisgering in same io_ring_ctx with registering

 drivers/block/ublk_drv.c      | 19 ++++++++++++++++---
 include/linux/io_uring/cmd.h  |  9 +++++++++
 include/uapi/linux/ublk_cmd.h |  6 +++++-
 3 files changed, 30 insertions(+), 4 deletions(-)

-- 
2.47.0


