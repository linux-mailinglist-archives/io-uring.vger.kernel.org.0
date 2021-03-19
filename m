Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18B73426F9
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 21:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhCSUfh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 16:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhCSUfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 16:35:22 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E901C06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:22 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x126so6706817pfc.13
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B1w5gAZ9TX7nypJfuRp/xT3zEUxljPxqA/ekijQDG2g=;
        b=YUNXiDJ5uILFI/QTRzSQjggdArc0HZ7bgUC//mPaRyT9TYCmEmA2b9LWNIQAbcT8zV
         aJWnk3gLJpI1+nCr3k7nBJd1m38mX3wiYynUQaWrm1x/HBbynGx7cwShOOM3DAfsPvdU
         8fgx24ZPZ5jxjJsdjJsjZkxg2fpQjZIhFKneT+HRJmIBU8sagwu7CwdEsNNlgdBnbRzS
         htLd0x1ejQwNLcSl5RhQCkiCFYQM5dtraO92Zz1PpfHuwUhb3fvoe+cSzatF0YZ5NPgU
         T+MW87dojFdS8ngHPePaV8Wah/FfJEmgJnz7Y6HBK3kgjdyWmB4ecFEgavm85xOrHf9p
         0KrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B1w5gAZ9TX7nypJfuRp/xT3zEUxljPxqA/ekijQDG2g=;
        b=dwZbaWrK0LQSCigWeHL9hfoQ25oMMwTndwEzgMSNWJDFxplRW5vgKqdVKXIg6Q4aIg
         eDLg3I/AkWtJq/GAPhww47wUH5UxC/uUU3aMvpMHcB6/PpVSL+SpjXjD/uwvEqezskgo
         zB5VQuMxSfmUznQSFcqCwdssU+bknCXye+62LN/M/w1QHidxQaDiCI2W704sz0Q4+Bgs
         WE/nEqTr8kJk0cKoRe7duOiny45nROd8czpOfcktiOv4GvXYgwXNZKi3hgxAbnpho7BL
         8u2hpDe4IXsOyp1BCriT7eIDFoooXOLKdi5M9MqRCs/uKp6mradm05yca+5yzgXVpuM1
         hrRA==
X-Gm-Message-State: AOAM530tq47/K9k5SOWaUnWgk5KmCyQIy9nce1uVUcXTtsYDchXJROFT
        Fu7mxB+gsT8tfHyuw5Om7UN8wumttUNtqA==
X-Google-Smtp-Source: ABdhPJx8RB9HX4RL89Pz/QKmEID2aAXu8gZuIXTX1Mu4GKLj1eOgo6aHHL113IjNr1NXt6NeEjKo1g==
X-Received: by 2002:a63:cb12:: with SMTP id p18mr9175676pgg.191.1616186121882;
        Fri, 19 Mar 2021 13:35:21 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b17sm6253498pfp.136.2021.03.19.13.35.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 13:35:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/8] Poll improvements
Date:   Fri, 19 Mar 2021 14:35:08 -0600
Message-Id: <20210319203516.790984-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Here's v2 of the poll improvements planned for 5.13. For a description,
see the v1 posting here:

https://lore.kernel.org/io-uring/20210317162943.173837-1-axboe@kernel.dk/

Changes since v1:

- Split poll update into an events and user_data update. Some users like
  to embed fd etc data in the user_data, so makes sense to allow update
  of that too. So we now have POLL_UPDATE_EVENTS and
  POLL_UPDATE_USER_DATA that can be used independently or together.

- Fix missing hangup for some cases.

- Rebase on current 5.13 io_uring tree.

- Various little fixes.

-- 
Jens Axboe


