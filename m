Return-Path: <io-uring+bounces-7742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33AD4A9ED3B
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 11:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9DDF3B07C5
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 09:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB29625F7B3;
	Mon, 28 Apr 2025 09:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhhMEFHj"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A928F49
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 09:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833482; cv=none; b=g68iH5q0C0won5jUJjPz12barP1FNiWL1ewQxp4IQW/xlK2ogUhMtu/dhFKaa5kqRALYaM77KN4F399vdf0gFh0LWc8jkz4a+PWIC9XU41T3kMaW/nSrCn39pSYiTSTwMOhbNjhWRVZD+K8zxR3mY7ZyngRdc6kD3lEG4+DoK+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833482; c=relaxed/simple;
	bh=nyIp/cP+ImVyfgsCQzedCWxfSXvFZ8EHfmo6uU5BzK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YS8mIh1NYBmRV7Xpp9nyICfDc5jYATZ1MjDibGM4VeKSUbXjtWU8RGjI7RA+y3c0/TkZ2SbzCU3dQB0aYy+snTab1STMSeQBUZMyoHPl6X8q6+zpm3vBd5Jk6uzgr9vGo9H7IfRNfK5XbmMSAmOMBto+jJlx57GRXw7EDdQq72A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HhhMEFHj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745833478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0wSm44iymHLUeNH7RrnsvIt4Qra2S4j4z3mK7tPws/4=;
	b=HhhMEFHj/Idsq2QftCwELisLcC9h5NAo2fAufiXCSQt6r/aDy5zEdhgTFUrkO1mp5cv9ng
	Vg9NUdQFk/NfIRsIu3Nxco6twbRN4hA5n90YrSXhunNzY+pf0OHKelHLgV7HeCFyAMheS+
	+yIlumo8Uz9/tGlzgbgSU4M1HrI/ono=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-E-R_Bx6fMOmk5pT58phCRA-1; Mon,
 28 Apr 2025 05:44:35 -0400
X-MC-Unique: E-R_Bx6fMOmk5pT58phCRA-1
X-Mimecast-MFC-AGG-ID: E-R_Bx6fMOmk5pT58phCRA_1745833474
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDFF31956086;
	Mon, 28 Apr 2025 09:44:33 +0000 (UTC)
Received: from localhost (unknown [10.72.116.134])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C62CF19560A3;
	Mon, 28 Apr 2025 09:44:32 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 0/7] ublk: support to register bvec buffer automatically
Date: Mon, 28 Apr 2025 17:44:11 +0800
Message-ID: <20250428094420.1584420-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hello Jens,

This patch tries to address limitation from in-tree ublk zero copy:

- one IO needs two extra uring_cmd for register/unregister bvec buffer, not
  efficient

- introduced dependency on the two uring_cmd, so the buffer consumer has to
linked with the two uring_cmd, hard to use & less efficient

This patchset adds feature UBLK_F_AUTO_BUF_REG:

- register request buffer automatically before delivering io command to ublk server

- unregister request buffer automatically when completing the request

- both io_uring context and buffer index can be specified from ublk
  uring_cmd header

With this way, 'fio/t/io_uring -p0 /dev/ublkb0' shows that IOPS is improved
by 50% compared with F_SUPPORT_ZERO_COPY in my test VM.

kernel selftests are added for covering both function & stress test.

Please review & comment!

Thanks,
Ming

Ming Lei (7):
  io_uring: add 'struct io_buf_data' for register/unregister bvec buffer
  io_uring: add helper __io_buffer_[un]register_bvec
  io_uring: support to register bvec buffer to specified io_uring
  ublk: convert to refcount_t
  ublk: prepare for supporting to register request buffer automatically
  ublk: register buffer to specified io_uring & buf index via
    UBLK_F_AUTO_BUF_REG
  selftests: ublk: support UBLK_F_AUTO_BUF_REG

 drivers/block/ublk_drv.c                      | 165 ++++++++++++++----
 include/linux/io_uring/cmd.h                  |  15 +-
 include/uapi/linux/ublk_cmd.h                 |  38 ++++
 io_uring/rsrc.c                               | 141 ++++++++++-----
 tools/testing/selftests/ublk/Makefile         |   2 +
 tools/testing/selftests/ublk/file_backed.c    |  12 +-
 tools/testing/selftests/ublk/kublk.c          |  24 ++-
 tools/testing/selftests/ublk/kublk.h          |   6 +
 tools/testing/selftests/ublk/null.c           |  43 +++--
 tools/testing/selftests/ublk/stripe.c         |  21 +--
 .../testing/selftests/ublk/test_generic_08.sh |  32 ++++
 .../testing/selftests/ublk/test_stress_03.sh  |   6 +
 .../testing/selftests/ublk/test_stress_04.sh  |   6 +
 .../testing/selftests/ublk/test_stress_05.sh  |   8 +
 14 files changed, 409 insertions(+), 110 deletions(-)
 create mode 100755 tools/testing/selftests/ublk/test_generic_08.sh

-- 
2.47.0


