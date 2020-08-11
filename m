Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DB9241CA2
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 16:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgHKOoq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 10:44:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48094 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728876AbgHKOoo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 10:44:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597157082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oBaHdbgWBei9PGc74NIX+QA+JMkdKt8VgiXEsDFjFk4=;
        b=QFDLFkp2NLwSUxU6j0Etvn7wAlc0dzCFjJuT2bo3v9207H4BDEgS37usoZSDesjTauquHh
        E2WFXEqsP7yjnOT1PTUNEJUIf0IpECQSfuuUDLHT4cgTyNvH8czYDAwy7BKgOtwohSsanZ
        t8Gds5EKEQYXUB+G0ZaejJTm+eAnds0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-YXPz2o8oPRqWk2CDU23HGQ-1; Tue, 11 Aug 2020 10:44:39 -0400
X-MC-Unique: YXPz2o8oPRqWk2CDU23HGQ-1
Received: by mail-wr1-f72.google.com with SMTP id z12so5704654wrl.16
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 07:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oBaHdbgWBei9PGc74NIX+QA+JMkdKt8VgiXEsDFjFk4=;
        b=g82DIrguB5gCAGWdaqN2qggjOm/1a5//hdv6VRU2xdG+7igCOChoP3tJtq8YR+xZZP
         bzLz3K3JVoD0GbVpdRYYrUklxXcWXE0SrFjXkgjy/DsTZJruoDTS8IliJURDHvRhJQ5n
         0wGHPauWckztFuHQLsGvs8THxO2BUnNR9uyFRBc+98zXejpiYKpdU6qU8BsEau9Nddfa
         mdr1VODmw0Mt80JEPwUvzOOqAl4D0BdswWVRUy2WuaFgp9UDmlWII/RuO5SeODv5bb+6
         uffc3/kI8lweNXtPhFu0o7sTcimanFw+Ff+3eRSiDGBWCj9emRCEaW5fC+dycQ1QxuG7
         epKw==
X-Gm-Message-State: AOAM532ZeouMNA3kITFzmjdwsPiPm1ELwYVy4s3xK4HNfoRu17uL+jMf
        bhSiLjYR2Scql5+rus0nI72SqX70pX2/DRxzJw82M/lkxV7vd88//Rk1tKXvJA3zVfN68wVfxcQ
        boGT9P0f/q7lmhgaardk=
X-Received: by 2002:a7b:c5c1:: with SMTP id n1mr4034377wmk.125.1597157075123;
        Tue, 11 Aug 2020 07:44:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0PTTFxjBv2fKmGNBax++pGGY3UvTBaVwdqqwXV0cnxjCNtFxDB5PgFxhVxAtR3xQ8Kg8yRA==
X-Received: by 2002:a7b:c5c1:: with SMTP id n1mr4034367wmk.125.1597157074886;
        Tue, 11 Aug 2020 07:44:34 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id h11sm22331259wrb.68.2020.08.11.07.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 07:44:34 -0700 (PDT)
Date:   Tue, 11 Aug 2020 16:44:19 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Subject: Re: possible deadlock in __io_queue_deferred
Message-ID: <20200811144419.blu4wufu7t4dfqin@steredhat>
References: <00000000000035fdf505ac87b7f9@google.com>
 <76cc7c43-2ebb-180d-c2c8-912972a3f258@kernel.dk>
 <20200811140010.gigc2amchytqmrkk@steredhat>
 <504b4b08-30c1-4ca8-ab3b-c9f0b58f0cfa@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504b4b08-30c1-4ca8-ab3b-c9f0b58f0cfa@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 11, 2020 at 08:21:12AM -0600, Jens Axboe wrote:
> On 8/11/20 8:00 AM, Stefano Garzarella wrote:
> > On Mon, Aug 10, 2020 at 09:55:17AM -0600, Jens Axboe wrote:
> >> On 8/10/20 9:36 AM, syzbot wrote:
> >>> Hello,
> >>>
> >>> syzbot found the following issue on:
> >>>
> >>> HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
> >>> git tree:       upstream
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=14d41e02900000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=9d25235bf0162fbc
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=996f91b6ec3812c48042
> >>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> >>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133c9006900000
> >>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1191cb1a900000
> >>>
> >>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>> Reported-by: syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com
> >>
> >> Thanks, the below should fix this one.
> > 
> > Yeah, it seems right to me, since only __io_queue_deferred() (invoked by
> > io_commit_cqring()) can be called with 'completion_lock' held.
> 
> Right
> 
> > Just out of curiosity, while exploring the code I noticed that we call
> > io_commit_cqring() always with the 'completion_lock' held, except in the
> > io_poll_* functions.
> > 
> > That's because then there can't be any concurrency?
> 
> Do you mean the iopoll functions? Because we're definitely holding it
> for the io_poll_* functions.

Right, the only one seems io_iopoll_complete().

So, IIUC, in this case we are actively polling the level below,
so there shouldn't be any asynchronous events, is it right?

Thanks,
Stefano

