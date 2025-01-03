Return-Path: <io-uring+bounces-5657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0BCA00228
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 01:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A35F4163037
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 00:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2E31DFCB;
	Fri,  3 Jan 2025 00:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F1MFhH5O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526D48BE5
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735865585; cv=none; b=lZu+2TM/pKmNfSTuxUwVzCOgUbBYgcfN5edZ04haZltm/GpDMouIUz5QNu4TPNqTxGmNCum6bH+TbUlYdNPyxNaSAR3eAKn7uPHJL9a6Ejh2NnhsZ9O4G5UGijCS1cmsacTpsKGhmhVEF2+wQfCkMulp7bwTAKI9LXmerY/VNL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735865585; c=relaxed/simple;
	bh=iUMc4Zwy96H711IFoaMpPvqDvdsWjOqx1Bk7kj3z4pE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=TgVHaF9aZJnzxEcxI6PnzKcRIC25p1lT+2YxB4WpgALS3u84Kzj0zWx+wJ2JXz5SArCAS6xiuTH6iYCKqNXGXW9VUDIBVvUaiooSQIPhEKbMZMJfJML+DjlfxQYDnOfBn6ELNfmEj4nGh68JLXbyLivodldAanyeSK+VU6aorOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F1MFhH5O; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a8146a8ddaso44218485ab.1
        for <io-uring@vger.kernel.org>; Thu, 02 Jan 2025 16:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735865581; x=1736470381; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfP8Drp9pnaISLKo3Lpz2HpUn34wVqfwF9utAQz/zbc=;
        b=F1MFhH5OkNEMZs7wmZ+lFKjTqWsHy7gTPa3pmMntocC4TAq2Lz5D+0y7zGmPwOQ7V4
         WsIiPd2ahjDqOAq61LZquuJha9JBY/zUjid+Fiwbxk5kYwdWBL74DeU/sPb7CC3VfDmQ
         whSrAb1iUiuUXej9atEV8VHTOtIjgchjhAgBjoobtq9sj8zGBTCNltlkiJHQbbm/2pgd
         WBqdPSxzPLhg98K8qSKJiMXE2jP+TkigL5W451ber4Cy0/MpnSx8WgfG044HJFzJDOIL
         IBxBc0VEOD6/YrZ9z9vHZ/dXHNt3zAGLgxnfVxlfCGbtoNExg7M478L1UWl7GDpTWWY3
         JJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735865581; x=1736470381;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YfP8Drp9pnaISLKo3Lpz2HpUn34wVqfwF9utAQz/zbc=;
        b=lpxyYNQtzDL96AdqzCYAVyJ1mhcyXGq9KI1yPiuHP0uaSZxDntM8Rc3yF5q3g35kfa
         yNtrotfvk2Zbnj2KZaZu8xmztZ/jn8HSXnysAQ0J6c8ekZtWfZQpq7+2pqaeWyWohETa
         /eRnzI0B7zTQNUzoEy/+lGWzVRuVBR2xlNbvIaWTOzm8g6qj8nUxilQel8sIak9/EOJw
         fT7urogjq1JZewLUK3At0KWhqxILi6VmzGFfy8HGNL/u/lahfOiFMQgCwqZ01sdX3HQp
         ggaLx75NSGFGYdswStWTb5vo1MQ0alPWgRo+Gdz+XspF0JxBLBMOZh/kzDrE2uFLGZMx
         pJ1g==
X-Gm-Message-State: AOJu0YxUj1IkqoPcLeIBHSIsxbLXqizXd4o39QfOnSEgpuwbZ0OhAelN
	5wHzJAh1Z5SgeJe2oD7oU6KVBwTRZn6kN9zQhKwVqsufSwUVxFWsBsP98zP4T46oTbKOzcZ+CQp
	D
X-Gm-Gg: ASbGncv0SQHylmczXNh3EVmX26NvGq8jkEZMdDsM/PFyzQ+WK7dTpOsVZq4XPRnK0lK
	kHc8eZ4Oa7UF0MgChizknYHmF32QlSz2ctkw/2yINkJvTsTqnbUZwI8U2rGCXZczdDzeZbJq5O5
	1XSBfbGrREDihS5oqsX6Dsvqkif2nSxjbsCfSdcVMg+Ku0PkvRO0l2h0OEMNEgfHXq1UwCIhCFk
	EZeO2SHwQMqFiI1xjzjph02j3HQ0oejVbBysT6i3UvYdY67D6d3qg==
X-Google-Smtp-Source: AGHT+IFZSTVyVuKC56slQNzY+D950g/jaWoRG3US/+obHrYIEmOkkSoWj5zcTylw9AA1k3F9Y+SxZg==
X-Received: by 2002:a05:6e02:1a47:b0:3a7:e732:472e with SMTP id e9e14a558f8ab-3c2d1aa2beemr385810625ab.4.1735865580841;
        Thu, 02 Jan 2025 16:53:00 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0e47d6f01sm77015255ab.73.2025.01.02.16.52.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2025 16:53:00 -0800 (PST)
Message-ID: <2ff79de8-3b10-4dd3-a372-bb76b695d00a@kernel.dk>
Date: Thu, 2 Jan 2025 17:52:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: always initialize kmsg->msg.msg_inq upfront
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

syzbot reports that ->msg_inq may get used uinitialized from the
following path:

BUG: KMSAN: uninit-value in io_recv_buf_select io_uring/net.c:1094 [inline]
BUG: KMSAN: uninit-value in io_recv+0x930/0x1f90 io_uring/net.c:1158
 io_recv_buf_select io_uring/net.c:1094 [inline]
 io_recv+0x930/0x1f90 io_uring/net.c:1158
 io_issue_sqe+0x420/0x2130 io_uring/io_uring.c:1740
 io_queue_sqe io_uring/io_uring.c:1950 [inline]
 io_req_task_submit+0xfa/0x1d0 io_uring/io_uring.c:1374
 io_handle_tw_list+0x55f/0x5c0 io_uring/io_uring.c:1057
 tctx_task_work_run+0x109/0x3e0 io_uring/io_uring.c:1121
 tctx_task_work+0x6d/0xc0 io_uring/io_uring.c:1139
 task_work_run+0x268/0x310 kernel/task_work.c:239
 io_run_task_work+0x43a/0x4a0 io_uring/io_uring.h:343
 io_cqring_wait io_uring/io_uring.c:2527 [inline]
 __do_sys_io_uring_enter io_uring/io_uring.c:3439 [inline]
 __se_sys_io_uring_enter+0x204f/0x4ce0 io_uring/io_uring.c:3330
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3330
 x64_sys_call+0xce5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

and it is correct, as it's never initialized upfront. Hence the first
submission can end up using it uninitialized, if the recv wasn't
successful and the networking stack didn't honor ->msg_get_inq being set
and filling in the output value of ->msg_inq as requested.

Set it to 0 upfront when it's allocated, just to silence this KMSAN
warning. There's no side effect of using it uninitialized, it'll just
potentially cause the next receive to use a recv value hint that's not
accurate.

Fixes: c6f32c7d9e09 ("io_uring/net: get rid of ->prep_async() for receive side")
Reported-by: syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index df1f7dc6f1c8..c6cd38cc5dc4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -754,6 +754,7 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 	if (req->opcode == IORING_OP_RECV) {
 		kmsg->msg.msg_name = NULL;
 		kmsg->msg.msg_namelen = 0;
+		kmsg->msg.msg_inq = 0;
 		kmsg->msg.msg_control = NULL;
 		kmsg->msg.msg_get_inq = 1;
 		kmsg->msg.msg_controllen = 0;

-- 
Jens Axboe


