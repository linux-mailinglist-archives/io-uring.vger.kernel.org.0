Return-Path: <io-uring+bounces-10362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC74C3208F
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 17:25:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A46ED427568
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 16:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC91330B3B;
	Tue,  4 Nov 2025 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RluVhC+E"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19D933374E
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 16:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273317; cv=none; b=NfNZs6a6+LbIeYzoJyQm7c39iFwkR+HdjXT6tn9iU5heRxuxrEOT4N3xMllAL32gQAWedr0CpK1ounTGr3Xf9bRNTKNU7ESFDUDp6YLSO5y5Pwzzz9uOkmpt6yPVf41zxIFBeoaYK0377OrO3D0uVSZBOKeikiLULTdNb9VGyWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273317; c=relaxed/simple;
	bh=rpOrdOrqKV6SAoQHhEPb4eHKvZSDZMMwSKEsKojnprY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uoBnoRZENqRCS5YEjPmWx3/3nU7zhxIQq3K239cdNvEb4JINwCTBg2ByO2Cq/zqGxq/wmDkv0T0PyuvsKnX0jrrKjvymao6fVWnHeZwHGD0sghGsG9ZXhAO1eA64ccG5FHofCeNwO/6ILjptyBv7F9tV/DoS2a0ooUeGfWdXoco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RluVhC+E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762273314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p42rTrIw8mqqMrGVMpTNcw+xGU+8LzeuRRA9VH0Hr1I=;
	b=RluVhC+ES0PLY5ysX974vN9VCwROrlyHoUe9wELw6e0ZBDO7jFa7CE8J+swGcL0lsn7env
	Z8q3MrCqHmy+2hkBIMibKfwVM3al4/u8OZzRQEjlcSVzhJaJCzr75Wf27DiL/xABKCzawe
	snu3B9Sa+WBapbHTkkLCg08t1T2F/VE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-9OP_lW5LM2KX6UM6q_MOOA-1; Tue,
 04 Nov 2025 11:21:51 -0500
X-MC-Unique: 9OP_lW5LM2KX6UM6q_MOOA-1
X-Mimecast-MFC-AGG-ID: 9OP_lW5LM2KX6UM6q_MOOA_1762273310
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1FE5195605F;
	Tue,  4 Nov 2025 16:21:49 +0000 (UTC)
Received: from localhost (unknown [10.72.120.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F8DD1956056;
	Tue,  4 Nov 2025 16:21:47 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/5] io_uring: add IORING_OP_BPF for extending io_uring
Date: Wed,  5 Nov 2025 00:21:15 +0800
Message-ID: <20251104162123.1086035-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hello,

Add IORING_OP_BPF for extending io_uring operations, follows typical cases:

- buffer registered zero copy [1]

Also there are some RAID like ublk servers which needs to generate data
parity in case of ublk zero copy

- extend io_uring operations from application

Easy to add one new syscall with IORING_OP_BPF

- extend 64 byte SQE

bpf map can store IO data conveniently

- communicate in IO chain

IORING_OP_BPF can be used for communicate among IOs seamlessly without requiring
extra syscall

- pretty handy to inject error for test purpose


The 1st 3 patches adds IORING_OP_BPF framework & struct_ops.

The 4th patch adds both fixed and plain user buffer support, in future
vector and fixed vector buffer can be supported.

The last patch exports io_uring_bpf_req_memcpy() for copying data among
different request buffers, so far fixed and plain buffers are supported,
this is also one demo for showing how to solve above requirements with
IORING_OP_BPF.

Follows liburing support and tests:

https://github.com/ming1/liburing/commits/uring_bpf/

Any comments & feedback are welcome!


[1] lpc2024: ublk based zero copy I/O - use case in Android

https://lpc.events/event/18/contributions/1710/attachments/1440/3070/LPC2024_ublk_zero_copy.pdf




Ming Lei (5):
  io_uring: prepare for extending io_uring with bpf
  io_uring: bpf: add io_uring_ctx setup for BPF into one list
  io_uring: bpf: extend io_uring with bpf struct_ops
  io_uring: bpf: add buffer support for IORING_OP_BPF
  io_uring: bpf: add io_uring_bpf_req_memcpy() kfunc

 include/linux/io_uring_types.h |   5 +
 include/uapi/linux/io_uring.h  |  56 ++++
 init/Kconfig                   |   7 +
 io_uring/Makefile              |   1 +
 io_uring/bpf.c                 | 556 +++++++++++++++++++++++++++++++++
 io_uring/io_uring.c            |   8 +
 io_uring/io_uring.h            |   6 +-
 io_uring/opdef.c               |  10 +
 io_uring/uring_bpf.h           |  86 +++++
 9 files changed, 733 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/bpf.c
 create mode 100644 io_uring/uring_bpf.h

-- 
2.47.0


