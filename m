Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B253B3C5C41
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhGLMj6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhGLMj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:39:57 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2F1C0613DD;
        Mon, 12 Jul 2021 05:37:08 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i20so34280809ejw.4;
        Mon, 12 Jul 2021 05:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c5iYjnhuOSvPsy5T4IiVkvk1EDH0D2rMauXYbVIBFd0=;
        b=bzd0vTKiN3xegMxG97DnMuDRHnikfGRib4kzVx9tyGhR2RLcomfNY4SEmK218x0Suw
         7ujpWhDzcGuqDY7jGev1nkNOyXQ+prKD+CGNUHfHpbPu0QZtZfyfcyc2S62GM957Vc+w
         EiFSFFRbmYIP0m1GJnjifmGb8tjz/7ZdOzt0FCRfIm3aH6doPcCQTbMJzlDqhmCLVrnn
         G+uZOe/hr6BBhko9Hb+MLkg/XqJMk1iZPJdUoOu51aBDJJUGiupNR3dJy+J9w90qScsP
         U50kzd8H2eDP9T3fxrBY76SSYRF4XuuEOHpK2F4GmbCpcE7qv+FtsEiKcVLYkogZTr+a
         lqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c5iYjnhuOSvPsy5T4IiVkvk1EDH0D2rMauXYbVIBFd0=;
        b=VgbutmgMbKehjyVxBNfvv+mv9989hvTZn/XGPm91knteziLm1sGOlLjHWbMSLU6RUv
         AJs9WCF1LvdXtn0AleqPrGpz1dTH/vaM63D3IhGZpH9VG+wkay3oXES6HlDeJctMuWaZ
         icCdRaI6pf2Q9sHsLC108Nhq5PI4oBw58fVqGUfbLR/QHT6IFU3L1Lp7rYbL8gmvLqpH
         qvY1Z1IfmGrmc1cncyH+RLeZyd1F/7eZ8u5zSKkpzxbWotZgsYHG3CmDvWREinPCsxy7
         soAQ7OFSIrAiJ5yB8LoTNdBzO9rqoWrqXoPfb8OmF2zHlpZlgTsiieq0Dd/b8ONz18h3
         Okow==
X-Gm-Message-State: AOAM532H9SSe3/8XLoSNjMho31ddzvGravPpZEOEgIcQrv23XXIICBLv
        2O9NJ3hTxosZDIvcZUotpE8=
X-Google-Smtp-Source: ABdhPJxUJt5aqytrAONF2ONicGDl5FRCMHPajn4YlG9oWoqYRKW9YxMqZ/xJTNbaItoX0G5cAq+fKA==
X-Received: by 2002:a17:906:d1d1:: with SMTP id bs17mr52232917ejb.492.1626093427479;
        Mon, 12 Jul 2021 05:37:07 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id y7sm6785216edc.86.2021.07.12.05.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:37:06 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  0/7] namei: clean up retry logic in various do_* functions
Date:   Mon, 12 Jul 2021 19:36:42 +0700
Message-Id: <20210712123649.1102392-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Suggested by Linus in https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/

This patchset does all the do_* functions one by one. The idea is to
move the main logic to a helper function and handle stale retries /
struct filename cleanups outside, which makes the logic easier to
follow.

There is one minor change in the behavior: filename_lookup() /
filename_parentat() / filename_create() do their own retries on ESTALE
(regardless of flags), and previously they were exempt from retries in
the do_* functions (but they *were* called on retry - it's just the
return code wasn't checked for ESTALE). And now the retry is done on
the upper level, and so technically it could be called a behavior
change. Hopefully it's an edge case where an additional check does not
matter.

On top of https://lore.kernel.org/io-uring/20210708063447.3556403-1-dkadashev@gmail.com/

Dmitry Kadashev (7):
  namei: clean up do_rmdir retry logic
  namei: clean up do_unlinkat retry logic
  namei: clean up do_mkdirat retry logic
  namei: clean up do_mknodat retry logic
  namei: clean up do_symlinkat retry logic
  namei: clean up do_linkat retry logic
  namei: clean up do_renameat retry logic

 fs/namei.c | 283 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 163 insertions(+), 120 deletions(-)

-- 
2.30.2

