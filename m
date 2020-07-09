Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB321A724
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 20:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGISh1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 14:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgGISh1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 14:37:27 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA39AC08C5CE;
        Thu,  9 Jul 2020 11:37:26 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w3so2902985wmi.4;
        Thu, 09 Jul 2020 11:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OMGEMeGfAwPhTFPRetOj75ZLR45+mAQXFuKMt68C8r8=;
        b=giSHD299a8hMU3ZjDONC0HBAizczD9K3goGSzFE/0p7Lowo5hC7pkDs1EudXvfvhrN
         O/FPofYUjdhQvjLFLXxzhbRP+G9M2vUmi/UBDXorCwp5ntNdiyIKB0w6oyTjwsI/X3bu
         ztnuaRZJi1bUMR/CAY312CZdcAuGTJ8xQT1G/Gt4XWNr+pWIWvzAWMlIHzRX6NfRHr7l
         +ZaGFEGgM0rrGW4p+OKx+dPgsmUmjoEaDnbmWLggcCIsu4N+GUWLgskMJMh37WnpXEq0
         qnfHtSbZWx441j/esSsVxuOTS8yyUKFtOiL136U1XxM9Ra1JZm4oUo3p0lVZ6v1PFUMf
         gQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OMGEMeGfAwPhTFPRetOj75ZLR45+mAQXFuKMt68C8r8=;
        b=KX9Kl5nimAacKqzDZqh56VCrVG05PddMxjDp8GkE7SQrXxEw8jk/EXiq6m/F0ITkzN
         FDhi2q0RH+bCk86Pf3CBHBPUfm0IYSZOavlgSfApZLgZC+CIuTLCAlfxI+gKYhulayDi
         /WsBGx4U5QCVYHths5kI1HzgePaSQA0fq5IZygfiigygf6rl/wME5JEFFJgrxtbNhAtb
         Iu0cgTLd4WUDODw1xeAhkKtxEPrDs4RNCfZONXTfgwZ/5Ne+oZJRcKr+7WvCZ2+vymJ8
         Byr2nw9KkhKkvNp1ZRAr4nED0FZooEs1i6h170Mp0q9hhPQGK/sbnXqfBPkBvwri3RmD
         gikw==
X-Gm-Message-State: AOAM531k0sg7fQZ1RSvSsYDrsQqXwYrb/rKZYxnrxqSjf7PG0KK+SxGp
        4+teXwkhRGBCqBLWHW7rI9Y7Fpy8DbYDCO7rOIWE7g5lP6o=
X-Google-Smtp-Source: ABdhPJzDP5YcdGanoRDlPNrDu6TVvP9HvZ9UeeRKVCdJ6D1EXd2WRKqnQaQr0b03+fW0/Qv4BxLM7njlu8TG1dKiuEA=
X-Received: by 2002:a1c:2485:: with SMTP id k127mr1276685wmk.138.1594319844998;
 Thu, 09 Jul 2020 11:37:24 -0700 (PDT)
MIME-Version: 1.0
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com> <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org> <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org> <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
In-Reply-To: <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 10 Jul 2020 00:06:58 +0530
Message-ID: <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Matias_Bj=C3=B8rling?= <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 9, 2020 at 7:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/9/20 8:00 AM, Christoph Hellwig wrote:
> > On Thu, Jul 09, 2020 at 07:58:04AM -0600, Jens Axboe wrote:
> >>> We don't actually need any new field at all.  By the time the write
> >>> returned ki_pos contains the offset after the write, and the res
> >>> argument to ->ki_complete contains the amount of bytes written, which
> >>> allow us to trivially derive the starting position.

Deriving starting position was not the purpose at all.
But yes, append-offset is not needed, for a different reason.
It was kept for uring specific handling. Completion-result from lower
layer was always coming to uring in ret2 via ki_complete(....,ret2).
And ret2 goes to CQE (and user-space) without any conversion in between.
For polled-completion, there is a short window when we get ret2 but cannot
write into CQE immediately, so thought of storing that in append_offset
(but should not have done, solving was possible without it).

FWIW, if we move to indirect-offset approach, append_offset gets
eliminated automatically, because there is no need to write to CQE
itself.

> >> Then let's just do that instead of jumping through hoops either
> >> justifying growing io_rw/io_kiocb or turning kiocb into a global
> >> completion thing.
> >
> > Unfortunately that is a totally separate issue - the in-kernel offset
> > can be trivially calculated.  But we still need to figure out a way to
> > pass it on to userspace.  The current patchset does that by abusing
> > the flags, which doesn't really work as the flags are way too small.
> > So we somewhere need to have an address to do the put_user to.
>
> Right, we're just trading the 'append_offset' for a 'copy_offset_here'
> pointer, which are stored in the same spot...

The address needs to be stored somewhere. And there does not seem
other option but to use io_kiocb?
The bigger problem with address/indirect-offset is to be able to write to it
during completion as process-context is different. Will that require entering
into task_work_add() world, and may make it costly affair?

Using flags have not been liked here, but given the upheaval involved so
far I have begun to feel - it was keeping things simple. Should it be
reconsidered?


--
Joshi
