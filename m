Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7126D14986E
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2020 02:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAZBwI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 20:52:08 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34880 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgAZBwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 20:52:08 -0500
Received: by mail-qt1-f193.google.com with SMTP id e12so4767831qto.2
        for <io-uring@vger.kernel.org>; Sat, 25 Jan 2020 17:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daurnimator.com; s=daurnimator;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x5xnrayNrZttsXjYnsD7leYSHgMeBAGc9r7Sjt9uupI=;
        b=M31j57V2Q7Le6pBu24wx04LIVUEaFW0AyT9xlcMsBLow1QshBDxR2SdMfNhLBgMvbE
         Qrn6IQFUvlD0j7lIzenvd0VpSXLevydGr2PPJb27EbkDXPMzHntS2QPHJDz4b6JcA/xJ
         SRvNbxVt9yQa5vzj7184zOzLeAdljxk4dz69o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x5xnrayNrZttsXjYnsD7leYSHgMeBAGc9r7Sjt9uupI=;
        b=t+xaXgD5En+Qlpiavkn3RKD83D2AutGl1beIpqrmHZRg96of8D00qqr5SUcPoV42fq
         26yyfElgClUyFY8pRXGXf398jYpiLtnbNmJ+O6x1XVgZrB44AKiWwmQ8gyKKQVOulGMP
         oak4LQ0fiTdb7ueAvN5fHDc36WEjD1xJilDF74ksfRPbi6/5YxfugKxMY4aKJnn4r122
         KTd0gx7aq2Yg5ftjqjC9MzWisQHpxZCZrZXhcQdSLd9qclbnqYJo46mXUF4fDHEZrIIa
         6Zwge3sv56UR9G3m/xi/ogfe+MW4WDE13oBDgV9NWQNzNp5YshLW08S2DlFxanRDsJQj
         kFIQ==
X-Gm-Message-State: APjAAAV2Szyujiddl/xolacdvkM90cGtOFvIzygZm6VtyZ3Em1grweSX
        TQeDkGyS0EhQzVk2Q+rVYKbo1Eb7PIQ=
X-Google-Smtp-Source: APXvYqyy6cN3yVuVAZMbeeeLSNor0RrR8KXWmt/kg6oDfxUR317YGpH8KqxtmsB1mFcAaKU+faDZYw==
X-Received: by 2002:ac8:5205:: with SMTP id r5mr10172536qtn.230.1580003527322;
        Sat, 25 Jan 2020 17:52:07 -0800 (PST)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com. [209.85.219.41])
        by smtp.gmail.com with ESMTPSA id n132sm6676435qke.58.2020.01.25.17.52.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 17:52:06 -0800 (PST)
Received: by mail-qv1-f41.google.com with SMTP id x1so2878370qvr.8
        for <io-uring@vger.kernel.org>; Sat, 25 Jan 2020 17:52:06 -0800 (PST)
X-Received: by 2002:a05:6214:982:: with SMTP id dt2mr10382741qvb.174.1580003525804;
 Sat, 25 Jan 2020 17:52:05 -0800 (PST)
MIME-Version: 1.0
References: <20200123231614.10850-1-axboe@kernel.dk>
In-Reply-To: <20200123231614.10850-1-axboe@kernel.dk>
From:   Daurnimator <quae@daurnimator.com>
Date:   Sun, 26 Jan 2020 12:51:53 +1100
X-Gmail-Original-Message-ID: <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
Message-ID: <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>
> Sometimes an applications wants to use multiple smaller rings, because
> it's more efficient than sharing a ring. The downside of that is that
> we'll create the io-wq backend separately for all of them, while they
> would be perfectly happy just sharing that.
>
> This patchset adds support for that. io_uring_params grows an 'id' field,
> which denotes an identifier for the async backend. If an application
> wants to utilize sharing, it'll simply grab the id from the first ring
> created, and pass it in to the next one and set IORING_SETUP_SHARED. This
> allows efficient sharing of backend resources, while allowing multiple
> rings in the application or library.
>
> Not a huge fan of the IORING_SETUP_SHARED name, we should probably make
> that better (I'm taking suggestions).

I don't love the idea of some new type of magic user<>kernel
identifier. It would be nice if the id itself was e.g. a file
descriptor

What if when creating an io_uring you could pass in an existing
io_uring file descriptor, and the new one would share the io-wq
backend?
