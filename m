Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA44372375
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 01:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhECXQD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 19:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhECXQD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 19:16:03 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F65C061574
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 16:15:09 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id y30so4966302pgl.7
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 16:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=xhf/1dJduLOJCNe2AU9V1VQzCeL9nYRZSP5wzFlpp5w=;
        b=gkXsOsEw7q9iyrOGQiFwqXE8RR5WxPF+OSd8fvDbxNDWbodCc3YZWiaoa98oBbEH8I
         Wk6Wje2UNgZhK5Yxw7mbLZb8tdi3Rp91YcOFAwutr2iujEWg7Q/xfcO2xmKTA0yUqKrz
         XQdQUANWPUtzmzqmaQvA232aY1/mIETJiJrMGzm8b+67TG2IxBAnOp1vKjBw5I0/mNOd
         5yUqocsuGzcQxfsT3wPvD8dRKpAjEGTv9bqPZuelLs3WitqsbEgqcQ+eC7IzyMYRlN4j
         i/aVb0oF2BnRWK8Ib0xbCdtRRfM0q25ptJMMJLy3zuL7l1tJqV2ti+QRJzW/P+06YorG
         4zjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=xhf/1dJduLOJCNe2AU9V1VQzCeL9nYRZSP5wzFlpp5w=;
        b=AfbYOfRwWcDuDaQLWeyXLpmB8KXQbN+I5rM/WRwpMFpP2FaKqVNlna1kgeaYqJ/ehf
         8leTKfGX87DMNzt5FRn7pHFJyx3D8IrN3Kqn3S2fVAzfWKrAbtwAyvPb7X3VRCLatRP/
         GktJ2S25drL6+RX0UUInsT9pYD2ut6llhJyDFSILAt0BwOsPpgYsSbH6Nq6VVV9kRqwN
         uiZGqRMXrreCwJ6QQ7PblW74rF+Sfqv79iPIBpcQZj9ujEbD60cy6MiS8y7pGFUDxTz9
         TMYIrKPyvq62ow3LpF++8fNlKq3UwEpTVlipBAP1cRQiiCFDnVd5S4FbkbisHAHP4VIj
         qeLQ==
X-Gm-Message-State: AOAM532Ri1PM5nbaAJ7WYGWmyo9DN/rDKtdyw9g96OcxzrjtxfIwYpeP
        l8/6hATZuD/a8ezgZ7uZg6zo1dEGvhQAKFPU
X-Google-Smtp-Source: ABdhPJzyUQSG+8dtdbtl1+SgXBnW9iHM1DAnA4CtPRI6rgbxtnXiFe8XJuyQTD38oFmBy3TAHHUdQg==
X-Received: by 2002:a17:90a:e003:: with SMTP id u3mr1204009pjy.77.1620083708528;
        Mon, 03 May 2021 16:15:08 -0700 (PDT)
Received: from smtpclient.apple ([2601:646:c200:1ef2:e4d2:be75:9322:ee7])
        by smtp.gmail.com with ESMTPSA id w2sm10301356pfb.174.2021.05.03.16.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 16:15:08 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es' registers for io_threads
Date:   Mon, 3 May 2021 16:15:06 -0700
Message-Id: <2D8933AD-A3A8-4965-9061-3929D84AAAA2@amacapital.net>
References: <8735v3jujv.ffs@nanos.tec.linutronix.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <8735v3jujv.ffs@nanos.tec.linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
X-Mailer: iPhone Mail (18E199)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On May 3, 2021, at 3:56 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> =EF=BB=BFOn Mon, May 03 2021 at 15:08, Linus Torvalds wrote:
>>> On Mon, May 3, 2021 at 2:49 PM Andy Lutomirski <luto@kernel.org> wrote:
>>>=20
>>> To be clear, I'm suggesting that we -EINVAL the PTRACE_GETREGS calls
>>> and such, not the ATTACH.  I have no idea what gdb will do if this
>>> happens, though.
>>=20
>> I feel like the likelihood that it will make gdb work any better is
>> basically zero.
>>=20
>> I think we should just do Stefan's patch - I assume it generates
>> something like four instructions (two loads, two stores) on x86-64,
>> and it "just works".
>>=20
>> Yeah, yeah, it presumably generates 8 instructions on 32-bit x86, and
>> we could fix that by just using the constant __USER_CS/DS instead (no
>> loads necessary) since 32-bit doesn't have any compat issues.
>>=20
>> But is it worth complicating the patch for a couple of instructions in
>> a non-critical path?
>>=20
>> And I don't see anybody stepping up to say "yes, I will do the patch
>> for gdb", so I really think the least pain is to just take the very
>> straightforward and tested kernel patch.
>>=20
>> Yes, yes, that also means admitting to ourselves that the gdb
>> situation isn't likely going to improve, but hey, if nobody in this
>> thread is willing to work on the gdb side to fix the known issues
>> there, isn't that the honest thing to do anyway?
>=20
> GDB is one thing. But is this setup actually correct under all
> circumstances?
>=20
> It's all fine that we have lots of blurb about GDB, but there is no
> reasoning why this does not affect regular kernel threads which take the
> same code path.
>=20
> Neither is there an answer what happens in case of a signal delivered to
> this thread and what any other GDB/ptraced induced poking might cause.
>=20
> This is a half setup user space thread which is assumed to behave like a
> regular kernel thread, but is this assumption actually true?
>=20
>=20

I=E2=80=99m personally concerned about FPU state. No one ever imagined when w=
riting and reviewing the FPU state code that we were going to let ptrace pok=
e the state on a kernel thread.

Now admittedly kernel_execve() magically turns kernel threads into user thre=
ads, but, again, I see no evidence that anyone has thought through all the i=
mplications of letting ptrace go to town before doing so.

(Is the io_uring thread a kthread style kernel thread?  kthread does horribl=
e, horrible things with the thread stack.)=
