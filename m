Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B27823F874
	for <lists+io-uring@lfdr.de>; Sat,  8 Aug 2020 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHHSew (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Aug 2020 14:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgHHSer (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Aug 2020 14:34:47 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55003C061A28
        for <io-uring@vger.kernel.org>; Sat,  8 Aug 2020 11:34:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m8so2892710pfh.3
        for <io-uring@vger.kernel.org>; Sat, 08 Aug 2020 11:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UkhmLPB9NW+lzLfpoTJ6AyTYFao0cMmVK55qXH4shFk=;
        b=RNVDgvpIiCC5jaMTosETgN8oYIsv8Mu8frxFk+9bEbypoNVZeFaa85slxev26npo73
         cQWvgIGSmjduM1s3/Bsn697ygndoTyZqcx2tnjDkKSsCKIiQH/2+NhZ9jocCwebP492k
         HcEPOv2VODWyQHZ8IKz4ugNmHQIgubQdE2Ozb4B0OLvbISBkITlbA5EnHlWGHNTfGw/G
         UWijzGH601xH2eyfoTGqYARhBNIFGcOvWCzvC2JB7xm/oT+yM74I0pV09ZpUb16gsjYb
         Wf5YeX9WJVQektICa4YPDqdwGlXHIifHAau/Rmu3US6JucxfgA/kJr5NhE0TLyf0MyR1
         Oweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UkhmLPB9NW+lzLfpoTJ6AyTYFao0cMmVK55qXH4shFk=;
        b=i23weLyFTDJkKDqhJMEtFoDsvU7jVYHbpRFd5/AdxlV4cOhAK7f8wDvrcBi9vC8jLE
         hE6GisT1oxMz+3Eu2M6PXeYN6nwtM91A27FqjWklab8Zv9y3aAEBaHQn1ajQSHatpZv5
         wZonci00QROK+dQJcKFfv9rC3DWiZrZgrLPfgszr44SpohvQIRvZ+4MSz5qnON0kTKAJ
         Fq/x5bcoo9SN0LvBF+16ZT/rdJ0vQWHahU/ch3dHQNUqgRZ3l4w1rIxf7lMAwwbo5WsC
         L1JdXCkuzyW4XrWHeezltp0RyvhhUSC9FD4qMA0WrlBAXHrRCNVKylWFjYBPoQ8I46Ie
         zS/Q==
X-Gm-Message-State: AOAM5307xC1I6RMEg7qVBq3NMxeoV5m+Ls62TWkptnUc/mi9C5epLoE4
        Qii2/wk4cNfVTPrzsTU9/McCyEKTWVE=
X-Google-Smtp-Source: ABdhPJzGp8fx3c+mZ7PO7MV3eOqybXPrkefFiHL/0ZCTAx5+Dqwyn25QTSUBN0H8r/zPmddom29EnQ==
X-Received: by 2002:aa7:8743:: with SMTP id g3mr18215391pfo.76.1596911683173;
        Sat, 08 Aug 2020 11:34:43 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j142sm17955584pfd.100.2020.08.08.11.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 11:34:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org
Subject: [PATCHSET 0/2] io_uring: use TWA_SIGNAL more carefully
Date:   Sat,  8 Aug 2020 12:34:37 -0600
Message-Id: <20200808183439.342243-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Adding io_uring support to Netty, Josef noticed that there's another
case where we can fail to process task_work in time. We previously
added a "work-around" for eventfd, see:

b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")

but we can run into this dependency issue even without that. See the
test case added to liburing:

https://git.kernel.dk/cgit/liburing/tree/test/wakeup-hang.c

for an example of that. This series adds a split way to call
task_work_add(), so we can use TWA_SIGNAL if the task is currently
not running. This over-reaches a bit since there are definitely cases
where we do not need to use it, but better safe than sorry for now.

-- 
Jens Axboe


