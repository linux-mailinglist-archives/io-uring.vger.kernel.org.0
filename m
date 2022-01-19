Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9681149330E
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 03:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348810AbiASCmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 21:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344650AbiASCmp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 21:42:45 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF01C061574
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:44 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id x15so960440ilc.5
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6KncxacvLekH5nRSfZksixLToBHe6z8B/+gQI4jN8dY=;
        b=tDTKIBOY3IcuX181p+DqTaUZE4MLwyJ+im0CT4VqXADfAU78IN+7YrvmAIXBCZQJHo
         M/a6Oqvd0qYg4mvIX2G0P5xJ/lQwG4FuawYW1Q62J82o2xQc43zqDugS51JPdIP7Bxef
         tq9xWHlFGeruvX3fYAtP5kNs8UZSp996IEm7GNu3AxAFU/Wquukhh8kkK9uWmpZ07QqL
         RlhfE9s+kTDa7YlQY+zcjGXix0J/EKgdlP0JwhqMGuRirBBmCNOD+H/z7eNChuf6SsAA
         qettLb2OXYsLmgynopuvmq6zRTcMazKmTwz0bSP6XL4u8GUmZY4xcnOZGxMEOW6Z5RiB
         pYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6KncxacvLekH5nRSfZksixLToBHe6z8B/+gQI4jN8dY=;
        b=mWGw8wYhPhPlqphy4CvcNd74wDxoP0jL+fSnjULN30BDrC5nHLXlSJK8G6mTWBxjE/
         slP9A/Yod8YuJBqbhfMfN0u4+X5IAt9aqwLKNmO4sSeLxp0Vkj6IceMg0nsGvFStZ1GD
         4lYZ3+ImEURHNh2aqR4zdR1OdJj33zC866ojtC8SQWRsDDUc+A47hi4n0J9rQIQdP9y6
         6lmwh/+JnOyVBIZtKv4QuUXsI0cgBfdRsregpflJuDA6/aF6c3tm5gKZ2eo5UTS30VV1
         rOWGCQKFJlnaFdV3xVBtOyj/yvdI4G0Oodfnpcm2Q42aBX2FylSbHNIGI5PLlpGZtCtX
         o13Q==
X-Gm-Message-State: AOAM531gb/DpZ5BUVVlREPNYnyS+RbxoYrwijofXN5ig9Mtulwd4R2MT
        pn56OswKouIu9FzHPsA8hr6c7IUBgXms3Q==
X-Google-Smtp-Source: ABdhPJx8Qg9e7ZpzgXDkjX/WUkyozMFn8Nl4lmPUbfvd95mHQI6PrTljJ5bY8pe4uPo2PQJakpIy5w==
X-Received: by 2002:a05:6e02:1d86:: with SMTP id h6mr15355649ila.265.1642560164011;
        Tue, 18 Jan 2022 18:42:44 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v5sm9863704ile.72.2022.01.18.18.42.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:42:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/6] Fixes for gaps in async cancelations
Date:   Tue, 18 Jan 2022 19:42:35 -0700
Message-Id: <20220119024241.609233-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Based on the report from Florian, found a few gaps in how we handle the
async work lookup and cancelations. Tried to break it down to as simple
patches as possible, and the first one is just an unrelated cleanup in
the same area that I came across. The functional bits are near the end
of the series.

-- 
Jens Axboe


