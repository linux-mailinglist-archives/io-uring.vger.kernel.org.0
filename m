Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A612414EF8B
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgAaP1n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:27:43 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46119 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgAaP1m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:27:42 -0500
Received: by mail-lj1-f196.google.com with SMTP id x14so7446928ljd.13
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qc4iV7u+7LZJudYZfUI6zVNlh7gRpRZuAwpNVS04Lhc=;
        b=0DgVl6rKp4JHwn/OhoPWRJI4QY2Bfwwx6nsdEYDAPteJ5G3+ttcNlb/5E5r9pGX9po
         LsnFphOVEZvH5LpvM6uSUFSaczmfsyeBcz3kDQMxTpy+NhRxQvF3sx/shSd1f9HZcy6t
         6+4K/YUkxCXBW98Fz24gstr+MVWssZGd3/+kuTjIhkWj6SvnSLSCxpXONzZ79RPFsO0y
         cQX2h4xZDclrj19XUtInJlXlpHDvpomFBLEkKec/scPHEm8D8NHu3xJohcRpi8Av/tJL
         HO4MWnMks+jkRMqVhwbicvsc+CdAINQxj9rryYBOCApnxPCPM7R5/dbS4CZ89Dm5O8sL
         9bUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qc4iV7u+7LZJudYZfUI6zVNlh7gRpRZuAwpNVS04Lhc=;
        b=OYlz79zKwIe1XSYPkfl8V3E8hHPVbJRRgQ4GvcG+sfFrFHQw6YnRKkUFDRFGcG+LAp
         lh7tLIe1NRpLCZ7g3vC7Skk0AeXy9vCDBhtWMAnBA2byT/3vTeu1+F9KVIU5V7RMv+u2
         VSGRh43b6Li9alvPEBm8JZHhJNxUoWbYNH3Sw0aOKt1DOreSX5tezJ4K6f9kgjW0yPBr
         arjIEddHpTkKgDceAIlw/3ODgWRBuZqkZiaTSzR5HzLAod7okvNWNRhxbUW3NWRj62F4
         LVEf618SSbzKvPU8tSxYS7ifTSih3Awh5btwzYhC4vxzJhpr0xa/OmGtdpRhz6r9FlDv
         Vjwg==
X-Gm-Message-State: APjAAAU+L75DFaU0IlwB5aCMNuY1yrC4yxeBATiQ2jz9f+0/UCOY+rjq
        Ya17TLoyQ+ACgsieURRFuUvR9o6yEJZuQDdJoW5htw==
X-Google-Smtp-Source: APXvYqytdVDAJwx/PWqC0I679F1nNuSYOCBUO5jM8tcQx5SK20D1rHR9jSfaNbQ3x4FohbU9PldQXr+QfxSKR3IlIvM=
X-Received: by 2002:a2e:9052:: with SMTP id n18mr6163722ljg.251.1580484459192;
 Fri, 31 Jan 2020 07:27:39 -0800 (PST)
MIME-Version: 1.0
References: <20200130160013.21315-1-glauber@scylladb.com> <94074992-eb67-def1-5f74-5e412dda18fd@kernel.dk>
 <CAD-J=zZURZV46Tzx4fC4EteD4ejL=axKaw-CjtyFmYhCYzKEdg@mail.gmail.com>
 <3338257d-009d-1db0-c77a-2bf06e5518f2@kernel.dk> <CAD-J=zaHpYPj-UOK46AhdKgSHQF2Hd5b_tjZ_+d9qAdu5VHXhA@mail.gmail.com>
 <d08b04c0-535e-4837-bd83-531f231259b9@kernel.dk>
In-Reply-To: <d08b04c0-535e-4837-bd83-531f231259b9@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Fri, 31 Jan 2020 10:27:27 -0500
Message-ID: <CAD-J=zYGgKA74OAuQzNt14-zpxFs1ryKw9TBkQ_vzVUfMos4qQ@mail.gmail.com>
Subject: Re: [PATCH v2 liburing] add helper functions to verify io_uring functionality
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 31, 2020 at 10:14 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/31/20 6:52 AM, Glauber Costa wrote:
> > On Thu, Jan 30, 2020 at 11:31 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 1/30/20 9:29 AM, Glauber Costa wrote:
> >>> On Thu, Jan 30, 2020 at 11:13 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 1/30/20 9:00 AM, Glauber Costa wrote:
> >>>>> It is common for an application using an ever-evolving interface to want
> >>>>> to inquire about the presence of certain functionality it plans to use.
> >>>>>
> >>>>> Information about opcodes is stored in a io_uring_probe structure. There
> >>>>> is usually some boilerplate involved in initializing one, and then using
> >>>>> it to check if it is enabled.
> >>>>>
> >>>>> This patch adds two new helper functions: one that returns a pointer to
> >>>>> a io_uring_probe (or null if it probe is not available), and another one
> >>>>> that given a probe checks if the opcode is supported.
> >>>>
> >>>> This looks good, I committed it with minor changes.
> >>>>
> >>>> On top of this, we should have a helper that doesn't need a ring. So
> >>>> basically one that just sets up a ring, calls io_uring_get_probe(),
> >>>> then tears down the ring.
> >>>>
> >>> I'd be happy to follow up with that.
> >>>
> >>> Just to be sure, the information returned by probe should be able to outlive the
> >>> tear down of the ring, right ?
> >>
> >> Yeah, same lifetime as the helper you have now, caller must free it once
> >> done.
> >
> > Well, in hindsight, I should have called that
> > io_uring_get_probe_ring() so io_uring_get_probe()
> > doesn't take a ring.
>
> Just change it - we just added it yesterday, and it's not released yet.
> I don't break anything that's been in a release, and I maintain
> compatibility between releases, but we can change it now.

Yeah, I figured as much and ended up changing it.

>
> > Alternatively, to keep things in a single function, I can change
> > io_uring_get_probe() so that if it
> > ring is NULL, we do our own allocation.
> >
> > I actually kind of like that. Would that work for you ?
>
> Not a huge deal to me, we can go that route.
>
> --
> Jens Axboe
>
