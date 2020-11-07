Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080D62AA1E4
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 01:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgKGAvs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 19:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbgKGAvs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 19:51:48 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6CDC0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 16:51:47 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id t191so1675733qka.4
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 16:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MidwcJtEuz6EP2nXlGHsa+y3NJw740xoS40pVjjYvk0=;
        b=ddbbMrnsXecAPJYlUgKXbtoGlYHfo6iB0X3wLUgRioeDrqtLE2m/d/c36t3IsPLf50
         dxXQV1VlcIbvayIMgxsOSmeO69PdPcmIfI7CrrYUOAUDAFvUhx2Z0SMJE52LBdJuzKSz
         pJwfb2BVmHLovH8W9Lhy6lrcw5cqcActYUlwc1/0yOQFbY9kE3C9cpj1VUBxwn7A2uOf
         dr402WxqWY0I9RmPH+yDe3dXjWbQdh3cJC9s4+HzN7L1OQicz6s6vxA+g/zNiiE0q0XD
         gVa9Kv9oVbw7BSldPpjTA04/C0wbRxK/aUFK8wCfYm/4VQvoyI2Y2QdEcf6/krjuPW9e
         XurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MidwcJtEuz6EP2nXlGHsa+y3NJw740xoS40pVjjYvk0=;
        b=qmvQRL2nW8hrjVlSF5alFNHEdcGzn5GLNuxckSNP1crh4vvEBeEmE+AuKTWtWhUF1a
         gFsXk1ucOiqnbTDAw9c4+1EO/EHRSb9/tejJA3vMc7P4Kt7ZO3XWJ7DCeDmay1cfXNOo
         EobVNe3yhWBUFYkP/TA7cQ5zPhc7iYzHYs+74uomI46qdaO5f4bPmt4BshfmOClKHxZX
         lCl90eLsgY690HZt/NmG8MHtuCDbKZbZSAdOneU0AtA6S4npIS12pZP+cmaWpi0RNCo3
         waKICzHv0eMQ2DTSXGS9xHlB+hXkNMasPQumDSlVRUmUJD0bN7bzezUMPdV0dXIViFJJ
         qdpQ==
X-Gm-Message-State: AOAM531tw7FgD0cSlAF9PlSewwJpsi+H+pC2M7pyEYHgDJrwMD/f49iY
        VnG/UcRqfN6qS5E5lbOkcGlwKEpAtQavMA7uNM8=
X-Google-Smtp-Source: ABdhPJznWT/622fpVqt2Gsy3Ljgp9iq7IK8X7U4+Zu9u++v3B+dfH7nZM7WMoClwx4oYExuxxw/zqGtAPWtzsaaR1eE=
X-Received: by 2002:a05:620a:24ce:: with SMTP id m14mr4272639qkn.399.1604710305908;
 Fri, 06 Nov 2020 16:51:45 -0800 (PST)
MIME-Version: 1.0
References: <CAAss7+pgQN7uPFaLakd+K4yZH6TRcMHELQV0wAA2NUxPpYEL_Q@mail.gmail.com>
In-Reply-To: <CAAss7+pgQN7uPFaLakd+K4yZH6TRcMHELQV0wAA2NUxPpYEL_Q@mail.gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Sat, 7 Nov 2020 01:51:35 +0100
Message-ID: <CAAss7+rt_mkHhGY=kkduDK58jVZy73yZx8qFYEPOU9JjGaCs=g@mail.gmail.com>
Subject: Re: Using SQPOLL for-5.11/io_uring kernel NULL pointer dereference
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 7 Nov 2020 at 01:45, Josef <josef.grieb@gmail.com> wrote:
>
> Hi,
>
> I came across some strange behaviour in some netty-io_uring tests when
> using SQPOLL which seems like a bug to me, however I don't know how to
> reproduce it, as the error occurs randomly which leads to a kernel
> "freeze",  I spend all day trying to figure out how to reproduce this
> error...any idea what the cause is?
>
> branch: for-5.11/io_uring
> last commit 34f98f655639b32f28c30c27dbbea57f8c304d9c
>
> (please don't waste your time as I'll take a look on the weekend)
>
> ---
> Josef Grieb

I forgot to mention that same cores are running at 100% cpu usage,
when error occurs

----
Josef Grieb
