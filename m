Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F54791B7D
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbjIDQZu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353334AbjIDQZt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:25:49 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C041980;
        Mon,  4 Sep 2023 09:25:41 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-99bf3f59905so249412666b.3;
        Mon, 04 Sep 2023 09:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844740; x=1694449540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsGj/By1L5B4hMy2OQnJ6fNGd/zzZdrlVFpYroV1qv4=;
        b=JE0neR/+7jwAH5Gggc9dCrRPn1rUCcBQ5T9Qnz+YeU86pxkO4ZIXSsHrD1R/Nb44Pp
         CCikSpqdXo63g9j2GDgVvvGfemQKTDOze9v+AV3WOCtAgDwMkHJFkJnDrUb8zldMON3Z
         gbgX/NfjyNO54JlYivxzOjTYpUFLlAC6GG77oTLnkpGzyjQoKuPDAgBA1XhpVDC62otw
         JW9nloloiEDRGbBg2Pa0CCfI2st9Na5YAh9gKersREfxLZVI0UOdORxDPAIAZNlFOGJU
         jvHFFLoomcvbYiQhnDzf/+H/JzQ4AQ8tq5z7Q2ksAs1VLczfUHiKJWpxy/XbzJWCTh0v
         yoSg==
X-Gm-Message-State: AOJu0Yz2YF/d/M1nrzodvz68KWtOmEgqWeWSTl0vEWmOaQfMfRSEwDvo
        f63MJV+taiZrhysKWQy6vRgWCMj7+a3nIw==
X-Google-Smtp-Source: AGHT+IFfo76sWVv8zOKd/DWiU9bcymnJjY4Xcn4K6B71AxjNfnpZ9zBV1YlUDOHKgrT0OzO6tsam7w==
X-Received: by 2002:a17:906:76c8:b0:99b:4668:865f with SMTP id q8-20020a17090676c800b0099b4668865fmr7688934ejn.10.1693844739936;
        Mon, 04 Sep 2023 09:25:39 -0700 (PDT)
Received: from localhost (fwdproxy-cln-116.fbsv.net. [2a03:2880:31ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id f25-20020a170906495900b0099d9dee8108sm6447486ejt.149.2023.09.04.09.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:39 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v4 07/10] io_uring/cmd: return -EOPNOTSUPP if net is disabled
Date:   Mon,  4 Sep 2023 09:25:00 -0700
Message-Id: <20230904162504.1356068-8-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904162504.1356068-1-leitao@debian.org>
References: <20230904162504.1356068-1-leitao@debian.org>
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

Protect io_uring_cmd_sock() to be called if CONFIG_NET is not set. If
network is not enabled, but io_uring is, then we want to return
-EOPNOTSUPP for any possible socket operation.

This is helpful because io_uring_cmd_sock() can now call functions that
only exits if CONFIG_NET is enabled without having #ifdef CONFIG_NET
inside the function itself.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/uring_cmd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 60f843a357e0..6a91e1af7d05 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -167,6 +167,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+#if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -192,4 +193,11 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return -EOPNOTSUPP;
 	}
 }
+#else
+int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
-- 
2.34.1

