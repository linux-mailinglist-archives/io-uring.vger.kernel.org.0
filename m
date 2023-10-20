Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F52A7D10A1
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 15:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377376AbjJTNjh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 09:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377401AbjJTNjh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 09:39:37 -0400
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAFB1BF
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:35 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-9b6559cbd74so128083566b.1
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697809173; x=1698413973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZmIgf8orud72D6ZziTFbUOmUuDgSQtB73Fv85A+5OI=;
        b=GAWIejMEZtXKVILn8QjswOTblP6aKvcTxI3SzTndbb2HAAvu0dWy0TLoGCvJMwZDoB
         lD4ugPH3CwpRryBh7+YKkE9mWR2T8xjq4Xz3vSkDIrMp1jq4lLom4RyjXZEY9+WmTq2p
         kUcsvbWF2G89o/TqPV94DWWNFtRLv/JS1MNpEJXSXKwsKuXJi/ZtwKRarykTXuqfmmqy
         mFVtAR7LPdV8qG0/zYVoph7RUax/4c9Y6xw+FkvuYOKXLbXxVRYEOi39yaZCLmrbRuqf
         YRBy/AIfNftzn7yhhYSqEv3TkDr/ya+oEfgxrecOhwC8/K98+YVjuo9er4blHFpeptPO
         1czA==
X-Gm-Message-State: AOJu0YwxHkYkHAFjAv+oLzs6J9UC2tfKgyEZARtl/hOVfGCPH9ALzWSu
        gaGv+Pef46FsS0ZuNbAcuUk=
X-Google-Smtp-Source: AGHT+IHPiF3+57Qs5OJ5jbUiz7tWTOvwgz4t6dQqcFsuKroYbp0ZwngQFE4COj51iNIKa12RMvWO9Q==
X-Received: by 2002:a17:907:25c3:b0:9bf:32c8:30ff with SMTP id ae3-20020a17090725c300b009bf32c830ffmr1418843ejc.25.1697809173413;
        Fri, 20 Oct 2023 06:39:33 -0700 (PDT)
Received: from localhost (fwdproxy-cln-010.fbsv.net. [2a03:2880:31ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id 26-20020a170906011a00b009ae587ce128sm1498970eje.216.2023.10.20.06.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 06:39:32 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 5/5] man/io_uring_prep_cmd: Add the new sockopt commands
Date:   Fri, 20 Oct 2023 06:39:17 -0700
Message-Id: <20231020133917.953642-6-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020133917.953642-1-leitao@debian.org>
References: <20231020133917.953642-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring now supports getsockopt and setsockopt socket commands.
Document these two new commands in the io_uring_prep_cmd man page.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 man/io_uring_prep_cmd.3 | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/man/io_uring_prep_cmd.3 b/man/io_uring_prep_cmd.3
index d6ec909..12f607e 100644
--- a/man/io_uring_prep_cmd.3
+++ b/man/io_uring_prep_cmd.3
@@ -72,6 +72,38 @@ Negative return value means an error.
 For more information about this command, please check
 .BR unix(7).
 
+.TP
+.B SOCKET_URING_OP_GETSOCKOPT
+Command to get options for the socket referred to by the socket file descriptor
+.I fd.
+The arguments are similar to the
+.BR getsockopt(2)
+system call.
+
+The
+.BR SOCKET_URING_OP_GETSOCKOPT
+command is limited to
+.BR SOL_SOCKET
+.I level.
+
+Differently from the
+.BR getsockopt(2)
+system call, the updated
+.I optlen
+value is returned in the CQE
+.I res
+field, on success. On failure, the CQE
+.I res
+contains a negative error number.
+
+.TP
+.B SOCKET_URING_OP_SETSOCKOPT
+Command to set options for the socket referred to by the socket file descriptor
+.I fd.
+The arguments are similar to the
+.BR setsockopt(2)
+system call.
+
 .SH NOTES
 The memory block pointed by
 .I optval
-- 
2.34.1

