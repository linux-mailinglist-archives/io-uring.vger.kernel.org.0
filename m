Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D8A357E5C
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 10:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhDHIqJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 04:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhDHIqJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 04:46:09 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5911DC061760;
        Thu,  8 Apr 2021 01:45:58 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id z1so1800874ybf.6;
        Thu, 08 Apr 2021 01:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99J/CBzF8eeODcwTLJG1kD3GoFOA/YtJT+K2uJ6P1yo=;
        b=bhM38B4AF1UqtXySCz92Ptq2REVaikD5Y5yxUaKO7BUjux6HIhe0wBLIfObYSFXvuq
         81azzZAW/btmRfS9dHpCWQJVsbji6UpeXiG95l7EfqecBSizs9RuBnLsNEzGwxw/U+xz
         KrvcOg0PKpDE/SB0o4oflbv8gxpW1Klpcs6Rq41qn7bLBFZ23mZvbUQfwSWryX1B+No5
         W3HroZu5wniL9vV5kQb20cpgqXyNUfX6xqR9YtpkLT2rXIe29+d5b/hxHoPLvR0Z5DoI
         WjHgZ6jsEOBgIGPOTh4FCuwaXJEgOSx+/Q4yBiEv+tdtPrSKeB5AllizDt31Z/TC+lwN
         yDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99J/CBzF8eeODcwTLJG1kD3GoFOA/YtJT+K2uJ6P1yo=;
        b=QvRTyDmzX3T/ky4EnpyQwsEL9igepwYbPeXFvoFrUj/M5UBW9HFg1ta4UsnR+RxiTU
         zFn9IY2Bzhqp9cyHofQjPf2dAdUDKpBby0sPMJ7FKzsTl3u8rV2u+ZBbmI5ugQqVVKBz
         ENttA5ylj/KSIWDuLHgVFet1QXvD1QmUm7CRidhrFIgd+dTqJYXvZ3CfjH92WMNaa3gy
         kJ5llj8ZRQwXifTLdtzmuwK7ZLIi+12OaW4MENItWf/96bcKprLn3ahqVVCIn7FAYzaK
         sOXfphQDesHXlwNLGEYLcm4YYTreIBf4LP4hN13lZ8e9v5FMmiEtfq9xqeSviJuF5WU6
         SAkw==
X-Gm-Message-State: AOAM533kuNfvpstZ4qa1g4tj+oThc/BdtNqm/9ji+rwi9ZS2PQpHEhc4
        c6pKyfsav2j3l7T52gM5JT918BP9Y/Md42o0rOA=
X-Google-Smtp-Source: ABdhPJzQ91IitgARZIRhXoXa3dYqesHpWzFqneoB2jN1/OpeIqtlUH4dc7cb2t9aWQqxJq+BhoJpZQo1w6AbqJ2asK8=
X-Received: by 2002:a25:a087:: with SMTP id y7mr9873697ybh.167.1617871557515;
 Thu, 08 Apr 2021 01:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210330055957.3684579-1-dkadashev@gmail.com> <20210330055957.3684579-2-dkadashev@gmail.com>
 <20210330071700.kpjoyp5zlni7uejm@wittgenstein>
In-Reply-To: <20210330071700.kpjoyp5zlni7uejm@wittgenstein>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 8 Apr 2021 15:45:46 +0700
Message-ID: <CAOKbgA6spFzCJO+L_uwm9nhG+5LEo_XjVt7R7D8K=B5BcWSDbA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 30, 2021 at 2:17 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> The only thing that is a bit unpleasant here is that this change
> breaks the consistency between the creation helpers:
>
> do_mkdirat()
> do_symlinkat()
> do_linkat()
> do_mknodat()
>
> All but of them currently take
> const char __user *pathname
> and call
> user_path_create()
> with that do_mkdirat() change that's no longer true. One of the major
> benefits over the recent years in this code is naming and type consistency.
> And since it's just matter of time until io_uring will also gain support
> for do_{symlinkat,linkat,mknodat} I would think switching all of them to
> take a struct filename
> and then have all do_* helpers call getname() might just be nicer in the
> long run.

So, I've finally got some time to look into this. do_mknodat() and
do_symlinkat() are easy. But do_linkat() is more complicated, I could use some
hints as to what's the reasonable way to implement the change.

The problem is linkat() requires CAP_DAC_READ_SEARCH capability if AT_EMPTY_PATH
flag is passed. Right now do_linkat checks the capability before calling
getname_flags (essentially). If do_linkat is changed to accept struct filename
then there is no bulletproof way to force CAP_DAC_READ_SEARCH presence (e.g. if
for whatever reason AT_EMPTY_PATH is not in flags passed to do_linkat). Also, it
means that the caller is responsible to process AT_EMPTY_PATH in the first
place, which means logic duplication.

Any ideas what's the best way to approach this?

Thanks.

-- 
Dmitry Kadashev
