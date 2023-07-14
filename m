Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0F8753EE1
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbjGNPbp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 11:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbjGNPbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 11:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726E430CB;
        Fri, 14 Jul 2023 08:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0319861D4F;
        Fri, 14 Jul 2023 15:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BC6C433C8;
        Fri, 14 Jul 2023 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689348700;
        bh=K5b9Yi9S3+psqUP3W9NtXlQNbnIN44u4KispcsguYS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tqKGtxhtHaWPBdxhECMdmhRXlOTNfKpowuK/6PXS9e034j+hyWX1yxJ0fpJ0DW8oB
         xnRqpDRQomABn/RRNaCoPzFxjMopjftDBIFFHAZsWqGP8Ea1z9MEnYaIbhLEp2UYDK
         y1Qvi/pImxtodWu4QWPmui86C2v0A2jfD6p1L/H7IOr8CmgFwyEb8eknhfVDxTBy0t
         KRqCeCciHrfUtMohrvwjEcw3lL0TxUT0/Ix5s/rInqjwhGQp0GiIePHXiN1+Kkwy3w
         fsZG2SjOZQrF2/2bjIySME6ZOyeAG35qlOqqCh/HGigTcCyWD4sZq4K0sw3nO3hBBE
         dQNPHim0gUszg==
Date:   Fri, 14 Jul 2023 17:31:36 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 1/5] exit: abtract out should_wake helper for
 child_wait_callback()
Message-ID: <20230714-sinken-bachforelle-646ef9eca292@brauner>
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230711204352.214086-2-axboe@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 02:43:48PM -0600, Jens Axboe wrote:
> Abstract out the helper that decides if we should wake up following
> a wake_up() callback on our internal waitqueue.
> 
> No functional changes intended in this patch.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Acked-by: Christian Brauner <brauner@kernel.org>
