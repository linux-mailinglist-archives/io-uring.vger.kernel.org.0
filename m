Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9EA438352
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhJWLQs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhJWLQo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:44 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BF6C061766
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:14 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v17so1522093wrv.9
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eOS1bTTj2ZLiw3pv6GR+o6pAYIZcmdGGuuWYyy5iD3M=;
        b=S/2ITJyY3d4INkQGERmLJunDWpPbHMQzxoUQqbroMa82TzriYaHq2En7euPjLDNbrF
         P8u3r36LqqY8NHXpGs3SDHR7TMefuO53QbsFBRR9faYNQ4gB4KHdvSVwrD0qd7FFv2OJ
         o3/W4QJ5v+Xu2iscUQ8ZbntDKQCQr1yjqFliGzPFZ3aQX+7WLdPupZF7PDJ8iD0t+ToV
         FJEcSMClIwrC9XqT41dVvvJjPeUWogvL2S6hLA2HLHWxi/JoScag2YC6jUCZC4nIWM3U
         hPhtmGgz0pEy6aqHiBtXQa5PBms2qUwwEOwLu+rmkfD+xzvaq/BJXBDDfT3UOeDPy4d/
         m+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eOS1bTTj2ZLiw3pv6GR+o6pAYIZcmdGGuuWYyy5iD3M=;
        b=hltvlLIU/Qi1gqWbGYf1ciFEzTfMkJNHVHcuh6iQG9tOBdYYSutHbp2IF3x/GJBDRF
         OzOBaDqQIDQix8Ku29LXdL+DFe9+rvFnEEfBF0ufShjf0zV1+WuVjwGUoVp6WUmicYZY
         EGmHsPBOKxurUHEixKbGH7v4+S3tsk93ywNkgCRmN0ovA3s40CDfe9JGW4qz0eVVcxsK
         5YD0NpFV4ih/Ug9YuXlFzvxXkqJcqdWlqAYctTeDaWgvDM5hZe1lfRkJjl9n199TtWFq
         Zz1qtJO+/tcQOfXoVzsfzjmisAi43bW0jy0iBwDV7Z4xqte/G3ZOKTvkkFu605SIWdgT
         Akhw==
X-Gm-Message-State: AOAM5333nFY7kLj6BNhMe7J390hmrBauGKbeXsZpoPb7wubjlldfLpJI
        MnCfd+LkKA0b/1WXekjI3CBZqoovGEc=
X-Google-Smtp-Source: ABdhPJybrJumyb33BIVlMdHJUvUMFUeo/qawZRYZBj5Xjwxw459zQos/0Poyu0yxAl22iuZLwVeWqA==
X-Received: by 2002:adf:e310:: with SMTP id b16mr7156793wrj.309.1634987653269;
        Sat, 23 Oct 2021 04:14:13 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5/8] io_uring: don't try io-wq polling if not supported
Date:   Sat, 23 Oct 2021 12:13:59 +0100
Message-Id: <6401256db01b88f448f15fcd241439cb76f5b940.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If an opcode doesn't support polling, just let it be executed
synchronously in iowq, otherwise it will do a nonblock attempt just to
fail in io_arm_poll_handler() and return back to blocking execution.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bff911f951ed..c6f32fcf387b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6741,9 +6741,13 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	}
 
 	if (req->flags & REQ_F_FORCE_ASYNC) {
-		needs_poll = req->file && file_can_poll(req->file);
-		if (needs_poll)
+		const struct io_op_def *def = &io_op_defs[req->opcode];
+		bool opcode_poll = def->pollin || def->pollout;
+
+		if (opcode_poll && file_can_poll(req->file)) {
+			needs_poll = true;
 			issue_flags |= IO_URING_F_NONBLOCK;
+		}
 	}
 
 	do {
-- 
2.33.1

