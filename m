Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9134F087D
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 10:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiDCIzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 04:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiDCIzi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 04:55:38 -0400
X-Greylist: delayed 325 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Apr 2022 01:53:45 PDT
Received: from dcvr.yhbt.net (dcvr.yhbt.net [64.71.152.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9540CDF9D
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 01:53:45 -0700 (PDT)
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 4D0A01F4D1;
        Sun,  3 Apr 2022 08:48:20 +0000 (UTC)
Date:   Sun, 3 Apr 2022 08:48:20 +0000
From:   Eric Wong <e@80x24.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>
Subject: Re: [PULL|PATCH v3 0/7] liburing debian packaging fixes
Message-ID: <20220403084820.M206428@dcvr>
References: <20211116224456.244746-1-e@80x24.org>
 <20220121182635.1147333-1-e@80x24.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220121182635.1147333-1-e@80x24.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Eric Wong <e@80x24.org> wrote:
> The previous patch 8/7 in v2 is squashed into 3/7 in this series.
> Apologies for the delay since v2, many bad things happened :<
> 
> The following changes since commit bbcaabf808b53ef11ad9851c6b968140fb430500:
> 
>   man/io_uring_enter.2: make it clear that chains terminate at submit (2022-01-19 18:09:40 -0700)
> 
> are available in the Git repository at:
> 
>   https://yhbt.net/liburing.git deb-v3
> 
> for you to fetch changes up to 77b99bb1dbe237eef38eceb313501a9fd247d672:
> 
>   make-debs: remove dependency on git (2022-01-21 16:54:42 +0000)

Hi Jens, have you had a chance to look at this series?  Thanks.
I mostly abandoned hacking for a few months :x
