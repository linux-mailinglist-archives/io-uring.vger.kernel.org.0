Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6684E5B67
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 23:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbiCWWnL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 18:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240425AbiCWWnK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 18:43:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584897CB23
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 15:41:40 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so3307146pjf.1
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 15:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uUhJ05/cb+wi0vSCWraGIhfxIBINvn2YCv3QCXxjOT8=;
        b=gYYhRY7FXxz208tV1zUubewxO65D0LYotNlMedbNpXAPduiYDF6lYkpSYqj2OUninI
         qa3NedMNdpHaj0IDhKqLUi8bLu1yzUQ/qCER6DiWrHKSR61YDtFb6RMRWc5n3AlShRsC
         JTrPFoxzDRKT0agZZnp5WNL/zFy+GiBejrx1hwIt3x9OepFCppskThcpZQmtTyFY6tQa
         q2m3D9xDqlEAj2lkGiWJX9BAfd4jtU9Nh6s69EcH9O5JXXKya6362u9HFzn5kzZO+QQh
         25X7xmIzs5r+Wlk4CAFoqUa/e8U3rH3eTpxAXxgAhURSARmmQaS2Rci2qNQ5rZbSiYec
         bg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uUhJ05/cb+wi0vSCWraGIhfxIBINvn2YCv3QCXxjOT8=;
        b=KCksQikbt6xvb2Rn+oxIeoQjNf/JEeNES/dLC+tLHbEJ/Zvf9u5imbNHDYztODIhZc
         ollStHTeiLA3Ay21f0Dj1yvDre+tzQWCH1FWBCz6PX+zhC2N+VTBJ94dFj/vJpEPRBTa
         FCWL814nIjU8aua++6oiuwes6qFwTRaMfoKW0H9qMzFTLvpYE/F0wN6dfCiD1Q9utfun
         GH78uvhrueGJnThxhAttZAwZYTQHr3zSA+fXUuQ8rOe10yLW0cbixB+m13dv1EbHcjxK
         e/GNHF9iCICunSZiK5gJToYcG7pvdvF6Dtp+hUTrzTdpp++5JVTP7FSATpU2wMDs4WwA
         NarA==
X-Gm-Message-State: AOAM532cQGQXJcNMHM0LAPeYHyDzr2wMK7HUdbJ5CBjSDy/FL0vGngAb
        QKaqHIkkgeFllnGnWO7Er8FUBsdh0TCw+lqD
X-Google-Smtp-Source: ABdhPJyTzcgzjCBo5zwgiGW0L9BCoJL4uIVwvln4g+14rzFOseyodG/nJPcS4vhdhKuuyjAn5AegFg==
X-Received: by 2002:a17:90a:4890:b0:1bf:654e:e1a0 with SMTP id b16-20020a17090a489000b001bf654ee1a0mr14462054pjh.113.1648075299595;
        Wed, 23 Mar 2022 15:41:39 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a001a0500b004def10341e5sm867839pfv.22.2022.03.23.15.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:41:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com
Subject: [PATCHSET v2 0/2] Fix MSG_WAITALL for IORING_OP_RECV/RECVMSG
Date:   Wed, 23 Mar 2022 16:41:29 -0600
Message-Id: <20220323224131.370674-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

If we get a partial receive, we don't retry even if MSG_WAITALL is set.
Ensure that we retry for the remainder in that case.

The ordering of patches may look a bit odd here, but it's done this way
to make it easier to handle for the stable backport.

v2:
- Only do it for SOCK_STREAM/SOCK_SEQPACKET

-- 
Jens Axboe


