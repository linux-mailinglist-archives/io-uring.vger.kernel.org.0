Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D927E736EE5
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 16:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjFTOk3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 10:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbjFTOkH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 10:40:07 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03511995
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 07:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687271999;
        bh=Er/doQMBUnj5/+gyZPCA/cb+c19RWHyKrddTxSlNpnM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=R2zjSYJ70gjIn9U+LeGCqxSaz2YOo7A/X/sRTGcldmW8i4cuNRSy65r52KggIUIJ8
         ZpjcrXcIgIxXLNYLycKjNejUTD9mo2HQTvl9D9zfFJaLFvnAnHJNJMu8qrgfMeKGcK
         3aoD2lJFkhnf7MOlW/CN3XMN+uFEX7bZ+lpVhbzMSfdDl8INPiSA5M99LfsJRpLZOa
         s2QYoihoADqh1/M2XhVauBYYHl6MRoPmqdwVNwsd1wFhwd923/J7g+Wqc1/wiQNXpc
         95yZkXJQ+6XTIKgyV1hmYwKxlOtA+MXeLOFTbEOXSoquKu3qv4gcRU91iFYhcVuUoy
         D5GZjwOnBokWA==
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        by gnuweeb.org (Postfix) with ESMTPSA id C33ED249D15
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 21:39:59 +0700 (WIB)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4f6283d0d84so6406768e87.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 07:39:59 -0700 (PDT)
X-Gm-Message-State: AC+VfDxPWuDBe2rDDFOIOViyFCuQBA0OsWgR7SSGrDMfHoT7WcK6jYza
        EBpQZqfAlVrpdlzKMSJj2jDE1zbXk0kGpLaO/Ow=
X-Google-Smtp-Source: ACHHUZ6LCOMwZ4en7QkSbMLz634QUB/cJ09H3m0PYrzfQVxwVCNLdv0mKTu0lheL8jDA4T+K1SR1ijoPFbEizBCVpgc=
X-Received: by 2002:ac2:5b0c:0:b0:4f8:666b:9de8 with SMTP id
 v12-20020ac25b0c000000b004f8666b9de8mr5546671lfn.13.1687271997438; Tue, 20
 Jun 2023 07:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230620133152.GA2615339@fedora>
In-Reply-To: <20230620133152.GA2615339@fedora>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 20 Jun 2023 21:39:46 +0700
X-Gmail-Original-Message-ID: <CAOG64qNrFTnY74g-hTUbOFBhsmxf6ojUiYP_heD-iXm0-VKMkQ@mail.gmail.com>
Message-ID: <CAOG64qNrFTnY74g-hTUbOFBhsmxf6ojUiYP_heD-iXm0-VKMkQ@mail.gmail.com>
Subject: Re: False positives in nolibc check
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
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

Hello Stefan,

On Tue, Jun 20, 2023 at 8:32=E2=80=AFPM Stefan Hajnoczi wrote:
> This is caused by the stack protector compiler options, which depend on
> the libc __stack_chk_fail_local symbol.

liburing itself explicitly disables the stack protector, even when
compiled with libc. You customize the build and use something that
needs libc (stack protector). So I would say liburing upstream has
taken care of this problem in the normal build.

> The compile_prog check in ./configure should use the final
> CFLAGS/LDFLAGS (including -ffreestanding) that liburing is compiled with
> to avoid false positives. That way it can detect that nolibc won't work
> with these compiler options and fall back to using libc.
>
> In general, I'm concerned that nolibc is fragile because the toolchain
> and libc sometimes have dependencies that are activated by certain
> compiler options. Some users will want libc and others will not. Maybe
> make it an explicit option instead of probing?

I'm not sure it's worth using libc in liburing (x86(-64) and aarch64)
just to activate the stack protector. Do you have other convincing use
cases where libc is strictly needed on architectures that support
liburing nolibc?

I think using stack protector for liburing is just too overkill, but I
may be wrong, please tell me a good reason for using it in liburing.

I admit that nolibc brings problems. For example, the memset() issue
on aarch64 recently (it's fixed). If you have similar problems, please
tell. We probably should consider bringing back the "--nolibc" option
in the "./configure" file?

> I've included a downstream patch in the Fedora package that disables
> nolibc for the time being.

Thanks for maintaining the package. I appreciate it.

-- Viro
