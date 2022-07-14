Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF04E57406C
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 02:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiGNATT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 20:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiGNATS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 20:19:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE5C011453
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 17:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657757955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cYTecQwHshpf7b8DCjqwvpE5Y9uxd9DEd0zHHWe8xcw=;
        b=P7jM3WrjwSWbY/jj9QSTfafSVxvmiyeBakpBBc590cYzV7YC7/CDgtwwtr4tlqNrWfWEz+
        IAKXhS312iB9eCxGvyCwaFT82Th+ckLQ2f8shJPFYhfryVOIGBYqDGZF3U7ds253uW/Nzg
        MCAgee7OCGG3aV9NcYftV27haYXiINs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-6C1v3qamOLS7jr_OyTFtRQ-1; Wed, 13 Jul 2022 20:19:12 -0400
X-MC-Unique: 6C1v3qamOLS7jr_OyTFtRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B093101A54E;
        Thu, 14 Jul 2022 00:19:12 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50DB640E8B04;
        Thu, 14 Jul 2022 00:19:06 +0000 (UTC)
Date:   Thu, 14 Jul 2022 08:19:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH V5 0/2] ublk: add io_uring based userspace block driver
Message-ID: <Ys9g9RhZX5uwa9Ib@T590>
References: <20220713140711.97356-1-ming.lei@redhat.com>
 <6e5d590b-448d-ea75-f29d-877a2cd6413b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e5d590b-448d-ea75-f29d-877a2cd6413b@kernel.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 13, 2022 at 02:25:25PM -0600, Jens Axboe wrote:
> On 7/13/22 8:07 AM, Ming Lei wrote:
> > Hello Guys,
> > 
> > ublk driver is one kernel driver for implementing generic userspace block
> > device/driver, which delivers io request from ublk block device(/dev/ublkbN) into
> > ublk server[1] which is the userspace part of ublk for communicating
> > with ublk driver and handling specific io logic by its target module.
> 
> Ming, is this ready to get merged in an experimental state?

Hi Jens,

Yeah, I think so.

IO path can survive in xfstests(-g auto), and control path works
well in ublksrv builtin hotplug & 'kill -9' daemon test.

The UAPI data size should be good, but definition may change per
future requirement change, so I think it is ready to go as
experimental.

If you are fine, please add the following delta change into patch 1,
or let me know if resend is needed.


diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 2ba77fd960c2..e19fcab016ba 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -409,10 +409,13 @@ config BLK_DEV_RBD
 	  If unsure, say N.
 
 config BLK_DEV_UBLK
-	tristate "Userspace block driver"
+	tristate "Userspace block driver (Experimental)"
 	select IO_URING
 	help
-          io uring based userspace block driver.
+	  io_uring based userspace block driver. Together with ublk server, ublk
+	  has been working well, but interface with userspace or command data
+	  definition isn't finalized yet, and might change according to future
+	  requirement, so mark is as experimental now.
 
 source "drivers/block/rnbd/Kconfig"
 


Thanks,
Ming

