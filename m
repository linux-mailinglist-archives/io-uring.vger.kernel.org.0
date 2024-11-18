Return-Path: <io-uring+bounces-4773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C66869D1431
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 16:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 485C0284DA4
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 15:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1B41A0B0C;
	Mon, 18 Nov 2024 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFMzUdhh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB2A1BD508
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731942846; cv=none; b=GC4SknBSlkr3L9eO1nFHGTRzIHLB9fjdAo5sqgv7A9Dpy/4Y/xzNR+dhxfg1GkMP6cTKQQw7ag0wfE73SRpnsAOUtmXJ3663/oU8y/tJ4WMJQZAKVu2RQVW8rBC1EdwefWMYzHgVzW8j4V/C5tahO7CXV/39GqVJoaVd5Y/vD6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731942846; c=relaxed/simple;
	bh=WykoxbmJZTrExbnyw4eTYLNSMxtiJ1+zqtJQ+D557ug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WZ+5lVRjmxrp5VyPULXnJjPuYXa7W7havAiXIq0Gp0Rwc8fFAqeGMv3xTc7r3iOCoP4sUi9rPV7fQTMgaBGUTmxVdeig7PB4sVNCpZNvo08fFauNksXNehpWiCg5sXH3VaKJFUojWQSCtEEFBAouo79NX5kPjV5llvS4r8RQjVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFMzUdhh; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb6110c8faso37444591fa.1
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 07:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731942842; x=1732547642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=02EIu9O/aoQBrZntR7Lv5tzXiXHRpy1XcH8RD8ki/T8=;
        b=BFMzUdhhNENcze539HDUb1Mez4bEXjvkaTZEf7pQyLmaFoSK6OCeOKB0G8Poxw/OBM
         cIROd6gs4jxFIXfEoJ3igeZj75318/2pKC1n/lrweVN+WJYuXDsL0oS3AR/6Ouo0lySA
         cABvb4c0lAuOu8Bob49mxRk3IIyCRITD1xe338UncgehUYfn/jHsOO3o2FRLIUT12yM1
         BpAXv+sUuSuZVt7ly1otLZQj2dRvihOfGuovpvhAADZ2znIby/zVYq5a5Vfj3NTWbn5U
         Vw2XoCNduxIT+QCXgRjAaEgALmB2GGHTQHI67WJJEPg1l8A+0zmjqTNvonk4OupVjy6v
         savw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731942842; x=1732547642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=02EIu9O/aoQBrZntR7Lv5tzXiXHRpy1XcH8RD8ki/T8=;
        b=oT7PCoK1xwmcKTUFjETuPVUviXXBpkD0TGKUD6aQ052wCQW7RzYLVKbr3nBLEChIQ8
         XO3rf/deaKxcpNf1AJWrlehK44fRCbBG7tLNaLCtmXuSs8LN7kOZj4Qpj9qbVJTgFRNA
         C+Eh8XocqvyBoUmgKe9mjU5Nh6BZ62TZfQSVRqBfZ1XxQibQjYhpU9m2hNOSAFEWwrN6
         A2mZOYxIEAvxB3ctE/M1s5fF1YxG2qAMhDEKXnt14y5Tn6DBWrGHJnFjvwy2ab8gmpdt
         6glqRYVAnNi064jGUvxSlITpWvZmTf4mi+56A4aVJp9PwAdOK/6T7C9XaeOIyIxIHPL4
         REmA==
X-Gm-Message-State: AOJu0Yz9YPTHH1EYTnkUR5rHA64MRmGZMHUFTSe33+RX4oNjbOxejcFH
	tnqy3ID1VTY9AyOT5zX9j4eZ0xXkVS/aoNQ0ZJ7n/smlkwKfWK18KJr+mA==
X-Google-Smtp-Source: AGHT+IHH6cWn84c+9/j/1vAD8eN21WRocTfz/dwdEj1hp82XwbYavV0HBaV0qWybu7yT1k0CMEiO1Q==
X-Received: by 2002:a05:651c:88a:b0:2fe:fec7:8adf with SMTP id 38308e7fff4ca-2ff609be35fmr53299571fa.38.1731942842099;
        Mon, 18 Nov 2024 07:14:02 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-218-132.dab.02.net. [82.132.218.132])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cfa7248e38sm2645711a12.17.2024.11.18.07.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 07:14:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	syzbot+5a486fef3de40e0d8c76@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: protect register tracing
Date: Mon, 18 Nov 2024 15:14:50 +0000
Message-ID: <8233af2886a37b57f79e444e3db88fcfda1817ac.1731942203.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syz reports:

BUG: KCSAN: data-race in __se_sys_io_uring_register / io_sqe_files_register

read-write to 0xffff8881021940b8 of 4 bytes by task 5923 on cpu 1:
 io_sqe_files_register+0x2c4/0x3b0 io_uring/rsrc.c:713
 __io_uring_register io_uring/register.c:403 [inline]
 __do_sys_io_uring_register io_uring/register.c:611 [inline]
 __se_sys_io_uring_register+0x8d0/0x1280 io_uring/register.c:591
 __x64_sys_io_uring_register+0x55/0x70 io_uring/register.c:591
 x64_sys_call+0x202/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:428
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff8881021940b8 of 4 bytes by task 5924 on cpu 0:
 __do_sys_io_uring_register io_uring/register.c:613 [inline]
 __se_sys_io_uring_register+0xe4a/0x1280 io_uring/register.c:591
 __x64_sys_io_uring_register+0x55/0x70 io_uring/register.c:591
 x64_sys_call+0x202/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:428
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Which should be due to reading the table size after unlock. We don't
care much as it's just to print it in trace, but we might as well do it
under the lock.

Reported-by: syzbot+5a486fef3de40e0d8c76@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 1a60f4916649..1e99c783abdf 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -905,9 +905,10 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
-	mutex_unlock(&ctx->uring_lock);
+
 	trace_io_uring_register(ctx, opcode, ctx->file_table.data.nr,
 				ctx->buf_table.nr, ret);
+	mutex_unlock(&ctx->uring_lock);
 	if (!use_registered_ring)
 		fput(file);
 	return ret;
-- 
2.46.0


