Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB4C2EA0D1
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 00:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbhADXaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 18:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbhADXaK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 18:30:10 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74A1C061793
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 15:29:29 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id g185so768135wmf.3
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 15:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sX3qczPL75hes/E2YRuUXrKVpL9PrRWDbcdpd4+/F+Y=;
        b=nsvhY5N/UxVCZdQ7FFy8c4g0J75m5O3P58SSsA42irqcErQxvBxOYcsGjKpczprU4z
         udB66qKZGRjvJCLk9/hxv6I0ej03tp6MhcP1AcZw6qoSRFdA1ot8JHb6zWAcS72mtPHO
         GoqWCeS6zQ/JNO94x+d/aiU3pmnS0rQLMJhomJH9g2/rEO6V9YAGM0h8cnG7OpZwXvoF
         h5KdFKykFo4ebRQEQnd52hRTq2l2T2yweUw9ekdufMiK6YcSjJrfGYdHbtQ2uvL+sE+m
         VDIqwbaGXSZgIUeogBLE1S3aoI2HZop9zbEEblydjehjfHugYhWCDOjDE9h3BGac9iO1
         GGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sX3qczPL75hes/E2YRuUXrKVpL9PrRWDbcdpd4+/F+Y=;
        b=BEM51TkU4fdYd8rJP/pR9wVnG7/QWI+3swDTTEwl9HD6JDVdmXpWzETKsBvTvSWs8z
         coqU5jmZbtj3ktrD4+Oeh9nqnDWIND8IFc3+QSuTj5yxO+yymEsPF09HLDKRGQpHUquj
         /xYU4yD29/uUCNmTi/n833KPGMp6rh+rrz1oXbemqDVAfYmd6MqtInzIyyn+x2nXe/0O
         t6o52BC+8xKfW/rk2cUwHGmC2J2HNa3kI6t1UD7NI0pi7OaeU27K7ftaCP7cvAqDi+Pu
         ZaXPpQED1jWLoYQ/LomegH/niorM8gb6aSxb5XbzxLoHAmsYy02m6m+oG3s4bUlg7qiO
         8O/w==
X-Gm-Message-State: AOAM532TIzDqG/kT6vVhtkF6hxBQdWL4SQqBVaNnPl+TeXM8jCbSzdNK
        Af5KLO9Ft1ny32MorFOtZzcaj5nivpv0SQ==
X-Google-Smtp-Source: ABdhPJzxr2UB/CXXJ6dEvZa1nJ/uDO8k3gPXaOj9+O0IABsZaGr4DvLmd3HpJtkwfKhtMzZx9HM8EQ==
X-Received: by 2002:a7b:c2e8:: with SMTP id e8mr529874wmk.103.1609792812171;
        Mon, 04 Jan 2021 12:40:12 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id w21sm734483wmi.45.2021.01.04.12.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:40:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] iopoll sync fixes
Date:   Mon,  4 Jan 2021 20:36:34 +0000
Message-Id: <cover.1609789890.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[previously a part of "bunch of random fixes"]
since then:
- 1/2, don't set mm/files under uring_lock
- 2/2, return an overflow fast check to io_iopoll_check()

Pavel Begunkov (2):
  io_uring: synchronise IOPOLL on task_submit fail
  io_uring: patch up IOPOLL overflow_flush sync

 fs/io_uring.c | 91 +++++++++++++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 43 deletions(-)

-- 
2.24.0

