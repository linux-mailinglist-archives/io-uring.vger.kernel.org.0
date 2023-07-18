Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E9975817C
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 17:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbjGRP4t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 11:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbjGRP4p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 11:56:45 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE63319A5
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 08:56:40 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-403ea0a50f7so18789001cf.1
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 08:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1689695800; x=1692287800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tjh+qVHNBsaCt+fpZytXbv4JtN2Kf+QfiKBiC+OQp3c=;
        b=bYsTsBY1ioUL9k8drjTPCTw/fEJ0EAlGX5g4owJLPMPxN2CHLKUwbHRdsGU8yNpkgq
         tSJhCUQojCe7iZMsDT/aY34J1oz2QHRzCjLM+KqEBEo9M8BD2KOp45IRPvgTMkckJ6dq
         H9fFQEgiHBZaevHiGZSqEfXqcoEtLjezHUCteBqtpUndGthYRfcrzEkhL4CGHaIFAcmx
         6wdKboUdDaPeOVdQT0aOEr8C1+gySsRWrc1UqrjcLLXuhZDet2FHUgbuPzKGfDMScL/V
         K78x7SFpD7MaWzPqAIp0HWYQyARw7uG7tneLlNjtBlR/Fv5UIeG6Vm/K9G6rR6HJEl7q
         8oNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689695800; x=1692287800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tjh+qVHNBsaCt+fpZytXbv4JtN2Kf+QfiKBiC+OQp3c=;
        b=G/y1UiL1Ny+20Ht6Fsii/gckFeVW0yCGAqRBFvb58nJqGwQci4bvEHX9oUkzKjT3Hp
         jPWBWHM/Nrqio7lSMNvg9ys/2TdAs1hrosOk998IItOBXfprNFJV00vNGO4Kr3IO1c/k
         14X3ze8H14J1yOeVGZoieHMubTpLOAGlbJnnjfgW51O+d1nGy8uE/+OESy7myi1TN3cB
         15Yn9LuUHtQ9ddQ7TjuIY8nlSUE9HBROIKLGtiOA658yZg+GcTk6Xi39x3BWd/K+vY8e
         uiOWxTPzt9I8Gpe/oBQI1XonNwrr7HXtX+zvn5WIVwxDLn8bebSKEZkdgUkXoRu1Y6mW
         2t3w==
X-Gm-Message-State: ABy/qLb7UW0OJULC3W0KHYnFwIJl77geSPHS9qK0lxQfv7Enkbm8Oe6j
        rpR5n8viYZGYjxuIsJUK10Sonw==
X-Google-Smtp-Source: APBJJlFA9677r6PhZxjwKlQ1fKWxhiNMVqP6N1YqyjTADbRS7wwnXs7xld1btAoYMOwt7mM3Vw+c9w==
X-Received: by 2002:ac8:7dd0:0:b0:403:a814:ef4d with SMTP id c16-20020ac87dd0000000b00403a814ef4dmr21293071qte.49.1689695800050;
        Tue, 18 Jul 2023 08:56:40 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id s21-20020ac87595000000b003e635f80e72sm727847qtq.48.2023.07.18.08.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 08:56:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qLn42-002YJT-5I;
        Tue, 18 Jul 2023 12:56:38 -0300
Date:   Tue, 18 Jul 2023 12:56:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Grzegorz Jaszczyk <jaz@semihalf.com>,
        Christian Brauner <brauner@kernel.org>,
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
        Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <ZLa2NmwexoxPkS9a@ziepe.ca>
References: <20230630155936.3015595-1-jaz@semihalf.com>
 <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
 <CAH76GKPF4BjJLrzLBW8k12ATaAGADeMYc2NQ9+j0KgRa0pomUw@mail.gmail.com>
 <20230717130831.0f18381a.alex.williamson@redhat.com>
 <ZLW8wEzkhBxd0O0L@ziepe.ca>
 <20230717165203.4ee6b1e6.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717165203.4ee6b1e6.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 17, 2023 at 04:52:03PM -0600, Alex Williamson wrote:
> On Mon, 17 Jul 2023 19:12:16 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Mon, Jul 17, 2023 at 01:08:31PM -0600, Alex Williamson wrote:
> > 
> > > What would that mechanism be?  We've been iterating on getting the
> > > serialization and buffering correct, but I don't know of another means
> > > that combines the notification with a value, so we'd likely end up with
> > > an eventfd only for notification and a separate ring buffer for
> > > notification values.  
> > 
> > All FDs do this. You just have to make a FD with custom
> > file_operations that does what this wants. The uAPI shouldn't be able
> > to tell if the FD is backing it with an eventfd or otherwise. Have the
> > kernel return the FD instead of accepting it. Follow the basic design
> > of eg mlx5vf_save_fops
> 
> Sure, userspace could poll on any fd and read a value from it, but at
> that point we're essentially duplicating a lot of what eventfd provides
> for a minor(?) semantic difference over how the counter value is
> interpreted.  Using an actual eventfd allows the ACPI notification to
> work as just another interrupt index within the existing vfio IRQ
> uAPI.

Yes, duplicated, sort of, whatever the "ack" is to allow pushing a new
value can be revised to run as part of the read.

But I don't really view it as a minor difference. eventfd is a
counter. It should not be abused otherwise, even if it can be made to
work.

It really isn't an IRQ if it is pushing an async message w/data.

Jason
