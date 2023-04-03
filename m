Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DBC6D444D
	for <lists+io-uring@lfdr.de>; Mon,  3 Apr 2023 14:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjDCMYw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Apr 2023 08:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjDCMYv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Apr 2023 08:24:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB8E30CF;
        Mon,  3 Apr 2023 05:24:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB3FCB81977;
        Mon,  3 Apr 2023 12:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4CEC433EF;
        Mon,  3 Apr 2023 12:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680524687;
        bh=2Msi5SZ8ml19YSOMiyhl4op0vJSG4H+HQne13hB3oLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6ZDaZshWlVKwPc84AxzulMoL+CYRlewZd5DR0MJ2l/j8cfd4u4QSQdeVlnuUc3V/
         eJ9e1U/DSqiKM/2f9C0O7p/L5LSEA5ZIMKP8QRLpryDSUhisoDm7Q3QX0+upg06ZFm
         2t19hxCKseQBFKgoxSJwlv1VKWyElkaQh+OKx1cYVceEZKo7RA0JBuvcQFg4T8pqtl
         XO7vXd2ITb10dCXzT83Fw6ypJQhwZXIbXHMPSI1muLmrEOxP4HItpx8oK6p7NG/SAz
         2m9ylqFGTKttPBVvmcRcdrlVkxeFtV1H6S2r822+B0DhBAx9PKgpgZEuhLzsKCorIu
         pbHV7GIG6zIUw==
Date:   Mon, 3 Apr 2023 14:24:42 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCHSET for-next 0/2] Flag file systems as supporting parallel
 dio writes
Message-ID: <20230403-wound-roundworm-c1660e059b8c@brauner>
References: <20230307172015.54911-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307172015.54911-1-axboe@kernel.dk>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 07, 2023 at 10:20:13AM -0700, Jens Axboe wrote:
> Hi,
> 
> This has been on my TODO list for a while, and now that ext4 supports
> parallel dio writes as well, time to dust it off and send it out... This
> adds an FMODE flag to inform users that a given file supports parallel
> dio writes. io_uring can use this to avoid serializing dio writes
> upfront, in case it isn't needed. A few details in patch #2, patch 1 does
> nothing by itself.

Looks good,
Reviewed-by: Christian Brauner <brauner@kernel.org>
