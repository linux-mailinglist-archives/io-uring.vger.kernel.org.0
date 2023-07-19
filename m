Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5623759304
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 12:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjGSK33 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 06:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjGSK3R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 06:29:17 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED59A1BDC;
        Wed, 19 Jul 2023 03:28:42 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-4fb9ae4cef6so11139788e87.3;
        Wed, 19 Jul 2023 03:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689762480; x=1692354480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4XUMOf5v4z2uwMw/EOS++l6o91vWfvUqdVme/BSedQ=;
        b=d+meDbA1AG2AppxzWprtgd/ccVuXUnY/ujzGhYSs6ks2W6FFiyb2Ks9QUppDpKh9y/
         11JLb+5gF6foaHLDyK6yV4hw9TXuPp+gQ+OkdxN3bfuMgQJkAR/v+qPU8BqDwcpxzcte
         0HQQswkv1HkQCRZw5LoqKSWkYBu1URIopR4Fk5m0eDNgteu41FoV9n6be4eFYhjLwj4A
         ZH7cQ7Q1x2jl5gGVxKyzQmVCIcSOzftfl4XsDBtNCDsz/et642KujKIxU8ZxKFCpxnRY
         sq5ePNfi2wUxNZaHfpI7v3niJV8+tJfjybNclzGJGYer15q8HMAOlsA6aktKbJKUKn4n
         ZLLA==
X-Gm-Message-State: ABy/qLYvML/X0rIpC5r4hv6FRgQiTfPEgFDWIcermVC1LCY80REOcUDx
        DDHrtirSj4WDv/GD1wUSi0A=
X-Google-Smtp-Source: APBJJlGyf9xcUaSS0Y1iW+/VJfm1IrDdU0RCzsjCwQZyBzexggn3dz8bfwvtgyqjHFVWVSuy9QaU3g==
X-Received: by 2002:a05:6512:a8d:b0:4f9:5426:6622 with SMTP id m13-20020a0565120a8d00b004f954266622mr13413608lfu.69.1689762479710;
        Wed, 19 Jul 2023 03:27:59 -0700 (PDT)
Received: from localhost (fwdproxy-cln-000.fbsv.net. [2a03:2880:31ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id x15-20020a05600c21cf00b003fbbe41fd78sm1380429wmj.10.2023.07.19.03.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 03:27:59 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] io_uring/cmd: Add support for set_sockopt
Date:   Wed, 19 Jul 2023 03:27:37 -0700
Message-Id: <20230719102737.2513246-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230719102737.2513246-1-leitao@debian.org>
References: <20230719102737.2513246-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add initial support for setsockopt for SOL_SOCKET level, by leveraging
the sockptr infrastructure.

Function io_uring_cmd_setsockopt is inspired by the function
__sys_setsockopt(), which handles the system call case.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/uring_cmd.c          | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8152151080db..3fe82df06abf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -736,6 +736,7 @@ enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
+	SOCKET_URING_OP_SETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 28fd09351be7..7c06634e744a 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -191,6 +191,28 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 	return -EOPNOTSUPP;
 }
 
+static inline int io_uring_cmd_setsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	int optlen = READ_ONCE(cmd->sqe->optlen);
+	int optname = READ_ONCE(cmd->sqe->optname);
+	int level = READ_ONCE(cmd->sqe->level);
+	int err;
+
+	err = security_socket_setsockopt(sock, level, optname);
+	if (err)
+		return err;
+
+	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock)) {
+		err = sock_setsockopt(sock, level, optname,
+				      USER_SOCKPTR(optval), optlen);
+		return err;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -214,6 +236,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return arg;
 	case SOCKET_URING_OP_GETSOCKOPT:
 		return io_uring_cmd_getsockopt(sock, cmd);
+	case SOCKET_URING_OP_SETSOCKOPT:
+		return io_uring_cmd_setsockopt(sock, cmd);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

