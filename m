Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E176740B065
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhINOTj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbhINOTN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:19:13 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1258FC061762
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:17:56 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f6so17316789iox.0
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f5uF7ATgVNfFvWMsYEORJBCsWjk2FRiRSwzPjSSzcDM=;
        b=OBpciB5HsUyjAxzRKo2BhNM4889PVjfOH9QI1LE4PDi/shB5f8PD21eya+LirYMlJi
         wknm3h68ybZKIxnSbui+aOEwqxEdOeWKHqHdQAp+p8BLM/hge2cYRA4M+YpGJBiYGbo6
         r8sdMHZVUDINLvSr5kqOUwhK9xcHrSBwMvlvBndQOo9YXzt5fMNpYIgJwA1m5IWlgall
         RI97mHETZxlINtBT3ymwtjgjD6Zh8fHEOUwy4chK6i8RaS2b5jiV/7SZL8rZhkT0YcNE
         quoPvL1zzyg7ldE3s0CA0u4MEm+oGbvVnF61L9pbYjiLyZaHoeNHp9jbMi7Nh8I3p9nV
         EH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f5uF7ATgVNfFvWMsYEORJBCsWjk2FRiRSwzPjSSzcDM=;
        b=rQlrrqQd2619yQKDIMIQhb/2H+zkxE65lA/hAxpZbmG0tOGJgT/jfiWm/sw9phDMqs
         JFys2zNI2Fhg/2KI7DLys986ZJwPtZgfVXp7R07yJ1tN4p0dI2K1cr3b19QQp7eIheMB
         9tZegO3odmRryP24PgR1+LDI49e9zhAocd/oivDsWu6DCZceAErTXrnuG9tBeIg0qyy5
         m+lGmDoW/8IeBcGBjC/TzyLxNdDgRGEciiUUM8+ZQZa7Wfx0en7WK/v7OAazBL92gZS9
         qdA+t/Z3faSSJ3MTuLgVT/l6jlb76nw09ymFwoDlS6P6lV9sDbz5GHCmLXf/29/xud26
         4Jxw==
X-Gm-Message-State: AOAM532PCDr1ITH61xXKKtm+16/WzN1omyISN1l3We9BO8A8qbpFZpu7
        MVhx8iS7kfyuzsughDzVcssqDag7/gSxHnBvu4o=
X-Google-Smtp-Source: ABdhPJwDGerk8uV/RnTgN/Aew0/bzOWqk178UH3J6YlOvZYVu1SwSb1nNDLtMQzvmyhoRxOYQbhEgw==
X-Received: by 2002:a05:6638:2395:: with SMTP id q21mr14939292jat.122.1631629075221;
        Tue, 14 Sep 2021 07:17:55 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p135sm6673803iod.26.2021.09.14.07.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 07:17:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: [PATCHSET v2 0/3] Add ability to save/restore iov_iter state
Date:   Tue, 14 Sep 2021 08:17:47 -0600
Message-Id: <20210914141750.261568-1-axboe@kernel.dk>
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
conditions often, and it seems to pass muster.

For a discussion on this topic, see the thread here:

https://lore.kernel.org/linux-fsdevel/CAHk-=wiacKV4Gh-MYjteU0LwNBSGpWrK-Ov25HdqB1ewinrFPg@mail.gmail.com/

You can find these patches here:

https://git.kernel.dk/cgit/linux-block/log/?h=iov_iter.2

Changes since v1:
- Drop 'did_bytes' from iov_iter_restore(). Only two cases in io_uring
  used it, and one of them had to be changed with v2. Better to just
  make the subsequent iov_iter_advance() explicit at that point.
- Cleanup and sanitize the io_uring side, and ensure it's sane around
  worker retries. No more digging into iov_iter_state from io_uring, we
  use it just for save/restore purposes.

-- 
Jens Axboe


