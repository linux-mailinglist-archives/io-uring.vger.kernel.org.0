Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D21635F19E
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 12:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhDNKse (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 06:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbhDNKsc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 06:48:32 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3301C061756
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:10 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x7so19385622wrw.10
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UClraf7P1R3peIOL5r6K4wlKKIsYihJEcAzUU1axiHw=;
        b=Mm2Pxjsw0xpB5P8AB858KWWYf/Mv0IzG0lwJsfNj3Y1q/EerKHs71UBitynkpyjPuO
         Ag+HtK7KwIrj+MlQn49ZMfMHIVPs0Ve0fumYaddCdmkfmrbh6yJDa+s4zOA3pnIlaJX3
         dI2J4dtL2/MTTqJ2xcyPlWDPQKwjwv89WaI5cdeaPYOopYjxmQJNLjIvmLusizrPo0ZD
         UVJEdXR8NQ/9jmLuAOW0fyJe0cGV5Ou7vZH+3tusmwNfLQrMnGoT0Wnf8KdoUE2PRLuk
         98PlnRZ9B8NIQWTcKPn+OZ6Uc7CWdNSEttuRrXJojyConCOoCtoI0SoyhlSYSFQ8Agrc
         l0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UClraf7P1R3peIOL5r6K4wlKKIsYihJEcAzUU1axiHw=;
        b=OQkiH54mKf3nsPTjRD+HCbHJ+YgBiqRtBCT+rveeIUVCa+TOE3Uo+sOU57nbSmeqfh
         /mD6ZSgQBkoMnnPE8pkanYZOK7oLgALH5wmkSB7J87zshSNGNCzwRRH4iTVGC5p46RuY
         tV5dXui2IZCur/lcmnFrjPV7aLgPxtxipyw/t7GcrEzCYFLq3UKdkJLdtOo9gB2tZYQ4
         fGsOUwpFJm6DwHgAgFOXBe/Hg2KUXEJYHP7lUKBu3Q/Pdr8pSoyEiBOD36Sy38ho34hU
         C4nfHRmmVXkhLdZZgOzAPwWuz0Qq2Qsse5hAnlxeLdyH2AFsoUm4Ckuo/KqfU+jJxaIP
         Az3A==
X-Gm-Message-State: AOAM530B1SjfIyoL9KSJPwH7Uf2sUdVY/LAJ1eT8fPPFNwtS8HYM0Xtq
        QQkUpg38gd+I4+WDcDAdwNE=
X-Google-Smtp-Source: ABdhPJz+1U+6auZx4G/i4sDCXACiIO8JUS5RelbLaX+y+fdENXdOrFI3X4crY90CVWg7f4vVRoQskw==
X-Received: by 2002:a5d:564a:: with SMTP id j10mr3120024wrw.108.1618397289713;
        Wed, 14 Apr 2021 03:48:09 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.163])
        by smtp.gmail.com with ESMTPSA id n14sm5003002wmk.5.2021.04.14.03.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 03:48:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13 0/5] poll update into poll remove
Date:   Wed, 14 Apr 2021 11:43:49 +0100
Message-Id: <cover.1618396838.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-2 are are small improvements

The rest moves all poll update into IORING_OP_POLL_REMOVE,
see 5/5 for justification.

Pavel Begunkov (5):
  io_uring: improve sqpoll event/state handling
  io_uring: refactor io_ring_exit_work()
  io_uring: fix POLL_REMOVE removing apoll
  io_uring: add helper for parsing poll events
  io_uring: move poll update into remove not add

 fs/io_uring.c | 197 ++++++++++++++++++++++++--------------------------
 1 file changed, 94 insertions(+), 103 deletions(-)

-- 
2.24.0

