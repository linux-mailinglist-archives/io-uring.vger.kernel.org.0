Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11A773A428
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 17:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjFVPDi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 11:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjFVPDg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 11:03:36 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C26268F;
        Thu, 22 Jun 2023 08:03:17 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-311099fac92so8393016f8f.0;
        Thu, 22 Jun 2023 08:03:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687446160; x=1690038160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/n7cyBQWBJrKRj8jxj2QgN2B2DXg9ROG/UR9O3ggiI=;
        b=a4j/5BRe6ikbuTRZI5Ze/gfo7/DAUTTt/Asv4VPS1uMJMnPhnmuh7vFI2flJapVr4c
         UC+yvK8fb+aDyyZvCRQqGDk+z6C2DKUUyx3wBFeXmEI9B0wmB5U9DE2jqY5GiagcJfrP
         L8dbVkdFYlUXouFhKkFgQHP98vaipyQbb6tfM+JyUloqgfELr3LX9nXtijiuJAKg4IUy
         bGq8hnjoDEAGee1IoRlEYtX8GaYpNcyfn+3JaDGggBdTUd/YydevihI5Qxys3woJHATZ
         XJt4sFYP7WCONzGr3yDRDr7jzQStv5iZj3SNvu2G8J9O9dIuzKIOIs/NTwXlcElan5hc
         NuOw==
X-Gm-Message-State: AC+VfDyPcTNW4Dm1Yd08cbR4TKzHn8kKo3+YFCQJsXm9gb0Kn6EbXh3a
        iWdghonOgUchIPWqbhymzMs=
X-Google-Smtp-Source: ACHHUZ4+rOnjnE4sQgtZcmXX9Fey6w9aB4HaOV5Uy8o85WMhvf0KHxeyaE5uZbAjbZTWnWK8B5SjBw==
X-Received: by 2002:adf:f34f:0:b0:30f:b1ee:5cd0 with SMTP id e15-20020adff34f000000b0030fb1ee5cd0mr16382265wrp.50.1687446159714;
        Thu, 22 Jun 2023 08:02:39 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-021.fbsv.net. [2a03:2880:31ff:15::face:b00c])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d4c4f000000b003111025ec67sm7266818wrt.25.2023.06.22.08.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 08:02:39 -0700 (PDT)
Date:   Thu, 22 Jun 2023 08:02:37 -0700
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
Message-ID: <ZJRijTDv5lUsVo+j@gmail.com>
References: <20230621232129.3776944-1-leitao@debian.org>
 <2023062231-tasting-stranger-8882@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023062231-tasting-stranger-8882@gregkh>
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

On Thu, Jun 22, 2023 at 07:20:48AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 21, 2023 at 04:21:26PM -0700, Breno Leitao wrote:
> > Enable io_uring commands on network sockets. Create two new
> > SOCKET_URING_OP commands that will operate on sockets. Since these
> > commands are similar to ioctl, uses the _IO{R,W} helpers to embedded the
> > argument size and operation direction. Also allocates a unused ioctl
> > chunk for uring command usage.
> > 
> > In order to call ioctl on sockets, use the file_operations->uring_cmd
> > callbacks, and map it to a uring socket function, which handles the
> > SOCKET_URING_OP accordingly, and calls socket ioctls.
> > 
> > This patches was tested by creating a new test case in liburing.
> > Link: https://github.com/leitao/liburing/commit/3340908b742c6a26f662a0679c4ddf9df84ef431
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> 
> Isn't this a new version of an older patch?

Yes, this should have tagged as V2.

[1] https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/#r

> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -361,6 +361,7 @@ Code  Seq#    Include File                                           Comments
> >  0xCB  00-1F                                                          CBM serial IEC bus in development:
> >                                                                       <mailto:michael.klein@puffin.lb.shuttle.de>
> >  0xCC  00-0F  drivers/misc/ibmvmc.h                                   pseries VMC driver
> > +0xCC  A0-BF  uapi/linux/io_uring.h                                   io_uring cmd subsystem
> 
> This change is nice, but not totally related to this specific one,
> shouldn't it be separate?

This is related to this patch, since I am using it below, in the
following part:

	+#define SOCKET_URING_OP_SIOCINQ _IOR(0xcc, 0xa0, int)
	+#define SOCKET_URING_OP_SIOCOUTQ _IOR(0xcc, 0xa1, int)

Should I have a different patch, even if they are related?

> > +EXPORT_SYMBOL_GPL(uring_sock_cmd);
> 
> Did you forget the "io_" prefix?

Yes, I will rename the function.

Thanks for the review.
