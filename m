Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB0F59D188
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 08:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbiHWGwt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 02:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239988AbiHWGws (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 02:52:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D524E32EF3;
        Mon, 22 Aug 2022 23:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92235B81995;
        Tue, 23 Aug 2022 06:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB91C433D6;
        Tue, 23 Aug 2022 06:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661237564;
        bh=vGvwBqmBj9kege1Mu3cMzG5gppy3ThrWIO+j3vcXwB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kcOu0TtrrQSpnY3V3GkJQ/LVxOGIDB2rLz5JPm4MYC4fNJEVKWsaZ6BLGW+Apbnk+
         LA0BIc2ah+5fVVitJbmYVoR+uauWxBu66mmWGYiEB2JUwMpj5xB4anLRHbyQuQ6CoX
         07UWJv/RH4aWF4qheM++X1UI63sT1d7vaQZ14cMI=
Date:   Tue, 23 Aug 2022 08:52:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 2/3] selinux: implement the security_uring_cmd() LSM hook
Message-ID: <YwR5OZ+tsu51pB8l@kroah.com>
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327379.369593.4939320600435400704.stgit@olly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166120327379.369593.4939320600435400704.stgit@olly>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 22, 2022 at 05:21:13PM -0400, Paul Moore wrote:
> Add a SELinux access control for the iouring IORING_OP_URING_CMD
> command.  This includes the addition of a new permission in the
> existing "io_uring" object class: "cmd".  The subject of the new
> permission check is the domain of the process requesting access, the
> object is the open file which points to the device/file that is the
> target of the IORING_OP_URING_CMD operation.  A sample policy rule
> is shown below:
> 
>   allow <domain> <file>:io_uring { cmd };
> 
> Cc: stable@vger.kernel.org

This is not stable material as you are adding a new feature.  Please
read the stable documentation for what is and is not allowed.

thanks,

greg k-h
