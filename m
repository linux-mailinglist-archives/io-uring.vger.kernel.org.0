Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57D41A5A7C
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 01:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgDKXGP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Apr 2020 19:06:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38715 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgDKXGP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Apr 2020 19:06:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so5670159wrp.5;
        Sat, 11 Apr 2020 16:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PaGtkGJZGIax0HkhiC3JEbE5dhQwfZdRNpvR3UC345s=;
        b=Kf3XC0kaXm39dEFLi0s5a1fVAl5PKVNz19sCnvh6ThyBEMMZY8yzzIL+ZXVVGzxdJN
         0UF6Nn59j1BlezcqqZNALN6RpYlXqkkiJc8k+CSUIMCuwlLZZU6UfM9Ky/w8NWEIXOHK
         e++8kjEwQcwUFFvVbUl5HLubymEDZAhGQfxIkcBESHmp5iAaJx5e/Sr1jiAqvEctrbcu
         koGbEhjb0BU7K6BUkFf6yDzzKFbcBwyMf1HXtJUkxyLHfh1/VR5VYAAsnTklpqVfUzuV
         UpeZfH/qkr4dfc7v+xy/UqC08WnZqxcDWV2Z59SKmPkoSe5etSy58V9W+MWxAl+JAdKX
         YJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PaGtkGJZGIax0HkhiC3JEbE5dhQwfZdRNpvR3UC345s=;
        b=ErWN7wGNV6+hmvrkR2jemrgZl2VI7zjI8atlKywRyjcqINRY9KdITnLFzNmPgok6KP
         Ri9vyHnNTWj1Yl8K0FS5nzmOuNZqkLCpTm+ffRoXp22cjbiIo5c2HsBTAMJvAwHsJ+55
         3oRVksnOuLqiKQABqYl3r5jB3gljHyInrU6mvb7jF8h1CxCKynE3Pyo6k1souydR4JTu
         VnU0nZ+v0V1oGVdm7sGixfnxUnhn7DQJeHOBxUR5MwNVe48Q+jXs53LwgT8YrYj1V6tF
         gjJKbKqO4iNKgtSOgEq7x/znbrDwOOROHxdOUUJlYoSvMmWgnPzb6wD7YETw3820D4p6
         P05A==
X-Gm-Message-State: AGi0PuYU6pQVm1Bhs76fDmeQkhomt7ogKYDDdXPLWo+OTG3iiQqliiD9
        wmEQ9B9ahq/MSAKZEDsRZrM=
X-Google-Smtp-Source: APiQypJWTgNjc4ZCznDIDupY5H4O2bVnW5vSZegtDGOtlGdh0Uj2U1dnSE0Stcy/Se8p+s0pSBfkqw==
X-Received: by 2002:a05:6000:108f:: with SMTP id y15mr12207690wrw.423.1586646374167;
        Sat, 11 Apr 2020 16:06:14 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id k133sm8992741wma.0.2020.04.11.16.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 16:06:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] submission path refactoring pt.2
Date:   Sun, 12 Apr 2020 02:05:00 +0300
Message-Id: <cover.1586645520.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The 2nd and last part of submission path refactoring. This moves
request initialisation bits into io_init_req(), doing better job
logically segmenting the code. Keeping negative diffstat as a bonus.

Pavel Begunkov (5):
  io_uring: remove obsolete @mm_fault
  io_uring: track mm through current->mm
  io_uring: DRY early submission req fail code
  io_uring: keep all sqe->flags in req->flags
  io_uring: move all request init code in one place

 fs/io_uring.c | 196 +++++++++++++++++++++++---------------------------
 1 file changed, 90 insertions(+), 106 deletions(-)

-- 
2.24.0

