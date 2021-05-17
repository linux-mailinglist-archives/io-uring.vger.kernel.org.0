Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63143828C6
	for <lists+io-uring@lfdr.de>; Mon, 17 May 2021 11:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbhEQJuL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 05:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbhEQJuH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 05:50:07 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF261C06138A;
        Mon, 17 May 2021 02:48:50 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id c14so7697439ybr.5;
        Mon, 17 May 2021 02:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5yHu67Byv9UCNP6IhXlftqzu+4udxTjRSoGhWEGIpCo=;
        b=YhFEQ5CVmVyeQaLPdpEEM5Y/MSh2yuvCEK9SsA6UXLzrZcj5QigyyekL4TdfvpSrJW
         qOjwTjz/ZG0BTTGHQEtwyvO9oOCcG/fM4Q5ze5rs4W0XC2xpOGBDSZOMekobjCKveJlR
         JCzMEeduw1ox2N4L5cC1hERqa9t82Spmsd+YsB2XisNCrjmq6Efj/ucqX8ZNnxBlXOxP
         bJdBDgi0eyw0YyPHwlHiovqd1fkUfM+FMU2yubMCYs7200Gocu6VyOktMFfhKYviUSYs
         yzWIvTm/Yf/nOsLx29FYHKqpmAiVRp1wB40wdXG5xamzyDL+0cp+wJkAGopij1A4CkLI
         tQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5yHu67Byv9UCNP6IhXlftqzu+4udxTjRSoGhWEGIpCo=;
        b=E4mvqgf78dPSBRliWmgcPOcRXNj7NcYFTxTRuqZ0IGIfxSGeVsxvMXVSZok9gD0uix
         eh5ok/teAb188buDlBpxP4Cvfrd/IUdwHRI7yBYpBcyTAbfpOse+keEpTP1lv+yA6+Pg
         z8Lxa8P6UCSD9fbWUfsms8yHZ89gnRALfEfcJCwYKEGNRnpzYpQV71c+LZCg9eCtFJVC
         cn541/WOOkdAYh13PT0Lth7YYkMQ9HrHJulxEmsb3/RHrcxMSh3mq0k4+yovrLFz+QK1
         K0WBaK0m3jWjCN6uHNlZzgT2EOmf9ZWf5pAcRY1TVfVPZncT1V4Mzs1WZaSJ8mX5edbW
         XwIw==
X-Gm-Message-State: AOAM531yZ9+3uHfGrHrOoYHHMphRJKkZTNct+bDlFZg4FIuDyzBd7D+C
        pmyTI0ryFOQdsmOIG6RgWsy29n5oCkKJw8j5yaw=
X-Google-Smtp-Source: ABdhPJxwAltTDHZa7v8H6CFo0Vz9NeUEG903w2+jWy7yZ24UgU/izHDUFVYiqbsKwc4hq+L13A3Xf8mP1SADzPSXbh4=
X-Received: by 2002:a05:6902:565:: with SMTP id a5mr16794745ybt.337.1621244930330;
 Mon, 17 May 2021 02:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210513110612.688851-1-dkadashev@gmail.com> <20210513110612.688851-2-dkadashev@gmail.com>
 <20210514143202.dmzfcgz5hnauy7ze@wittgenstein>
In-Reply-To: <20210514143202.dmzfcgz5hnauy7ze@wittgenstein>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 17 May 2021 16:48:39 +0700
Message-ID: <CAOKbgA6MEMNDFpzqrJs3igxhH0=c+ChezmRX+uZcBk-k-wawuw@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] fs: make do_mkdirat() take struct filename
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 14, 2021 at 9:32 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> (We should probably have all helpers just return either long or int
> instead of alternating between long and int.)

Looks like all the helpers are using int internally, and syscalls using
these helpers return int as well. So I will add a patch to make all of
them return ints.

--
Dmitry Kadashev
