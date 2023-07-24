Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CDB75FB24
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 17:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjGXPs2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 11:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjGXPs1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 11:48:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36E68E;
        Mon, 24 Jul 2023 08:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5129161214;
        Mon, 24 Jul 2023 15:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6062DC433C9;
        Mon, 24 Jul 2023 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690213705;
        bh=BnR8p0NTli1iiWv9Tj8n06sGq3rdMDNYDQt3cb8Gkno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=09knLTUNb7IDYFLoq8gfZtCz8sVHyS9i/6s6my6RY4QsUcEacAIvE5y0wBxD8x/kh
         ZHwQm0PleT5vwAkgR6ASkAc8XYGRrWukuQ8akak1iB+jYw8733wpkFW3PfpcbT1TB4
         82SjKZ7oYXAU2etqIVWBzXQAIs+4dKYqZ+JhFs2Q=
Date:   Mon, 24 Jul 2023 17:48:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     axboe@kernel.dk, andres@anarazel.de, asml.silence@gmail.com,
        david@fromorbit.com, hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
Message-ID: <2023072438-aftermath-fracture-3dff@gregkh>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 24, 2023 at 04:35:43PM +0100, Phil Elwell wrote:
> Hi Andres,
> 
> With this commit applied to the 6.1 and later kernels (others not
> tested) the iowait time ("wa" field in top) in an ARM64 build running
> on a 4 core CPU (a Raspberry Pi 4 B) increases to 25%, as if one core
> is permanently blocked on I/O. The change can be observed after
> installing mariadb-server (no configuration or use is required). After
> reverting just this commit, "wa" drops to zero again.

This has been discussed already:
	https://lore.kernel.org/r/12251678.O9o76ZdvQC@natalenko.name

It's not a bug, mariadb does have pending I/O, so the report is correct,
but the CPU isn't blocked at all.

thanks,

greg k-h
