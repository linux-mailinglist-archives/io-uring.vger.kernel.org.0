Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAA2722E1D
	for <lists+io-uring@lfdr.de>; Mon,  5 Jun 2023 20:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbjFESBO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Jun 2023 14:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbjFESAy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Jun 2023 14:00:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99042F9
        for <io-uring@vger.kernel.org>; Mon,  5 Jun 2023 11:00:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F21628F3
        for <io-uring@vger.kernel.org>; Mon,  5 Jun 2023 18:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DCCC433EF;
        Mon,  5 Jun 2023 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685988041;
        bh=lZb4iIlfbn3a0MKKXDqoE1jvt5CsqzMShPWBWD/Z20Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aHkJjnqwuuw6HO1w62WdfmosaFKYQVpMO5Ipx+adjKCTalQnmQUi1MWlkwFiAbNi9
         usFYsN6LSDtxKVUcVZLEypm1thDhvAIbbZ7vsbmlhyltggHJJ36pjZk/Cs2dkUiMbZ
         pLNk5p5aFLUedLhBP0OASBDE09IKP5XWRwXDqgq5hvNA6Byf8BUDwgKBaZYeeycISQ
         N0dg8iYVZYLcQbvE7RWC5/oU2EZ+x1OC+Nn7CLvw5vJ9whXZpWxCIKWLQqOONc7ROd
         3rYA3HUooYVR3Z6GmtcbWvrVohI14o1jpo5hbjIy1ux8dXt4c50fc0iodz9CR7EN8v
         B6p2ipB1w9mpQ==
Date:   Mon, 5 Jun 2023 11:00:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org,
        olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Message-ID: <20230605110040.3713a1fb@kernel.org>
In-Reply-To: <qvqwedmpyf3i.fsf@devbig1114.prn1.facebook.com>
References: <20230518211751.3492982-1-shr@devkernel.io>
        <20230518211751.3492982-2-shr@devkernel.io>
        <20230531102644.7f171d48@kernel.org>
        <qvqwedmpyf3i.fsf@devbig1114.prn1.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 05 Jun 2023 10:47:40 -0700 Stefan Roesch wrote:
> > Can you refactor this further? I think the only state that's kept
> > across "restarts" is the start_time right? So this version is
> > effectively a loop around what ends up being napi_busy_loop_rcu(), no?  
> 
> I'm not sure I understand this correctly. Do you want the start time to
> be a parameter of the function napi_busy_poll_rcu?

The RCU and non-RCU version of this function end up looking very
similar, what I'm asking is to share more code.
