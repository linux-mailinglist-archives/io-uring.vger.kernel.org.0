Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7E41A2EC4
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 07:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgDIFTJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 01:19:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35284 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgDIFTJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 01:19:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id g3so10422949wrx.2;
        Wed, 08 Apr 2020 22:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uSC39yWXfhJXkC8zUepIWQwvmgUUPBBJLFDU4bzKkpQ=;
        b=o5WIwXuZFOq1RA0LEFWaQ7za8Af33EPFCI2sfVg7e7YzQRB5RsBXB+8O6T+oVbrBpM
         n4gZjlZrDrsY4zos6QdUQAruaKWGJ+w5UGGFGwOG1nYS21WfjQ6Y4999Cj1p0Pk6SnxI
         4awQP0sjrITaA8jDsz0h6hOyu6Z6GurwbZl44GdKd2j7P9cT6DEpvQTrBDVUVNsnnxBX
         J2vkilXOP9RtjA8egMCS0lgazf/bbVB3+/dAL7U6Py6DuOyQSrjr7hiSrDlM0ZGbTe4q
         wkNTmHoAVABfdv63uxSmTJBqsxvNq7XMQiB0jngL+wTnu2InNf0Z47Su0cYooTstlobq
         bmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uSC39yWXfhJXkC8zUepIWQwvmgUUPBBJLFDU4bzKkpQ=;
        b=jVdgmlo4JXRyRDWTrou0orNQVkg3k6pv+Wkv1ZbcV0s/A7edENmddce4wnV+88eLyg
         5II02nSo9Fdxur1LZft0Tsl7jtjo1kNPPY74SXcZTmfCwE2m7sg/JqXw6qQN2l/nTirT
         eJtTj5NL8juqG8pF1KYJ2CRI5KEDU3sZkW0YTiq+iVPb06n9haBAH4dAkiTpAUrNNZbm
         rrqoxNkhRA+bJ/BSRWHSy2V2x5AKZoQvrj5uAKH0KnMUbt/A2jmsRdeHbqCfnbhMCrUz
         o51pFY5TvzgpGy+jXvcGoEZsQALhq09DovJ34rwuRQKgTjuNtYPdZ7/Rw4Z4a9JEQjnO
         Stpg==
X-Gm-Message-State: AGi0PuaXbVi6AzLY40wgqh4OlnA0zIGj0ICc4unRZmh4x9panNbMMKGH
        GDeUngLDzvXbStE8DEwP/KeH+wXu
X-Google-Smtp-Source: APiQypJxKuNMkASgyk6loARWy+tTolgmYLS8K8yzWmQqVpcH3RvwBniTJdBRqmxHmX/DSKmyfXt0Bg==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr2088365wrv.419.1586409546958;
        Wed, 08 Apr 2020 22:19:06 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id h81sm2395073wme.42.2020.04.08.22.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 22:19:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix fs cleanup on cqe overflow
Date:   Thu,  9 Apr 2020 08:17:59 +0300
Message-Id: <72e624af63743f265e25da90c322bd45b9d4feeb.1586409373.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If completion queue overflow happened, __io_cqring_fill_event() will
update req->cflags, which is in a union with req->work and happend to
be aliased to req->work.fs. Following io_free_req() ->
io_req_work_drop_env() may get a bunch of different problems (miscount
fs->users, segfault, etc) on cleaning @fs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

P.S. never tried to reproduce the issue

 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 21e1c69b9c43..be65eda059ac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -608,6 +608,7 @@ struct io_kiocb {
 	};
 
 	struct io_async_ctx		*io;
+	int				cflags;
 	bool				needs_fixed_file;
 	u8				opcode;
 
@@ -638,7 +639,6 @@ struct io_kiocb {
 			struct callback_head	task_work;
 			struct hlist_node	hash_node;
 			struct async_poll	*apoll;
-			int			cflags;
 		};
 		struct io_wq_work	work;
 	};
-- 
2.24.0

