Return-Path: <io-uring+bounces-7234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBAC1A702F5
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:58:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 611973AB89B
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1631EEA36;
	Tue, 25 Mar 2025 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOmvz9Ka"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853C32561D7
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910741; cv=none; b=JgWiHd9O8mOtecBXreZrtevBXnOnv7XyQvKQiC9D25a3lBzvGTK6zBGBYLfLFCB+uIxK55hXKi1lZh2Jzkfut7I4002ybQL2ZOahgd809sykhgymNAX+EvMI+tqYZApmNBOUhSwbfscBW48yEU5OFWDLFb0nNUSL1b2a8pUoXmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910741; c=relaxed/simple;
	bh=61mNQ1lT+iQsj57B8hAIu9hIsEvNTo1qqtTb7RMCVcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M9P0eQTeTRnIFulpgZNtxtb3nXDtZfksero1pkNonnc42g65JTC4XMDeCY7ZCQ1pIaQCql5CUSFB1cc6EkhCXgYBKUJFPGHzudiczIAqi2TKt+ADR7By/M1rFCafjQ1S+hImJmL3pVNfgii2M0tQIqQuBeGNqiGUsZ8IhuJ8/3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hOmvz9Ka; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742910736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=m+95qTSC+81h5LWhnZqF9la2IYPlgFOsnjR9zq22Vsc=;
	b=hOmvz9KaoZ4hWkBD4oQYFxoQw8aEENHEKfAro7EKVezNdyoKSYXdrfdE2B8ddbOHMLChG7
	n7cOomoUsOPf0bfeLdgrtDMDTvkfK6/7pzMUXxwd9aKpQ/H59zP5sL93+R0aT3//VSjqtv
	b1GJaH/i/AWJSiw33RmjEi4C8Heirko=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-hCcCtU2_MW2081lImrpX2w-1; Tue,
 25 Mar 2025 09:52:11 -0400
X-MC-Unique: hCcCtU2_MW2081lImrpX2w-1
X-Mimecast-MFC-AGG-ID: hCcCtU2_MW2081lImrpX2w_1742910730
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84229180AB16;
	Tue, 25 Mar 2025 13:52:10 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF68A1801751;
	Tue, 25 Mar 2025 13:52:07 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/4] io_uring: support vectored fixed kernel buffer
Date: Tue, 25 Mar 2025 21:51:49 +0800
Message-ID: <20250325135155.935398-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hello Jens,

This patchset supports vectored fixed buffer for kernel bvec buffer,
and use it on for ublk/stripe.

Please review.

Thanks,
Ming


Ming Lei (4):
  io_uring: add validate_fixed_range() for validate fixed buffer
  block: add for_each_mp_bvec()
  io_uring: support vectored kernel fixed buffer
  selftests: ublk: enable zero copy for stripe target

 include/linux/bvec.h                  |   6 ++
 io_uring/rsrc.c                       | 125 +++++++++++++++++++++++---
 tools/testing/selftests/ublk/Makefile |   1 +
 tools/testing/selftests/ublk/stripe.c |  69 ++++++++++----
 4 files changed, 170 insertions(+), 31 deletions(-)

-- 
2.47.0


