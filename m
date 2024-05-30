Return-Path: <io-uring+bounces-2024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D85E48D52D2
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 22:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08D4C1C24526
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 20:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038F14D8DD;
	Thu, 30 May 2024 20:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cQg+dKW0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6311614BF89
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 20:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099551; cv=none; b=YbCn77SY04fAUqvzpbqvDOUyNeW2Iwao4JJlR/f0ubQSRVaCesXX5d3hP0eeTdaJ9NKHV9F29AcUCG8ntNQrvk372LaBEyjk7HKajizLuVOQ2koSeaEzEySKhBbJPVQ+tXO9Kd2inGAUwKml7EzcOX9Rp5kXD/ft/ZrZVOAegr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099551; c=relaxed/simple;
	bh=lB+E1cKRxUg+pV6eKF80NLNzhhUX47cyJnHvWLnNyqs=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=dh4HfZn93EO1DW1m3IVxOekv5uYi6JYl88l0+lXr4LY/fLjdz8T+Fw/A3KSozXXGnQaSdvAYezJydmNuYDpbZcLgtqeODP90Ze82u91jm6JVlEYmXk3s/JxKlW56xqII4tG5IihhNffxuGQFLGh26gvbPhJ6HyMGAjQY8QnoD4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cQg+dKW0; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5b3356fd4f3so183168eaf.1
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 13:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717099546; x=1717704346; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AVygp+5SOh4n5WFolw32HoP+ARGvDvMNAkk7oB6rlh4=;
        b=cQg+dKW0QvSYvQkEm3iHZW6sJJvQOimxV6gMRpb2/ssLj82YCMn7Rfm7url9BSyWFP
         B7KKqhiYRl3YGXMNtZyXxXBHBEY+2fxWOdD6SB1GmY+Pm0fBV+wRuFiglwyM9izqp1rV
         qrNAAjMFQcprUN/wSsJoEFYGei3bEaAIWmB9lhaTtF86FuywzT6+nTyGNdDJ2ZTRCQBg
         iP7Zox8Z4mlAIl28lSfb19IrKrFF84uytTlaHMOXd2PhhqY8QPTG1RyDAmZCum7dyJZW
         Uw/ymcCOZYUprTHG+nPNR1BDVTtN6BwDQ8WuEhSoJhURTvZ0n/OVihFv19DSqo28w2mH
         qHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717099546; x=1717704346;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AVygp+5SOh4n5WFolw32HoP+ARGvDvMNAkk7oB6rlh4=;
        b=FQhDFzxZHybK6HPzyQDPrUxxL8O9KDwg6uABWcHZ+p8QmKVex4sjTRtTEVX0uXr8hJ
         DlOeMqKL4uo5kekywmWacRkwWTgie47+qyZEEOCFSkCS4kCiba6ZxOWLuBcJPlqrYbBn
         qMqUquU2kOJ3fvOc7MUveJhLWE7tnISnxFykyKRMGLdy2luFkbJV5uNow/wUPQstIaiq
         4VV5NbEdSy5EEZ0/tSaQv2zaMecQKNK8aWDc/9B9foYjigCFD47qZvMcUsJ27Bc9yCiM
         qifFkszpGGxm5j97D6Ex+RAm+leV0IToAOjuEcngzotmorNcfUTosGV+w/F75c+MC59L
         tpzg==
X-Gm-Message-State: AOJu0Yx3B5DY10fHUMEoAEHz/6w9fFpTX+GQrcG6rnTAZfKM/3q0hCU0
	Q7p1ZcRqsmojiXsPD7nS1JIkzee0Z5yVHUzukeCKtXP1zn+vEqvLvhM9g4cTjiR+w/AO2tC34nU
	R
X-Google-Smtp-Source: AGHT+IHeTBMYUki7KK06HoQREybrp7sSeck9qlCvcTpmGWUpwHIaxDdmW/OJmd6rEwAbw2tYbuDW7A==
X-Received: by 2002:a05:6871:3329:b0:24f:c164:2cd7 with SMTP id 586e51a60fabf-25060e93b4dmr3600825fac.4.1717099546429;
        Thu, 30 May 2024 13:05:46 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f9105231absm83431a34.11.2024.05.30.13.05.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 13:05:45 -0700 (PDT)
Message-ID: <c52d9b19-7fd7-4fb1-b396-632b9f0f612d@kernel.dk>
Date: Thu, 30 May 2024 14:05:44 -0600
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
Subject: [PATCH] io_uring/net: assign kmsg inq/flags before buffer selection
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

syzbot reports that recv is using an uninitialized value:

=====================================================
BUG: KMSAN: uninit-value in io_req_cqe_overflow io_uring/io_uring.c:810 [inline]
BUG: KMSAN: uninit-value in io_req_complete_post io_uring/io_uring.c:937 [inline]
BUG: KMSAN: uninit-value in io_issue_sqe+0x1f1b/0x22c0 io_uring/io_uring.c:1763
 io_req_cqe_overflow io_uring/io_uring.c:810 [inline]
 io_req_complete_post io_uring/io_uring.c:937 [inline]
 io_issue_sqe+0x1f1b/0x22c0 io_uring/io_uring.c:1763
 io_wq_submit_work+0xa17/0xeb0 io_uring/io_uring.c:1860
 io_worker_handle_work+0xc04/0x2000 io_uring/io-wq.c:597
 io_wq_worker+0x447/0x1410 io_uring/io-wq.c:651
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 io_req_set_res io_uring/io_uring.h:215 [inline]
 io_recv_finish+0xf10/0x1560 io_uring/net.c:861
 io_recv+0x12ec/0x1ea0 io_uring/net.c:1175
 io_issue_sqe+0x429/0x22c0 io_uring/io_uring.c:1751
 io_wq_submit_work+0xa17/0xeb0 io_uring/io_uring.c:1860
 io_worker_handle_work+0xc04/0x2000 io_uring/io-wq.c:597
 io_wq_worker+0x447/0x1410 io_uring/io-wq.c:651
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3877 [inline]
 slab_alloc_node mm/slub.c:3918 [inline]
 __do_kmalloc_node mm/slub.c:4038 [inline]
 __kmalloc+0x6e4/0x1060 mm/slub.c:4052
 kmalloc include/linux/slab.h:632 [inline]
 io_alloc_async_data+0xc0/0x220 io_uring/io_uring.c:1662
 io_msg_alloc_async io_uring/net.c:166 [inline]
 io_recvmsg_prep_setup io_uring/net.c:725 [inline]
 io_recvmsg_prep+0xbe8/0x1a20 io_uring/net.c:806
 io_init_req io_uring/io_uring.c:2135 [inline]
 io_submit_sqe io_uring/io_uring.c:2182 [inline]
 io_submit_sqes+0x1135/0x2f10 io_uring/io_uring.c:2335
 __do_sys_io_uring_enter io_uring/io_uring.c:3246 [inline]
 __se_sys_io_uring_enter+0x40f/0x3c80 io_uring/io_uring.c:3183
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3183
 x64_sys_call+0x2c0/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

which appears to be io_recv_finish() reading kmsg->msg.msg_inq to decide
if it needs to set IORING_CQE_F_SOCK_NONEMPTY or not. If the recv is
entered with buffer selection, but no buffer is available, then we jump
error path which calls io_recv_finish() without having assigned
kmsg->msg_inq. This might cause an errant setting of the NONEMPTY flag
for a request get gets errored with -ENOBUFS.

Reported-by: syzbot+b1647099e82b3b349fbf@syzkaller.appspotmail.com
Fixes: 4a3223f7bfda ("io_uring/net: switch io_recv() to using io_async_msghdr")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 0a48596429d9..7c98c4d50946 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1127,6 +1127,9 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		flags |= MSG_DONTWAIT;
 
 retry_multishot:
+	kmsg->msg.msg_inq = -1;
+	kmsg->msg.msg_flags = 0;
+
 	if (io_do_buffer_select(req)) {
 		ret = io_recv_buf_select(req, kmsg, &len, issue_flags);
 		if (unlikely(ret))
@@ -1134,9 +1137,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		sr->buf = NULL;
 	}
 
-	kmsg->msg.msg_inq = -1;
-	kmsg->msg.msg_flags = 0;
-
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
-- 
Jens Axboe


