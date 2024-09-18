Return-Path: <io-uring+bounces-3225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D0AD97BCA4
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 14:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52D8A284CAF
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 12:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F45189F41;
	Wed, 18 Sep 2024 12:59:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B54189F3C
	for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 12:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726664356; cv=none; b=CDPNyKTd/O3a3cQpMdoFjEE81am1zrLhccON/3/uJezP1yzpFg0oURBN34299cJQGvIBLsgkNpR3EJ9NAgimYylt+uXlkk1+IPCGbhR2buajEQChZxZr8FJa9eyBrkZxqbl9j+jFuBdjw4OLvwx4xx619D0tNkbvhAK8vgX/x84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726664356; c=relaxed/simple;
	bh=ItP0eXFPYmd9o7eVWd/9ZhqaxsLVCz9CCD1dUiGMa2o=;
	h=From:Date:Message-ID:To:Subject; b=b8k4hLsp1vsNgGbprrrz2Bj6nIJG6M5ILsa80PqaQz222CeYfcVafXUiaxHQvpfpmM6Vts5J5SAlk2d6xfixwwlqhLMg1/lHKDwBb3O1wWiDbKFVmYwNJMdQtT8MetVfhcTUE79Wte5tZT7iJ9YSVBoBsSEnFJG0crcUGUH3yt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=45650 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1squGx-0004Yp-0d;
	Wed, 18 Sep 2024 08:59:07 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Wed, 18 Sep 2024 08:59:06 -0400
Message-ID: <cover.1726589775.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v3 0/3] napi tracking strategy
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

v3 changes:
- address minor comments in patch #3
- replace the double for loop hash macro with the single loop list macro to iterate the napi elements in patch #2
- add __cold attribute to common_tracking_show_fdinfo() and napi_show_fdinfo()

v2 changes:
- extract small changes from the core changes to ease minor fixes backport
- totally remove the io_napi_tracking_ops interface

Olivier Langlois (3):
  io_uring/napi: protect concurrent io_napi_entry timeout accesses
  io_uring/napi: fix io_napi_entry RCU accesses
  io_uring/napi: add static napi tracking strategy

 include/linux/io_uring_types.h |   2 +-
 include/uapi/linux/io_uring.h  |  32 +++++++-
 io_uring/fdinfo.c              |  41 ++++++++++
 io_uring/napi.c                | 140 +++++++++++++++++++++++++--------
 io_uring/napi.h                |  15 +++-
 5 files changed, 192 insertions(+), 38 deletions(-)

-- 
2.46.1


