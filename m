Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187117CAADE
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjJPOCt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjJPOCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:02:37 -0400
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328891A2;
        Mon, 16 Oct 2023 07:02:10 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-9be02fcf268so411309466b.3;
        Mon, 16 Oct 2023 07:02:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464928; x=1698069728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GoPtknS6OIlEb2FwqHC7u4ghwC0fruWw/wSEYWNl/e0=;
        b=qbnHvy/K/XgTwfjLl6LWrZvq/MtRRmxUfgHP0hgjCXfNTAHJfhjGq9Oz+T1dVSEY4w
         4geTeq1Yca3Qmt46qalBij4pnLiwcrhjdSRnWSqt4cV76LHgBtXsDYV5uAjWi/dxoOVR
         RCeZOtGGw4bfrU/Rr0lPFotmesFItUuT3XhTAsrsGEFZaYaI+8JsO2nTtbajxe7hIAFk
         WN3RSJ8LtDL5oT7sjeTqMr2z0/S1jlJC46dfRdhWFXQff2YApa0++RlDNfNVzsypw2K+
         hiYaZ6p1FagU6BYVQg7OA5Nhu/AVLgHy1yZPCcXuKt3MJmvf2EfwF2Ny8GPrIpZz7L9z
         vJCw==
X-Gm-Message-State: AOJu0YwOUYLZ2XwittgQ+22g6dH/DRPyyiqp0a8hXbf+oPm8BRaoQGQ7
        KIZpPaTUVQRNgWD/FYCsNqI=
X-Google-Smtp-Source: AGHT+IF5vzM1NqZ0WpxDbsBqtuU9dNFJF+Awb8uzQopHZd+JsoW4kOcSpZ+J6oiV/juHhfAfdsoyOA==
X-Received: by 2002:a17:906:32db:b0:9ba:2d67:a450 with SMTP id k27-20020a17090632db00b009ba2d67a450mr18844084ejk.40.1697464925891;
        Mon, 16 Oct 2023 07:02:05 -0700 (PDT)
Received: from localhost (fwdproxy-cln-008.fbsv.net. [2a03:2880:31ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id jl24-20020a17090775d800b009b94c545678sm4119594ejc.153.2023.10.16.07.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:02:05 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v7 09/11] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Date:   Mon, 16 Oct 2023 06:47:47 -0700
Message-Id: <20231016134750.1381153-10-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
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

Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
where a sockptr_t is either userspace or kernel space, and handled as
such.

Differently from the getsockopt(2), the optlen field is not a userspace
pointers. In getsockopt(2), userspace provides optlen pointer, which is
overwritten by the kernel.  In this implementation, userspace passes a
u32, and the new value is returned in cqe->res. I.e., optlen is not a
pointer.

Important to say that userspace needs to keep the pointer alive until
the CQE is completed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  7 +++++++
 io_uring/uring_cmd.c          | 28 ++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92be89a871fc..9628d4f5daba 100644
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
@@ -81,6 +85,7 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	optlen;
 		struct {
 			__u16	addr_len;
 			__u16	__pad3[1];
@@ -91,6 +96,7 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -740,6 +746,7 @@ struct io_uring_recvmsg_out {
 enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
+	SOCKET_URING_OP_GETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 42694c07d8fd..8b045830b0d9 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -214,6 +214,32 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+static inline int io_uring_cmd_getsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd,
+					  unsigned int issue_flags)
+{
+	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
+	int optlen, optname, level, err;
+	void __user *optval;
+
+	level = READ_ONCE(cmd->sqe->level);
+	if (level != SOL_SOCKET)
+		return -EOPNOTSUPP;
+
+	optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	optname = READ_ONCE(cmd->sqe->optname);
+	optlen = READ_ONCE(cmd->sqe->optlen);
+
+	err = do_sock_getsockopt(sock, compat, level, optname,
+				 USER_SOCKPTR(optval),
+				 KERNEL_SOCKPTR(&optlen));
+	if (err)
+		return err;
+
+	/* On success, return optlen */
+	return optlen;
+}
+
 #if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
@@ -236,6 +262,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		if (ret)
 			return ret;
 		return arg;
+	case SOCKET_URING_OP_GETSOCKOPT:
+		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

