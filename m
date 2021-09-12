Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7F1407F5C
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhILSXN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhILSXN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:23:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8549C061574;
        Sun, 12 Sep 2021 11:21:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j1so4734015pjv.3;
        Sun, 12 Sep 2021 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=U/bs3PjkeGfYHulbf2M0xJeDzF6gbg27groVLIx4AqE=;
        b=m/t9Q7Ur2ewBwZZQPT2N75BnjIdMGQ8nTSJi99bX/jC3psPHN7FqYu6TeyAQvf46uc
         fKPxBwsJR4KslfxF3mUv1rQCfhLpdKddifYnsiaTmaIOxksj8bTYLVKoRNjGL6iN0NqL
         csNQz3F1TXAL7PlpNWSYIpoQdSsjethutrl8ibWiEDCybrH6zkT4K2bTCH7lqpwmmpEc
         w0SYBsA6tUCmocXPMs4VkgZchnxCTZDN3RovkMkVMYQW8F3cMd32Sm//SH7LO5tUBJ+s
         14N/r4M3M3285atq+/tWsWAcNfCC4kjbJK9mZstborrOa8bLbGFHE5vfTLUXmUtW4aeG
         9/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=U/bs3PjkeGfYHulbf2M0xJeDzF6gbg27groVLIx4AqE=;
        b=nBpNPtW5Kjbw0NrLXHlT2Bzq+A91nhKsidXbTeJUD6o2NtoOYUPiY+LnknT/jVVUhR
         lT22L/nJ1YthyjRubZLS6sEKAZ6LbsDA4OYpo/1vnetEFNb6FjRl+AzF6s9XWDeO8ZGX
         +E2pkQK6m6u4TznWnfJ1ROYcgmeoLwdRU7s0lwTUiw+blEJTVlSCRFti0F1zXTEkMGcz
         7rShOX8K5IwQ/5suuCMvyPG3XZdpOiohTXiKu731lxvzuns03ulFiecVfgWrMqdVvsMi
         9wmyvbTRIxbzKt+WLH9k/+yerEYtKFwxUS5BuznifFQznr1GWyOvMMofxY/S2A6boAJD
         RLew==
X-Gm-Message-State: AOAM532iofMMXnMxTxuwPtlmnh9phxwEwCDkgZEnaKpg1cQXKlGFbq7D
        AYfL+mwS8ECXm+PIdaSAX9bSs4y3C0Zr0g==
X-Google-Smtp-Source: ABdhPJw7kv3Fm9M50+pru6ljc1jr9D/If3Icki7HhjSweHuqf/6b+EhAJujVRCVJN2WTngfxfCeBdA==
X-Received: by 2002:a17:90a:8c8b:: with SMTP id b11mr8627118pjo.14.1631470918049;
        Sun, 12 Sep 2021 11:21:58 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id g2sm4625419pfr.35.2021.09.12.11.21.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Sep 2021 11:21:57 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: io-uring: KASAN failure, presumably
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <859829f3-ecd0-0c01-21d4-28c17382aa52@kernel.dk>
Date:   Sun, 12 Sep 2021 11:21:55 -0700
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C5C0EB71-B05E-4FE6-871D-900231F8454B@gmail.com>
References: <2C3AECED-1915-4080-B143-5BA4D76FB5CD@gmail.com>
 <859829f3-ecd0-0c01-21d4-28c17382aa52@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Sep 12, 2021, at 11:15 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 9/11/21 8:34 PM, Nadav Amit wrote:
>> Hello Jens (& Pavel),
>>=20
>> I hope you are having a nice weekend. I ran into a KASAN failure in =
io-uring
>> which I think is not "my fault".
>>=20
>> The failure does not happen very infrequently, so my analysis is =
based on
>> reading the code. IIUC the failure, then I do not understand the code =
well
>> enough, as to say I do not understand how it was supposed to work. I =
would
>> appreciate your feedback.
>>=20
>> The failure happens on my own custom kernel (do not try to correlate =
the line
>> numbers). The gist of the splat is:
>=20
> I think this is specific to your use case, but I also think that we
> should narrow the scope for this type of REQ_F_REISSUE trigger. It
> really should only happen on bdev backed regular files, where we =
cannot
> easily pass back congestion. For that case, the completion for this is
> called while we're in ->write_iter() for example, and hence there is =
no
> race here.
>=20
> I'll ponder this a bit=E2=80=A6

I see what you are saying. The assumption is that write_iter() is =
setting
REQ_F_REISSUE, which is not the case in my use-case. Perhaps EAGAIN is
anyhow not the right return value (in my case). I am not sure any other
=E2=80=9Cinvalid" use-case exists, but some documentation/assertion(?) =
can help.

I changed the return error-codes and check that the issue is not
triggered again.

Thanks, as usual, for the quick response.=
