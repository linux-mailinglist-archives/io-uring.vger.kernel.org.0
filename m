Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5530018AB4A
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2020 04:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCSDvc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Mar 2020 23:51:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34098 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgCSDvc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Mar 2020 23:51:32 -0400
Received: by mail-pf1-f195.google.com with SMTP id 23so676141pfj.1
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2020 20:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=A2n5NhSwc+NPxtTb6f8JirkTqbU6e2vkYk5KBXYjPlE=;
        b=cmuzcQHOm6vvRwzxEXGE84VZhmsdqisfSb0WtC6gx18mDDgRmjdOCTHrkQVmIrwKbS
         6QwT+MlN/N3I9EXuIOkizifUsRZ106J6jE02qixHh/KA8qvauXusjaX3f3Xk4Buxy/Ol
         WJBLZaElCC2DMpTwgTr6MqzQpKpuN24Un47eoBkaFBpYQswTmD/PtNDbetcnBR5RZQrF
         Q/m6D88CUVb6uU7NejiRbMUlpx863zI+URtzzxePtpme1K6bamXEHErkWbPz0FqhID/u
         01Ea78T2IF5InatE8lP5yYNmY8wN/hJUZpI7oAv+EKjstfjYbFJDchyDdkgUicChze80
         kwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=A2n5NhSwc+NPxtTb6f8JirkTqbU6e2vkYk5KBXYjPlE=;
        b=p56Q4TcDPc9IbtkxI4epKk3kxs4KnBBuoYBKfIqOCvzxlkgTLTAuY/D+9zrTlv2YVt
         w0WHd4R/8Z5fZ50PL/AJ2PrhNj9nIuM8rDHZmKFn4tT6VutyioRKpGND+ZhYuEXYVmWl
         Zg1PIaAq0MxgUgHkYLFURI31Mgp8G1RMFX81rKzP02E9Gx5W6ZhMpaqphbvW1nqsox4A
         eoXx9sBWpnkSwP2E3WC6xpjCYrncEfLD/tQJ7dMGSJ5TR4jJogoXT3Wp42GxyIL8HD0q
         NBgOK4/iriGVeNIzMODoDeIO6YilIl35snKN6uWW8g3+dGGGv5Mf2JyV4C5DVhdKC4IV
         SJcA==
X-Gm-Message-State: ANhLgQ0gAkmpsVc7h6yFhlTB9a6HcnljbWuiD3ZtwwPG9lJ7CBtya6Wi
        DX4Sffrl1l2HZTsKJp6H//sonA==
X-Google-Smtp-Source: ADFU+vtpjc5+9w/VwhMv8QCF5SknsiOnyqAvECIHq9gli96yeQlGz8pV0OiICPe+xXIimMX93/RriQ==
X-Received: by 2002:a62:55c7:: with SMTP id j190mr1721673pfb.65.1584589891244;
        Wed, 18 Mar 2020 20:51:31 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id l189sm472640pga.64.2020.03.18.20.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 20:51:30 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: REQ_F_FORCE_ASYNC prep done too late
Message-ID: <d9c7608a-a5c5-8082-1b74-90ce690288b4@kernel.dk>
Date:   Wed, 18 Mar 2020 21:51:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous patch ensured that we always prepped requests that are
forced async, but it did so too late in the process. This can result
in 'sqe' already being NULL by the time we get to it:

BUG: kernel NULL pointer dereference, address: 0000000000000008
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0 
Oops: 0000 [#1] PREEMPT SMP
CPU: 2 PID: 331 Comm: read-write Not tainted 5.6.0-rc5+ #5846
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:io_prep_rw+0x37/0x250
Code: 41 89 d4 55 48 89 f5 53 48 8b 0f 48 89 fb 4c 8b 6f 50 48 8b 41 20 0f b7 00 66 25 00 f0 66 3d 00 80 75 07 81 4f 68 00 40 00 00 <48> 8b 45 08 48 83 f8 ff 48 89 43 08 0f 84 c6 01 00 00 8b 41 34 85
RSP: 0018:ffffc900003ebce8 EFLAGS: 00010206
RAX: 0000000000008000 RBX: ffff8881adf87b00 RCX: ffff8881b7db4f00
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8881adf87b00
RBP: 0000000000000000 R08: ffff8881adf87b88 R09: ffff8881adf87b88
R10: 0000000000001000 R11: ffffea0006ddee08 R12: 0000000000000001
R13: ffff8881b325c000 R14: 0000000000000000 R15: ffff8881b325c000
FS:  00007f642a59e540(0000) GS:ffff8881b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000001b3674004 CR4: 00000000001606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_write_prep+0x1c/0x100
 io_queue_sqe+0x8f/0x2a0
 io_submit_sqes+0x450/0xa10
 __do_sys_io_uring_enter+0x272/0x610
 ? ksys_mmap_pgoff+0x15d/0x1f0
 do_syscall_64+0x42/0x100
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f642a4d0f8d
Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d3 4e 0c 00 f7 d8 64 89 01 48

Fix this by ensuring we do prep at io_submit_sqe() time, where we
know we still have the original sqe.

Fixes: 1118591ab883 ("io_uring: prep req when do IOSQE_ASYNC")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6049546e77c..ff35f5ac91ea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5528,15 +5528,11 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ret = io_req_defer(req, sqe);
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
-fail_req:
 			io_cqring_add_event(req, ret);
 			req_set_fail_links(req);
 			io_double_put_req(req);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
-		ret = io_req_defer_prep(req, sqe);
-		if (unlikely(ret < 0))
-			goto fail_req;
 		/*
 		 * Never try inline submit of IOSQE_ASYNC is set, go straight
 		 * to async execution.
@@ -5650,12 +5646,21 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			req->flags |= REQ_F_IO_DRAIN;
 			req->ctx->drain_next = 0;
 		}
+		if (sqe_flags & REQ_F_FORCE_ASYNC) {
+			ret = io_req_defer_prep(req, sqe);
+			if (ret < 0)
+				goto err_req;
+			/* prep done */
+			sqe = NULL;
+		}
 		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 			req->flags |= REQ_F_LINK;
 			INIT_LIST_HEAD(&req->link_list);
-			ret = io_req_defer_prep(req, sqe);
-			if (ret)
-				req->flags |= REQ_F_FAIL_LINK;
+			if (sqe) {
+				ret = io_req_defer_prep(req, sqe);
+				if (ret)
+					req->flags |= REQ_F_FAIL_LINK;
+			}
 			*link = req;
 		} else {
 			io_queue_sqe(req, sqe);

-- 
Jens Axboe

