Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD31266A0B
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 23:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgIKV2c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 17:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgIKV2b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 17:28:31 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE031C061573
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 14:28:30 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k13so1473433plk.3
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 14:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QK8th+KrUL1jfU7oQEo7lIy9kQCc4lZudYDjRnKR60E=;
        b=FhN9xgLakL1zFpOe2Qp9299D9njYE8mEjxAIFOOECRKvFI06YL5aiPgj1fN0nr64tM
         4pBWq/a2unqfjEJ0A958p8+G3B9pU5Io3UKX/br1HDJsE6tOiFQ9sYl2dUm9tcNuu3Pn
         KLyE1I0/t8J6GrWweNpHbTElsn+JY5GWJLZnqVtR5M4eSSXrXeKxhyJ3+gIldsOF2VBt
         6fqBHZBkXGNkbR95uOnh9u8RP4N9+adeKWYSGBsoxYX5/1Bm5weix7pHZeCI3ZW0ChG6
         mqIfmk66dGmFUCpGxgeyp053BooMgTUog+Bh5cMPjZrk8TJidS72iQuzuCuy54agi07j
         xQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QK8th+KrUL1jfU7oQEo7lIy9kQCc4lZudYDjRnKR60E=;
        b=TAJJ8XHO46178+YB/oXe+wwSqRTxe2Xw389uXyKyjWDAwEH8K5Xkgr4PyD2rxTB8V8
         psxE4GeivqCHQt9MyBxQaRJklE0OByq5fiJ/6Y1acy46qWtfLcK5tMJ25ghm45e/PHp2
         BC3w3ApsSaAsf5zcZWgdgCjXvOY2bTahS3D0Oz27zE+dc29E6XkWzrspa1bMV7I8L09a
         UYy/v2iPJ9L76gRew2K/YGkN+Pp/2dx1irDa3LDz8ftCFC44SLWJxyoBvP9T1MfO+T37
         gfR3mMT/C6Z3rG3j3K4Ciof2OUvE0UgKtSly/a1I5sJGU7baJhZ+4PPXwwtrUuKnMUL+
         z1fQ==
X-Gm-Message-State: AOAM531KxjZ3JiOn8RPK7xDqcXUV8DQSJRiwi6ml9BcQ5mi3oRrCI1pG
        Ws2Wgjw+2KcbGP+Y5jLuiJuavrY5ubSK6HJa
X-Google-Smtp-Source: ABdhPJxfMFP3YabJvQG1eCm8+WRHk8z/j5EK6ALN2vMrY5IZ5RZDuN+LfeHp76Xzzub1WK82yLtJjQ==
X-Received: by 2002:a17:90a:e384:: with SMTP id b4mr1689481pjz.46.1599859709255;
        Fri, 11 Sep 2020 14:28:29 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u14sm3241876pfc.203.2020.09.11.14.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 14:28:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jannh@google.com, asml.silence@gmail.com
Subject: [PATCH 0/2 for-next] Rework ->files tracking
Date:   Fri, 11 Sep 2020 15:26:23 -0600
Message-Id: <20200911212625.630477-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As discussed on the list, it'd be really nice to rework this so we have
more flexibility (in particular in the presence of SQPOLL). Please
poke some holes in this one. Patch 2 is the meat of it, patch 1 is just
a prep patch. The basic idea is explained in that patch, so I won't
repeat that here.

-- 
Jens Axboe


