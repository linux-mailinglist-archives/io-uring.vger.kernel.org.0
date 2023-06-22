Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CA973A8B8
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjFVTBu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjFVTBt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 15:01:49 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4659B;
        Thu, 22 Jun 2023 12:01:48 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-31121494630so8626255f8f.3;
        Thu, 22 Jun 2023 12:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687460506; x=1690052506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQKzGLLngarWVhVTw2URKzbQiX5Xh0ThcGjikbK/29A=;
        b=UDaogkxedFUKrLBbokO3Ju1XWzQsshU4NzizhE111YxjVL/KNgAdifnWs3aZVyEqnh
         vZLqxNQG2p5Z41RNyZ2k1HYP7KJToFUID1byUceENvRpFn2nmR/Fk/3WzleWGvlOzZBg
         cbtsILSaBxvPwgt6bsmd3HEx6TR2HX3bnAuRa0OHGTEDRRUKAYhbmcvyN+XtUXdS/smy
         TqIuucLOcep/obdp00dn2uafwYJ/S4an7+fCBuCNKM4VQh2n7V5rQ5kAexgk9ST+XZnL
         BsB9yEtdUnp3AvAw+5NPltZEX4Znv66aHgXRugSSkasJa4s8vfAHsOaoVqBv/jNSCYWT
         wHaw==
X-Gm-Message-State: AC+VfDzUGonVeZqp2rk4tW0X5cz5cCvSnqP0udUDlT/eVoGBUMoR85aJ
        NuctXn7FZLyWZHinSTcAZt0=
X-Google-Smtp-Source: ACHHUZ4Fm507H6gAfhlPKOCV3A52LQqvUW+RMQ+AjS6G760+nRpx0UGIk5+/UcW36fRpV4dsuqghUA==
X-Received: by 2002:a5d:67cd:0:b0:2ef:b052:1296 with SMTP id n13-20020a5d67cd000000b002efb0521296mr17148852wrw.22.1687460506529;
        Thu, 22 Jun 2023 12:01:46 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-004.fbsv.net. [2a03:2880:31ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id j11-20020a5d604b000000b003078681a1e8sm7680789wrt.54.2023.06.22.12.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 12:01:46 -0700 (PDT)
Date:   Thu, 22 Jun 2023 12:01:44 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Message-ID: <ZJSamAduIRJ3b/TX@gmail.com>
References: <20230621232129.3776944-1-leitao@debian.org>
 <2023062231-tasting-stranger-8882@gregkh>
 <ZJRijTDv5lUsVo+j@gmail.com>
 <2023062208-animosity-squabble-c1ba@gregkh>
 <ZJR49xji1zmISlTs@gmail.com>
 <2023062228-cloak-wish-ec12@gregkh>
 <20230622103948.33cbb0dd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622103948.33cbb0dd@kernel.org>
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

On Thu, Jun 22, 2023 at 10:39:48AM -0700, Jakub Kicinski wrote:
> On Thu, 22 Jun 2023 19:03:04 +0200 Greg Kroah-Hartman wrote:
> > > Correct. For now we are just using 0xa0 and 0xa1, and eventually we
> > > might need more ioctls numbers.
> > > 
> > > I got these numbers finding a unused block and having some room for
> > > expansion, as suggested by Documentation/userspace-api/ioctl/ioctl-number.rst,
> > > that says:
> > > 
> > > 	If you are writing a driver for a new device and need a letter, pick an
> > > 	unused block with enough room for expansion: 32 to 256 ioctl commands.  
> > 
> > So is this the first io_uring ioctl?  If so, why is this an ioctl and
> > not just a "normal" io_uring call?
> 
> +1, the mixing with classic ioctl seems confusing and I'm not sure 
> if it buys us anything.

Sure, let me remove the dependency on ioctl()s then.
