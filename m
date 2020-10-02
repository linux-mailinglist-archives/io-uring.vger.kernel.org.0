Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F22C281A0F
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388267AbgJBRsu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 13:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBRsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 13:48:50 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BECC0613D0
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 10:48:50 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y20so2354401iod.5
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 10:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wwHs4GL4cPKtYEmgUAWXGIjajFNzzeAQGOe82nZJvDY=;
        b=lwS52s5o7a5JYw5/tmMSL7zEVBJUshzHp2KjlHiDn3KFI/TOi8NfTMVgCqwXUvbJmX
         bGxH0pG+nz7OsOPVw0DwxtCqggm7NHwm5zpBxa0O0PJDJXXNkHWyFk9h12ZMitD6CT2v
         N8DCeclCfCeWk2gcpOJA3W5I0pmjrffmkSrbXkrBT056n2QWSQPfSQoGJ2V6bF07h/wp
         ZE7ytf3jawIZ9rxDi797nqqKDhQzJTW5P2VsdwDGfr25MsExa6lAM/3oRPxjPQZrxMVt
         emWoCOIVcL2ioq9gKUx17h8Lfvmj5YsoKr8syQfCc+rHfKcys+JqFA/lSOUCkECGLRFP
         Gedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wwHs4GL4cPKtYEmgUAWXGIjajFNzzeAQGOe82nZJvDY=;
        b=Tt5w1cWEVtoe9bQXSQbPCoRBRNKQ1KEVz0waXLRvarT3UCodP6ULf4wiyje2oqx0sO
         EGkjj/1Cq8oY9Jm6c5AUxYpkmma0CJDrPOXgFExmEMqZRQQSh/Moq9N5si9ze864W3f3
         24k26RnWn9mnDjbNxcXxPGGDcyjykBtXxoBgnWdrcDRnQE6PxmpNNeaKzHuxzYF0GX8U
         rkiJGPwd+48COu+zHhRp4/oaHxEe4kovu7TOMIT86ugDbn38Itm7f0YsaqeeHlVJM9gZ
         vQhtIBiXER/W6WABF+RTyOaO8cHrAb7u1eIsAFerHLo2sS1RHlscwpxHrZE2adajsyvd
         dHHg==
X-Gm-Message-State: AOAM533fwgGTv2HhZTa5iZknFZvk5BZtoo7qJcPzQt7xobk6FVUFwtlB
        LWtyMngVkWHb+ToVkGj8Nj9Z6g==
X-Google-Smtp-Source: ABdhPJwrScYznco9bTGhKLudt4SEG2zHhZ+gYbPkSWKhUuY1UWBO1K9V4sOjQeDxqxo0wehGhrDm0A==
X-Received: by 2002:a5d:8e0a:: with SMTP id e10mr2886385iod.169.1601660929540;
        Fri, 02 Oct 2020 10:48:49 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i27sm1156102ill.12.2020.10.02.10.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 10:48:49 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.9-rc
Message-ID: <06ed71bb-ed17-9621-d461-e189ce217d28@kernel.dk>
Date:   Fri, 2 Oct 2020 11:48:48 -0600
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

- Fix for async buffered reads if read-ahead is fully disabled (Hao)

- double poll match fix

- ->show_fdinfo() potential ABBA deadlock complaint fix

Please pull!


The following changes since commit f38c7e3abfba9a9e180b34f642254c43782e7ffe:

  io_uring: ensure async buffered read-retry is setup properly (2020-09-25 15:39:13 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-10-02

for you to fetch changes up to c8d317aa1887b40b188ec3aaa6e9e524333caed1:

  io_uring: fix async buffered reads when readahead is disabled (2020-09-29 07:54:00 -0600)

----------------------------------------------------------------
io_uring-5.9-2020-10-02

----------------------------------------------------------------
Hao Xu (1):
      io_uring: fix async buffered reads when readahead is disabled

Jens Axboe (2):
      io_uring: always delete double poll wait entry on match
      io_uring: fix potential ABBA deadlock in ->show_fdinfo()

 fs/io_uring.c | 23 ++++++++++++++++++-----
 mm/filemap.c  |  6 +++++-
 2 files changed, 23 insertions(+), 6 deletions(-)

-- 
Jens Axboe

