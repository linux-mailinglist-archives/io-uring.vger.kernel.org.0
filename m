Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195A6753282
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 09:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbjGNHFm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 03:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjGNHFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 03:05:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4912B171D;
        Fri, 14 Jul 2023 00:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C59AE61C37;
        Fri, 14 Jul 2023 07:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72352C433C8;
        Fri, 14 Jul 2023 07:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689318339;
        bh=jyWvUrZcUvjNBBSZOzXCNGPPxcxV/q9OYHwe4H3B3Lw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ukDx1eRh8ZivXqHNYBn5Q0ezu7jPxA8DBkgLn6Yr4ieEasOnILafdrjyXNGEm446B
         vdoY8r4oSZIdNajc3UECepRL8sXl8WF1aY3nsBTYeT1jETstZ0f8AhW7bTRQc/52Qq
         P+stCjuut9rZUb/FtZq2RC8GkYNcmH18gWUjcC/YVZwiCNSkJoOeVjb4/L8KcmM6xP
         IeKh3hfbNuWYqjO1NcV70XYwdDRmrE9otI0QO8uXvZ2x+z2rjsCQR5r+pIi8kHOFqH
         yUig3DyDnWCSEK1kxr9YLeu9ZSrBGXd6ZPFhVoSKNhVLjgUv6X+4bGRfk/gzLXxZ3w
         K4WbhoY8kPy2A==
Date:   Fri, 14 Jul 2023 09:05:21 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
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
        Xu Yilun <yilun.xu@intel.com>, jaz@semihalf.com
Subject: Re: [PATCH 0/2] eventfd: simplify signal helpers
Message-ID: <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230630155936.3015595-1-jaz@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 13, 2023 at 11:10:54AM -0600, Alex Williamson wrote:
> On Thu, 13 Jul 2023 12:05:36 +0200
> Christian Brauner <brauner@kernel.org> wrote:
> 
> > Hey everyone,
> > 
> > This simplifies the eventfd_signal() and eventfd_signal_mask() helpers
> > by removing the count argument which is effectively unused.
> 
> We have a patch under review which does in fact make use of the
> signaling value:
> 
> https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com/

Huh, thanks for the link.

Quoting from
https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-jaz@semihalf.com/#25266856

> Reading an eventfd returns an 8-byte value, we generally only use it
> as a counter, but it's been discussed previously and IIRC, it's possible
> to use that value as a notification value.

So the goal is to pipe a specific value through eventfd? But it is
explicitly a counter. The whole thing is written around a counter and
each write and signal adds to the counter.

The consequences are pretty well described in the cover letter of
v6 https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com/

> Since the eventfd counter is used as ACPI notification value
> placeholder, the eventfd signaling needs to be serialized in order to
> not end up with notification values being coalesced. Therefore ACPI
> notification values are buffered and signalized one by one, when the
> previous notification value has been consumed.

But isn't this a good indication that you really don't want an eventfd
but something that's explicitly designed to associate specific data with
a notification? Using eventfd in that manner requires serialization,
buffering, and enforces ordering.

I have no skin in the game aside from having to drop this conversion
which I'm fine to do if there are actually users for this btu really,
that looks a lot like abusing an api that really wasn't designed for
this.
