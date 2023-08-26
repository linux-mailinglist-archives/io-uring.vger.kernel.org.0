Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F142278929B
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 02:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjHZAEY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 20:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjHZAEY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 20:04:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A979E7F
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 17:04:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 104FA6519A
        for <io-uring@vger.kernel.org>; Sat, 26 Aug 2023 00:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F681C433C8;
        Sat, 26 Aug 2023 00:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693008260;
        bh=JsUqsUf1lSFTm6kJ/JZhqDbL4MYU9OIcC9jl/ZbihtE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MHmcl4dKOL1CsoSEZk4fwdcFlKo6DAaJYgB7LLNiAS7nD6BcsNPgwrksAhwcE4OYa
         CB1JmJyQ2QLOvKeyWD8c8Os6SRJ6wMuF/bxr7h9p/2kYTDUSGePnripRUQECWZC6xx
         Tloh5Hab4YNCjb+OTk3/ARFmgx4omnj8UQ5Ukalm8zecSVu9NcId4tJCKOxuQuKkWt
         19WmAi6/lL3lJmIhnJZdo48EcKLhUrvZAnphKHSsT+YzF8f2Sm0pjaWQIo7dddcuhO
         VbkvZZ2ybVETpxJfyev7lW2Ri4rdyaUrT21v3l6lrsbyfMOlj1B+H3UDf44xO2YWMR
         J0kzguc4GUclA==
Date:   Fri, 25 Aug 2023 17:04:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Wei <dw@davidwei.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>
Subject: Re: [RFC PATCH 00/11] Zero copy network RX using io_uring
Message-ID: <20230825170419.2aa593df@kernel.org>
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 25 Aug 2023 15:55:39 -0700 David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> This patchset is a proposal that adds zero copy network RX to io_uring.
> With it, userspace can register a region of host memory for receiving
> data directly from a NIC using DMA, without needing a kernel to user
> copy.

Please repost this and CC netdev@.
