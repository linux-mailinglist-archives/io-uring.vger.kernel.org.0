Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F17861A3D99
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 03:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDJBHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 21:07:10 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:33539 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDJBHJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 21:07:09 -0400
Received: by mail-pl1-f176.google.com with SMTP id ay1so166700plb.0
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2020 18:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=yLwIvsPpTjuwRCf4XNooqSkmxioNK/7m8vjoArRxTZ0=;
        b=mvPT5Z9OG0KJgS380cKv5XsSTm+AXs9ZGgk8uPXMUN1HHLD4YNGbWzX0t922f6wxWP
         txcLIIY0FdopzVyR32en3fegco4CBpzULTJLn6g3n+SLYh/Rl0ty9DLU5COYfAvFNzxf
         NO702+BSFderQQ1RUykzNdv0bsP5mxYJSFx8O3WIrKbFpt43qw8Wu5GyfShZaGf/hmIg
         gIDtU+LK0dsOgxiy1i/89ipMFENJl6k/EDq7AZEafVm206R5KJEItifGEu2+YS68vCGJ
         X9hU3ZooxGul7/E6EA+LC6dAG92Q7AHW9aYGQIhHEHOoGgWIHHiuVYuqooeUoiqDQS0L
         bIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=yLwIvsPpTjuwRCf4XNooqSkmxioNK/7m8vjoArRxTZ0=;
        b=kEMwtp7e4s2MkUuZ2hE7BT/RjsafxZynUKAYJIYLGH2Mfuw9BJu0WNynG86XpMHiSy
         wULftLB2rygGjbbTmVlAQpW1VjZ6BtxvB4s5hHt7yC9sHbzoyoO/Wbv34lJFIfJnjHoE
         Q/P01eyXYpFXcGyfeSXUUD6LK1uUhYtRcYPtvSfssyzwMlLb8j11UkomGUzCYJ0hueQw
         T+nXp6nuzbV/QI3HoiTA8lIaWMnXeUtFNRWpyXvMJlmgyxQOzSoZWn/KLlC4kfINONI+
         6JiCG7c2bYcAoJ7n1qyNBdkq4scgz4VSh1cWOKvhVolg5zVwkBxPNU7dnvwYx9+wnrCa
         f1kg==
X-Gm-Message-State: AGi0PubUybL1Jk1b/8L/39DxrGu9Gi1RKzTe8pZiibdXVDf49Zu0aBgS
        mZ2ugDisA0LeOOMjAusfj5EPdQ==
X-Google-Smtp-Source: APiQypLIJ+Dhf59k+8OQPCX2c2q0LPEAUz+EP3lACoNIulH8RC0DwTAhvLMDJp8QNhMafodx+z0omg==
X-Received: by 2002:a17:90b:1b01:: with SMTP id nu1mr2430864pjb.129.1586480829129;
        Thu, 09 Apr 2020 18:07:09 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:70f8:a8e1:daca:d677? ([2605:e000:100e:8c61:70f8:a8e1:daca:d677])
        by smtp.gmail.com with ESMTPSA id c59sm146152pje.10.2020.04.09.18.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 18:07:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.7-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <9739a06d-728e-1d6b-d511-ad4eefdd19b5@kernel.dk>
Date:   Thu, 9 Apr 2020 18:07:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Here's a set of fixes that either weren't quite ready for the first, or
came about from some intensive testing on memcached with 350K+ sockets.
In particular, this pull request contains:

- Fixes for races or deadlocks around poll handling

- Don't double account fixed files against RLIMIT_NOFILE

- IORING_OP_OPENAT LFS fix

- Poll retry handling (Bijan)

- Missing finish_wait() for SQPOLL (Hillf)

- Cleanup/split of io_kiocb alloc vs ctx references (Pavel)

- Fixed file unregistration and init fixes (Xiaoguang)

- Various little fixes (Xiaoguang, Pavel, Colin)

Please pull!


  git://git.kernel.dk/linux-block.git io_uring-5.7-2020-04-09


----------------------------------------------------------------
Bijan Mottahedeh (1):
      io_uring: process requests completed with -EAGAIN on poll list

Colin Ian King (1):
      io_uring: remove redundant variable pointer nxt and io_wq_assign_next call

Hillf Danton (1):
      io_uring: add missing finish_wait() in io_sq_thread()

Jens Axboe (6):
      io_uring: retry poll if we got woken with non-matching mask
      io_uring: grab task reference for poll requests
      io_uring: use io-wq manager as backup task if task is exiting
      io_uring: remove bogus RLIMIT_NOFILE check in file registration
      io_uring: ensure openat sets O_LARGEFILE if needed
      io_uring: punt final io_ring_ctx wait-and-free to workqueue

Pavel Begunkov (6):
      io_uring: fix ctx refcounting in io_submit_sqes()
      io_uring: simplify io_get_sqring
      io_uring: alloc req only after getting sqe
      io_uring: remove req init from io_get_req()
      io_uring: don't read user-shared sqe flags twice
      io_uring: fix fs cleanup on cqe overflow

Xiaoguang Wang (3):
      io_uring: refactor file register/unregister/update handling
      io_uring: initialize fixed_file_data lock
      io_uring: do not always copy iovec in io_req_map_rw()

 fs/io-wq.c    |  12 ++
 fs/io-wq.h    |   2 +
 fs/io_uring.c | 428 ++++++++++++++++++++++++++++++++++------------------------
 3 files changed, 269 insertions(+), 173 deletions(-)

-- 
Jens Axboe

