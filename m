Return-Path: <io-uring+bounces-3630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12FD899BAD3
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDACE1F2147F
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 18:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4412213D52C;
	Sun, 13 Oct 2024 18:28:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5275B83CD6
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728844117; cv=none; b=Hg6qWPTPYdXLconQnAdNo7AFuMxW0tIGv0n9CQ1HV47xWtwAq5TYd5IoCccC4OTPYjh/ykVvVx9oqWQqX3cvpmpFvLrzrDTdHH9X5bqIx/vajeHD5mXHiVflTTyW5W3rTQk/hXTIdflu/O5t0llq15M88dV7a9HKXgZpDqR25z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728844117; c=relaxed/simple;
	bh=vR+uiPei8nhKsLe20slFm0vlgaO8qI47bLaVkV9O/gQ=;
	h=From:Date:Message-ID:To:Subject; b=oXz7X7GfmKDmDpVMjU0Z6B395mRWR5j/LzX2P8dg8Bz/Nk4HvgusiLgV/vYm18Y5SLs5n4Z157eoXme7lsL/0SzH9sgk3VrFOLj2mo3ECplf0Josf6F2/8Bj6Gap6JbpGbu2IsAASdbZx5N5ZS5C3KBmcLnu+mnX9LiozRad40s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=55236 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1t03K1-0002gw-2z;
	Sun, 13 Oct 2024 14:28:05 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Sun, 13 Oct 2024 14:28:05 -0400
Message-ID: <cover.1728828877.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v4 0/6] napi tracking strategy
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
much static most of the time. To address this common scenario, the concept of io_uring_napi_tracking_strategy has been created.
the tracking strategy can be specified when io_register_napi() is called.

To keep backward compatibility, the legacy strategy IO_URING_NAPI_TRACKING_DYNAMIC is assigned the value 0 so that existing code using io_uring napi busy polling continue working as before. If IO_URING_NAPI_TRACKING_STATIC is provided, io_napi_add() becomes a noop function and the responsability to update the napi devices list is given to the user by calling io_register_napi() with the opcode value of IO_URING_NAPI_STATIC_ADD_ID or IO_URING_NAPI_STATIC_DEL_ID.

the NAPI ids used by a process can be discovered by calling
getsockopt(fd, SOL_SOCKET, SO_INCOMING_NAPI_ID, &napi_id, &len)

the patch serie consist of very minor fixes followed by the core of the changes
to implement the new feature.

v4 changes:
- improve cover letter text
- rebase patch on for-6.13/io_uring
- create a prep-patch for the __io_napi_add refactoring change
- create a prep-patch for the Scope-Based Resource Management refactoring
- create a prep-patch for the __io_napi_do_busy_loop cleanup
- adress io_napi_add() code review comment

v3 changes:
- address minor comments in patch #3
- replace the double for loop hash macro with the single loop list macro to iterate the napi elements in patch #2
- add __cold attribute to common_tracking_show_fdinfo() and napi_show_fdinfo()

v2 changes:
- extract small changes from the core changes to ease minor fixes backport
- totally remove the io_napi_tracking_ops interface

Olivier Langlois (6):
  io_uring/napi: protect concurrent io_napi_entry timeout accesses
  io_uring/napi: fix io_napi_entry RCU accesses
  io_uring/napi: improve __io_napi_add
  io_uring/napi: Use lock guards
  io_uring/napi: clean up __io_napi_do_busy_loop
  io_uring/napi: add static napi tracking strategy

 include/linux/io_uring_types.h |   2 +-
 include/uapi/linux/io_uring.h  |  32 +++++-
 io_uring/fdinfo.c              |  54 +++++++---
 io_uring/napi.c                | 184 +++++++++++++++++++++++----------
 io_uring/napi.h                |   8 +-
 5 files changed, 207 insertions(+), 73 deletions(-)

-- 
2.47.0


