Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED5077F9E5
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 16:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352438AbjHQO5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Aug 2023 10:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352474AbjHQO4p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Aug 2023 10:56:45 -0400
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AA2358D;
        Thu, 17 Aug 2023 07:56:28 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-99c3c8adb27so1058627066b.1;
        Thu, 17 Aug 2023 07:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692284187; x=1692888987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQ0mVRxVAzaTLmEd/HemwV6+ljHNBK9BmdpK1e4n1Fk=;
        b=HhakUhuWD8IuqO5cUkbKW+BqG/HC7D/HtZSJNr27Ku0wGEnd3vu2KNLKr/ywy3oKCH
         eR8RJD/Nq9XCGNVEIMJcz1gNlkPjv8STlLavmrKS/Vl4cUlth7fKImD/uVTtd43QARK1
         Oxm+r/aeAZ6u8wESyJMtdRJ1jd8hVQmxsp3dWodb+m8mthgCQBRRN2L4R0yBXXofy3Ad
         wIFb2roG7pE7mrsrRZtqmMPtDJrG79WYf4UqTY3YCNkCuRUqxhQBXMzyVS64XXlF65VL
         37rvGg7odpOXQulsJjksBgFNQt6iiqr4m3LwbHNJ++pZGs1g2W0FR5ylRgeuvd0cZ2qZ
         vpcw==
X-Gm-Message-State: AOJu0YxryfRWS1k02PbgLaJCUnSUSkcRcGeZtr+gae6bPi05Bsuo4dGC
        yzTS972Xw70hhyT+CTeYdNM=
X-Google-Smtp-Source: AGHT+IEsohlieh21iQeLkKanrDXE3z5P+/3xxLzQkFGsKChB+60ow3ngaXkrzdOg3/s7riUp6DU8+g==
X-Received: by 2002:a17:906:9be4:b0:99e:46b:6a58 with SMTP id de36-20020a1709069be400b0099e046b6a58mr1629764ejc.37.1692284186466;
        Thu, 17 Aug 2023 07:56:26 -0700 (PDT)
Received: from localhost (fwdproxy-cln-003.fbsv.net. [2a03:2880:31ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id a17-20020a1709062b1100b0099bd5b72d93sm10207857ejg.43.2023.08.17.07.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 07:56:26 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, krisman@suse.de
Subject: [PATCH v3 8/9] io_uring/cmd: BPF hook for getsockopt cmd
Date:   Thu, 17 Aug 2023 07:55:53 -0700
Message-Id: <20230817145554.892543-9-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230817145554.892543-1-leitao@debian.org>
References: <20230817145554.892543-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add BPF hook support for getsockopts io_uring command. So, BPF cgroups
programs can run when SOCKET_URING_OP_GETSOCKOPT command is executed
through io_uring.

This implementation follows a similar approach to what
__sys_getsockopt() does, but, using USER_SOCKPTR() for optval instead of
kernel pointer.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/uring_cmd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index a567dd32df00..9e08a14760c3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -5,6 +5,8 @@
 #include <linux/io_uring.h>
 #include <linux/security.h>
 #include <linux/nospec.h>
+#include <linux/compat.h>
+#include <linux/bpf-cgroup.h>
 
 #include <uapi/linux/io_uring.h>
 #include <uapi/asm-generic/ioctls.h>
@@ -184,17 +186,23 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 	if (err)
 		return err;
 
-	if (level == SOL_SOCKET) {
+	err = -EOPNOTSUPP;
+	if (level == SOL_SOCKET)
 		err = sk_getsockopt(sock->sk, level, optname,
 				    USER_SOCKPTR(optval),
 				    KERNEL_SOCKPTR(&optlen));
-		if (err)
-			return err;
 
+	if (!(issue_flags & IO_URING_F_COMPAT))
+		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level,
+						     optname,
+						     USER_SOCKPTR(optval),
+						     KERNEL_SOCKPTR(&optlen),
+						     optlen, err);
+
+	if (!err)
 		return optlen;
-	}
 
-	return -EOPNOTSUPP;
+	return err;
 }
 
 static inline int io_uring_cmd_setsockopt(struct socket *sock,
-- 
2.34.1

