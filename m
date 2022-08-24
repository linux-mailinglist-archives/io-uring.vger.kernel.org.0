Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C9F59F379
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 08:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiHXGLD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 02:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiHXGKz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 02:10:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCACB186C6;
        Tue, 23 Aug 2022 23:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB136113E;
        Wed, 24 Aug 2022 06:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDF9C433C1;
        Wed, 24 Aug 2022 06:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661321452;
        bh=8S6Si2CVUJ4bQuqVJVuhcS4NYT/mUhhFJIemYGM+Tj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SUU/Qui5+M+d1pUl90i10WbuQR+64BKtYzBovldhlc/9v9b3LW3t+IQz7nAocdEAg
         MTe3FnXrIqS+8nu7ls3FRJPB1ICFNPiyNfQzNg6lFFKLA98K9iq1KUmd6SVA0tGzZN
         W5HLy6u7SL7IN4UByqNW/8qYc7Fao7keDlu0ckq0=
Date:   Wed, 24 Aug 2022 08:10:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
Message-ID: <YwXA6f6SmAxyMxzX@kroah.com>
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly>
 <YwR5HBazPxWjcYci@kroah.com>
 <CAHC9VhQOSr_CnLmy0pwgUETPh565951DdejQtgkfNk7=tj+BNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQOSr_CnLmy0pwgUETPh565951DdejQtgkfNk7=tj+BNA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 23, 2022 at 01:02:08PM -0400, Paul Moore wrote:
> On Tue, Aug 23, 2022 at 2:52 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Aug 22, 2022 at 05:21:19PM -0400, Paul Moore wrote:
> > > This patch adds support for the io_uring command pass through, aka
> > > IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
> > > /dev/null functionality, the implementation is just a simple sink
> > > where commands go to die, but it should be useful for developers who
> > > need a simple IORING_OP_URING_CMD test device that doesn't require
> > > any special hardware.
> >
> > Also, shouldn't you document this somewhere?
> >
> > At least in the code itself saying "this is here so that /dev/null works
> > as a io_uring sink" or something like that?  Otherwise it just looks
> > like it does nothing at all.
> 
> What about read_null() and write_null()?  I can definitely add a
> comment (there is no /dev/null documentation in the kernel source tree
> that I can see), but there is clearly precedence for /dev/null having
> "do nothing" file_operations functions.

Yes, they should "do nothing".  write_null() does report that it
consumed everything, why doesn't this function have to also do that?

thanks,

greg k-h
