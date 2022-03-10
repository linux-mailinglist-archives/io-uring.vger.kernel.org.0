Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1476E4D452C
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 11:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiCJK5m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 05:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiCJK5l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 05:57:41 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4171405FC
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 02:56:40 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by gnuweeb.org (Postfix) with ESMTPSA id 917D97E2CF
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 10:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646909800;
        bh=Cr37aJ6EJ81FAnn6MdMYwVPdEZ7B8S/YIzT7gu4yWH8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=N9GV9jx9gF3hpT/F8stXs1PpQQiyLMEcmA+NEVYbJlfdtKgTWTiUrv9UUoGsQ7ekr
         XN9hL78gC8z5HIS9DH1Dff05K3TgxjLEo3woPoGJnrvv3ycywlhmKldccDQX1mA2kL
         aRu4POAhPoy2+js7xxweXU716Fsej76Ndyht6/hmEreRr+27F3rm382kUjtY5Kc2We
         z0vu9m3eTHIlL09Od3MmauExL7P9NptwkQJV1d68TFca8OiQ7qCbc86EUyTQuAPCvU
         GRJR9tZYhsWfFynaTixBvoB5bKI3Obn4xehw5VCxRvYxEarZTPbBzkE3HIOWWUpzuE
         AGEn/rmKTYDYg==
Received: by mail-lf1-f46.google.com with SMTP id w7so8726681lfd.6
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 02:56:40 -0800 (PST)
X-Gm-Message-State: AOAM53120xhnY543w+E8N8d7kCeK9dOMfLpB9fEj4KSaJFoyo66KIICu
        KS9i/s0wTT6ucCJg3cpb8uhAGiIy51+DXzlDNXc=
X-Google-Smtp-Source: ABdhPJwtzOt2dWG7ecAQ3LEYN1QWSwxBZhT7828p5p8uOuHJo/dj5u8lTellivR1z3XsiV4g5KtNlqyULAzxB7ZuCy4=
X-Received: by 2002:ac2:4e4a:0:b0:448:5f9f:92ae with SMTP id
 f10-20020ac24e4a000000b004485f9f92aemr2133874lfr.483.1646909798652; Thu, 10
 Mar 2022 02:56:38 -0800 (PST)
MIME-Version: 1.0
References: <20220310103224.1675123-1-alviro.iskandar@gnuweeb.org>
 <20220310103224.1675123-3-alviro.iskandar@gnuweeb.org> <628f2f77-b20c-ac5f-90cc-586a9939b6af@gnuweeb.org>
In-Reply-To: <628f2f77-b20c-ac5f-90cc-586a9939b6af@gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Thu, 10 Mar 2022 17:56:27 +0700
X-Gmail-Original-Message-ID: <CAOG64qNJUTwsn1aLuMzNh3m8tVEStkJV2tL=BzU4Kt89-f25vw@mail.gmail.com>
Message-ID: <CAOG64qNJUTwsn1aLuMzNh3m8tVEStkJV2tL=BzU4Kt89-f25vw@mail.gmail.com>
Subject: Re: [PATCH liburing v2 2/4] src/Makefile: Add header files as dependency
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        gwml <gwml@vger.gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 10, 2022 at 5:50 PM Ammar Faizi wrote:
> You should add the dependency files to .gitignore, otherwise we will have
> these files untracked after build.
>
>    Untracked files:
>      (use "git add <file>..." to include in what will be committed)
>            src/queue.ol.d
>            src/queue.os.d
>            src/register.ol.d
>            src/register.os.d
>            src/setup.ol.d
>            src/setup.os.d
>            src/syscall.ol.d
>            src/syscall.os.d
>
> Also, when doing `make clean`, the dependency files should be removed.

lmao, i forgot, oc, i'll be sending v3

-- Viro
