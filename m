Return-Path: <io-uring+bounces-3211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B649B97A7B7
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 21:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AC72B23DA7
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 19:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD121DFE4;
	Mon, 16 Sep 2024 19:19:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95722135A54
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 19:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726514398; cv=none; b=EeAx+zcS+iQ5wSmcuXuy12GTNEXK4u2DR1vk4GTevid6OVMW/60xIV6jX9PvosBIKnOoK5ZpjlwJdGtj5gsRtKEl9CxSpxZMERzd+Aghtu33xKPWRmEjjQz4vDsj0jSCFXmUomAOKN7hsvu/L7QadGcdRrnmkZeHc1AOTsloKYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726514398; c=relaxed/simple;
	bh=8JUx80E+n1YEEhG5INJ58nXdhpQP0myBE5qBc7kWb/c=;
	h=From:Date:Message-ID:To:Subject; b=VwltEMLqbfVay8Rai2E7+X7BNMVUTnc9SMafisSS/MgK1Y2ZGP695jAcgApW5qaDWojoSFJg63YpXXOA0BikkDtO7E/Bc5ZfcCn2wRn9XzR5OHSh427ZqTpXMEzYNz8MT03ZZ7hB11093D3zZz/ruYItREc8+GSu8R3qMpuTNtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=40090 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sqHGN-00065d-0i;
	Mon, 16 Sep 2024 15:19:55 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Mon, 16 Sep 2024 15:19:54 -0400
Message-ID: <cover.1726354973.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v2 0/3] napi tracking strategy
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

the actual napi tracking strategy is inducing a non-negligeable overhead.
Everytime a multishot poll is triggered or any poll armed, if the napi is
enabled on the ring a lookup is performed to either add a new napi id into
the napi_list or its timeout value is updated.

For many scenarios, this is overkill as the napi id list will be pretty
much static most of the time. To address this common scenario, a new
abstraction has been created following the common Linux kernel idiom of
creating an abstract interface with a struct filled with function pointers.

the patch serie consist of very minor fixes followed by the core of the changes
to implement the new feature.

v2 changes:
- extract small changes from the core changes to ease minor fixes backport
- totally remove the io_napi_tracking_ops interface

Olivier Langlois (3):
  io_uring/napi: protect concurrent io_napi_entry timeout accesses
  io_uring/napi: fix io_napi_entry RCU accesses
  io_uring/napi: add static napi tracking strategy

 include/linux/io_uring_types.h |   2 +-
 include/uapi/linux/io_uring.h  |  32 +++++++-
 io_uring/fdinfo.c              |  36 +++++++++
 io_uring/napi.c                | 135 ++++++++++++++++++++++++++-------
 io_uring/napi.h                |  15 +++-
 5 files changed, 186 insertions(+), 34 deletions(-)

-- 
2.46.0


