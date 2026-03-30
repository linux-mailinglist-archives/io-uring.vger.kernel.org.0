Return-Path: <io-uring+bounces-12889-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKlRHV+nymmx+gUAu9opvQ
	(envelope-from <io-uring+bounces-12889-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 18:39:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 76DDD35EED8
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 18:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 92FA2300F798
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 16:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814A1385520;
	Mon, 30 Mar 2026 16:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XuClYAyk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F227F22156C
	for <io-uring@vger.kernel.org>; Mon, 30 Mar 2026 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774888592; cv=pass; b=QopeDs3V5/refXHatIqh346Al62D+5JZUIICULI/mhcihsGZ5A0RBuWk7PPtrsVZmBm6ve+dGQ8RmzWHHyagW5+d5QQVb1vqc7oxRBWBiMxPXzLtpLF8aiUsD6Y+YfDYaAF6HHrJ6l/L9z6dVPzO4gKLIbDANJcOacxBnc52tDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774888592; c=relaxed/simple;
	bh=lRpmBzbJ2y3v5I1vQVYUfVMZX2Rhzu2Tqeud3CF/U1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5JXHrDRF7Vn+evhB+4tPGh9ku6yRdsj6O9fGkupevQ9ExZ0cJCcbuXrDUeSsWy9KEXJynOhXzS8xb0CdouKNs+AFItAIP4s7RbvtUQ4SAV+GtQ4mgWzpvWHxGQW/ZeryeNd9gUxy0XRPwF++nq1XL9luKVnLYGR6jHSwDoopYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XuClYAyk; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d04fc3bf2so496484f8f.3
        for <io-uring@vger.kernel.org>; Mon, 30 Mar 2026 09:36:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774888589; cv=none;
        d=google.com; s=arc-20240605;
        b=Ot6nQ/OYsV0LlRxpv+RcABaqIRY0hq3qoETqHz1RffwNXdMxUGKcG3nGvVQOzEiNqI
         5hjWMYlD/ppwpJ1VVBxCwOWYL6ucM7USKyQFO/0LHJyFlcV2au3nn+gh99zq6ekLSLxQ
         mFkSQWIJq35UxEAKNkBv+b3ygOaK6bsPaw7OWQmVkG4k8KYKJ9tJQ4Ab1kHNvbL43gFL
         xFbwXUpBWmod1qWcBKpD487D+nABojPkW2tf0BQ88hoRoMSPW7pm3Q3aJnZiZ6ygiCOM
         YRlLAGdqQaZEruXzJFKkMboIXzPqqnbrcZ9Tlt6C+O0JnhC5EipXuU+txm3RmqH57MCm
         OqBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VKLr+L2TmUFppPid5N5ASUyuTHqufpEapHu+AszqT34=;
        fh=JXR/kStZc194Ev7V446rqsX5a+IhQVpwu5/22e2wX08=;
        b=DZq2fmZxsT6oSXpj/VkfYBQAiJM0US1eXU5jd4sm1vp1akODt/fHBuaQXyzTOR3hjp
         PwrCzxr78LtG1K+KH9xWReZ0ncABUHcleWm/GDvjUCruaubWfjS7qXpKfmOeeLXVaecO
         EPwk6YvRxiN7QyefPsb0WBMAZzSues9Ywn/vr6/emWiRhX5Epxqo1GUEH288IzK+KvDB
         9RAwPF69cZ+P6HviYxHEpXOE0hfjGHCtPsUEBG3+if2K80p8XjMCd36hSRijtpRdr075
         pK/k6521Rb5snToNoi432sVa4jtb0jTotwwvt9Vt2mPHqUHz+HJHm5IAHXInmXxJYkJv
         MVfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774888589; x=1775493389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKLr+L2TmUFppPid5N5ASUyuTHqufpEapHu+AszqT34=;
        b=XuClYAykKsdrzS7J7FbyL8QaamVpgb/rLcwenXfGPzqpA7PdGjj/z5JkKkoiYrxePh
         JmoolBuwTpVWJGgaF1uql8ZIRXbW7BTeCSNXSCyAfCrFwUnH5PhlIWNKHWLczwP88agB
         v7OYhfOqRomsY8E6lbt6vEPeJWqWRqglRC7b+oRFvei5TSXiKF6viphJGz/RO8Rkes7R
         IXULMbJlGa2vpf+3FosP5MFnEz57zh/+MeNJkhDOcKYUclbj6QvUwC1dhvm2gVN6+EYL
         hyBg5AS+HzhcXxuXdfqDTISFiihWR8qu/rKLLg4SmY1xQu7ZCvL/Xzhqr5DQq1g6C5+7
         vPTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774888589; x=1775493389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VKLr+L2TmUFppPid5N5ASUyuTHqufpEapHu+AszqT34=;
        b=BBIXTLfbZ8rbiNhvQ54JLZ5frG53gbOABPpQb7lO9p0Y01S0aOKr9QSCRjI5M92rkF
         y5v6uLzKbNV9nyNCcUTerJErOz8w1dsGK2eF5BYGXuRU455YLW8G3SVCXfQhKnCUtTtY
         cDV/ka7oxC+P07H/T6AxjXS2f/8Chp2hLwgHfH4GpwCJd4IFY8kKvipBwB9fxMEeeeN5
         HVEzwuwrSpNrSNW7OqM0J62xa6GuPd0O8kaMYEKG5vL04ErpPknl/u8MxJXmClmdRlAg
         1Lzy+nqp1bMnwV/1SCtwfOIBD8qRXkB11D+I7xivEubRO4IoBXTppyFpUI8GKDmX+SYJ
         aw0A==
X-Forwarded-Encrypted: i=1; AJvYcCVrHbYtUzs1DBLLaX6n+t8dUcis8Up7vI9uD2Brn9eZyEnCLoMMe3Sw4WEDvbTudwAs6BgUQlNLYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQb8ArnKWO+2kCoo0SCw1noBvSDv9dap7j1IsWYr9gT0X16C16
	QGEo7bSs4mGU53dLTA4sUpDDmi8KAOLo3/SIgMf1Ocai3KKjYiUtVKx4m2BZtJBHegi86C36c/A
	LP0ze3GziMiEsVkwAjrTDCHG+tFJky/c=
X-Gm-Gg: ATEYQzysGLmB3+hkT0Pd3+bKhr3h1J9N07RoU3vpCoQsavbsujZBW++OArqyIGOPw74
	SS2dOjQrvCZTuX9lFS4kwFPIanwfIKw6KGFc1p//xoA3JJCk151ioNFDmjeaTEueRMKee7AfdlV
	iG+LKr2VlGd/8chQu6E32wQ8XUzcqjNQQ1Cd6xKOzKR1stQE/XGPA+G7ro780GA6fCX5m+FRqOa
	d4xACpctOXbNbpwtl4fZk6Sa60hKUbYcr1hEsqux7QaUeBhI/8sjIJNg+UNAm0BiP15tzJcxh08
	Ph1zVA==
X-Received: by 2002:a05:6000:2903:b0:43c:ff58:35c7 with SMTP id
 ffacd0b85a97d-43cff583754mr7712708f8f.14.1774888589231; Mon, 30 Mar 2026
 09:36:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com> <177402515458.59192.3003058602103165983.b4-ty@kernel.dk>
In-Reply-To: <177402515458.59192.3003058602103165983.b4-ty@kernel.dk>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 30 Mar 2026 09:36:17 -0700
X-Gm-Features: AQROBzAE47q9ygVHrHM_MasNQdhzhlJXWzZn7kJw7EmcefVJHDk_T2k-X-IbTZQ
Message-ID: <CAJnrk1ZMmRpLc3uPMuD2jcb8J14gZryb7jno5vN4cNE4OXEBXw@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Jens Axboe <axboe@kernel.dk>
Cc: hch@infradead.org, asml.silence@gmail.com, bernd@bsbernd.com, 
	csander@purestorage.com, krisman@suse.de, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12889-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 76DDD35EED8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 20, 2026 at 9:45=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
>
> On Thu, 05 Mar 2026 16:32:16 -0800, Joanne Koong wrote:
> > Currently, io_uring buffer rings require the application to allocate an=
d
> > manage the backing buffers. This series introduces buffer rings where t=
he
> > kernel allocates and manages the buffers on behalf of the application. =
From
> > the uapi side, this goes through the pbuf ring interface, through the
> > IOU_PBUF_RING_KERNEL_MANAGED flag.
> >
> > There was a long discussion with Pavel on v1 [1] regarding the design. =
The
> > alternatives were to have the buffers allocated and registered through =
a
> > memory region or through the registered buffers interface and have fuse
> > implement ring buffer logic internally outside of io-uring. However, be=
cause
> > the buffers need to be contiguous for DMA and some high-performance fus=
e
> > servers may need non-fuse io-uring requests to use the buffer ring dire=
ctly,
> > v3 keeps the design.
> >
> > [...]
>
> Applied, thanks!
>
> [1/8] io_uring/kbuf: add support for kernel-managed buffer rings
>       commit: ff168843d80cd1855b646c5e8be2c6aa5bfb8adb
> [2/8] io_uring/kbuf: support kernel-managed buffer rings in buffer select=
ion
>       commit: bf4a6eb27f8135f36a5286bd5ba87bf6468c1283
> [3/8] io_uring/kbuf: add buffer ring pinning/unpinning
>       commit: b6ffe5399bc04abab4da9afb2ba092e6269d7077
> [4/8] io_uring/kbuf: return buffer id in buffer selection
>       commit: 9aa9e55e8bad1b65c9bcc2892101b06ae00c96d9
> [5/8] io_uring/kbuf: add recycling for kernel managed buffer rings
>       commit: de48bc0efc58d1ebf7e35c36dde6eb0e6b246b8c
> [6/8] io_uring/kbuf: add io_uring_is_kmbuf_ring()
>       commit: 08b57b67602a98abf4b454a363263cba9fcfc91f
> [7/8] io_uring/kbuf: export io_ring_buffer_select()
>       commit: 4706d1f235ff94f19b5c818bc0a3abd735903695
> [8/8] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
>       commit: 3515a2aedcdf459fc851df40a3712fc4a9a060f7


After reading the io_uring/net.c code and considering how it'll work
for selected kernel buffers, I don't see a non-hacky way for fuse to
take advantage of selected buffers for socket receives. I'm realizing
that it requires too much special casing to make it compatible with
fuse (eg relying on the bufring being permanently pinned, different
locking requirements for the bufring for fuse vs. traditional io-uring
paths since fuse shouldn't contend for the io_uring mutex in the
request dispatching path). Kernel-managed buffers doesn't tie in as
nicely as I'd thought with other io-uring requests either. For
IORING_OP_READ / IORING_OP_WRITE requests, the kernel buffer would
still need to be placed in a fixed buffer since the sqe unions both
buf_index and buf_group and I don't see a clean way to route both of
those fields through without making the uapi worse. One of the
principal reasons for having kernel-managed ring buffers be part of
the io-uring infrastructure was so it could be easily integrated with
other io-uring requests, but I'm realizing this doesn't hold weight. I
think Pavel was right that it'd be cleaner for io-uring if this logic
lived inside fuse instead of being part of the io-uring uapi.

Jens, could you drop this patchset from the for-7.1 tree? I'm going to
move this logic into fuse instead.

Thanks,
Joanne

>
> Best regards,
> --
> Jens Axboe
>
>
>

