Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50FA20C322
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgF0Qmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 12:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgF0Qmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 12:42:42 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE8BC061794
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 09:42:42 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x18so11100537ilp.1
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 09:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LoQKXe9o5JRAUhz/Y9nqb75TfvUXP5mRg0kAlyir88w=;
        b=fv21zefwXvJW//lvFvP82LyKu09cnhJk2OJZfDyWNsxlY7GfNRlhRa8NK9el8c3vjZ
         DpdLfbi3FAhGM+fTOcE9fupAV3oBcdVSppIFzrIq8uc2w4VMJeWMjcxkaWorlziHQNvl
         j5xgHGkXtQkqPzGVMwv2Umle95V3NWf1mToljxnIQwzsHEdB5oMTC+FRUudIl7dXg74v
         gSqsOUEJ2xPlNZLwWPUAl4emcdYazNL/Xiyk0+rYZ8hBeX9DQ0FKVlwYL6yHqfNaA0fv
         2Wx0EjQ0AXVAiFUgjtQ49pbWZEQUVWHfdKSrw+FqsIG+01et5sQV9jjDfxli0iHNQfGt
         6UjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LoQKXe9o5JRAUhz/Y9nqb75TfvUXP5mRg0kAlyir88w=;
        b=rm2dF/VaFZPPM7HBFEOORZ1FITovuo3GgvqSTFNYrqpgOfwe1DdiaWq4sVFQqwh8cl
         albefW/9fkb2jpp8xgiltiYn9gKIWnRejPxFWVd1iV2r1uJuWU0K4S3Dx7cDft4G5TMQ
         9n4NImpgkIQZPnc5W909v0Y4WseI0hKoHz3oM7UtM4dn0zhEpkLFjtOIdK74CknKu0q6
         A2T638dvSPPL6jvO793COu/qhZr2LsN53BEw1HncVTtQT6Gb5rwpc9e6tY+TOTtS4tCY
         W0DYx/UJRF89K/VjnL6T0wxPFBtUf+4f0QaP3738MimdwiT8WYEv7Ezwho4RTpXOhYBe
         MTXg==
X-Gm-Message-State: AOAM532T66AaChhor8b+b4iGefCXwMC4J5yJ/ce8wd+1ge1AO8jkjzhQ
        kulKTkAA2xX1EzkZvdPAty0xCu0Aq4kdRjO2RuA=
X-Google-Smtp-Source: ABdhPJwnDBEwd1mlqkq4pWLUGDvElVGOmkrfF4++rWDSh8zBYzTfBjqvClamBNKLRxmtIll5bwCpbk1sICzwnihQDkU=
X-Received: by 2002:a92:dc0c:: with SMTP id t12mr1191917iln.260.1593276161889;
 Sat, 27 Jun 2020 09:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200627055515.764165-1-zeba.hrvoje@gmail.com>
 <b83a2cc5-31ea-9782-1eeb-70b8537f92c3@acm.org> <CAEsUgYj6NDoHPHN+i7tsR5P0tj1Dj47ixJFhFf8UVpm7kagfhg@mail.gmail.com>
 <c9603711-18c6-217b-ced0-cc1fefec0c6e@acm.org>
In-Reply-To: <c9603711-18c6-217b-ced0-cc1fefec0c6e@acm.org>
From:   Hrvoje Zeba <zeba.hrvoje@gmail.com>
Date:   Sat, 27 Jun 2020 12:42:30 -0400
Message-ID: <CAEsUgYh-gv=yJhJ6nztDjcwwCq-_+kdk=qTuMx9cisFKYamN9A@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix usage of stdatomic.h for C++ compilers
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jun 27, 2020 at 12:23 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2020-06-27 08:39, Hrvoje Zeba wrote:
> > Any suggestions?
>
> How about the two attached (untested) patches?
>

Tested on my end, looks good.

Thank you!
