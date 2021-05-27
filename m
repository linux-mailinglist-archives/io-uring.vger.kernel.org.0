Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B14393083
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 16:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhE0ONt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 10:13:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235342AbhE0ONt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 10:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622124735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eOZmoE9TvEm2tUufikHg+bUlvlyIrf4tFxbg3hpYnEw=;
        b=GLVJJM7kjocnSkLZ7JUQNJ2xdxDg51ksLMsqq5Uv/gexggBwwEFGndK2qOChQ88lFuYbOt
        laZpG8lTHEDPVK8IKG4s/TjxTKbRduFq4EM3vSB6w3/cPbMMuUFx+DTthSlPITtpB/GED2
        FmFdLt3eV98oinOCJF75dM6krBFWS5Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-Lh_JOAupO2-4sl4yrrCQvQ-1; Thu, 27 May 2021 10:12:14 -0400
X-MC-Unique: Lh_JOAupO2-4sl4yrrCQvQ-1
Received: by mail-wm1-f72.google.com with SMTP id b206-20020a1c1bd70000b02901713122405eso273789wmb.1
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 07:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eOZmoE9TvEm2tUufikHg+bUlvlyIrf4tFxbg3hpYnEw=;
        b=fAjZT6FzG+6OAmnp/efHgC42UiI2TsQ4C8YyMxOybEqLjQQra0XppIVvWf28HrOkx+
         fPkV9Lx+ws2mTjW15sULJ/TG5CukAb300S/pYW5Z7dF0MHIkF4KqBlmTwyKsScT6fWa5
         LoxvIuIbv3hTyalybS5wbx87g0tpa1KjXW78FU0/kF1fLROULOF2pUCKBzltAx6FIK0v
         VDXv6rUoWzh4x07lPsVKQywM6FyBKaFmwMsAd4X5nxF2XdomyCMhr+L90E7xOF7wjNg3
         bTcO3kVttPhnKAsQMlpfNh1VpCspY2e+t0MIdZzNozpkaJEqeJPwOCQchDLpMtDb5TmC
         OMYA==
X-Gm-Message-State: AOAM533ESM8JtH1q1NUB5HlZnSy9XhiozRmmd/FhjZwr7EkbDPgFjGRQ
        gWiCnkY2mQ9CFEYKSeBCrKxENnBSL4+MNUI13BnR1bS051HE8l3V8svSLxtM6nO3tuC7pcDuxHu
        eH+S6cUYxpHlscgewBEl8D4j/W8ZugGcF0XE=
X-Received: by 2002:a7b:c24a:: with SMTP id b10mr8610737wmj.157.1622124732938;
        Thu, 27 May 2021 07:12:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhybCeFtlvYWzQ5ueSjUYz+VaCXc45NWGiAf6EI/h9Wxk9XPu60l50ljSNUItdJ1i8Yo35RBpsyCCv7NnxoHo=
X-Received: by 2002:a7b:c24a:: with SMTP id b10mr8610709wmj.157.1622124732672;
 Thu, 27 May 2021 07:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210526223445.317749-1-jforbes@fedoraproject.org> <aa130828-03c9-b49b-ab31-1fb83a0349fb@kernel.dk>
In-Reply-To: <aa130828-03c9-b49b-ab31-1fb83a0349fb@kernel.dk>
From:   Justin Forbes <jforbes@redhat.com>
Date:   Thu, 27 May 2021 09:12:01 -0500
Message-ID: <CAFbkSA1G2ajKQg4eA947dv0Pcmyf-JQbkn8-jYnmUeMAEpfHtw@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Remove CONFIG_EXPERT
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 27, 2021 at 8:43 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/26/21 4:34 PM, Justin M. Forbes wrote:
> > While IO_URING has been in fairly heavy development, it is hidden behind
> > CONFIG_EXPERT with a default of on.  It has been long enough now that I
> > think we should remove EXPERT and allow users and distros to decide how
> > they want this config option set without jumping through hoops.
>
> The whole point of EXPERT is to ensure that it doesn't get turned off
> "by accident". It's a core feature, and something that more and more
> apps or libraries are relying on. It's not something I intended to ever
> go away, just like it would never go away for eg futex or epoll support.
>

I am not arguing with that, I don't expect it will go away. I
certainly do not have an issue with it defaulting to on, and I didn't
even submit this with intention to turn it off for default Fedora. I
do think that there are cases where people might not wish it turned on
at this point in time. Hiding it behind EXPERT makes it much more
difficult than it needs to be.  There are plenty of config options
that are largely expected default and not hidden behind EXPERT.

Justin

