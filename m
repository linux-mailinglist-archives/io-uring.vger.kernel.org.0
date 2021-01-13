Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0E82F4B9D
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbhAMMrA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 07:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhAMMqv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 07:46:51 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD9FC0617A2
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 04:46:10 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 3so1495369wmg.4
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 04:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F+qHT4JobKaYscNKbFypYjwY06R8svKZb+0z+qobI5k=;
        b=u+sOOC/74+f2VGmmkbU7ouoqfKF7YkbKd1nH4W1xkQ9qZ4PigG62/0czDh2I+/6LnI
         TDvtuxkmPhkEextbfd6jd4DKQ1aZ//QVF8gv0ZiymW8CaypTY+gRL/i074Wo8mbrJ6lU
         t8VkNs9JIDCA7e8CVDLo3NO0pdImUngZBfnTGJJG7bidAz6q6AMGZTDzsL8Z+pnz0eQw
         mEDjlve5bNWFNANsf3LUkY10qBSHcmkJxmTx2Z0yfCgRdq82OGwhXUuMXba4qLQRczMQ
         gBtqGJLEqPpAySRIO8j4nttp1P+/37hnF66Ze1S3EfvaESAsawkGbfoaEh7TIGW7SVoM
         8Dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F+qHT4JobKaYscNKbFypYjwY06R8svKZb+0z+qobI5k=;
        b=fZKgKR2FsK3SP2bZTwkzL2KJTz6bHlkuQWDbSdbli8RxZxASLo8Ip+6Q4Z2PT/rXTW
         h9TcMHSvQvbViNYazxX52BnGKfoisp3BCAMxllMoks80o0W/RLCwTWkKjof8hUnKkRqr
         lyijcdhRUyltvncUGnAYbJOvsVaVytV60cMk86Uxb7vrQ2XjrpfQRa6FEyq6gDhFl06V
         7iWDLQ8/QT6RP1StnKWWTMMtwXNm+MaIhH44uhrESQfGafVo8X0aRgFJww3Lsp9wbYfg
         ik0hKj7ec3t8xCYKiULCLas4LDMqGbMaY7/UOtVyfF4WUf8TEFzCxnOPzIGO+HQhv+N2
         +tzg==
X-Gm-Message-State: AOAM532C6tYP0Sh2epdqXp2Wte/pPr2ygbqUAxfJ2zKg7X1kcwonucuS
        EwBfXooOSDFAr3GGGPuLm54=
X-Google-Smtp-Source: ABdhPJwDsL6DHRL5E2HubnMErxJRjKAlm9tWnePH9LNBdzaVjOKbLAPu5buuQSGAenXKfbJ1u0CHQQ==
X-Received: by 2002:a7b:cbd0:: with SMTP id n16mr2097232wmi.162.1610541969638;
        Wed, 13 Jan 2021 04:46:09 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id j7sm2835764wmb.40.2021.01.13.04.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:46:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+9c9c35374c0ecac06516@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring: do sqo disable on install_fd error
Date:   Wed, 13 Jan 2021 12:42:25 +0000
Message-Id: <7ecb3d4caa77e53a63c681750da7fe02ab68a8aa.1610540878.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610540878.git.asml.silence@gmail.com>
References: <cover.1610540878.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 0 PID: 8494 at fs/io_uring.c:8717
	io_ring_ctx_wait_and_kill+0x4f2/0x600 fs/io_uring.c:8717
Call Trace:
 io_uring_release+0x3e/0x50 fs/io_uring.c:8759
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

failed io_uring_install_fd() is a special case, we don't do
io_ring_ctx_wait_and_kill() directly but defer it to fput, though still
need to io_disable_sqo_submit() before.

note: it doesn't fix any real problem, just a warning. That's because
sqring won't be available to the userspace in this case and so SQPOLL
won't submit anything.

Reported-by: syzbot+9c9c35374c0ecac06516@syzkaller.appspotmail.com
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf043c600e55..81a7ec036330 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9701,6 +9701,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 */
 	ret = io_uring_install_fd(ctx, file);
 	if (ret < 0) {
+		io_disable_sqo_submit(ctx);
 		/* fput will clean it up */
 		fput(file);
 		return ret;
-- 
2.24.0

