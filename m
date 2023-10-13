Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C407C899F
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 18:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjJMQD2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 12:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbjJMQD2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 12:03:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCD4BD;
        Fri, 13 Oct 2023 09:03:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE306C433C8;
        Fri, 13 Oct 2023 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697213006;
        bh=mcv6vZBKM2c2x3X7SAMdPBiYtPn9l0sRcjbP8ZSJ5z4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MrF9MdWF4vAESJ/XDsEGBcBpXrsoKIgrVVO76N7PlbkbgEUGDha7Xm94oXOGXe2Ns
         uWd9TE+aXkxYmIBlXFaafRP2d5mVEkIYhXYAIgygSaUMtXmD1Xkqlr3sILI16n16Ts
         o6j7GxZjNekad8tKLy2idhnP8Yka1MEOWSiLb4vIzwTChKb4fgALRBgTlyN/nsoawS
         t/rEtQPo4av2FBphw+EBSMW/96CvbJ8k87y+kDXM08mIWAX0EtxaF6IHDmIoeFJTUf
         K0Lf5BQz75FTczg6LP2ihMG7AuayOqPgq6qE+cuQv18hDNC0Hn7Y2cu/WOr3sjmEe/
         tRfAX80bPHYbw==
Date:   Fri, 13 Oct 2023 18:03:20 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dan Clash <daclash@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, paul@paul-moore.com,
        linux-fsdevel@vger.kernel.org, dan.clash@microsoft.com,
        audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] audit,io_uring: io_uring openat triggers audit reference
 count underflow
Message-ID: <20231013-keilen-erdkruste-7a1154fb0da0@brauner>
References: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20231013-karierte-mehrzahl-6a938035609e@brauner>
 <f1a37128-004b-4605-81a5-11f778cd5498@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f1a37128-004b-4605-81a5-11f778cd5498@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > Picking this up as is. Let me know if this needs another tree.
> 
> Since it's really vfs related, your tree is fine.
> 
> > Applied to the vfs.misc branch of the vfs/vfs.git tree.
> > Patches in the vfs.misc branch should appear in linux-next soon.
> 
> You'll send it in for 6.6, right?

Given that it fixes a bug, yeah. I'll let it sit until Monday so other's
have a moment to speak up though.
