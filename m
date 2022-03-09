Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345234D25EB
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 02:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiCIBCj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 20:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiCIBCi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 20:02:38 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E91C9460
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 16:40:19 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        by gnuweeb.org (Postfix) with ESMTPSA id C747D7E6E3
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 00:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646785452;
        bh=y+AGYe4W2NEYGIeCYH0cqaTXwO0QEInpr22w4Kp8DVk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TsEzGaZCx0b7Un3Rq6dAQqXALg6EIFNe/ZzQzOuJzL4CdxtCBjA7WJfxS84ODnutU
         8aMQTIWQGT07fJACItO752ixSYxvKWrQprAhLuZd4Eo5ZDVpo+qq1e+1uWP2/fqMZe
         O3B8p0GJLo+n6ooGvWBuFRHb1xbhFa8HefQrHtlDJE37DcEeXLhTKLVxW1lQuu9BHJ
         q7bhpaqMrsZJTctJQnbnuSsoiRLjjcX5tW5P7MuCWzhweMljGd9yFpfYvebfcJwQ30
         Xc7eRwNYb68h7UUziU/ts1EtIoCRvdZBfiAkiOkj3fx1ZCz3Lm7lOwyT8IwAwn32Ra
         zM1gGk27BJtFw==
Received: by mail-lj1-f175.google.com with SMTP id r22so889247ljd.4
        for <io-uring@vger.kernel.org>; Tue, 08 Mar 2022 16:24:12 -0800 (PST)
X-Gm-Message-State: AOAM5324EjIR5/K1/ylFohWJEa79SDu9wcy+JIkwibdqtuR/4lTQQRk6
        bpp7Hp8quNK8SjdCxlv5q0HpI+A7WgQvGb5w980=
X-Google-Smtp-Source: ABdhPJwAizxZ85f6W/4dPVOGlSmdctbFVQ+eAu+FokRiFZFZBatgKp2VeqLVSRJyRd/MAlnfGMSpqRfV5x+mdErPV6k=
X-Received: by 2002:a2e:3013:0:b0:247:ea0d:11e2 with SMTP id
 w19-20020a2e3013000000b00247ea0d11e2mr6477216ljw.2.1646785450753; Tue, 08 Mar
 2022 16:24:10 -0800 (PST)
MIME-Version: 1.0
References: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
 <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org> <acccd7d5-4570-1da3-0f27-1013fb4138ab@gnuweeb.org>
 <CAOG64qNECK73RGZek10_5se-H9T5EY3XwRaA4Jj-1PuCJv5F=w@mail.gmail.com>
In-Reply-To: <CAOG64qNECK73RGZek10_5se-H9T5EY3XwRaA4Jj-1PuCJv5F=w@mail.gmail.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Wed, 9 Mar 2022 07:23:59 +0700
X-Gmail-Original-Message-ID: <CAOG64qNjjy9j5QcdqSKjiETUFn6AZb6A4OKWN25nZdia=6X2ew@mail.gmail.com>
Message-ID: <CAOG64qNjjy9j5QcdqSKjiETUFn6AZb6A4OKWN25nZdia=6X2ew@mail.gmail.com>
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

On Wed, Mar 9, 2022 at 6:06 AM Alviro Iskandar Setiawan wrote:
> On Wed, Mar 9, 2022 at 5:52 AM Ammar Faizi wrote:
> > This is ugly, it blindly adds all of them to the dependency while
> > they're actually not dependencies for all the C files here. For
> > example, when compiling for x86, we don't touch aarch64 files.
> >
> > It is not a problem for liburing at the moment, because we don't
> > have many files in the src directory now. But I think we better
> > provide a long term solution on this.
> >
> > For the headers files, I think we should rely on the compilers to
> > generate the dependency list with something like:
> >
> >     "-MT ... -MMD -MP -MF"
> >
> > Then include the generated dependency list to the Makefile.
> >
> > What do you think?
>
> Yes, I think it's better to do that. I'll fix this in v2.
> thx

Sir, I am a bit confused with the include dependency files to the Makefile.

I use like this:

   -MT <object_filename> -MMD -MP -MF <dependency_file>

the dependency file is generated, but how to include them dynamically?
I think it shouldn't be included one by one.

So after this

   [...] -MT "setup.os" -MMD -MP -MF ".deps/setup.os.d" [...]
   [...] -MT "queue.os" -MMD -MP -MF ".deps/queue.os.d" [...]
   [...] -MT "register.os" -MMD -MP -MF ".deps/register.os.d" [...]
   [...] -MT "syscall.os" -MMD -MP -MF ".deps/syscall.os.d" [...]

files .deps/{setup,queue,registers,syscall}.os.d are generated, but I
have to include them to Makefile right? How to include them all at
once?

-- Viro
