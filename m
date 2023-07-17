Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAABC756CD0
	for <lists+io-uring@lfdr.de>; Mon, 17 Jul 2023 21:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjGQTJ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Jul 2023 15:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjGQTJY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Jul 2023 15:09:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171C118D
        for <io-uring@vger.kernel.org>; Mon, 17 Jul 2023 12:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689620916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ir1J/k3wLKNYp7LI2ijvFBF6ZKrDfOA6Drq2a2Jon50=;
        b=B4DThB0Lv+ETPz9tIxnhsTUh5Kp+TOxJvpk8PPAEd97110jklxpxktgtbNDlizQhQoSAvQ
        HZjPR1G3S0xmT0JBFNTa6k2Ue4F6y+TxzVQiHf3wepfXw4yccXvaXlHhA2gjW3b7dumZS5
        7UT2PTW3mg/Yi9wPoBAcjZyKoDqE3H8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-VmJeATt5OzO2J-IQ_fFvGA-1; Mon, 17 Jul 2023 15:08:35 -0400
X-MC-Unique: VmJeATt5OzO2J-IQ_fFvGA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34650d1dfd4so30501385ab.2
        for <io-uring@vger.kernel.org>; Mon, 17 Jul 2023 12:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689620914; x=1692212914;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ir1J/k3wLKNYp7LI2ijvFBF6ZKrDfOA6Drq2a2Jon50=;
        b=PTuhIy+zZxN/pkAiuuJyhStjTnfT4jXSJFcfXTyMXUpUpxto7Xjnyt3a4CfFqkFDc9
         kaHxqERDONyf67+Gu4aVoWjzWVZCZt/5egjKh1twW/QsmxV07C6kOKrX4kIw4PPTi9aR
         Y+z+PhaJ+4eQG1vM7LAeGkRnqk1siE6V9Gt6pZGYpRM2j1pllFUiM+2tGsid9hMnPQPD
         hCme/OWBxXNU5JEAbPS+yWPm+Tf08k3BzHwTQOQN7HCwaHZvkTnaot+xxGzqMpPdK/Lw
         Bx/y5XAmJ5AR0U1XFvsGHPvZU/Cswanuxl+tTixwyCmEH7ojIUGLczPKotMODd0qWxMU
         z0+A==
X-Gm-Message-State: ABy/qLYNtu0RCAWeXAVZEML6nGJk6s8q6iiS9V7pvSnWBm+ajM7PqeOY
        bHve2paajDJs56CEPIaoloSXNo4KfeKuZl2VTDomDan24OCTqQCC1Ucj/XdYItRO72UKk9c647Y
        upibE61xjT6tMsY4e6H0=
X-Received: by 2002:a05:6e02:1a8b:b0:348:8542:a673 with SMTP id k11-20020a056e021a8b00b003488542a673mr578056ilv.22.1689620914115;
        Mon, 17 Jul 2023 12:08:34 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH8IAKDk/Qq0r0DbEq84CfbH5y70uroq/83Nyu0gFtjM6u4GlatJgupAE/Bg/5ujaAlXs4PMg==
X-Received: by 2002:a05:6e02:1a8b:b0:348:8542:a673 with SMTP id k11-20020a056e021a8b00b003488542a673mr578040ilv.22.1689620913830;
        Mon, 17 Jul 2023 12:08:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o9-20020a92dac9000000b003460b456030sm129837ilq.60.2023.07.17.12.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 12:08:33 -0700 (PDT)
Date:   Mon, 17 Jul 2023 13:08:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-usb@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Paul Durrant <paul@xen.org>, Tom Rix <trix@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>,
        linux-mm@kvack.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Fei Li <fei1.li@intel.com>, x86@kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.com>,
        intel-gfx@lists.freedesktop.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-fpga@vger.kernel.org, Zhi Wang <zhi.a.wang@intel.com>,
        Wu Hao <hao.wu@intel.com>, Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linuxppc-dev@lists.ozlabs.org, Eric Auger <eric.auger@redhat.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, cgroups@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        intel-gvt-dev@lists.freedesktop.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, Tony Krowiak <akrowiak@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Oded Gabbay <ogabbay@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Moritz Fischer <mdf@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Dominik Behr <dbehr@chromium.org>,
        Marcin Wojtas <mw@semihalf.com>
Subject: Re: [PATCH 0/2] eventfd: simplify signal helpers
Message-ID: <20230717130831.0f18381a.alex.williamson@redhat.com>
In-Reply-To: <CAH76GKPF4BjJLrzLBW8k12ATaAGADeMYc2NQ9+j0KgRa0pomUw@mail.gmail.com>
References: <20230630155936.3015595-1-jaz@semihalf.com>
        <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
        <CAH76GKPF4BjJLrzLBW8k12ATaAGADeMYc2NQ9+j0KgRa0pomUw@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 17 Jul 2023 10:29:34 +0200
Grzegorz Jaszczyk <jaz@semihalf.com> wrote:

> pt., 14 lip 2023 o 09:05 Christian Brauner <brauner@kernel.org> napisa=C5=
=82(a):
> >
> > On Thu, Jul 13, 2023 at 11:10:54AM -0600, Alex Williamson wrote: =20
> > > On Thu, 13 Jul 2023 12:05:36 +0200
> > > Christian Brauner <brauner@kernel.org> wrote:
> > > =20
> > > > Hey everyone,
> > > >
> > > > This simplifies the eventfd_signal() and eventfd_signal_mask() help=
ers
> > > > by removing the count argument which is effectively unused. =20
> > >
> > > We have a patch under review which does in fact make use of the
> > > signaling value:
> > >
> > > https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com=
/ =20
> >
> > Huh, thanks for the link.
> >
> > Quoting from
> > https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-=
jaz@semihalf.com/#25266856
> > =20
> > > Reading an eventfd returns an 8-byte value, we generally only use it
> > > as a counter, but it's been discussed previously and IIRC, it's possi=
ble
> > > to use that value as a notification value. =20
> >
> > So the goal is to pipe a specific value through eventfd? But it is
> > explicitly a counter. The whole thing is written around a counter and
> > each write and signal adds to the counter.
> >
> > The consequences are pretty well described in the cover letter of
> > v6 https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.co=
m/
> > =20
> > > Since the eventfd counter is used as ACPI notification value
> > > placeholder, the eventfd signaling needs to be serialized in order to
> > > not end up with notification values being coalesced. Therefore ACPI
> > > notification values are buffered and signalized one by one, when the
> > > previous notification value has been consumed. =20
> >
> > But isn't this a good indication that you really don't want an eventfd
> > but something that's explicitly designed to associate specific data with
> > a notification? Using eventfd in that manner requires serialization,
> > buffering, and enforces ordering.

What would that mechanism be?  We've been iterating on getting the
serialization and buffering correct, but I don't know of another means
that combines the notification with a value, so we'd likely end up with
an eventfd only for notification and a separate ring buffer for
notification values.

As this series demonstrates, the current in-kernel users only increment
the counter and most userspace likely discards the counter value, which
makes the counter largely a waste.  While perhaps unconventional,
there's no requirement that the counter may only be incremented by one,
nor any restriction that I see in how userspace must interpret the
counter value.

As I understand the ACPI notification proposal that Grzegorz links
below, a notification with an interpreted value allows for a more
direct userspace implementation when dealing with a series of discrete
notification with value events.  Thanks,

Alex

> > I have no skin in the game aside from having to drop this conversion
> > which I'm fine to do if there are actually users for this btu really,
> > that looks a lot like abusing an api that really wasn't designed for
> > this. =20
>=20
> https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-ja=
z@semihalf.com/
> was posted at the beginig of March and one of the main things we've
> discussed was the mechanism for propagating acpi notification value.
> We've endup with eventfd as the best mechanism and have actually been
> using it from v2. I really do not want to waste this effort, I think
> we are quite advanced with v6 now. Additionally we didn't actually
> modify any part of eventfd support that was in place, we only used it
> in a specific (and discussed beforehand) way.

