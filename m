Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A09D4D24A0
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 00:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiCHXJM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 18:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiCHXJL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 18:09:11 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8793569CEE
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:08:11 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        by gnuweeb.org (Postfix) with ESMTPSA id 3F87A7E6E2
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 23:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646780891;
        bh=SwcHS54sikmo3eu3YNcCFc1MNPCGLwx6jOyfBqb6q2o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tHJxywcVNuGFpdwnBh6Dp2pukAUtJL4rKsFQJwiAMC71fjaK36wDzTka4QJ8iIuaM
         9v7+hRpTit50y1vQdJbu3rCzIaWnVqUTlI9UVcIMBH5hXLFQ3UEVHyMYAEOZwOX4kD
         nF6xEPc2BbZcypCvkd0gk8fJM8ET4ywR20dxf+/M1adf77ROQ8c7eGquurmDNPO8VP
         H1oLpdHd2SEv351X3UkS+LDFATvKA+08KxfWp5NC/jmtEsZV0bNi6AQyfO23pOOhVh
         NjR/9vQLQJCCHfvdr3NdO9nn9E9zjCHBLSlHtNhBhTiujoGyr8TCeXpfF9PxAH+GDy
         tPSX7iMW+7ddQ==
Received: by mail-lf1-f42.google.com with SMTP id w12so650226lfr.9
        for <io-uring@vger.kernel.org>; Tue, 08 Mar 2022 15:08:11 -0800 (PST)
X-Gm-Message-State: AOAM530dfrt7PHbWdfl7ujC5LdgZWCpVE2u2XzltE4T49vgFz6BsKmVe
        HXKM5C59eJSpuR1+4W6P9awv6YPq4B5gKaOmJ+U=
X-Google-Smtp-Source: ABdhPJwLyTxgggPjUgVqlJpnPhX2XeDvIfxcg7BL1ZVf3bOiDX0Ie8leUwMS7AOmmVl13jpslQ8zHbqC9bHniwIcVLg=
X-Received: by 2002:a05:6512:ad2:b0:448:3655:fac5 with SMTP id
 n18-20020a0565120ad200b004483655fac5mr5704421lfu.136.1646780889374; Tue, 08
 Mar 2022 15:08:09 -0800 (PST)
MIME-Version: 1.0
References: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
 <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org> <756bf7eb-ed5a-ea69-ba0a-685418125bfe@gnuweeb.org>
In-Reply-To: <756bf7eb-ed5a-ea69-ba0a-685418125bfe@gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Wed, 9 Mar 2022 06:07:58 +0700
X-Gmail-Original-Message-ID: <CAOG64qMqr07u-L8ZHede8AeQvifxdtzccJmnj1hH0BiQOaTa6A@mail.gmail.com>
Message-ID: <CAOG64qMqr07u-L8ZHede8AeQvifxdtzccJmnj1hH0BiQOaTa6A@mail.gmail.com>
Subject: Re: [PATCH liburing 2/2] src/Makefile: Add header files as dependency
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 9, 2022 at 5:59 AM Ammar Faizi wrote:
> On 3/9/22 5:40 AM, Alviro Iskandar Setiawan wrote:
> > When the header files are modified, the compiled object are not going
> > to be recompiled because the header files are not marked as dependency
> > for the objects. Add those header files as dependency so it is safe
> > not to do "make clean" after changing those files.
>
> Another missing part is the test files, they should also be recompiled
> when changes to files in src/ are made. With this change, they are not.
>
> The same also for examples/.

oc oc, that will be separate patches. Will be done in v2.

-- Viro
