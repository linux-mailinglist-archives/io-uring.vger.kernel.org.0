Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80859592F1B
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 14:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbiHOMoG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 08:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242180AbiHOMoF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 08:44:05 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4FADEED
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 05:44:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j1so8968702wrw.1
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=naaqAhYoxKXyqXtvlOxXTARAFOxkC5jGnvvOGFrJSL4=;
        b=ZoFENEKMQAMgnXPz64W0eBSnCZr9q7zS6DKo+QDjYk8mVQexiiyuUhSmIn4PR0i+er
         lxG5o57TKqMyen3MYSVLy6CNN16wpCbNW43K/txMkbx70M7hn75XBwlC3QzaOhFwroJP
         8oflhoZ1rvNafhBzvu3a0jgcyPyT6XhcZyh2hUqZ3tUzG67jiaaXVb+6BKluQKVheY02
         GLpe78tF1vHWm/WpP2rVKa2Jmkj/8Jl0e+e2bPjk7nzPGqDErPMP3SKuLlYBSczFQf7r
         UtClF8fx7bn640E19J5IPGtWRnh3QbIIxbMgQHJcS4h2E3mgwhdsAOqWBJT+vJr2lM2j
         1Xhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=naaqAhYoxKXyqXtvlOxXTARAFOxkC5jGnvvOGFrJSL4=;
        b=CVnFfjmxgwZbyChwuS+D6AeCMWQhxzMy1IJyPFJB+cDM/swlThHTxYQdbyAdP/B8qv
         tOzartkAvjXI/CEXGdhRtcQo+9EdKVfXsjxf2bG/u5LAXkQ+/9lJi0Fem+JJ3L8BE02p
         IZeLx+YpTSqKIQCJvm4x2h+jSNh2gc3vWmhcGuKaxn8w4+nmVpSE7HzxP8iTYrJ5Mbsw
         PGQhKFiJ26/aIUO62khHsSU5ndiL3KOaLdDPqRDtXgORbJoZaGKvs/b9h2qqZQQW91gM
         Y8nt0Cm4R4KG1azkaQth1vGj+51pey3g1ASi2GZYYn2Ix/dekz6X6om2cH67Ogl4FnMn
         oj0Q==
X-Gm-Message-State: ACgBeo3i06GjjNSQrMGDoTZeMo+T8/GjsZ0uysLPFGBEjCe55ms9fIiA
        amYQGyaWdq2Ojyvep21xXj7UuyxhWjY=
X-Google-Smtp-Source: AA6agR5erJ+JY/6K6EqlRBk0ufAUuvpZgCMVO5wla+3rgFqiuJpz7HtaUlN7BofwAxFhywSJcy7gDg==
X-Received: by 2002:a5d:50c6:0:b0:220:7a2a:bbd1 with SMTP id f6-20020a5d50c6000000b002207a2abbd1mr8487363wrt.471.1660567442437;
        Mon, 15 Aug 2022 05:44:02 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:5fc6])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c154d00b003a54fffa809sm10296109wmg.17.2022.08.15.05.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 05:44:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-5.20 0/3] small io_uring/net fixes and uapi improvements
Date:   Mon, 15 Aug 2022 13:41:59 +0100
Message-Id: <cover.1660566179.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Just a random bunch of changes we need in 5.20

Pavel Begunkov (3):
  io_uring/net: use right helpers for async recycle
  io_uring/net: improve zc addr import error handling
  io_uring/notif: raise limit on notification slots

 io_uring/net.c   | 18 +++++++++---------
 io_uring/notif.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.37.0

