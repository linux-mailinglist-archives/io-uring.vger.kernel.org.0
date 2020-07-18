Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2A0224DE2
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 22:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGRUsk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 16:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgGRUsk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 16:48:40 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EB0C0619D2
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 13:48:39 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f18so21579902wml.3
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 13:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSBlxmJMuFZpNpktd7cbz73sBWuqJUwwofJfRglgo/E=;
        b=IYma4PnkkcFmf1wVYiH0V9z2ySfea0II7kg+V8RObXTyLvhX7D7Sg7HJUkWURfIBkO
         s8W1f6o9+pq3uH9XA6JaP6zQIjQk/wkB+AF8k2LkAmHkNxKBqR1xUYE5YuB1Ao+JPjsD
         M3PqSbTzSzQKl/aEOmT8ISf4dnxwxCjR+PrmrTdEcf0A528Q72poCc2hFniH3EmmrhRw
         XWAzjn0nnVr63Gj9kXNzRmCOiQYfEupk98GHNn3iGh5y4juKARg52sFo+/z0jP5oLjVo
         c9zg4p5tmQ3tWQOCi+VJ96Aopu9JOFxUSjRkl7EEuik3QBSQpK2hashd4wjVNvtUH9Ip
         SY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSBlxmJMuFZpNpktd7cbz73sBWuqJUwwofJfRglgo/E=;
        b=SJrN0cRtIEcB6VDTVA5lve1kNlrwIyB+x4eABMbql2WTCLlCmEY1pKAcZ5yuy7IrLB
         oP97peChV4FD8g28Tbxd0GhWyTsaZM1sIJzdaMuJ3B4ZmvQl52IDKra7z2tAuRvRtwb+
         kYS0Iktg07KaewpcqAXEX2kVnqBiUkJIi0C3aac8rzExkhWA9O4LKLrWiNUI5H5AqFIZ
         uQaW1jUron5V6+FlSEcMY5MI0Xmf+k4/vBVo621jGwASWZzorVjyuHIGa8l6SzXgvlzJ
         YxWlgJMhe1CZ9U9JB7NhaBIEei9NSaRURUqkCIzs5u3L/f3EqAkfQBvp8e1DzqjoP5X3
         XEAg==
X-Gm-Message-State: AOAM532UpMi+ZdXnZMJegxi8TThn2E3yW8vbcmg6aySdFx+i9na4NqE5
        Hl1X9Q+5ttmPYwFI5C6lIVyyrK48EbvYZjcKLk4=
X-Google-Smtp-Source: ABdhPJwfglR0/mC9hHt016JifSQDzzxUMlDVcSFoCzCF1kONsXdm56aHJ9K6KDyZzHtAKqt4L89u/YRmN/43EAxrXe0=
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr14709577wmh.130.1595105318434;
 Sat, 18 Jul 2020 13:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
 <CAKq9yRiSyHJu7voNUiXbwm36cRjU+VdcSXYkGPDGWai0w8BG=w@mail.gmail.com>
 <bf3df7ce-7127-2481-602c-ee18733b02bd@kernel.dk> <CAKq9yRhrqMv44sHK-P_A7=OUvLXf=3dZxPysVrPP=sL43ZGiDQ@mail.gmail.com>
 <4f0f5fba-797b-5505-b4fa-6e46b2b036e6@kernel.dk> <CAKq9yRjwp6_hYbG3j11ekAg_1iJ8h_aLM+Kq7uCmgYvOHESFaA@mail.gmail.com>
 <9a7105c2-261b-3c0c-ed03-fa0abec48861@kernel.dk>
In-Reply-To: <9a7105c2-261b-3c0c-ed03-fa0abec48861@kernel.dk>
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Sat, 18 Jul 2020 21:48:12 +0100
Message-ID: <CAKq9yRikzb3S_U2RJYsuxj34VrGfi0xVeXu1LRjnUSy9jX+DcQ@mail.gmail.com>
Subject: Re: [PATCH] io_files_update_prep shouldn't consider all the flags invalid
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 18 Jul 2020 at 21:23, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/18/20 11:29 AM, Daniele Salvatore Albano wrote:
> > On Fri, 17 Jul 2020 at 23:48, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 7/17/20 4:39 PM, Daniele Salvatore Albano wrote:
> >
> > I changed the patch name considering that is now affecting multiple
> > functions, I will also create the PR for the test cases but it may
> > take a few days, I wasn't using the other 2 functions and need to do
> > some testing.
>
> Thanks, I applied this one with a modified commit message. Also note
> that your mailer is mangling patches, the whitespace is all damaged.
> I fixed it up. Here's the end result:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.8&id=61710e437f2807e26a3402543bdbb7217a9c8620
>
> --
> Jens Axboe
>

Oh, I am very sorry about this, it's gmail in plain text mode, I will
double check the settings.

Thanks!
Daniele
