Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3597700E1E
	for <lists+io-uring@lfdr.de>; Fri, 12 May 2023 19:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbjELRwY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 May 2023 13:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjELRwX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 May 2023 13:52:23 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4776D6A67
        for <io-uring@vger.kernel.org>; Fri, 12 May 2023 10:52:22 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-3357ea1681fso2041735ab.1
        for <io-uring@vger.kernel.org>; Fri, 12 May 2023 10:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683913941; x=1686505941;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aG3G6a1B8o+ZKzYW+VcUywRSJ2Q12op40VfZW7FPk2c=;
        b=YkdAvOoZHoxWxKvuPzsningOHUHWbptZyzZvgjPEHBLwI1piZTH0rxsZClMWKroe9i
         bQDeSVMf7FhyXHQll9QndcTQp0tYVUu+min3cJLLgTAgVAPsjiEuFMlGSxsk5FxEa7JD
         rNUuVAgdpA1vBgNGZ0adbO8BPmduPAIAvCZ9vGqK53noINdjMxn/zq31XhT2zgGFVoKR
         Y9UfYOfHX6aRo0DuheW9wgHrN0Nd20kRAsdIuRnL6Kmmgd5imJdD37I+V+EHVUclQJPy
         xHu4UIAx2cYgFkb2ItdflWAG7ZzA0J6ihb/ZM0U6wUJ5CQSaiJHmgSDa51eSUDXDMpDZ
         pqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683913941; x=1686505941;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aG3G6a1B8o+ZKzYW+VcUywRSJ2Q12op40VfZW7FPk2c=;
        b=keOQBr67qrpDLh20lbUzGXisH/6XEqEmpSLDFxpunVzEptlCyRMgd1sd/TD5bAtq9G
         983jfTtNUL76Wp+QOv9pcg9P4Y4lb7XqxIDiuw2XpkR9H2VURsK9XZHUlC0zR1q9aVeZ
         9R3KynCn18BPKCIl+9W/WISwKkLuB/rcMqd5K/TAopLXHKkloG2tiOq4/52A6MzEubyT
         upXf3wlodPH+Lt3uuQJEs3Z12nb3xy+dXl2PqSHC0q55mmpVXZosmStjzn1ACXGdNgiE
         zAr2laJb0196enykNHJI6MEAoPfe7H8feXgvCc/n5dACr0DnthUYCYHJJt/13nDYxFG/
         CWvw==
X-Gm-Message-State: AC+VfDyXZHyVv0jcSEfI/tAeuiQC/96P/5ExemJEUBP3X6CQ8aINiJrq
        h2Z/3sfhmC0OD5jGNlngWnrdKXVPkwTbcfsQXHw=
X-Google-Smtp-Source: ACHHUZ4mvsPLcav+LmLwxBa0OXt0EP0Jl6cnbBjU5a4TzC81yOBwosdqHg5+J82ITX/dhWs70Amdnw==
X-Received: by 2002:a05:6e02:1d05:b0:331:1129:b8a9 with SMTP id i5-20020a056e021d0500b003311129b8a9mr14802253ila.1.1683913941431;
        Fri, 12 May 2023 10:52:21 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ei11-20020a05663829ab00b0040da7ae3ef9sm5085801jab.100.2023.05.12.10.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 10:52:20 -0700 (PDT)
Message-ID: <ddd808a0-f4a6-b002-f978-d6f04ccae10c@kernel.dk>
Date:   Fri, 12 May 2023 11:52:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.4-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single fix making io_uring_sqe_cmd() available regardless of
CONFIG_IO_URING, fixing a regression introduced in 6.4-rc1 if nvme
was selected but io_uring was not.

Please pull!


The following changes since commit ac9a78681b921877518763ba0e89202254349d1b:

  Linux 6.4-rc1 (2023-05-07 13:34:35 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-05-12

for you to fetch changes up to 293007b033418c8c9d1b35d68dec49a500750fde:

  io_uring: make io_uring_sqe_cmd() unconditionally available (2023-05-09 07:59:54 -0600)

----------------------------------------------------------------
io_uring-6.4-2023-05-12

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: make io_uring_sqe_cmd() unconditionally available

 include/linux/io_uring.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
Jens Axboe

