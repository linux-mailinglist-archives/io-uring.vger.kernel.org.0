Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A496C6975
	for <lists+io-uring@lfdr.de>; Thu, 23 Mar 2023 14:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjCWN1M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Mar 2023 09:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWN1L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Mar 2023 09:27:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA6B86AF
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 06:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679577987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ShWK//M258t/efyGB3M9/gDO5J6ICtboPZa+1gy9j3c=;
        b=Etj26xgPt8QMcENeyXLea2SsPjACmJ4J976komDBNxyE4lCjM6DPGJN8ECfmZKhGqW0jcA
        iDyU9xrtnwGGaVAUSMj0yA2a+lfGz+Zhl3EEhcadCihHGqUchpsk2vSnQx/FJSmoIyx8Zi
        wvQg/It7ZU3M+xwr5oTB3EyhAxBbKUA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-i4M5T5pDMJ2BI5zRWHkiTw-1; Thu, 23 Mar 2023 09:26:24 -0400
X-MC-Unique: i4M5T5pDMJ2BI5zRWHkiTw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5E9485530D;
        Thu, 23 Mar 2023 13:26:23 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DA8140CF8F2;
        Thu, 23 Mar 2023 13:26:17 +0000 (UTC)
Date:   Thu, 23 Mar 2023 21:26:12 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Bernd Schubert <bschubert@ddn.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dharmendra Singh <dsingh@ddn.com>,
        Amir Goldstein <amir73il@gmail.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/13] fuse: Add an interval ring stop worker/monitor
Message-ID: <ZBxTdCj60+s1aZqA@ovpn-8-16.pek2.redhat.com>
References: <20230321011047.3425786-1-bschubert@ddn.com>
 <20230321011047.3425786-7-bschubert@ddn.com>
 <CAJfpegs6z6pvepUx=3zfAYqisumri=2N-_A-nsYHQd62AQRahA@mail.gmail.com>
 <28a74cb4-57fe-0b21-8663-0668bf55d283@ddn.com>
 <CAJfpeguvCNUEbcy6VQzVJeNOsnNqfDS=LyRaGvSiDTGerB+iuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguvCNUEbcy6VQzVJeNOsnNqfDS=LyRaGvSiDTGerB+iuw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 23, 2023 at 01:35:24PM +0100, Miklos Szeredi wrote:
> On Thu, 23 Mar 2023 at 12:04, Bernd Schubert <bschubert@ddn.com> wrote:
> >
> > Thanks for looking at these patches!
> >
> > I'm adding in Ming Lei, as I had taken several ideas from ublkm I guess
> > I also should also explain in the commit messages and code why it is
> > done that way.
> >
> > On 3/23/23 11:27, Miklos Szeredi wrote:
> > > On Tue, 21 Mar 2023 at 02:11, Bernd Schubert <bschubert@ddn.com> wrote:
> > >>
> > >> This adds a delayed work queue that runs in intervals
> > >> to check and to stop the ring if needed. Fuse connection
> > >> abort now waits for this worker to complete.
> > >
> > > This seems like a hack.   Can you explain what the problem is?
> > >
> > > The first thing I notice is that you store a reference to the task
> > > that initiated the ring creation.  This already looks fishy, as the
> > > ring could well survive the task (thread) that created it, no?
> >
> > You mean the currently ongoing work, where the daemon can be restarted?
> > Daemon restart will need some work with ring communication, I will take
> > care of that once we have agreed on an approach. [Also added in Alexsandre].
> >
> > fuse_uring_stop_mon() checks if the daemon process is exiting and and
> > looks at fc->ring.daemon->flags & PF_EXITING - this is what the process
> > reference is for.
> 
> Okay, so you are saying that the lifetime of the ring is bound to the
> lifetime of the thread that created it?
> 
> Why is that?

Cc Jens and io_uring list

For ublk:

1) it is MQ device, it is natural to map queue into pthread/uring

2) io_uring context is invisible to driver, we don't know when it is destructed,
so bind io_uring context with queue/pthread, because we have to complete all
uring commands before io_uring context exits. uring cmd usage for ublk/fuse should
be special and unique, and it is like poll request, and sent to device beforehand,
and it is completed only if driver has incoming thing which needs userspace to handle,
but ublk/fuse may never have anyting which needs userpace to look.

If io_uring can provides API for registering exit callback, things could be easier
for ublk/fuse. However, we still need to know the exact io_uring context associated
with our commands, so either more io_uring implementation details exposed to driver,
or proper APIs provided.

> 
> I'ts much more common to bind a lifetime of an object to that of an
> open file.  io_uring_setup() will do that for example.
> 
> It's much easier to hook into the destruction of an open file, than
> into the destruction of a process (as you've observed). And the way
> you do it is even more confusing as the ring is destroyed not when the
> process is destroyed, but when a specific thread is destroyed, making
> this a thread specific behavior that is probably best avoided.
> 
> So the obvious solution would be to destroy the ring(s) in
> fuse_dev_release().  Why wouldn't that work?

io uring is used for submitting multiple files, so its lifetime can't be bound
to file, also io_uring is invisible to driver if here the ring(s) means io_uring.


thanks,
Ming

