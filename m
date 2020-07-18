Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4537B224D57
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 19:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgGRR3e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 13:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgGRR3d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 13:29:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BC6C0619D2
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 10:29:33 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id c80so18614642wme.0
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 10:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zxR/M1uGKBQ+DjHs2ip29WULr/5SFv0EuoLzf8ctuBo=;
        b=VaL2r5sby0VGu+2FRNrp4ZuIfDdWl79oj6P43+WAqBtwPNx/5YXbocDlX3QXfE6vl0
         XEVQ7ABtV47yWJprJupE6dknVcVdZefnDSz4SyjmOVZ0hTbDe48oCkZE/UK84JZIButG
         Z5p+v6Wy7/mT4pCIhWgFMQXlRnOKNXIWi3PX2njNIGuNIZsnPLqLVir5KHK7AIB7+Qfv
         VY0awD8g+iLhN0AMhR4ywKuo7GYygrPBe37OSVaUmkYyVDl6p14zJ5Hfj9laqRtP8wRz
         B6u8e8ZzF4966R9J/TT0vzzvxdRDVGfK54J7WqsNvSrDcomHEmuiwjPp+a3sFPopDTTk
         3HZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zxR/M1uGKBQ+DjHs2ip29WULr/5SFv0EuoLzf8ctuBo=;
        b=MJgmHp66ZbMJ+CRCvRqmAaX/cACF6WTwNsK7n3ngzslfzIdCVGt3VGpPBxROylG6sj
         LQGkXIeBvFR3uQd+hDPYW5t6jEEJGBl0oNKZppR8lsZqD3aKbrdV8gOx+9VX/Mdyn6FB
         zvfWXbLzYDcoZFvexNCgigRI144ISPlAXtDWfb5+2apbtegHMK2FyQ0kkJt91mixQWhn
         9LHstdYMK8984E4sjtaKoDPpEAQvrQjy0tzroCsJNASlH34Uz/uUebQlDPtUOYKdg09j
         2z1NIeqfDP08KrXaumdA5/paaheI1nh73xDHa/uZVkjt6zL5K6FrwqwJF/kfSAeZXMG3
         6fXA==
X-Gm-Message-State: AOAM532W9zwJsKpEzIL+J8muEvl1cSqocUv/fKHoV1RsfRavOG4PcWf0
        +6OYjNlr7o3IPYLH+1PRH49iWvJYbRYWbwEjsLZnt/gE
X-Google-Smtp-Source: ABdhPJyVj7pMOUc517EiLtJiJfv5vrodYznhD9/GF9hXyVPG/JqNmWktpfPB/sbBV+iAQJ7mnFBNUHWfoYjQnu6kQYM=
X-Received: by 2002:a1c:e143:: with SMTP id y64mr14195647wmg.90.1595093370931;
 Sat, 18 Jul 2020 10:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
 <CAKq9yRiSyHJu7voNUiXbwm36cRjU+VdcSXYkGPDGWai0w8BG=w@mail.gmail.com>
 <bf3df7ce-7127-2481-602c-ee18733b02bd@kernel.dk> <CAKq9yRhrqMv44sHK-P_A7=OUvLXf=3dZxPysVrPP=sL43ZGiDQ@mail.gmail.com>
 <4f0f5fba-797b-5505-b4fa-6e46b2b036e6@kernel.dk>
In-Reply-To: <4f0f5fba-797b-5505-b4fa-6e46b2b036e6@kernel.dk>
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Sat, 18 Jul 2020 18:29:04 +0100
Message-ID: <CAKq9yRjwp6_hYbG3j11ekAg_1iJ8h_aLM+Kq7uCmgYvOHESFaA@mail.gmail.com>
Subject: Re: [PATCH] io_files_update_prep shouldn't consider all the flags invalid
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 17 Jul 2020 at 23:48, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/17/20 4:39 PM, Daniele Salvatore Albano wrote:
> > Sure thing, tomorrow I will put it together, review all the other ops
> > as well, just in case (although I believe you may already have done
> > it), and test it.
>
> I did take a quick look and these were the three I found. There
> shouldn't be others, so I think we're good there.
>
> > For the test cases, should I submit a separate patch for liburing or
> > do you prefer to use pull requests on gh?
>
> Either one is fine, I can work with either.
>
> --
> Jens Axboe
>

I changed the patch name considering that is now affecting multiple
functions, I will also create the PR for the test cases but it may
take a few days, I wasn't using the other 2 functions and need to do
some testing.

---

[PATCH] allow flags in io_timeout_remove_prep, io_async_cancel_prep
 and io_files_update_prep

io_timeout_remove_prep, io_async_cancel_prep and io_files_update_prep
should allow valid flags.

Signed-off-by: Daniele Albano <d.albano@gmail.com>
---
 fs/io_uring.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba70dc62f15f..3101b4a36bc9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5010,7 +5010,11 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 {
        if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
                return -EINVAL;
-       if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
+
+    if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+        return -EINVAL;
+
+    if (unlikely(sqe->ioprio || sqe->buf_index || sqe->len))
                return -EINVAL;

        req->timeout.addr = READ_ONCE(sqe->addr);
@@ -5186,8 +5190,11 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 {
        if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
                return -EINVAL;
-       if (sqe->flags || sqe->ioprio || sqe->off || sqe->len ||
-           sqe->cancel_flags)
+
+    if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+        return -EINVAL;
+
+    if (unlikely(sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags))
                return -EINVAL;

        req->cancel.addr = READ_ONCE(sqe->addr);
@@ -5205,7 +5212,10 @@ static int io_async_cancel(struct io_kiocb *req)
 static int io_files_update_prep(struct io_kiocb *req,
                                const struct io_uring_sqe *sqe)
 {
-       if (sqe->flags || sqe->ioprio || sqe->rw_flags)
+    if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+        return -EINVAL;
+
+    if (unlikely(sqe->ioprio || sqe->rw_flags))
                return -EINVAL;

        req->files_update.offset = READ_ONCE(sqe->off);
--
2.25.1
