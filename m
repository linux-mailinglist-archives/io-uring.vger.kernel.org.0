Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC74755E74
	for <lists+io-uring@lfdr.de>; Mon, 17 Jul 2023 10:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjGQI3w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Jul 2023 04:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjGQI3u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Jul 2023 04:29:50 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DDB18B
        for <io-uring@vger.kernel.org>; Mon, 17 Jul 2023 01:29:46 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-345ff33d286so22420885ab.3
        for <io-uring@vger.kernel.org>; Mon, 17 Jul 2023 01:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1689582586; x=1692174586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrEcIar0BkfpmBL+8BCmNKqe2TUSK3LL+WBdNYsOjsM=;
        b=e52IJgo7nORao0Gl4I5dRpwwbrYRCXZTSuwaC/thRVodGrQS/Ih+iZx/Zsqn89WU3w
         pQgXUWQS+Vk59/Fh6rrIEqzCQJkEny2i0gy7zEPOvxwj9yUxhnNvrizRbt8YsZpplHpx
         RjVLFZyrzR9wafddakUgpMo5lLKlNumHP6uiacp/wGVyLbBbCgrHIUP/7snpf7XV2sof
         jlaeLm95LpwgAuzcjO7UCvT+e3bh2UJ0I6TbCUpKBOZvGLRTw6wJXY5zbY52dacz1/1P
         iPPOvh8ArwyYCroEOLn3Y8OJKVgd78PUACDF8tTPiPB+Om3hyy+66x8dhT2yU/74h83y
         v2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689582586; x=1692174586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrEcIar0BkfpmBL+8BCmNKqe2TUSK3LL+WBdNYsOjsM=;
        b=H6SWtXrUPYRoLrVnk4apta0ejYZXygH5biYbuzZNM63m6XSWS9pkExtnM53hojlaS3
         bjYuj0SmbQw3o/jXCsSAczfbZ5x25MTTllnxGmsgXXrqTcQwm8rV2e0OHg4EsmErGCsM
         C2itC+NN6c9uTo4GgH5OXEletCqN9yF+gE4l6//zhktpNq7S/c878YXICJ1ZAnfvQg/q
         qs+rq4mYQaLMGG7qXsqdGcMc6ZpEYOaMOCyxRlGWD797iDJIU9oxfdq9N0IsuAHCnDD4
         TR2WBKkbhs3ceCnbXq4jY0QehkuvJzJQqoKn+dbcFUWp2VpKk4lU5dMWn0FiesV1vdtp
         Hu8Q==
X-Gm-Message-State: ABy/qLZDwr1hvHeN5Y6QOvEW6w8vBGqlevczGfVRvHys5WyJWyt4Kb5R
        zKydsMT+eU15K3X8Luja7dJ+AEjT2EqL/+cTjFWPTQ==
X-Google-Smtp-Source: APBJJlGE7jn73weZAb7Q+GH4ouydfCd9ILtA9ynYfWdyB1I4k5TGE6qNhhrOJBaOwSkah9YrBoRDKcKZ9t95G975sJc=
X-Received: by 2002:a92:d4d2:0:b0:345:d470:baa6 with SMTP id
 o18-20020a92d4d2000000b00345d470baa6mr9664500ilm.29.1689582586220; Mon, 17
 Jul 2023 01:29:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230630155936.3015595-1-jaz@semihalf.com> <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
In-Reply-To: <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Mon, 17 Jul 2023 10:29:34 +0200
Message-ID: <CAH76GKPF4BjJLrzLBW8k12ATaAGADeMYc2NQ9+j0KgRa0pomUw@mail.gmail.com>
Subject: Re: [PATCH 0/2] eventfd: simplify signal helpers
To:     Christian Brauner <brauner@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

pt., 14 lip 2023 o 09:05 Christian Brauner <brauner@kernel.org> napisa=C5=
=82(a):
>
> On Thu, Jul 13, 2023 at 11:10:54AM -0600, Alex Williamson wrote:
> > On Thu, 13 Jul 2023 12:05:36 +0200
> > Christian Brauner <brauner@kernel.org> wrote:
> >
> > > Hey everyone,
> > >
> > > This simplifies the eventfd_signal() and eventfd_signal_mask() helper=
s
> > > by removing the count argument which is effectively unused.
> >
> > We have a patch under review which does in fact make use of the
> > signaling value:
> >
> > https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com/
>
> Huh, thanks for the link.
>
> Quoting from
> https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-ja=
z@semihalf.com/#25266856
>
> > Reading an eventfd returns an 8-byte value, we generally only use it
> > as a counter, but it's been discussed previously and IIRC, it's possibl=
e
> > to use that value as a notification value.
>
> So the goal is to pipe a specific value through eventfd? But it is
> explicitly a counter. The whole thing is written around a counter and
> each write and signal adds to the counter.
>
> The consequences are pretty well described in the cover letter of
> v6 https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com/
>
> > Since the eventfd counter is used as ACPI notification value
> > placeholder, the eventfd signaling needs to be serialized in order to
> > not end up with notification values being coalesced. Therefore ACPI
> > notification values are buffered and signalized one by one, when the
> > previous notification value has been consumed.
>
> But isn't this a good indication that you really don't want an eventfd
> but something that's explicitly designed to associate specific data with
> a notification? Using eventfd in that manner requires serialization,
> buffering, and enforces ordering.
>
> I have no skin in the game aside from having to drop this conversion
> which I'm fine to do if there are actually users for this btu really,
> that looks a lot like abusing an api that really wasn't designed for
> this.

https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-jaz@=
semihalf.com/
was posted at the beginig of March and one of the main things we've
discussed was the mechanism for propagating acpi notification value.
We've endup with eventfd as the best mechanism and have actually been
using it from v2. I really do not want to waste this effort, I think
we are quite advanced with v6 now. Additionally we didn't actually
modify any part of eventfd support that was in place, we only used it
in a specific (and discussed beforehand) way.
