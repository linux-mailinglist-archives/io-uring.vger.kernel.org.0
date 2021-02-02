Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887F830C888
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 18:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbhBBRx3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 12:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbhBBRvM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 12:51:12 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FB8C061786
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 09:50:32 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id p20so11977527ejb.6
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 09:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q7b/5RMtkxFfK48Fs0uXkc+wVXmOkWkDGx2P6aNVSBY=;
        b=3adaXgzDp1Tjz/8eZ3bLey54hZKyDnVBiQfbF13dPoj2QNFcIXNJN59PsebH8ePSLi
         D7b1w2MO4n/UzbldPPr1ldSvUAJnzgC0TR5UUHM6uR7pk8P/RlcvYUu5kmHiJyFmWv9n
         bkUrx1ULMiVglmhellqf3NBVnFbYOaqeIMonVl6RkN3j1jf46qT0iPrcoBKAK/0H5dGl
         TKAv1ArPjRbleZ7kii2YBdG9+C9gZ02szggASdXZNe6AMvnklYDQTAjwbw8NFSakDC8M
         MMlEXr4zkS8JfIHwWY9SNvpjvJQnpR0Kfaytb+d++jXdd1O/qzdc8/vC33qzQiEJ8FqC
         gZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q7b/5RMtkxFfK48Fs0uXkc+wVXmOkWkDGx2P6aNVSBY=;
        b=K0i8en50d7zJrmz7UTChKu30dBpFSQAo5wXK+UZVO+HB9P3xBvgX0HoLROqAZ4kztH
         E0orJHGILdTBVNIeVQrgwqa7evB5hRc4vGY6B9QNgNgrOoKk7I5yIbYtTa7NtZxzhUrn
         Rmcw5iACiAQcw7s439+CM33vdGoJcwDYLlE+eaLXwszpBtqS831T3lygG8IfWXbZW18h
         9pmzWgVLePUhWvy8tIis/sZNpqYn670TbLD8Bw4B7xHsORX5vnaAONuyiYYQ34etkynI
         h7FZ2+cW+HOiDmcfBC+R0nzQSTfKMDxtILramfEhnAISERHMsKtTtTK8aqyXl822kr2W
         +6FQ==
X-Gm-Message-State: AOAM533leBUhFTA2R75sVDFc5bXZa3l+IoPdaIykpV4O0dwYetbzLj+i
        5qdVxmS5q2YzXy1LupEGQHZXJOszeX0OmICSGGqnzA==
X-Google-Smtp-Source: ABdhPJwS4vkqyzhtGwAnnXT0ZE8f3XBRnYonycLCnx8CCV+WefHuzvtwW4qGYkxgh5lmzSalYq79EE+ppYMYHDZz4Pk=
X-Received: by 2002:a17:906:1c13:: with SMTP id k19mr23670591ejg.338.1612288230765;
 Tue, 02 Feb 2021 09:50:30 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com> <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk> <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk> <1baf259f-5a78-3044-c061-2c08c37f7d58@kernel.dk>
In-Reply-To: <1baf259f-5a78-3044-c061-2c08c37f7d58@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 2 Feb 2021 12:50:19 -0500
Message-ID: <CAM1kxwg7X=MzAiKs44Wx+5J2__rO7Er6892MyENRN0mwxOP_xA@mail.gmail.com>
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Alright, so you're doing ACCEPT with 5.10 and you cannot do ACCEPT
> with SQPOLL as it needs access to the file table. That works in 5.11
> and newer, NOT in 5.10. Same goes or eg open/close and those kinds
> of requests.

okay i must have missed that point somewhere. perfect i'll just avoid
sqpoll until using 5.11. at least this exercise exposed some other
issue pavel wanted to look into!

> --
> Jens Axboe
>
