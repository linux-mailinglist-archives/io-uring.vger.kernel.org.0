Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8303718D3
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 18:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhECQGM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 12:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhECQGM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 12:06:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC777C06174A
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 09:05:18 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gj14so3381698pjb.5
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 09:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=uLnt91tc2pnUIyT7YI8X96lYU8WCxDw6ZB6QLt1X+W4=;
        b=Ue92zNTA0q1aHeR5Ncr/UOW9zdBS1jD+IYbVdMndT7N+rdhSAfmJDMkGZw8dyop9Fg
         j7MWa5HE6oo8yuqfl9LWBFeHC+5FW12nQcdEpPxbx3UkQCZ2RXoXWnpIqZTLu4XwtmDx
         3S41jyYW6SLz3P9Kln1mvAF8PCOHKnU3qOVslOq8pz5lQD3fu4BDXW2GFWAdzDKTZSYB
         F9tAhy2RAa+PuO8+iTGgkvNCWsK1/oxSp3G+G3fVOCQEwXwrcyiS2UKaqtsN82rsz+8t
         WBkwDrj6M/B/EQYXQcYbGPEes22h0xUOgbiHbFP+K/kUqQqH81mZb6zQhEImG1MfmgX9
         gkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=uLnt91tc2pnUIyT7YI8X96lYU8WCxDw6ZB6QLt1X+W4=;
        b=QXvzrOky5QMpUVKWr65+XXr3ddQOvlz4Bf5xU+SBrqv7po39l8F1g5WIxIFjREv2RD
         a305eB+qXz2Rc1hPM3AAE9ZaJTY7QlqAkPl0kZUbIL3+3VB9T2nGowM5eReUlU1MbiwZ
         QBQRQG2RzZguHlTZhUy215hliAzGjtHa+xqeF9fx2HIKK+ECfdniunQqfjYKD30IVp3g
         nAf2Ktwn/3AQupVOG2mYyFT+sxKPeQstQ9dbUDjnjw4ji0KlqQWDpbl+HXnZgCpLv+K+
         Z1QdtGGRzQfjxqvghR44X9hrNWBY+Rm6jPZQHtAu1lDg0bf9BO7EdrT+HWZ3vq4i+Cbi
         +Dlw==
X-Gm-Message-State: AOAM530W+5/RrVmo2htF4pEF8Azi7dzt60Y9m1B/qj0yWr16h29nGhID
        ymPJmB78r3i+ddTlszyMrsAW05SyeggcLCTD
X-Google-Smtp-Source: ABdhPJwtDAaXX4mlafMNdmEkobxScO2VjZ8KFmDQuNM9DPTdtvPtlCUHfvVD6cFGnY1U/Dj83hZ6Cg==
X-Received: by 2002:a17:90a:ae10:: with SMTP id t16mr22736759pjq.86.1620057918132;
        Mon, 03 May 2021 09:05:18 -0700 (PDT)
Received: from smtpclient.apple ([2601:646:c200:1ef2:1960:85f5:fe97:e8ac])
        by smtp.gmail.com with ESMTPSA id f135sm9268244pfa.102.2021.05.03.09.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 09:05:17 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es' registers for io_threads
Date:   Mon, 3 May 2021 09:05:16 -0700
Message-Id: <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
X-Mailer: iPhone Mail (18E199)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> On May 3, 2021, at 7:00 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> =EF=BB=BFStefan,
>=20
> On Sun, Apr 11 2021 at 17:27, Stefan Metzmacher wrote:
>=20
> Can you please CC x86 people on patches which are x86 related?
>=20
>> This allows gdb attach to userspace processes using io-uring,
>> which means that they have io_threads (PF_IO_WORKER), which appear
>> just like normal as userspace threads.
>=20
> That's not a changelog, really. Please describe what the problem is and
> why the chosen solution is correct.
>=20
>> See the code comment for more details.
>=20
> The changelog should be self contained.
>=20
>> Fixes: 4727dc20e04 ("arch: setup PF_IO_WORKER threads like PF_KTHREAD")
>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> cc: Linus Torvalds <torvalds@linux-foundation.org>
>> cc: Jens Axboe <axboe@kernel.dk>
>> cc: linux-kernel@vger.kernel.org
>> cc: io-uring@vger.kernel.org
>> ---
>> arch/x86/kernel/process.c | 49 +++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 49 insertions(+)
>>=20
>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>> index 9c214d7085a4..72120c4b7618 100644
>> --- a/arch/x86/kernel/process.c
>> +++ b/arch/x86/kernel/process.c
>> @@ -163,6 +163,55 @@ int copy_thread(unsigned long clone_flags, unsigned l=
ong sp, unsigned long arg,
>>    /* Kernel thread ? */
>>    if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>>        memset(childregs, 0, sizeof(struct pt_regs));
>> +        /*
>> +         * gdb sees all userspace threads,
>> +         * including io threads (PF_IO_WORKER)!
>> +         *
>> +         * gdb uses:
>> +         * PTRACE_PEEKUSR, offsetof (struct user_regs_struct, cs)
>> +         *  returning with 0x33 (51) to detect 64 bit
>> +         * and:
>> +         * PTRACE_PEEKUSR, offsetof (struct user_regs_struct, ds)
>> +         *  returning 0x2b (43) to detect 32 bit.
>> +         *
>> +         * GDB relies on that the kernel returns the
>> +         * same values for all threads, which means
>> +         * we don't zero these out.
>> +         *
>> +         * Note that CONFIG_X86_64 handles 'es' and 'ds'
>> +         * differently, see the following above:
>> +         *   savesegment(es, p->thread.es);
>> +         *   savesegment(ds, p->thread.ds);
>> +         * and the CONFIG_X86_64 version of get_segment_reg().
>> +         *
>> +         * Linus proposed something like this:
>> +         * (https://lore.kernel.org/io-uring/CAHk-=3DwhEObPkZBe4766DmR46=
-=3D5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com/)
>> +         *
>> +         *   childregs->cs =3D __USER_CS;
>> +         *   childregs->ss =3D __USER_DS;
>> +         *   childregs->ds =3D __USER_DS;
>> +         *   childregs->es =3D __USER_DS;
>> +         *
>> +         * might make sense (just do it unconditionally, rather than mak=
ing it
>> +         * special to PF_IO_WORKER).
>> +         *
>> +         * But that doesn't make gdb happy in all cases.
>> +         *
>> +         * While 32bit userspace on a 64bit kernel is legacy,
>> +         * it's still useful to allow 32bit libraries or nss modules
>> +         * use the same code as the 64bit version of that library, which=

>> +         * can use io-uring just fine.

Whoa there!  Can we take a big step back?

I saw all the hubbub about making io threads visible to gdb.  Fine, but why d=
o we allow gdb to read and write their register files at all?  They *don=E2=80=
=99t have user state* because they *are not user threads*.  Beyond that, Lin=
ux does not really have a concept of a 32-bit thread and a 64-bit thread. I r=
ealize that gdb does have this concept, but gdb is *wrong*, and it regularly=
 causes problems when debugging mixed-mode programs or VMs.

Linus, what is the actual effect of allowing gdb to attach these threads?  C=
an we instead make all the regset ops do:

if (not actually a user thread) return -EINVAL;

Any other solution results in all kinds of nasty questions. For example, ker=
nel threads don=E2=80=99t have FPU state =E2=80=94 what happens if gdb tries=
 to access FPU state?  What happens if gdb tries to *allocate* AMX state for=
 an io_uring thread? What happens if the various remote arch_prctl accessors=
 are used?

=E2=80=94Andy=
