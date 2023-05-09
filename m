Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2DE6FCA16
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbjEIPTR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 11:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjEIPTQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 11:19:16 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B534A40CE
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 08:19:15 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-760dff4b701so37603639f.0
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 08:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683645555; x=1686237555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dgWRc5/LSrLk2Jc/BvYuBNSBxWtzvDa1580QK6qMmU=;
        b=4xi4UZAsDeZFH2vLjBFdwNzUsZtprOD9/RBP6wxtqxg2m2X0Pjlt0wGUNsQsC4YjDC
         prvSHWRI031SawHeC7XDrXt2NCWtp22mGMWbkt4ze/0RNLPQZ96qCJP54CPLe/oYA2V4
         +OeMBSOhB88waZ+p2FXolrirI5HHe0yBzxhV3nwWRR9lo8gOqDc9LXXC0VxS5WNACLTz
         bu7Ig3MeIqOObDGvZn85n+CTT6M86yMgbNblAoLWF1IceccPHnwapfS4y+tUKqP1tNHB
         HDP9nG7JtLG26waYqnPKg6JByAGiL2yYvHdkKCBOhLxXog21b0CvwGVgPq6EfL586PT1
         m/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645555; x=1686237555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dgWRc5/LSrLk2Jc/BvYuBNSBxWtzvDa1580QK6qMmU=;
        b=RBY6WTdK1XuuMC/sNL3kh5taflHYJHFqdOFShdnBsY/4aDx2TTCYBcfzO3WIhWkMOO
         CR/MMC54KK289qEbm0w6fAGj+RvMFk3RWAgxYP5MxjSY+RotCLRLtHmx5J7ppPWFqvbr
         /8qGPNMvoLs1OKO3JbF79/6DE2ZMK+bXds/v3ACK8/uHtQ7s/ZiRKHcEh8YvlOsS4OZm
         mFvtDxV2iBMBQSxvxNfjp+ImUbj6KBUhVLJSKKA+Nq1B8Ze5CGigKooeFjm33gPxY7AX
         ME2nkuGVk5xF3iO1PMgsTZKnIhWEZ/EP3HhcqGTPPCGICDiu91PPA/73PVdb0CqFSsxL
         yZgw==
X-Gm-Message-State: AC+VfDxpSDtIBQiWEDr+KNx4TQZfoEP1m0sindxqyBleMi/GaXO3UWZc
        HjxXSi5hA4jrqk0nXTIPj17AtN0hiCksLmaE3+g=
X-Google-Smtp-Source: ACHHUZ5Dj4Z1JapNi5FTM3anXVp9Zd6k/R11Xiek3v5eBUYl2hIPAtlM36jdfz24NtBjXzjui/oOSw==
X-Received: by 2002:a05:6602:2d51:b0:763:6aab:9f3e with SMTP id d17-20020a0566022d5100b007636aab9f3emr11367715iow.1.1683645554843;
        Tue, 09 May 2023 08:19:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z1-20020a056638240100b0041659b1e2afsm677390jat.14.2023.05.09.08.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:19:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 1/3] net: set FMODE_NOWAIT for sockets
Date:   Tue,  9 May 2023 09:19:08 -0600
Message-Id: <20230509151910.183637-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509151910.183637-1-axboe@kernel.dk>
References: <20230509151910.183637-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The socket read/write functions deal with O_NONBLOCK and IOCB_NOWAIT
just fine, so we can flag them as being FMODE_NOWAIT compliant. With
this, we can remove socket special casing in io_uring when checking
if a file type is sane for nonblocking IO, and it's also the defined
way to flag file types as such in the kernel.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/socket.c b/net/socket.c
index a7b4b37d86df..6861dbbfadb6 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -471,6 +471,7 @@ struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname)
 		return file;
 	}
 
+	file->f_mode |= FMODE_NOWAIT;
 	sock->file = file;
 	file->private_data = sock;
 	stream_open(SOCK_INODE(sock), file);
-- 
2.39.2

