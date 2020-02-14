Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E2015E610
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 17:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392980AbgBNQp3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 11:45:29 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43757 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387652AbgBNQp2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 11:45:28 -0500
Received: by mail-io1-f67.google.com with SMTP id n21so11201663ioo.10
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 08:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AjDTQ++9QAUeFd+rM3tBuggZ7ZACTbI+xzsIgBMTRTo=;
        b=ycrObv7TUf+k9MpCwzfm6tpUYr91Ogua7iMMx/VPIyahPd051i0e8Zamp2+sJc+N8E
         MWpaXBeFRSxAIxjhBIfwlmJ9Utg1WcZFzLFLnGzOTp253vcU4bYZtK/b/xhIKCacawsC
         pTXpDNMaiGidQ5WERxCg9jlO1UvXIF+LkGZQUkpfPaoVfWXxa3ML5a8Ugg8b19dMzAdX
         a0L1qnU4FiUCktmkrosHUiA8C+oKvv1qXOJftnyzBiAoQ6BAEiYP0y77C91rHeryrnYn
         RORh0OoP+qRXz/gK3nZBAbvCPPGW2LqwsQy7WpzUV1diTJlqLQnYYDHhawlkODozl+Hu
         TJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AjDTQ++9QAUeFd+rM3tBuggZ7ZACTbI+xzsIgBMTRTo=;
        b=aRoQ4JgFysFbZ2b7Ay0eo6vG7Xfbxs40H/EVG7ExFVUWPxsXyydpKSyfyY9oBPZckL
         4a5/h0FzW1mNIe9qBGF9MQOmmiZe3+kPvn9cEZEGIAaIBXCF88SsUsNDbMZb7ABiiZfU
         WiwoIW24uVjPnP0ndWAP8Nx2uA1DRsl0u/CiWHKAZ25M6T0tzH+47GpfVKQ6NaBJOZDV
         mE55C5KX9iR0LAgjwukaHUrYPEFwAmhvCqnV74J2UwLEPOgQCwjuFS133p8KljIuj1pb
         VAtugcYWjmxHKrI3YLp0YAihexad6WRpWZhj5pXLbJ41GBi91ErHCnJDeVXDeHv2ZYgf
         jsFA==
X-Gm-Message-State: APjAAAXP+1Sb1HOrAqVRkcXG5V625ukGcziZVkAjQ9NGZWuHERYryIPJ
        tAZjT74hYQReN7HSiDBo2SJLzdBV1yY=
X-Google-Smtp-Source: APXvYqxWJ3CWx/BsESTmCh48/BdVAfeJ6FBaTCG5T4yzDJV8DfeGgXGXDGP+viVJlJzScdgBgSHEEA==
X-Received: by 2002:a5e:c803:: with SMTP id y3mr2905152iol.116.1581698727961;
        Fri, 14 Feb 2020 08:45:27 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q90sm2127344ili.27.2020.02.14.08.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 08:45:27 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.6-rc2
Message-ID: <d72d51a9-488d-c75b-4daf-bb74960c7531@kernel.dk>
Date:   Fri, 14 Feb 2020 09:45:26 -0700
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

Here's a set of fixes for io_uring that should go into this release.
This pull request contains:

- Various fixes with cleanups from Pavel, fixing corner cases where
  we're not correctly dealing with iovec cleanup.

- Clarify that statx/openat/openat2 don't accept fixed files

- Buffered raw device write EOPTNOTSUPP fix

- Ensure async workers grab current->fs

- A few task exit fixes with pending requests that grab the file table

- send/recvmsg async load fix

- io-wq offline node setup fix

- CQ overflow flush in poll

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-02-14


----------------------------------------------------------------
Jens Axboe (11):
      io_uring: statx/openat/openat2 don't support fixed files
      io_uring: retry raw bdev writes if we hit -EOPNOTSUPP
      io-wq: add support for inheriting ->fs
      io_uring: grab ->fs as part of async preparation
      io_uring: allow AT_FDCWD for non-file openat/openat2/statx
      io-wq: make io_wqe_cancel_work() take a match handler
      io-wq: add io_wq_cancel_pid() to cancel based on a specific pid
      io_uring: cancel pending async work if task exits
      io_uring: retain sockaddr_storage across send/recvmsg async punt
      io-wq: don't call kXalloc_node() with non-online node
      io_uring: prune request from overflow list on flush

Pavel Begunkov (8):
      io_uring: get rid of delayed mm check
      io_uring: fix deferred req iovec leak
      io_uring: remove unused struct io_async_open
      io_uring: fix iovec leaks
      io_uring: add cleanup for openat()/statx()
      io_uring: fix async close() with f_op->flush()
      io_uring: fix double prep iovec leak
      io_uring: fix openat/statx's filename leak

Randy Dunlap (1):
      io_uring: fix 1-bit bitfields to be unsigned

Stefano Garzarella (1):
      io_uring: flush overflowed CQ events in the io_uring_poll()

 fs/io-wq.c    |  92 +++++++++++++++---
 fs/io-wq.h    |   6 +-
 fs/io_uring.c | 299 +++++++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 284 insertions(+), 113 deletions(-)

-- 
Jens Axboe

