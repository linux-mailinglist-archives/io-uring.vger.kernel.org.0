Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EFA527211
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbiENOf3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiENOf2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:35:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD767201AC
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n8so10541365plh.1
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ke3NsMb/k6GmJxHAaVqzEhETE1JXVl1Gx40uFduFsTM=;
        b=cjEN0irl/DPst1CLee+zIuurLTXP5xW69YpdZqiBPe/EtXm1AyxPzYjinB+P0M8UQw
         o9MbEYXDwJ7O/oFgMMnYvwIqzUO0eTfOi8odU9WyUvtx8e8v85lusIkSHdjVs/swZ28L
         CPBp5Mw3byXScHuNSImNWGNDD3GvubA4i+0o4/h7L0qYLHRu+2i7PsaG8WN4JkRbe38x
         z6ER/xf6oCrj9PgiJ0iv6U7PO2/HFR4ofqgKMXSIUWsnU1k/EsmsjpxSR/y0WkaUciu3
         TLKDr+wjRq9SmiGMwoMczavhP7jrW6Ceu9PcoRhAl3YMj+27ZINq2gCsXP7UwCNFQdWj
         taXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ke3NsMb/k6GmJxHAaVqzEhETE1JXVl1Gx40uFduFsTM=;
        b=t7B9Gilbx0O+qccvV7idGLUzQrEJLNQ0TqrGOp7KfZqD23sqfpfLLS8b48QjSanzwM
         HO62FC3oxwfx90Tm1cg4BRqX4QK8ZatGoIR4ApMbs8M87iUTeU/AMYO0vmqYbI+buUJ1
         DCep9V3Ncbz8PIvaIwUR+Wduv7SXyXvDaZ+3moESUN+FdPqCpIhIO1jLG9xFj4TNMdgr
         My0T3u8UaJw+Afb72NJYyPKmHDdFapW4vJzkFVfbuwoMfGDzWJXSI4x0xOqGT9SGqPFe
         Lv7XqfDtDeQgtpXC8c8g864V9lias0T32hJz3eMz2QnWLg4FcpZfvEUh3hZ6sNQw0VUs
         Iu1A==
X-Gm-Message-State: AOAM530ENfjn8qc3Gbcwdss/aeb3gGR7nCnjkZQ/eZx1W2435Jh424vr
        nArZceJndEt2r87+lYb8X1/9Rpy7FwdrLdL5
X-Google-Smtp-Source: ABdhPJy5OXhIeaSj+8q9Zjm4juW/K1Ni9NU47SE25ivoACiR5yWF3CyVkl4jHHfq6UX+QdAtRpCZmQ==
X-Received: by 2002:a17:902:f64c:b0:156:4349:7e9b with SMTP id m12-20020a170902f64c00b0015643497e9bmr9682964plg.139.1652538926330;
        Sat, 14 May 2022 07:35:26 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015ea95948ebsm3762179plj.134.2022.05.14.07.35.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:35:26 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6/6] man/io_uring_prep_accept.3: add man info for multishot accept
Date:   Sat, 14 May 2022 22:35:34 +0800
Message-Id: <20220514143534.59162-7-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514143534.59162-1-haoxu.linux@gmail.com>
References: <20220514143534.59162-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Add man info for multishot accept APIs, including non-direct and direct.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 man/io_uring_prep_accept.3                  | 51 +++++++++++++++++----
 man/io_uring_prep_multishot_accept.3        |  1 +
 man/io_uring_prep_multishot_accept_direct.3 |  1 +
 3 files changed, 44 insertions(+), 9 deletions(-)
 create mode 120000 man/io_uring_prep_multishot_accept.3
 create mode 120000 man/io_uring_prep_multishot_accept_direct.3

diff --git a/man/io_uring_prep_accept.3 b/man/io_uring_prep_accept.3
index 779bcd92fd2f..e52c13ee1288 100644
--- a/man/io_uring_prep_accept.3
+++ b/man/io_uring_prep_accept.3
@@ -18,11 +18,23 @@ io_uring_prep_accept  - prepare an accept request
 .BI "                          int " flags ");"
 .BI "
 .BI "void io_uring_prep_accept_direct(struct io_uring_sqe *" sqe ","
-.BI "                                int " sockfd ","
-.BI "                                struct sockaddr *" addr ","
-.BI "                                socklen_t " addrlen ","
-.BI "                                int " flags ","
-.BI "                                unsigned int " file_index ");"
+.BI "                                 int " sockfd ","
+.BI "                                 struct sockaddr *" addr ","
+.BI "                                 socklen_t " addrlen ","
+.BI "                                 int " flags ","
+.BI "                                 unsigned int " file_index ");"
+.BI "
+.BI "void io_uring_prep_multishot_accept(struct io_uring_sqe *" sqe ","
+.BI "                                    int " sockfd ","
+.BI "                                    struct sockaddr *" addr ","
+.BI "                                    socklen_t " addrlen ","
+.BI "                                    int " flags ");"
+.BI "
+.BI "void io_uring_prep_multishot_accept_direct(struct io_uring_sqe *" sqe ","
+.BI "                                           int " sockfd ","
+.BI "                                           struct sockaddr *" addr ","
+.BI "                                           socklen_t " addrlen ","
+.BI "                                           int " flags ");"
 .PP
 .SH DESCRIPTION
 .PP
@@ -72,6 +84,25 @@ CQE
 .I res
 return.
 
+For a direct descriptor accept request, the
+.I file_index
+argument can be set to
+.B IORING_FILE_INDEX_ALLOC
+In this case a free entry in io_uring file table will
+be used automatically and the file index will be returned as CQE
+.I res.
+.B -ENFILE
+is otherwise returned if there is no free entries in the io_uring file table.
+
+The multishot version accept and accept_direct perform a bit different with the
+normal ones. Users only need to issue one this kind of request to listen all
+the comming fds, each fd accepted is returned in a CQE. One thing to notice is
+io_uring_prep_multishot_accept_direct() only works in
+.B IORING_FILE_INDEX_ALLOC
+mode, which means the CQE
+.I res
+returned is a file index counted from 1 not a real fd.
+
 This function prepares an async
 .BR accept4 (2)
 request. See that man page for details.
@@ -81,12 +112,14 @@ None
 .SH ERRORS
 The CQE
 .I res
-field will contain the result of the operation. While the non-direct accept
-returns the installed file descriptor as its value, the direct accept
-returns
+field will contain the result of the operation. For singleshot accept,the
+non-direct accept returns the installed file descriptor as its value, the
+direct accept returns
 .B 0
 on success. The caller must know which direct descriptor was picked for this
-request. See the related man page for details on possible values for the
+request. For multishot accept, the non-direct accept returns the installed
+file descriptor as its value, the direct accept returns the file index used on
+success. See the related man page for details on possible values for the
 non-direct accept. Note that where synchronous system calls will return
 .B -1
 on failure and set
diff --git a/man/io_uring_prep_multishot_accept.3 b/man/io_uring_prep_multishot_accept.3
new file mode 120000
index 000000000000..0404bf59f71a
--- /dev/null
+++ b/man/io_uring_prep_multishot_accept.3
@@ -0,0 +1 @@
+io_uring_prep_accept.3
\ No newline at end of file
diff --git a/man/io_uring_prep_multishot_accept_direct.3 b/man/io_uring_prep_multishot_accept_direct.3
new file mode 120000
index 000000000000..0404bf59f71a
--- /dev/null
+++ b/man/io_uring_prep_multishot_accept_direct.3
@@ -0,0 +1 @@
+io_uring_prep_accept.3
\ No newline at end of file
-- 
2.36.0

