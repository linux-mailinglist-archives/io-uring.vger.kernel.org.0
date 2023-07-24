Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BBD75F9C3
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 16:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjGXOYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 10:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjGXOYF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 10:24:05 -0400
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D959AE63;
        Mon, 24 Jul 2023 07:23:54 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-4fdea55743eso3230709e87.2;
        Mon, 24 Jul 2023 07:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690208633; x=1690813433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uNsYJZWwOrHCH/sJVncer8wWx/Kh/edw84SCouspcyA=;
        b=e/xBohH/50oRB6zrqoVZWgRo172FH873dB9JgE5Nk7U7KEdHAL6FXr9Rw26k/QJWeO
         hjVCJTfNP7AkUKw2cC4JEJevlWa2VK0/IyJm9gnc9sa6KUAHvQ5bjgrPh2xYaAzSZuyM
         0uJIVREtHdi/5Z5W5oUAyDhPHfOFHc4Mixod2eeXZrh1F33NdDYvEI77ZVxIqjhiThXe
         XPO5KUc6WOk96Ya396c+S4crlwv2HBmP8xLVkgJ4VA9aGpXrZffhDVJCKkGPkga3oJJO
         gciSroK0SPuiupcKe6bmrzql0rdjfhpH1Th2+3ukTapKYy2qd+NSt7xw+CDI0HgZMVya
         ZMUA==
X-Gm-Message-State: ABy/qLbiKk6wOxEwrj8fCgeHr615fFVwBveqS74CUDvma8b6TjIAkXRJ
        dhzwqS2wa+BM3Gb2CvzfPNA=
X-Google-Smtp-Source: APBJJlFobzJA49V7cwHizW7uFZQNLEpem4kXaOWLNY5A888apHAKbRYlYNS9/vSwePZA5UXZ6aCE6w==
X-Received: by 2002:a05:6512:4002:b0:4fb:89cd:9616 with SMTP id br2-20020a056512400200b004fb89cd9616mr6091098lfb.0.1690208632870;
        Mon, 24 Jul 2023 07:23:52 -0700 (PDT)
Received: from localhost (fwdproxy-cln-006.fbsv.net. [2a03:2880:31ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id ba28-20020a0564021adc00b0051e2670d599sm6313052edb.4.2023.07.24.07.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 07:23:52 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org, leit@meta.com
Subject: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Date:   Mon, 24 Jul 2023 07:22:35 -0700
Message-Id: <20230724142237.358769-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230724142237.358769-1-leitao@debian.org>
References: <20230724142237.358769-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
where a sockptr_t is either userspace or kernel space, and handled as
such.

Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().

Differently from the getsockopt(2), the optlen field is not a userspace
pointers. In getsockopt(2), userspace provides optlen pointer, which is
overwritten by the kernel.  In this implementation, userspace passes a
u32, and the new value is returned in cqe->res. I.e., optlen is not a
pointer.

Important to say that userspace needs to keep the pointer alive until
the CQE is completed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  7 ++++++
 io_uring/uring_cmd.c          | 43 +++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9fc7195f25df..8152151080db 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -43,6 +43,10 @@ struct io_uring_sqe {
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
 		__u64	splice_off_in;
+		struct {
+			__u32	level;
+			__u32	optname;
+		};
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
@@ -79,6 +83,7 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	optlen;
 		struct {
 			__u16	addr_len;
 			__u16	__pad3[1];
@@ -89,6 +94,7 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -729,6 +735,7 @@ struct io_uring_recvmsg_out {
 enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
+	SOCKET_URING_OP_GETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8e7a03c1b20e..16c857cbf3b0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -166,6 +166,47 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+static inline int io_uring_cmd_getsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	int optname = READ_ONCE(cmd->sqe->optname);
+	int optlen = READ_ONCE(cmd->sqe->optlen);
+	int level = READ_ONCE(cmd->sqe->level);
+	void *koptval;
+	int err;
+
+	err = security_socket_getsockopt(sock, level, optname);
+	if (err)
+		return err;
+
+	koptval = kmalloc(optlen, GFP_KERNEL);
+	if (!koptval)
+		return -ENOMEM;
+
+	err = copy_from_user(koptval, optval, optlen);
+	if (err)
+		goto fail;
+
+	err = -EOPNOTSUPP;
+	if (level == SOL_SOCKET) {
+		err = sk_getsockopt(sock->sk, level, optname,
+				    KERNEL_SOCKPTR(koptval),
+				    KERNEL_SOCKPTR(&optlen));
+		if (err)
+			goto fail;
+	}
+
+	err = copy_to_user(optval, koptval, optlen);
+
+fail:
+	kfree(koptval);
+	if (err)
+		return err;
+	else
+		return optlen;
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -187,6 +228,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		if (ret)
 			return ret;
 		return arg;
+	case SOCKET_URING_OP_GETSOCKOPT:
+		return io_uring_cmd_getsockopt(sock, cmd);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

