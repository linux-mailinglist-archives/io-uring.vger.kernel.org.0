Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE2A35A823
	for <lists+io-uring@lfdr.de>; Fri,  9 Apr 2021 22:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhDIUxV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Apr 2021 16:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbhDIUxV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Apr 2021 16:53:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B934C061762
        for <io-uring@vger.kernel.org>; Fri,  9 Apr 2021 13:53:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id i190so4996985pfc.12
        for <io-uring@vger.kernel.org>; Fri, 09 Apr 2021 13:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cyRAmHl6RO9p362s4zLtY4IArcXG9p1OigveqxmQSTk=;
        b=1HbRliRYLu+3HmR5bbcJJJFy0aYVj1+pmCBKAaZMsbeGvj3U2kwn3nZydzkD7xZhIV
         WQ+394xnMCPYDMDOjTM0NFTCV/o4QId5CDBACdAmw2DRXhApJDxYTvU4JHro1MZPskVu
         3KECnVaZdMz2ErbbAmu7tbbbh1DtCpNqiHloIHyyRLLOH7vc+sStYAQhwi7pVRFsuPsQ
         U9NAz1vUEicVh461JX8xeTgptNT7zJ/1N4eev7UWE3plb8rRKWkGNN7p2FoM+BuVHyAI
         kgqrcXgj9+6XHBQD5SMZxB1l4I9xSLLL/eBugiB8c+UXMZhJ8Yw4yKieX3EMQf1Vhkb1
         SfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cyRAmHl6RO9p362s4zLtY4IArcXG9p1OigveqxmQSTk=;
        b=p2iroYU7tbABiXd9AY6avsSy3yaJgsNtBqL06HwFopFI4NtkP8NtYDfdU6UV7ud2Yv
         tzKY2zcFG4B1BBKu16ZU4piyRjrF0ZrsfPPzNNTHvEPNsCfTbgH5YZIKpj9kSJhT+gpi
         2cQWH4p/zkGVO6YsMJtWcUjgJZFczDNGPkEIxx8cXwwRSwOZmarjSyVrkC2epyJRJ31L
         UrsbSgmV9pv212PnGh+IWqd7K4Q3QG+kcy2asH2dvvD0Tyvrkvbx/1Q+nzoJ53qdwfwX
         hX5qDHIXhmSw7Eqr8YJpg/EZGuCVCCphyHAYuw4CAOyyv9jADmna42GhFZfptaaAMS2l
         f61g==
X-Gm-Message-State: AOAM5314PiYNXgAjnIdMaPwKV2+iG+/G4gRlmI4o2y8c1d2gKIeGtNnQ
        P/x5dh+mA2E9YoFzpvtR2oSffMEQy2vCXg==
X-Google-Smtp-Source: ABdhPJyenyVWWAyyZoaA3DewydERwvBYZkVWenhvatRsZIZLVO728t1vFIUkj3F3TNir7kuJ316jlw==
X-Received: by 2002:a63:5562:: with SMTP id f34mr15488941pgm.391.1618001587426;
        Fri, 09 Apr 2021 13:53:07 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id c24sm3075813pfi.193.2021.04.09.13.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 13:53:06 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.12-rc7
Message-ID: <e782a5ec-f2c1-4980-6428-8b0067df213a@kernel.dk>
Date:   Fri, 9 Apr 2021 14:53:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two minor fixups for the reissue logic, and one for making sure that
unbounded work is canceled on io-wq exit.

Please pull!


The following changes since commit e82ad4853948382d37ac512b27a3e70b6f01c103:

  io_uring: fix !CONFIG_BLOCK compilation failure (2021-04-02 19:45:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-09

for you to fetch changes up to c60eb049f4a19ddddcd3ee97a9c79ab8066a6a03:

  io-wq: cancel unbounded works on io-wq destroy (2021-04-08 13:33:17 -0600)

----------------------------------------------------------------
io_uring-5.12-2021-04-09

----------------------------------------------------------------
Pavel Begunkov (3):
      io_uring: clear F_REISSUE right after getting it
      io_uring: fix rw req completion
      io-wq: cancel unbounded works on io-wq destroy

 fs/io-wq.c    |  4 ++++
 fs/io_uring.c | 19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

-- 
Jens Axboe

