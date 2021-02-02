Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46D430C734
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 18:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhBBRNU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 12:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbhBBRLD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 12:11:03 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC686C06174A
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 09:10:23 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id hs11so31134531ejc.1
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 09:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TOEsVVrXYTVasviitt9aTWjTTbJopvwKWYmYVVNS3wo=;
        b=NihvAb5pXc77/U0JanKHddN7JYdugx+SxnCkI37Fm8WXlyBDPx5IND/B2uJDs3K4iQ
         XItvd48cQrZiYBunonVX5Wcr7Bz4ObPA9NVtC3ycpWpeWg//w9M3WsXGsScmA5OEveYW
         UPtvWH4W8Ru4QDyO+9HhaDRC3zU15Lan9weRcibGBtExIWnqiaVfc3fIHoiCn5VCBd4E
         TwifBWFM5G3HJaDtHU95GIg+5S15GuphCMKKZFbW0wtGay98BxwtnuHBVDcs7euqRkVB
         ZC85UMiPmZ4GHaHvFjMFDNiHPsx5aTL1IhI2etB0aPSqhf3jLZrslKeSD3QGmfN+AKvT
         Sl8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TOEsVVrXYTVasviitt9aTWjTTbJopvwKWYmYVVNS3wo=;
        b=P3A20D7JBnLET66rvV3Y+pQ2X+9liQ1UL5ElqafpmkdgQNKobaX6chVPJ+V4g/4l+E
         RoZMOSvH9a3tz7YnvLh3MyB9RK//EtgglCQ9V3nkIwcWLLvaO7NWVNxwTLmojZqQBtzC
         rZfUzWV6cJ3VEacOtwnNc6LMbwMqonbUAvtXF95/ncJBXiTshTWxZKVI90b7GUdo2RCt
         UxI6od1IefBTlQYyB0nGm+BCHbp1Z/uNJ4knrpQmdJxxykEC8hTxB/ubwBb/7S1IugK0
         y9HtF0bv+Z2fwe544egYrs2L45/I24GWD93+4Ij54CWEvCNVKFuf+WXn3SShqlWjfOuf
         OcEQ==
X-Gm-Message-State: AOAM531pVTtz+68SiO4SsW43oh4JJic4CTJABr6/BqesWCEYvzZmOwqG
        5ZFZ4WMN5VKEYloZSaq3AUXnQnmCUSOVXka9d1r2uSau8YOmxg==
X-Google-Smtp-Source: ABdhPJwXLW6oSXLpNskKoCAmhyYJFhyAI8zl1gT+gDt2ab7hYv1JHe3+TBJjVB9HLJpRXbkw+NDjO/9LgXP/xbiCz54=
X-Received: by 2002:a17:906:1c13:: with SMTP id k19mr23513151ejg.338.1612285822460;
 Tue, 02 Feb 2021 09:10:22 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com> <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com> <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
In-Reply-To: <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 2 Feb 2021 12:10:11 -0500
Message-ID: <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Can you send the updated test app?

https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56

same link i just updated the same gist
