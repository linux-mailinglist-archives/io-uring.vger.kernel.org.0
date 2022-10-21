Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B61607808
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 15:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiJUNOq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 09:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiJUNNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 09:13:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B77826D93E
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 06:13:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n12so4717820wrp.10
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 06:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qD/HUVeBVaV7ueHpbiwfPiA2/CzRwAefzoKoFoTpIMU=;
        b=Iz1jFHzRNSZThyn/ZNMrsDVqu0NE0CNSpt2Ohk4HkLXcwOYgfGT8zxnXU0Uum8ffaO
         u4k4MAGSA0oXBtECDHKVs+hnPXv2JvmLwSLb0yByFXQTLjsi4SCNmnCJHGHw9lVPIcnP
         9ehufmdh3/HshlxWEq5yDfHTUO6wW8AHB08rpdgiotgFKZmonqjbZdEm2meIc8Fnd+r2
         MJUk7SJXuyjt26fg57KzbwnpiprQ86Uk115TfC1ypzx7Ac8DFXp+NoB6m96zqcwsYrWt
         z5Sas2CHwexC5YR6KlqiUhgPx3zt/4X65EFd6/ll3KuZTTi2+fBQlsQWtAGrurDnjswX
         BNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qD/HUVeBVaV7ueHpbiwfPiA2/CzRwAefzoKoFoTpIMU=;
        b=Ey40SZ/M+MzQMxJpIQpEvo/dVRZ2sXd+KccaLEWpRnyDK9ApxWXOLVrb2m++Kzs/iP
         bau8hJhGK37TOMjTo/YqayWhIC5ddvu6zcI70/ugMqBu6VCJ+iLsmYRvChWTi97WT9Ys
         ox1pCKyrPg761n4UXHq1TTJQLMU0PL7I2bLmtLIrJ3YoO1SAL3XBBF7uzPqmPcs+4mBB
         lp4os4xFQwruHE+X4dVvFWU0NCMf9x351xcnsm0MHHtd77Q42atYByd26AxSptgpwKYr
         YOrqChFdtPXlUwDMqQc1O+kDCHdGCm4oBWbBZp2vnrKz62ATfCifiTkzyv+HUOvmZbQF
         li/g==
X-Gm-Message-State: ACrzQf1n0COrupp5BwuHK2Wvx0QXM9TZki+ipywAWZX60HVa8aUNlP18
        ZlaPCVmStdpoVqW6R2Oi/1GhgOoHYgk=
X-Google-Smtp-Source: AMsMyM7OUClqeu72gtdkoSYttvmYmzfDZvWIZNyzmJLrYzGMbMPV0a9bntGBj5fjRj0YxXEhKNe1qg==
X-Received: by 2002:adf:fc8b:0:b0:234:d624:cb7 with SMTP id g11-20020adffc8b000000b00234d6240cb7mr7425160wrr.412.1666357988562;
        Fri, 21 Oct 2022 06:13:08 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id n4-20020adf8b04000000b00231893bfdc7sm20739442wra.2.2022.10.21.06.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 06:13:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/3] io_uring_enter.2: document IORING_RECVSEND_POLL_FIRST
Date:   Fri, 21 Oct 2022 14:10:59 +0100
Message-Id: <46c7ba19248dd732241651da54bdcdee5f988d20.1666357688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666357688.git.asml.silence@gmail.com>
References: <cover.1666357688.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2 | 85 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 25fdc1e..d98ae59 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -394,12 +394,46 @@ holds the flags associated with the system call. See also
 .BR sendmsg (2)
 for the general description of the related system call. Available since 5.3.
 
+This command also supports the following modifiers in
+.I ioprio:
+
+.PP
+.in +12
+.B IORING_RECVSEND_POLL_FIRST
+If set, io_uring will assume the socket is currently full and attempting to
+send data will be unsuccessful. For this case, io_uring will arm internal
+poll and trigger a send of the data when there is enough space available.
+This initial send attempt can be wasteful for the case where the socket
+is expected to be full, setting this flag will bypass the initial send
+attempt and go straight to arming poll. If poll does indicate that data can
+be sent, the operation will proceed.
+.EE
+.in
+.PP
+
 .TP
 .B IORING_OP_RECVMSG
 Works just like IORING_OP_SENDMSG, except for
 .BR recvmsg(2)
 instead. See the description of IORING_OP_SENDMSG. Available since 5.3.
 
+This command also supports the following modifiers in
+.I ioprio:
+
+.PP
+.in +12
+.B IORING_RECVSEND_POLL_FIRST
+If set, io_uring will assume the socket is currently empty and attempting to
+receive data will be unsuccessful. For this case, io_uring will arm internal
+poll and trigger a receive of the data when the socket has data to be read.
+This initial receive attempt can be wasteful for the case where the socket
+is expected to be empty, setting this flag will bypass the initial receive
+attempt and go straight to arming poll. If poll does indicate that data is
+ready to be received, the operation will proceed.
+.EE
+.in
+.PP
+
 .TP
 .B IORING_OP_SEND
 Issue the equivalent of a
@@ -416,12 +450,46 @@ holds the flags associated with the system call. See also
 .BR send(2)
 for the general description of the related system call. Available since 5.6.
 
+This command also supports the following modifiers in
+.I ioprio:
+
+.PP
+.in +12
+.B IORING_RECVSEND_POLL_FIRST
+If set, io_uring will assume the socket is currently full and attempting to
+send data will be unsuccessful. For this case, io_uring will arm internal
+poll and trigger a send of the data when there is enough space available.
+This initial send attempt can be wasteful for the case where the socket
+is expected to be full, setting this flag will bypass the initial send
+attempt and go straight to arming poll. If poll does indicate that data can
+be sent, the operation will proceed.
+.EE
+.in
+.PP
+
 .TP
 .B IORING_OP_RECV
 Works just like IORING_OP_SEND, except for
 .BR recv(2)
 instead. See the description of IORING_OP_SEND. Available since 5.6.
 
+This command also supports the following modifiers in
+.I ioprio:
+
+.PP
+.in +12
+.B IORING_RECVSEND_POLL_FIRST
+If set, io_uring will assume the socket is currently empty and attempting to
+receive data will be unsuccessful. For this case, io_uring will arm internal
+poll and trigger a receive of the data when the socket has data to be read.
+This initial receive attempt can be wasteful for the case where the socket
+is expected to be empty, setting this flag will bypass the initial receive
+attempt and go straight to arming poll. If poll does indicate that data is
+ready to be received, the operation will proceed.
+.EE
+.in
+.PP
+
 .TP
 .B IORING_OP_TIMEOUT
 This command will register a timeout operation. The
@@ -1150,6 +1218,23 @@ system call equivalent.
 
 Available since 6.0.
 
+This command also supports the following modifiers in
+.I ioprio:
+
+.PP
+.in +12
+.B IORING_RECVSEND_POLL_FIRST
+If set, io_uring will assume the socket is currently full and attempting to
+send data will be unsuccessful. For this case, io_uring will arm internal
+poll and trigger a send of the data when there is enough space available.
+This initial send attempt can be wasteful for the case where the socket
+is expected to be full, setting this flag will bypass the initial send
+attempt and go straight to arming poll. If poll does indicate that data can
+be sent, the operation will proceed.
+.EE
+.in
+.PP
+
 .PP
 The
 .I flags
-- 
2.38.0

