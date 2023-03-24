Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC76C8254
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 17:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCXQ2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 12:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCXQ2q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 12:28:46 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CE42D55
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 09:28:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id le6so2260099plb.12
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 09:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679675323;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujec9rM2xQ4WZdirS9QGUugugNGORageZmid59zrq8w=;
        b=yi+NaPCBc0i9MrLeDUWTeEpTKDmwYK/wmq8KnIP3c98q+2UV387zO+MnQnxEfW6W3M
         6ubWjONJfdewaxJTbv3cumsfsbLUofC5NTMJq1YfkwZexbLU24kCViQD3XicBPT/jA/0
         8CkZTx13pYVDSGgtY7jnsDVgezvcV4z37bifKZsBkTiePabJBKS7CA6oeOX342WKEufQ
         3c4oFqh633+opccssTC1y05RPcmUx1VjuqaRhwfefo9aOfjcS12qdbW7i9XZjVXL4NbQ
         mzvA857k5O/LJ3VQIbjnEUgA4o1vNKCJTXJyAwvCilBv8x3COYcm4g5kRG5BZeSWZL9N
         yJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679675323;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ujec9rM2xQ4WZdirS9QGUugugNGORageZmid59zrq8w=;
        b=IRrj1Y2yjsSmZVkTCbosndhZBUU2MjCSoL2hXbjhi7IBhCzFbAKs7ggpKs2vx77Kd5
         qUoGv0P2tehe6wxMpWtn4kCV41BDLx/8BXgZOUC0S5Po5me1VnP/bFrDZW0t3WcpXptc
         HvQJnjK+ge+4YaYU/4yTgpCdU1TquuxNi97K8BHKr+APBn2Lc/faulqqMcWlHb3h/AlE
         uv/Y+whFMbapd4v7SRbtay9ODz3w7b3R7jXJQ+Iw4RGFiZ2cuc4tY+T8Xq+xpdJwriCZ
         0OY8LGZeh7IHKyqPfTyGBtraSo1A4BLdCMNNfPue+TXIz5vzRe+P3DCSWrWvINfxjLN3
         gFYA==
X-Gm-Message-State: AAQBX9fa1c1MurWzOGj2x0JS2zllSQECkBhZXl3MyP4kENuvO5V1LMRf
        C/J8JbFrJVooWDL2xD3ZBNQL65Ayuf44WZfVD+f+uQ==
X-Google-Smtp-Source: AKy350Z7CfrWvHGuBzoxIJP1BdvveGC+ikpPa7IeX7xIH+CHMIaHbvlp7w8gLknut7WdtRsiYLleXQ==
X-Received: by 2002:a17:902:9347:b0:1a2:1a52:14b3 with SMTP id g7-20020a170902934700b001a21a5214b3mr2201828plp.4.1679675322661;
        Fri, 24 Mar 2023 09:28:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c1::1239? ([2620:10d:c090:400::5:56f0])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090aca8b00b0023d143182b3sm3186493pjt.41.2023.03.24.09.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 09:28:42 -0700 (PDT)
Message-ID: <07712171-44e0-5fae-c2c7-c4efd45d8f79@kernel.dk>
Date:   Fri, 24 Mar 2023 10:28:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.3-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes that should go into the 6.3 release, both heading to
stable as well:

- Fix an issue with repeated -ECONNREFUSED on a socket (me)

- Fix a NULL pointer deference due to a stale lookup cache for
  allocating direct descriptors (Savino)

Please pull!


The following changes since commit d2acf789088bb562cea342b6a24e646df4d47839:

  io_uring/rsrc: fix folio accounting (2023-03-16 09:32:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-24

for you to fetch changes up to 02a4d923e4400a36d340ea12d8058f69ebf3a383:

  io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get() (2023-03-22 11:04:55 -0600)

----------------------------------------------------------------
io_uring-6.3-2023-03-24

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/net: avoid sending -ECONNABORTED on repeated connection requests

Savino Dicanosa (1):
      io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get()

 io_uring/filetable.c |  3 +++
 io_uring/net.c       | 25 ++++++++++++++++---------
 io_uring/rsrc.c      |  1 +
 3 files changed, 20 insertions(+), 9 deletions(-)

-- 
Jens Axboe

