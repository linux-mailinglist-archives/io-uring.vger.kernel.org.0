Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316EA3E37A5
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 02:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhHHAOw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Aug 2021 20:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhHHAOw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Aug 2021 20:14:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7544CC061760;
        Sat,  7 Aug 2021 17:14:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso133139pjy.5;
        Sat, 07 Aug 2021 17:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnFgqgDmT/V4c/zLfpNtBbyVZkh3iobp61ysMleZsHY=;
        b=FtBcwRMxPJXP/EfG4YMfGYnjKc5DQYG/fhfHr8MHZ5+S5J+8OIDjgp9dRE4A79qR6c
         FUGAo1g6Glm0VsLAyzeryeUYoEVWeE2wnO40vRS2rTEIGw0BewQgJjiGvUOmciRxjxMk
         fhEhVuOpg943ikBK8dXQSGmJw0v4/si83dYpFxf7k88z5nCSy+8u9Q7KljQaioSTrdUf
         Pda14wsf0huvaWqRyzGXj0szNOCJQmhhgxOP/c74FJkvoakcTkZBzlfcyjhCcZ0mPdRu
         irXi6gPbXMjDh+yg4GeK2bNyI459qhA/ZvlIlhh4Eft7EPHdRUnlHYMDbBDcNkSgz5o0
         lymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnFgqgDmT/V4c/zLfpNtBbyVZkh3iobp61ysMleZsHY=;
        b=ePSTl/Fd7TCcyuOSIHKI+4uXSTaIu4mfcytqJtaKAVVv1dS6iOBQjv9c/ydD1DnCyW
         L8B4ZJWdkFSIEHrFQ3iJpmhCU+b/+tFsqgy1TnXqmiXpSLmykRQ3dT7b8GW9eVWtLSon
         R4e8L1rN1Y9TqQJIxB7c4Vh/skKWc1SM+goLyuYG3hgbRqbdx1eQjsA4U5ajDjSrZMIT
         7lY8GOuzFOay8lK81LoQ2zaWh/UIdWyYLZUoPiQE2vhfvvubpHFIktud5PsSufvwxDdk
         sMSOdmPpz1r7c78c5B7k13r9sxBLAw77YuRT2Muh8hexqBIMXKkn/G8kqs99zwk01IkZ
         Vfzg==
X-Gm-Message-State: AOAM531L7oEQECY7TTRxcZsls9MJnAPIh/WrEf0y/CwH+y+Kfdfmr9hu
        uhovatfmCqhszFLN50oaoaQ=
X-Google-Smtp-Source: ABdhPJwnD7t4fRx+P/KVAYylu7IxTPO2g+Bub7YhSAx0DL38ML0RoqO3m6+3NSD9kFpPIPJxXk8YbQ==
X-Received: by 2002:a17:90a:43a7:: with SMTP id r36mr3634210pjg.187.1628381673653;
        Sat, 07 Aug 2021 17:14:33 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id u3sm16624278pjr.2.2021.08.07.17.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 17:14:33 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 0/2] io_uring: bug fixes
Date:   Sat,  7 Aug 2021 17:13:40 -0700
Message-Id: <20210808001342.964634-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Two small bug fixes. The first fix is for a real issue that encountered
on 5.13, which caused my workload not to work with a submission queue.
Apparently, on 5.14 it is only a performance issue (i.e., not a
functionality issue).

The second fix is for a theoretical issue.

I did not cc stable, as I leave this decision to the maintainer.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>

Nadav Amit (2):
  io_uring: clear TIF_NOTIFY_SIGNAL when running task work
  io_uring: Use WRITE_ONCE() when writing to sq_flags

 fs/io_uring.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

-- 
2.25.1

