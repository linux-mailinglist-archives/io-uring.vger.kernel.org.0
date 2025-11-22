Return-Path: <io-uring+bounces-10730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCF4C7BFFB
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 01:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DEC1A4E04D6
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 00:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81F87081A;
	Sat, 22 Nov 2025 00:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZK+ZW7B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="C89svZla"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B287080D
	for <io-uring@vger.kernel.org>; Sat, 22 Nov 2025 00:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763770758; cv=none; b=aCROKbvsHVaaDZVwNo167zD4BPGPc3BCQMqiRr3deAhx2tI9/6CxxU+OQyBOB/doYpbZ+fCcaQ45ubypYHvCIkZbiEuDG2Wvin/h/hvYYAkZ7mvJhbXwdW9Oxaxo15otjeTuRPauvDBLZEAC9GnaumBvsDv95oROXd1LGNuRA8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763770758; c=relaxed/simple;
	bh=MOW3WvhypnHpthN8MwuNRwcmQ4c66mbeLvnQ3XJCDFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sgIfPS0AJ31NzUm2NfhtvID8/9mQb3fVa2wLr3eGWj3Iup63emWNKMkg1LdWATWogTG0feyWFXTAq1SuoGglR0ix5NA7XK6qWluBHRqrqTrzvXgBvCbk40pXFm6ZO7QrTx12fmg/+OJKv4rL8fhupbjMZB73JAVdXq4HAvojWDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZK+ZW7B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=C89svZla; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763770755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7rtpRj4BMKfOgQjvaUSy0Z7XyjSyu3zr3N4YzScRS4=;
	b=LZK+ZW7BMrIpazYZd34IHxpYweigX10Uy8fCkjwU/Zrwek4QNTlp+vSW4rzIrj5d33orsq
	8cngtpxRU05M8j35F02H8VzvdErBUetd9H5v94J+D+cHnCrlwx0NVgbGr97YsFLLwv0Umc
	UzH5bbl3PEXy/tQceyZIt7bnqYmhrHI=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-ccBoXntbMhW3QAbrHhE3YA-1; Fri, 21 Nov 2025 19:19:14 -0500
X-MC-Unique: ccBoXntbMhW3QAbrHhE3YA-1
X-Mimecast-MFC-AGG-ID: ccBoXntbMhW3QAbrHhE3YA_1763770754
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-5dfaab3a44dso5244275137.1
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 16:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763770754; x=1764375554; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7rtpRj4BMKfOgQjvaUSy0Z7XyjSyu3zr3N4YzScRS4=;
        b=C89svZlaiqNhXDyzitOKjVP1wgpRFu6MRU9uIlifFb0xBjyeOGZWw6Cu4Apb16Og/m
         9Q5rFdbv/XW9VCDeBO2Mmyk8neiU+emilAvAvXA9OX44gLViWLqbpubp5Tbcirh+Ep6g
         auLMwJc/FzNlZIG2tpUBFSLuXSJmlSQbGN+8mwUthNERzms62Eiij0j25vsF3NqAfN4J
         3Y3H5nVWINfNMCvcy4DYGxYQw1aSP03I3rk1exhkrqe+frfK3VFRIML/WFrurwfEEpXB
         x2VU8IidQS+FvsqjlJNdugoPu7N0UPU0ExIT6CP0YLrnST8cd2AuTDHAJ1L87PmPWl6z
         EUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763770754; x=1764375554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y7rtpRj4BMKfOgQjvaUSy0Z7XyjSyu3zr3N4YzScRS4=;
        b=tZfx/nmwODgs5tdX/gzbsMuvCcVH1khMqOzCvh9qRZ1/iBweeoQRbiC1lv9l/wRDI+
         dcCisVkS2BCGo0gQGgb88/K/0Sw2ah1hbjd9b1A6pj9ZbbLdaF813Z42gARgaJiss5E1
         Y/Y5aDAcIOajrHT/AcrCFwXD2WM3oOQQyvSB4WZZHNkFvu8B02IWp9BRfwIs9Rzk67h9
         iTbThTTCePOfgLURyK+RHOfv8yuOagQ1Qfn5xCJSTfdd1MLwG0shaUP09AYJGbxU7qcN
         3PrN6S4i8HU/ANrIfKqaPSSlbkOn4iJvBsO+Kg+DqWdaVTjEqeWziFFx6kaVOSRX1q1S
         K4qg==
X-Gm-Message-State: AOJu0Yw+RvbHS6hMbpYGYbhVYAD+NHEE4JndHLSv+hKkxr4TT2oQbVWD
	WHVUerqxJed5dc9mvpnsKtbSjBgC/t7xXzHpfGJKQL9vBTJcnnw59b0vZrOQi8Jr3q+9uQFXksI
	XJUYPDzU4OU3QoFTv78peh3/2kQJKGJjDXwSuzhKMlQLG3kFNHqKcfxYyBXNgPJuWrzouxAxRaI
	SNUt27wQRlzKONqAhkQX9g4ZnK3gJUpHp9VpM=
X-Gm-Gg: ASbGncvPHMAPztrNI/YAR8UedeMa0KH44sJXaCwcGD5jHCb8adCxbrNEgZqaycTlbpm
	gPtundScEqmfQyndtaT4KYWA3DvvptFDK5+eUP2UgQCSbI+cuRKZF38/xQAf76jw9kJUEg09fZX
	0Uzr823tx+gSC27koTO3UJK/SrsORRETHdmV0PxxmgOdEd89mEXAU1iEFszoakBjvqEIM=
X-Received: by 2002:a05:6102:c4f:b0:5df:b31d:d5ce with SMTP id ada2fe7eead31-5e1de3b25a1mr1630834137.28.1763770753975;
        Fri, 21 Nov 2025 16:19:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG+aoefvB37BjKVPhW2cTzTDAMFr4WytQkAu7Yd9jNRzcZtCUB7eX19TtJlZip6Bkbr+HHyU6QSEvj0fzQAeC8=
X-Received: by 2002:a05:6102:c4f:b0:5df:b31d:d5ce with SMTP id
 ada2fe7eead31-5e1de3b25a1mr1630830137.28.1763770753685; Fri, 21 Nov 2025
 16:19:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763031077.git.asml.silence@gmail.com> <6143e4393c645c539fc34dc37eeb6d682ad073b9.1763031077.git.asml.silence@gmail.com>
 <aRcp5Gi41i-g64ov@fedora> <82fe6ace-2cfe-4351-b7b4-895e9c29cced@gmail.com>
 <aR5xxLu-3Ylrl2os@fedora> <1994a586-233a-44cd-813d-b95137c037f0@gmail.com>
In-Reply-To: <1994a586-233a-44cd-813d-b95137c037f0@gmail.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Sat, 22 Nov 2025 08:19:02 +0800
X-Gm-Features: AWmQ_blClujpDv7dQhjfukVwLN0dHGKoJkNNVry2owNYnkLRuqrvkIlWp2Y8FuA
Message-ID: <CAFj5m9KfmOvSQoj0rin+2gk34OqD-Bb0qqbXowyqwj16oFAseg@mail.gmail.com>
Subject: Re: [PATCH v3 10/10] selftests/io_uring: add bpf io_uring selftests
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, 
	Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2025 at 12:12=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 11/20/25 01:41, Ming Lei wrote:
> > On Wed, Nov 19, 2025 at 07:00:41PM +0000, Pavel Begunkov wrote:
> >> On 11/14/25 13:08, Ming Lei wrote:
> >>> On Thu, Nov 13, 2025 at 11:59:47AM +0000, Pavel Begunkov wrote:
> >> ...
> >>>> +  bpf_printk("queue nop request, data %lu\n", (unsigned long)reqs_t=
o_run);
> >>>> +  sqe =3D &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
> >>>> +  sqe->user_data =3D reqs_to_run;
> >>>> +  sq_hdr->tail++;
> >>>
> >>> Looks this way turns io_uring_enter() into pthread-unsafe, does it ne=
ed to
> >>> be documented?
> >>
> >> Assuming you mean parallel io_uring_enter() calls modifying the SQ,
> >> it's not different from how it currently is. If you're sharing an
> >> io_uring, threads need to sync the use of SQ/CQ.
> >
> > Please see the example:
> >
> > thread_fn(struct io_uring *ring)
> > {
> >       while (true) {
> >               pthread_mutex_lock(sqe_mutex);
> >               sqe =3D io_uring_get_sqe(ring);
> >               io_uring_prep_op(sqe);
> >               pthread_mutex_unlock(sqe_mutex);
> >
> >               io_uring_enter(ring);
> >
> >               pthread_mutex_lock(cqe_mutex);
> >               io_uring_wait_cqe(ring, &cqe);
> >               io_uring_cqe_seen(ring, cqe);
> >               pthread_mutex_unlock(cqe_mutex);
> >       }
> > }
> >
> > `thread_fn` is supposed to work concurrently from >1 pthreads:
> >
> > 1) io_uring_enter() is claimed as pthread safe
> >
> > 2) because of userspace lock protection, there is single code path for
> > producing sqe for SQ at same time, and single code path for consuming s=
qe
> > from io_uring_enter().
> >
> > With bpf controlled io_uring patches, sqe can be produced from io_uring=
_enter(),
> > and cqe can be consumed in io_uring_enter() too, there will be race bet=
ween
> > bpf prog(producing sqe, or consuming cqe) and userspace lock-protected
> > code block.
>
> BPF is attached by the same process/user that creates io_uring. The
> guarantees are same as before, the user code (which includes BPF)
> should protect from concurrent mutations.
>
> In this example, just extend the first critical section to
> io_uring_enter(). Concurrent io_uring_enter() will be serialised
> by a mutex anyway. But let me note, that sharing rings is not
> a great pattern in either case.

If io_uring_enter() needs to be serialised, it becomes pthread-unsafe,
that is why I mentioned this should be documented, because it is one
very big difference introduced in bpf controlled ring.

Thanks,


