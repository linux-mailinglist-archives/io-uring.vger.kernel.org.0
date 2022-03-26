Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D2F4E83FF
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 21:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbiCZUH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Mar 2022 16:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiCZUH5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Mar 2022 16:07:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0D5204A9E
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 13:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECE1BB80B62
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 20:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC1DC2BBE4;
        Sat, 26 Mar 2022 20:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648325177;
        bh=mh4CTpS3+5z4yU8doxvFYQYqi2OJsjvp/SsPoBk6Eos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PyKmgoaxTcREXc05xLKj9kjcLT8C/8toj+ZJOTfwSRpj27RsOgQ5+8pWwsxYEXoge
         Oe2B/YC0mcQ8GwG3AwpA56WR3TPrQjhWhABUtdBJL+Vb5Xama2agAwxv7cdJkfYLqw
         flytgNrd/cpRBtUE6pqNXdyNMzjtarOTldCAD9uTQqvHRuCJQR8P1dVFwHM21T3uEc
         no6NFy05FVIaXrGyzoKGy9/hX5bpaynqXd3+rpBzw2Gx9vSUzNG80w9ze23zNiqSyv
         ihyo7O1tzup9DneLxgaUBmUYRExYC18jmQDNqtqgWkTeZi9UzU6FUtwH9vwL1ZdfIs
         0xFlFj8NxmkZQ==
Date:   Sat, 26 Mar 2022 13:06:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Message-ID: <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
        <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 26 Mar 2022 13:47:24 -0600 Jens Axboe wrote:
> On 3/26/22 1:28 PM, Jakub Kicinski wrote:
> > On Fri, 18 Mar 2022 15:59:16 -0600 Jens Axboe wrote:  
> >> - Support for NAPI on sockets (Olivier)  
> > 
> > Were we CCed on these patches? I don't remember seeing them, 
> > and looks like looks like it's inventing it's own constants
> > instead of using the config APIs we have.  
> 
> Don't know if it was ever posted on the netdev list

Hm, maybe I don't understand how things are supposed to work. 
I'm surprised you're unfazed.

> but the patches have been discussed for 6-9 months on the io_uring
> list.

You may need explain to me how that's relevant :) 
The point is the networking maintainers have not seen it.

> Which constants are you referring to? Only odd one I see is
> NAPI_TIMEOUT, other ones are using the sysctl bits. If we're
> missing something here, do speak up and we'll make sure it's
> consistent with the regular NAPI.

SO_BUSY_POLL_BUDGET, 8 is quite low for many practical uses.
I'd also like to have a conversation about continuing to use
the socket as a proxy for NAPI_ID, NAPI_ID is exposed to user
space now. io_uring being a new interface I wonder if it's not 
better to let the user specify the request parameters directly.

> Adding Olivier who wrote the NAPI support.
> 

