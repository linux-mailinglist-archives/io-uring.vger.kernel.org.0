Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB2128D4F8
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 21:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732519AbgJMTut (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 15:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732504AbgJMTus (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 15:50:48 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA0CC0613D2
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 12:50:48 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id f21so660622ljh.7
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 12:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oStFpL1sAklg8aQ9yJTrzYQkDSOL/BdJXdvIHiiieQ4=;
        b=EgxwghXHbFhUzfXmwnW3oWkcTuf9hghKJ+L0vimiZ2lNhz9ijKRICn6R1+VFJwxRfd
         3DO4aIph84yByZbN+yybxkssHP/RBykec4Cl4VJE58xKoOtU7gZtEMDeQg0S2eROjjBH
         rhqhqOEG94lka1wG1vNOxQhSRsutJq3Z20kn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oStFpL1sAklg8aQ9yJTrzYQkDSOL/BdJXdvIHiiieQ4=;
        b=YV+tEHykzqkqSnAoivG/kkRSxp9clLY70db34dYeFkXlw3KSRuC5lHkUe0KZd2RYr6
         UzFozr4wgqzBkXaXp9vHyI6eoiVT8Zdbf9K4D3YnoBTHbBNhfqNToy973E+6jh0aKI5X
         Lgc0v2uc7iop/gtjNa26g8aUVN5a7+wdt7ThcuyHlFXZEPXsw85koHqeWAWQHlFmnv+7
         mPLzWLSmNa+evlHMOjNSP+FcG6mA5FDJ8WmEUNpiV10IS7eFegmqtKKlxwsN0jRPX/nW
         N4SisU5/A9XTdbfDiG7ZCva/+jWP+b+d+K9PN0deF7doXE/B0klQTdJgTBqkB5Glzbl0
         crCg==
X-Gm-Message-State: AOAM532SAtEGz/utN23EgrN6taYQYyEz5ZVFiHdeBItYgtnHx+xy05CW
        WkrVjmoGSmEn0yD+U0/acmrXYUl0ad3Xig==
X-Google-Smtp-Source: ABdhPJyaP3hSpzGGIcRotdTj5m528IH0/fIh/5r2jqxqAHYCFMcqvisF99XzqzxU5byTA6oxsSrObg==
X-Received: by 2002:a2e:a41b:: with SMTP id p27mr494817ljn.30.1602618646745;
        Tue, 13 Oct 2020 12:50:46 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id z19sm240731lfr.46.2020.10.13.12.50.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 12:50:46 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id d24so1052722lfa.8
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 12:50:45 -0700 (PDT)
X-Received: by 2002:a19:cbcb:: with SMTP id b194mr322674lfg.133.1602618645500;
 Tue, 13 Oct 2020 12:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <36a6706d-73e1-64e7-f1f8-8f5ef246d3ea@kernel.dk>
 <CAHk-=wgUjjxhe2qREhdDm5VYYmLJWG2e_-+rgChf1aBkBqmtHw@mail.gmail.com> <a81737e4-44da-cffc-cba0-8aec984df240@kernel.dk>
In-Reply-To: <a81737e4-44da-cffc-cba0-8aec984df240@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 13 Oct 2020 12:50:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjAYpRhQkaFvqu+CnNcTHiMFrry_Ma6S8xGT_3BDEJkpA@mail.gmail.com>
Message-ID: <CAHk-=wjAYpRhQkaFvqu+CnNcTHiMFrry_Ma6S8xGT_3BDEJkpA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.10-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 13, 2020 at 12:49 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> What clang are you using?

I have a self-built clang version from their development tree, since
I've been using it for the "asm goto with outputs" testing.

But I bet this happens with just regular reasonably up-to-date clang too.

            Linus
