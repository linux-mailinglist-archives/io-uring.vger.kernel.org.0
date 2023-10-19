Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688477CECAF
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 02:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjJSAUJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Oct 2023 20:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSAUI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Oct 2023 20:20:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA904FE;
        Wed, 18 Oct 2023 17:20:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1753FC433C8;
        Thu, 19 Oct 2023 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697674806;
        bh=dxFpRFGQyZYIt12hrHgMufWeqE05AdXR2afP4eEpMLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EtTjOL6T7kpVGiMQBlY9JUSeIpRaurrIM4JwgzxgVfML6zjp89ZXotZhHt0JTWOk7
         uDzhIRAcEWdRCHC/LLDwrIbj0fQKwQz1Vze+94phMo0XZbKViWkJie8TY89DF7gl4i
         aPjAd7qDPTPyI0RCzmsoPFesF9ZAZDFnC/NrQw7TAwp5E+KCe3IK3dB7Pwqij6bLlC
         BkF0xxU5lXKleXt6sJyC7zT71JpESUlIjVSiTGb2Jvejo35jb/ykViTcbOs9Gh3e/3
         fnMDSMq5MgN/NFn4khDuhTqF4m38BINMJ6M7769H9qzcYxGKMudRLN8GPgylceOstA
         CdAZAkyJpbyaw==
Date:   Wed, 18 Oct 2023 17:20:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, pabeni@redhat.com,
        martin.lau@linux.dev, krisman@suse.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v7 03/11] net/socket: Break down __sys_setsockopt
Message-ID: <20231018172005.6c43c7ca@kernel.org>
In-Reply-To: <20231016134750.1381153-4-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
        <20231016134750.1381153-4-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 16 Oct 2023 06:47:41 -0700 Breno Leitao wrote:
> Split __sys_setsockopt() into two functions by removing the core
> logic into a sub-function (do_sock_setsockopt()). This will avoid
> code duplication when doing the same operation in other callers, for
> instance.
> 
> do_sock_setsockopt() will be called by io_uring setsockopt() command
> operation in the following patch.

Acked-by: Jakub Kicinski <kuba@kernel.org>
