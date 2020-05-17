Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF65E1D67A5
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgEQLT2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgEQLT2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:19:28 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDE1C061A0C;
        Sun, 17 May 2020 04:19:27 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d22so5489606lfm.11;
        Sun, 17 May 2020 04:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e6etauvJHI/BRbBrWveTIlcowv32UOIt40/wJV6YqrY=;
        b=inBG7pM1uL4IAfP2V7PvN5p2K4wKGfOW4orM/yP3udwv+ayN0OL8C9246wPSYc4R5x
         LlJ/Zc8GvWXA993/Wkkb87yyFwMte20tZiPnsfyEquFG7Sl+bwq7qG8FkWhf1wJOyWPs
         pVXbyysgngmf8NQI5univO20trlL7zQSiXb9qN5bkT3sus1cyMyl2i0jWibeMIe+lckB
         58MwEGZFOiF4Iq7votkjZ4yFe6Aaj/WBasokuK4FY3bpL8glFS3/mGc6QbKDeskObzvO
         Ni6ljIYP9qomyS9j1az7RL5EaC4PHyJL32KSKjIiV5u3GbOWDzfsjpIFeYp/llIg201T
         eQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e6etauvJHI/BRbBrWveTIlcowv32UOIt40/wJV6YqrY=;
        b=GnX/WQI64JtRKuy4yCjyzeSBVoic3cf3hwTkw3W3+3wYBzb7Kfa5NTKGq1c9PP6O1q
         B9ZCH8vCWnzRgfyPzerYr4xLB9Lgx2wUVowbH/01Ukr0tp2Fal0Fvye2HAxtObLEdTEa
         6te5IIel2aMOCG6Dmyx+/A8XYw4RoXGukKKKGKQxlrS85S+JP9/mC5t7+VeyBoVCMCVs
         0ChIX4iVFg6KORSD/RbgR4Sc9gW/R/OmuwlFY5/RC1ngi5b7mr/Y//K8LKBoq2ONyOnp
         uhbl/y2iZYDKMkOAVrjQ0cjOWyLdHuvdwBnX6uhXXfHUjcuXATCLCvDVjOLtNRb6/AEF
         vDzw==
X-Gm-Message-State: AOAM533SzDUe4eLmMUKDFRe7WnAuyBa1yJNky5nv6erxkKKXIcP+m24c
        FJ8c4XkRkpv1TFYNjk9FHov+syhg
X-Google-Smtp-Source: ABdhPJw63H4zVFB0r61kD5Mq2AxYy1X8QrxZ4hCSDoa5OK1aVda/RYd25KFCmyV5C1Ppyg2VVqaH+Q==
X-Received: by 2002:a19:987:: with SMTP id 129mr8119429lfj.8.1589714366200;
        Sun, 17 May 2020 04:19:26 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id f24sm5534246lfk.36.2020.05.17.04.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:19:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] io_uring tee support
Date:   Sun, 17 May 2020 14:18:04 +0300
Message-Id: <cover.1589714180.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tee support.

v2: handle zero-len tee

Pavel Begunkov (2):
  splice: export do_tee()
  io_uring: add tee(2) support

 fs/io_uring.c                 | 62 +++++++++++++++++++++++++++++++++--
 fs/splice.c                   |  3 +-
 include/linux/splice.h        |  3 ++
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 64 insertions(+), 5 deletions(-)

-- 
2.24.0

