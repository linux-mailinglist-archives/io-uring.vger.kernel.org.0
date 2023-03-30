Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831986D0B5F
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 18:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjC3Qd7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 12:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjC3Qd6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 12:33:58 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14470C168
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 09:33:50 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id d22so7496199iow.12
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 09:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680194029; x=1682786029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ukPSQiglCncXT1XN3eFxdj+NedwO2RuGtgUy1jPQXt0=;
        b=4GhnTZ/nhoD3L77gujQyBVNXS03oF3CDM2T40tvrApUX8C6RAaRUvkY+Ojr6/bYQcK
         8bfs/TGvX7Rb2dM3cRLiz0WEp4xY0iZM4f4HMbha4zePqLcSXDpZ70yY7CLjnMUz+34T
         66/l8QjVHLf3K6thWBHguC8nvhpR5WxynJdhDZkjJV64aXPQE2FsLCMKN58f5VWGQGLj
         V2lzkQA0k9+eN6JxoZrtFLEW7DgjQaPAfzyol/3mg7w5E6EVoUg31QqKZgwrQyZLAaEH
         ZVsgAIbnddlWEjPoEtvyeBSsjJufL0kPLeef3cp9wSIY9tIetBJq6w9TFwkpAJNivhv+
         JNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680194029; x=1682786029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ukPSQiglCncXT1XN3eFxdj+NedwO2RuGtgUy1jPQXt0=;
        b=ZN1yVPImPkRudGa4Yh6kklzl9izQ2J9kRICPxcWnbMPewJAOMWfZoJDmjCrj1Uthm2
         wbsoBwc5e2cju+GsPp71qbAznv8guhCCCkTyOTYbwRgSQ1be5+Yk99ShO16MUscLpTgr
         o0JiJ1EEPJKKoCeo+srxA8CRHU6EHwB+gcW+8NFWBjSzS0aB+R8J6eS5xsFHFsh/ci2U
         lkajpbht3afW1tC/SIZt5OOnBmgZQ6rfB26XYlrRGEOCVFqtGSe9dwVLmm20Z4OC5Gxi
         FS6kCetLsQjw57TuhrBvloR4flJaL06lKO6Uuo7q4GLRWtd3Io8Ws+lwP9GHV4tCh+G/
         YzhQ==
X-Gm-Message-State: AO0yUKXAUh/Fp01G2W7jEAcjPVwwUQtLJYd+I2UMb+Lzhn7iY25FJeix
        DirhcFML6hECDQFyg5dtLvoN17ggphA9yKiUlfnDOw==
X-Google-Smtp-Source: AK7set/Hlz1oug9BaqNci7ncYLi4p8H0F8Ocnsg9mq1eKRQ5FXg0pjdooOb67f4/qtZqw150SF8LJg==
X-Received: by 2002:a05:6602:72c:b0:719:6a2:99d8 with SMTP id g12-20020a056602072c00b0071906a299d8mr10476862iox.0.1680194029002;
        Thu, 30 Mar 2023 09:33:49 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h21-20020a056638339500b003ff471861a4sm19099jav.90.2023.03.30.09.33.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 09:33:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Misc cleanups
Date:   Thu, 30 Mar 2023 10:33:44 -0600
Message-Id: <20230330163347.1645578-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Nothing particularly interesting in here, just a bit of code cleanup
I came across while doing other changes.

-- 
Jens Axboe


