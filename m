Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B039C5AE536
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 12:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbiIFKU6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 06:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238972AbiIFKUu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 06:20:50 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CFF2FFEE
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 03:20:49 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m1so14475243edb.7
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 03:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=647HhNEsHvh7PjDVOQ4idDM8nRUHSCH9+wszZhQKSM4=;
        b=onz6WoYCOM3uUY3T7bAukS3PgdMez13rtIAXCPUdOUmzGnCd/BFFfq+x4aTeY0Nxfj
         PBOvtAZ3ZoeBdBQ944dzZQt+5Y9VSBVJRE5VjgvsFngNV7qFTU1Q41T+2CxcCsYXLqdh
         AQstcrt8VhjKD9A4/Ej6+02yiSKOSuiUxamm0cVM9J3bS8CXFJKvjFVpXxhkjOGABSLB
         V1d65Myp7nXNMk/Y1fxAbEQTCMZtjb4I4nZdwi9PlmdlYh1xaCCv0nUCajVbafb0WSqx
         f9JAbyPMtDbi7rbnZPpgknWEI28Qa1pJQLGw03fL2LXPmvYTKIWMtzshIxrjZr++K2Yo
         Aihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=647HhNEsHvh7PjDVOQ4idDM8nRUHSCH9+wszZhQKSM4=;
        b=vpNPdKKvDHj7YeMBgRBA9cuVYzCqJ+LsgqlPUeN6YJ32LaK8HZQN/Xn1D44Szp92Nf
         msCUODsz/pna1nt0tXQzHrqtvAaN2zxtKI0fjiEABz8dzsndBQREfGUfO4Vypk7Ox1rT
         G95hwVoZ3KmO8u9z9Ml6AM1pgX6zU1/7i4mUvILiXOLRTrLDt7ws7XmOdbQdx/yyPxgh
         G3rnkaE6IEDMPIoRZeNIpgXX6g3gDqT0vsNHtt8ToFbvR0y35ucQURUqfBjvdFDw0vsw
         c4IGu8prA53mI1DlN1wWsdbFOnhlKbNaRYDAn4F9UFr9MNr+v6LA9og3VP/KlkcdCxs7
         iUZg==
X-Gm-Message-State: ACgBeo1lexAjoLsscZF9xqPD5FIwXwcmxNY6Dj6e4qPNsLFE6DkTz1pJ
        5ynClY42Yqtu8E04h3Uxqz3CVGGUlJE=
X-Google-Smtp-Source: AA6agR7BgQEiLVZ/dKxv0vFWRJwRjBc0tpQg/hr4pDtayezNOsNz7CaYyRSt90AtEQ1o5NvjxfdQeg==
X-Received: by 2002:a05:6402:2937:b0:44e:b578:6fdd with SMTP id ee55-20020a056402293700b0044eb5786fddmr4370721edb.159.1662459647106;
        Tue, 06 Sep 2022 03:20:47 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:20b2])
        by smtp.gmail.com with ESMTPSA id 12-20020a170906318c00b0073923a68974sm6194302ejy.206.2022.09.06.03.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 03:20:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2] man/io_uring_enter.2: document IORING_OP_SEND_ZC
Date:   Tue,  6 Sep 2022 11:17:19 +0100
Message-Id: <e876fa3c0de9d45db41a796eb8ac547e298a8787.1662459139.git.asml.silence@gmail.com>
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

Pasting a text-only version right below for convenience.

Issue the zerocopy equivalent of a send(2) system call. It's similar to
IORING_OP_SEND but tries to avoid making intermediate copies of data.
Zerocopy execution is not guaranteed and it may fall back to copying.

The flags field of the first struct io_uring_cqe may likely contain
IORING_CQE_F_MORE, which means that there will be a second completion
event, a.k.a. notification, with the user_data field set to  the  same
value, and  the user must not modify the buffer until the notification
is posted. The first cqe follows the usual rules and so its res field
will contain the number of bytes sent or a negative error code. The
notification's res field will be set to zero and the flags field will
contain IORING_CQE_F_NOTIF. The two step model is needed because the
kernel may hold on to buffers for a long time, e.g. waiting for a TCP
ACK, and having a separate  cqe  for request completions allows the
userspace to push more data without extra delays. Note, notifications
are only responsible for controlling the buffers lifetime and don't
tell anything about whether the data has atually been sent out or
received by the other end.

fd must be set to the socket file descriptor, addr must contain a
pointer to the buffer, len denotes the length of the buffer to send,
and msg_flags holds the flags associated with the system call. When
addr2 is non-zero it points to the address of the target with addr_len
specifying its size, turning the request into a sendto(2) system call
equivalent.

Available since 6.0.


 man/io_uring_enter.2 | 47 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 1a9311e..a93e949 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1059,6 +1059,53 @@ value being passed in. This request type can be used to either just wake or
 interrupt anyone waiting for completions on the target ring, or it can be used
 to pass messages via the two fields. Available since 5.18.
 
+.TP
+.B IORING_OP_SEND_ZC
+Issue the zerocopy equivalent of a
+.BR send(2)
+system call. It's similar to IORING_OP_SEND but tries to avoid making
+intermediate copies of data. Zerocopy execution is not guaranteed and it may
+fall back to copying.
+
+The
+.I flags
+field of the first
+.I "struct io_uring_cqe"
+may likely contain IORING_CQE_F_MORE, which means that there will be a second
+completion event, a.k.a. notification, with the
+.I user_data
+field set to the same value, and the user must not modify the buffer until the
+notification is posted. The first cqe follows the usual rules and so its
+.I res
+field will contain the number of bytes sent or a negative error code. The
+notification's
+.I res
+field will be set to zero and the
+.I flags
+field will contain IORING_CQE_F_NOTIF. The two step model is needed because
+the kernel may hold on to buffers for a long time, e.g. waiting for a TCP ACK,
+and having a separate cqe for request completions allows the userspace to push
+more data without extra delays. Note, notifications are only responsible for
+controlling the buffers lifetime and don't tell anything about whether the data
+has atually been sent out or received by the other end.
+
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
+Available since 6.0.
+
 .PP
 The
 .I flags
-- 
2.37.2

