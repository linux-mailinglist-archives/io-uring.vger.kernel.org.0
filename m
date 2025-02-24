Return-Path: <io-uring+bounces-6651-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9BFA41469
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 05:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06E133B1F7E
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 04:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CD41A3172;
	Mon, 24 Feb 2025 04:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="dAxv52vw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0666F194C61
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740370408; cv=none; b=HxgNbQAaTKPYOxZqB8U/1D/V69exkWJjawcoFm2MF884nCE/51ImrdPaGEoXC60oCZ7IlVMKF5NomBYSu9qvANKAMWg3lFQu8jJdPNP2I7zIIDqiygfIaKlxsW+djUr9jxTMo8o0+wMxJbtcExEpT3W6e7XjlZIVOoDXgxkqrMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740370408; c=relaxed/simple;
	bh=y8eQgTmWj7h65q054PUX/NYy9DNrsauX+voINEreQuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aYUQb1FSb8vNbV7xoek4B4bpdTZeBPZCqn94LYJjUr0vSFd8VTbYyhNNTbYHyAApipR9dqLb/m34SxvOnMpKDyP0gDD1nN6utU1XNQhp2fFsLPufQWxeLLeBpFeV7KzydhQ2bGJLeWL1fOKMfDAW25pqd96lv6RvjPHLZeifL4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=dAxv52vw; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fc0026eb79so8115705a91.0
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 20:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740370406; x=1740975206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=veiI/QihasJNgngpHzSx74DeastlJMBTKPJJy0YtKh0=;
        b=dAxv52vw4jbd0FJ+y8F0+V6nJ9VqIIZywWeveIFXXQo9tRUNrTX0321Fjw46nuK6vv
         sjKiiJzdSKzH1o+WWCG1QWMNoNRshiLY+U3a1O5uIx39Z9jOfJ1h7F/Icp+cJFkPM8EL
         vMaIhB9noZ8MQsMPlUqo22WuKPDDeFr2gFIFCP+uE7S9a9/++jK7R8oVHCYxvuDNa2nj
         yLghbb+gAjLmOHVrj4tTWVLvzbz8hHD8iQyYaImgpaWcvaz4oXm9yqnorXcvIr9DITq6
         M5iK0pHVxZoOxYHwKVmTafreD5UUU7bex1LLmZsK4/XWQ+ainYFjC4+LZOfddM8k6r4r
         jpsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740370406; x=1740975206;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=veiI/QihasJNgngpHzSx74DeastlJMBTKPJJy0YtKh0=;
        b=E4VCqRwK6yJlDxBAmGNxW2Tt3RAIQPrJAJc9xn+StCi/mu3nmaX5yKtZgtPpTacqe6
         yUtUAC/yBxQfN3Ls+0UJfd9w/Ff/9u7zy9MdSgx4G9nd8/wWsKlTd5jZkLxr9Osqxon9
         VHKPexLmK68NEC6yluVAqY2Hyv31c1OrqeFIBx1LoDdNoKDZQ2EAtTUedxNdJCmPz7rv
         rxXnuGJEfapxH/d61xbrVWxkU61AKqaeKcIkuRNn0eqfScmOTTPX7ztQL5vCPPgiTyHY
         K+QX0Q4BJ/JJdqRW+7rMUYaCDLLcdnznghpwGpBK1gryFbQPGoXMGQdnaPDAL/3qqPoi
         Xd7g==
X-Gm-Message-State: AOJu0YwU1Ly/nk5kKo4hLj5tXho5I7or4ipKfoxLmHTg6mQhgj6aT5aA
	02PTLsWGTCPJuXyxPiBSMOAkrlymwLlrFzFUP7gsUxD6Apu+zx0dqMLsgm+1jAf5ngkyAnMo/+X
	M
X-Gm-Gg: ASbGncvOGtkimwCJZbhww00qoUIrSHtd2H74cKiKrUcJQ5U42NrTBvaOI94iHOKHJFI
	WIi8ETxNS5obD0sEMUKQU/lhqy5z1mqHsV4ULjRwt7b96KkhVlmFx6AT3uJhXhYmTK4CKKiZy+K
	eUqmMra2PO4wcJfF6urj8NfGjGZGBGAqeHvjiHKe3Jdd5EFvTFhIJg65+9rhUDCE092IlX5i3Ax
	vW6g9zozeTfz+BqDraXXULzcSHFg/xJyXXFY4CMpYRzGCJaMW/qj+OsLS7PpwAoi051MzgmEofn
	E1UHHn2E3kg=
X-Google-Smtp-Source: AGHT+IHBPHRFzxsVXjfmoSRPRCqEj12USqX8h+BDpa0FixJdx0JrCEJAvI0XtY1gRSCzhlCLMiBWXw==
X-Received: by 2002:a17:90b:3ec4:b0:2ee:48bf:7dc9 with SMTP id 98e67ed59e1d1-2fce78c8385mr20688404a91.15.1740370406221;
        Sun, 23 Feb 2025 20:13:26 -0800 (PST)
Received: from localhost ([2a03:2880:ff:12::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fceb02d7f0sm5483075a91.3.2025.02.23.20.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 20:13:25 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	lizetao <lizetao1@huawei.com>
Subject: [PATCH v3 0/2] io_uring/zcrx: recvzc read limit
Date: Sun, 23 Feb 2025 20:13:17 -0800
Message-ID: <20250224041319.2389785-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently multishot recvzc requests have no read limit and will remain
active so as long as the socket remains open. But, there are sometimes a
need to do a fixed length read e.g. peeking at some data in the socket.

Add a length limit to recvzc requests `len`. A value of 0 means no limit
which is the previous behaviour. A positive value N specifies how many
bytes to read from the socket.

Also add a new selftest case.

Changes in v3:
--------------
* Remove all references to 'singleshot'
* Use 0 to mean no limit
* Remove unused var `limit`
* Complete recvzc req early when len == 0
* Revert return codes in io_zcrx_tcp_recvmsg()
* Check explicitly that ret > 0

Changes in v2:
--------------
* Consistently use u32/unsigned int for len
* Remove nowait semantics, request will not complete until requested len
  has been received
* Always set REQ_F_APOLL_MULTISHOT
* Fix return codes from io_recvzc request
* Fix changing len if set to UINT_MAX in io_zcrx_recv_skb()
* Use read_desc->count

David Wei (2):
  io_uring/zcrx: add a read limit to recvzc requests
  io_uring/zcrx: add selftest case for recvzc with read limit

 io_uring/net.c                                | 16 +++++--
 io_uring/zcrx.c                               | 13 ++++--
 io_uring/zcrx.h                               |  2 +-
 .../selftests/drivers/net/hw/iou-zcrx.c       | 43 ++++++++++++++++---
 .../selftests/drivers/net/hw/iou-zcrx.py      | 27 +++++++++++-
 5 files changed, 85 insertions(+), 16 deletions(-)

-- 
2.43.5


