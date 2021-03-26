Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4DD34ABDF
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhCZPwJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhCZPwD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:03 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A047C0613B1
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:03 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id z9so5416257ilb.4
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6KRW9ZJsq6c47vOf7tfyaofFPNrEfYDeTWDF4l0gi8=;
        b=vt05UeQjQ9LIsj4o4Ij/ce7suEu9EgJkPuxbBa8fOlejCAGJs4Nx6E3/nCYOxTgG5I
         Q+Ash89MMhYzZt2scu+lMsZjRhcZb00DuECcvZYFi4kc41U23pvdiK6B5AwaEtqsttFu
         RYx2zhd81zGIMRK+8NncSlc/xxGqGNI0h5Q8zKLhJ9IPmdJhNY1b4Ri3xZKX4YFQeRaP
         Qf6cXt58FjNaY4DiZIi6vh3Mjt2mnyQ5cq19Lk4m1tl6hPUhVrBHbHCeknQjR4UQufF+
         Cz5XxYk4Ekns+B3HVpi1w3dzEs8VyhG3BEikaB8ZEYbkbq+kNPIeLJ95lbuyhANbINT2
         leqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6KRW9ZJsq6c47vOf7tfyaofFPNrEfYDeTWDF4l0gi8=;
        b=cixPGpQH3bee6Tc/VGjZuik4tuFpUaSHDs9zyP96GUjDsVXgo2QgkfGn/r2ozrEmnL
         9AMXz+e8FJv7eCD7UK4i7zhArsXje7xC+fB3DrDEpP3ZxuOXu/zKslee8HbnI92uvIbY
         5M51GXUmL61UB2yuM6ZiBJBYnkhGwx69LyIt6HXlzN6q0T+pWPLT/avf/JExdpFQS0Oc
         83e7o1zOfFPOy/BImW0sqSEpG7FOjJBV7cKZZndfP4o01yBvxqX3mRd3+sJoYZuJXahA
         9ht5U2kuZrodE2u+hawErLfqIjA7PYjOzsfIMgZ2anWn+5CqfSe/VVqbBO8VGCpEDHej
         3wZQ==
X-Gm-Message-State: AOAM531xagcUC0uyWFf9MQ9L8l7LnFZg8cA/W+NybYu9v2TeY+CfLA+p
        9NTDd5/K6aTMTlsKSO0rX+L+zwtP69Ro+Q==
X-Google-Smtp-Source: ABdhPJxn13EXHCCphWuJEDL0ghhEZUZvikA03Zp89sXlg/MG5i9E2uHwTVIdnfDfC4kmkYS4StiGxg==
X-Received: by 2002:a92:c5a7:: with SMTP id r7mr1080255ilt.142.1616773922625;
        Fri, 26 Mar 2021 08:52:02 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET v2 0/7] Allow signals for IO threads
Date:   Fri, 26 Mar 2021 09:51:13 -0600
Message-Id: <20210326155128.1057078-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

For the v1 posting, see here:

https://lore.kernel.org/io-uring/20210326003928.978750-1-axboe@kernel.dk/

I've run this through the usual testing, and it's running long term right
now. I've tested the cases that Stefan reported, and we seem fine now.

Changes since v1:

- Catch fatal signals in get_signal() for PF_IO_WORKER. This is only a
  problem for nested signals, like SIGSTOP followed by SIGKILL. We
  can't have get_signal() calling do_exit() on behalf of the IO threads,
  they have cleanups to do. Thanks Stefan.

- Move signal masking to when the PF_IO_WORKER thread is created, and since
  we now handle SIGSTOP, unmask that as well. Thanks Oleg.

- Remove try_to_freeze() parts in IO threads, we don't need those anymore
  with the calling of get_signal().

- Minor cleanups.

 fs/io-wq.c       | 24 +++++++++++++++++-------
 fs/io_uring.c    | 12 ++++++++----
 kernel/fork.c    | 16 ++++++++--------
 kernel/freezer.c |  2 +-
 kernel/ptrace.c  |  2 +-
 kernel/signal.c  | 19 ++++++++++++-------
 6 files changed, 47 insertions(+), 28 deletions(-)

-- 
Jens Axboe


