Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAD7737145
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 18:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjFTQQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 12:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbjFTQQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 12:16:40 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1CDF4
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 09:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687277799;
        bh=cX9albBSE+AHrI8QCKgto/DzPa3OM+fuEpskRDEahg0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=NnT43fsqhNBiSJ41Fo5ZaVhxcym27zfvW+cwgUN0vZ9dN06E7g92S6feVrAA9YSOm
         lkMoFhUlKjtobbNZnldTX5iEMcd+JWOwLzkTNv4s+/2OIz623GO8wEZX8nHjhy4K1l
         zl197xlb4bPovlfahLXuELksrUzd1tZFSVX8px/KJ9cGJJKXGxdJcwjwWQ+cnEsLY3
         iqNh8LEV8akotP2mxTOcoZDh4eAhV/4zTnGmhsFLKk9REEhy8oMMG1OseGgXOGF2YA
         +OCW0+87yNsMbdHjh86KLoARjgbi9yccLHOgCHEnjBoXV9PqNO/xWrcIzMDX0ojbCS
         HP1YBfAK/hr+A==
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        by gnuweeb.org (Postfix) with ESMTPSA id E25A9249D1A
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 23:16:39 +0700 (WIB)
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2b47bfd4e45so33373571fa.0
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 09:16:39 -0700 (PDT)
X-Gm-Message-State: AC+VfDx8MP5tqJ6fDPyr4i1JWslQi3yNos05Ki5vJjRnmoHTdwBP4oRu
        h3CLvPu4Orwdg3Bia6OS3apfJPZCyHk5u5qncv8=
X-Google-Smtp-Source: ACHHUZ7uoZo/9Guho8lHcefRmisYU1tN4KLN3sygmRbvQKuL8ujKa2RnVMYZVJiUvjLRfNrMgkNUSSvdAS0Ajm2isPs=
X-Received: by 2002:a2e:9982:0:b0:2b3:f4ca:eacb with SMTP id
 w2-20020a2e9982000000b002b3f4caeacbmr9005130lji.43.1687277797750; Tue, 20 Jun
 2023 09:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230620133152.GA2615339@fedora> <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
In-Reply-To: <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 20 Jun 2023 23:16:26 +0700
X-Gmail-Original-Message-ID: <CAOG64qO4Dj9OM1R_tT-+=TeCpV5wdnzmFEJ1YqLjYtpNZB1UEw@mail.gmail.com>
Message-ID: <CAOG64qO4Dj9OM1R_tT-+=TeCpV5wdnzmFEJ1YqLjYtpNZB1UEw@mail.gmail.com>
Subject: Re: False positives in nolibc check
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Guillem Jover <guillem@hadrons.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 20, 2023 at 10:49=E2=80=AFPM Ammar Faizi <ammarfaizi2@gnuweeb.o=
rg> wrote:
> Can you mention other dependencies that do need libc? That information
> would be useful to consider bringing back libc to liburing.

The recent memset() problem is another example of it. It seems that
the compiler on aarch64 replaces a zeroing struct operation with a
call to memset(). I usually see the same memset() insertion on x86-64
too. I thought -ffreestanding will make the compiler not generate a
memset() call when zeroing a struct or array. Not sure about it.

-- Viro
