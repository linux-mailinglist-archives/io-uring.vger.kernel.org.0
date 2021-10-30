Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC4440A15
	for <lists+io-uring@lfdr.de>; Sat, 30 Oct 2021 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhJ3P7Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Oct 2021 11:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhJ3P7Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Oct 2021 11:59:25 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF0FC061570
        for <io-uring@vger.kernel.org>; Sat, 30 Oct 2021 08:56:54 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g11so785528pfv.7
        for <io-uring@vger.kernel.org>; Sat, 30 Oct 2021 08:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYY+dghi+I2ndR1+8MEvnw/tABsysr8Q6Qzqk9JGRNY=;
        b=SxXLSyh/wRU0puOiOqWTFDrcm9BlDDJa9idQRE2fm5tulV1pMoLvIIaspyobFm8Mz+
         kCbGpZbl0o4CE2mCB8D3W6GcTWPC09K1W/FXzTdd4/qMt8v5LF0mf4ePTZH0qXPpk2/r
         dn9NSlrYv3oKd8bI0nbG2KeIV0oqCNbw9Y2yBbi3AIwqRg4E7HxuAtiwS5YK+Px3BLes
         rpTaHZWSs6fY0BmKpks4SaEyRcV36VPgr3KIiaz+2kSjMso9it88ANf7Odb6i3TuscwO
         oYjIkQnqyySDCi/ZtfMgUnjRSXC6aejRFHeUPdl+gpJCQIRdLSLJ9jC1Ml28oOWNBOFd
         6KAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYY+dghi+I2ndR1+8MEvnw/tABsysr8Q6Qzqk9JGRNY=;
        b=IDw33lmevOl4GA8kIIEE77DEYALLLqru0lXTVw2ANM59pIJM0RxJN2l8OaJxqAaOuf
         T+W9BaCBYcNOrzfMKjeW5qld8n1d6IbkICOxReF/oV3ElfSBbHVQQkOzY9p8SPflVzRw
         Izs91bR7CsPidM5UIm8fN2HVAAjxdPUoRPu7qsurqfJ8A8r7tFGxj4VSkPScczmnH5ti
         YhLUGlXEp4UegBZFP4AFIublI2FNZ8uJc8B+GYGZ+ZYhKAMRcaIcFoHAYbAVEyporbDY
         B/LeN7tu1mOliydYKg8mhhu+XJZkKyocRcQjRbF0hDzTENiAk2jY6n5uyD0Ir/GUEHJ1
         9XPQ==
X-Gm-Message-State: AOAM530UKfIvkho56yBbwE1QojmVDtPh2GQoH/20dJjf/6Eh4oxVTS3I
        S3S8U2xON2iT1GSniG8q9ArTtQ==
X-Google-Smtp-Source: ABdhPJy1X3Jn2GjN1YITD1/12NhRKyHZ5dhN3W3u3bbhDp6sIKIyA/FLlQasS52rUobdW7NH8dQKlA==
X-Received: by 2002:a63:370c:: with SMTP id e12mr13258781pga.359.1635609414174;
        Sat, 30 Oct 2021 08:56:54 -0700 (PDT)
Received: from integral.. ([182.2.69.43])
        by smtp.gmail.com with ESMTPSA id z73sm2284818pgz.23.2021.10.30.08.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 08:56:53 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 0/2] Fixes for Makefile
Date:   Sat, 30 Oct 2021 22:55:52 +0700
Message-Id: <20211030114858.320116-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



Hi Jens,

2 patches for liburing, both fix the Makefile.

Ammar Faizi (2):
  examples/Makefile: Fix build script bug
  test/Makefile: Refactor the Makefile

 examples/Makefile |  21 ++--
 test/Makefile     | 263 +++++++++++++++-------------------------------
 2 files changed, 98 insertions(+), 186 deletions(-)

-- 
Ammar Faizi
