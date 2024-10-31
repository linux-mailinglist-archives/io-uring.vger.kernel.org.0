Return-Path: <io-uring+bounces-4270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8929B7C87
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 15:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D15CC1C20FD5
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D6242C0B;
	Thu, 31 Oct 2024 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fCnTxz+x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A5419538D
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730384081; cv=none; b=dI0jEtOJyVu35gdRy2m7LHPo1PohyDZzgXiX6UO/55oIJsw+HBiHtVXVvOrWJp99ZQSTl30wEepaiYUFbHCv3gg0RS5FXfj2JaXNuWNj3TciiAjr+Gp4hCFxYTg/RWvDbUgkZ4zVOpkItCLyE9Xp9gy8/26kIfUh9VhM/iXdkiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730384081; c=relaxed/simple;
	bh=lzQwurv6QT01hIrIbN9ul9GvZ1dQC+rBxi2Lqi7hNl8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=ApUXOQ/T4F7jA/J2bk12URb0A3JYLCNSe7Pz8uw61bf0VY8urElI7mmInrk5slSzqyrERBzRrSIjXjERDbqtmZDQr5HrHHzDoOERqPew1xDRc3IAt+v5Yz6pfdqlgap5hidaJzrK8JJacXlOAHEAAaVn6ux29la2EBY0LZn2O0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fCnTxz+x; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83aad8586d3so37941839f.1
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 07:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730384075; x=1730988875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHpERe6g4THQHHunVxX4R+p0LPUBUQPPw/vhfS9/TYM=;
        b=fCnTxz+x8O0XgJTU0V5PkTEA/d/BRi4Yw3wBDRIOAyTD3Xiu6dcflY8816nWFmkJ3f
         X5GrS9f6wJrh3vquSr5ZksxokVTj7wqp5ICw/2pbwTRj7iSDb7sGJ6ieAeOfFwyZ9Qqc
         ptJWc9MXwDSoQpkcpXM/SC8oou2sAOfzccpMACUbV2QG+8fiw0tyQTCz39beQ1IxdEKd
         21UxNJsKGT7kmUbUDb8lSGjdCwgPjDrZjjg/3DG7LXeOHp8UtILMYi28RRDOC98tP4J5
         0g39GgtyZivYSzk9U1Ut/ywcEIn0wwL2ZypzntOcwpm1i5x8gfy6pIyAW2P2M+MDYPxs
         znsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730384075; x=1730988875;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SHpERe6g4THQHHunVxX4R+p0LPUBUQPPw/vhfS9/TYM=;
        b=sPwWATUwuwdNiu3+VLPfKWAvke0JGPfK0fEPBjovUbL6ApAf8JbAjActDw00iFOfhX
         CnrYdE+nq4gOEeEgM2P9jfdFMwatkz0NrU6mwUu65L01zrNqz6SMyxUQYxpIwwrfyIFO
         MBGt+j4JVuI7lAMtZUM4WMbTzaGoObQJ8pePa2ah0gLDw1l6Ndm7d7YFIVKADP7r3Io4
         gYf4GrHkxyZ96siWi8o3EUgTXH4J3R0RbFFTwd2gkhmaGaPjk2nemTy/UYeQDzY1XMoo
         ORf9Af1RYHur74YS4hkNK+VtvZlsoKLfW4hupk1GhgljEejHwUH8iPNnW5/44bAYMqUi
         edBQ==
X-Gm-Message-State: AOJu0YyU9Ja4yHpr1RzZnoWWua119s9rdYi01dHizX65tgt7mRJNHsZ4
	e9oyJxqXjvJOp8leb6IsdbSCPT2jmyzMech064lHK2nFv+9c4DhdnH23pAE6R+/CPjUI70W3lsh
	viaM=
X-Google-Smtp-Source: AGHT+IGo34DKxudFSUmz7+qg4aqR6wHjjmkDImhyVm9Pg6niSXy20hZcUqrRoJdngPZaoXiQrrS7Hw==
X-Received: by 2002:a05:6602:29d0:b0:83a:a746:68a6 with SMTP id ca18e2360f4ac-83b1c43e1a0mr2268593139f.5.1730384075328;
        Thu, 31 Oct 2024 07:14:35 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b67cd0ab8sm33772539f.49.2024.10.31.07.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 07:14:34 -0700 (PDT)
Message-ID: <46f67f82-846b-4607-902a-c71e3d2a68c6@kernel.dk>
Date: Thu, 31 Oct 2024 08:14:34 -0600
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
Subject: [PATCH] io_uring/rw: fix missing NOWAIT check for O_DIRECT start
 write
Cc: Peter Mann <peter.mann@sh.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When io_uring starts a write, it'll call kiocb_start_write() to bump the
super block rwsem, preventing any freezes from happening while that
write is in-flight. The freeze side will grab that rwsem for writing,
excluding any new writers from happening and waiting for existing writes
to finish. But io_uring unconditionally uses kiocb_start_write(), which
will block if someone is currently attempting to freeze the mount point.
This causes a deadlock where freeze is waiting for previous writes to
complete, but the previous writes cannot complete, as the task that is
supposed to complete them is blocked waiting on starting a new write.
This results in the following stuck trace showing that dependency with
the write blocked starting a new write:

task:fio             state:D stack:0     pid:886   tgid:886   ppid:876
Call trace:
 __switch_to+0x1d8/0x348
 __schedule+0x8e8/0x2248
 schedule+0x110/0x3f0
 percpu_rwsem_wait+0x1e8/0x3f8
 __percpu_down_read+0xe8/0x500
 io_write+0xbb8/0xff8
 io_issue_sqe+0x10c/0x1020
 io_submit_sqes+0x614/0x2110
 __arm64_sys_io_uring_enter+0x524/0x1038
 invoke_syscall+0x74/0x268
 el0_svc_common.constprop.0+0x160/0x238
 do_el0_svc+0x44/0x60
 el0_svc+0x44/0xb0
 el0t_64_sync_handler+0x118/0x128
 el0t_64_sync+0x168/0x170
INFO: task fsfreeze:7364 blocked for more than 15 seconds.
      Not tainted 6.12.0-rc5-00063-g76aaf945701c #7963

with the attempting freezer stuck trying to grab the rwsem:

task:fsfreeze        state:D stack:0     pid:7364  tgid:7364  ppid:995
Call trace:
 __switch_to+0x1d8/0x348
 __schedule+0x8e8/0x2248
 schedule+0x110/0x3f0
 percpu_down_write+0x2b0/0x680
 freeze_super+0x248/0x8a8
 do_vfs_ioctl+0x149c/0x1b18
 __arm64_sys_ioctl+0xd0/0x1a0
 invoke_syscall+0x74/0x268
 el0_svc_common.constprop.0+0x160/0x238
 do_el0_svc+0x44/0x60
 el0_svc+0x44/0xb0
 el0t_64_sync_handler+0x118/0x128
 el0t_64_sync+0x168/0x170

Fix this by having the io_uring side honor IOCB_NOWAIT, and only attempt a
blocking grab of the super block rwsem if it isn't set. For normal issue
where IOCB_NOWAIT would always be set, this returns -EAGAIN which will
have io_uring core issue a blocking attempt of the write. That will in
turn also get completions run, ensuring forward progress.

Cc: stable@vger.kernel.org # 5.10+
Reported-by: Peter Mann <peter.mann@sh.cz>
Link: https://lore.kernel.org/io-uring/38c94aec-81c9-4f62-b44e-1d87f5597644@sh.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 354c4e175654..155938f10093 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1014,6 +1014,25 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)
+{
+	struct inode *inode;
+	bool ret;
+
+	if (!(req->flags & REQ_F_ISREG))
+		return true;
+	if (!(kiocb->ki_flags & IOCB_NOWAIT)) {
+		kiocb_start_write(kiocb);
+		return true;
+	}
+
+	inode = file_inode(kiocb->ki_filp);
+	ret = sb_start_write_trylock(inode->i_sb);
+	if (ret)
+		__sb_writers_release(inode->i_sb, SB_FREEZE_WRITE);
+	return ret;
+}
+
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -1051,8 +1070,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	if (req->flags & REQ_F_ISREG)
-		kiocb_start_write(kiocb);
+	if (unlikely(!io_kiocb_start_write(req, kiocb)))
+		return -EAGAIN;
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (likely(req->file->f_op->write_iter))

-- 
Jens Axboe


