Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5D564FC47
	for <lists+io-uring@lfdr.de>; Sat, 17 Dec 2022 21:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiLQUs6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Dec 2022 15:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLQUst (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Dec 2022 15:48:49 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A0CBE30
        for <io-uring@vger.kernel.org>; Sat, 17 Dec 2022 12:48:45 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 79so3849414pgf.11
        for <io-uring@vger.kernel.org>; Sat, 17 Dec 2022 12:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5o+Q51zxFtdCWSIgmUXlOUsotdOlGh5co2IgFh2s2IU=;
        b=bn5gdmmgKej6nd7jYSA9vyXwpbphkzDoo1uXvt17E4Kn6Eve35ZUfZUFIqHhfMhAWZ
         f4msMuIAAJ0/X8Fzur1vgJVteuyXRpY12MO9S/9D6rsbQKti/dGJ0NEn+y8nK8shGPa/
         uYKAXXYHoP7dzBjwtJ/8OED5m89LbvEtFEgcwWj0tAAVRVXS0aZ+qVhMTPP8lW4baK5v
         CeBzUxMRf31GhnH3mxrSbuN93+T/kxAQahga/UG9/9LySh7ZGbkkbeWEqjG+ZQO7iHDE
         IcGArlOTWVJp1qd2T4oVGpSckmpelga4OVyTgQTYsRc1d3nUTnbqJ9erqoQnqilzt0JR
         +9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5o+Q51zxFtdCWSIgmUXlOUsotdOlGh5co2IgFh2s2IU=;
        b=kUMa5V3oRn7Wr72nlqlG2gfSuvDJPd0eKuGFOveWnhD66wUKb6DBhraXdrXfkvAwoh
         4/lltZvTQrTeS1FtR6Dp8eH8vO7UiSVwn/cYff+oPDgG9qe3pE4AYHqyN8H9Ts+68h5I
         TS8vux9OZqgEEdtgDQgO5Rrr886fzqY/kH5h9Rs3bUwmQdFd6vO7dpUiJ6AjF+L6pqKH
         cVbmq6w6qLxQU5cvg+eTLM5mXy1iXeHAXRbH+XpWyBdxiYzbRnULhpckQAz1ToAT/3so
         ggk/rIplm8h1FVoMZEIryfsxCSIeV+6bZuCigF80XIAEdKC3ThId+Cl08E+8dyNHbk/r
         LIVA==
X-Gm-Message-State: ANoB5pnJl8IX11Oq4/EvX5JH3K1aXUykQzBb/noNnh869U+RmgeoxMwm
        t1/YWy8uSkCIg9fJcSEx6cHEvrOLbr7Cu52ZQmk=
X-Google-Smtp-Source: AA0mqf5p+F5sgnqlheLD59cZlywDwKkwo6LWsnL31FapUxuNsdLV1kI5GdieRlKJ760l58a9Edcx7A==
X-Received: by 2002:aa7:958e:0:b0:577:36aa:ae03 with SMTP id z14-20020aa7958e000000b0057736aaae03mr8772558pfj.1.1671310124500;
        Sat, 17 Dec 2022 12:48:44 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i62-20020a62c141000000b0057737e403d9sm3528761pfg.209.2022.12.17.12.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 12:48:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     dylany@meta.com, asml.silence@gmail.com
Subject: [PATCHSET 0/2] tw/wakeup tweaks
Date:   Sat, 17 Dec 2022 13:48:38 -0700
Message-Id: <20221217204840.45213-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

One patch tweaks when we think we have task_work pending to be more
inclusive rather than gate on TIF_NOTIFY_SIGNAL, patch two ensures we
don't do extra loops io_cqring_wait() - and just as importantly, that
the expected run path for task_work will not have the task itself
adding to the ctx->cq_wait waitqueue.

-- 
Jens Axboe


