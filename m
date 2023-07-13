Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFB4751E46
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 12:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbjGMKGk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 06:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbjGMKGT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 06:06:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16961270F;
        Thu, 13 Jul 2023 03:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BF4A608D5;
        Thu, 13 Jul 2023 10:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6875C433C8;
        Thu, 13 Jul 2023 10:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689242764;
        bh=uxBF/65cfGgFc9NUZsYBWMo4c7yjkoqCGF6QeEUJdAY=;
        h=From:Subject:Date:To:Cc:From;
        b=fMIucUY7GArhLgcLDCFIQxCyAzXRgRPE8TkbNnY5GyU1HBPhbd5464W8Yg6jjQ1lL
         m6CWFlXeaqd10iV8ptWkOllE56aJPowyXSs5WiPty1Qsblb5rDh7+XYZZkXkukuQUD
         2oiaMlw7C0sww3ot9gyUkCaU1j297MtNOoU25HevXc+ptbrPhHq2Zk21bLHu2o2olV
         KM6Bl/kUQtYvAIUPH+MSd/KGQP+HX58eb57Amnb444A4mU/RQ41PTUTV2bTgUUDM37
         0Ncnb1LvDeYFhV3bcDM22YynZx1G+N6CQHl4PYcq4tdmwsqnstpRPCpNQMucQad6SH
         v0+dq9gbDJkNg==
From:   Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] eventfd: simplify signal helpers
Date:   Thu, 13 Jul 2023 12:05:36 +0200
Message-Id: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHDMr2QC/x3MwQrCMAyA4VcZORtpN9jAVxEPaZtuAY3SSBHG3
 t3o8Tv8/w7GTdjgMuzQuIvJUx3xNEDeSFdGKW4YwziFJU7YqyF31nctaLIq3TGkUOK8UJk5g4e
 vxlU+/+n15k5kjKmR5u238sP5IZbhOL4kMfO0fwAAAA==
To:     linux-fsdevel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>, Oded Gabbay <ogabbay@kernel.org>,
        Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>,
        Moritz Fischer <mdf@kernel.org>, Xu Yilun <yilun.xu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christian Brauner <brauner@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <muchun.song@linux.dev>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-aio@kvack.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=276; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uxBF/65cfGgFc9NUZsYBWMo4c7yjkoqCGF6QeEUJdAY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSsP1PLoVi0NYRvYnj1752/FbjTRLb2F5/eK1jjLMP8OeoE
 g8DNjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlwrGT4n2l3WEWjd0VXqt6ih11Ns1
 YfjrROvjc3V73IYWbr0apscUaGq6+my1lGuQtz2O564OagKGE5qVEnsLx/a9H1rIRnpwXZAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hey everyone,

This simplifies the eventfd_signal() and eventfd_signal_mask() helpers
by removing the count argument which is effectively unused.

---



---
base-commit: 6be357f00aad4189130147fdc6f568cf776a4909
change-id: 20230713-vfs-eventfd-signal-0b0d167ad6ec

