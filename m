Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7A68ADC9
	for <lists+io-uring@lfdr.de>; Sun,  5 Feb 2023 02:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjBEBP1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Feb 2023 20:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjBEBP0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Feb 2023 20:15:26 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DC225957
        for <io-uring@vger.kernel.org>; Sat,  4 Feb 2023 17:15:25 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 3E67C81F44;
        Sun,  5 Feb 2023 01:15:23 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675559725;
        bh=y7ogPbL/pb4P1405Aya0AeNIMO84kT5UTNjjj0UatKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=myNDjNvolOitDLFuAojPg3RG8cxLgd1miEQS6xlZ1Zddr8Rhkh84sk2ghHIYAW5Uz
         dqMTYcjq6LCPwjf4fGEIsoG8/bur9/xoJu7vy8xulFMinh4SgWKfSIiFMx6Ogkce//
         y5x75MCnbM/uXL7xgp9zK8utJ73cP8ehl8JWZa3mt3lGClGVcLHaeXQwzcRCI0tEIf
         +xseJjHhl98gTMMgNX/WMxpqf8gu+q0v959Mn2Ew/xQEtKQHvMAONclLqiURNOltb9
         h6YckvT+6xGRr65xe/xKO7TDOOuG+uC7Vrx/Jq4Au5Dv6puXgY1+uNmb50ESI9x9UJ
         W8Q4xy+4kCRig==
Date:   Sun, 5 Feb 2023 08:15:19 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 3/4] liburing: add example programs for napi busy poll
Message-ID: <Y98DJyJWttMYGEFI@biznet-home.integral.gnuweeb.org>
References: <20230205002424.102422-1-shr@devkernel.io>
 <20230205002424.102422-4-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205002424.102422-4-shr@devkernel.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 04, 2023 at 04:24:23PM -0800, Stefan Roesch wrote:
> This adds two example programs to test the napi busy poll functionality.
> It consists of a client program and a server program. To get a napi id,
> the client and the server program need to be run on different hosts.
> 
> To test the napi busy poll timeout, the -t needs to be specified. A
> reasonable value for the busy poll timeout is 100. By specifying the
> busy poll timeout on the server and the client the best results are
> accomplished.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>

This version is much better. No more whitespace issues and the CI is all
green.

Acked-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

