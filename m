Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84979777E1E
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 18:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbjHJQXy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Aug 2023 12:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjHJQXv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Aug 2023 12:23:51 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5FA2715
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:23:50 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3492971f72fso1705445ab.1
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691684630; x=1692289430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=kLe2/Au4YDjNdXbQEI+fcPjxiYYp/FcSGJst4kdwpME=;
        b=khf3I8PGG5ybE9HdabBVP+PehsOKRsVmxuchSkr4tBCrONpRM2XAnuNleqtHhG2fJs
         8tOhAWjZ2F0mwxVFR6cLCgaul9TBwMog12I9QgFgg+GVF5aUmui/miKyQ22gLf35wF2y
         Om1luDEL+fSWPXzYhG975/k/mGXbHHdif1roaOYnZbmvWbVSR1wjrzwf8C0HTKO89X+4
         Fi5AgxQfpueeuLhpWWkrQE/D41Dy2/oxVji7CPPREcZ9DDX0fdQNoqSYX9guFJ3CciNQ
         lPpHnNttfx5Vz7av7+MDCCEsHyC/rrO+QPYzibWA8XVoDgqs7tFTilsJLi7lOScBzKEZ
         GlmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691684630; x=1692289430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kLe2/Au4YDjNdXbQEI+fcPjxiYYp/FcSGJst4kdwpME=;
        b=aWleqRfCPD5XCGVRaoVoXZthsjmb4S65qSHHg+xMVRqQYE97HhNO0wFrlXUDkl0CGU
         KlUeUJmUrm+AgpWlX2DpOZeJpqNGeGsiFjhJupbwrLbzFi0T6k4IMX6nnYyqG3KiRNog
         8OzlqBHcGgQGbCUkBGUZ+Dm/iMOyo+UVRR33VVTq/FWvcnKAQCfYEtgItXKD0CVzW882
         IGwfambFkvemn0Fl+3osXp4f8dE343mYAbiAJRXIkzencFzII0lwa8W/yW/FLtonELIn
         bp7iyEt2PoxtlI1SGcURxqg9G2eT36dzx1zrfH3hpcoqfBK6GOR0SawTey09cX1/PeSf
         lOFQ==
X-Gm-Message-State: AOJu0Yzs8l5WwuhQGOUjE9XS80eSPtASoxXd0g+6o1h97QEGA2Vu2nW3
        I6pcPYs6moQRra8C5FKUAF2HHWuZ/GYnGIvz5u4=
X-Google-Smtp-Source: AGHT+IHxnvmCIzqr4wCU7XcaUhKm1QsqHMm1N/7bxVGJtICPmrlTWNpYqqzUj7Db9dfi8YkBN/FYtw==
X-Received: by 2002:a05:6602:3428:b0:790:c991:8467 with SMTP id n40-20020a056602342800b00790c9918467mr5645671ioz.0.1691684629928;
        Thu, 10 Aug 2023 09:23:49 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j5-20020a02cb05000000b0042ad887f705sm491941jap.143.2023.08.10.09.23.49
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:23:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH for-next 0/3] Misc cleanups
Date:   Thu, 10 Aug 2023 10:23:43 -0600
Message-Id: <20230810162346.54872-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Nothing major in here:

1) Drop fdinfo grabbing a reference to the ring, the caller has already
   grabbed a reference to the ring fd so we don't need it.

2) Cleanup around file putting.

-- 
Jens Axboe


