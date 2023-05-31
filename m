Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87A71886E
	for <lists+io-uring@lfdr.de>; Wed, 31 May 2023 19:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjEaR0v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 May 2023 13:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjEaR0t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 May 2023 13:26:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10163BE
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 10:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A289C61199
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 17:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A1AC433D2;
        Wed, 31 May 2023 17:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685554006;
        bh=DMo7nTLpSRqf4Dk0AC7I+Z12K6KMLk1Qc8jq4NBGxiQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O7SVgz8o0ETKUSaQmZgLEyF2HAhELYi3/xg73eUu8F17Lua+lydUdLHTolVav7Uvy
         AxFnqtrh7PuCdljK9smU8DyyrXcVPSQVp2e69IMzgdVJOEcBkDDXcnj2QmhxlRcrIZ
         VYxqE9U0PbP20rxxIBbVb0mBKaxZjbU1X1ZHx+VS1A4JXjp9FAIa9Dg3qnEw+9g3Z0
         1X4luK+8McFRpQCjfUzbvWhnCVcrQbrndA23XT2d5udoqRh7MwajnyczsrO/1FXDHe
         qMh4Ro1djs4wy2XY2OZ2/4QhhyckYEx2ILQrYmSQBVeEH6nupJAdpd7bdjO6oAUX/p
         W/KVMK2wcYoyA==
Date:   Wed, 31 May 2023 10:26:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org,
        olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Message-ID: <20230531102644.7f171d48@kernel.org>
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
>  	unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
> -	int (*napi_poll)(struct napi_struct *napi, int budget);
> -	void *have_poll_lock = NULL;
> -	struct napi_struct *napi;
> +	struct napi_busy_poll_ctx ctx = {};
>  
>  restart:

Can you refactor this further? I think the only state that's kept
across "restarts" is the start_time right? So this version is
effectively a loop around what ends up being napi_busy_loop_rcu(), no?
