Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B14E556EEB
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 01:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237412AbiFVXQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 19:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357288AbiFVXQQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 19:16:16 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DBF41F9D
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 16:16:15 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id t21so11161610pfq.1
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 16:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Zt2sGkcxJ+Tca7Md7YrxFmRtUgQqjRlBo78xSd7XpQ=;
        b=jlDVfFqpFLlB8bbHYJI5Q5KOQ1FjDs1+na5KU2chZtGtA15//K+5iJNgQWgMevfs/3
         RRuJKePn5HrKPMOqA6mjehfbMkGAQyHbg60/1dWjCA09ghJBlq/3Cpcfx7hrmM5JIbRh
         nTYxy2y+lFNmCVofY4mWmGt0OGifVjbvE/mjGG/dDt34b8PqYPt2QHcjujj5y7BZweW6
         zkwvCcdOJoiIqhaxynryZGEvNJaJSU5Fo7SbMpVsvuYWTATA3wpDZPkGstZnA6tcGqeN
         zLz0UcgZiJ87Wl2GAS/6Q63QmQZQ9riv6WkUujSwQr5HSs0Mq+UPvU2IB5xYPRYjwLEA
         aF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Zt2sGkcxJ+Tca7Md7YrxFmRtUgQqjRlBo78xSd7XpQ=;
        b=V6lpg7mxwYY9I57v70OrPRjv1oFofIhRMfDnjAJpElnEwZJExF+0StZykie9Rbxqde
         k/UjBn3ORtJQrEIAIAykoXqLcBJD22WPv8RWAGeFdVmB8Mc3IyEySQkfNpViuajwFrog
         A56KV5el4Xt1IKggVYnscddWdKW7z7gLvmrclEvHdom/HYPKPxOtXE+oKIOKTO578etf
         DWcJeZQLZhfsOvrQInx8UhGADdpuloQdQTtp4d23rol0tNn/xHV/Q3EZKQDED8q/QW/h
         oRIBP6sU4t/nDAKkVcJb3y5If7RGA7q1UXhUjr27y/LjePTj1RcR8xy93wV2DE+khy6W
         Z8mQ==
X-Gm-Message-State: AJIora81lcZkZPRG1qAg4cG7iVL2gGCYAhVyOuBy5ceZGuuyysh5IB35
        xhmfRoGNG1yZEKzvt0ukhZkqoHSCESeleQ==
X-Google-Smtp-Source: AGRyM1twIIIWEI2jkG0U8lDfSL74ZasHEWtg0iRVz7hXbNt5mT/5n56/PmrtDVcwdfM5+Jxa6RWOBQ==
X-Received: by 2002:a63:6cc4:0:b0:408:b022:8222 with SMTP id h187-20020a636cc4000000b00408b0228222mr4891282pgc.435.1655939774741;
        Wed, 22 Jun 2022 16:16:14 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2-20020a056a00198200b0051b9ecb53e6sm13947437pfl.105.2022.06.22.16.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 16:16:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, carter.li@eoitek.com, hao.xu@linux.dev
Subject: [PATCHSET v3] Add direct descriptor ring passing
Date:   Wed, 22 Jun 2022 17:16:09 -0600
Message-Id: <20220622231611.178300-1-axboe@kernel.dk>
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

Hi,

One of the things we currently cannot do with direct descriptors is pass
it to another application or ring. This adds support for doing so, through
the IORING_OP_MSG_RING ring-to-ring messaging opcode.

Changes since v2:
- Add flag for controlling whether to post a CQE to the target ring or
  not.

-- 
Jens Axboe


