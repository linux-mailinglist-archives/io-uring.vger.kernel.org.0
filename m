Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAD25ADB36
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiIEWLr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIEWLq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:11:46 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8F265250
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:11:45 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qh18so19399115ejb.7
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=26C3+QnfV7rFtDBcdAIcFfDEviGlCChpaa0aRU3uUK4=;
        b=dT2eFKULMMzllGOnD9PGo8wNC6IsTodjNACxeguJQP6NxtGYun3OO/QVayskjzHu/5
         64SlSg+tG6e97QvRQXXSJvI10SNyf91K8AGlwZClFkVRf57oWlBajZNS9lT9TCZxq5JD
         8sUP94bm7fkArGF/ntRQvMNkva9CGZ0qkdK1oaeiUuPfweAD8hbf6zrH0dxwfUN/iYwL
         IjN050vJI4hwdh/G1SnlxAoa0M2yVNa+bsDwXXVB8qGD/LC4sChVFi/8yoE8cgjsLiW+
         RcuOkXyCpttIlxdRBb1FZvbZX7bDnPNVMnTxbFZKxE8ZW4oYnqEtIQ+1OMHZyiDw1woy
         46Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=26C3+QnfV7rFtDBcdAIcFfDEviGlCChpaa0aRU3uUK4=;
        b=Yi22aAyVhj3EbfOlCRjPVEVIjtGIvMsgX01eU+lVDnd8N+yWZ9HmgEwDqLvK4WbTuG
         JgO2BmAa+2TtkUe4OfOi6kTY/pfgLJ0S7sZy7j1HdjtjbW20eo5Jz3bkss5EeZrENOvg
         lqH9TB9iyEoCy68v8U3ajUwDE+zTMCjuMnesE5l3xKmpD316hVr818eadJ8RHAdG2NxT
         vtPsO+bkYW38Jeoq4/4BJEwGEBJbhcq8Bv8+MBiarLollWOgRMes2kb0xIDJvWR5aKtX
         SF0k2OyqYBmS6rsOTyiNRuWF3xWNpUTfu/Dno/rsoNCB9b2PLVpWLPssJuGg4bf/LV+q
         6kTw==
X-Gm-Message-State: ACgBeo1f6WfzssnwXqnFWEGql+pZpRk0S3AyYytNj5+LO3B6VEdxVVcp
        a6flXTuQfeSoMCBR9UaYqs7WwGf8Gzs=
X-Google-Smtp-Source: AA6agR4XIO2MLyt76uI2j/dr44qsJF8ix59KjW4GymvtYVBjycvt+4oOldW5Kdtq9h1LFWHQb8Vj7w==
X-Received: by 2002:a17:907:30ca:b0:750:c6f7:45e1 with SMTP id vl10-20020a17090730ca00b00750c6f745e1mr11737754ejb.357.1662415903554;
        Mon, 05 Sep 2022 15:11:43 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906218100b0073a644ef803sm5615017eju.101.2022.09.05.15.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 15:11:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing] man/io_uring_enter.2: document IORING_OP_SEND_ZC
Date:   Mon,  5 Sep 2022 23:09:24 +0100
Message-Id: <b56a06f431ea01d125627d4fd95d712e5d72a51c.1662415676.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Doc writing is not my strongest side, comments are welcome.

 man/io_uring_enter.2 | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 1a9311e..7fd275c 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1059,6 +1059,50 @@ value being passed in. This request type can be used to either just wake or
 interrupt anyone waiting for completions on the target ring, or it can be used
 to pass messages via the two fields. Available since 5.18.
 
+.TP
+.B IORING_OP_SEND_ZC
+Issue the zerocopy equivalent of a
+.BR send(2)
+system call. It's similar to IORING_OP_SEND, but when the
+.I flags
+field of the
+.I "struct io_uring_cqe"
+contains IORING_CQE_F_MORE, the userspace should expect a second cqe, a.k.a.
+notification, and until then it should not modify data in the buffer. The
+notification will have the same
+.I user_data
+as the first one and its
+.I flags
+field will contain the
+.I IORING_CQE_F_NOTIF
+flag. It's guaranteed that IORING_CQE_F_MORE is set IFF the result is
+non-negative.
+.I fd
+must be set to the socket file descriptor,
+.I addr
+must contain a pointer to the buffer,
+.I len
+denotes the length of the buffer to send, and
+.I msg_flags
+holds the flags associated with the system call. When
+.I addr2
+is non-zero it points to the address of the target with
+.I addr_len
+specifying its size, turning the request into a
+.BR sendto(2)
+system call equivalent.
+
+.B IORING_OP_SEND_ZC
+tries to avoid making intermediate data copies but still may fall back to
+copying. Furthermore, zerocopy is not always faster, especially when the
+per-request payload size is small. The two completion model is needed because
+the kernel might hold on to buffers for a long time, e.g. waiting for a TCP ACK,
+and having a separate cqe for request completions allows the userspace to push
+more data without extra delays. Note, notifications don't guarantee that the
+data has been or will ever be received by the other endpoint.
+
+Available since 5.20.
+
 .PP
 The
 .I flags
-- 
2.37.2

