Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1649A1EBBC0
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgFBMfb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 08:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgFBMfb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 08:35:31 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A4EC061A0E;
        Tue,  2 Jun 2020 05:35:29 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k26so2943439wmi.4;
        Tue, 02 Jun 2020 05:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5Q568n3WGM5Rw6G3hGSgRG/IVyA9rqbq+xRfmkcbdc=;
        b=KbaAXzlcqDz0zEECfG9LjimjIO0peoezbtspI4izEw/tXV160dZ4VOH/YKxJU463IJ
         +PKgvmUhcWeLyukKueQYw1v5/EVE3gs/RVBDyBEGgKAzkbFIuT7f5rnkXi+0S4g3FjIZ
         ldxSfXoamQ4/Tf4y+kmr8IPbpiu4b3Y1yWEMiBbH1eFdU67LZXpahK76EszXiRu341W3
         d9iMBBdTZlrx0uj+gbas16ME/j2+/y/x8o2xekDLVHjCwQv8uXn0e/HmL+OqXutQlAeD
         siW2UfgpHZgYLPrxOdkUoYL/L1U7B43L6tFaPZ7Ggkt5nPm3QncW6C1eisjoNVSdvjD5
         R2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5Q568n3WGM5Rw6G3hGSgRG/IVyA9rqbq+xRfmkcbdc=;
        b=txOqELCgkpbrtp+9SRLBm8Nvc/tEog4k31vaWMz8RGUvBHOZ+7HTCGdpmEdE1ZZ2rk
         Foi26Uqnb0cbsQW+6nrqhNN14zSBWsDHVEVTp6qQTwWO0EmUXE5P5TqO3wa8UFuXk0zx
         KloLTp+XHBqdPW0Ur2xP8mT+1uhOPKAcfF/sQpMQMWJcGQVcw5HdL+dvbOJFr6NrLHld
         3nUevMZnRZEpzZSzZ18s+RT3Jf/4SAuGFBlN61aqznhuUkW1pcaQm1HK3tCbTgMlKP1t
         hjkUY2GSa8SOZxZYaTxlH2NRpYP8lWpwFQgzTTgyFQRJYwzRXd1BkypVOBBP8oNH8J7J
         wd5w==
X-Gm-Message-State: AOAM531zva5GcVXChbgpoxmgXruB3wwEo0Jvu57SqWu8h0mHdsdiNmYs
        Z2e3UQgMixv45thONNl85NeYNYfN
X-Google-Smtp-Source: ABdhPJyhPZgH9xPEGDOxTY7MdxvaWsaZMMuoWTczETtp5FN/4pK1uECPdklzQRynWrqIJqVGlOvbYQ==
X-Received: by 2002:a1c:6884:: with SMTP id d126mr3920973wmc.121.1591101328090;
        Tue, 02 Jun 2020 05:35:28 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id z22sm3347711wmf.9.2020.06.02.05.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 05:35:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] forbid using open/close/statx with {SQ,IO}POLL
Date:   Tue,  2 Jun 2020 15:34:00 +0300
Message-Id: <cover.1591100205.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first one adds checks {SQPOLL,IOPOLL} for open, close, etc.
And 3 others are just cleanups on top.

notes:
- it cures symptoms, but would be great what's with null-deref in [1/4]

- need to look whether epoll and sfr are affected by {SQ,IO}POLL

- it still allows statx with SQPOLL, because it has a bunchg of rules
for ignoring dirfd, e.g. when absolute path is specified.
Let's handle it separately.

Pavel Begunkov (4):
  io_uring: fix open/close/statx with {SQ,IO}POLL
  io_uring: do build_open_how() only once
  io_uring: deduplicate io_openat{,2}_prep()
  io_uring: move send/recv IOPOLL check into prep

 fs/io_uring.c | 78 +++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 46 deletions(-)

-- 
2.24.0

