Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4BB723316
	for <lists+io-uring@lfdr.de>; Tue,  6 Jun 2023 00:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjFEWVl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Jun 2023 18:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjFEWVl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Jun 2023 18:21:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE0BAF
        for <io-uring@vger.kernel.org>; Mon,  5 Jun 2023 15:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E807626A4
        for <io-uring@vger.kernel.org>; Mon,  5 Jun 2023 22:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B98AC433D2;
        Mon,  5 Jun 2023 22:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686003699;
        bh=dCL+k3F63GFuMKYpU11gd3w+RnYFIFLaP63gLGgRE90=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QSwHoX9DlN9xlKIDBfLDen+kWaFdczHr7IxcySA/0oLmLp6JrRiN/uPEYqwRTZ6cF
         jIWIKxrJdU951c1VeP8HgmLfPg7uUy8OxyUrGAu0U/0/GwtbM3k4G/tbkSKpQfJWQO
         saSzxsp2WjAgpliO0f81Z9OTU6byPUto10pDDHVBKZcZJiEvRIw8bXKNRpcv4fP+Zg
         Vts1dpfEjfVwRs9jpMuGE+Nrg1RtT3TYsw1tFssgsGViPf40tZWhhXDDzjN9TQKqYl
         uv0Z8cl1f+BlSVkJoVy0yddaNh7QzOq0CEa3BfsC59XgK6qdTw/5lycOhHdDjRG/bV
         uf+weP3EG6Hrg==
Date:   Mon, 5 Jun 2023 15:21:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org,
        olivier@trillion01.com
Subject: Re: [PATCH v14 3/8] net: split off _napi_busy_loop()
Message-ID: <20230605152138.1c93a261@kernel.org>
In-Reply-To: <20230605212009.1992313-4-shr@devkernel.io>
References: <20230605212009.1992313-1-shr@devkernel.io>
        <20230605212009.1992313-4-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon,  5 Jun 2023 14:20:04 -0700 Stefan Roesch wrote:
> +static void _napi_busy_loop(unsigned int napi_id,

IDK how much of an official kernel coding style this rule is but 
I think that double underscore is more idiomatic..

>  		    bool (*loop_end)(void *, unsigned long),
> -		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
> +		    void *loop_end_arg, bool prefer_busy_poll, u16 budget,
> +		    bool rcu)
-- 
pw-bot: cr
