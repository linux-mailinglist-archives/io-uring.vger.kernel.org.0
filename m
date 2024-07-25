Return-Path: <io-uring+bounces-2581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B34593C525
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 16:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20803281862
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 14:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73DB13DDB8;
	Thu, 25 Jul 2024 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O+huJU+G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3B219A29C
	for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918860; cv=none; b=XqvXEXEI7NUC/W1jz1G4mQUrAm3z6UF5rv6if+VI4256CdG427b/GjFtmn0ycczYQOYSRNk3IVRVC+76e1CIyLxekksE7qkfSv1bPCt+EZTbgawdTv9ixj4xK8V9XpUCPOl591vnYj1D1IOrt8CxSdCPqMFPYs5j5AeZ3cqJBMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918860; c=relaxed/simple;
	bh=MGEfrnjFuQAIigl/EXYuQlxt3zIxPtOqpg/Gbb1FOZU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=m4MxGClaj8uK0lCVxJ7Vr9QNNv/y+mQzQQ506h/+LLBZhUoKxvTzDdmdNd+Fh8UCRSpD5WzyT81U/UTiPaZvwSQySW8lK/N1LwkBHNlhI3dvOzy3vYZwgAX/+2fuGqUUeAkmCTrT0Mxzz+qoHeYtW5uCAB+K8kdbim5LWeed4is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O+huJU+G; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70e9545d8b2so141141b3a.3
        for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 07:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721918857; x=1722523657; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TIT7jCLia46ncjFi0yJfP89JpkCT/mA2kbteSlP9wg=;
        b=O+huJU+GhMMEgd+oUgp2qEdLdp4q6/5cZ9hy7Yd93bvT2EhjpB2UyRFcK6tLESHDW/
         3rj4IrzCj3GMMdM5IaNNomRd/Q56yWtwifLJ2BgNwcb/mMCJfAkHQklldcaE0/kcb+lB
         DpsxdwFOtjpWshuFvR8igWv+td7s4vcfij9C36RTLlx9qlf4AJu3XNre0zblJDGo7CSf
         ejBOn/B23abB4JMXXNzHj7cRGpNC32slbi6VZd8Ev3f+SLESEXMG33tVKP7vhqnll3QO
         clE/2r9X7eDAJIunj5QkwnQb/kKCJtprwbo7LR5TiB4j9JiZBurzVrGzd/WotxOuVIs/
         K1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721918857; x=1722523657;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+TIT7jCLia46ncjFi0yJfP89JpkCT/mA2kbteSlP9wg=;
        b=pUPHtXnLniENEVXqi8Q5+Bwq++WjzXpXCVcBbqGOynh8dqzlF3Xjw4O9a30fDC6hag
         YgClV8ITsw4dBAmpMg/S77xpS9Kwj7ZcGQaKM8ynNO08UfPby7mc+WAKLYENFy1lnEwD
         xwqDDJy+xcI/g01MWuRn3Gb8oiuAC0JHKVTMV5cp+wSTTd2BYvV/b/pgaZpkb4hRjHFG
         qHqrSQJvUYTVRvxoOy3t+SsasKHieWPuK8KX1fF1TiZ7QEqpkQysRLrzHvP31o03psjf
         QVu3gsixW8m3t5LiGwbyMKkhhX9lgTy5hj6UXk11QJPh1tg2dN1prX6gmto2IrjI6YnD
         jQbQ==
X-Gm-Message-State: AOJu0Yzj/j2jzUIXVKF3L522LsWIefBoyVfL20acNRrdbfs5ccov9o2z
	IgZUwWG9j2jSgQ3tCMqIOyEwfwZ7sbJM7WPpJIPokxWAG7Vzbd0vxk6yUM7uio5kq0ULXGO+5Wu
	x
X-Google-Smtp-Source: AGHT+IGWWXQ79wTQVyyy+jHMjJYtvTCTelH2rMND77F7slCEwIvjKD9Z5Wm+cQS3wHHetzZPxFhhLA==
X-Received: by 2002:a05:6a20:43a2:b0:1c3:b15b:f86b with SMTP id adf61e73a8af0-1c476f37bfcmr2116989637.0.1721918857169;
        Thu, 25 Jul 2024 07:47:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8146aesm1206509b3a.131.2024.07.25.07.47.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 07:47:36 -0700 (PDT)
Message-ID: <9ce0055a-709c-4ff1-b4d9-af6167c5de12@kernel.dk>
Date: Thu, 25 Jul 2024 08:47:35 -0600
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
Subject: [PATCH] io_uring/msg_ring: fix uninitialized use of target_req->flags
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_uring/msg_ring: fix uninitialized use of target_req->flags

syzbot reports that KMSAN complains that 'nr_tw' is an uninit-value
with the following report:

BUG: KMSAN: uninit-value in io_req_local_work_add io_uring/io_uring.c:1192 [inline]
BUG: KMSAN: uninit-value in io_req_task_work_add_remote+0x588/0x5d0 io_uring/io_uring.c:1240
 io_req_local_work_add io_uring/io_uring.c:1192 [inline]
 io_req_task_work_add_remote+0x588/0x5d0 io_uring/io_uring.c:1240
 io_msg_remote_post io_uring/msg_ring.c:102 [inline]
 io_msg_data_remote io_uring/msg_ring.c:133 [inline]
 io_msg_ring_data io_uring/msg_ring.c:152 [inline]
 io_msg_ring+0x1c38/0x1ef0 io_uring/msg_ring.c:305
 io_issue_sqe+0x383/0x22c0 io_uring/io_uring.c:1710
 io_queue_sqe io_uring/io_uring.c:1924 [inline]
 io_submit_sqe io_uring/io_uring.c:2180 [inline]
 io_submit_sqes+0x1259/0x2f20 io_uring/io_uring.c:2295
 __do_sys_io_uring_enter io_uring/io_uring.c:3205 [inline]
 __se_sys_io_uring_enter+0x40c/0x3ca0 io_uring/io_uring.c:3142
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3142
 x64_sys_call+0x2d82/0x3c10 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

which is the following check:

if (nr_tw < nr_wait)
        return;

in io_req_local_work_add(). While nr_tw itself cannot be uninitialized,
it does depend on req->flags, which off the msg ring issue path can
indeed be uninitialized.

Fix this by always clearing the allocated 'req' fully if we can't grab
one from the cache itself.

Fixes: 50cf5f3842af ("io_uring/msg_ring: add an alloc cache for io_kiocb entries")
Reported-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/000000000000fd3d8d061dfc0e4a@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 29fa9285a33d..7fd9badcfaf8 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -110,10 +110,10 @@ static struct io_kiocb *io_msg_get_kiocb(struct io_ring_ctx *ctx)
 	if (spin_trylock(&ctx->msg_lock)) {
 		req = io_alloc_cache_get(&ctx->msg_cache);
 		spin_unlock(&ctx->msg_lock);
+		if (req)
+			return req;
 	}
-	if (req)
-		return req;
-	return kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN);
+	return kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
 }
 
 static int io_msg_data_remote(struct io_kiocb *req)

-- 
Jens Axboe


