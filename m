Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CB2292489
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 11:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgJSJXI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 05:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgJSJXI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 05:23:08 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19497C0613CE
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 02:23:08 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k1so9693194ilc.10
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 02:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M7zMqBIzaYC8t0KoPaFRCpogFr9O8bSVaG7aPpieQD4=;
        b=mlv/9SgcqSzEsTUZx9aRiX8kkAQ5dvoCcGrbk6YP/JHefD8mEwqyBM1VYGzHZ9CQbt
         jtidmdeeBcV4VbN4G2xxlCnrDicwAvX8SJmS7PwSS3wuzRvKZiKLGuQicQGejlxlSnuB
         u5KPuO5rQuZIcabFcytDQRlyE0mj667ifS/5RYIIMUkhGPMiq1hqB5ORtJHWV44gCvRH
         7X4dxW4mVf2gvtXb+A+JRZOdE/1Hb+vtzNgt2b0NFlWoWum3DMR7BUzB/DTF0Fsm3pcl
         i2WspKoi2wZyTZnUgzIHYAgSBfqZid55HaFPxHD5dRFaaAymjo2//WtkCE3QacYbPQ8i
         LCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M7zMqBIzaYC8t0KoPaFRCpogFr9O8bSVaG7aPpieQD4=;
        b=MzgSVaeEhmrWArzOxS5Jj2c9MOhvr7lwabqsGRwdi/aGGSHMjeXM+CmDFxkjXNOGKk
         DlhIRTegBnmT0W5tNaClsb9dc6WPtvAlPG8UNZHf4mwYzEmRroGWl4PATTkITxyOFAlE
         9kRC34SJ5OmZsKHYLtj/Cve+2U83PfvZgkiibZ4gs7P03NBLRkKb1N83M6wRuxSJRZxU
         lqE2RogeDYxNhbLoxuVmuVfz4G2FZ0Www0vW53/O4tQLaibghrMbtmiVA6ChmRajlhX9
         AHe+/g9BgXqfniIH7Iz5DkDExPYUf9fDnrWNSUEb3/WGXdiOPgWC4SAvKMSNa2eMiy2u
         2d+Q==
X-Gm-Message-State: AOAM533zfe8iBf7nmCZb22cDN5lBqnM51VL6cYW3IEpaf+QAaFUG9/FA
        UPYQKrAyECsGdOeAQjp+qIRzJ3fzzoTHy4l0+TA=
X-Google-Smtp-Source: ABdhPJxGIkaEEmNkCDdDA+n1nnJLFEJi1EMI8Ug7uTfGxLgBJQBjMXMdt2JxEkCXXD/BwUsOZKovV+VDQHJ3I90X2e8=
X-Received: by 2002:a92:c04c:: with SMTP id o12mr2851792ilf.22.1603099387435;
 Mon, 19 Oct 2020 02:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
 <20201001085900.ms5ix2zyoid7v3ra@steredhat> <CAD14+f1m8Xk-VC1nyMh-X4BfWJgObb74_nExhO0VO3ezh_G2jA@mail.gmail.com>
 <20201002073457.jzkmefo5c65zlka7@steredhat> <CAD14+f0h4Vp=bsgpByTmaOU-Vbz6nnShDHg=0MSg4WO5ZyO=vA@mail.gmail.com>
 <05afcc49-5076-1368-3cc7-99abcf44847a@kernel.dk> <CAD14+f0h-r7o=m0NvHxjCgKaQe24_MDupcDdSOu05PhXp8B1-w@mail.gmail.com>
In-Reply-To: <CAD14+f0h-r7o=m0NvHxjCgKaQe24_MDupcDdSOu05PhXp8B1-w@mail.gmail.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Mon, 19 Oct 2020 11:22:56 +0200
Message-ID: <CAM9Jb+gip_ahaA6Chwrt62pkfuJ2HfZki84pPSKEJhaQaSovMw@mail.gmail.com>
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Qemu Developers <qemu-devel@nongnu.org>,
        io-uring@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Ju Hyung Park <qkrwngud825@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

@Jack Wang,
Maybe four io_uring patches in 5.4.71 fixes the issue for you as well?

Thanks,
Pankaj

> Hi Jens.
>
> On Sat, Oct 17, 2020 at 3:07 AM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > Would be great if you could try 5.4.71 and see if that helps for your
> > issue.
> >
>
> Oh wow, yeah it did fix the issue.
>
> I'm able to reliably turn off and start the VM multiple times in a row.
> Double checked by confirming QEMU is dynamically linked to liburing.so.1.
>
> Looks like those 4 io_uring fixes helped.
>
> Thanks!
>
