Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C75534FE45
	for <lists+io-uring@lfdr.de>; Wed, 31 Mar 2021 12:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhCaKoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 06:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbhCaKoC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 06:44:02 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15512C061574;
        Wed, 31 Mar 2021 03:44:02 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 8so20637964ybc.13;
        Wed, 31 Mar 2021 03:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P3z3C2ealREu50usClDQ2fnA3EIDR3IA/u2tZEcn6O4=;
        b=pN/JqtJJqV5sf04KJOBJ/5RFZONDmjxnT3zmKGmBjAZ1b/HaIowUEC3yBsDWdwSgZU
         fwso+98QpK/ftdyJ1f7Oh/tIha5A4xnTXl9cYat0N6UibyRtM7crSOUSxB7Zmpx3u9pc
         Yw5a5uArmoAbSzRQkIvKtSC4bvIWDtJCMBz2R+kUMOvdIFcfezqEOAcoghWEkVsOFVyq
         TcgaGBh2DVguL2IgR8m8nphBIeIt7KlJr1v2sa9GgJ8CfXvwtBoO0pVbcDqSPSVwCS2H
         kbEqA365bjyfudST8iTe43BS9lkZ10RhDE/Q4DeECSHHpLvR0yCO6KdOBK1E49TJ9Yj0
         wG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P3z3C2ealREu50usClDQ2fnA3EIDR3IA/u2tZEcn6O4=;
        b=P0guTPstC2RRRT62Q8XoNV+6Rx13sait3CRihi3z4gBOpboNtubghRqfk7lQ1MWt3Q
         PyzcY+x2GVAPjAfuojjUzlzaF564HnwKSog8ebP34uQqrPhRaMriooiCsLwsGg7lXizK
         jbiNX/eSyNvXmNIV2QMfCenzwO+9JhfZNFjGpgcwOFnwjn8g763ShQZJFg9SnGrXzY+l
         N/wpnuH4Frul4lHMZL3KDpk5/fMVIVCSQk3PeBPd72K4nbVDrfifyI2cvAsY6WyW+0BR
         by0VZcgleeI+swQGiDhTPSWZ9BSzmdB/79qPHHvUM3sic9DvEEfFEvwA9v5vGFJXgg6m
         gTSA==
X-Gm-Message-State: AOAM532InJXmGBPfpfrrMDRDcjvzrbcCgUP/38MoOcaEERHS+WpSt86E
        9Z1inYpNWx7tptpCWq192fjWBBCFPk7ufHs9ZteF6tq1tdU=
X-Google-Smtp-Source: ABdhPJzSMWBolhTMOIPNVV/DHyaomB2BEzp2p10BYg+3FI6s+DMhZBnsdFk3g2qNGxbPqYyF1exEoLURwN3mGm5xUUA=
X-Received: by 2002:a5b:74d:: with SMTP id s13mr3856473ybq.289.1617187441479;
 Wed, 31 Mar 2021 03:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210330055957.3684579-1-dkadashev@gmail.com> <20210330055957.3684579-2-dkadashev@gmail.com>
 <20210330071700.kpjoyp5zlni7uejm@wittgenstein>
In-Reply-To: <20210330071700.kpjoyp5zlni7uejm@wittgenstein>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 31 Mar 2021 17:43:50 +0700
Message-ID: <CAOKbgA4eAYE1aDBU3WJumnz8aUoF23qOD32F_OtwE=qCXRSxeA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 30, 2021 at 2:17 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> The only thing that is a bit unpleasant here is that this change
> breaks the consistency between the creation helpers:
>
> do_mkdirat()
> do_symlinkat()
> do_linkat()
> do_mknodat()
>
> All but of them currently take
> const char __user *pathname
> and call
> user_path_create()
> with that do_mkdirat() change that's no longer true. One of the major
> benefits over the recent years in this code is naming and type consistency.
> And since it's just matter of time until io_uring will also gain support
> for do_{symlinkat,linkat,mknodat} I would think switching all of them to
> take a struct filename
> and then have all do_* helpers call getname() might just be nicer in the
> long run.

OK, I can change the rest of them in the next version if no one objects.

-- 
Dmitry Kadashev
