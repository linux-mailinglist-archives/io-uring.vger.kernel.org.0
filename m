Return-Path: <io-uring+bounces-12596-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 5G1xJcThrmlPJwIAu9opvQ
	(envelope-from <io-uring+bounces-12596-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 16:05:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E14E823B3A9
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 16:05:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1283130131D3
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 15:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8879D3D6485;
	Mon,  9 Mar 2026 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="H2IXjsgS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60B53AE6E1
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773068564; cv=pass; b=P5Sz9m/i0bi3gbswzaU0XPDcEW+vwzWEzwr47tOFe+SIYqYPOBkAOl9cdv9ZURrIkr58+BXtib0VjW0Gvam3lj312jLAx3WD/ijYRvqA+Wepq55L8XMs/JKqeuUNgHfM4MuL8/vo04+BlgcR8fW+ifjLnE3qXBtBL8gaI75cztc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773068564; c=relaxed/simple;
	bh=eqfU6ul3moKHFv5Rt6DgTPzcTZjyCjZpdBnBV8hZ5So=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4DOChqDm2pDA9+aiSzTDY+eOe9qNAc9ebOF9RW/1r75gcfn496AF7lSwZZkUPumV/U+mqZ0LIu6nwQA8lYtQB5pPlC0UQ/0mUQuIyXfAbdNfjr4z2PRIU2peFyVjgtPP0Lk75COF+RS+YMlCMa4SE0NQIG18tvZOii8nbjGiZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=H2IXjsgS; arc=pass smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-40efb4bceb6so615918fac.2
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 08:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773068562; cv=none;
        d=google.com; s=arc-20240605;
        b=X39pu3hGX6hKuWxtj1hRW+A4uSsQG2cfgvjqYSUhNefc/H6eCN/Jzr3iP7LE6xAxgZ
         GJHuDGj2otnh3rDkA7sdPVLXmGVurAsOiP1QD7DtwakTR9mDfcxiMuFlrc5s/EHisbg9
         xyNY4tJXeNGuccCMiiVBSvwsoeifukxtw/p70Kj6simjfee8NsK64N+iiX8tusLbjlsa
         t+mtn2qoqfJwZpsv5mQLRDHkrwjxI8Qrz27Fok5vAopcqtIKvScwvtT2OhpwUBDbl+39
         1fAo9P6K2yBN/XfMVjV04XpSyI8Pj/eUuFlBonRvgmUs9ZTbc4w+5ZP/7JIMUXE6GSwi
         7ahg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NmkngJbnrPZ0QH13s7fieqKyIWpdpnQZouXymIBu37M=;
        fh=mNnhPPHdgjGRiE9n5A7uV0Ysxqoiyx/s7cH2X5Hwcz4=;
        b=Po8QoItTlIuBh0s91CwNeO6eeL+hMmAcl7obJtZXVmUStAEjyw08JpsSiCK5IT+jxd
         YcOXwHX8kB0bkzkFXg7v7aIE3vTrpdRCX3pgbLeYEazoaHe4QQ1ALedzvmzvCUW0S5B5
         lbMjmjW7p97YHY1CDWqnDe7bIR3HEmNZF+URPfwB1kYiBBSeWPvC2n1cjz2t9ZfZVP3Z
         0iigu4Jlkv5HGaSWwBDbi2bbcYLQBOusPrVe/9zVw1m2EfYsJPdRoNHY86937/icxo3k
         iypDUblTyz9bt/KXFX3nFbRSIgJqKljyVAvNuaMTrGDdA5RF+Yk/j7wNZ+bhPtJkIcvu
         Hb0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773068562; x=1773673362; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmkngJbnrPZ0QH13s7fieqKyIWpdpnQZouXymIBu37M=;
        b=H2IXjsgSanMBd+1aiZY6Xoph0fhDVHKw1qoU8Wtsa4iZOIowOi+WUQRMhId756vPXM
         9UZofN6WUs/I+F3ZiPNqbXNAzz/MylVDCvtTuVt0aFJSBW+HGhmlDRNmO2jZUdReoJFC
         dwQ1OY4Mov+GV9Qur4xkdMECT5TbKaFIxCl1nqgCuud1FCHhHG1e7sFXGZrBJP9sCFnN
         dK9XhUQORpE+dXECS2ACBoqYFyNL30UPyP9gSBVthvuYdU29ipKYGN60+xiU5yPnr3bx
         gDxEXiOh7yKM+91Gzjcx2/LTmybRyFjYf2ujo1H39o9K5pQAZ4bwCjXChfu2MaTiJIbG
         DNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773068562; x=1773673362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NmkngJbnrPZ0QH13s7fieqKyIWpdpnQZouXymIBu37M=;
        b=UKXYJ6zZXh5GhN3ELl5tBXdRaPgx+38sVggA4rSzhzgwFxkeIrZArRbN7LDBD+iPVk
         3CIQ/armTaFZC/cQxWbxjvkMjJGUsQj3+L2JRfVWj0VnedyKWWQDAWqcSMS2cWmhAmgv
         UVXd9BB2YjjRlWaBUlVTrLc2kfID0LfHW8uQcFdaX8owqx/4AqXlHAMW+4Yk+N+P4SUi
         C57NH3EbrMudZ+wNa3N9ZnabQyhG4LLgl4eoyQ4/q0XLEUYdX5FJZvEiL/WchGeHtRJC
         BPB5XQcBGVaIjCA1EZLypMZGDB0iyOTYzw6gEOdnKRAqQS3lBSn3nbKvn1V8Rrjl4jYt
         kVnw==
X-Gm-Message-State: AOJu0YwkrT6Wm6zixTfuNmHmisG7l3JAEnn71hdJCLTqDNfhWiZiJyHA
	PkbeQIpHPIx1Qoag8hZRhHl15YoTq8fUzOFb4z8eIDXDGDn4Kgpyg3czCAjKU0n2X4QYli2VWuk
	qbIiKGSdrU0CHMMtG0aKOzuKo6bhRBWQqFRzsioOduA==
X-Gm-Gg: ATEYQzwJKojMKnW4UgMT5gfSnT2VtBFd518oq28bz5FJMDGvmkqlborY3bxNP5h14Z/
	AjpIa5XkDBVJVpOV3uXoSzMi/t0aeVKgxrImokryzDkF3OLpnsOYR8mIfS3Whj5vVqj8rMSPOfw
	j4Xh+kdX+GEhhq65/nvqdD/U6LmM/9U53DbLiGvjafDxqVJlaU8KvWn0Kt6Ni5WkMWaYVWbwyAP
	XsYli7yQlJYNwA4IuC8kUXopSBSV3phiTCpD8Yl1DYx7IfJHfH9OxJ3WXdUlmxQni34WL7Qan71
	F/a6uxs=
X-Received: by 2002:a05:6870:d6a3:b0:417:43d7:bb8a with SMTP id
 586e51a60fabf-41743e71e1amr1002002fac.4.1773068560198; Mon, 09 Mar 2026
 08:02:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772109579.git.asml.silence@gmail.com> <d8c8748a-4b13-4097-bdeb-495e6410a0df@gmail.com>
In-Reply-To: <d8c8748a-4b13-4097-bdeb-495e6410a0df@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 9 Mar 2026 08:02:28 -0700
X-Gm-Features: AaiRm52-inccUBaxMPpcEWgeJN28TwhjPTVhGI2-_ae4ZFa1Q4Gj4m52EswA1NQ
Message-ID: <CADUfDZoBTwnCo-f_st9-jdgNhHLWUCjZQFpGdowGUA5BoJ836w@mail.gmail.com>
Subject: Re: [PATCH v10 0/4] BPF controlled io_uring
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, bpf@vger.kernel.org, axboe@kernel.dk, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E14E823B3A9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12596-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_DNSFAIL(0.00)[purestorage.com : server fail];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	NEURAL_HAM(-0.00)[-0.982];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 9, 2026 at 6:24=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 2/26/26 12:48, Pavel Begunkov wrote:
> > Introduces a way to override the standard io_uring_enter syscall
> > execution with an extendible event loop, which can be controlled
> > by BPF via new io_uring struct_ops or from within the kernel.
> >
> > There are multiple use cases I want to cover with this:
> >
> > - Syscall avoidance. Instead of returning to the userspace for
> >    CQE processing, a part of the logic can be moved into BPF to
> >    avoid excessive number of syscalls.
> >
> > - Access to in-kernel io_uring resources. For example, there are
> >    registered buffers that can't be directly accessed by the userspace,
> >    however we can give BPF the ability to peek at them. It can be used
> >    to take a look at in-buffer app level headers to decide what to do
> >    with data next and issuing IO using it.
> >
> > - Smarter request ordering and linking. Request links are pretty
> >    limited and inflexible as they can't pass information from one
> >    request to another. With BPF we can peek at CQEs and memory and
> >    compile a subsequent request.
> >
> > - Feature semi-deprecation. It can be used to simplify handling
> >    of deprecated features by moving it into the callback out core
> >    io_uring. For example, it should be trivial to simulate
> >    IOSQE_IO_DRAIN. Another target could be request linking logic.
> >
> > - It can serve as a base for custom algorithms and fine tuning.
> >    Often, it'd be impractical to introduce a generic feature because
> >    it's either niche or requires a lot of configuration. For example,
> >    there is support min-wait, however BPF can help to further fine tune
> >    it by doing it in multiple steps with different number of CQEs /
> >    timeouts. Another feature people were asking about is allowing
> >    to over queue SQEs but make the kernel to maintain a given QD.
> >
> > - Smarter polling. Napi polling is performed only once per syscall
> >    and then it switches to waiting. We can do smarter and intermix
> >    polling with waiting using the hook.
>
> Any comments for the patch set?

I'm not opposed to this feature, but I agree with Ming that it seems
largely orthogonal to his patchset allowing BPF programs to access
io_uring registered buffers[1]. This patchset doesn't provide any
kfuncs for interacting with registered buffers, so we would still need
something like the kfuncs implemented by Ming's patchset to allow BPF
programs to access registered buffers directly. Although either the
->loop_step() or ->prep()/->issue() interface could allow userspace to
run a BPF program in the context of the io_uring, I wouldn't be keen
on reimplementing the entire io_uring_enter() loop logic just to
intercept a few requests to run BPF programs. The ->prep()/->issue()
abstraction seems more straightforward to me, though I understand that
it's not as general as the ability to modify the behavior of the
entire io_uring_enter() syscall.

Best,
Caleb

[1]: https://lore.kernel.org/io-uring/20260106101126.4064990-1-ming.lei@red=
hat.com/T/#u

