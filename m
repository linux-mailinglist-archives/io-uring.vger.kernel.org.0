Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B283718883
	for <lists+io-uring@lfdr.de>; Wed, 31 May 2023 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjEaRc2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 May 2023 13:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjEaRc1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 May 2023 13:32:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6A7B3
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 10:32:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D04C61648
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 17:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41597C433EF;
        Wed, 31 May 2023 17:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685554345;
        bh=qEe7igGl6XdmFOwdjny4zu0cgUf0VC9lnrrik0i38ok=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kHdY02oetdtSggaLwdgcWz+nBI9hVuqPeKsR0Gy17yBECTyc0ld9coChsewRoqmXl
         13zjq8FaGZikAqeCt79hzZIpyHXuWez0cM9v6leXAhk/ZKteUYFMvSxUY4ax3Y7JCp
         csfkDJlMGcV4nWE6Y4xGyxqX+RkuEPMx5b9gBK67uR3+xHI7oi/+KT1KV//YUKx82J
         qunHHCSZZZmnDXYTAX/mHzaPe+mNmMRnRW0KCmXt4sdwnGtXC1Y1VYavkz6B7+VOoB
         SkxzOjhqP75Vb51QN/G7VEMFqAhvUl1Kh7N5BTqIm3Lw80wmUZGNE+pQLebAEgpiCo
         XCJb+OZ+JO3og==
Date:   Wed, 31 May 2023 10:32:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org,
        olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Message-ID: <20230531103224.17a462cc@kernel.org>
In-Reply-To: <20230518211751.3492982-2-shr@devkernel.io>
References: <20230518211751.3492982-1-shr@devkernel.io>
        <20230518211751.3492982-2-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 18 May 2023 14:17:45 -0700 Stefan Roesch wrote:
> -	napi = napi_by_id(napi_id);
> -	if (!napi)
> +	ctx.napi = napi_by_id(napi_id);
> +	if (!ctx.napi)
>  		goto out;
>  
>  	preempt_disable();

This will conflict with:

    https://git.kernel.org/netdev/net-next/c/c857946a4e26

:( Not sure what to do about it..

Maybe we can merge a simpler version to unblock io-uring (just add
need_resched() to your loop_end callback and you'll get the same
behavior). Refactor in net-next in parallel. Then once trees converge
do simple a cleanup and call the _rcu version?
