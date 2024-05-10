Return-Path: <io-uring+bounces-1851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BEFE8C1D33
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 05:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E60051F21D7B
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 03:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4335E1494DE;
	Fri, 10 May 2024 03:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B0y82TX1"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D14E149C51
	for <io-uring@vger.kernel.org>; Fri, 10 May 2024 03:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715313043; cv=none; b=fQ2wIeliqA1n+1SkYj9VbVA4TmjnKMchKmpQIG1Zs2JOHRyoaaFgcgRIngV2Iocr/gHD9B5gkZ90bTffW+k19zZrI0jhQ+7Cb9YV7xS4XuZjViGSvJ6F0xLuC2Qk/QqZXkj8EUg+KRKW4/tJiBYagAiqQ+v9qINQh8Tw6xgQKpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715313043; c=relaxed/simple;
	bh=JWp5ldY1S7rY/wyuYjxemffIioC467PDoZbp08RrJcg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zbf+bf0DECwpMgcnFQnxh4ISjA2fTLJND0ghldiITZf1s3RviIdzqBMPtdrApwpP7vb4qL+5kLI7NAQn1yvBNTuBuw+x0onOSwLRdA+PCoA4REQltJtCkXATz33FAiOWbVCsVrR4Yjep6csvfJvJ3kkwHcSbFDE0kPTupo5fjpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B0y82TX1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715313040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YrEb6T1ViuXoFnJJdj/DhKrLFLdEudr93hsjfPGdTfA=;
	b=B0y82TX1FPph3p30pr1+lyBotDEcC5EnvtAOyQWNBqcXtBH5qbEh5jOVK26eIP0uztUiBo
	8Y/LUeVUbumuB4ADCmhy7/hkzmERhqwsag8Kc3o3GtxDksmtyMUJ1raboLhTZeEvtGrdv7
	95I4DJLdRAc9B7UkxRa481Cwfhtt1PI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-ta5i8Hk_Om6Wx0116ZNhIQ-1; Thu, 09 May 2024 23:50:38 -0400
X-MC-Unique: ta5i8Hk_Om6Wx0116ZNhIQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F267857A85;
	Fri, 10 May 2024 03:50:38 +0000 (UTC)
Received: from localhost (unknown [10.72.116.53])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DF2A2087D78;
	Fri, 10 May 2024 03:50:37 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/2] io_uring: support to inject result for NOP
Date: Fri, 10 May 2024 11:50:26 +0800
Message-ID: <20240510035031.78874-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Hello,

The two patches add nop_flags for supporting to inject result on NOP.

V2:
	- add patch1 for backport, suggested by Jens


Ming Lei (2):
  io_uring: fail NOP if non-zero op flags is passed in
  io_uring: support to inject result for NOP

 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/nop.c                | 26 ++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

-- 
2.42.0


