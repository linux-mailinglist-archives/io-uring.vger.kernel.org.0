Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D5D4D2495
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 00:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiCHXHz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 18:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiCHXHw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 18:07:52 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73EB64BC4
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:06:52 -0800 (PST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
        by gnuweeb.org (Postfix) with ESMTPSA id 919B17E6E2
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 23:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646780812;
        bh=q/THvieLIn+NlZJB+R6Zj7xoHCZ/pOVxkbJkKpZHTa4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dNa82cPoYQQl587rfBh7+blriRSm2oyhR1BP2c44VNHI4QWtGe8/5KvFfoC6H8Hqw
         SPP0MfWEG0At4dS52IXA0T2DNcpzXngpadvs2MsaltWcHs5ZAmmIRBBaIwEG2Fs6DW
         WHLdUHxqAhD7ydecT/rmX+DGyCXA/NDqg0GqfZhZ2dlfpYGx0j6Pb4HrBS0kwmJGU2
         X7iyTLZr+wMvu90JetZeFE5i3BKcbX6o1jbiU+2U7qHotcUrADVvLS+W3ESsOSYAGJ
         a5MS5MrgzuLREEU+duOiMNR7jZnZ9GXaxHAoGMUw39dfsVJ+8mKfFDeIewrTliIy/L
         re6i9jDrduBog==
Received: by mail-lf1-f52.google.com with SMTP id bu29so765691lfb.0
        for <io-uring@vger.kernel.org>; Tue, 08 Mar 2022 15:06:52 -0800 (PST)
X-Gm-Message-State: AOAM533GObcL3XRnV6Fg169BwKTba0709pNK0nZ0cKVb31ZVbQKUWAdv
        cZf+ppMH8YrEaXd9LuDwEccKfGjWdSmIiCjxczA=
X-Google-Smtp-Source: ABdhPJwhRgTimXVxQbLnA3Mu8IGg7NAKk9iszdsU/V7H5ovBoApQeNHN8ExTIs/6TDeGfblfFqnDyYvsXOcMjrjkRR0=
X-Received: by 2002:ac2:424f:0:b0:448:4df1:77bf with SMTP id
 m15-20020ac2424f000000b004484df177bfmr793381lfl.70.1646780810526; Tue, 08 Mar
 2022 15:06:50 -0800 (PST)
MIME-Version: 1.0
References: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
 <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org> <acccd7d5-4570-1da3-0f27-1013fb4138ab@gnuweeb.org>
In-Reply-To: <acccd7d5-4570-1da3-0f27-1013fb4138ab@gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Wed, 9 Mar 2022 06:06:38 +0700
X-Gmail-Original-Message-ID: <CAOG64qNECK73RGZek10_5se-H9T5EY3XwRaA4Jj-1PuCJv5F=w@mail.gmail.com>
Message-ID: <CAOG64qNECK73RGZek10_5se-H9T5EY3XwRaA4Jj-1PuCJv5F=w@mail.gmail.com>
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

On Wed, Mar 9, 2022 at 5:52 AM Ammar Faizi wrote:
> This is ugly, it blindly adds all of them to the dependency while
> they're actually not dependencies for all the C files here. For
> example, when compiling for x86, we don't touch aarch64 files.
>
> It is not a problem for liburing at the moment, because we don't
> have many files in the src directory now. But I think we better
> provide a long term solution on this.
>
> For the headers files, I think we should rely on the compilers to
> generate the dependency list with something like:
>
>     "-MT ... -MMD -MP -MF"
>
> Then include the generated dependency list to the Makefile.
>
> What do you think?

Yes, I think it's better to do that. I'll fix this in v2.
thx

-- Viro
