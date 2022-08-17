Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7A55969D6
	for <lists+io-uring@lfdr.de>; Wed, 17 Aug 2022 08:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiHQGtj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Aug 2022 02:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbiHQGti (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Aug 2022 02:49:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50434D4C4;
        Tue, 16 Aug 2022 23:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 711E66114F;
        Wed, 17 Aug 2022 06:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8642C433C1;
        Wed, 17 Aug 2022 06:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660718975;
        bh=08ntRBn7X58UTGsESkqDo/Jh2OBIjZLXmZ6bzpaRq3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8XSB2SGpdDox2o+oMKsH54U3D8YO3KmMh7BHJzEFC89tjetgy1aiB6i95mk+0OGK
         LrvLBaAmQNCouqh46A9QUDCV7PAfTW7PCW+4ssXxEwm8OthlBQnZrxE0WStoN5obQT
         kHkGUUJLtvjbC2k7oKLRac2F3TUWpnf1u6Y3lP1U=
Date:   Wed, 17 Aug 2022 08:49:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jiacheng Xu <578001344xu@gmail.com>, linux-kernel@vger.kernel.org,
        asml.silence@gmail.co, io-uring@vger.kernel.org,
        security@kernel.org
Subject: Re: KASAN: null-ptr-deref Write in io_file_get_normal
Message-ID: <YvyPe7cKY2sLzbJt@kroah.com>
References: <CAO4S-mdVW5GkODk0+vbQexNAAJZopwzFJ9ACvRCJ989fQ4A6Ow@mail.gmail.com>
 <YvvD+wB64nBSpM3M@kroah.com>
 <5bf54200-5b12-33b0-8bf3-0d1c6718cfba@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bf54200-5b12-33b0-8bf3-0d1c6718cfba@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 16, 2022 at 10:57:39AM -0600, Jens Axboe wrote:
> On 8/16/22 10:21 AM, Greg KH wrote:
> > On Wed, Aug 17, 2022 at 12:10:09AM +0800, Jiacheng Xu wrote:
> >> Hello,
> >>
> >> When using modified Syzkaller to fuzz the Linux kernel-5.15.58, the
> >> following crash was triggered.
> > 
> > As you sent this to public lists, there's no need to also cc:
> > security@k.o as there's nothing we can do about this.
> 
> Indeed...
> 
> > Also, random syzbot submissions are best sent with a fix for them,
> > otherwise it might be a while before they will be looked at.
> 
> Greg, can you cherrypick:
> 
> commit 386e4fb6962b9f248a80f8870aea0870ca603e89
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Jun 23 11:06:43 2022 -0600
> 
>     io_uring: use original request task for inflight tracking
> 
> into 5.15-stable? It should pick cleanly and also fix this issue.
> 
> -- 
> Jens Axboe
> 
> 

Thanks, will do after this next round of releases go out.

greg k-h
