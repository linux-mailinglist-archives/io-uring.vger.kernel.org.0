Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70794529AF4
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 09:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241347AbiEQHgl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 03:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241734AbiEQHft (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 03:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA9449CB3;
        Tue, 17 May 2022 00:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EE4AB8173C;
        Tue, 17 May 2022 07:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B75CC34117;
        Tue, 17 May 2022 07:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652772870;
        bh=3Mn3c9Wc7pD+d1aaszgA1Yd1K2ZOziotgCCcTDcQogU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ov0YAdW0dQEPS6r5cwxm4rehQQTijgFvDwpS8QGxvUnq2wgQSOQRaeLri6T7d9qMm
         E/JhKFR2afH8wHZKiLkYvRm1p9NDyEMvGrTuYZIr20xujkmAJpScFrMfF1T6zLalfJ
         m+UnJ8I2VwDAK6RgxmIzZkO6Mk47Dx/WXcw0H1MY=
Date:   Tue, 17 May 2022 09:34:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "zhanghongtao (A)" <zhanghongtao22@huawei.com>
Cc:     akpm@linux-foundation.org, linfeilong@huawei.com,
        suweifeng1@huawei.com, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH] drivers:uio: Fix system crashes during driver switchover
Message-ID: <YoNQA0OuGtj2Q9o3@kroah.com>
References: <d204cc88-887c-b203-5a5b-01c307fda4fb@huawei.com>
 <YntcNunjPdb3Clry@kroah.com>
 <889918de-e0b8-1ee1-ab86-ca02c8aa35b9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <889918de-e0b8-1ee1-ab86-ca02c8aa35b9@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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

Yes, do not unbind the driver from the device unless all userspace
programs have stopped using the device.

Also, do not use the UIO driver for disk devices, that way is crazy, use
a real block driver.  What prevents you from doing that today?

thanks,

greg k-h
