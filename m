Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691B51F02B9
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 00:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgFEWFe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 18:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgFEWFe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 18:05:34 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD91C08C5C2
        for <io-uring@vger.kernel.org>; Fri,  5 Jun 2020 15:05:34 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id v11so11135226ilh.1
        for <io-uring@vger.kernel.org>; Fri, 05 Jun 2020 15:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=mRuOsZjliXVkI4CGaKjAr5etWzmc9aOOuKXeRUD/q9I=;
        b=AZMEvpBK/sZOtDVsrZYlFmUFgTqAXEKR++kW/dzCQu9Xa0ufedv76kB6Jn+U/6uIul
         C4cmmZW1jA31O7dOGCPpiev9/ChGlfAbaEQGE84YfKVJHoXo9YzuWz2/4+j9ataXJBdd
         zV91TnvBQ0zBsLSTosOMRiS0oVGW3S0gFPcAqBSKFTMWBCt1WyECru8uT64w2pMD9Q2N
         NpQ7gOKD5/8vW0gSJS2qnQVarfvbYwx9ReB0D3TvNXQhL7N8b9hUJ1aJ6tz9L4Q+w6Qt
         ouYVQZwN6BaXKb3iWh0XOak9Be28hSiX3pbFjdNmKFi6RODXoFBNySuIB3VrBp4KSEqc
         QvGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=mRuOsZjliXVkI4CGaKjAr5etWzmc9aOOuKXeRUD/q9I=;
        b=JyEYtGU7sNDMtQMaHsNsQCb3I++kNW9qSw7fMsH1cACqBZXAdIZyJJN8w2q1shrrp/
         P4on5R7CljuwKHjOXFOypqhdSNIMpqKhWd5grIMNk5EEcstOZ0ytfTsUiH+dUwEHO959
         X6dCZqBR8TMCA+UlQfjvqTzA2r/K9+79rfg9dyFFER4WQ5JnV2NvnWI3rLLnsmoutD+8
         I1YZs3KeLKrM6t/fKb/Eh0kyQAa5yv702SFoqYWRX8d9pPO5zPtX2Q7mO2xy5KxB9DzF
         hrDPCV0gTgQLGflaK47pCV7Ka3Mecca1DPOEUoIhyjKwQ0AopE1fKh8TC2HoQnpd1j8p
         FLZA==
X-Gm-Message-State: AOAM530Qc1g5E6+7qZbRpfc3Yy4voz1i8cjrHQmK5gijygz8MHptqv3d
        9zQ4Ky4nSGnlj2M557Ma65qUq9ZLE15xvPJg1YNxo/9JmIo=
X-Google-Smtp-Source: ABdhPJx80hZaMDIqxsBNmZlgJ+a1ioDKWEK2LKfIVl49Dwih9Yn6Jd3jOzvUzIUB0bdCtyXf1MeHWLhBl9lQasJKS1g=
X-Received: by 2002:a92:7311:: with SMTP id o17mr11006569ilc.176.1591394732711;
 Fri, 05 Jun 2020 15:05:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 6 Jun 2020 00:05:21 +0200
Message-ID: <CA+icZUXRE+++FbchwF5Rhrj5AeRY=H2T8m07Y8CV5bhu_s5OgA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: re-issue plug based block requests that failed
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

with clang-10 I see this new warning in my build-log:

fs/io_uring.c:5958:2: warning: variable 'ret' is used uninitialized
whenever switch default is taken [-Wsometimes-uninitialized]
        default:
        ^~~~~~~
fs/io_uring.c:5972:27: note: uninitialized use occurs here
        io_cqring_add_event(req, ret);
                                 ^~~
fs/io_uring.c:5944:13: note: initialize the variable 'ret' to silence
this warning
        ssize_t ret;
                   ^
                    = 0
1 warning generated.

Thanks.

Regards,
- Sedat -
