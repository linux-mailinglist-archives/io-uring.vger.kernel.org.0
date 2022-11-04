Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB3F619528
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiKDLH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiKDLHp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:07:45 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB43817A96
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:07:44 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l11so7080572edb.4
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iS+4Tm3xUuaAm19YYKie3KnFU+/uFxBbtr+LrrCespE=;
        b=IXk3nWxl2vG4ZaIoDpMVIpYO7ypW1S04uSWeVtRkyTd28ye+GaUpsf5gi9Kv++qyy8
         74sBkA+Eb6qH/tUKM3w2pDHIgE0YPKFiFakFx5/vlLGuSkJSmRPXOBG4PG+LF2x/H5W1
         ZOdZ7cwDQpchN6cgpjSH8oR9/AB54QthNeYHyseEQu1Y0G4feZdTJ5WR2FysWtJ1zqHg
         HQlIlyK4lGveHo1pARGAXtiM8hfN67uyQ/5eeaNYFas+hh5ATKJeE0HlGJLo22qWYcBd
         zssvJSlt2++a+84w7gIwvU5TcSKhqA4xh0YK7P7FxTcgSHazO6HkdtjMtYVBeRjIYTXL
         caNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iS+4Tm3xUuaAm19YYKie3KnFU+/uFxBbtr+LrrCespE=;
        b=mCKnkj8Fvo1mxRv+tD4Gc44Jruhacgizb1xgx6QDlkhPxPIFSUg4Fe9VH9OlNGg/q8
         90biqLfbH581xaIW4fSOpZpQOpf2B5h+bDrz63UxrW7k4rOZWgZUYLNCroiwzGdxpg1i
         ft7iLMni3vxbQTKBWtyueQHilDrFOelO60ps7euCQkGes9xqzwDWZrEDuRD3ibxEOX3A
         aiM0OFN8ffF2XjcteRR1vxfx7v1PXA0OvwrQ3AGIsOA/9j5C4Mo6u9Khv16tQW8BriT1
         pVEuNj+RcbBK09p0ckWAZm1UKha3xKA9S1QHOIn/ht9Deqmz9iP4zL8a1KtAqglPmOWT
         DTbQ==
X-Gm-Message-State: ACrzQf24INinCZcacWX6Akvz6NSt6sAcklm38+bb8c7+Lsbmht3xUerh
        FXd8BhLXrwKvziunOOdiQuvtj+Ljs8Y=
X-Google-Smtp-Source: AMsMyM56zAkb3Yzek7/XIHP1MxFrIDWSOhTr2y6F1HsDEdQoTn1SzeHIg4UV/VAQXTQWEIMsyx3n0g==
X-Received: by 2002:a05:6402:298e:b0:451:129e:1b35 with SMTP id eq14-20020a056402298e00b00451129e1b35mr34673758edb.79.1667560062911;
        Fri, 04 Nov 2022 04:07:42 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id bg19-20020a170906a05300b0078df26efb7dsm1665491ejb.107.2022.11.04.04.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:07:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/3] some extra zc tests
Date:   Fri,  4 Nov 2022 11:05:50 +0000
Message-Id: <cover.1667559818.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

Pavel Begunkov (3):
  tests/zc: create a new ring for test_send_faults()
  tests/zc: add control flags tests
  tests/zc: extra verification for notif completions

 test/send-zerocopy.c | 55 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 13 deletions(-)

-- 
2.38.0

