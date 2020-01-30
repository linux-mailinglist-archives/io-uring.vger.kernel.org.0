Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302B514DF1F
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 17:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgA3Q3h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 11:29:37 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32811 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbgA3Q3h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 11:29:37 -0500
Received: by mail-lf1-f68.google.com with SMTP id n25so2734246lfl.0
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 08:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YUU/nfumPjH2MkqVt3he3cYe7OpilInSX9LLQYklpMA=;
        b=0uFoe1PSwj5XA9i50TCuCMtJfd4v5VgB25WjGArc0xy3R6nM2pJn4l6Jh7VD8obCTe
         hTg63lvPvxGOUYtu5/XN4tlBai01zZfeCsDcZGNIciUlvqQdKDrEWGkCd9b1fu5FC/Bi
         JK8i0Gdx1N4FMisxt8+pBaOvmwEREVYymOPcSId6D97UZtwLvJ+9USn3a8XpqYzbAAd8
         q/5Ge0peBgIAp8o0jSJHQdApf8vOoVI4xaT4rcnoMDw1BoywmvS5S5cc0uUyXkJlGoE1
         5E7/5s5GeAmoUBapjFapYcPLRuceKVUuA/q9sExQjHzW0zyJ943ZH1locU9UGWOu9AKs
         4Svw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YUU/nfumPjH2MkqVt3he3cYe7OpilInSX9LLQYklpMA=;
        b=iHANRu8BfVQ1ooEMestn47JlNvvBzQ9ucZuT8dFl28FIZQ11TUKL4AdfHg4qwO3U+j
         SX3ESs7qXHgjnovrMd5oBM9XiPXkkGnK+kvvxBY6Ar4mKyP58hS0SLxrqQ8pRoA5Ewgh
         ewtSb8DjnlVzYmUlN3SFurxOVr9WwM0FZ97S516qWyqo4vipEQmoZT6/bSn4i0jJMz1+
         M6a6zZVHKBdE4dZcBbmoutZukL5IWA6OG/m8THJ2JzXMVKEA0UzB8bieyJTpeJYpr66j
         hoXGyKXlnEX54pKgCLqW/Bbq3D//v000NwjaT+xDP1W3rZoepDHKzYBTflpUKHTvJidB
         Ax7g==
X-Gm-Message-State: APjAAAUZmhaHyCxrAgI/ivEDz7n301eTuiDRbIycqQIymUgRRZl6ubq3
        qflGioGYWd0xXtqkyr8wNZ490Jk+/P6UdA2ygdAeSg==
X-Google-Smtp-Source: APXvYqxJU3rz5MMp6OpWUgSOEiAQgb+wutHPFe6e2FP7xAjSzVTGjCqVANa/GU+8zF5AfhCbTsYi0801GnGjMFt/yVs=
X-Received: by 2002:a19:4a:: with SMTP id 71mr3009333lfa.50.1580401775230;
 Thu, 30 Jan 2020 08:29:35 -0800 (PST)
MIME-Version: 1.0
References: <20200130160013.21315-1-glauber@scylladb.com> <94074992-eb67-def1-5f74-5e412dda18fd@kernel.dk>
In-Reply-To: <94074992-eb67-def1-5f74-5e412dda18fd@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Thu, 30 Jan 2020 11:29:24 -0500
Message-ID: <CAD-J=zZURZV46Tzx4fC4EteD4ejL=axKaw-CjtyFmYhCYzKEdg@mail.gmail.com>
Subject: Re: [PATCH v2 liburing] add helper functions to verify io_uring functionality
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 30, 2020 at 11:13 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/30/20 9:00 AM, Glauber Costa wrote:
> > It is common for an application using an ever-evolving interface to want
> > to inquire about the presence of certain functionality it plans to use.
> >
> > Information about opcodes is stored in a io_uring_probe structure. There
> > is usually some boilerplate involved in initializing one, and then using
> > it to check if it is enabled.
> >
> > This patch adds two new helper functions: one that returns a pointer to
> > a io_uring_probe (or null if it probe is not available), and another one
> > that given a probe checks if the opcode is supported.
>
> This looks good, I committed it with minor changes.
>
> On top of this, we should have a helper that doesn't need a ring. So
> basically one that just sets up a ring, calls io_uring_get_probe(),
> then tears down the ring.
>
I'd be happy to follow up with that.

Just to be sure, the information returned by probe should be able to outlive the
tear down of the ring, right ?
