Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440012C76D3
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgK2AWT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgK2AWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:22:19 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF6C0613D1;
        Sat, 28 Nov 2020 16:21:38 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id w6so7735064pfu.1;
        Sat, 28 Nov 2020 16:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=D1zmqsgYAEls0Ar0R4MN3csbFZSpx82fYoNUjW1wBrY=;
        b=d7xkwLfEsHcWZN9cvWOleSnutNFudMpjBidt2GLXEVqw8fNA/tH6++eaCWkjq9J5qo
         Re6Q6lrR81ssqbcRvb4FvnR9pMY+UA1+j5y1rhPqJkJ06EdCP25fsdtaGK21lzLFekHq
         IEZlBm9eSzxWHovjCJPk0Mf5hqXkgmTtMNZA+5vbuFbqkMhiE5ZlADBF+UJPfaGgoseJ
         UCc2XYj6HVwc3/EaNJNMuenH7RL9UeePm9lDu2NKC4t+hjH/Dgd4wKJrLax3wMu2jH8W
         wvE5TEwW8snfqkQoJMBvvGErVznNUtY9+iYMosJo7sfU24vL2Rp9JSUXRuYBI/NRBm/7
         k83g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=D1zmqsgYAEls0Ar0R4MN3csbFZSpx82fYoNUjW1wBrY=;
        b=TAPzX6LHLRnfa3R+DC5vCfELLm8tTlTP0rXm/6sNuxIw/freWXG2ZEk3J0knlkTp4l
         GfqYM210/9AgYz7SifYGGl4EOpj/kENz9WM4Yy3/Z3DKm5UetiOgkwVZeJm/27hIWBiI
         rfrRwyn5vEVGGz+wCiAvSy1w/RrUzeYsDBCAoOgDhAC2Pp/OSnvxkJ7dx87n6meuQ4GM
         ebT3tEkTvc93AjueGVfyh8TXSZD82GDVQ76ehA56pGlVf0gSzruX4JnTkLGZMzFDiwON
         LGhAwnLmyMcSFGEZa7M50BxywAfJeTE4KfOxmSNLvpkly3mZVABp0asnfb6JgDkQzxq+
         CE1Q==
X-Gm-Message-State: AOAM5305C223cleO9k7gH2NkX+FnLGqCvabXT8m5xnLkArFwh/H+bPAm
        +lNqw2ykFGkPzifiiejzMGg=
X-Google-Smtp-Source: ABdhPJwtP0Xiip8vu1kAmWvmDIJLQ1LHm+3F1bnSFteoe3qD4iLdZLFOJyU2IPkYLSKd2CyLRSN4oQ==
X-Received: by 2002:a65:4683:: with SMTP id h3mr12289437pgr.167.1606609298357;
        Sat, 28 Nov 2020 16:21:38 -0800 (PST)
Received: from [10.0.1.10] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id y24sm10302745pfe.42.2020.11.28.16.21.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Nov 2020 16:21:37 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: Lockdep warning on io_file_data_ref_zero() with 5.10-rc5
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <c16232dd-5841-6e87-bbd0-0c18f0fc982b@gmail.com>
Date:   Sat, 28 Nov 2020 16:21:36 -0800
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A68B2535-0B9D-43C9-9762-AE8427E64773@gmail.com>
References: <C3012989-5B09-4A88-B271-542C1ED91ABE@gmail.com>
 <c16232dd-5841-6e87-bbd0-0c18f0fc982b@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Nov 28, 2020, at 4:13 PM, Pavel Begunkov <asml.silence@gmail.com> =
wrote:
>=20
> On 28/11/2020 23:59, Nadav Amit wrote:
>> Hello Pavel,
>>=20
>> I got the following lockdep splat while rebasing my work on 5.10-rc5 =
on the
>> kernel (based on 5.10-rc5+).
>>=20
>> I did not actually confirm that the problem is triggered without my =
changes,
>> as my iouring workload requires some kernel changes (not iouring =
changes),
>> yet IMHO it seems pretty clear that this is a result of your commit
>> e297822b20e7f ("io_uring: order refnode recycling=E2=80=9D), that =
acquires a lock in
>> io_file_data_ref_zero() inside a softirq context.
>=20
> Yeah, that's true. It was already reported by syzkaller and fixed by =
Jens, but
> queued for 5.11. Thanks for letting know anyway!
>=20
> =
https://lore.kernel.org/io-uring/948d2d3b-5f36-034d-28e6-7490343a5b59@kern=
el.dk/T/#t

Thanks for the quick response and sorry for the noise. I should improve =
my
Googling abilities and check the iouring repository the next time.

Regards,
Nadav=
