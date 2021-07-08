Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B292E3C193A
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhGHShT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 14:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhGHShT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 14:37:19 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0961FC06175F
        for <io-uring@vger.kernel.org>; Thu,  8 Jul 2021 11:34:37 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id s18so3928954ljg.7
        for <io-uring@vger.kernel.org>; Thu, 08 Jul 2021 11:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o2ASoGiHcKvlol6jVeSQSpIyIFc5g3r9dX0y3Fr3Zgc=;
        b=gE2ilK7h886+WToRooDIY8/bXblwfYQrTzKDQ7q/OgvAeCfHMqkjTTJqCH3ejPJm9X
         IRyUa6pi3KuJLLlpYE7CrnIdEa8Ih/7GxWt55xPvATc2Wbe5muIqzEsr+kDxql3PxIO/
         9esjBbLtbdr2ajX5MQM608F7ujW97xtnU0uec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o2ASoGiHcKvlol6jVeSQSpIyIFc5g3r9dX0y3Fr3Zgc=;
        b=g4UmYOeud+XO2ntUqyIYgHLbTzy551Y0hdhQMADPzSwbxk1pYNVlAtCFKRCzJ6rOMY
         q7tGvgMmxpHwkUh5bTB1NWOvBOk2BTBQa9ofspyHIbDXSEgFAxQNLSCyXA2dS0C1bHaZ
         pST7Isa+EJsueNjkqL6mIg1enp+4FgnuH96f05J4zRgVpZAVi5LHpwW0LE8YjKzFm/sO
         YmwaBXITLmlAQvDMBaKNZZhKyfJaHKKZI2U2A5OZ2gOIKuc3PCtpYCamZSxixSHPE4Xc
         Y7lRKqVrLFoNwcj0CXjwyMnMNojUREJdpdhDH96PP71xPVGRc+SxhPimpIYksTGysFVI
         eS8A==
X-Gm-Message-State: AOAM532jEphpUCgM9vupI0IDlPkbUHecBsiCURLtZeFUUM9LpDi79oxP
        pRS1fxcjM1Es3xfdEJB0uc6z+FsWqT66Umo3QcY=
X-Google-Smtp-Source: ABdhPJx2cLkOAntJr5i1Lx81GLOZmQ7RWTeG27fsswDj+UCeq8Sxy8jlZkQvzZHiWSOLdoo4EMvwSw==
X-Received: by 2002:a2e:8248:: with SMTP id j8mr25161928ljh.300.1625769274251;
        Thu, 08 Jul 2021 11:34:34 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id m4sm264645lfp.15.2021.07.08.11.34.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 11:34:33 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id r16so3916643ljk.9
        for <io-uring@vger.kernel.org>; Thu, 08 Jul 2021 11:34:33 -0700 (PDT)
X-Received: by 2002:a2e:9c58:: with SMTP id t24mr24720298ljj.411.1625769273393;
 Thu, 08 Jul 2021 11:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210708063447.3556403-1-dkadashev@gmail.com>
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 8 Jul 2021 11:34:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjMFZ98ERV7V5u6R4FbYi3vRRf8_Uev493qeYCa1vqV3Q@mail.gmail.com>
Message-ID: <CAHk-=wjMFZ98ERV7V5u6R4FbYi3vRRf8_Uev493qeYCa1vqV3Q@mail.gmail.com>
Subject: Re: [PATCH v9 00/11] io_uring: add mkdir and [sym]linkat support
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 7, 2021 at 11:35 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> v9:
> - reorder commits to keep io_uring ones nicely grouped at the end
> - change 'fs:' to 'namei:' in related commit subjects, since this is
>   what seems to be usually used in such cases

Ok, ack from me on this series, and as far as I'm concerned it can go
through the io_uring branch.

Al, please holler if you have any concerns.

I do see a few cleanups - the ones I've already mentioned to try to
remove some of the goto spaghetti, and I think we end up with just two
users of filename_create(), and we might just make those convert to
the new world order, and get rid of the __filename_create() vs
filename_creat() distinction.

But those cleanups might as well be left for later, so I don't think
that needs to hold the series up.

Al - one last chance to speak up..

           Linus
