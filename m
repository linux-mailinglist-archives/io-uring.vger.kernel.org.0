Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3529F7BBCDB
	for <lists+io-uring@lfdr.de>; Fri,  6 Oct 2023 18:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbjJFQgN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Oct 2023 12:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjJFQgM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Oct 2023 12:36:12 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C738CAD
        for <io-uring@vger.kernel.org>; Fri,  6 Oct 2023 09:36:07 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-351265d0d67so2735465ab.0
        for <io-uring@vger.kernel.org>; Fri, 06 Oct 2023 09:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696610166; x=1697214966; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3IRcCm3RIbdm1AhrCF3DHBV0rKOE3WGkvk5iGkU/QE=;
        b=NJghJsi3aFD6A3u3nKGr1jBZj7/OEd5nxfqX1iJVwuOrdqFwsw5m0djOmmwZBMa72n
         yoCj4BvOPYaxFQIgy5Wm4hIFQ2cC5X/GxW09oxmxMJNhcDvZk2nm252SNnINXMDSSoS5
         EqYCFvCywjD0KJehHS3q4yXmkgmMJPYMvLbFpbPd1vAVMzj7sQi/ZKfjdjLqnOtjaq+I
         I9XEUK2uvn2ae85b9JsQP+6AW3p+1Zkr2ji69q0xMmHCIKBAk5tP0m5c36+odgZ6GhM5
         5wvc9jAJk6PiYMCMLFhg4fAyWelR5mrg6xAPyxzCJ8AIeisEc8gKDQ3WjKbKbT19dZnJ
         Sotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696610166; x=1697214966;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b3IRcCm3RIbdm1AhrCF3DHBV0rKOE3WGkvk5iGkU/QE=;
        b=nyiEB52Z4nY0WzPF7grN/NqKPANYvqdlpRMSIgrLEp7h4C87EGpp7R9RI9FL+4Ga06
         uNUyxwfhjEIlUED22+Z3wQsYMHvnckidtXtlLbGqbE9ip685nAAxsa1PRdFUggD+6zfF
         flQ4FUlw5ckx+YAwO/rJPWa6Di1DzLdQRgLDYk3WLDsUt98qtHZ8p9Mee9n1u0AFOd1k
         P3GJ8qeKB4+jmVokmY1KI0UXryhSCR0tguj5SDUDRz/+5aD1ViUuogt/RDS4sg0p9CiO
         z3GgxS1iU2Qj1nPYwqIYWL1HjeQfQdjLBp/CIFaXJKeEsTIcAZ57ajcSsh0D5OO7tuLF
         uVoQ==
X-Gm-Message-State: AOJu0YxUvyuynX2rRc/ffAuzu6hbI4g7bjKAJAAAMwcAnC0AdzOZn9G2
        ciOcJvLftsNQm3XifzvJA7bmVGxXgAw1CsNx0Z0=
X-Google-Smtp-Source: AGHT+IEGol9hNSn0KhFvzqI5WtQLobp1xnlz3p2P3RnOuZ59UrG5Xt2qncRXCJUPNZhtABhDxuX6Eg==
X-Received: by 2002:a05:6602:1a07:b0:79d:1c65:9bde with SMTP id bo7-20020a0566021a0700b0079d1c659bdemr9353191iob.1.1696610166365;
        Fri, 06 Oct 2023 09:36:06 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y24-20020a6bd818000000b0079fdbe2be51sm629272iob.2.2023.10.06.09.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 09:36:05 -0700 (PDT)
Message-ID: <18e5bd5d-9d70-4880-ba26-a72b0e5b6a57@kernel.dk>
Date:   Fri, 6 Oct 2023 10:36:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.6-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes for the 6.6 kernel release:

- syzbot report on a crash on 32-bit arm with highmem, and went digging
  to check for potentially similar issues and found one more (me)

- Fix a syzbot report with PROVE_LOCKING=y and setting up the ring in a
  disabled state (me)

- Fix for race with CPU hotplut and io-wq init (Jeff)

Please pull!


  io_uring/fs: remove sqe->rw_flags checking from LINKAT (2023-09-29 03:07:09 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-06

for you to fetch changes up to 0f8baa3c9802fbfe313c901e1598397b61b91ada:

  io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls() (2023-10-05 14:11:18 -0600)

----------------------------------------------------------------
io_uring-6.6-2023-10-06

----------------------------------------------------------------
Jeff Moyer (1):
      io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls()

Jens Axboe (3):
      io_uring/kbuf: don't allow registered buffer rings on highmem pages
      io_uring: ensure io_lockdep_assert_cq_locked() handles disabled rings
      io_uring: don't allow IORING_SETUP_NO_MMAP rings on highmem pages

 io_uring/io-wq.c    | 10 ++++------
 io_uring/io_uring.c | 16 +++++++++++++++-
 io_uring/io_uring.h | 41 +++++++++++++++++++++++++++--------------
 io_uring/kbuf.c     | 27 +++++++++++++++++++--------
 4 files changed, 65 insertions(+), 29 deletions(-)

-- 
Jens Axboe

