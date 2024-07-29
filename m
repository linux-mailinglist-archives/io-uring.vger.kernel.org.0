Return-Path: <io-uring+bounces-2594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4819403F9
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 03:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B53C1C21D07
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 01:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6DE4683;
	Tue, 30 Jul 2024 01:46:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34E629AF
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 01:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303965; cv=none; b=M0IzAN5+eAPM2qT1KHZue78rYZEy/fE3ggo3QTCjAUUiMkvAd24BHhrGKUzmPmHreXVe9L6K+f1oOZ3bZA2+HKF+xaLRm097dBiOdwlOOyPX+OLFW+fJrTlnwHARb7msyLLbv18W/KJc00tAayAPeob7aH3gWGMTc3quur7t4SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303965; c=relaxed/simple;
	bh=ISpBmPkVCqfk4/6Gf5fG+ORd8orlPJ5nbudX10JqGDs=;
	h=From:Message-ID:To:Date:Subject; b=Ai1n1RVpauhR0F4RAOSLLOdhn/0ZaC+fdG1uA5/MLN6W9KMm8N3evR4Yb/hCWMOlSmXb/9eJoW2OCnDD4ZzqiUVTdEkoYdK09s3f1TMFL6JyBRajLF9W246BjsZ/Sz8PaIwJ4xkfjBLwqqhgfd80EAm/hC2IcnxnzW21gM36D5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=37486 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYbwA-00044p-0w;
	Mon, 29 Jul 2024 21:46:02 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <0fe61a019ec61e5708cd117cb42ed0dab95e1617.1722294646.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Mon, 29 Jul 2024 19:03:33 -0400
Subject: [PATCH] io_uring: keep multishot request NAPI timeout fresh
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

this refresh statement was originally present in the original patch:
https://lore.kernel.org/netdev/20221121191437.996297-2-shr@devkernel.io/

it has been removed with no explanation in v6:
https://lore.kernel.org/netdev/20230201222254.744422-2-shr@devkernel.io/

it is important to make the refresh for multishot request because if no
new requests using the same NAPI device are added to the ring, the entry
will become stall and be removed silently and the unsuspecting user will
not know that his ring made busy polling for only 60 seconds.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/poll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0a8e02944689..1f63b60e85e7 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -347,6 +347,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 		v &= IO_POLL_REF_MASK;
 	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
 
+	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;
 }
 
-- 
2.45.2


