Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616292F8BAC
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 06:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbhAPFgy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 00:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPFgx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 00:36:53 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EB7C061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 21:36:13 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id 6so3991401wri.3
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 21:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDXxjK2UC0JXVxKNNBsByMZw2fjSwMqIJhpWRjAwO3U=;
        b=kJngGUAgbGNovWPLhlN+f311j1aCdmp0hx+14JiMUjr9wAEH7P81M84jjsmE4+L4Vi
         XDJZi1nO58ZUxnFBvvI6+gPLJhKzuvViKSmc6KJdLQF0mD0Cckq71XwBRNtEc5YNvgMY
         jVDlpZcJ6yiYw+2046CaKvXXbbDgYPZ/sqb3zVeMe8o3+9YWVEOdcSQrjUMwcFwIZCLc
         K9x7gSvbJxKIsV2irb/h3JEej/DM8a9vH9l/9g8SNVpVK5lj5Jq45XubH2tStbCi4tp4
         Jkk7Vb8ii8YSPfS3xjnJ1Rfx+act+rRRR1pxFkLj5jBXrc6XW9FUr9wXeZgwDKBd/9Oe
         H+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDXxjK2UC0JXVxKNNBsByMZw2fjSwMqIJhpWRjAwO3U=;
        b=qXES3Y24RHLN46CYS2YpM6G6JZRZOUs/lHkFDtRRBwXa/onNZBatCmvoeMafY0gU39
         xwedOuhRxjxqhzz0vqrnKZf95pwm1Aio2bAQxWcfIEcrlxQCb6yCTjaF7Buy792AOs5l
         XVQoYDREBmWIstwz2fyufFu6VbTbQOx6qnULwNN3PYKKsN2P7azw6Y9O1NSqBIFB7QSQ
         kjpd/tJwinGNFg9JuzDmsIpaeG4W3Lzul8MyYhOPb0kyQhGbzJjk7ymukaOYU38roJuc
         jHbPAA8WDj4WA3NO/uKYWPu170koaf6dVc8OvQCOq+iO4SE8SvM76QbbcQecP3i73mqL
         1E+A==
X-Gm-Message-State: AOAM530rp+I52/A4CVJirIDBXcUFZBu8Aws48wsvpxHuocQDqY7eSugo
        sQpBInRnJzyKo03wlNiht6d/Ve51xFs=
X-Google-Smtp-Source: ABdhPJwHndsAE+SYLhZ0WM5f29D7Jpkibk3SMD4vBdx+Sz5vRR9JcNceB70jNEyBGGfzwJIIGAvIJw==
X-Received: by 2002:a5d:54cc:: with SMTP id x12mr16486018wrv.132.1610775371897;
        Fri, 15 Jan 2021 21:36:11 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id b132sm15348373wmh.21.2021.01.15.21.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 21:36:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
Subject: [PATCH 0/2] syzbot warning reports
Date:   Sat, 16 Jan 2021 05:32:28 +0000
Message-Id: <cover.1610774936.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two more false positive WARN_ON_ONCE() because of sqo_dead. For 2/2
issue, there is an easy test to trigger, so I assume it's a false
positive, but let's see if syzbot can hit it somehow else.

Pavel Begunkov (2):
  io_uring: fix false positive sqo warning on flush
  io_uring: fix uring_flush in exit_files() warning

 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
2.24.0

