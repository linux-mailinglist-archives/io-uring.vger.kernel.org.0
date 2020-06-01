Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259B21EA50D
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 15:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgFANfn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 09:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgFANfn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 09:35:43 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04F7C061A0E;
        Mon,  1 Jun 2020 06:35:42 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q8so6879286iow.7;
        Mon, 01 Jun 2020 06:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Mm9uE9NM2GVLX8GeiFA3Elt/+Sx++UDtpFbF9gjRBVU=;
        b=C44FdFHBF68VTftOHu2ACXs+04O7zuVYuR1g0PsX3OKoy0PjAHyDMVmPdzF3bry9aM
         Y68EysdAwYXirkOl57d0NM6IZIeEyvnVOAih4vVRdbl3cx3EwI1utpqNBALnK52Cv0v0
         crF/6ouOP/kBa5CUUilQLDqrNwvAkx3lMqxV5pDl+hi9tMaOKIknaTdfefQvDDN7xx0u
         ekscqu13cdX7aF5jH1fbT7pGYN2CpdFdEVyoGc8/PTRhAj6JECIM8fNEf0p2SB5creY2
         7NHSW18RpUn0wKcQQKUjfuqMEVA+nArENCwIogXm+nMDFEZ/s7Z0jcr99AM53t3XW5lz
         uzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Mm9uE9NM2GVLX8GeiFA3Elt/+Sx++UDtpFbF9gjRBVU=;
        b=O+mifLFkWx7bq3Wo5mKwRU1sxkF1AdjPVAjfx7xIsnq83kHOEmsD62l17EaLXD423m
         o5IrvDU9Y4bNjzJp0thUbS2WPTchAIyVIAImF7me5qCU/Bs+rV+6ffk/kYLYajZVpXfb
         fXF76Gu/s3iGqI0okvFVwfJfiAcDqSMJl6DQYWt/b0rRQHysdLp0tRrNOJTgvPVoG6xJ
         KmWWTG9J3M67mMi/N1ndIAgh2P690W455E/8sZBWbFlbqkGe08/qu6Vz+zr+eYF0FQvJ
         hQbr9pmYY9C4YuM6xREiBsivxnFg6ztSUz8ZxvNxgf/6gSSvHeVcms5tzqv2KYtpbeKb
         TMIA==
X-Gm-Message-State: AOAM533dWD+KYcHmvJfxN4oS9uAdZk08DPWOQwVrm5Yu5P2EB5AqaBYQ
        ZvanJKkqA6ovtdGeVgT1/PawDs29Rz28hXUcs6NvBzVixRg=
X-Google-Smtp-Source: ABdhPJwkH7gonz1/C5KKVb8WOk57OSgAr+6Z7cJaik9LJIMkyDM+qguJHo7DacZbWa0/P6rO2/sC9ATO9jBABEaBQp0=
X-Received: by 2002:a05:6602:2dca:: with SMTP id l10mr19039638iow.163.1591018542171;
 Mon, 01 Jun 2020 06:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk> <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
 <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
 <CA+icZUWHOYcGUpw4gfT7xP2Twr15YbyXiWA_=Mc+f7NgzZCETw@mail.gmail.com>
 <230d3380-0269-d113-2c32-6e4fb94b79b8@kernel.dk> <CA+icZUXxmOA-5+dukCgxfSp4eVHB+QaAHO6tsgq0iioQs3Af-w@mail.gmail.com>
 <CA+icZUV4iSjL8=wLA3qd1c5OQHX2s1M5VKj2CmJoy2rHmzSVbQ@mail.gmail.com>
In-Reply-To: <CA+icZUV4iSjL8=wLA3qd1c5OQHX2s1M5VKj2CmJoy2rHmzSVbQ@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 1 Jun 2020 15:35:31 +0200
Message-ID: <CA+icZUXkWG=08rz9Lp1-ZaRCs+GMTwEiUaFLze9xpL2SpZbdsQ@mail.gmail.com>
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

with Linux v5.7 final I switched to linux-block.git/for-next and reverted...

"block: read-ahead submission should imply no-wait as well"

...and see no boot-slowdowns.

Regards,
- Sedat -
