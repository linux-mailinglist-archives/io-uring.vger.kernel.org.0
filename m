Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7051EC289
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 21:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgFBTQs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 15:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBTQs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 15:16:48 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F6AC08C5C0
        for <io-uring@vger.kernel.org>; Tue,  2 Jun 2020 12:16:46 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u16so6870515lfl.8
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2020 12:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5fZ6zLtAy3LTzxhqfmYZ+TNxuUzAC++MhnTYU5kqbQ=;
        b=A2fCI0rpiUNtB3rip/2ui+kwNOmogwE0Mlm+6H3u0+Cuw9yfCX5ueKWG1paD1Ydg1h
         7McX06c4sk/N9FxyoodhdFcP4ZNVV1YwNVq/Lo6tfu7WCdBIdzmMjLUQur8BXbhOF5t6
         u1Iu+9IPkZjaGcEdDMAl5YeBMXgx2FWL52t2d1dUg4HpKV7j5uICCNy82/fVe8exq4By
         a6uBJ1ixtLsahNn3xl0dd5EL/6BovsNkYBy8usxYAMHykpcOz56XRB4rmOorGox3xiBx
         xYBgarCBR8LuY2u304ZKu9ownhYHlfg61LGxb8G/ws5Ze5j5tWNwLb2izOptVsAhoFzb
         xOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5fZ6zLtAy3LTzxhqfmYZ+TNxuUzAC++MhnTYU5kqbQ=;
        b=cbIFSXvbKCdR6INg/fjyaHdHtamObFeI7PmVe3/K8SM6DHb2y3Rz8hh3s8CZB9tACe
         6FtFTaGFGnRCB6tvgRocLzqwiwJLAQuTMUTfETaGNCaK6946fb0oMtEHJhxTlBC2bXd3
         sBowIz7N3c6jLYwu/znCyZQG7MSvB3MiHZNNiKw/g5/3JvZNUhefkCnD39RmPkT7ABdP
         CIShX89j57BuKi9WLHnWs8Aeje5XMasJJ1+HHMNG9eIVWVbxwFQiXe0THQM7GAV0+4RM
         Ua2E8YqYp5jyWwcHgKx5EAOjLB6Coy3IRyzX4bXVSlZS/ScfhOm5Lcdj+IQ8Udh1Bt/k
         sDMA==
X-Gm-Message-State: AOAM530P8ABf//QkIihi3ByEF4XQB5nR5UUdwZtwBS/YsBu06fsoSK6x
        fk++5Y09NuC6bTIZiuMy2aF1EuyFhUgq2ne3dIpeIw==
X-Google-Smtp-Source: ABdhPJxH9AAXZB6dfzyGzaLjN6dnbvis/2y9qyXiXsGzY5AZnZOEgz35VkyR30tOquE+GErz7CFg8BpLf15IM/G2AXI=
X-Received: by 2002:a19:cb05:: with SMTP id b5mr450703lfg.108.1591125404859;
 Tue, 02 Jun 2020 12:16:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk> <4eaad89b-f6e3-2ff4-af07-f63f7ce35bdc@kernel.dk>
 <CAG48ez1CvEpjNTfOJWBRmR6SVkQjLVeSi2gFvuceR0ubF_HJCQ@mail.gmail.com> <9c140709-f51f-af35-86c3-68fd02fffb18@kernel.dk>
In-Reply-To: <9c140709-f51f-af35-86c3-68fd02fffb18@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 2 Jun 2020 21:16:18 +0200
Message-ID: <CAG48ez3x+d1acZEQv_rouXeMq3+qWsGpntXum=iv6FMZ9ch6Jw@mail.gmail.com>
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Clay Harris <bugs@claycon.org>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 2, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 6/2/20 12:22 PM, Jann Horn wrote:
> > On Sun, May 31, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> We just need this ported to stable once it goes into 5.8-rc:
> >>
> >> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.8/io_uring&id=904fbcb115c85090484dfdffaf7f461d96fe8e53
> >
> > How does that work? Who guarantees that the close operation can't drop
> > the refcount of the uring instance to zero before reaching the fdput()
> > in io_uring_enter?
>
> Because io_uring_enter() holds a reference to it as well?

Which reference do you mean? fdget() doesn't take a reference if the
calling process is single-threaded, you'd have to use fget() for that.
