Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64453291267
	for <lists+io-uring@lfdr.de>; Sat, 17 Oct 2020 16:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437495AbgJQO32 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Oct 2020 10:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438310AbgJQO32 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Oct 2020 10:29:28 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AECC061755
        for <io-uring@vger.kernel.org>; Sat, 17 Oct 2020 07:29:28 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id q20so1532258uar.7
        for <io-uring@vger.kernel.org>; Sat, 17 Oct 2020 07:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P+gIv2Lcj4WNQ6W5r97xFTj/z+w+Zw6Am1AGbMCfPgE=;
        b=AvVweg/pSu+cvJE0S0zZqtqcLAoadXExFz3xAe9zG7vo50YMTLwHQ1i8ftED2DTCXA
         uDyLEeGC6cYYaKOaXhAhMiSavtK6o+K0Bf0j3CS6CK6OzuSRfmaff3DhIkmIeSRj1QmC
         iOisXBQpzXX94cVxrWjw059s2E/Sj+SZ8+0L6jcZKRmU2wzQSoBODay/ZjP4eDDE4KHD
         rIXoGB1a4ZvI8eIsepfck2FIUOVafAAvByyjbLIaaBkDw2ok0thiS0I16UshtZz++jVD
         JAra2+ekaIrQbnMF4Bc81YjliIwbhBI8tg+Dy3t7U9FlTbPsxakUCdFDzj6/YRsRUX3Z
         TwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P+gIv2Lcj4WNQ6W5r97xFTj/z+w+Zw6Am1AGbMCfPgE=;
        b=pNzaTwVbw/o1JKGuxxY4fL9vqdk8rPjr9rpsiBjHTvlLzB2KLxOOz+zA74YMw+dxFg
         6igF9o9O5aYAf5QcVWYwtTG4m+aCbHkRQeSMtl1T7CpDTwZI7eLSGfhULIfTrzLb/bIq
         Z4Uui6zm+IStTmsN0csnYeKP115iz6IdertVnlrGlkI3dhjjFeNMHKQsDCj21uNHTqtu
         qaHJvurC02Vx11GLp046HroW2DKYOCq3Y2o5HbjzEvxj23z8jwVfZhteOugqwJbSALHV
         lw5+pBevTBgbZaWo1MKW1fgihSYfsEKRhr1v21TFaqiS8Zt/tvyNYAtfHRiWlEFBAb2a
         E8LQ==
X-Gm-Message-State: AOAM531PYn5okMhMo7fip3S84LSkv/LZbhXJlaD4DxmMnMH6r96k1HiJ
        rcLPHsc9yC4CKO2xHRD6rC4+c5X/9UVvahMdt4Y=
X-Google-Smtp-Source: ABdhPJzden7sO+y2LzeOJWCADNP5kK3JioLv+GRKwCvaAYdK5okKzL5TOLlsjB6Kg7jXp74ndZ1SqzW+p2DQEwMjyA0=
X-Received: by 2002:ab0:6f81:: with SMTP id f1mr4272724uav.31.1602944967083;
 Sat, 17 Oct 2020 07:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
 <20201001085900.ms5ix2zyoid7v3ra@steredhat> <CAD14+f1m8Xk-VC1nyMh-X4BfWJgObb74_nExhO0VO3ezh_G2jA@mail.gmail.com>
 <20201002073457.jzkmefo5c65zlka7@steredhat> <CAD14+f0h4Vp=bsgpByTmaOU-Vbz6nnShDHg=0MSg4WO5ZyO=vA@mail.gmail.com>
 <05afcc49-5076-1368-3cc7-99abcf44847a@kernel.dk>
In-Reply-To: <05afcc49-5076-1368-3cc7-99abcf44847a@kernel.dk>
From:   Ju Hyung Park <qkrwngud825@gmail.com>
Date:   Sat, 17 Oct 2020 23:29:16 +0900
Message-ID: <CAD14+f0h-r7o=m0NvHxjCgKaQe24_MDupcDdSOu05PhXp8B1-w@mail.gmail.com>
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, io-uring@vger.kernel.org,
        qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens.

On Sat, Oct 17, 2020 at 3:07 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Would be great if you could try 5.4.71 and see if that helps for your
> issue.
>

Oh wow, yeah it did fix the issue.

I'm able to reliably turn off and start the VM multiple times in a row.
Double checked by confirming QEMU is dynamically linked to liburing.so.1.

Looks like those 4 io_uring fixes helped.

Thanks!
