Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A907050F3
	for <lists+io-uring@lfdr.de>; Tue, 16 May 2023 16:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbjEPOhR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 May 2023 10:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbjEPOhM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 May 2023 10:37:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBEE30DC
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 07:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CACB663AE3
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 14:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81EEC433EF;
        Tue, 16 May 2023 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684247821;
        bh=kaxwbay1KRPiA3CRo5jUaEWJLpeBr+/aZlM+DLSaUYo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=G0DHTuaC70NNkxyZSp7tTGOHGqWuKyG+78cauyoTu1HTlHVl6kD51YMxdxWAqEZbI
         /oVU9lafmotwQhg2XXHxZiZ3Vtg5AoVnPJeu3T6THYOU/lkLa9tb/620nMtowzp7RB
         /lujoVNirbw2YIUpS3c2CG3IaSQS6SreS/oH9QvVC27MuOxDWQsan/VGYenl0Z/kgl
         f+zRSTFHqaeooFWoC/siBNkFiR31EhPPrDb6vP/RsyzYxANuVTIiqKJjWnssqNWfDv
         V4PS06uGcOI9jVnZ8BllUyuStB4QzV7Mg6qcFQX9UDuUIo+ClSwT3mRlxBld7q8G/f
         pMC4fGPVisZBw==
Message-ID: <1182a9ae-8396-97d1-6708-b811ddd9d976@kernel.org>
Date:   Tue, 16 May 2023 08:37:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf
 refcounting
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
References: <cover.1684166247.git.asml.silence@gmail.com>
 <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
 <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
 <CANn89i+Bb7g9uDPVmomNDJivK7CZBYD1UXryxq2VEU77sajqEg@mail.gmail.com>
 <d7edb614-3758-1df6-91b8-a0cb601137a4@kernel.org>
 <ee609e87-0515-c1f8-8b27-78572c81b1b4@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <ee609e87-0515-c1f8-8b27-78572c81b1b4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/23 6:59 AM, Pavel Begunkov wrote:
> 
> 
>> The one in net_zcopy_put can be removed with the above change. It's
>> other caller is net_zcopy_put_abort which has already checked uarg is
>> set.
> 
> Ah yes, do you want me to fold it in?
> 

no preference.

