Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1968774597
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 20:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjHHSnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 14:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbjHHSnX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 14:43:23 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AEB47E2;
        Tue,  8 Aug 2023 09:37:48 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-99bc9e3cbf1so7259366b.0;
        Tue, 08 Aug 2023 09:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691512580; x=1692117380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkmTv84pMJXYa4K1dNGjk/Yamo7BduW6q6khqHXBPa8=;
        b=Dd8Vgwj0UHNXYwynWoCRfMASq4JLeZpNRyD/tDC9/ATD1zoHWUD7ZBnS7KIY4WDcfK
         ft9+HC6Im3yySuN5IA5x2mBmsJHnSVZ1PXbqb+ovN4ly171nyV0dASxLtRo3/nlwXxDo
         aLK1oV5PIlsIJs2UrdsvJjI7JFwh3NrDn54tIZ3w0s3CkR0cC0e71kaoBOGXWS8pJA0W
         nEmzli7l0wxxb4cN1N2BC61xsSM+p2tbs2xTwZyKuS7hTuFdRVGBsWeUl3I7NzhFcLoR
         ZEoZ8LhZxB+pGH0RTFuHz9iTIkCjkS5MgAOof+PL6lB2JUE8uTccbwHO/zc5G23VX2UL
         RJVg==
X-Gm-Message-State: AOJu0Yx4C50amqYS9gt0/ZdikrVwIQtBhmV0KIH8JFMRFOWB81RRqczP
        dTuNCJmSONEKBPOItM+Xhm94RIj+iFA=
X-Google-Smtp-Source: AGHT+IFCb2xDaXaWa86RAvY8VGrjOIB1tiZauK4N/+kpq0thYV6NlgElKwksutrFFgGq6zVtrt/YmA==
X-Received: by 2002:a17:906:53ce:b0:99c:7300:94b8 with SMTP id p14-20020a17090653ce00b0099c730094b8mr10749291ejo.10.1691502074057;
        Tue, 08 Aug 2023 06:41:14 -0700 (PDT)
Received: from localhost (fwdproxy-cln-116.fbsv.net. [2a03:2880:31ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id qh17-20020a170906ecb100b0099cc1ffd8f5sm4484910ejb.53.2023.08.08.06.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 06:41:13 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v2 8/8] io_uring/cmd: BPF hook for setsockopt cmd
Date:   Tue,  8 Aug 2023 06:40:48 -0700
Message-Id: <20230808134049.1407498-9-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808134049.1407498-1-leitao@debian.org>
References: <20230808134049.1407498-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for BPF hooks for io_uring setsockopts command.

This implementation follows a similar approach to what
__sys_setsockopt() does, but, operates only on kernel memory instead of
user memory (which is also possible, but not preferred since the kernel
memory is already available)

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/uring_cmd.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 3693e5779229..b7b27e4dbddd 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -205,23 +205,42 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
 {
 	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
 	int optname = READ_ONCE(cmd->sqe->optname);
+	sockptr_t optval_s = USER_SOCKPTR(optval);
 	int optlen = READ_ONCE(cmd->sqe->optlen);
 	int level = READ_ONCE(cmd->sqe->level);
+	char *kernel_optval = NULL;
 	int err;
 
 	err = security_socket_setsockopt(sock, level, optname);
 	if (err)
 		return err;
 
+	if (!in_compat_syscall()) {
+		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level,
+						     &optname,
+						     USER_SOCKPTR(optval),
+						     &optlen,
+						     &kernel_optval);
+		if (err < 0)
+			return err;
+		if (err > 0)
+			return 0;
+
+		/* Replace optval by the one returned by BPF */
+		if (kernel_optval)
+			optval_s = KERNEL_SOCKPTR(kernel_optval);
+	}
+
 	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
 		err = sock_setsockopt(sock, level, optname,
-				      USER_SOCKPTR(optval), optlen);
+				      optval_s, optlen);
 	else if (unlikely(!sock->ops->setsockopt))
 		err = -EOPNOTSUPP;
 	else
 		err = sock->ops->setsockopt(sock, level, optname,
-					    USER_SOCKPTR(koptval), optlen);
+					    optval_s, optlen);
 
+	kfree(kernel_optval);
 	return err;
 }
 
-- 
2.34.1

