Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4B1226D1A
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 19:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgGTR27 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 13:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgGTR26 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 13:28:58 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E64C061794
        for <io-uring@vger.kernel.org>; Mon, 20 Jul 2020 10:28:58 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k27so10604808pgm.2
        for <io-uring@vger.kernel.org>; Mon, 20 Jul 2020 10:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=xHiR/oaIUa5pbgNSUHGq5QFpcwnJQsNkMFGVCEqO8so=;
        b=a1MsoLnahfulhQyk3sQsJrIU0k/+OszU3zBP0cJH82Ram+mo+waJkr1NTjIeMwkiqn
         ed9V1qkSCCh7AMcPedy3Ec5w+9GPs5vum5IXSsQiRy0zdzFN2oktRwyJ9S6bOkASAJHQ
         J5kbITP0bxBBJHKljVCnY5OzhNgXH3IUG8QTLjr5GGwIPYblTMvorMwFOZKX3pQptQuD
         Z9cwzEtJcIoupOadWfvGjTH/UfcgqbRTo4EUQvX/KTyygXaGUF9ELU2D7595CYK/IHW7
         bgV+8Btko85b47omINODDlL7L+UfFa38WNmSs01PM2yzgR9sl/M5bNlUXAtUa4NsGF1y
         Pzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=xHiR/oaIUa5pbgNSUHGq5QFpcwnJQsNkMFGVCEqO8so=;
        b=YKYxsrRhKdeUo3yxntvw7skxTu4xF0DjpXBfDCiKcH59BQIL+yplvkEe2pGBV0CQsO
         vt2bqCxItizX+Bj4ozxFwYmww+7T32lzSLHBY40jxXUU8is9S+RwH+WZNaoUSqWyR7/v
         07snvlURVkOqNCRKp7Ilb9uB9PhrlfqXOm4LTdq/r+L5MVf11/MBJBgDMsF1b2f0LwKl
         EDsocOxwKd0+HuDNtBdMb4IYIMpINuqkwRvbCOkJ2Daey4C0+ypddwJgeWYoK+ufKboG
         OjDuMg0ynDklIcsgNHZzF4F9Vs1uqidL7cFU5rxA9mjP9zhfv5UuZ5EArVqMdl4ry+oC
         BmQg==
X-Gm-Message-State: AOAM530tzjF3EXIq8NsUl8PA5PB9fPC+u2/M0NiZUF2pmQe7t6fRwai0
        Ml1L20S6VvXN8jXrSyYgyDQb+Q==
X-Google-Smtp-Source: ABdhPJzw98Kgq+brxFH0izVyuVi0opuOriMG8dW3/iCgRExLS3kbTbxih/QZd30S6kgN2/SxOMHx5g==
X-Received: by 2002:a62:3744:: with SMTP id e65mr21637646pfa.20.1595266137524;
        Mon, 20 Jul 2020 10:28:57 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:600f:2f5b:3d86:4df5? ([2601:646:c200:1ef2:600f:2f5b:3d86:4df5])
        by smtp.gmail.com with ESMTPSA id ji2sm189425pjb.1.2020.07.20.10.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 10:28:56 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: io_uring vs in_compat_syscall()
Date:   Mon, 20 Jul 2020 10:28:55 -0700
Message-Id: <8987E376-6B13-4798-BDBA-616A457447CF@amacapital.net>
References: <b754dad5-ee85-8a2f-f41a-8bdc56de42e8@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
In-Reply-To: <b754dad5-ee85-8a2f-f41a-8bdc56de42e8@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (17F80)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Jul 20, 2020, at 10:02 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> =EF=BB=BFOn 7/20/20 10:58 AM, Andy Lutomirski wrote:
>>=20
>>>> On Jul 20, 2020, at 9:37 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>=20
>>> =EF=BB=BFOn 7/20/20 12:10 AM, Christoph Hellwig wrote:
>>>> Hi Jens,
>>>>=20
>>>> I just found a (so far theoretical) issue with the io_uring submission
>>>> offloading to workqueues or threads.  We have lots of places using
>>>> in_compat_syscall() to check if a syscall needs compat treatmenet.
>>>> While the biggest users is iocttl(), we also have a fair amount of
>>>> places using in_compat_task() in read and write methods, and these
>>>> will not do the wrong thing when used with io_uring under certain
>>>> conditions.  I'm not sure how to best fix this, except for making sure
>>>> in_compat_syscall() returns true one way or another for these cases.
>>>=20
>>> We can probably propagate this information in the io_kiocb via a flag,
>>> and have the io-wq worker set TS_COMPAT if that's the case.
>>>=20
>>=20
>> Is TS_COMPAT actually a cross-arch concept for which this is safe?
>> Having a real arch helper for =E2=80=9Cset the current syscall arch for t=
he
>> current kernel thread=E2=80=9D seems more sensible to me.=20
>=20
> Sure, I'd consider that implementation detail for the actual patch(es)
> for this issue.

There=E2=80=99s a corner case, though: doesn=E2=80=99t io_uring submission f=
requently do the work synchronously in the context of the calling thread?  I=
f so, can a thread do a 64-bit submit with 32-bit work or vice versa?

Sometimes I think that in_compat_syscall() should have a mode in which calli=
ng it warns (e.g. not actually in a syscall when doing things in io_uring). =
 And the relevant operations should be properly wired up to avoid global sta=
te like this.

>=20
> --=20
> Jens Axboe
>=20
