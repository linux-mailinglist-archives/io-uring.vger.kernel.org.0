Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0235011DB93
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 02:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfLMBU4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Dec 2019 20:20:56 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:39639 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfLMBU4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Dec 2019 20:20:56 -0500
Received: by mail-pf1-f181.google.com with SMTP id 2so530658pfx.6
        for <io-uring@vger.kernel.org>; Thu, 12 Dec 2019 17:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1R6tmvWcEBwZb2GTftoBNDaWJmdCaDgJIQY9cVEdhgU=;
        b=fLkSn9otj1I8OwYo0v2cVIMFcFN0oas1n/u8H+eGjvSR/P5RCnjdzjqzqlo9gAWmWh
         yBs4+0UEetEBCsB3t7swBbg6h4Nju6zHySimp5X3lsQqfs8U/OkdyzriXJMHx2KY/UvL
         QCq0LHPaWGaXRA2NIcKDJUIvGJ38RWLn0PjKR0JqVuo8WI313KyvDoWRaWr6rMgvEP41
         Secs9QNQeB/DbP+JWBivxQWycdgireXSUw9fKuSOOa4z4HQps89UnJUoGkm+YmKdz1SQ
         y7AGaHT5J9Ha6pZQex/Ps8rLNmq1X1T55Q+juZbpSN3aUlcKnd4YTOjR1ypLybp16rQj
         yDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1R6tmvWcEBwZb2GTftoBNDaWJmdCaDgJIQY9cVEdhgU=;
        b=gA9vZeFUqmEvgut2+kklZH0crM4r8BUB2La6wSoOMf1B5e/cubgMLpS9iZmjUo09MM
         8U1yh2ttYbOCRMFbmiuYvV1rQG4RuaCJViyMow6CQymeLCqPowMU8X3f1WAQC5RrlczC
         pYDwinxyZMzwUbicS1UmoC0Jed0toFQTYFxXJ1cmsiZpeJhjSaiNELHbNvqzLzMouO0M
         195HxSs3OAv0sByBjDvVbMhbiM2an0Z3e/7/HLYREWzC+JPzQGN9VfG7Qi2Rpoy3myH+
         20UUsLyPOdYuhIrUUnUgXN49D8c8oQjgx0SEvLUJVOyFURPJ2fSItcXYvtJoWKK25h44
         /AqQ==
X-Gm-Message-State: APjAAAV4TId2ls+JawChfPIBRkm0FwlM2TIWAMYxioUxfwnxSHuVAFog
        R1R/hzHLqgdai0qPodet1Jrk7W9JmWgFWw==
X-Google-Smtp-Source: APXvYqzqngZG2HdvLoFUAQcdK/njq9pztPIF/oQQb0oEG3KMrKNb3IV2VC5Ft+7iTTEdUfhtzadq9Q==
X-Received: by 2002:a63:5818:: with SMTP id m24mr14036375pgb.358.1576200054841;
        Thu, 12 Dec 2019 17:20:54 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e1sm8886417pfl.98.2019.12.12.17.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 17:20:53 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL io_uring fixes for 5.5-rc2
Message-ID: <323b5808-b058-78b3-89d9-146be5f69440@kernel.dk>
Date:   Thu, 12 Dec 2019 18:20:51 -0700
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

Here's a set of changes/fixes that should go into 5.5-rc. This pull
request contains:

- A tweak to IOSQE_IO_LINK (also marked for stable) to allow links that
  don't sever if the result is < 0. This is mostly for linked timeouts,
  where if we ask for a pure timeout we always get -ETIME. This makes
  links useless for that case, hence allow a case where it works.

- Five minor optimizations to fix and improve cases that regressed
  since v5.4.

- An SQTHREAD locking fix.

- A sendmsg/recvmsg iov assignment fix.

- Net fix where read_iter/write_iter don't honor IOCB_NOWAIT, and
  subsequently ensuring that works for io_uring.

- Fix a case where for an invalid opcode we might return -EBADF instead
  of -EINVAL, if the ->fd of that sqe was set to an invalid fd value.

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.5-20191212


----------------------------------------------------------------
Jens Axboe (11):
      io_uring: allow unbreakable links
      io-wq: remove worker->wait waitqueue
      io-wq: briefly spin for new work after finishing work
      io_uring: sqthread should grab ctx->uring_lock for submissions
      io_uring: deferred send/recvmsg should assign iov
      io_uring: don't dynamically allocate poll data
      io_uring: run next sqe inline if possible
      io_uring: only hash regular files for async work execution
      net: make socket read/write_iter() honor IOCB_NOWAIT
      io_uring: add sockets to list of files that support non-blocking issue
      io_uring: ensure we return -EINVAL on unknown opcode

 fs/io-wq.c                    |  34 ++++++---
 fs/io-wq.h                    |   7 +-
 fs/io_uring.c                 | 168 +++++++++++++++++++++++-------------------
 include/uapi/linux/io_uring.h |  40 +++++-----
 net/socket.c                  |   4 +-
 5 files changed, 146 insertions(+), 107 deletions(-)

-- 
Jens Axboe

