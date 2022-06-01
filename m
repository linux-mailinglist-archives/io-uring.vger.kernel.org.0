Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB653AB05
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 18:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344314AbiFAQYc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 12:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347929AbiFAQYc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 12:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C0B8D6A5
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 09:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E65761597
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 16:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696F1C3411C;
        Wed,  1 Jun 2022 16:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654100669;
        bh=yk5oVwOf9gF45vUfOuLMNv53AupSiVNfzVWdnWWAcGM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jS3d5JY6vWIl/Ggg4fGkN+2OLXpWNo1IvJ/JYWoJHJcK1qztTjzvgM1gRRYiC3CFU
         I82b2MWnDwaD6Tdp52r9VgH3OhIeNAmvIPRfbMZKuyQgwGnQ9GGfroKRZSL+4smWGj
         BXj6kKy2rKPKY7pgvvPkMtr5HaOXfs/NHkGnZvlyt+c667VgqxrXqPi7jUPMpm2XvK
         50reInHbGESqaA7YQdhdjf+pSSj18HwZmFB7u+18CiX0GGFf7y0bPPandJfUSnqaQ4
         mUspSUjrypm/nYedqyd+nLbeoWAMApeDuycmiE+4YHOF1pKm+fDJOynjqSOM2WYgVw
         +shEI4tojXsbg==
Date:   Wed, 1 Jun 2022 09:24:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Message-ID: <20220601092428.6e7a13a7@kernel.org>
In-Reply-To: <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
        <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
        <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
        <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
        <20220326143049.671b463c@kernel.org>
        <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
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

On Wed, 01 Jun 2022 02:59:12 -0400 Olivier Langlois wrote:
> > I'm not entirely clear how the thing is supposed to be used with TCP
> > socket, as from a quick grep it appears that listening sockets don't
> > get napi_id marked at all.
> > 
> > The commit mentions a UDP benchmark, Olivier can you point me to more
> > info on the use case? I'm mostly familiar with NAPI busy poll with
> > XDP
> > sockets, where it's pretty obvious.  
> 
> https://github.com/lano1106/io_uring_udp_ping
> 
> IDK what else I can tell you. I choose to unit test the new feature
> with an UDP app because it was the simplest setup for testing. AFAIK,
> the ultimate goal of busy polling is to minimize latency in packets
> reception and the NAPI busy polling code should not treat differently
> packets whether they are UDP or TCP or whatever the type of frames the
> NIC does receive...

IDK how you use the busy polling, so I'm asking you to describe what
your app does. You said elsewhere that you don't have dedicated thread
per queue so it's not a server app (polling for requests) but a client
app (polling for responses)?
