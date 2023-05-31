Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536FB718891
	for <lists+io-uring@lfdr.de>; Wed, 31 May 2023 19:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjEaRiV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 May 2023 13:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjEaRiU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 May 2023 13:38:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091EA11D
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 10:38:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 911B463631
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 17:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BC3C433EF;
        Wed, 31 May 2023 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685554697;
        bh=unVXum49HaR7vPN//WTc8unNcKqz+tOCAEdMjspXxZ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lbv5y3NP7JhCiPsPsVLn5b9b6Im6K3j5IS1+Vu8WQoD5LKxRFeewyNwbVfZA76G5P
         xnaHvyqRRbGONXAICIQI1/8NhjTFst1O3yBMRcfrT0kH+zxoyyJfwqlMqwMaLn6wdz
         Wqjgf1GCBK6JFGAumcf4kFQd52qPr78SncQ963exBi20T71acRBvQe3eqeBiDZlTzc
         LIcZTZnS2jZSccMIYvIjzhklQifjIVNVV4bYKbB9e10eRU7LRApcNfH1FIOykbK+wq
         9yojHh7lLFQwlsKuwiwdWdJpo6o1oCw4kNvWobGFGGPOp7v5HDVPryiyhwxEf+vK4+
         WDUbWkWaxjcUQ==
Date:   Wed, 31 May 2023 10:38:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org,
        olivier@trillion01.com
Subject: Re: [PATCH v13 2/7] net: introduce napi_busy_loop_rcu()
Message-ID: <20230531103815.001d6a3d@kernel.org>
In-Reply-To: <20230531102915.0afc570b@kernel.org>
References: <20230518211751.3492982-1-shr@devkernel.io>
        <20230518211751.3492982-3-shr@devkernel.io>
        <20230531102915.0afc570b@kernel.org>
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

On Wed, 31 May 2023 10:29:15 -0700 Jakub Kicinski wrote:
> I think it's worth noting that until the non-RCU version this one may
> exit without calling need_resched().

My brain is broken. I meant to say "unlike non-RCU version this one may
exit for reasons other than loop_end()'s decision".
