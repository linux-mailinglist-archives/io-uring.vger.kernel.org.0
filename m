Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A55A23AE74
	for <lists+io-uring@lfdr.de>; Mon,  3 Aug 2020 22:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgHCUxc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 16:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgHCUxb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 16:53:31 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E28C061756
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 13:53:31 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b11so21203829lfe.10
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 13:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=boqqlPEphuqFOJvJXYWvtssstb3e5GfHxvP4UX5Sq5c=;
        b=KoLB4qo00ttZ2rb6l5YXNE1gls5lSCPrNhMgqClS0lvY/JPsH9QzjORUdh/XfpVP9d
         llAyfafcZTRGmbD3dCIvElgiiL5Wmg1ePatuFMFxwUHOf39YQbD87hnmiBrhYtv6T491
         lr09HtKaYwZyX7qWtmxXfWf0EEMNi9ni6Qxns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=boqqlPEphuqFOJvJXYWvtssstb3e5GfHxvP4UX5Sq5c=;
        b=hDe1b69VtRWF8+ueN7b5+HdtZeWUTVbiVzkkwqQJF8fk3KwwigQLTTqRab1tYfuIR2
         W3EkJLi1nYva2EtyAd9w24tlgwhX7PKxFOzLf1X7LBtQviiB1PsGy5QLKmoaqkBw3V8L
         CUGdeQafIArSCnMFzfp/3AHjkzdhmq7kv/CmMaIoho7tnUgcKnM4gLmTvxJOmHrvsQUa
         PGVLkoZ5nRQlZFolAJdQxM65Qaw7sqynJIsZemfKlAIwbT7RoEbzO73ThNeeMkJs9pew
         lV/tQjIBQRkDcCvzHe6AR71+KPJGY52D40LphJdmh5i6Epn5jG33cC6gWwSi+Pgo0np0
         VK3A==
X-Gm-Message-State: AOAM531kznw5h0gorRA6CcZMcDmGEU90w6SS2/NQXwSKvJSzFhHf7QVR
        vcj7f5DfgUXcIQJxC6XCeddmdF/jUpI=
X-Google-Smtp-Source: ABdhPJwPHHYKWLk2C9Bt2+HptSii0AuXR9q0qk8PYzHYEH31On5zv13DGi/EG7DZU4bOpeFFkQGr8A==
X-Received: by 2002:ac2:5dc1:: with SMTP id x1mr9063567lfq.217.1596488009704;
        Mon, 03 Aug 2020 13:53:29 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id i7sm4641371lja.130.2020.08.03.13.53.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 13:53:28 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id m15so20519981lfp.7
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 13:53:28 -0700 (PDT)
X-Received: by 2002:ac2:46d0:: with SMTP id p16mr9624647lfo.142.1596488008455;
 Mon, 03 Aug 2020 13:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk> <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
In-Reply-To: <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Aug 2020 13:53:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjztm0K9e_62KZj9vJXhmid-=euv-pOHg97LUbHyPKwzA@mail.gmail.com>
Message-ID: <CAHk-=wjztm0K9e_62KZj9vJXhmid-=euv-pOHg97LUbHyPKwzA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
To:     Jens Axboe <axboe@kernel.dk>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 3, 2020 at 1:48 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I've pushed out my merge of this thing [..]

It seems I'm not the only one unhappy with the pull request.

For some reason I also don't see pr-tracker-bot being all happy and
excited about it. I wonder why.

                     Linus
