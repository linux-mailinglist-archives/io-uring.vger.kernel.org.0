Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0574510E8B
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 04:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356736AbiD0BxY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 21:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343798AbiD0BxX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 21:53:23 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E57120A1
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:50:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x12so313493pgj.7
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iaov2gdKL6IjHqrTf6+khZFbb0WzClx3r2F6Pmi3RUM=;
        b=lY+HVUlZi9CFq1sPHIIpPYyowMGh1oWOP7Rg8e09KB4s2HoECMiaxwUUl7iq44Y0Jv
         A3uuBUpfycys/iNM9QZA74HvGtCSYo81+qgXZGluZvJdQYtfObp0EeCjTWYiDlcWC22I
         MEaoKuBnufridJabyOsjpOnbk7LKJVax8hni+B+q40E92OAWDWYjOhMFhajfWzgENSip
         wW2BslEk56pkNEptZ1XjyUJQGYi0YlVuJrxFGuD/bgnUcUQfJ8uiWF2yfOXt9/KWbOSt
         VXZmQXKgTzuphJOe21e1bWZ6ViB3CoDDZcXBp1QQ2Ib02njriZiqlzmGeHnZEWC/j3YR
         p9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iaov2gdKL6IjHqrTf6+khZFbb0WzClx3r2F6Pmi3RUM=;
        b=JPB66s6v6RDlNXShfNKLwTkgNl5FzyBA6KUC/Rrvnx946L3G42lgVUvh+jfUcRL31p
         kkzH1d/5UhBaXAZ4jyTY9ZBHp9coZRcYkdGmTH2s52TgVdNCXL+aSwIC+5p30KdLNUQ9
         cEqbL2usdFX3hGAXXowFFF0O7J/Jqy8ZNh/mDua1ws8DMoIuZBaAHSkwpzUtVCDWzJrg
         QtA6AQKxhoqf78kzMsXpcJktXt0G060s7WVsYN8eo194CByCpIYqjbbYM2EolexSLIGR
         0b6vZrRKo4dzyn8zbKyhkt51LNQhZZ6WfCJ9Hmq2lzG1azB4Xfbo8VtiYPZQOeNzRx1o
         MWuQ==
X-Gm-Message-State: AOAM531+bdorAI0JrWdcwXq6ywS9banDW1ZCjJ/tlWbK1fxqGLrXhYeC
        OvoX5sOw9yYl4KohNEbUFU6HrYAYqUm3Qbva
X-Google-Smtp-Source: ABdhPJzr1vead2SlLXSZnE6odk8/Dc7AoLH2yTjlzRC1tCPSWO/yJZRYuJb3Tr+XSuwQd3chwLmVjg==
X-Received: by 2002:aa7:8385:0:b0:4f6:ef47:e943 with SMTP id u5-20020aa78385000000b004f6ef47e943mr27780146pfm.38.1651024209638;
        Tue, 26 Apr 2022 18:50:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090a734200b001cd4989febcsm4554547pjs.8.2022.04.26.18.50.08
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:50:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH 0/2] Check reserved flags for send/recv
Date:   Tue, 26 Apr 2022 19:50:05 -0600
Message-Id: <20220427015007.321603-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

For some reason we don't check reserved fields for send/sendmsg and
recv/recvmsg. We don't use them either, but we should check and -EINVAL
if they are set.

-- 
Jens Axboe


