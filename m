Return-Path: <io-uring+bounces-10997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 98690CB2779
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 09:55:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 998F03004D2C
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 08:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0E51CAA79;
	Wed, 10 Dec 2025 08:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awvou8R4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A271194A6C
	for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 08:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765356914; cv=none; b=g8LF+u76nXmsrw9vLzEoxHLf8TwLAB95Hl2tDMGYneYFvosIc5bI800phNxEsU6ww+tMSTWZgj0+1HBMn8R1u9Q+g59drFmFswWP5IzJN0g2edkQfE+ghOLqVdRFUEBMBazjAUaA9ECmkVC6eXk3Ijj9FialotcekFBinBwTLXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765356914; c=relaxed/simple;
	bh=QB4yGGOuKupTJk6F2ItMMuN24htljhQDpcat3ZIFNDs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZOXOB9WyPhALdA59qJa8ftMRxKwmZSfOCreLN1tMBUDxwQnNoqPRDy6Th5jgy4KYwiuMICOK+w/pJIDcUUJE0XO4M5GPMzNniqk8GqRz46P8ZlNmFPQZCSAhwLSaj4+JTZJjUeAqzi9xLlxtKvwZRL+2h51k4yBe7SfZBdtKeyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=awvou8R4; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7ba49f92362so437191b3a.1
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 00:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765356912; x=1765961712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kowiV3s6eCrqiOOc/4UHrcMg8VvvNPKGr9faP8+r8ho=;
        b=awvou8R4NJtbsPGtskldSjE7Qo73UBQAI7WlRRPeBk0s2dAaGeXHsJrlaNvVlDX/DQ
         FmoKxkfYyuaJR1oSn84Y9yr6rACYWWtqPxwzQn92xQtFoM6gjaKVcjsxzDinVpRhp0cZ
         NV4l6ARo3LsxN7hy9qaOo3Xh8SFQ39i5V4cmb0fT88Emj8a1pxirM2quMONjQAxfuXDm
         ejIkPD8VeUzhI20Izd48BvRzXNElos/USTbfGzL8TsBVf9RGGbTMk6mMKO41ehsjZxXe
         N/xQIKoPcwxTPNuWlQzhCLRGdbxW5ewVSxlqxvokY1U3g5kcd96/kcZWtLNtNNqeX1qi
         G30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765356912; x=1765961712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kowiV3s6eCrqiOOc/4UHrcMg8VvvNPKGr9faP8+r8ho=;
        b=mTD0e93k0l4sef+kDcY0DA0wqLvkZXEklGcdkerI/R3/FaAooEDMHWWPwgs4yd2TOg
         yTWYMmywPzZypLR3pi6GMb0jr6KMvCqA3UliQxi+McZk8Vg1M5bercCQzzJUSjblZvLr
         BONPQEinpYe96WGQaDuTd6NWoKJxDZXsO6ClMBUlQ1fNtBEjso88ioWstgxGF2R4PIE+
         /D3gxZKmNp7+BbLE/h5xLHsfwowRUyg9rmrjYJQYQzFEmx4B+fhTfd7T+7q84h+p5yS3
         6ZesMw9+w2/2UMBS4xLdMxF+4JCok93Ya2vlQtF1ANaScm6uJthS9aOF0vQNEqSA7bh0
         X9CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRNN1ltKvmzNHTnkKjcHCzpq+XQJZMnjp5EvugYoLhZaspRJ15h1oZ7zBHRgwL2eLOWLIDn5aHuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRSo6xk1Sdi7t++MngsOLs5mTMbTBBVlvtGQseDmcB2F14n7Bp
	skBe58i3tCrNW8NEEmQKSO8f3wZtrKT1TlAjz/36robhL3aUMosbXJUl
X-Gm-Gg: ASbGncvvq19no03K85wmDGL5kkbhMgdwq/7BKT2yvd2JGVDtm4RI3yspMR/Dob9N0Qb
	nYbS+Zew5MCAPtqTtGZQs3wQaEVeSWgwrlZz7Rz9bUGi7C5bMp/jWUpyUip1OgMSkBK8rMg02EL
	v0aYfozavJNXIjIxe1TrU+44Nl1S7jaXTzuny2UXJjgLVia/ib2tLitSdxVL0WMzn1ybnTmpEJH
	49/jOdkfEfLCGS/Zr7S+BeRDQmUvF6th/cWBCgl8LiQv8IJdDIruBTH0rZqflVJ2uAbrPet7G8a
	4/UqLLhHp3dr6WSp0szCrq6XKb7R3qTSKcpNrurggnuzILvuE71ruB3n6d1L8S34lAFuLhGE9BY
	GnHEpRJCLp3j8VE2y/5tAEQfvZ+KTHl1isr0KlsJIRSmiUdV4J+qcTq28gMEISt/qrSgV1BUY4D
	B4H+h+yQng27WLBmqWtCQGCbOxXl+oeKGPI6bDqJOo788=
X-Google-Smtp-Source: AGHT+IGAWQeuYaJz9YLRxl39OR3Kj65SF5BFWDB+ANV4DyoeUpznFjcUgQe+0GvQc5zeMbBihrbDZw==
X-Received: by 2002:a05:6a00:6714:b0:7e8:3fcb:9b06 with SMTP id d2e1a72fcca58-7f1348ed04fmr2748595b3a.28.1765356912278;
        Wed, 10 Dec 2025 00:55:12 -0800 (PST)
Received: from localhost.localdomain ([101.71.133.196])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7e2ae6fcc87sm18681836b3a.49.2025.12.10.00.55.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Dec 2025 00:55:11 -0800 (PST)
From: Fengnan Chang <fengnanchang@gmail.com>
X-Google-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [RFC PATCH 0/2] io_uring: fix io may accumulation in poll mode
Date: Wed, 10 Dec 2025 16:54:59 +0800
Message-Id: <20251210085501.84261-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
is considered that the current req is the actual completed request.
This may be reasonable for multi-queue ctx, but is problematic for
single-queue ctx because the current request may not be done when the
poll gets to the result. In this case, the completed io needs to wait
for the first io on the chain to complete before notifying the user,
which may cause io accumulation in the list.
Our modification plan is as follows: change io_wq_work_list to normal
list so that the iopoll_list list in it can be removed and put into the
comp_reqs list when the request is completed. This way each io is
handled independently and all gets processed in time.

After modification,  test with:

./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
/dev/nvme6n1

base IOPS is 725K,  patch IOPS is 782K.

./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
/dev/nvme6n1

Base IOPS is 880k, patch IOPS is 895K.

Fengnan Chang (2):
  blk-mq: delete task running check in blk_hctx_poll
  io_uring: fix io may accumulation in poll mode

 block/blk-mq.c                 |  2 --
 include/linux/blk-mq.h         |  1 +
 include/linux/blkdev.h         |  1 +
 include/linux/io_uring_types.h |  8 +++---
 io_uring/io_uring.c            | 51 ++++++++++++++++------------------
 io_uring/io_uring.h            | 15 ++++------
 io_uring/rw.c                  | 35 +++++++----------------
 io_uring/slist.h               |  9 ------
 io_uring/sqpoll.c              |  8 +++---
 9 files changed, 49 insertions(+), 81 deletions(-)


base-commit: 4941a17751c99e17422be743c02c923ad706f888
prerequisite-patch-id: 14d5e19968d0acb074ebcd62f073c330b0e34f36
prerequisite-patch-id: 1b5c18a564a4b4788f4992dc02d70c01f69c0e0e
-- 
2.39.5 (Apple Git-154)


