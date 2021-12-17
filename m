Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD847923F
	for <lists+io-uring@lfdr.de>; Fri, 17 Dec 2021 18:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbhLQRAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Dec 2021 12:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236105AbhLQRAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Dec 2021 12:00:23 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D1CC061574
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 09:00:22 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id x6so3766911iol.13
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 09:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=86339NXJW/C3Mf/2xW19kALb/EXQ8tWTBeskuwOFqUQ=;
        b=fbN1FumwN4prZ+cjiTRd1TxKbFz2nYsIv3eX+Iv4EePihJtmD2rZUkRsnpVj2Ctzbo
         tdBVcrBHmzoIrnFEOZIKAi/2NBcqEvlh4MBrSCs2BvlIa0GUW8hZIDe2MfQs0nOY6Tt0
         ofdP5QHKAKSnjhF6uzUg2rYTHPoISM4IMMVg/3RShI5O011v/j+z4dLdegXW/JKONxEr
         9fRHZ1XEqZuFzFv6h9JL+dLKgVT2saqN9DnxIxS10fSygvtD1axQ6A+X/LDD4SBLcSdU
         nMaWWU/jGQ2UvZSjP2SJP5eIH793o3wH9k0b1jvuIZxZcYdNfnzEz3jyepKlLktXYrYL
         281A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=86339NXJW/C3Mf/2xW19kALb/EXQ8tWTBeskuwOFqUQ=;
        b=XJslNAnT20t+2HWHlpnSZgpoiLYtoRizG3mSnLr97rIr20Z4BHIRL+E5ukHcvsE2AS
         83ysIRfISfZ2mZErIj2tfxfOhO/aPgWTMPhFgwvKGQpJNkj46jKvxl5qN88MvesRDKdf
         bGdMY6xxLDAXYNWrZOMH4dAai1z9MVkId9j/Z7lAiUoc558wl+4c/d855CxT4vyBYOr0
         6ceSCN9Ph/sYjvK11UXf9kj0CP001S4lcpRZ2rh5aH/anBWYbehXldHdcmWXBoq7Nbws
         gv3AgRFIQgeKUVjwKRjIsJw0hub2vMoVHF3gRD564EY00xs3cQS4J3QBUD3Bn+ijPIOF
         NRbQ==
X-Gm-Message-State: AOAM531VFsFE0Aol6lHP2sM8M06N6eI9zCF7fmqQCPYuYvxFX4PhIhl1
        IDkrGZagn1ZLlg3YdBX0CemFo1qLtDdmNg==
X-Google-Smtp-Source: ABdhPJy0vOZxAcWuTHzcJmOkazYh/9TFlaVQ0Qr7l8D3loDLkx+MZDwNaC1Y7EvqCoa3Ybm16dLbnQ==
X-Received: by 2002:a05:6602:2d49:: with SMTP id d9mr2123719iow.153.1639760422166;
        Fri, 17 Dec 2021 09:00:22 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l3sm5189408ilv.37.2021.12.17.09.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 09:00:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.16-rc6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <1a6bc93c-df75-d47e-e90e-e90a87e48a56@kernel.dk>
Date:   Fri, 17 Dec 2021 10:00:21 -0700
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

Just a single fix, fixing an issue with the worker creation change that
was merged last week.

Please pull!


The following changes since commit 71a85387546e50b1a37b0fa45dadcae3bfb35cf6:

  io-wq: check for wq exit after adding new worker task_work (2021-12-10 13:56:28 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-17

for you to fetch changes up to d800c65c2d4eccebb27ffb7808e842d5b533823c:

  io-wq: drop wqe lock before creating new worker (2021-12-13 09:04:01 -0700)

----------------------------------------------------------------
io_uring-5.16-2021-12-17

----------------------------------------------------------------
Jens Axboe (1):
      io-wq: drop wqe lock before creating new worker

 fs/io-wq.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
Jens Axboe

