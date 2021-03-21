Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CEF343383
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 17:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCUQi5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 12:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCUQiT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 12:38:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9D5C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 09:38:08 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so7307332pjb.0
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 09:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5N9DOBNg5q+cX1nThPiWZ6ZK66G2Hs/lXfr1BIfQ6bI=;
        b=bok2Rpaa9lxPeYRNWQ9PjghCs+hzkICxgl0Hn8gfGAClySVtOu/lZkblCXdwOzT4kO
         Rjxvm8u3hr/uMYQd1fKwQwbO42MVQf9Jf2ysChYin6eJfpta73UelDBQj4n0iQW96xOd
         aBqZKu+50MDz/H69LifB27M3SIY4QWzTSyDBX+eNeouC0lLiz98VnO0iAU9Raz/6fw7W
         KrwnluO+bclyegl5mCcz5Go3Px30KdZ/P9K0+51RxJgYo3wDvvrY97aMyp0StQmY6bJG
         LKhS8Z2beZKXrakBAKkE70uVe3/H1zZkd1msW7RUeQNPlIA4XArh4B+6C7llacVLgjed
         DSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5N9DOBNg5q+cX1nThPiWZ6ZK66G2Hs/lXfr1BIfQ6bI=;
        b=bezmXnR5NJYivfbW1d0zZvEMptVy9E10LzxIXkfT67k3LuafrkGr5HUpbh3TCtM7Du
         BJwHXUZz+ksbW/e45KAyY9tVUfAG2AadscjbbFHYK0u/etETech0BflBTa4DUezBsMRU
         wDLu1xJLNDzocj3TxPmEK/hViOplnAbaw7jLKBLxDYkyTnIqjXx0XN+0CFJghC910PNX
         WNgVoV+if47svrV4OZXfgFpjz2CeBjKjm8JKC7RTNODdhcyC3PbgzD7W0Er+SxLTvMSS
         At74pZ6GmF45nW+Hc2vs1CYad2Itr9QnXNuD86GShWAozuBZhsBsk7UFe9oJ1bpF0gTL
         vEuA==
X-Gm-Message-State: AOAM532b+jIkAarXw+UAuyCnJsziSwjnWPTqZ6iaAIH4Qd17lA9vHMzp
        ipTxgnIw/53W9mC0RSFTiIBoIMC5eW7dtQ==
X-Google-Smtp-Source: ABdhPJx5jlTHtmIllV5ZH3877irJ+uzY0PbBmrzJHKndmknI0bZRvO0j/dVfEMtXZLt0W1dxcHzLQg==
X-Received: by 2002:a17:902:ce8d:b029:e4:bc38:c4 with SMTP id f13-20020a170902ce8db02900e4bc3800c4mr22778542plg.48.1616344687261;
        Sun, 21 Mar 2021 09:38:07 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c6sm12165070pfj.99.2021.03.21.09.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 09:38:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring followup fixes for 5.12-rc4
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        io-uring <io-uring@vger.kernel.org>
Message-ID: <ea7f768a-fd67-a265-9d90-27cd5aa26ac9@kernel.dk>
Date:   Sun, 21 Mar 2021 10:38:04 -0600
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

Was planning on holding these for -rc5, but I think we may as well
flush them out. In this pull request:

- The SIGSTOP change from Eric, so we properly ignore that for
  PF_IO_WORKER threads.

- Disallow sending signals to PF_IO_WORKER threads in general, we're not
  interested in having them funnel back to the io_uring owning task.

- Stable fix from Stefan, ensuring we properly break links for short
  send/sendmsg recv/recvmsg if MSG_WAITALL is set.

- Catch and loop when needing to run task_work before a PF_IO_WORKER
  threads goes to sleep.

Please pull!


The following changes since commit de75a3d3f5a14c9ab3c4883de3471d3c92a8ee78:

  io_uring: don't leak creds on SQO attach error (2021-03-18 09:44:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-21

for you to fetch changes up to 0031275d119efe16711cd93519b595e6f9b4b330:

  io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL (2021-03-21 09:41:14 -0600)

----------------------------------------------------------------
io_uring-5.12-2021-03-21

----------------------------------------------------------------
Eric W. Biederman (1):
      signal: don't allow STOP on PF_IO_WORKER threads

Jens Axboe (2):
      signal: don't allow sending any signals to PF_IO_WORKER threads
      io-wq: ensure task is running before processing task_work

Stefan Metzmacher (1):
      io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL

 fs/io-wq.c      |  8 ++++++--
 fs/io_uring.c   | 24 ++++++++++++++++++++----
 kernel/signal.c |  6 +++++-
 3 files changed, 31 insertions(+), 7 deletions(-)

-- 
Jens Axboe

