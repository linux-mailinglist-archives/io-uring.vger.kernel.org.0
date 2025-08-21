Return-Path: <io-uring+bounces-9150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA92B2EC8A
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 06:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C16F87BF512
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FF3469D;
	Thu, 21 Aug 2025 04:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQIjiUfK"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC33336CE1A
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 04:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755748946; cv=none; b=XjJ7aUeDlCrGrf8dSR/86ww3gPlQIAQOEY9AgKSbJ8a+gJNLaXHh1G6sZ95hsGJLOcY7DG9S67xM6ZM+ge+PECxRDxuIGF0mE50mws5FpNBt2JFt0is2oxK5O5piejDi7hM99ZVgJVym9v6DRK/c8vwTAtkeTNbUeDyXSTgl0AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755748946; c=relaxed/simple;
	bh=Sxph0ZDJKRB9zatt2QlRMnt5+tq1Csn2MeFaIHw+mfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nR28OyHN8LWvV84cwLx62FJaNDV3/NL9sTb+lU3M4PivnOuxA+3l7AzOhvi3Q5sTi34mSZ74iszirCy1vruUGGPiWbDMR3yuPh6/N36vUmjDUokLFkKgOTrsqBjbYfZsLqd6qpAM4URCvdEQwak+RHXum83WCDompsTG2oiSxyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bQIjiUfK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755748943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4CrE0XtC5JhIhxWtZ2es4ZWYf9RK8YkGNdhtWmExmcg=;
	b=bQIjiUfKOpRM8M5YGuDOG5T74VW5JSed9x5PJoa2LwIe9X9Oij5gkqNqb1YcVF2Eev0Qvp
	eMTUkOcFTBqGP5XhrMS7M/XijU4w9yu0Uh7X63xM49wGxsgEoWcA/TgfIKs22F/qFdVNq9
	CL1+hxzOy85Oo2lSZ4MmVkvEIyntTlM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-xipIs3h1OrOF5d8F2GbiKw-1; Thu,
 21 Aug 2025 00:02:21 -0400
X-MC-Unique: xipIs3h1OrOF5d8F2GbiKw-1
X-Mimecast-MFC-AGG-ID: xipIs3h1OrOF5d8F2GbiKw_1755748940
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9C121800345;
	Thu, 21 Aug 2025 04:02:19 +0000 (UTC)
Received: from localhost (unknown [10.72.116.104])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C4891180047F;
	Thu, 21 Aug 2025 04:02:18 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 0/2] io_uring: uring_cmd: add multishot support with provided buffer
Date: Thu, 21 Aug 2025 12:02:05 +0800
Message-ID: <20250821040210.1152145-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Jens,

This patchset adds multishot support with provided buffer, see details in
commit log of patch 2.

Thanks,
Ming


V5:
- rebase on block/io_uring-buf-list and use 'struct io_br_sel' to build the two APIs
- add patch 1 for moving `struct io_br_sel` to `linux/io_uring_types.h`

V4:
- add io_do_buffer_select() check in io_uring_cmd_select_buffer(()
- comments that the two APIs should work together for committing buffer
  upfront(Jens)

V3:
- enhance buffer select check(Jens)

V2:
- Fixed static inline return type
- Updated UAPI comments: Clarified that IORING_URING_CMD_MULTISHOT must be used with buffer select
- Refactored validation checks: Moved the mutual exclusion checks into the individual flag validation
sections for better code organization
- Added missing req_set_fail(): Added the missing failure handling in io_uring_mshot_cmd_post_cqe
- Improved commit message: Rewrote the commit message to be clearer, more technical, and better explain
the use cases and API changes

Ming Lei (2):
  io-uring: move `struct io_br_sel` into io_uring_types.h
  io_uring: uring_cmd: add multishot support

 include/linux/io_uring/cmd.h   | 27 +++++++++++++
 include/linux/io_uring_types.h | 19 +++++++++
 include/uapi/linux/io_uring.h  |  6 ++-
 io_uring/kbuf.h                | 18 ---------
 io_uring/opdef.c               |  1 +
 io_uring/uring_cmd.c           | 71 +++++++++++++++++++++++++++++++++-
 6 files changed, 122 insertions(+), 20 deletions(-)

-- 
2.47.0


