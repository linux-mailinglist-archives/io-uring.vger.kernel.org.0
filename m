Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3548421B75A
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgGJN6H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgGJN6H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:58:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85AFC08C5CE;
        Fri, 10 Jul 2020 06:58:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r12so6007064wrj.13;
        Fri, 10 Jul 2020 06:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qGTdmZTNycuSsZdYyd+aOzaPH9cISwBzNXZdZyFF4OI=;
        b=rzyk22Li/x8K4ZYEuz81gQfs0qxf588SLcl4ZiGskAdILv8F4NmLTti5Y5MNLsqX4A
         cVRiD2BKx6SKDbwn9iDnKIyVf8XWOJ7lC8ioWjj+ojQj1STT3efceKA+V3idbqE+g1bp
         vGFdZXyMfG0zzTIBRcYl8SFjy7JZOqUka8IP5rHmUK/UqT1j7WPkk3hpiLU2f3nMIQBq
         tpnrCR8Y2midwlrbwJx8I/3G1CJVvwmRkaJx6d88LwHlRF5zH2jbUBr2lisOSHhW10hE
         ZCdzSzrB77RoZEDa6anJH7lt9PNCSXESjyzSnqfSZdblccMBPGTBlz7LP36lxBNkXYe5
         oPlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qGTdmZTNycuSsZdYyd+aOzaPH9cISwBzNXZdZyFF4OI=;
        b=W7rteyHSLQBbgXLPirUrUWhvgyMXW9E0VFxG535wfStdldcEzk7eXGQN3FGjGdDcj3
         zZ8cii9MfzvBo4R+LHnk2U2PAnvRDZaQME7u5BG4wmjdtXCEK/R5uARDqQYE42DN+823
         /C5hDGlhK0+k3QjQ0gdTxgC02JaMIJI/nBPujQwAXSPcSXl6VBPH2b9CBgQTd/98GqY/
         ngWRB/Nicj4uJ2vWXcnJNw5MRLp2JxSvhs1YW8UrXNguffY4/Nf1QjXeT4Lz1TKh2917
         xLQs/KQXRuGJXDxN/vvFFpDd+6pqPsLGTGZRY7ywGAvb7h0AFLGJ+Y96EVCCuJb6UCzH
         wp1A==
X-Gm-Message-State: AOAM531k3Vtj6CzVpSfIq5G9LTgUAJ0E3mrUW/8eetG2GKfLmz38NVKJ
        SzaTg2pbzThErpHmHEtsESdI6xaOucV7ee4XDRc=
X-Google-Smtp-Source: ABdhPJxAXPyq+TgGM1KIrPXsNrVp0LsQhJw7n+KMql5in4TTsc5AAhvy36mPobH51Ew8wqP3H+CbX4J2nUXnh92VB5A=
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr65348995wro.137.1594389485356;
 Fri, 10 Jul 2020 06:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com> <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org> <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org> <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk> <20200710130912.GA7491@infradead.org>
 <CA+1E3rJSiS58TE=hHv5wVv-umJ19_7zKv-JqZTNzD=xi3MoX1g@mail.gmail.com>
In-Reply-To: <CA+1E3rJSiS58TE=hHv5wVv-umJ19_7zKv-JqZTNzD=xi3MoX1g@mail.gmail.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 10 Jul 2020 19:27:38 +0530
Message-ID: <CA+1E3r+6TVr8SYtOJpDyDu9=LZQpr4qaNiYno6ErMoSBh-eBkA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        "Matias Bj??rling" <mb@lightnvm.io>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 6:59 PM Kanchan Joshi <joshiiitr@gmail.com> wrote:
>
> On Fri, Jul 10, 2020 at 6:39 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Thu, Jul 09, 2020 at 12:50:27PM -0600, Jens Axboe wrote:
> > > It might, if you have IRQ context for the completion. task_work isn't
> > > expensive, however. It's not like a thread offload.

Not sure about polled-completion but we have IRQ context for regular completion.
If I've got it right, I need to store task_struct during submission,
and use that to register a task_work during completion. At some point
when this task_work gets called it will update the user-space pointer
with the result.
It can be the case that we get N completions parallely, but they all
would get serialized because all N task-works need to be executed in
the context of single task/process?

> > > > Using flags have not been liked here, but given the upheaval involved so
> > > > far I have begun to feel - it was keeping things simple. Should it be
> > > > reconsidered?
> > >
> > > It's definitely worth considering, especially since we can use cflags
> > > like Pavel suggested upfront and not need any extra storage. But it
> > > brings us back to the 32-bit vs 64-bit discussion, and then using blocks
> > > instead of bytes. Which isn't exactly super pretty.
> >
> > block doesn't work for the case of writes to files that don't have
> > to be aligned in any way.  And that I think is the more broadly
> > applicable use case than zone append on block devices.
>
> But when can it happen that we do zone-append on a file (zonefs I
> asssume), and device returns a location (write-pointer essentially)
> which is not in multiple of 512b?
>
>
> --
> Joshi



-- 
Joshi
