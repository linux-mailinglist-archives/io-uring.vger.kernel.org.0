Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B2F71887A
	for <lists+io-uring@lfdr.de>; Wed, 31 May 2023 19:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjEaR3U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 May 2023 13:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjEaR3S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 May 2023 13:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23705BE
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 10:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B267860DE9
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 17:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC60FC433EF;
        Wed, 31 May 2023 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685554157;
        bh=YpeBXg92OH1AfduJ1lActhi9tLyMGhBkqJVOffBpjpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UoEtRc596Mv7qWEDJRDVyHAeaVBsDIlgJPDfPHL8kMyp0Pbj49a0h3F3bJPY5YoT8
         jCowLX3/R7vyRAxAn0/8QnSN0HF1mqe3Qymuu01OFovDtYIUgXSNSM0gkDgkwZ3COX
         qYYKb5kAPjWN/MsbdwiwqJCuR4JKVcaawNeqi+v5PcVKBajWu1wU7gUgMYXfQerhaa
         ou8HhRcM+rl5zMwmWQjyZshWoETAIXkBS3Rn11722fRTOeSmmQi7Ib4bmwYZMKSLMU
         /WeFIiRVkvYxO6A6zdo7g85seVdiL6A6NUuiVISlnUpUHH62FC2Ew9oDbmiWbjeFq6
         1MaKAnM+L/bow==
Date:   Wed, 31 May 2023 10:29:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org,
        olivier@trillion01.com
Subject: Re: [PATCH v13 2/7] net: introduce napi_busy_loop_rcu()
Message-ID: <20230531102915.0afc570b@kernel.org>
In-Reply-To: <20230518211751.3492982-3-shr@devkernel.io>
References: <20230518211751.3492982-1-shr@devkernel.io>
        <20230518211751.3492982-3-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 18 May 2023 14:17:46 -0700 Stefan Roesch wrote:
> + * napi_busy_loop_rcu() - busy poll (caller holds rcu read lock)
> + * @napi_id         : napi id
> + * @loop_end        : function to check for loop end
> + * @loop_end_arg    : argument for loop end function
> + * @prefer_busy_poll: prefer busy poll
> + * @budget          : budget for busy poll
> + *
> + * Warning: caller must hold rcu read lock.

I think it's worth noting that until the non-RCU version this one may
exit without calling need_resched(). Otherwise the entire kdoc can go
IMO, it adds no value. It just restates the arguments and the RCU-iness
is obviously implied by the suffix.
