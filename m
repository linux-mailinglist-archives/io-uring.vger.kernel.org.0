Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9F4F0C87
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 22:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344780AbiDCUpp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 16:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiDCUpp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 16:45:45 -0400
Received: from dcvr.yhbt.net (dcvr.yhbt.net [64.71.152.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2349315A21
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 13:43:49 -0700 (PDT)
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 638111F4CE;
        Sun,  3 Apr 2022 20:43:49 +0000 (UTC)
Date:   Sun, 3 Apr 2022 20:43:49 +0000
From:   Eric Wong <e@80x24.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>
Subject: Re: [PULL|PATCH v3 0/7] liburing debian packaging fixes
Message-ID: <20220403204349.M316769@dcvr>
References: <20211116224456.244746-1-e@80x24.org>
 <20220121182635.1147333-1-e@80x24.org>
 <20220403084820.M206428@dcvr>
 <c53378f8-87eb-43a6-afbb-e506c566ad26@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c53378f8-87eb-43a6-afbb-e506c566ad26@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> wrote:
> I never build distro packages and know very little about it, so would
> really like Stefan et al to sign off on this. I'm about to cut the next
> version of liburing, and would indeed be great to have better packaging
> sorted before that.

Thanks for the response, awaiting Stefan.

> Does it still apply to the curren tree?

Yes :>
