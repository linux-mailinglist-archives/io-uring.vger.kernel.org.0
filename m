Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC7C3C6E56
	for <lists+io-uring@lfdr.de>; Tue, 13 Jul 2021 12:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbhGMKZR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Jul 2021 06:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbhGMKZH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Jul 2021 06:25:07 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C08C0613DD;
        Tue, 13 Jul 2021 03:22:17 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id t186so15010420ybf.2;
        Tue, 13 Jul 2021 03:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kgs8oeW0ycc7IDe+GjR30XYsaqIiXu8BpvcpJrKBeSs=;
        b=I7oetqpzqDLWr7v25D30Nffs2M6CN/1WzcGNM7pfDtvIvLkyMVo8Ey71kuiYWS9SkF
         Q39ykA/VuG0b9K81gZ2GGSNyf8w9k6et/9MQMsFTI70k2hAjMf96XuP5J4kdbV7wObnS
         UzkLJO6mc598z+ZqfuS+gO7AroJ4wIuWHAnz/L2K9peqxwXnv6u/DJUUWg83K4RB5MJk
         EC7em6i3rw66W6r5J63zkHl5MSRR6bD+LcIOGw+1OUITX1Pd1AJamSyUz8Kh1ZCvccxZ
         Jar8Xn5uSz+I5HSA37SvkIWLOZWxeyFW6yCTbRU5a6Jaxsna/OgASpLmWyvabynTtmS2
         bS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kgs8oeW0ycc7IDe+GjR30XYsaqIiXu8BpvcpJrKBeSs=;
        b=shgKUPgp0NqRPF/py2Eaq2P+pIJ6qP9C4kkOV8RpuOy4qeZ0ZqlDtKOQ9qiWNikO1o
         s0WUNJAY4p7tpvbRZh+xgj/YZ8ZuIyTg/0O86PIRq7ZY8AMzXNfrAojijxaKQnhN6nRb
         qZKkyCxbdLUVvgg8Dk9AOBpN4gI738F/drfIkCfdIbShLik9DjgkdAEP1zzPWypCD666
         jexlUx5CtDPSQt+Cq6gysu6gTY9ZeHxaCJC+dhOVkuwVEqwGunTLZm3XYnFaLroPaNKu
         cWHW37eN5FW9tjUK0LO4gn/J4aHjtNnVLUJZCxLGWmrehs/edI5o0YBLfeNoTQQH/oQd
         IVmA==
X-Gm-Message-State: AOAM532joT1ZBmC5FidAX1SPKdnk/IEe0reMEiVyLX3z7ZB1GYbBNO62
        WmukMemGKl/1bVTz1jE/vclhSFNJ+qQxpTF5xW8=
X-Google-Smtp-Source: ABdhPJzmnYKh7dl22yIcgVC4WEmkZqDBluKreERvFIQixKQZfj+rYxhIKhw/+Oh8FzGfrgx7DrQyRkdTJyvTCWyWaXg=
X-Received: by 2002:a25:d296:: with SMTP id j144mr4947077ybg.337.1626171736563;
 Tue, 13 Jul 2021 03:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210712123649.1102392-1-dkadashev@gmail.com> <CAOKbgA4EqwLa3WDK_JcxFAU92pBw4hS8vjQ9p7B-w+5y7yX5Eg@mail.gmail.com>
 <CAHk-=wiGH-bYqLvjMOv2i48Wb1FQaAj8ukegSMLNbW0yri05rA@mail.gmail.com>
In-Reply-To: <CAHk-=wiGH-bYqLvjMOv2i48Wb1FQaAj8ukegSMLNbW0yri05rA@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 13 Jul 2021 17:22:05 +0700
Message-ID: <CAOKbgA7wvQ10owLkLEepFhasDH508LTKVRtyJKSPg2O=s6JPdg@mail.gmail.com>
Subject: Re: [PATCH 0/7] namei: clean up retry logic in various do_* functions
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 13, 2021 at 2:02 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> See my comments about the individual patches - some of them change
> code flow, others do. And I think changing code flow as part of
> cleanup is ok, but it at the very least needs to be mentioned (and it
> might be good to do the "move code that is idempotent inside the
> retry" as a separate patch from documentation purposes)

Indeed, I should have at least included the flow changes into the commit
messages.

I'll send v2 with those comments addressed.

-- 
Dmitry Kadashev
