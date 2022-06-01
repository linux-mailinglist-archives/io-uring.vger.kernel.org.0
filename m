Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D7753AB7F
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 19:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbiFARFJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 13:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351597AbiFARFC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 13:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734D1A0D02
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 10:05:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FBE7B81BAF
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 17:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D28C385A5;
        Wed,  1 Jun 2022 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654103097;
        bh=aJDrtXDGATWjkeGhMzWmjZOsuJQRjIj0XVO7cK63Kr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eMwPURkau4tqXUvxogBa38OryQUHZWFBJ6rXJK/jPdxATizisQw6aU9ltB3qYFj2p
         inmuYJ2E41EmbdyVcZ6a83XKZ278gynCFY9AC9eSEth9RCmPWVOP4HJGRZWYnCGViP
         AnVmAxet+zBXSlJ5w90mRVvk4vM8VEmEp1N8fSA8SS0LzyBmcNHDY2eNIEK4KA3SVL
         08L+8P2eIiZkA1Bv4MfRrHd/aZwcVpeCko9mlEw3WUG1fEr3IsG5yFAiIJH0hS1Z+P
         qHxceMojiJkraCYuknmeSdLoRwOjz9fwndmNdbzIy/FWuDs6C7D8zySm3kSS3/d5b7
         A4d3itqXGhl+w==
Date:   Wed, 1 Jun 2022 10:04:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Message-ID: <20220601100456.037a763c@kernel.org>
In-Reply-To: <ddcb0deaa314e1541da86c8b2b297ae291a2b72e.camel@trillion01.com>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
        <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ddcb0deaa314e1541da86c8b2b297ae291a2b72e.camel@trillion01.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 01 Jun 2022 02:58:25 -0400 Olivier Langlois wrote:
> On Sat, 2022-03-26 at 12:28 -0700, Jakub Kicinski wrote:
> > On Fri, 18 Mar 2022 15:59:16 -0600 Jens Axboe wrote:  
> > > - Support for NAPI on sockets (Olivier)  
> > 
> > Were we CCed on these patches? I don't remember seeing them, 
> > and looks like looks like it's inventing it's own constants
> > instead of using the config APIs we have.  
> 
> No, you werent CCed on those patches. No one, including myself, did
> think that you would want to review code not in your subsystem and
> running scripts/get_maintainer.pl on the patch did not list your group.
> If not receiving an invitation did upset you, I am sorry. This was not
> intentional

All the talk about teams, groups and APIs. Like EXPORT_SYMBOL() is
supposed to be about crossing organizational boundaries.

Seems pretty obvious to me that netdev people and authors of the
original busy polling may have guidance and advice on networking uAPIs.

Maybe thinking more open and collaborative approach leads to better
results is naive. I'm certainly not trying to mark the territory or
anything like that.

> Can you be more explicit about the constants and the config API you are
> refering to?

I think I was talking about the setsockopts which can be used to modify
the polling parameters. I'm not 100% sure now, it was 2 months ago.
