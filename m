Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449302DCDB6
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 09:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgLQIhL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 03:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQIhK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 03:37:10 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDF2C061794
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 00:36:30 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id u12so25054718ilv.3
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 00:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zPkAsK4FG/Q1d6+TcASgZ0VIqIfZbrRkMxQ4TFqVH2g=;
        b=XMXyV3O60kJ1ACkmN/vDT41Bf9hDcMsfQ+XEs/x9FaNgkQ3SPdPQ3lfjPgj0UkQ5lj
         pXBSHsiOj5UvGTJopPC1Aouego2xeeU9QtC6kjV/xpDmO+ahK4ttNl50OFnP3vQ6S8ew
         o0kSlS28y479/ytqljWjs5IJx5IW1WjwTB/g+oESZiGfCIUAtLTQselYBipuHb+saQJe
         WXCCXOfw2cL7u5pdmkbhHqrgFYp6UHm/tVPJK+8TvHLBkXQaWxyf+B7R4e73JNpA9sst
         r+PkCerOXiKIivEp4eloLIqw9W/UDViIWjOKJXNYhKqF/6ssCM1dDPxQvwCngwLGgaXD
         wP8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zPkAsK4FG/Q1d6+TcASgZ0VIqIfZbrRkMxQ4TFqVH2g=;
        b=ujD1siYcZeTkAKFiVVi+BsfHOQXkoUW/f6ek6i4/aXS5Lvc9kXEaPqdefp47iyfspZ
         SZSSb0IYF4NlH/AJccBqj2c04Xja9EaR8WOCnz6Ug0PCWu/heF9NBsRz0tF4dwfBA8oF
         0Sm+stH4d4j7Xy0IxL37FRyESdoAOR1tUkYsVImoivbutA8S+T5L/8jkKmd6/cbdsn9+
         4H5oDNY+TfMPgjN3RmhW90AX1cgp9tPIQcEb76zSpd7Eh2KDGg7Co9kpuuveqvIUe2f3
         dDteSXNVfebIwA09MurI0Qq34aeBLxln+eD7TmkUirafAcsA8WNwqgkf4BeO4QvCB7OM
         a8GQ==
X-Gm-Message-State: AOAM531pw/sIaJrLXF5UJB2ifmHnC85GA0qgNTfvxVUmRL9lpPz24b1P
        Qse1NbDzt4i7xrYXud9oWmIg4xnLGjKeoDxcHDg=
X-Google-Smtp-Source: ABdhPJztd7LVFLfXYV1wQkbnFF7NC9bMLnJ2jrbyTnvt8gf8jh9LmF3NC/KowvA73WvilimdFMZeUORQb0RBHZQdpNo=
X-Received: by 2002:a05:6e02:c2a:: with SMTP id q10mr48275642ilg.92.1608194190100;
 Thu, 17 Dec 2020 00:36:30 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com>
In-Reply-To: <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 17 Dec 2020 15:36:19 +0700
Message-ID: <CAOKbgA4V5aGLbotXz4Zn-7z8yOP5Jy_gTkpwk3jDSNyVTRCtkg@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Norman Maurer <norman.maurer@googlemail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 17, 2020 at 3:27 PM Norman Maurer
<norman.maurer@googlemail.com> wrote:
>
> I wonder if this is also related to one of the bug-reports we received:
>
> https://github.com/netty/netty-incubator-transport-io_uring/issues/14

That is curious. This ticket mentions Shmem though, and in our case it does
not look suspicious at all. E.g. on a box that has the problem at the moment:
Shmem:  41856 kB. The box has 256GB of RAM.

But I'd (given my lack of knowledge) expect the issues to be related anyway.

-- 
Dmitry Kadashev
