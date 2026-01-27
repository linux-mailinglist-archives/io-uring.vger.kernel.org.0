Return-Path: <io-uring+bounces-11929-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGPRNfsheGk/oQEAu9opvQ
	(envelope-from <io-uring+bounces-11929-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 03:24:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 302E68F01E
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 03:24:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB04B300DE3A
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 02:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B6D1D5CFB;
	Tue, 27 Jan 2026 02:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFdVMwri"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4933398A
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 02:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769480697; cv=pass; b=lVISGSGWhLTTuhBOqG4jbPBFyDMyDQpAiaoalJv+m6NBcrwkMvLWLdMBPgYp0ihzQ9oKVO3wCnWUjvkszJCoZhLrBmM4yAPv57JBzXDp+a9KYnMePBFOhNO7hscZqtLD5lTBQkJRVcQeMttucLspVXMcvGG0I8gnlowLx5Qc3Yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769480697; c=relaxed/simple;
	bh=9g7vZuBScqSdVtyblI97+PJBk2t8Vq5yyGlXwSurl3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d6s912fDyf18REApWH7dd7hbapCvBsowLxOJqp+CbZiA7Qs/cxOvVxWivxR0KM/pD4qt9VjFd9prkvWwyaAFCnGa8iyi0jjjb0gxV5Tv8f5Ejbk7DM8z/mxJgNFp0MLegldzazt1klGSF/b0efghNO7DxUIBZE36Y7dsZMnIr24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFdVMwri; arc=pass smtp.client-ip=209.85.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-650854d9853so762570a12.0
        for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 18:24:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769480694; cv=none;
        d=google.com; s=arc-20240605;
        b=dtvz8Ijsrlkr0BDYPLp4vy3YWX0CtbO1diosJgFWqdLw4/UjfgEKBnU05OolgkNMuR
         f6J5DJJrir7/Z67EG0eQj+PlSmVTA62qn7fJkLJG8e6YnO2rMH9R6avv4KvplrKJ7Q5P
         C3F+rbMGltYCAfc3ALPImn7U0GvjVZTDS3LHm97mxrz6aG92ZAPD3O3rU5ueVIFTBGBc
         0rDB4Bd3kAHd1zMiMvRv7zpoF4jT2Cp050jkunOlPpMcsYkz+grk3FuGU+nEA+KEu8AV
         bmHtXRHpBGClvZ941NSEyCYfnn5QNIEWmNThwUT1UAnHB6SY4UfbnJQhbZEBHhzSNwdu
         4Sbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9g7vZuBScqSdVtyblI97+PJBk2t8Vq5yyGlXwSurl3k=;
        fh=UjUPYjCyuUY2Mb2LfpQI9V6TSxwVKRTjKeLIVK2k6xw=;
        b=doR5YXYJssO42InOE90jHSYtMg1AB+qFuMGVRgEhXWdkOU+3p1qMeUZfqw6SmihTSF
         ot23XRhvK79Hut5JdX25crm3g2LVYe5bwvYMwGSVtGgvo+HVJCj7J1rT0IuSq2IJ47a/
         3cV0UuF9ePTlqKINypR+ndRmY+fhDmJtn/nJU+q/zys3FXH0z/TXqAC2eoq9Ykj0oaCZ
         EfNsNewImBmQWdW1JsGZe18BUYV4WO9jIuwTB7UDl6FvEqlPLz8ZcfVot4/bNkpCHdW9
         8iIt4xQQeYUg7+O6zNa+AqPkMrbppBHXwiDg9fvWX9p5Z2/JM5FtQ+kcxxbR3glxIiL1
         tmpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769480694; x=1770085494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9g7vZuBScqSdVtyblI97+PJBk2t8Vq5yyGlXwSurl3k=;
        b=gFdVMwrioXmTkET+IMsOhVeVK459r/ATedlIvML8PY9Abb+MXAw9L7WH99JCLwiMWD
         w+XAfesSgqmiAEubDzrqiQRVvau6Gv/rQvuU2QxclNWdck3E/6mItKcH0BYdCTLEpa6m
         kNafgpfPoRZklUyw54VwEgJFwEzeDKVKgYkp4W5S9dy717iuan1A3/n9u9IV2Ecu2lON
         J0v7X15SWj9Nvt+IVaLt61FJGhPRHC/u9uva28RncrxB7RyT+KPELyGWjNakt4Gibl/K
         DDWdMLBi39DJ0Hlr6U63Act2d+Pq0YadTJZiWCLhu8BSF4iUuqEY2SoyceKfpqnuwJUb
         8YaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769480694; x=1770085494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9g7vZuBScqSdVtyblI97+PJBk2t8Vq5yyGlXwSurl3k=;
        b=N0se39z6T0buaOY+qLEK1/T9vNMtLRapwsuYBQBwqZy6bSe5h4WK/vHiLkdiwKYXS/
         nXoB8AMZq8YKw8lswVoCyIfkEoL0ClcUpQTACHbqeLCLWo4NSUE5FTOfAftR4kT1w7Ts
         tDsLMjG3+Rzr1jrYN7cwpQVpIFMnVLo1AOc+0NhvyT3rchrNuhsLbHKjOD4GpFhIBD/t
         Wwz09aYIgfl/XAPYyJMQLRL4JWAMLVQxcW+bP2BAvctCjV5MDaUxRNXJIsISGoe54u9I
         4vbRxKpzDmg/IjftmRy08qmdheccZrMbxJJxH1jEL52Qj5ubflQ01YEaVcs4KQBl5DT6
         NbKw==
X-Gm-Message-State: AOJu0Yw3ZALf2NS7QGAj28cKmJfi3+4fPKz+wSl+pH9J7bX8YgsHKfTu
	6LBPE+asMRCJ4OX/8aSMSMF14UUxM5JgZ0HJ7ofk+X3AkjtOsbE2BtFeK3ieqCYPOGj7BSwGN4A
	/zd/bsTIhN6pi4Q3nwqnLN+M0Ew6NlibXriVH3jwBJ5XG
X-Gm-Gg: AZuq6aKuFpKLq3qAEgsU7/expu6vvgmMdxCFVsqPzgh/WXPvEJxEpvmj0JKYLBuRReB
	/yK22nUY2/usmuM01GVDZV0FQNzCkV8YBJnrxmgor+aG4jOmQ1CGN5+/wTH5rHBv6LBA4iwIpjZ
	ygbE7O5oTNuWBJiweNmxc7T4BmKDvE6u/duQZ5UQjvq6rL8peOEaIiVmVTp79UUZeI2TqgJIX2X
	mWdcnt2PCxkwgwBALvxDFDt2blNrzD/7exf39hmIqqxFLd8OiPkpM1WLO4/VjYAxKNLfOs=
X-Received: by 2002:a05:6402:510b:b0:64d:23ac:6ca6 with SMTP id
 4fb4d7f45d1cf-658a608dea4mr79810a12.4.1769480693790; Mon, 26 Jan 2026
 18:24:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125075302.621785-1-1599101385@qq.com> <cea5285e-061b-4e5e-8c06-82461e8eeb62@kernel.dk>
 <CADPKJ-4HUKdt8jgsVWoecBc9qOZQ_4wXkSW8kas9mXVyWt9a+w@mail.gmail.com> <79ae8fdf-460d-439a-977b-6876c808bb75@kernel.dk>
In-Reply-To: <79ae8fdf-460d-439a-977b-6876c808bb75@kernel.dk>
From: clingfei <clf700383@gmail.com>
Date: Tue, 27 Jan 2026 10:24:40 +0800
X-Gm-Features: AZwV_QiUfDyLCccVQdmXLbPnGgg48BmHUOiIeFN-atuFJTDd4XzE7LW8C6DDjAM
Message-ID: <CADPKJ-42_AXtjyaEmbDdkw2D_CXRgJ5U=Z1yc505V2f0YSS0xg@mail.gmail.com>
Subject: Re: [PATCH] io_uring: gate personality per opcode to fix TOCTOU check
 in io_msg_ring_prep
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11929-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clf700383@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 302E68F01E
X-Rspamd-Action: no action

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2026=E5=B9=B41=E6=9C=8826=E6=97=A5=E5=
=91=A8=E4=B8=80 20:36=E5=86=99=E9=81=93=EF=BC=9A
>
> On 1/25/26 6:57 PM, clingfei wrote:
> > Jens Axboe <axboe@kernel.dk> ?2026?1?25??? 22:16???
> >>
> >> On 1/25/26 12:53 AM, clingfei wrote:
> >>> From: Cheng Lingfei <clf700383@gmail.com>
> >>>
> >>> Add allow_personality io_issue_def and reject personality use in
> >>> io_init_req for opcodes that do not permit it. This fixes a TOCTOU
> >>> window in the prior implementation: userspace could race-update
> >>> sqe->personality and bypass the __io_msg_ring_prep personality check.
> >>
> >> Please do detail what the bug is here, this looks like some kind of
> >> AI hallucination. The check in msg_ring prep exists just to reject
> >> commands with it set, for future expansion. The only thing that
> >> matters is the ordering and use in io_init_req(), which is fine.
> >>
> >> --
> >> Jens Axboe
> >>
> > Sorry, I forgot to reply to all in the previous email.
> >
> > The io_init_req checks sqe->personality; if personality is not zero,
> > req->creds is initialized based on personality. The msg_ring prep also =
checks
> > sqe->personality and rejects non-zero personality values. However, sqe =
is
> > shared between the kernel and userspace. This means a user can submit a
> > msg_ring SQE with a non-zero personality. After passing the check in
> > io_init_req, the user process can concurrently modify personality to
> > set it to 0,
> > thus enabling it to pass the check in msg_ring prep and invalidating
> > its rejection
> > of non-zero `personality` values.
>
> I'm not disputing you can't change ->personality between io_init_req()
> and __io_msg_ring_prep(), that's obviously possible. I'm saying that it
> doesn't matter one bit at all, as the check in __io_msg_ring_prep() is
> just there for future proofing. If the application knowingly changes the
> SQE post submit to defeat an -EINVAL return, then yes it'll defeat the
> future proofing. But so what? If you look at other prep handlers, the
> -EINVAL checks never made any attempts at protecting against this
> scenario, as it's only there for future proofing.
>
> IOW, you could just remove this check in __io_msg_ring_prep() and it'd
> be fine. Or just leave it alone, because it really doesn't serve a
> purpose.
>
Thanks for your patient reply.

I agree that this does not matter since it cannot be leveraged for
further exploitation.
Initially, I read the Linux 6.6 version of the code, which can only
affect fpl->user
in __io_scm_file_account when the cred is substituted with another process'=
s.
However, I found that this portion has been removed in the latest
kernel version...

By the way, I did read other prep handlers=E2=80=99 code, but almost none i=
ncluded
a similar double-check that could be bypassed in the same manner, which is
why I find this a bit strange.

> > This is not an AI hallucination, and it can be demonstrated by a
> > userspace PoC.
>
> It does read like one, however... Including this reply.
>
> --
> Jens Axboe

