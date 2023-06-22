Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39DD73A8A6
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 20:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjFVS54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 14:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjFVS54 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 14:57:56 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BAC9B;
        Thu, 22 Jun 2023 11:57:54 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3113dabc549so6373464f8f.1;
        Thu, 22 Jun 2023 11:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687460272; x=1690052272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+D7IxMvZiNc4XLA71ABTPWob0+kv7MAt7f1wzI5iIVk=;
        b=iZ/UfTaOiB84bHYkRP8lgxCMFXL2DnnjP0dYt7uh8xnsz37f+pbDUsGPE25VXIPSio
         sLqnLAK4NGzhoaHXVU5pdfniRsh3E01SqcVGCMrLerKabWbwrTMJq8iUklm9T7Jy7Fld
         qjWUGDRR8St1rcjnJ//NsvGVwgquT74CAD4Hry+Qpsro/6Jc81i3sR+LnftPERbaQIms
         sBl0TEZUUuOKDP4cenx3BL12kjLd+ZCqUEwrXRsgaX8QpNXpeCqpyWIzA1Vl+W1ATSEK
         UJ4sxaVtVsHYyKf+v7G/gSQgcgB6RANPEXCe7J5A36nO29YJmcwuTE+ZNNLu9gyAYffE
         TUCQ==
X-Gm-Message-State: AC+VfDwaCT6mbRbODzzla/jebSR0oqIbD7wHuRqJJkhvIQZEVChPT3AY
        s/27+a7llhCOY6uhoxEtjt8=
X-Google-Smtp-Source: ACHHUZ7OEfuZDffKcXnV2k9Ljlw9v13ArnjKZS8lTi7RuFnPrVLeqPw8N/wH+jjpvea8d6UmNYVxsg==
X-Received: by 2002:a5d:530f:0:b0:311:14ab:5621 with SMTP id e15-20020a5d530f000000b0031114ab5621mr20128451wrv.30.1687460272341;
        Thu, 22 Jun 2023 11:57:52 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-120.fbsv.net. [2a03:2880:31ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id e25-20020a5d5959000000b003063db8f45bsm7660178wri.23.2023.06.22.11.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 11:57:51 -0700 (PDT)
Date:   Thu, 22 Jun 2023 11:57:49 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, leit@meta.com,
        Arnd Bergmann <arnd@arndb.de>,
        Steve French <stfrench@microsoft.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Simon Ser <contact@emersion.fr>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH] io_uring: Add io_uring command support for sockets
Message-ID: <ZJSZrXrzPXT9j4sr@gmail.com>
References: <20230621232129.3776944-1-leitao@debian.org>
 <2023062231-tasting-stranger-8882@gregkh>
 <ZJRijTDv5lUsVo+j@gmail.com>
 <2023062208-animosity-squabble-c1ba@gregkh>
 <ZJR49xji1zmISlTs@gmail.com>
 <2023062228-cloak-wish-ec12@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023062228-cloak-wish-ec12@gregkh>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 22, 2023 at 07:03:04PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Jun 22, 2023 at 09:38:15AM -0700, Breno Leitao wrote:
> > On Thu, Jun 22, 2023 at 06:10:00PM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Jun 22, 2023 at 08:02:37AM -0700, Breno Leitao wrote:
> > > > On Thu, Jun 22, 2023 at 07:20:48AM +0200, Greg Kroah-Hartman wrote:
> > > > > On Wed, Jun 21, 2023 at 04:21:26PM -0700, Breno Leitao wrote:
> > > > > > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > > > > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > > > > @@ -361,6 +361,7 @@ Code  Seq#    Include File                                           Comments
> > > > > >  0xCB  00-1F                                                          CBM serial IEC bus in development:
> > > > > >                                                                       <mailto:michael.klein@puffin.lb.shuttle.de>
> > > > > >  0xCC  00-0F  drivers/misc/ibmvmc.h                                   pseries VMC driver
> > > > > > +0xCC  A0-BF  uapi/linux/io_uring.h                                   io_uring cmd subsystem
> > > > > 
> > > > > This change is nice, but not totally related to this specific one,
> > > > > shouldn't it be separate?
> > > > 
> > > > This is related to this patch, since I am using it below, in the
> > > > following part:
> > > > 
> > > > 	+#define SOCKET_URING_OP_SIOCINQ _IOR(0xcc, 0xa0, int)
> > > > 	+#define SOCKET_URING_OP_SIOCOUTQ _IOR(0xcc, 0xa1, int)
> > > > 
> > > > Should I have a different patch, even if they are related?
> > > 
> > > Yes, as you are not using the 0xa2-0xbf range that you just carved out
> > > here, right?  Where did those numbers come from?
> > 
> > Correct. For now we are just using 0xa0 and 0xa1, and eventually we
> > might need more ioctls numbers.
> > 
> > I got these numbers finding a unused block and having some room for
> > expansion, as suggested by Documentation/userspace-api/ioctl/ioctl-number.rst,
> > that says:
> > 
> > 	If you are writing a driver for a new device and need a letter, pick an
> > 	unused block with enough room for expansion: 32 to 256 ioctl commands.
> 
> So is this the first io_uring ioctl?  If so, why is this an ioctl and
> not just a "normal" io_uring call?

This is a way to pass a generic command to file. This is not a ioctl per
se (not called through ioctl). I am leveraging the ioctl to embedded the
"direction" and "size" information in the command itself.

I can defintely do something as the following, if it is a better
implementation:

	#define SOCKET_URING_OP_SIOCINQ 0
	#define SOCKET_URING_OP_SIOCOUTQ 1
