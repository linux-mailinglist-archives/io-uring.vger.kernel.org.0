Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8333355EECC
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 22:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiF1UCL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 16:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiF1UBk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 16:01:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF233B3C0;
        Tue, 28 Jun 2022 12:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 961B860C49;
        Tue, 28 Jun 2022 19:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E4FC341C8;
        Tue, 28 Jun 2022 19:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656446061;
        bh=eZUfr5felgN92tClv9rcTibAmU/Gkmrb/pcPN45R3VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tU9YwxD/l6NMWg8WQSMi0C1M6PTME0xZzDMH27K1XBNIplK2c5ivxFfK666D3dmpD
         jYVIEEnfVSGoYKOSA298y6Lo9v1gjrsKW9BZkfoFRZ3IGDm9WGsIJOq79c/0OvLwrW
         VZcqElh5uI89c/e+nxsu0dKVtwKzoLOXcKhGbJij+gKpTuq1qCwmunP1u6gnNe2IuG
         A13vYgCxehFxdVgda2rf14umnPMHhtM4JT4jpX9qC6IGCdo4KFB+jtgGQxMxLw0YnG
         s+RnSvT0MBCnNDB3Sz8GBXcxZfNRkrcqb1Dc61QEucuj7zZm4d2QhyVNiUvfDhoOTC
         K4UnPW9IWQPEQ==
Date:   Tue, 28 Jun 2022 21:54:18 +0200
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] io_uring: replace zero-length array with
 flexible-array member
Message-ID: <20220628195418.GA52851@embeddedor>
References: <20220628193320.GA52629@embeddedor>
 <37147b0c-4b11-37df-6c4a-ee2dfeb9cbb7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37147b0c-4b11-37df-6c4a-ee2dfeb9cbb7@kernel.dk>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 28, 2022 at 01:38:44PM -0600, Jens Axboe wrote:
> Thanks for sending this separately. As mentioned out-of-band, we already
> have it like this in the io_uring.h header in liburing.
> 
> Applied for 5.20.

Great! :)

Thanks, Jens.
--
Gustavo
