Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C4952305A
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 12:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbiEKKJv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 06:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiEKKJk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 06:09:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8380983030;
        Wed, 11 May 2022 03:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EC7E614FB;
        Wed, 11 May 2022 10:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB001C340ED;
        Wed, 11 May 2022 10:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652263776;
        bh=Az7KghA1K1FqtzlIeR2ZSVJbO3Qd9hiek6Rayqy2SXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KAfyyUFMRyTcwHJtjpKhA0wviVF4xIq7ed1TBkPpgwzEBowjZ8erykABk6KszpRpo
         meKTyOR/6C/fWl/uIJkFioOhTCDCBBIB97Fz4XXvZgiG6ZA7NY4e28ItHZx4mmSxLO
         PQQimceoELvHoRr92n6G6UsSYvyW8GRpT57fXtdQ=
Date:   Wed, 11 May 2022 12:09:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "zhanghongtao (A)" <zhanghongtao22@huawei.com>
Cc:     akpm@linux-foundation.org, linfeilong@huawei.com,
        suweifeng1@huawei.com, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH] drivers:uio: Fix system crashes during driver switchover
Message-ID: <YnuLXTu1wXvCbP/x@kroah.com>
References: <d204cc88-887c-b203-5a5b-01c307fda4fb@huawei.com>
 <YntcNunjPdb3Clry@kroah.com>
 <889918de-e0b8-1ee1-ab86-ca02c8aa35b9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <889918de-e0b8-1ee1-ab86-ca02c8aa35b9@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, May 11, 2022 at 04:51:11PM +0800, zhanghongtao (A) wrote:
> Thanks for your reply.
> I looked through the historical emails and thought I was not the
> same problem as his.
> After the driver is switched, the application can still operate
> on the mapped address, which causes the system to crash.
> The application is not aware of the driver's switchover.
> The solution I can think of is to block the switch and wait for
> the application to release before switching, as shown in the patch.
> So want to seek help from the community, how to solve it better?
> Is there a better way?

A better way to do what?  I have no context here at all, sorry.

What is "switching" the driver?  If it is root by doing a bind/unbind,
then you are on your own and have to do that very carefully, right?

thanks,

greg k-h
