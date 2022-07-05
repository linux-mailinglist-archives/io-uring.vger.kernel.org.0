Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6656635F
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 08:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiGEGrI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 02:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGEGrI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 02:47:08 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B047A1A2
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 23:47:07 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        by gnuweeb.org (Postfix) with ESMTPSA id 1B07B801E6
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 06:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1657003627;
        bh=L3E4VC+xedClXIq6Iwt5Suwlsj2YS5xkIhUvznT2sN4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lq8tHJLrfT6LVQbHJGYV0+w0oqwxA5ALGF/04ThzP2vXl7MeHAR65ny618Ja5FFu/
         1fwm89EHoAhFiQB1lNIt3IQISeR3jqYT+tlz0J1rCU352KE6h9QfwJ0zP2nbugZAzp
         OX9FMIjtix8SPa9L8u68sM6QbmYcLAm6DMgnn1yaJBvjalaoKMWLC8zoKwpHmN3zAw
         kKQW6RNPHt+cvtu2cTaTy3aqf1w84Rv2sp8h3zKoWdxl0S76OUaeb0aHcJ/coa5Hkx
         YIDn7hMujVYpi2WG0cGONL2rlS5HTV+HALoo81Y5uP3UCl5hSFfsS/r/RC1ppAejq6
         lDXjugYCb24Iw==
Received: by mail-lj1-f177.google.com with SMTP id a11so13325788ljb.5
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 23:47:07 -0700 (PDT)
X-Gm-Message-State: AJIora9ZRmwVRbx7Tw6eIlaZoCDFWp8Ln2iV3yKKFI919nUmcxWrgSxp
        LiOn05kzvH4cp5ng0471evCsGzRDEuI5A0hqOFk=
X-Google-Smtp-Source: AGRyM1tiB0mzV0hfYhO/ANsdr+iwi8YLH+wfRkXg6ecIEX7Hs4EuKFlyLxGERlEw7en8tC3j8MZdHaBtQbWEqmrUY7s=
X-Received: by 2002:a2e:a485:0:b0:25a:735c:9f41 with SMTP id
 h5-20020a2ea485000000b0025a735c9f41mr17933885lji.389.1657003625134; Mon, 04
 Jul 2022 23:47:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220704192827.338771-1-ammar.faizi@intel.com> <20220704192827.338771-3-ammar.faizi@intel.com>
In-Reply-To: <20220704192827.338771-3-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 5 Jul 2022 13:46:54 +0700
X-Gmail-Original-Message-ID: <CAOG64qMDn0_YmQ9SjkvgFTvPHLo-V4MVNQ26MBt8bgkgvGV-JA@mail.gmail.com>
Message-ID: <CAOG64qMDn0_YmQ9SjkvgFTvPHLo-V4MVNQ26MBt8bgkgvGV-JA@mail.gmail.com>
Subject: Re: [PATCH liburing v4 02/10] arch: syscall: Add `__sys_open()` syscall
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
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

On Tue, Jul 5, 2022 at 2:31 AM Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> A prep patch to support aarch64 nolibc. We will use this to get the
> page size by reading /proc/self/auxv. For some reason __NR_open is
> not defined, so also define it in aarch64 syscall specific file.

The commit message should also be updated, no extra definition for
__NR_open anymore in this version.

> v3:
>   - Use __NR_openat if __NR_open is not defined.
>
> Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

tq

-- Viro
