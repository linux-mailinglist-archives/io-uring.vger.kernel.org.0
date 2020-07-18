Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B562249D7
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 10:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgGRIdT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 04:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgGRIdT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 04:33:19 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92341C0619D2
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 01:33:18 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y13so7314123lfe.9
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 01:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=abV8wUTSDMSpKBwCeSXTN/t32erHK+qMjMsCvTfkssI=;
        b=vc3tdmkttxBHXGv1uZTJEVn/dhvYH93V8rEowi893/vcRa0ETVlPKHsRAlUmP8maNA
         pqAfO2QkcH5GkY9IaLKucaHB3WCWobbj8lXh2MrfnaWvsh5tJDlrqs1VRV5V4u7vGM51
         NuqRvdKQDEyWfscA27YhZ5Lh6w8mePGncOnbGMA6qmMnL9Bcc47oVY8RZI2j0SHwWU8m
         EPDDLT2sBzsFWlKMJh3uK1CkVBiwc5EBuh2vh89oc6Bnb4CUeG3EbyRWIuOZcqWM07HR
         ioB+gSFSGB9sXVyaDRr/xz6NYEDbRnluDBvkEviezBjschpCQw/pxWyy7n9kkyyoIaKC
         K+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=abV8wUTSDMSpKBwCeSXTN/t32erHK+qMjMsCvTfkssI=;
        b=GjSKRFsoAT7MLpDJ1wj3dhH4x9QmN1QcqPh+cJkfIamcG5p/P2xLIvk0WdaOGi1o9K
         PaU7tgZKeq2L3VtISUxG5ada2pmxs+M4rX9wJTw43pcBUkVJF5RqlIJffAfF57vAcjG4
         FLy8gswmcIPmfebSxF6WoLZAMFOgDrAWzh4Ao72vzvwi2CPHBDwX/6+/5RBK+HRJ/lT5
         jcOWDJ87zEpaXB8ffFMCYqb2GgPzTwvbJKXFvdLvKk7qVi21j7Q8ETLmssA0kjBIMaxW
         d8yBvB674GL0iGYxkDzdzQGkuLf+/6GwW9q2EqTJ26zFYV7HFg+S/gGmeu0Nt1lx8lv7
         /7bA==
X-Gm-Message-State: AOAM532qCaqUfqyPikJ9X/r3gs6RefYgD1n9AttXT+HlG4L8r3/Q4fFg
        jwmiAELhVxHQmFGrluokgCo6ZOAr
X-Google-Smtp-Source: ABdhPJyHbbKCL7x7vD8OwxmlC1aVsEepYukqrqoal3oEjtDpFfsKbYhmlWkOH/y7ZdtJ+r8dP5tWXg==
X-Received: by 2002:ac2:558f:: with SMTP id v15mr6338401lfg.187.1595061196901;
        Sat, 18 Jul 2020 01:33:16 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id e16sm2089451ljn.12.2020.07.18.01.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 01:33:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.9 0/2] memory accounting fixes
Date:   Sat, 18 Jul 2020 11:31:19 +0300
Message-Id: <cover.1595017706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two small memory accounting fixes for 5.9

Pavel Begunkov (2):
  io_uring: don't miscount pinned memory
  io_uring: return locked and pinned page accounting

 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
2.24.0

