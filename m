Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D28B4E83C7
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 20:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiCZTaV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Mar 2022 15:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiCZTaU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Mar 2022 15:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7F732052
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 12:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A61B260B9F
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 19:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D280DC340E8;
        Sat, 26 Mar 2022 19:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648322920;
        bh=VBrq8iFJzq/FlupzgCSPc4k4h2pJXO4qrq8Cg7EL8b0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Diie5K1/G3ZfDRl63L+1frIC0xVMr8TVDEeSIKQTPatYwdaSHVMthg5iwGZVyTRoF
         TGQlOmwqiPQuppWV2Nr3Y4X5oO2hMUiuLUnU9D17603xtH+KmkhjsUWDRViP+zegBO
         41MsPQ1M8dw+KcwHRuApGCNXLFiJb67OCFtcITnF0kFRLZCU+/NncVRmn97gQqcpkx
         Ps62JnEqDozrqD5tWlUdvUuWbImM4/7M1G/RFVbKPhkcrLeFM2mtHG4zNu4sWogpCJ
         aFWqhocfe51vv1QXwJpKBpO1znIbom/SuJc2j7HldhJ0+fUhUlUiYE2aJkAGDhq5/5
         NWFKBr3fTzElw==
Date:   Sat, 26 Mar 2022 12:28:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Message-ID: <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 18 Mar 2022 15:59:16 -0600 Jens Axboe wrote:
> - Support for NAPI on sockets (Olivier)

Were we CCed on these patches? I don't remember seeing them, 
and looks like looks like it's inventing it's own constants
instead of using the config APIs we have.
