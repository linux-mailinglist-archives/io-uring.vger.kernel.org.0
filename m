Return-Path: <io-uring+bounces-11206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED220CCB2DE
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 10:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9F2A030084A7
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C622F3632;
	Thu, 18 Dec 2025 09:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F8xopgO7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A60C221FBA
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 09:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050329; cv=none; b=atemgUzVxApb83F9w7VKpRG28o9U60iQ+vUcYFbhU83o457BHSEgFLwXwNeaQn0wc/1oY4d/BmBPK1o5Qk9PXbKIKDumltDM6cd18L3Isyrx8Vr09n7LjKEpvxLqOIhzh7nDW1WZzQGJ10iQvd9WoQkLFT5ICh27ZBSblTJwfj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050329; c=relaxed/simple;
	bh=SYPbf339VxwLN/Vh/N9OMA/Mq6aNiItSBpKdMg4dDOs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uGSPFPxFvJtkc174ry/pMepyBYyYV5YHknsB5VSX6qLr5YpVwOHa/P/l0096WSeuuu3NDtw11fi+uxkiovGiKvQFpIP60VOTitlu65Qc+aDCHDzJp3rFcQsEmBj01KjBlNtrWIGI1bRSmVZudFTpJD9w482ny8FBEzcBR5+1YxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F8xopgO7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766050326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WrdshZ7Q3JgLAQQbhmfcEAVf6Ka64wrjhIKhEj1LrVY=;
	b=F8xopgO7ckgvVC0CIev2E8F0GHx8Ag5d9T0EVzw0ko5+baDJxug4TcyzjnSm/XcaHHl+mT
	ms3pQ46rYym3xLqe9XpUYoJfGWsecfNJBhid5hzVKNP2Jz3fSwAUk7d5R7HQe8k1XgVNor
	BOWBVbPK/oTZz3e8WXNxega1J1NOLK4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-H47HXcWUM3moDhUhhSY8dQ-1; Thu,
 18 Dec 2025 04:32:03 -0500
X-MC-Unique: H47HXcWUM3moDhUhhSY8dQ-1
X-Mimecast-MFC-AGG-ID: H47HXcWUM3moDhUhhSY8dQ_1766050322
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E5151955DC3;
	Thu, 18 Dec 2025 09:32:01 +0000 (UTC)
Received: from localhost (unknown [10.72.116.190])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 47C5319560B4;
	Thu, 18 Dec 2025 09:31:58 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/3] block: fix bi_vcnt misuse for cloned bio
Date: Thu, 18 Dec 2025 17:31:41 +0800
Message-ID: <20251218093146.1218279-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hello Guys,

The 1st patch removes .bi_vcnt from bio_may_need_split() because the
incoming bio may be cloned.

The 2nd patch doesn't initialize cloned bio's bi_vcnt in
bio_iov_bvec_set().

The 3rd patch removes iov iter nr_segs re-calculation for io_import_kbuf().


Ming Lei (3):
  block: fix bio_may_need_split() by using bvec iterator way
  block: don't initialize bi_vcnt for cloned bio in bio_iov_bvec_set()
  io_uring: don't re-calculate iov_iter nr_segs in io_import_kbuf()

 block/bio.c     |  2 +-
 block/blk.h     | 13 ++++++++++---
 io_uring/rsrc.c | 10 ----------
 3 files changed, 11 insertions(+), 14 deletions(-)

-- 
2.47.0


