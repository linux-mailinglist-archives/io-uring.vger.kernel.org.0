Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AEC246B30
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbgHQPug (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 11:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730869AbgHQPuL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 11:50:11 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B20C061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 08:50:11 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id c12so12753135qtn.9
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 08:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9/+mRcRVsO5XOyBoFGamKUFiA/gjT8of7WwWWUyG9Uo=;
        b=WSQHPyuhDq7kPqZeWtKdwNxDLdxbv6SNfwyCHY0BYeO3gc0c5QGz3DleBMzQuqOt/S
         7wJJdDo5eXsAASTrHU2NHmU38GKs/KY5vLX9DSL+jm1hmWo9U/bvf/1x1bYG6nk0z/Fl
         KEGrm+3g+T41FmgNEK06qJP5p0KofoYsnmxhTR9zMc0xcKs81uxIye+8B5bUjqIfXkRU
         nf896luxt/xCIlKEIhLQhmObyxcIt1Yipctjyqe2B7KrsUb0fKXvNnBIrl4ndJI4TCbK
         UEbV1e5PGjSiE8UuEZi/RL7KuDiymZX8udXKlOHMEKxVWkLADqusNLOcGHuG53ZVtlcC
         I7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9/+mRcRVsO5XOyBoFGamKUFiA/gjT8of7WwWWUyG9Uo=;
        b=JZlEkhFhi9S8v4cNDwKgH5MHLOgYino8bVjk62bL7xDI6HRNqL7JevvfGuuiD5xKCM
         lkxSMYgZ4TmiRCESm+3iRM9NslhFeDwCE7CIpMncwsNQonv59eVTL3Czr6E9QTIwLu05
         ViyzGCaAioN3ASozuIdqGXzv598Z0tnOF0epyrDZOT5/InQZSxFgcyMtOhWOasqr4m1u
         cI/VpeDiZ9ZJmV2uuXQjb480J6p2QEKzrpRfwZZCPGoQKC2p+EkuWlMx/IXvvSwFHEal
         qic0XmoXTfjmXgvMv/iu3wKX1n33x2VUfu29z8Q1runK6CQOOfYimfptWRw7reRWmK7c
         7Rjg==
X-Gm-Message-State: AOAM533TdejGb/uNBZeUNI+yYSCzPiJmvfzpMUeq1iH70504azx0Tyb6
        tyVdLLv5SBT/sLsTB0U5RTo2ADwaITObS97ALMmC0NLq
X-Google-Smtp-Source: ABdhPJyspZ24Devjv3qBsPgscEWSSHCCBmzHk3VW6WcJP32VhOpA512jFUVmpG7BRuVpWwEnBNsIBU7w/D7kJkLix/0=
X-Received: by 2002:aed:2825:: with SMTP id r34mr13096261qtd.321.1597679409846;
 Mon, 17 Aug 2020 08:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
 <477c2759-19c1-1cb8-af4c-33f87f7393d7@kernel.dk>
In-Reply-To: <477c2759-19c1-1cb8-af4c-33f87f7393d7@kernel.dk>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Mon, 17 Aug 2020 18:49:58 +0300
Message-ID: <CAF-ewDp5i0MmY8Xw6XZDZZTJu_12EH9BuAFC59pEdhhp57c0dQ@mail.gmail.com>
Subject: Re: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With 48 threads i am getting 200 mb/s, about the same with 48 separate
uring instances.
With single uring instance (or with shared pool) - 60 mb/s.
fs - ext4, device - ssd.

On Mon, 17 Aug 2020 at 17:29, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/17/20 4:46 AM, Dmitry Shulyak wrote:
> > Hi everyone,
> >
> > I noticed in iotop that all writes are executed by the same thread
> > (io_wqe_worker-0). This is a significant problem if I am using files
> > with mentioned flags. Not the case with reads, requests are
> > multiplexed over many threads (note the different name
> > io_wqe_worker-1). The problem is not specific to O_SYNC, in the
> > general case I can get higher throughput with thread pool and regular
> > system calls, but specifically with O_SYNC the throughput is the same
> > as if I were using a single thread for writing.
> >
> > The setup is always the same, ring per thread with shared workers pool
> > (IORING_SETUP_ATTACH_WQ), and high submission rate. Also, it is
> > possible to get around this performance issue by using separate worker
> > pools, but then I have to load balance workload between many rings for
> > perf gains.
> >
> > I thought that it may have something to do with the IOSQE_ASYNC flag,
> > but setting it had no effect.
> >
> > Is it expected behavior? Are there any other solutions, except
> > creating many rings with isolated worker pools?
>
> This is done on purpose, as buffered writes end up being serialized
> on the inode mutex anyway. So if you spread the load over multiple
> workers, you generally just waste resources. In detail, writes to the
> same inode are serialized by io-wq, it doesn't attempt to run them
> in parallel.
>
> What kind of performance are you seeing with io_uring vs your own
> thread pool that doesn't serialize writes? On what fs and what kind
> of storage?
>
> --
> Jens Axboe
>
