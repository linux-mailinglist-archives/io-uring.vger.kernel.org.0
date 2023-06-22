Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6811173A6E0
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 19:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjFVRDK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 13:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjFVRDJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 13:03:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45094171C;
        Thu, 22 Jun 2023 10:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5DF36189D;
        Thu, 22 Jun 2023 17:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC32C433C0;
        Thu, 22 Jun 2023 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1687453387;
        bh=bTPWSed6ATavN9U5OfmHvXOmtlfLENbeNFQ2nEWL28k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cqgTLammDQGkc9nRI3L+FPR4xD/n/+LA+BC7NUMTKssxHlmUTQkbZn3zzlij2wg8K
         q8rKPbqVl34LFlKDbmsSubW9/ucihWzklC8Sq6rRs2p0Jx8TZMcYD65vEma9W0I3ip
         t9h1OX2xT/Ngwu+fvgTjdThlK0T3lqetXfJ71rr8=
Date:   Thu, 22 Jun 2023 19:03:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Breno Leitao <leitao@debian.org>
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
Message-ID: <2023062228-cloak-wish-ec12@gregkh>
References: <20230621232129.3776944-1-leitao@debian.org>
 <2023062231-tasting-stranger-8882@gregkh>
 <ZJRijTDv5lUsVo+j@gmail.com>
 <2023062208-animosity-squabble-c1ba@gregkh>
 <ZJR49xji1zmISlTs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJR49xji1zmISlTs@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 22, 2023 at 09:38:15AM -0700, Breno Leitao wrote:
> On Thu, Jun 22, 2023 at 06:10:00PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Jun 22, 2023 at 08:02:37AM -0700, Breno Leitao wrote:
> > > On Thu, Jun 22, 2023 at 07:20:48AM +0200, Greg Kroah-Hartman wrote:
> > > > On Wed, Jun 21, 2023 at 04:21:26PM -0700, Breno Leitao wrote:
> > > > > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > > > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > > > @@ -361,6 +361,7 @@ Code  Seq#    Include File                                           Comments
> > > > >  0xCB  00-1F                                                          CBM serial IEC bus in development:
> > > > >                                                                       <mailto:michael.klein@puffin.lb.shuttle.de>
> > > > >  0xCC  00-0F  drivers/misc/ibmvmc.h                                   pseries VMC driver
> > > > > +0xCC  A0-BF  uapi/linux/io_uring.h                                   io_uring cmd subsystem
> > > > 
> > > > This change is nice, but not totally related to this specific one,
> > > > shouldn't it be separate?
> > > 
> > > This is related to this patch, since I am using it below, in the
> > > following part:
> > > 
> > > 	+#define SOCKET_URING_OP_SIOCINQ _IOR(0xcc, 0xa0, int)
> > > 	+#define SOCKET_URING_OP_SIOCOUTQ _IOR(0xcc, 0xa1, int)
> > > 
> > > Should I have a different patch, even if they are related?
> > 
> > Yes, as you are not using the 0xa2-0xbf range that you just carved out
> > here, right?  Where did those numbers come from?
> 
> Correct. For now we are just using 0xa0 and 0xa1, and eventually we
> might need more ioctls numbers.
> 
> I got these numbers finding a unused block and having some room for
> expansion, as suggested by Documentation/userspace-api/ioctl/ioctl-number.rst,
> that says:
> 
> 	If you are writing a driver for a new device and need a letter, pick an
> 	unused block with enough room for expansion: 32 to 256 ioctl commands.

So is this the first io_uring ioctl?  If so, why is this an ioctl and
not just a "normal" io_uring call?

thanks,

greg k-h
