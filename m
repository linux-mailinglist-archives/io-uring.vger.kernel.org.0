Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE745EB5F2
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 01:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiIZXqC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 19:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiIZXqB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 19:46:01 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F6A8A1DB
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:46:00 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id s14so12596470wro.0
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MWf2JMcAHHBE1hwpwhCIJnSpqlaA9N7ZdDzYoRDa2V8=;
        b=F0ojKyqsFjDiYqrP2HC8I6XDEI6O4kh4PpbmjtbZa9KwjbE6kewS7y7G0rsPvzE4nq
         pkq+YY/lGtWRkMJQjXq3Rsw9rIZamdw+eQu7K4kBjUJND+4J5eqvoALTYWsunLPv948/
         ZUKjphMpnItUv8cPyEMzN1J0OxswX6z/TsBUJzRfBwkGqaIu4tdOkohBz6E1rjzZoG2N
         tQfGRnWokpz4KXBagm8XBWVMxlR+kUtyhvIWhq/p+tNj9aDCC8MPdzJZYm/cM0kAqKH/
         oeV1XFieNv6ByP0OOcr9BV0h5feNJgMykZ2p8vZfoJ/ppZl+TxIR8JVwfljCWR3T8OWO
         7R9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MWf2JMcAHHBE1hwpwhCIJnSpqlaA9N7ZdDzYoRDa2V8=;
        b=kjl8TcDfMQ26khH6uIGiUjwoJU3FMDNTPp7WNacjH8I5SJlMMNZ8NjPaqyPYzHewFn
         KtBlHLt7FeJditQ2+EVbtiYiV+h6+HRFSC4Pm4lJ2PSpFThoTkDzPvzHwCCBpqhrzBJo
         uybQA7CO6ejLy0U4d/p96I6rt4MpJQPMDoSuddfjj/m9+hHxB3wQLkKpZaA8nRm42D99
         ttXq2OPEXWWll5S6ypmP0iHFE0lX1qKoBHpRbWnBSk+k/tLLUOc/+lBIyqNNFbumpPfk
         2pYWLUhgNbxx9om7qiKFSwGzYg9mgjnpfQ9IBEEuwZT0WBXwn9O4IKTK9jQzlDko53/S
         jThw==
X-Gm-Message-State: ACrzQf0xWLmEq1LXWxrJKBCoFeO6b9t81Kbfuzj7Tyt9nlrCW0VacHAY
        lyEEw08b5SoSxI9x6vVcdwzlZrC2beg=
X-Google-Smtp-Source: AMsMyM4E0Cy/giQZuPVUBC7W49rnOBujZhuKzudh7DDCbd0Unz+QLjCSlLtHFbj3DtJQbSKsQn6hRw==
X-Received: by 2002:a5d:64c2:0:b0:228:cb3e:1ce with SMTP id f2-20020a5d64c2000000b00228cb3e01cemr14900352wri.392.1664235958942;
        Mon, 26 Sep 2022 16:45:58 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id l16-20020a05600012d000b0022abd7d57b1sm89318wrx.115.2022.09.26.16.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:45:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Beld Zhang <beldzhang@gmail.com>
Subject: [PATCH for-next v2 1/2] io_uring/rw: fix unexpected link breakage
Date:   Tue, 27 Sep 2022 00:44:39 +0100
Message-Id: <3a1088440c7be98e5800267af922a67da0ef9f13.1664235732.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664235732.git.asml.silence@gmail.com>
References: <cover.1664235732.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->cqe.res is set in io_read() to the amount of bytes left to be done,
which is used to figure out whether to fail a read or not. However,
io_read() may do another without returning, and we stash the previous
value into ->bytes_done but forget to update cqe.res. Then we ask a read
to do strictly less than cqe.res but expect the return to be exactly
cqe.res.

Fix the bug by updating cqe.res for retries.

Cc: stable@vger.kernel.org
Reported-and-Tested-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 59c92a4616b8..ed14322aadb9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -793,6 +793,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		}
 
+		req->cqe.res = iov_iter_count(&s->iter);
 		/*
 		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
 		 * we get -EIOCBQUEUED, then we'll get a notification when the
-- 
2.37.2

