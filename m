Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADEE73A76B
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 19:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjFVRj7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 13:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjFVRjy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 13:39:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCD31FD2;
        Thu, 22 Jun 2023 10:39:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C65C618CA;
        Thu, 22 Jun 2023 17:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52726C433C8;
        Thu, 22 Jun 2023 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687455589;
        bh=6Mcce3nF6YdsClruQbW80qlgIDWGMFESghPF7l7JYTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c/wGJVyyFBHOwRk677FOXLxKHfOpmo7aYhn8TXoCyysBSD9UN0HRCi/VIEy4fVtc3
         d1Gtwc4Tlz0ZMOG6N2t6zeJCnCq0Ac3UfKvnIvE5ZZRksc5XHdNUCO3ys3TEVyYqB9
         O5aTb6ejHzcie2Y3dxe6TFO3Tx54mwjqIDfllxxT2yeNQkcittmTYy4ty+rg7d5x/5
         gYUetO9mpIHBZhBPcQIevv1XEy0sHwQScl/zfyoUZDduBaQ4FV+wexEVRBjKC+uN3K
         nVASNPf6jJeZE8DcXCk8LoxzJA9L3gYZjf9cqV9w6ceYkEMCGPZirph5X8Wsb8TCwX
         wosPPNlFHhh3g==
Date:   Thu, 22 Jun 2023 10:39:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Breno Leitao <leitao@debian.org>
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
Message-ID: <20230622103948.33cbb0dd@kernel.org>
In-Reply-To: <2023062228-cloak-wish-ec12@gregkh>
References: <20230621232129.3776944-1-leitao@debian.org>
        <2023062231-tasting-stranger-8882@gregkh>
        <ZJRijTDv5lUsVo+j@gmail.com>
        <2023062208-animosity-squabble-c1ba@gregkh>
        <ZJR49xji1zmISlTs@gmail.com>
        <2023062228-cloak-wish-ec12@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 22 Jun 2023 19:03:04 +0200 Greg Kroah-Hartman wrote:
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

+1, the mixing with classic ioctl seems confusing and I'm not sure 
if it buys us anything.
-- 
pw-bot: cr
