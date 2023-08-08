Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3747747A0
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 21:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjHHTRc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 15:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbjHHTQX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 15:16:23 -0400
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61302F839C;
        Tue,  8 Aug 2023 09:39:15 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-4fe48d0ab0fso9142016e87.1;
        Tue, 08 Aug 2023 09:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691512724; x=1692117524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1FImuotzzVQ6nA+cw3aWKU2TeJBwRAYe/LnZXkkaFw=;
        b=EkCA40kxooti6uJfoNlssQSr4NVwrGflalP+OqK6jMNA3ijjWS+eZs4M6eyBQVVYyI
         P3kHuvn9LiAnPomnRuO7ZHip+S52gzRIikunEID3OL7n7HeIdUT5PhF4xsmZ2oRinjvf
         hI9EDM5uZ10nKb5k70YeyEcWgKGdYOqMwJWqYWa6MPUnDk8e85F1A74l1R4jl6+I0Loj
         bsza1vqK10MbxmFz0x56knIi3keDR+l1SS98hIerkHxa27MgvqqWxnw8z51imILB3cOy
         e4hdzFvoGcN9QFehT/WvdSMqGVYKQckTSmdtAz7S91690wrq3TmUCCrrVAhqmGaDDRZW
         yOEA==
X-Gm-Message-State: AOJu0Yxl9tj8oc6OXXvZgkWKC0MKrNfxqj53h9M+IjPt/ox4OyBb8DX/
        LNnmSJHzDprRO/nUSjbjiN6TPpNHYjo=
X-Google-Smtp-Source: AGHT+IFbk39aiWdQs43VmDbGnkeQcAnhXwYUlno2wMsVnKErCw/KqJgXvGi+kwIrhmeCXX2f4IKflA==
X-Received: by 2002:a2e:3307:0:b0:2b6:fe3c:c3c1 with SMTP id d7-20020a2e3307000000b002b6fe3cc3c1mr9358880ljc.4.1691502072628;
        Tue, 08 Aug 2023 06:41:12 -0700 (PDT)
Received: from localhost (fwdproxy-cln-003.fbsv.net. [2a03:2880:31ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906284f00b00992e265495csm6650549ejc.212.2023.08.08.06.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 06:41:12 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v2 7/8] io_uring/cmd: BPF hook for getsockopt cmd
Date:   Tue,  8 Aug 2023 06:40:47 -0700
Message-Id: <20230808134049.1407498-8-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808134049.1407498-1-leitao@debian.org>
References: <20230808134049.1407498-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add BPF hooks support for getsockopts io_uring command. So, bpf cgroups
programs can run when SOCKET_URING_OP_GETSOCKOPT command is called.

This implementation follows a similar approach to what
__sys_getsockopt() does, but, using USER_SOCKPTR() for optval instead of
kernel pointer.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/uring_cmd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index dbba005a7290..3693e5779229 100644
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
@@ -179,17 +181,23 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
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
 
+	if (!in_compat_syscall())
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

