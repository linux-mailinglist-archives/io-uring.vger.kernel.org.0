Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E7114EDFC
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 14:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgAaNwR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 08:52:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32848 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbgAaNwR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 08:52:17 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so7198084lji.0
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 05:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LXtoyDbRhJ1GDdgHuSvQPa215Cd1GpLKYxadt+kW0Pw=;
        b=G3irzPF3OOtKYKeJtZcs95l544OTGs4eFBFlfVdrSSPIMvJ9Fln7Fb4Hm3yvUN870C
         HMkTPoe2nthLRCExbdPih0AErGT5VPG1gKgR30+wvmhE6tgDMPWn4CpiwPcEq7yXU38J
         lR3PyL3FY/0f8T3E80Ub1HPcxFspfnY7g/2oa2WpWAA78yvtozR1NPLzbv/8rr8xQ311
         t/l+LHELDF1jDzjhXf2wrBUisLL1Nq3GDqWney0Q19/Kb5r6Ve/oBS8n/1rVnjJJEZg5
         6GbOPZnwxf5a8pWjJ+v9hYLGbA6O+pOK3GlDnnDSg9rLrCBfZE6iuS1VBmqIHMss0apc
         ktFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LXtoyDbRhJ1GDdgHuSvQPa215Cd1GpLKYxadt+kW0Pw=;
        b=pahy0kouxiQ0+aD1J9xakokRFkO8QZVE1C072lXi5+REx/h8qsvHWo3cM1zKGKkYYL
         pTWMS2anMZakIDSzQ6buu3FWmyBJm6WAD1LA5FQceTLM+S3/6XCakxZioWa/5pGz2sOb
         m+OOZGElEorPud9v4ipGAFW+z8ngVBR3hbYjnspPnisvqe1qtqc4+27rRFF6CzCfwEv2
         RMiOLtHc9PsvSZP4Eystfjunvqdl93P+oqkG19OF4LBpM1zG45Jva4EsF87XrNa+rYeB
         g0huvc4dvK+gj9DlmZPksfgpQdOFShjB7IB8jmEzbEBWo6dpGpzyijJ/a95Fqu9+IQb1
         7+pA==
X-Gm-Message-State: APjAAAX1CWANbWOgWFcMLITN2fb7IH9VjKNDFTdGdKHdchLyKyKXt/s7
        30zcFC1ZRTY4DMytKlw7gi8SXN2QBaj9N4YR/oK7/Q==
X-Google-Smtp-Source: APXvYqyaaJYxzY+pDnZj2mFGXMxemfcvDbkG49xKpYr1N+RozmG1FbAvNrsaUUl8dIF2v6kl/bYQepnTzUiVsdcWxI8=
X-Received: by 2002:a05:651c:1049:: with SMTP id x9mr6128021ljm.233.1580478734924;
 Fri, 31 Jan 2020 05:52:14 -0800 (PST)
MIME-Version: 1.0
References: <20200130160013.21315-1-glauber@scylladb.com> <94074992-eb67-def1-5f74-5e412dda18fd@kernel.dk>
 <CAD-J=zZURZV46Tzx4fC4EteD4ejL=axKaw-CjtyFmYhCYzKEdg@mail.gmail.com> <3338257d-009d-1db0-c77a-2bf06e5518f2@kernel.dk>
In-Reply-To: <3338257d-009d-1db0-c77a-2bf06e5518f2@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Fri, 31 Jan 2020 08:52:03 -0500
Message-ID: <CAD-J=zaHpYPj-UOK46AhdKgSHQF2Hd5b_tjZ_+d9qAdu5VHXhA@mail.gmail.com>
Subject: Re: [PATCH v2 liburing] add helper functions to verify io_uring functionality
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 30, 2020 at 11:31 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/30/20 9:29 AM, Glauber Costa wrote:
> > On Thu, Jan 30, 2020 at 11:13 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 1/30/20 9:00 AM, Glauber Costa wrote:
> >>> It is common for an application using an ever-evolving interface to want
> >>> to inquire about the presence of certain functionality it plans to use.
> >>>
> >>> Information about opcodes is stored in a io_uring_probe structure. There
> >>> is usually some boilerplate involved in initializing one, and then using
> >>> it to check if it is enabled.
> >>>
> >>> This patch adds two new helper functions: one that returns a pointer to
> >>> a io_uring_probe (or null if it probe is not available), and another one
> >>> that given a probe checks if the opcode is supported.
> >>
> >> This looks good, I committed it with minor changes.
> >>
> >> On top of this, we should have a helper that doesn't need a ring. So
> >> basically one that just sets up a ring, calls io_uring_get_probe(),
> >> then tears down the ring.
> >>
> > I'd be happy to follow up with that.
> >
> > Just to be sure, the information returned by probe should be able to outlive the
> > tear down of the ring, right ?
>
> Yeah, same lifetime as the helper you have now, caller must free it once
> done.

Well, in hindsight, I should have called that
io_uring_get_probe_ring() so io_uring_get_probe()
doesn't take a ring.

Alternatively, to keep things in a single function, I can change
io_uring_get_probe() so that if it
ring is NULL, we do our own allocation.

I actually kind of like that. Would that work for you ?

>
> --
> Jens Axboe
>
