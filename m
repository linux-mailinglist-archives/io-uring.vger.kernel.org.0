Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7F81AF2C4
	for <lists+io-uring@lfdr.de>; Sat, 18 Apr 2020 19:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDRRVY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Apr 2020 13:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgDRRVY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Apr 2020 13:21:24 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64B9C061A0C;
        Sat, 18 Apr 2020 10:21:23 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id z6so6384698wml.2;
        Sat, 18 Apr 2020 10:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Mmyrgp0gwbPy6iOJUPF/mmRY393aiDlZLAI44AwPnY=;
        b=PKlV8rD5CiWKWjGUgZHEn7MV3BvKjxu5WxiIqR1UnvYtq3UeE/1Np9m4rHOGycHAcz
         Qv02GlkcSHX34Obl14fZcil8Yn2wuBVtJ/Df8WudJ+mONpXAhQXH3gjbXTMhd9cjmGVM
         vke2AET9Wk63y+GQcxFmPgRplSNAy28LR5bAPL2T9PkFy1ymGI5q/wU+JM3ZVov42GjV
         kSNAWf+2KRNXz7gzS9K2PnAO9kifPYoBPjV8EqPSokrH+JsGc0hPuL6NmePyWmcTgx+C
         ucRLyIxrmMXzRHYu7qjtAb5yhGskSoa/PdiQ7q6lAg4ITP0JYT937x5Vckzvy+1YGybJ
         cW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Mmyrgp0gwbPy6iOJUPF/mmRY393aiDlZLAI44AwPnY=;
        b=FFahLyrNtWF5MrL4YAzJAOPYOsJK0Gtt025obq2X85VJ0MXWGUUjw0F/t3Q7tdT/P7
         +kRUf9x1jOyXpKewtN3rqJbTdUgLrtNPTIx0lzH7tJSFkff6Ftiso+Xh7bl5JbLMFb4l
         rlVFBFMzBHLE4EuXRW2u6OVx1FmMrjieL45MGTBn/EAfnFiWhpsz862ks2RUlrWs/CNE
         kKkz0aI2PHE5uBcCI8NbFcGu8O1giEvBc0+d0xZvHjEtRYgvHa6/868U8x97ejQDQja7
         mf/9loiW4TuqjiiZbp2LlFQOMUxzKwElb7mbjbncDYrnLln+xj7Rkr9bYYeC9gDCcQJN
         wskg==
X-Gm-Message-State: AGi0PuaFe/BQbpTVeyp9frH/8vn4agrMQgp2J+jqoFxd+HJcuF7aVF2B
        7VEE9DM5O+hHMBEuV3HgyWBmuSuO
X-Google-Smtp-Source: APiQypIRlBCTZlXxHVqWq17ZY/wPksDEr9J5qLbuTCyeGbBLxwEaquHKaj9BCAioBLUjmVAeDNGuIg==
X-Received: by 2002:a7b:c944:: with SMTP id i4mr9501673wml.144.1587230482199;
        Sat, 18 Apr 2020 10:21:22 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id b85sm12538247wmb.21.2020.04.18.10.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 10:21:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] CQ vs SQ timeout accounting
Date:   Sat, 18 Apr 2020 20:20:09 +0300
Message-Id: <cover.1587229607.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first patch do the job, and triggers after __any__ CQEs, including
ones from other timeouts. And it obviously fails to pass the tests. The
second patch makes it to count only non-timeout CQEs, and passes
the tests. Feel free to squash them.

Fixes Hrvoje's issue. Also, there is one more bug to be fixed.
It's related to bulk completion, and manifests itself with both
implementations.

Pavel Begunkov (2):
  io_uring: trigger timeout after any sqe->off CQEs
  io_uring: don't trigger timeout with another t-out

 fs/io_uring.c | 107 ++++++++++++++++----------------------------------
 1 file changed, 33 insertions(+), 74 deletions(-)

-- 
2.24.0

