Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3346D1767C0
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 00:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCBXCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 18:02:55 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41755 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgCBXCz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 18:02:55 -0500
Received: by mail-ot1-f67.google.com with SMTP id v19so1069331ote.8;
        Mon, 02 Mar 2020 15:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TQJUvsCfdhXZTMuK5P/1s7YDv4YpFHdf94n7B4huL1w=;
        b=TeAa4GF1Uo6zEiC8wTfqSOdSDq+sIm2r7mCILqG9rM1RSOusW87Nsqi4KFuFyqI6vl
         L/6lC0DVayS+mWxkMhRUVIz1IQM7m47N9X5Wf0BSlohxkF+FuDUUZZuNlEsA0xy58pIW
         sUrKv9E+nU9x6wkIvrTvK/60H4W9/0TMM4y8VR0BUnmT/TnYVpB3fkr+inR+O/U4/tUe
         zspe0kB15glmsBQRwzBtjcjedPuqbP6U7mpCMGBODv8LbQrSHhsgcF6wb5M96ZpFpkvG
         NZJ14VcRepgy03TaDNOr1ggNuwqrGJS91UavFhd8UuiWEd/Cri3ZJq3qg1hg4/ltQcpk
         INkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TQJUvsCfdhXZTMuK5P/1s7YDv4YpFHdf94n7B4huL1w=;
        b=Yk3Tio7HN+7GWktpKA4Q568sZYAY1eVNVSEZCnx3DRWHO4NkuRVQP+I95Cg3H40x2Y
         Kkg/dc1egLd7yGG4RNf5BW5mzCiYLRdsJ9zK8w05YfubSpMUL2LMWOeGjXL5Ij9KvOcp
         7bNv5sT+33Xrs2fArN395lJoR4g31LO3xEf5zgtYtn6eRj2HPP7UDGK1cqk9kLAx+3pw
         fBdfS0Rq5kTAf1jAy+M5dfuaZMtK+6fkThMBqwacAZiObVbDQHxdqWz3HavXwvcbDQJj
         a9qBhtW+deWu+wpVMS3OMzt+qCMXib649KMMDjZl2lDcyXQHF0UFwAQpSdIvr2+s2mZt
         jCdw==
X-Gm-Message-State: ANhLgQ2xi3uTjXNycCFTyYjyTgLcCk8bqllTF+RAnjSCR4zvka0XWVuC
        YhKyf1FSujyIFvWo6fMVzb4=
X-Google-Smtp-Source: ADFU+vtT/VAYIDqCROuLs8VdcZOa2gBOUF2LQnnMwdX+01+Q4urmJWJJdPh+mhZ/DkVLtSS0Qo/1RQ==
X-Received: by 2002:a9d:3c1:: with SMTP id f59mr1248078otf.170.1583190174381;
        Mon, 02 Mar 2020 15:02:54 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id n9sm3317261otq.73.2020.03.02.15.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 15:02:53 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH -next] io_uring: Ensure mask is initialized in io_arm_poll_handler
Date:   Mon,  2 Mar 2020 16:01:19 -0700
Message-Id: <20200302230118.12060-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clang warns:

fs/io_uring.c:4178:6: warning: variable 'mask' is used uninitialized
whenever 'if' condition is false [-Wsometimes-uninitialized]
        if (def->pollin)
            ^~~~~~~~~~~
fs/io_uring.c:4182:2: note: uninitialized use occurs here
        mask |= POLLERR | POLLPRI;
        ^~~~
fs/io_uring.c:4178:2: note: remove the 'if' if its condition is always
true
        if (def->pollin)
        ^~~~~~~~~~~~~~~~
fs/io_uring.c:4154:15: note: initialize the variable 'mask' to silence
this warning
        __poll_t mask, ret;
                     ^
                      = 0
1 warning generated.

io_op_defs has many definitions where pollin is not set so mask indeed
might be uninitialized. Initialize it to zero and change the next
assignment to |=, in case further masks are added in the future to avoid
missing changing the assignment then.

Fixes: d7718a9d25a6 ("io_uring: use poll driven retry for files that support it")
Link: https://github.com/ClangBuiltLinux/linux/issues/916
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

I noticed that for-next has been force pushed; if you want to squash
this into the commit that it fixes (or fix it in a different way), feel
free.

 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8cdd3870cd4e..70e4624af3c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3738,8 +3738,9 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	req->apoll = apoll;
 	INIT_HLIST_NODE(&req->hash_node);
 
+	mask = 0;
 	if (def->pollin)
-		mask = POLLIN | POLLRDNORM;
+		mask |= POLLIN | POLLRDNORM;
 	if (def->pollout)
 		mask |= POLLOUT | POLLWRNORM;
 	mask |= POLLERR | POLLPRI;
-- 
2.25.1

