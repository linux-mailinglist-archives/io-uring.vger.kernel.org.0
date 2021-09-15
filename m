Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD2440CA13
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhIOQbD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhIOQbB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:31:01 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD687C061575
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:29:42 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id b6so3628655ilv.0
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UxuAkQ4ZtEcbC+XH0J5oJ2exv4p4EDf6m4KsjfHsOSo=;
        b=d4BsZUAHcQWlZRxgHrvDbCkMmPZAsdoZEzZwBDP59rutjmrLeTwIz9qARf8OewK3Wp
         UxlKzMP6tmWPE0mCM9Q4F2zGQyT2i3Ev6sXkU5QOHBREW0B5VCJ4qpMo3+Q5WqNKov0L
         CE0ELiE7emZ/v6aKI7PcDb047fIHhoXlqb/zXSmoYs5ed0735klf8/Yc2lg2/3dLtwMn
         yUJQ3h54j8Ii13o7kAo3eI8veZkHtNpGANTM3p/MeZWdLyXRbu35e/+4GJQUC2lCqvlp
         bL+G8ppx7fKbrlkHl+uqCiCwBv1WXNiGD0BiT88oBrDhF1dGw65qIo4qALhcdC/J3HeS
         lAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UxuAkQ4ZtEcbC+XH0J5oJ2exv4p4EDf6m4KsjfHsOSo=;
        b=CowE0b611prH32oBkAX7b7AOYhCZYldBFEwATbmReJI8BbEbvv4Ucewvkcov2l9c+V
         Oppqoh776gH1NWTdNNkHbRBLX1aMmQdn3ELArEGOAwv8jIYanYa01XFm0JNsCEJpGhiP
         jnNo4HRedwTnZe/nlCYKQQuRl2TwZX7rE+Y0WeKL7YKGuZDbSggPsGWdGI5wGl8CZktq
         4SOy02DQcOpjMKTzTWEJD3yrTi8mU9Ig475sVdjWvA82gVIAb7CxifxKjaDtQb6n4Ubj
         JBQIWkVZauO7cshuJl8uJglD4rRvJ4QRCsu+32e3Ytuz2jzyw9nNDgJbp/8Rtp1rvd4v
         fnBA==
X-Gm-Message-State: AOAM530LVy02G+lLycqpkchcn+HkrrwHkebbPVaiudNCqkphmgKP6hni
        dJ231O5sXh7HnWOj8qQWmvo8/MHpP892PtMxbv4=
X-Google-Smtp-Source: ABdhPJzUsCoNUfzqz1dDtv0AlqnIYxxmDSmXZINr6v8l7jYvuEsMjmwaot8J1UrnGWEzrIFvxKmPsQ==
X-Received: by 2002:a92:7114:: with SMTP id m20mr687074ilc.114.1631723381941;
        Wed, 15 Sep 2021 09:29:41 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t15sm227160ioi.7.2021.09.15.09.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:29:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: [PATCHSET v3 0/3] Add ability to save/restore iov_iter state
Date:   Wed, 15 Sep 2021 10:29:34 -0600
Message-Id: <20210915162937.777002-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Linus didn't particularly love the iov_iter->truncated addition and how
it was used, and it was hard to disagree with that. Instead of relying
on tracking ->truncated, add a few pieces of state so we can safely
handle partial or errored read/write attempts (that we want to retry).

Then we can get rid of the iov_iter addition, and at the same time
handle cases that weren't handled correctly before.

I've run this through vectored read/write with io_uring on the commonly
problematic cases (dm and low depth SCSI device) which trigger these
conditions often, and it seems to pass muster. I've also hacked in
faked randomly short reads and that helped find on issue with double
accounting. But it did validate the state handling otherwise.

For a discussion on this topic, see the thread here:

https://lore.kernel.org/linux-fsdevel/CAHk-=wiacKV4Gh-MYjteU0LwNBSGpWrK-Ov25HdqB1ewinrFPg@mail.gmail.com/

You can find these patches here:

https://git.kernel.dk/cgit/linux-block/log/?h=iov_iter.3

Changes since v2:
- Add comments on io_read() on the flow
- Fix issue with rw->bytes_done being incremented too early and hence
  double accounting if we enter that bottom do {} while loop in io_read()
- Restore iter at the bottom of do {} while loop in io_read()

Changes since v1:
- Drop 'did_bytes' from iov_iter_restore(). Only two cases in io_uring
  used it, and one of them had to be changed with v2. Better to just
  make the subsequent iov_iter_advance() explicit at that point.
- Cleanup and sanitize the io_uring side, and ensure it's sane around
  worker retries. No more digging into iov_iter_state from io_uring, we
  use it just for save/restore purposes.

-- 
Jens Axboe


