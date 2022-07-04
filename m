Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E50456557D
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 14:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiGDMek (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 08:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiGDMei (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 08:34:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4085E11C1C
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 05:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656938070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9UB4cMRFdeVOiRIbGYBVc5TxD3EzBsUt7mV4+/Fo8vI=;
        b=Rp+7pzb7f5d+RBwpf0eNsM5uKCiegtFqV7CE1v+gDU19D+kqzxtsGZZ+4hx4jhVY4tvJ2q
        tlLXGZqzYrQlJq8w9HcA1Fkp8oUCRjlwsxw04687D41bEzRujm1S4kcqeifajtUg18dNjD
        gN+7cyOir4cREeXIAXqKPh9QX7sQHeI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-EXIVYpsfOsGpiTZVNGBghg-1; Mon, 04 Jul 2022 08:34:27 -0400
X-MC-Unique: EXIVYpsfOsGpiTZVNGBghg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C29ED85A581;
        Mon,  4 Jul 2022 12:34:26 +0000 (UTC)
Received: from T590 (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9759D2026D64;
        Mon,  4 Jul 2022 12:34:20 +0000 (UTC)
Date:   Mon, 4 Jul 2022 20:34:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Message-ID: <YsLeR1QWPmqfNAQY@T590>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
 <da861bbb-1506-7598-fa06-32201456967d@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da861bbb-1506-7598-fa06-32201456967d@grimberg.me>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 04, 2022 at 02:17:44PM +0300, Sagi Grimberg wrote:
> 
> > This is the driver part of userspace block driver(ublk driver), the other
> > part is userspace daemon part(ublksrv)[1].
> > 
> > The two parts communicate by io_uring's IORING_OP_URING_CMD with one
> > shared cmd buffer for storing io command, and the buffer is read only for
> > ublksrv, each io command is indexed by io request tag directly, and
> > is written by ublk driver.
> > 
> > For example, when one READ io request is submitted to ublk block driver, ublk
> > driver stores the io command into cmd buffer first, then completes one
> > IORING_OP_URING_CMD for notifying ublksrv, and the URING_CMD is issued to
> > ublk driver beforehand by ublksrv for getting notification of any new io request,
> > and each URING_CMD is associated with one io request by tag.
> > 
> > After ublksrv gets the io command, it translates and handles the ublk io
> > request, such as, for the ublk-loop target, ublksrv translates the request
> > into same request on another file or disk, like the kernel loop block
> > driver. In ublksrv's implementation, the io is still handled by io_uring,
> > and share same ring with IORING_OP_URING_CMD command. When the target io
> > request is done, the same IORING_OP_URING_CMD is issued to ublk driver for
> > both committing io request result and getting future notification of new
> > io request.
> > 
> > Another thing done by ublk driver is to copy data between kernel io
> > request and ublksrv's io buffer:
> > 
> > 1) before ubsrv handles WRITE request, copy the request's data into
> > ublksrv's userspace io buffer, so that ublksrv can handle the write
> > request
> > 
> > 2) after ubsrv handles READ request, copy ublksrv's userspace io buffer
> > into this READ request, then ublk driver can complete the READ request
> > 
> > Zero copy may be switched if mm is ready to support it.
> > 
> > ublk driver doesn't handle any logic of the specific user space driver,
> > so it should be small/simple enough.
> > 
> > [1] ublksrv
> > 
> > https://github.com/ming1/ubdsrv
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   drivers/block/Kconfig         |    6 +
> >   drivers/block/Makefile        |    2 +
> >   drivers/block/ublk_drv.c      | 1603 +++++++++++++++++++++++++++++++++
> >   include/uapi/linux/ublk_cmd.h |  158 ++++
> >   4 files changed, 1769 insertions(+)
> >   create mode 100644 drivers/block/ublk_drv.c
> >   create mode 100644 include/uapi/linux/ublk_cmd.h
> > 
> > diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> > index fdb81f2794cd..d218089cdbec 100644
> > --- a/drivers/block/Kconfig
> > +++ b/drivers/block/Kconfig
> > @@ -408,6 +408,12 @@ config BLK_DEV_RBD
> >   	  If unsure, say N.
> > +config BLK_DEV_UBLK
> > +	bool "Userspace block driver"
> 
> Really? why compile this to the kernel and not tristate as loadable
> module?

So far, this is only one reason: task_work_add() is required, which
isn't exported for modules.


Thanks,
Ming

