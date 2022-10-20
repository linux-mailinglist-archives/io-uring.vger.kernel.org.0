Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F417660551E
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiJTBnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJTBnm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:43:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982421CFC78
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:43:40 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r14so27795020edc.7
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uk4Vo1LH3Y0LsC69wP89X8QzUmIOLtPnDtQx2bziQqw=;
        b=goc05PYiCXRyN5rUUAexrjU9whf9SOm60BuHlruuCRX72YUDHOZDTKxGmvfesbONqd
         9VBJJ2IvaQw5N5Q12oF8MbIP1FXNO/6zg2Qgnb2fT5KGAVWsF598OduJmAiSiI1vAaAE
         hdXfKdojebxVOMLoGEBXuiX0VyuxDT5YWpmqQsrT9+Nroomn00hbKvbR/Vk4q2GC8G8q
         oNSu4tdslEzE3Dwf0Qaj8zWzIUtQLHe4ifGZDf33jByXOkNXsOKc55OGxfe7btCwGZx5
         cJZrTtPF/riv/RJs640C10PJHwHzaHxEJyPeuFYu51Opot/8rzJJtoR5CVGCrbOsRG64
         PFVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uk4Vo1LH3Y0LsC69wP89X8QzUmIOLtPnDtQx2bziQqw=;
        b=q8jYx+PNvyTulDGC3CucJyjj08U9XMVywRmn2hl+h58Hg4ZbDGF1wnnxWzK/a984+n
         InZyU2U7DmLdcTXqI1+DCLmH1pHjw3OqQ32oCUQBdVBOZTUEO+flJpGzRT1/P3/lFaqv
         AGPGLS5OYLeZMe86Tkp7V05gj36QaHK+frpiIcahme8K3XpWCDdnQe5lM5MKn3Xag/VQ
         XRZvZiiqk9FOot60gymJc1QGe4nnZ6YcPd0o2hXMNV3RbSPzotKjKerehLRk6h3+ovZE
         6dM070e/+xpoFqJphADv+2h1wF4I6cnd+UvJZ2dpGCTHYK8RjEPA/N8rWzl5XlwSBI1F
         9MWQ==
X-Gm-Message-State: ACrzQf327RyhzajkJl7hTfxm4ub/3YeeyqvkXFIH4FrEY3ThOKrzI0sI
        EOW6XogVzx1Y5/arI50tvwBFxsSAR54=
X-Google-Smtp-Source: AMsMyM5G9QlAts1Cej4tAcMOOpr6SB4UPirIEIoHeNj5KKTEv94vhFg6fdBUshE8pjYsYkA7uwtXrw==
X-Received: by 2002:a05:6402:500d:b0:459:3e56:e6f9 with SMTP id p13-20020a056402500d00b004593e56e6f9mr10312131eda.367.1666230218750;
        Wed, 19 Oct 2022 18:43:38 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id g16-20020a170906539000b0073d5948855asm9695530ejo.1.2022.10.19.18.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:43:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.1 1/2] io_uring/net: fail zc send for unsupported protocols
Date:   Thu, 20 Oct 2022 02:42:35 +0100
Message-Id: <ee7c163db8cea65b208d327610a6a96f936c1c6f.1666229889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666229889.git.asml.silence@gmail.com>
References: <cover.1666229889.git.asml.silence@gmail.com>
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

If a protocol doesn't support zerocopy it will silently fall back to
copying. This type of behaviour has always been a source of troubles
so it's better to fail such requests instead. For now explicitly
whitelist supported protocols in io_uring, which should be turned later
into a socket flag.

Cc: <stable@vger.kernel.org> # 6.0
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8c7226b5bf41..28127f1de1f0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -120,6 +120,13 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
+static inline bool io_sock_support_zc(struct socket *sock)
+{
+	return likely(sock->sk && sk_fullsock(sock->sk) &&
+		     (sock->sk->sk_protocol == IPPROTO_TCP ||
+		      sock->sk->sk_protocol == IPPROTO_UDP));
+}
+
 static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
 						  unsigned int issue_flags)
 {
@@ -1056,6 +1063,8 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
+	if (!io_sock_support_zc(sock))
+		return -EOPNOTSUPP;
 
 	msg.msg_name = NULL;
 	msg.msg_control = NULL;
-- 
2.38.0

