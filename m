Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B92E213FCC
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 21:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGCTRE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 15:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgGCTRE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 15:17:04 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15267C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 12:17:04 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id p20so35294790ejd.13
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 12:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sQmtSPVlnPwp7SoArndaMOrgiccygNrGa4M38UFXyl8=;
        b=KFY3xH0UlUYIvFPsuvJ+tEq1ktvec78JyMwteXue95wQOOK52h2URmR27uWY8FsuEx
         tC88dDkVe81YWXrCk4J3npwV3sjcvR8iLSYIlEm4eKsd1SdXOxxzbrwgJdhU4DQgK4xQ
         lHW8NbUaNBUHBicuiig2hZy25R5Mahh52VYb8qxHwJJewfBZqFyU+tLKh0qddBP86vGU
         FDwQc9DhM3PoICLVChQ50jiwrF2qbVXoE1+yhs9yDo110jSENHqGz2OLu3vSm40E0Zwh
         jrZ2YUfF/QtAc4d7Mp6ykP/krrnqHZk/mflM17kOzhgrUOhAU6SMmNU37NTSRlyqCIoS
         ZlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sQmtSPVlnPwp7SoArndaMOrgiccygNrGa4M38UFXyl8=;
        b=TLZyF9d0n80ZT6RZBCy2U4nHR2VeciZL8VwuxUnrFAFyasGIbovuvbqQ6hIb5cxY19
         MgRxX3FxwMwsEcvg9HZEy2ncnEZnQ82XWYCz0YzOqf8kZOtvS2gBxYq7pJ4wkKdHl74Y
         me2779HXochKywq4NCJlYrFl+iLZ1mHJD0ruhsoW/O1EThdU/1seDeGsDqme8SRIqvOV
         TMFjy0J+s0IazUTkXec2NEAlkLyJKWidv8IX07QzvVy9BllJownrhwqhXW66Z48yxAR5
         VafqQyCwb544sk8qLNUcp/MgccCG6bv4UHYrsEhvPBfj7QC1aN4fkoB8vThUB5rwBltk
         ltWA==
X-Gm-Message-State: AOAM533PikMuzcL4xNFN49eABfzHyjwf36ZWF+r2VIUbOmxghlN/RWDD
        Oqm+EYqqktF6W1JVJWoSHqQ=
X-Google-Smtp-Source: ABdhPJzamDNgLxVMpOo5jVeEubEi36gQ8DEgnh6G9Bs66HJTUIFfezfLT1UIMqY2O0oVkwyAm9hWwA==
X-Received: by 2002:a17:906:fca4:: with SMTP id qw4mr31915421ejb.362.1593803822647;
        Fri, 03 Jul 2020 12:17:02 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id p9sm9907883ejd.50.2020.07.03.12.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 12:17:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] bunch of fixes
Date:   Fri,  3 Jul 2020 22:15:05 +0300
Message-Id: <cover.1593803244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just random patches for 5.9. [1,3] are fixes.

Pavel Begunkov (3):
  io_uring: fix mis-refcounting linked timeouts
  io_uring: keep queue_sqe()'s fail path separately
  io_uring: fix lost cqe->flags

 fs/io_uring.c | 59 +++++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

-- 
2.24.0

