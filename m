Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA5254F35F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381391AbiFQIpy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381401AbiFQIph (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:45:37 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC696A03D
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:45:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z7so5242989edm.13
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qWiOJOwfzhwIJbohxiRe+8J/U490q1scGHF6XNAx7A=;
        b=ebmFeG6DOs6Xcc6UJ88YJQG+eI49B03AwRKRwOhoMbKl6zNWds77fRXdGdHm5mNUfC
         8cm1JaBExskF/gpIxXPJKdIqp1ryc2hH4rO/AVm4qRpwmnfg85uAieehdlk7+uA5pWKy
         ppQ5Bc/gnENlL9fDQhM5LkqNWA4VkP4iecmnmC4ZBJu2SiYOk87eIaQtvMlCnwrP3Llg
         e8hZxiZNr9yS8BXiAJOv0LdSTyHwfxGxCGX45bflckEPUHPjDucroCQlGgVXeaUq4kIJ
         pAylOoWMQ9pgQLOthWDsH1WMFHvUmgGGl/BGEP0B1dku/OZruPa41m2e/ZAcloZdS+i9
         jiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qWiOJOwfzhwIJbohxiRe+8J/U490q1scGHF6XNAx7A=;
        b=kZsoSzXqVO7NRacAinry9asVuLz7NO4oGmkv18CC2mH5ZjQ1hDEX5uJux9ZAnOkbqf
         oFcM9GkKCTibqPMyubSle6HfVKxdjvB8aiamuwwExJz/V1yA+8jValMFuLyVUQJniviq
         FvK0ZonpNou6rG7qUucT8bSVb5mdqY3CQkuU866qHrbynqTYguoHNQm9TMuUUrg/QvcB
         sxWtu28nc/rkksb8FrAiRfJfATZc6KjPucsbHV+/I0NrNDagWjbb7mzvC/pUCyVufjhG
         B9R7fVf540Jk/hLAnCd5ib229a2lZnoyVJlTt7sMOuAJ5qiIZqjCXlQ804VUt/1O4wNd
         z0MA==
X-Gm-Message-State: AJIora+Z+JQLYpkFZaRgxdE2iBTB9+AYWGbxBtoZUUKyj9v/8khBRU7q
        kmZwSAGSQB9kHId7wWmH2Q2+kqvR2oXhWA==
X-Google-Smtp-Source: AGRyM1tiVLbpf7EXQjxd8ppdN8kL5RCfff+BKaw7MgYtFFEeyeYnl/PoKljbyZZwGWYlE6ckgVUIDw==
X-Received: by 2002:a05:6402:368a:b0:42d:ef42:f727 with SMTP id ej10-20020a056402368a00b0042def42f727mr11173115edb.204.1655455524763;
        Fri, 17 Jun 2022 01:45:24 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id ot21-20020a170906ccd500b006f3ef214e0esm1844106ejb.116.2022.06.17.01.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:45:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/2] use nop CQE32 tests to test some assumptions
Date:   Fri, 17 Jun 2022 09:42:40 +0100
Message-Id: <cover.1655455225.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

Pavel Begunkov (2):
  Revert "test/nop: kill cqe32 test code"
  tests: fix and improve nop tests

 test/nop.c | 54 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 13 deletions(-)

-- 
2.36.1

