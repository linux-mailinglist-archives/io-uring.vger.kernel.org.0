Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FF179ECDC
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 17:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjIMP2o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 11:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjIMP2i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 11:28:38 -0400
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7BC1BE9;
        Wed, 13 Sep 2023 08:28:33 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-502b0d23f28so6812681e87.2;
        Wed, 13 Sep 2023 08:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694618912; x=1695223712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rF5iM8ZkJqphGmjRFU1s0SbK7ImZ/Xg4gUBQOimY8QI=;
        b=i6HhVNKpabsOIC2vJKOGy/osVxXwPvIZ/0kg4nRvpeW7rlqSCb1WtpJvR0lMM09S17
         J8HcNioLp2n4DbmP/s0PE+Cx37xLFQnqsGTt1q5oV+0tjQhOUnO2s2g4YpDqr0hcZpVV
         +wmiSyFHqRk7c/FXKqZ9/7odXustALINmGb73P30w0ZsdZwdZClnRaeqlh045jqSqYNJ
         P3h8eSIEfmfPOedoXjUZ6fCEau/tQETJjAY2+BgBFCdjibIpPxcTmXIEwWLLfxh9NUfo
         myMzxPlTF/YHEq1UnJuzKhkuwVGZf/dBtk85RChMXTsJOEiWtS+Lrh8mEBGe+f+W2ELg
         JcXA==
X-Gm-Message-State: AOJu0Yy1OmCJGvkJJiddeQWIz0PrJy5qLdOPyI3QzvaFOlcNkez8eFY5
        rEWUHMNu7+aLuEEsWmHwWXQ=
X-Google-Smtp-Source: AGHT+IFeaXyIkMgF9AuqjzrWL2PW3mVfMdv3z6auaM6K/CEvS2+FXH/TE2OedM1zhhL7jlvLu+syIA==
X-Received: by 2002:a19:2d08:0:b0:4fe:1681:9378 with SMTP id k8-20020a192d08000000b004fe16819378mr2448500lfj.66.1694618912053;
        Wed, 13 Sep 2023 08:28:32 -0700 (PDT)
Received: from localhost (fwdproxy-cln-001.fbsv.net. [2a03:2880:31ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id kj27-20020a170907765b00b0099b5a71b0bfsm8705015ejc.94.2023.09.13.08.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 08:28:31 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v6 5/8] io_uring/cmd: return -EOPNOTSUPP if net is disabled
Date:   Wed, 13 Sep 2023 08:27:41 -0700
Message-Id: <20230913152744.2333228-6-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230913152744.2333228-1-leitao@debian.org>
References: <20230913152744.2333228-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 io_uring/uring_cmd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 60f843a357e0..5753c3611b74 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -167,6 +167,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+#if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -193,3 +194,4 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
+#endif
-- 
2.34.1

