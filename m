Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1886130C86D
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbhBBRtf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 12:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbhBBRrb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 12:47:31 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3D8C061797
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 09:46:50 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hs11so31318878ejc.1
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 09:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SND7QUg5tGIFBlnjjNC83cm0uubjtKgj1HdYdfK4dPs=;
        b=xqdA2yaDGbMQeRRpzF8JjvYfCsReckrlzNUUE473lJ0FYzpmsLmIfljG5wzouv7m6/
         qPCGMotJdYZ5MBY+tEA+8xCnsh3RpTkO5AZAsTIusJyTG0ncKxglQpkDBKFAoBgaZQkq
         +jcjI5INKWRY8qzPqvYJ38FvYiQ0y+oUffL3bgnYdSnVwIMH1bhHtyjZcJFRTgZIMHPQ
         3Er76F1nUgMRwl1YndSeydtcfYeryXr9Krwo62z4KM+4HNrAJ+s5WKB6aCW3U9NyFsuk
         Hrt6iUdKUD8Mw8MJtI/g9HaLsmEZRXEPbu9OLwlXJCzRNHvntsRu0HCCC0RgUNGBuIty
         2imA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SND7QUg5tGIFBlnjjNC83cm0uubjtKgj1HdYdfK4dPs=;
        b=YWzsld5t72lDAzO25PXMgeM8O5+5q3lnM2yt5i1YvbTGaZVjaBCU528MyAhS2oNy0v
         A/EpXm3mnUu3PGiHZB0FP1WOTsVXEMMvUOCKfv+ReJWjGj0z/xZFr6cJ2EUNrEgD3H7w
         cexpjvQ5CwH2NhMGiWCApq1Du3H3YbIQe+aU7eFa9onrLFqttDn9KallK7tD+zZUHqw5
         gp6wa2yZ9DwT1+Lg5ZfJmZzLZVLt5wJ7vn3KxCC5t7nii7VTd2F8a88rs2dSEhRwUEwt
         b12N18ye8ZKtZWSCDHoR6hGBgvqMakeSt2P5Lr5+BJjV155HjQ0TCVqk9ZoIwTU8R91K
         6IoQ==
X-Gm-Message-State: AOAM531L0UMA1xBQqMB/rEN39QbjmSco7JfYMzZrmIAsf2Q5FwDxJ5We
        tk3h/t5xGtDHJn06UYNqlXCO1OLvmxqSJf5gc6go5Q==
X-Google-Smtp-Source: ABdhPJxW6G09xxPm6IL6amM4lcygENTXAhqqrfneOacPYr880CrYpCWZWMVUFBk6+ZLnotdsKFjUWYeMZcZ3r46j9bk=
X-Received: by 2002:a17:906:1c13:: with SMTP id k19mr23657806ejg.338.1612288009503;
 Tue, 02 Feb 2021 09:46:49 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com> <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk> <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
In-Reply-To: <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 2 Feb 2021 12:46:38 -0500
Message-ID: <CAM1kxwg4xyg9jh=V2ruA4JO1_hx9iw_7vYReEEAPWK-DswDDNw@mail.gmail.com>
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> And how are you running it?

compiling the file locally with this command...

clang++ -fuse-ld=lld --std=gnu++2a -I/folder/with/liburing
/path/to/liburing.a -o accept.test accept.test.cpp -g

and then just doing ./accept.test
