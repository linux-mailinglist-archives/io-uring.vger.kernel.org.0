Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A68112ADE8
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2019 19:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfLZSVx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Dec 2019 13:21:53 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37319 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfLZSVx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Dec 2019 13:21:53 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so10719519plz.4
        for <io-uring@vger.kernel.org>; Thu, 26 Dec 2019 10:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9WPJkjaBWeuoiIg8eHRKiDJaYeZQujvSEBablONAzYA=;
        b=oJ/eq3wi4oRIJfY1g6s8yHvYXlPtrFonI2CoxcBKrM9P6hfR8ml2Tt1cEC9F1uoDnG
         W+gN/ZE0/n0dFDNKojBdAKpE+xU90ouuGuvtxDPCOd+/21I1AfZyOsJGfkP3c7oD7wT2
         AhCMwbjd2MtFJ6dpR436h8VWnXeUDF6nt4Xzdf4H0+8UAVObnChkasj8hXADftLdqzHA
         O8jzA1RGKPYXZc5DUaQcGLyHicYFrfz7G5njiFXf3dzNODYIzQV22ehhrzSPxMtZoVHY
         4q6XJxkiC0QPz8393mmEPRBgCeiJepoTxMX4ixbB6vBvb6FpAZLUm3rPVcQ3QYdtLxpQ
         EiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9WPJkjaBWeuoiIg8eHRKiDJaYeZQujvSEBablONAzYA=;
        b=WP7qOw82UypuIlKr1S73kvUz/UaVFc9oPPWUJEolXnJA3ar40iYrDYey8bHcSfKb6e
         JuySZvEy7ZT7XS4zd7j1woTxn13PFjTp/k5DydHWwf/1T/ie5mtWoV+41irx5D4a6cw9
         nW/m8upcH2fGG+w0usictTPmoWiyUcLYNxTsgntm3uoLIZexj8sB70cIWjI7oBP/Mueq
         OzfbLl001fvadBIC34VCYtUYmskHUKoGhI0QH+WWRwj+Y/DNDsAXm+3mR+0CpyUVVyR1
         0SgyxEPAfp+hbC4AGax5q9UE9qS8SoGkzTN8jbtpxaVIYA7mm3B2ukeo7PiI227aNpTf
         8nTw==
X-Gm-Message-State: APjAAAUXatFbpcYscHZXrutsT4LygsUL6SM7QjmjnvCXO1mFboVCxC5g
        oaiGNn9JzrSPLjwpbxzBzrctgYudtUeq0A==
X-Google-Smtp-Source: APXvYqzZmedAr3Pa9CVJkfEeAX4xC35rLvR0X62FCYedvP0o0hP1zIhztN8Y8HlEzCnTVOxZ83qnnQ==
X-Received: by 2002:a17:90a:2486:: with SMTP id i6mr21782674pje.9.1577384512656;
        Thu, 26 Dec 2019 10:21:52 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q63sm15458330pfb.149.2019.12.26.10.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 10:21:52 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.5-rc4
Message-ID: <69cdbfdc-da7d-a3fe-f196-3c0819757908@kernel.dk>
Date:   Thu, 26 Dec 2019 11:21:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

This pull request:

- Removal of now unused busy wqe list (Hillf)

- Add cond_resched() to io-wq work processing (Hillf)

- And then the series that I hinted at from last week, which removes the
  sqe from the io_kiocb and keeps all sqe handling on the prep side.
  This guarantees that an opcode can't do the wrong thing and read the
  sqe more than once. This is unchanged from last week, no issues have
  been observed with this in testing. Hence I really think we should
  fold this into 5.5.

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.5-20191226


----------------------------------------------------------------
Hillf Danton (2):
      io-wq: remove unused busy list from io_sqe
      io-wq: add cond_resched() to worker thread

Jens Axboe (7):
      io_uring: use u64_to_user_ptr() consistently
      io_uring: add and use struct io_rw for read/writes
      io_uring: move all prep state for IORING_OP_CONNECT to prep handler
      io_uring: move all prep state for IORING_OP_{SEND,RECV}_MGS to prep handler
      io_uring: read 'count' for IORING_OP_TIMEOUT in prep handler
      io_uring: standardize the prep methods
      io_uring: pass in 'sqe' to the prep handlers

 fs/io-wq.c    |  10 +-
 fs/io_uring.c | 690 ++++++++++++++++++++++++++++++----------------------------
 2 files changed, 357 insertions(+), 343 deletions(-)

-- 
Jens Axboe

