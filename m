Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E873033F4
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 06:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbhAZFK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbhAZB3o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 20:29:44 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C392C0698DA
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 17:28:56 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id o10so20561862lfl.13
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 17:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eCBiVPLnNd99s9ixAeOAKiUEku0CKs85XbwIxF+qIiU=;
        b=LKe3NezafxofVDDFMckuJejnvRhI98RhnDFXvBKXGftcSflu2cCY4yPblP7gnkxnWY
         6nyy8Lng59qDw3xg86xE7YL+nsgf/Da4VzTjdVrdeAKrrgl4DiwcDMsjCfhZE9OSQfrG
         1tuZInnROaBkJou88CLzvrHw6RmAC4/LrchEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eCBiVPLnNd99s9ixAeOAKiUEku0CKs85XbwIxF+qIiU=;
        b=cMIqEz7tTkpWeUvQCfyKEoG5ryVwU8CkUDIyhmyZ/VkNpo/V8YXJoS+1ZsK/0vX894
         4Y11sGe73digdZbqi6s5S57Wl/s/9TYzcdmvWC06tb5At6bizV0mstw0GABwGtfDu4Pg
         iQ+BjESislsN+JwXdcxfM2hlxOQGRCT3hLCYD1GXrF0zFPwZD6HBxjxQlsgAxbG9YCb1
         Tukvtk11uOTAfmd9L0hRtCk0Z5/VnlxLw8SvGf5AyjFIqcUtmmFBXMD7iccuaasYQQ6k
         wyRMBz5ozvAAoQTTqwY0B99uSu7FVqgwASJkF6Xs/yf8ht2a3mOIgtvwwrcXovzJNHUW
         4H4Q==
X-Gm-Message-State: AOAM5308FGVGAnqq1HjymH7UNrl1oLaBnW00c04vT0Uo5FYH2x0JP8DX
        NV3FFEWKGAsfmIflZOwkC4NZ9y0/b8SaAA==
X-Google-Smtp-Source: ABdhPJyERm6oaXvkbskXcJS5KvAcRiMgHHb4HoF/VnyDVkRxS7buOy5jjgBTI9oX2m2alLut2pp8zA==
X-Received: by 2002:a05:6512:a8c:: with SMTP id m12mr1481781lfu.253.1611624534109;
        Mon, 25 Jan 2021 17:28:54 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id k30sm935483ljc.140.2021.01.25.17.28.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 17:28:53 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id f1so10766688lfu.3
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 17:28:53 -0800 (PST)
X-Received: by 2002:ac2:420a:: with SMTP id y10mr1414183lfh.377.1611624532705;
 Mon, 25 Jan 2021 17:28:52 -0800 (PST)
MIME-Version: 1.0
References: <20210125213614.24001-1-axboe@kernel.dk> <CAHk-=whh=+nkoZFqb1zztY9kUo-Ua75+zY16HeU_3j1RV4JR0Q@mail.gmail.com>
 <4bd713e8-58e7-e961-243e-dbbdc2a1f60c@kernel.dk>
In-Reply-To: <4bd713e8-58e7-e961-243e-dbbdc2a1f60c@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 25 Jan 2021 17:28:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgdL-5=7dxpertTre5+3a5Y+D7e+BJ2aVb=-cceKKcJ5w@mail.gmail.com>
Message-ID: <CAHk-=wgdL-5=7dxpertTre5+3a5Y+D7e+BJ2aVb=-cceKKcJ5w@mail.gmail.com>
Subject: Re: [PATCHSET RFC] support RESOLVE_CACHED for statx
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 25, 2021 at 5:06 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Which ones in particular? Outside of the afs one you looked a below,
> the rest should all be of the "need to do IO of some sort" and hence
> -EAGAIN is reasonable.

Several of them only do the IO conditionally, which was what I reacted
to in at least cifs.

But I think it's ok to start out doing it unconditionally, and make it
fancier if/when/as people notice or care.

              Linus
