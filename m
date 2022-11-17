Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2550962E479
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 19:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240558AbiKQSk4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 13:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240556AbiKQSky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 13:40:54 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2C98514D
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:53 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id i21so3849880edj.10
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7ecGT9mQr+jHnGmdIZzs4uEOMKWqAb4ccxZWqPWE+Vs=;
        b=XVGSdZEKtFYNlCdimhOWXpab53hzGEkK+Ll7ahM33cSUteTNpA3mDlt30OExWsIYkn
         FwtOOBt3hUKcN6+9VgFhS8TrCnzmjvWXmYyYc3xcEXUDd1uC+lt3ExrX9bqqFgzYWcrE
         UNPLrHSaSorfbMIsyZGk85lSx5bzDnIotG7jrdK08fb3iLh/5vh2/UHyp7CDcFc+Ndah
         fFKZ6gD6S5aszYJ2Rb9AL+Km4xaoxKNzaEgIvCamdmzVGnznJD0AlXPALt7Ao8rD8zJu
         vk9VGvZRaW8xzA/TBhZ6AVehNjJo1s8UwiWLhMSd0WGLe54zJ33WOmUe+HSN/tPUZoA/
         WoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ecGT9mQr+jHnGmdIZzs4uEOMKWqAb4ccxZWqPWE+Vs=;
        b=10DIu9jIZnnABf3gVaTR3U8XQbERz94nm/o6evmSIYwiKSYV2S4yexbXOGrrwPZSep
         H0yrD1CteTJg7uE1Gp5wCuZ0oQbkamL6fOORXjjutAmWIFFyZowZ7+aAsHV11ksBKQny
         oTzkiBNSsnik/jZe2Ma4+SDBZQx/3cWIA/BcPp2z0WkPogF1BAx/slmP8V32PgMcrT3n
         OvkB6ftFUk+S6EolfqJSfq77q+iHnA07eU5Wc2j2+OBL7cdsJ7nb0GqGeMk1qu7m9CRr
         1touVAbBe+WjrFDbPDpprTn8k4Z/KjK39p7NFV/aqz/2LFBeliHG4/fWeLg+OX8ZqAn0
         GCkw==
X-Gm-Message-State: ANoB5pmmuqi8YA0lu702/7hrOKzKNMcDD10UrEaNdN2PCEIKn9Amv2qm
        2uZshbx+6TGIV2AUcoYU8paDp/O+qt0=
X-Google-Smtp-Source: AA0mqf4nNPXRMvT4ttNZw0gU8r2SdecrcH7yENG6K5cTlXNNVqNNKiQWu4AIusS2AjkjsX2O4+9WjQ==
X-Received: by 2002:aa7:cf12:0:b0:461:86b7:7627 with SMTP id a18-20020aa7cf12000000b0046186b77627mr3453851edy.180.1668710453166;
        Thu, 17 Nov 2022 10:40:53 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id kx4-20020a170907774400b007838e332d78sm685486ejc.128.2022.11.17.10.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:40:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 0/4] minor poll fixes
Date:   Thu, 17 Nov 2022 18:40:13 +0000
Message-Id: <cover.1668710222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

First two patches fix poll missing events.
3 and 4 fix leaks of multishot apoll requests.

Pavel Begunkov (4):
  io_uring: update res mask in io_poll_check_events
  io_uring: fix tw losing poll events
  io_uring: fix multishot accept request leaks
  io_uring: fix multishot recv request leaks

 include/linux/io_uring.h |  3 +++
 io_uring/io_uring.c      |  2 +-
 io_uring/io_uring.h      |  4 ++--
 io_uring/net.c           | 23 +++++++++--------------
 io_uring/poll.c          | 10 ++++++++++
 5 files changed, 25 insertions(+), 17 deletions(-)

-- 
2.38.1

