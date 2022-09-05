Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723C35ADB29
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiIEWIT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiIEWIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:08:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABD251A0D
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:08:16 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso6377322wmb.2
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=vR4+2X/z/Zv2XLVvonQCP2Kyh5vtobI+HtIIAYhbxmM=;
        b=YtoNM5DCnsGnmC28wA7REJMTJPKq0dfupsSllR2L3WMCnrq0+OfVETZJor54C+m/VA
         Sm0cnWJcwzAa69LPwy7qU02bxaBFIPeNdt8lwLVk4hBG1+3gcls/YFRvMEJz57rwEkvV
         R1VB1pI/7WfaM5fjtEa9sEt6f7qz1F1WADD9Ah6ih54vr9YU8w2W/nl7ERrsiO+/vlK/
         hB/SHdhiXNhVPS74LWyHdbob2tuYlWkdOn8nhfBPckziIj81yma5M0+V08wnaw7Jn0Gi
         N0Y98+6BHhA/++J/8n6aEavSalEWcNZZqYq+I9ace0UAdvps9yUlJS9GaSLzNdw4Z55A
         U11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vR4+2X/z/Zv2XLVvonQCP2Kyh5vtobI+HtIIAYhbxmM=;
        b=SP1KXlRzwwU1fGPDNuxJM/3DRcW2nEN9qBZZjGmXJ6EPCoTLUb86cofcFBPPAPYtCF
         fwEbss5KDe6rdJQGxaF+7d1YGIYlZUzIhz7zycIdbfJT6e+XTlGEM2zEw01PSlBXEyb9
         YtHpnM3YHARd8dWaBW3ZAfif1w8tb/6VfXsHQZGFrXraXf+036JpqUM6B5ztSJX3eX/2
         UZTo2keM02G/KQTYafnQr8AOBm3xkf6spG6IAlVrlduDL3Lm92a3/zddIP5wlxwsRc0V
         bRaU8RqXjA8OFGX9KcGK1mRbHdrSxW++s0ClGms4j4sOHUW6W0aqgronEzD3F/IVQhC3
         LCsQ==
X-Gm-Message-State: ACgBeo0ylyJQ8UgpjXl/MUN1JinGfgudmPG+O5NyagkNhx/6Ig0AQcI+
        7IlZ4rJ+14GpBNHke87HHG/tcPsrDMY=
X-Google-Smtp-Source: AA6agR5l3N3Iiwh/KjqlnYJ7ttlnj5Ud4Ds5PEibgruF7djTxyhi0lGjzRw/HSRDV+ofNKTVfqylqw==
X-Received: by 2002:a05:600c:418a:b0:3a5:e724:21d4 with SMTP id p10-20020a05600c418a00b003a5e72421d4mr12119595wmh.168.1662415694947;
        Mon, 05 Sep 2022 15:08:14 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id z7-20020a05600c0a0700b003a5c1e916c8sm33791067wmp.1.2022.09.05.15.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 15:08:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 5/5] tests/zc: skip tcp w/ addr
Date:   Mon,  5 Sep 2022 23:06:02 +0100
Message-Id: <77860403d6fa96a9288e037ede9dcae23a4314e2.1662404421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662404421.git.asml.silence@gmail.com>
References: <cover.1662404421.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index f996f22..39c5c5d 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -390,7 +390,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (!buffers_iov[buf_flavour].iov_base)
 				continue;
-			if (tcp && cork)
+			if (tcp && (cork || addr_arg))
 				continue;
 			if (mix_register && (!cork || fixed_buf))
 				continue;
-- 
2.37.2

