Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BBC3BE38A
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 09:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhGGHaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 03:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhGGHaJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 03:30:09 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D2DC061574;
        Wed,  7 Jul 2021 00:27:29 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id o139so1667371ybg.9;
        Wed, 07 Jul 2021 00:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZDMx0xn9K56slO2ccdjdkVky2pH9xzn56fgtn0hQnGw=;
        b=UpHJ9I6vyrH2K8m5PfwOuY3AQOv70YQKr11ey+eYOku5OeoHQpR9s1+QfvszqUJt8G
         SBT2q0P3wNFO9nJi6zSQPsJ2CST4fk4J0K0gRMMLhu1OcBviLPXa2ZfSc+BN3cUdSGry
         PCaNBj6XckIWF+XMfyw/WteLJT7xnYnbyMxLuJccridLzjce0BjTde/GXhBF3YaxWYn/
         nZIB+8KF7sPI0BYQPXAlw9SnNQTSn/ghP9rp/wy7st2fKYUB+9l0XIOAT8MD6nVWAXEG
         IvM3KkjnIJKYJqm7TNOqcQpEMejs3gAzaBTJWx8IG8A1mB0bQ9E6fR2BWXJiCQfypMrm
         5KzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDMx0xn9K56slO2ccdjdkVky2pH9xzn56fgtn0hQnGw=;
        b=mFm8xFQYyj+AtNfgIhg7Dw4KcpFgx/WVqCFR8vqNnz+5KakqdJqK9hb2m83khoig1u
         OK/ryTRevOPR0XysbnFzpQOc4b05RFlW/MpeMM5nvylTefhjwrZxMm4mjZIPlzvbjzkJ
         UbSHHRn8G8V190hGYDUvkVTzZ9SeXdL2tofyp1El4lkUwapTqdEMS5sEBzbpwFBDOxZ6
         ddSk7QJRVONZY/Af+TO3AG+Pexf8dy6C1QgGEVguZbait+JJk+iEj4M11fm2R4BLePtY
         66WVJkkXK7I0Uxd55/cew3wCOtFfmmZDjZa/Vx4oExaAGscFROTusJKPXy02reLgkKtB
         I85A==
X-Gm-Message-State: AOAM532hmnv6shoooPjEj1JnouIgQkcyaXQUPoXD8/idyt6ULV5CkcDj
        PvS+frNJpapbZ0aAyKOD05Y8tU2Dv7TtyMYqqGc=
X-Google-Smtp-Source: ABdhPJwEhJOOCJ0u3fXWoBNEsy46dPg5zrHdbEX4QeuOO5yphSnOeDmUOdl3ByWk24HRYuw5USOFB/0ECLS7RWYLAkE=
X-Received: by 2002:a25:da11:: with SMTP id n17mr30034251ybf.428.1625642847133;
 Wed, 07 Jul 2021 00:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210706124901.1360377-1-dkadashev@gmail.com> <20210706124901.1360377-8-dkadashev@gmail.com>
 <CAHk-=whdhY-RT=8wky=MgxAo0C9gSODcimLg3brdNy9p6OzhxA@mail.gmail.com>
In-Reply-To: <CAHk-=whdhY-RT=8wky=MgxAo0C9gSODcimLg3brdNy9p6OzhxA@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 7 Jul 2021 14:27:16 +0700
Message-ID: <CAOKbgA7MiqZAq3t-HDCpSGUFfco4hMA9ArAE-74fTpU+EkvKPw@mail.gmail.com>
Subject: Re: [PATCH v7 07/10] fs: make do_linkat() take struct filename
To:     Linus Torvalds <torvalds@linux-foundation.org>
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

On Wed, Jul 7, 2021 at 1:05 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is the only one in the series that I still react fairly negatively at.
>
> I still just don't like how filename_lookup() used to be nice and easy
> to understand ("always eat the name"), and while those semantics
> remain, the new __filename_lookup() has those odd semantics of only
> eating it on failure.
>
> And there is exactly _one_ caller of that new __filename_lookup(), and it does
>
>         error = __filename_lookup(olddfd, old, how, &old_path, NULL);
>         if (error)
>                 goto out_putnew;
>
> and I don't even understand why you'd want to eat it on error, because
> if if *didn't* eat it on error, it would just do
>
>         error = __filename_lookup(olddfd, old, how, &old_path, NULL);
>         if (error)
>                 goto out_putnames;
>
> and it would be much easier to understand (and the "out_putnew" label
> would go away entirely)
>
> What am I missing? You had some reason for not eating the name
> unconditionally, but I look at this patch and I just don't see it.

__filename_lookup() does that "eat the name on error" for uniformity
with the __filename_create(), and the latter does that mostly because Al
suggested to do it that way:

https://lore.kernel.org/io-uring/20210201150042.GQ740243@zeniv-ca/

Granted, he did that back when this series was much smaller, only about
mkdirat, and in that case it looked like it makes things a tad simpler,
and even though I found the semantics a bit confusing, I've assumed that
I'm missing something and this is something the FS code does, so people
are used to it.

Anyway, I'll send v8 of this series with yet another preparation patch,
that will change filename_parenat() to return an error code instead of
struct filename *, and split it into two: filename_parenat() that always
eats the name, and __filename_parentat() that never eats the name. And
__filename_lookup() and __filename_create() will never eat the name as
well, so things are nice and uniform and easy to reason about.

And hopefully if Al does not like that approach he can weigh in.

-- 
Dmitry Kadashev
