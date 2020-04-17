Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306FB1AE3C3
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 19:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgDQR0g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728666AbgDQR0g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Apr 2020 13:26:36 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB051C061A0F
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 10:26:35 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r24so2858107ljd.4
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 10:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=axfO7OLGNTCrLAVeBKh/eWQ+8sqIplMY2YUjR1earEU=;
        b=UmKw1Q0ckwm1woOAXjKENpstVpDxJfriTgN5Z+SQkyqmSUkHruZiFIB4ZS0X6zMdZj
         5RT1fDNr9COsnCUQ8OfkkHNZ+CwNeeGSRynF5bFMnX2K99CNUV92aBL7CEt3Efn8voqC
         KEaB6UXfOuBfRtmXGQ5A5GAYff55GpMuQtfIU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=axfO7OLGNTCrLAVeBKh/eWQ+8sqIplMY2YUjR1earEU=;
        b=h0xuVTnToDLpK+4m8x6hsR/ACzA3MjXxNqe/EywsR6BhkO8qjsxOiL5uNE0QIwFmpd
         SlfDNVBo9ItEfCjBXuK86sVHAVg85kGt7H18ZtjuTBYpgSPVeMqpj/lY27PBRL/i9mLU
         sf3RATWI1kk/kxMfrKoeO26sq40Dnuc5hOIsw1ak9e3OAQvqgYrFHtcu88B13KIamrkE
         3Q9Wg8iVHJ6AZILFBpwavWlZTx7TRRLZ82RnFAHjChvzQ19F+SeahalcKFBHSDTxM+lJ
         LBl6kuE+GxCEyEMfIAu3M8dZiwta6fyn76eJ2Qxc/uFw7U9eo05sa1Aerlv2qyto/J5m
         u+Tw==
X-Gm-Message-State: AGi0PuahTCLUw4CLNhGCWE8SGnA2FX1JMf36NVSs5pb8osYZijDpMix+
        9FiwgLU0RPtLEPRkV0bXrTxWF30avXQ=
X-Google-Smtp-Source: APiQypIdS3qHKqB6A13Y8ta7AGmJD2IfhJp/eGzu3AnZRfHEHYIwBiXhap0FGm8ZIcHJWfRETnyx7A==
X-Received: by 2002:a2e:5855:: with SMTP id x21mr2739646ljd.75.1587144393517;
        Fri, 17 Apr 2020 10:26:33 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id j15sm7161018lja.71.2020.04.17.10.26.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 10:26:32 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id v9so2816945ljk.12
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 10:26:32 -0700 (PDT)
X-Received: by 2002:a05:651c:50e:: with SMTP id o14mr2706220ljp.241.1587144392363;
 Fri, 17 Apr 2020 10:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <2750fd4f-8edc-18c2-1991-c1dc794a431f@kernel.dk>
In-Reply-To: <2750fd4f-8edc-18c2-1991-c1dc794a431f@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 17 Apr 2020 10:26:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiWP0M=ZAim7VVuoR+5ri+Ug+KZDE-TZskma4HV91ACxA@mail.gmail.com>
Message-ID: <CAHk-=wiWP0M=ZAim7VVuoR+5ri+Ug+KZDE-TZskma4HV91ACxA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.7-rc
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 17, 2020 at 8:16 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> - Work restore poll cancelation fix

That whole apoll thing is disgusting.

I cannot convince myself it is right. How do you convince yourself?

                Linus
