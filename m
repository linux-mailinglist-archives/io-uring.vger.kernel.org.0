Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C57CAAE3
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjJPOC5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbjJPOCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:02:37 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE380107;
        Mon, 16 Oct 2023 07:02:11 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-9b2cee40de8so933528266b.1;
        Mon, 16 Oct 2023 07:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464930; x=1698069730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0wd+OTWCVvK4oFazQDiqozW0gDG2Ec9q983374w//U=;
        b=K/mdLlO8j/3nyPlFgYDaUFfimGpKxD3k/zbnsBYrSnE5ZiwvJnypHBTP1kbVN9T9Lt
         zlJCAxIyA4kAVZJIM0B0D0/d9cH+0XrzEv9E1M+Nhq+0vdaEP7uYVnkEXGfir0qiYDHh
         +do4pqeWD9gZ8uh82n7RP6JT7d5J71nGLOAl5GVg+gBoh8rYcXaMOz1OqdZmjX3zejyM
         /vk4huSazxFpTXiRHQjVApKMyLmHXTm4X++b4TFPdZLQuR0IkbevjaTAUN0kaDoH6+wI
         IYfr9SCJrjyqHd67JDEmkghVcA9TuY4SnlVIIaACdoS3rTJyuPM4lS8kxBeDMB2tSdlE
         T3iw==
X-Gm-Message-State: AOJu0Yy6nz5S9HYPY0UUmXNYRc1u3T1hqnhR9edY28fcKfR2hTRLnfA0
        NJV0o1OdktviwYOgCe3oamHyy4DPy2U=
X-Google-Smtp-Source: AGHT+IE/t+V78wH2E5WXRhfhOr+WjqaQXREnO586qgNGleN9dM85Q3gVRiWW1xLWltrg1UooQqY//Q==
X-Received: by 2002:a17:907:318e:b0:9a5:7d34:e68a with SMTP id xe14-20020a170907318e00b009a57d34e68amr5784529ejb.28.1697464929941;
        Mon, 16 Oct 2023 07:02:09 -0700 (PDT)
Received: from localhost (fwdproxy-cln-008.fbsv.net. [2a03:2880:31ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id c16-20020a170906529000b009a1a653770bsm4101720ejm.87.2023.10.16.07.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:02:09 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v7 10/11] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
Date:   Mon, 16 Oct 2023 06:47:48 -0700
Message-Id: <20231016134750.1381153-11-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add initial support for SOCKET_URING_OP_SETSOCKOPT. This new command is
similar to setsockopt. This implementation leverages the function
do_sock_setsockopt(), which is shared with the setsockopt() system call
path.

Important to say that userspace needs to keep the pointer's memory alive
until the operation is completed. I.e, the memory could not be
deallocated before the CQE is returned to userspace.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/uring_cmd.c          | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9628d4f5daba..f1c16f817742 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -747,6 +747,7 @@ enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
+	SOCKET_URING_OP_SETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8b045830b0d9..acbc2924ecd2 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -240,6 +240,25 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 	return optlen;
 }
 
+static inline int io_uring_cmd_setsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd,
+					  unsigned int issue_flags)
+{
+	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
+	int optname, optlen, level;
+	void __user *optval;
+	sockptr_t optval_s;
+
+	optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	optname = READ_ONCE(cmd->sqe->optname);
+	optlen = READ_ONCE(cmd->sqe->optlen);
+	level = READ_ONCE(cmd->sqe->level);
+	optval_s = USER_SOCKPTR(optval);
+
+	return do_sock_setsockopt(sock, compat, level, optname, optval_s,
+				  optlen);
+}
+
 #if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
@@ -264,6 +283,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return arg;
 	case SOCKET_URING_OP_GETSOCKOPT:
 		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
+	case SOCKET_URING_OP_SETSOCKOPT:
+		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

