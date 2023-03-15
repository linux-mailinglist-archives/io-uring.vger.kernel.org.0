Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55A16BB6DF
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 16:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjCOPDl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 11:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjCOPD1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 11:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CC11633B;
        Wed, 15 Mar 2023 08:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38144616F0;
        Wed, 15 Mar 2023 15:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798C7C433EF;
        Wed, 15 Mar 2023 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678892561;
        bh=we60uODtwnKhE7BEmxS/LKxG+c2TTPrdMLNL4ZDlIUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NM/er7eB3escxmyWs8Fz5P+LwAWRR8PkTtZuaU60ilRsmAZ0YxsccibuLLMPSZ+q9
         tZPwI55KpHNClSSE0tztQm08ItLZrQwjJvZvHrOXQrg+dGMMwXz5Hj3plICQ6rbmta
         OHiCDExWdx8LSXwgciUPjY6Eduv9yigCC0RFe+SIGHx9BA9J0/OKYisFpgON1WcmQf
         ineyZmzOIScGUOqYgWQy/gezsofKv+koM9X5XczNmJb3SA5dzsVbWBUukLPYJMzwUk
         pjoCZO2rRZyB539psDAfQQhXrTiJfPI7i8hImfpx0cNmg8nDgMI4vlutS7Ta5b3Sii
         Jhn8M2RDt7qBQ==
Date:   Wed, 15 Mar 2023 16:02:37 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 2/3] pipe: enable handling of IOCB_NOWAIT
Message-ID: <20230315150237.iwhoj7a3nb4vwazd@wittgenstein>
References: <20230314154203.181070-1-axboe@kernel.dk>
 <20230314154203.181070-3-axboe@kernel.dk>
 <20230315082321.47mw5essznhejv7z@wittgenstein>
 <38781e4c-29b7-2fbc-44a9-f365189f5381@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38781e4c-29b7-2fbc-44a9-f365189f5381@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 15, 2023 at 08:16:19AM -0600, Jens Axboe wrote:
> On 3/15/23 2:23 AM, Christian Brauner wrote:
> > On Tue, Mar 14, 2023 at 09:42:02AM -0600, Jens Axboe wrote:
> >> In preparation for enabling FMODE_NOWAIT for pipes, ensure that the read
> >> and write path handle it correctly. This includes the pipe locking,
> >> page allocation for writes, and confirming pipe buffers.
> >>
> >> Acked-by: Dave Chinner <dchinner@redhat.com>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> > 
> > Looks good,
> > Reviewed-by: Christian Brauner <brauner@kernel.org>
> 
> Thanks for the review, I'll add that. Are you OK with me carrying
> these patches, or do you want to stage them for 6.4?

I'n not fuzzed. Since it's fs only I would lean towards carrying it. I
can pick it up now and see if Al has any strong opinions on this one.
