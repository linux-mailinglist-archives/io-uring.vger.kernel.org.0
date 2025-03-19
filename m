Return-Path: <io-uring+bounces-7125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B2DAA687DD
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 10:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B424189A24C
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 09:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5FDE25332F;
	Wed, 19 Mar 2025 09:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I22cdWGP"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8FE253328
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 09:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742376415; cv=none; b=eyMT/Cd36L6VQojvrQxZDgWJYVvDVIf/Eo4sSOALG//zJavoY+SDhHv4Gs9RkUuOGg8aurMOeWJMnt3g7I3fWjSH/5HJnrsCont9/3vE13OOfkHOVhgCD2x91y0Tx/qm1tyP7ivIUBeTL3TuJO5txgLFhQEutB3xB8uAOtYKjBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742376415; c=relaxed/simple;
	bh=/xOq7SSOrrDGho5UC/j3Kyh0WCKB7cpX82DrDyjIkbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZRLel3OyNBkpnfVABChs7XoDao3q/10n6AHOksQ6YV6Qaan8GdVpiQ69D9Tn/CGecvIyJUYLsMHY9MTttVmtx5G0uF97mHvKyUAEuSr1pG24kJGwYlPKyq8UP+nY3xHwiRHiD7WZD7kiHLZokZ6JyXY+pNUlN5MvCsUpQN33I0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I22cdWGP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742376411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LbxEb6880d5LQwawc9xi/YAbNZo/Ogbv4R4xfW4nuTw=;
	b=I22cdWGPa4/nLwmrgvVkefv9cbLcM1p1CoJfKVf+44K//C15fRKqVWjHjdaOy602mw1dLD
	/JTamvJqzPAuN4UUy8eVgSs+E5mnxnGgqa596WkzSEg+2oHwT0JEiPkEPfs9TeHJtDQUvf
	oNfjYsFqvhPqz/v19nbw6353kuV2/s4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-SJasV17PNFSpXCkfg5wXMg-1; Wed,
 19 Mar 2025 05:26:50 -0400
X-MC-Unique: SJasV17PNFSpXCkfg5wXMg-1
X-Mimecast-MFC-AGG-ID: SJasV17PNFSpXCkfg5wXMg_1742376408
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 785FD1956059;
	Wed, 19 Mar 2025 09:26:48 +0000 (UTC)
Received: from localhost (unknown [10.72.120.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 492181800946;
	Wed, 19 Mar 2025 09:26:46 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/2] liburing: test: replace ublk test with kernel selftests
Date: Wed, 19 Mar 2025 17:26:34 +0800
Message-ID: <20250319092641.4017758-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Jens,

The 1st patch removes the liburing ublk test source, and the 2nd patch
adds the test back with the kernel ublk selftest source.

The original test case is covered, and io_uring kernel fixed buffer and
ublk zero copy is covered too.

Now the ublk source code is one generic ublk server implementation, and
test code is shell script, this way is flexible & easy to add new tests.

Thanks,
Ming


Ming Lei (2):
  liburing: test: remove test/uring_cmd_ublk.c
  liburing: test: replace ublk test with kernel selftests

 .gitignore                              |   1 +
 test/Makefile                           |  22 +-
 test/runtests.sh                        |   8 +
 test/ublk/file_backed.c                 | 217 ++++++
 test/{uring_cmd_ublk.c => ublk/kublk.c} | 925 ++++++++++--------------
 test/ublk/kublk.h                       | 336 +++++++++
 test/ublk/null.c                        |  38 +
 test/ublk/test_common.sh                | 221 ++++++
 test/ublk/test_stress_02.sh             |  48 ++
 9 files changed, 1286 insertions(+), 530 deletions(-)
 create mode 100644 test/ublk/file_backed.c
 rename test/{uring_cmd_ublk.c => ublk/kublk.c} (56%)
 create mode 100644 test/ublk/kublk.h
 create mode 100644 test/ublk/null.c
 create mode 100755 test/ublk/test_common.sh
 create mode 100755 test/ublk/test_stress_02.sh

-- 
2.47.0


