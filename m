Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AF521F843
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 19:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgGNRc4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jul 2020 13:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgGNRc4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jul 2020 13:32:56 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133B1C061755
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2020 10:32:56 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r12so23385854wrj.13
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2020 10:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wH4RY0q2yG+Q2hgzUnzTMsY+pAlXkLBMRhCghbUnpQc=;
        b=tfAzPYAUWUqHakS+gPp6Knv0Fm/9XIvvU2uciCN51CxSmMal86m45oiDdxDrBmyYbu
         WRDDwv70XR8SLxTL5qysv0ECoKgtNd8VoTZGe0f2CSACMO252Nkf5A2rLA3jbSanu0eI
         OaerQ+7YeSUeoXZwZgiL/1NfFEOTJZz7xcq/4w+DuHi7QQcc4XT0jHmNa6/i5SRsjXj5
         5DHbdlaVPCuL+8tITrhsZJlRDe7+UtJE3cC8c0lhTmz4+gHGUQY4D+NreMWW96rkAnn3
         qpUDaUOyPlonacwzKpUZ8Oe3qe8uZoQwp+oi3yNxc8Vw/LARPdJQ8YWimD85w8n4EP6m
         8nEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wH4RY0q2yG+Q2hgzUnzTMsY+pAlXkLBMRhCghbUnpQc=;
        b=kC95EOjPq0d0iTAiA1P74gGj5xAMFfpdIJkdlJDwBxjTpsx2VwTtrj2iTrW9qekCjJ
         3VCVDr5ZJtZF5co6eXW2vezLGdP0GImnl7+IeOarBYuVuIrfPXTy+r4E7SmmUJ6TCXmb
         44AL3KMW2FwYVZ4T0rRxZMW0fYD0WyXwNTlw3TOAseQccVrz1w4uDfZSp377DJoAS4gx
         FfB8+4RSVx3l44G4mtislf8h1iuR6iarC0JA8ePPEMSbKtriW3AH61YfiEfb6bC+JGkZ
         gd8ODt4O/taUpaORqhDPPmcra4v4Bq0vwV7wl7qMYlUM6NIECJ6L28f38nSHKM084HRs
         gMTw==
X-Gm-Message-State: AOAM530fXWcCS7mSt36NTrbp6Xaoe0S76wcFbmbTFjBSqOrwGU0FhzVU
        AadHx+thspJOpw0tZC7dQ8KA2u9luR/OaVIhS7dD7kZF
X-Google-Smtp-Source: ABdhPJxMuQYrmGKVy1C1g1nh+h94TVD9dykLnfWBsOU4si4X6RlIxUourChfzc0Yovufrg95JEBeUFyXqYUGxXpZ0Ag=
X-Received: by 2002:a5d:4591:: with SMTP id p17mr7109298wrq.343.1594747974321;
 Tue, 14 Jul 2020 10:32:54 -0700 (PDT)
MIME-Version: 1.0
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Tue, 14 Jul 2020 18:32:27 +0100
Message-ID: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
Subject: [PATCH] io_files_update_prep shouldn't consider all the flags invalid
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently when an IORING_OP_FILES_UPDATE is submitted with the
IOSQE_IO_LINK flag it fails with EINVAL even if it's considered a
valid because the expectation is that there are no flags set for the
sqe.

The patch updates the check to allow IOSQE_IO_LINK and ensure that
EINVAL is returned only for IOSQE_FIXED_FILE and IOSQE_BUFFER_SELECT.

Signed-off-by: Daniele Albano <d.albano@gmail.com>
---
 fs/io_uring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba70dc62f15f..7058b1a0bd39 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5205,7 +5205,14 @@ static int io_async_cancel(struct io_kiocb *req)
 static int io_files_update_prep(struct io_kiocb *req,
                                const struct io_uring_sqe *sqe)
 {
-       if (sqe->flags || sqe->ioprio || sqe->rw_flags)
+       unsigned flags = 0;
+
+       if (sqe->ioprio || sqe->rw_flags)
+               return -EINVAL;
+
+       flags = READ_ONCE(sqe->flags);
+
+       if (flags & (IOSQE_FIXED_FILE | IOSQE_BUFFER_SELECT))
                return -EINVAL;

        req->files_update.offset = READ_ONCE(sqe->off);
--
2.25.1
