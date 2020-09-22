Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C7227466E
	for <lists+io-uring@lfdr.de>; Tue, 22 Sep 2020 18:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIVQUO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Sep 2020 12:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgIVQUO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Sep 2020 12:20:14 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EA4C0613CF
        for <io-uring@vger.kernel.org>; Tue, 22 Sep 2020 09:20:13 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id u24so1550402pgi.1
        for <io-uring@vger.kernel.org>; Tue, 22 Sep 2020 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=OuYZ36WnxwIp9b6camA1INonBCd7PS5F7n5lbvDtQoE=;
        b=vkrTbtOH4vHnR/84aYqVDHrQ5AGvI5gJZ+epaaRbPDginNWZ7IQOaHp0KiQGLoRIqK
         lCtpCBfEppwh5xdm5Fg2E09yGBsQ1omUh0FsVnB0AGbc0KabsZevsMs5kdugIv8CVE5/
         WA4g4A2X6yhuybhLsZ26G3b/9jK9koGpq3H8xumPWJXJrnSzbLUYbfDR++IgN0bKoBQq
         n0DG/oDelKPnE35WpGCvEELD66Jz17cs7lC56sr6mITihQA1DVJ1mt9BGhniHUyWF6Lh
         zzYPOu4uBf4nQ34xtWqSlA6XpnJ8NFviCNNpjE2H0nhrpatshwJ5hPmeTiRqtrX3VMpc
         QmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=OuYZ36WnxwIp9b6camA1INonBCd7PS5F7n5lbvDtQoE=;
        b=nLtNe2oVXUpGJn+PJfOzIEzIDKD6D9KxiDHyK4pFtSX2QZ2UdEqc4IuLHblYhIZzbr
         5LIzexiUSGGmjyNo1pRazzjqW5IWP05uGCd+K3D5m9t21Gs1b8CG+Wfx1QyGNPLhLC8Q
         fjpGf2wrvn24ngEcWMgcV9fsmAKjGjAcK5pXaiIM1FduXLk125CLnkT54/h53D5aF9je
         w2B/tf8qBOauKXstqq9FvSnZ1nOzuXgta8KnUhGcH2jF3wDZAOLzMKf47mMfjantuqCA
         OFiXXLyh25JREGti19sFYSREvEXj7itgY4TyehQXMBqDMfhSxjRCS7XToXaxZSkZmybi
         IZig==
X-Gm-Message-State: AOAM532M0rk9xBiIm46S9Bs7Hsj8rQo/9kTPn49zPzqyiF1ogZjqg8ma
        dL2FMgVzH3VEGyxkmgW/huJVfw==
X-Google-Smtp-Source: ABdhPJzVdW+N5Ufbpna8vjsXyt2h2YPelrT15cDlhJa791IGnC+04vroQZTdEBrKNKjccVmTF6OthA==
X-Received: by 2002:a17:902:fe88:b029:d2:2a16:254 with SMTP id x8-20020a170902fe88b02900d22a160254mr5598643plm.23.1600791613205;
        Tue, 22 Sep 2020 09:20:13 -0700 (PDT)
Received: from localhost.localdomain ([2601:646:c200:1ef2:f4bd:fe2:85ed:ea92])
        by smtp.gmail.com with ESMTPSA id gk14sm2982522pjb.41.2020.09.22.09.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 09:20:12 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Date:   Tue, 22 Sep 2020 09:20:07 -0700
Message-Id: <446566DF-ECBC-449C-92A1-A7D5AEBE9935@amacapital.net>
References: <CAK8P3a39jN+t2hhLg0oKZnbYATQXmYE2-Z1JkmFyc1EPdg1HXw@mail.gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <CAK8P3a39jN+t2hhLg0oKZnbYATQXmYE2-Z1JkmFyc1EPdg1HXw@mail.gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
X-Mailer: iPhone Mail (18A373)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Sep 22, 2020, at 2:01 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> =EF=BB=BFOn Tue, Sep 22, 2020 at 9:59 AM Pavel Begunkov <asml.silence@gmai=
l.com> wrote:
>>> On 22/09/2020 10:23, Arnd Bergmann wrote:
>>> On Tue, Sep 22, 2020 at 8:32 AM Pavel Begunkov <asml.silence@gmail.com> w=
rote:
>>>> On 22/09/2020 03:58, Andy Lutomirski wrote:
>>>>> On Mon, Sep 21, 2020 at 5:24 PM Pavel Begunkov <asml.silence@gmail.com=
> wrote:
>>>>> I may be looking at a different kernel than you, but aren't you
>>>>> preventing creating an io_uring regardless of whether SQPOLL is
>>>>> requested?
>>>>=20
>>>> I diffed a not-saved file on a sleepy head, thanks for noticing.
>>>> As you said, there should be an SQPOLL check.
>>>>=20
>>>> ...
>>>> if (ctx->compat && (p->flags & IORING_SETUP_SQPOLL))
>>>>        goto err;
>>>=20
>>> Wouldn't that mean that now 32-bit containers behave differently
>>> between compat and native execution?
>>>=20
>>> I think if you want to prevent 32-bit applications from using SQPOLL,
>>> it needs to be done the same way on both to be consistent:
>>=20
>> The intention was to disable only compat not native 32-bit.
>=20
> I'm not following why that would be considered a valid option,
> as that clearly breaks existing users that update from a 32-bit
> kernel to a 64-bit one.
>=20
> Taking away the features from users that are still on 32-bit kernels
> already seems questionable to me, but being inconsistent
> about it seems much worse, in particular when the regression
> is on the upgrade path.
>=20
>>> Can we expect all existing and future user space to have a sane
>>> fallback when IORING_SETUP_SQPOLL fails?
>>=20
>> SQPOLL has a few differences with non-SQPOLL modes, but it's easy
>> to convert between them. Anyway, SQPOLL is a privileged special
>> case that's here for performance/latency reasons, I don't think
>> there will be any non-accidental users of it.
>=20
> Ok, so the behavior of 32-bit tasks would be the same as running
> the same application as unprivileged 64-bit tasks, with applications
> already having to implement that fallback, right?
>=20
>=20

I don=E2=80=99t have any real preference wrt SQPOLL, and it may be that we h=
ave a problem even without SQPOLL when IO gets punted without one of the fix=
es discussed.

But banning the mismatched io_uring and io_uring_enter seems like it may be w=
orthwhile regardless.=
