Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8729D7DA17B
	for <lists+io-uring@lfdr.de>; Fri, 27 Oct 2023 21:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjJ0Tx6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Oct 2023 15:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjJ0Tx5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Oct 2023 15:53:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D53FAB
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 12:53:55 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-2801963f737so125658a91.1
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 12:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698436435; x=1699041235; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0uniYbzMfNrb2vQMQYMIs0LV7zIMgxBq4LSfyStd11s=;
        b=IUovnXg0IVXkHRS5NIYtdRWQ/jor10FxnJaUXU/9YECqb1HEdNTTznPc+T2+KflQnw
         dH+plmKLYaBS0c9SW0DqLEbZEn29bOVg9KJ5+Jb5uR5Epap6rBziP+kXyrE+81BAgQUR
         S4QHItmwJzW1pO+T0pM7KIK6Z/FixLVBEuD0191XNV5ZpxwBI7CFjW2sZyEywfV5ageP
         vLY3jgXvs6OQ3yH09fg5lVfr3ecNOLOVFl7V6kf/e7AxgJw37oUQqL3t8UtdfeR1RyHE
         E6q89GbKKvZA1UGHGks6YPevrJ4WBR33QblSQth85dU9ytU1waokh/pYpC+y7pN6KoLN
         xE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698436435; x=1699041235;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0uniYbzMfNrb2vQMQYMIs0LV7zIMgxBq4LSfyStd11s=;
        b=u2TLV50Zq7ROgAUIxmSqwRHlMydkC3hBDj+5usJo11FkZEsJo2FnRauX40A8jOIfIj
         gGrOubUCA4h9dk5JFaa/YT8kB3HozOqr1ziXeq9yFPZrvFpLroTkSZH5K2E5NiPF9Bhl
         AM1XNZhAYNgUCjhExfWWmtl33MHmenLKbcMPt4p4ubG11I0WkjmWqAhP4kXfmsCLI8di
         8ZCougV9vsaideipEaeuNXPbfx05SjtyzVQW6rAhEF+a0cAQq3MOgcutUxfIheU6UgwW
         xcQ1Fhl5PZWYhv8GWMZg1g3a75sG5iWhAKkx1Kqz0sFw0Ea4+5k9IXnVh/BDmYCyqWDh
         esVA==
X-Gm-Message-State: AOJu0YwFugvDzuRv2zqxAP24iFnh/aSMxVsXDgTJ2nCAVL3VOFbw++f3
        AOtVgWRI3AvEn6fV/rk3Mygf14Fbe3Ghq9bnVOg7Qw==
X-Google-Smtp-Source: AGHT+IGZO2ZMcto8A2lXzosQWwqcoNWL7kEKNIQdEQH2C/wSRuAuXHQWl3m5DAHbIs5gfaRDUo1arg==
X-Received: by 2002:a17:90b:310d:b0:27f:f8d6:9622 with SMTP id gc13-20020a17090b310d00b0027ff8d69622mr3662325pjb.0.1698436434750;
        Fri, 27 Oct 2023 12:53:54 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090a1a0a00b00274922d4b38sm1760076pjk.27.2023.10.27.12.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 12:53:53 -0700 (PDT)
Message-ID: <4d88d020-6d8d-4662-b2d3-abd43ebe0d61@kernel.dk>
Date:   Fri, 27 Oct 2023 13:53:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.6-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Fix for an issue reported where reading fdinfo could find a NULL thread
as we didn't properly synchronize, and then a disable for the
IOCB_DIO_CALLER_COMP optimization as a recent reported highlighted how
that could lead to deadlocks if the task issued async O_DIRECT writes
and then proceeded to do sync fallocate() calls.

Please pull!


The following changes since commit 8b51a3956d44ea6ade962874ade14de9a7d16556:

  io_uring: fix crash with IORING_SETUP_NO_MMAP and invalid SQ ring address (2023-10-18 09:22:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-27

for you to fetch changes up to 838b35bb6a89c36da07ca39520ec071d9250334d:

  io_uring/rw: disable IOCB_DIO_CALLER_COMP (2023-10-25 08:02:29 -0600)

----------------------------------------------------------------
io_uring-6.6-2023-10-27

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid
      io_uring/rw: disable IOCB_DIO_CALLER_COMP

 io_uring/fdinfo.c | 18 ++++++++++++------
 io_uring/rw.c     |  9 ---------
 2 files changed, 12 insertions(+), 15 deletions(-)

-- 
Jens Axboe

