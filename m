Return-Path: <io-uring+bounces-13875-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0+OMEjarRmo9bQsAu9opvQ
	(envelope-from <io-uring+bounces-13875-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 20:17:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D486FBE96
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 20:17:25 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=Aqs+Q9d6;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13875-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13875-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC58730EBF3B
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2026 17:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD1B23EAAD;
	Thu,  2 Jul 2026 17:19:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1CF348C4C
	for <io-uring@vger.kernel.org>; Thu,  2 Jul 2026 17:19:38 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783012781; cv=pass; b=cMPZ8GtJs9n/GFKxmgn3VyhwDOftLCP6ZYNlygF4zYNdxpaBALDj+uKtnNsxU1ylPHMjKhpbm82wi4+9cn9Z1I38Op8Injps5F6OcpEmv9S2oOVJ2lphvnepnhDCgXs5wwuhd9hTEh/EtDRnauyFY/W5qd2HqtsPzKq6ae8dqIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783012781; c=relaxed/simple;
	bh=p4g/gqPWqDIuh0yUy+JMeQdYbjF/OHB6ZhDO/qQpaqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L/kC0WnmrJiiC4vv97IJ99WAoGa9Be65R8t7ti4YJ6WAPDhwfJhblfdjRRumJp7D6YVv3/ZYLFSGAIAS8x75iatjTxxPiKEmxCmvSR8Jnqkhnx4AgpSYS/llvL0a38CxhvY6wtEAEwFVMVnYwP2yhuKx/Uo9PJPAYj91K/rTXgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Aqs+Q9d6; arc=pass smtp.client-ip=209.85.210.43
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e9e15491a5so272796a34.0
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2026 10:19:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783012777; cv=none;
        d=google.com; s=arc-20260327;
        b=pORi1S1jxSqF1oAwTrEbCS2r6gQvSDELgJuUpB/Q/1TBkQq/dC/R1wv22MkDZKW+vD
         eHJJvmwZ07T71lAGmEZSnqf6F1wj2mAPPUN/XY0yUsH5m1ZZbg6feLbRFfLLLVWD+HVZ
         ctfAW5vGdOldNGe4SdqQqZAEaMqHjGGV/XNXDEpWw4dfhLwKXHY/zl/M1jMa6j3wXN6G
         U1eCuTph5pAFv3eZ63Odza17mhnMrfSynLZAB5O/cNspemZ17REMqUAqcWlCSA5DHqXI
         0iP636U7hyCpDse1Ya1S6OjCaUsZConldYpeCqMf65CiBh11ZZY0L9UwMJB2NBXVchJw
         ehqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vBZXCXIfp05oiGflqHRAW8T5MU2dNOq4FBN9pWokm6Q=;
        fh=zE7gOFfAEbrGeipg6rhS1C3OjT6oLzG4LpcMDbN78ZA=;
        b=ibJhACLIQI4FP7HXiQSu4nGlanBzb0eD8FaLTRPFJu27mDFJ+6OXaec/FyEVOxHE7w
         ko4hIX67oQdj6Y/Tv0DEVuTZ7f6CHU5R+yvGjmaXwbn47V5udTwUh5JgCNxUwBxHXe2X
         n6CCWVSXi/rRMKOAoEID2hxdw1hK87FY/H56iI6YBlL6KkVl43s4/F3nzKlPAGGABD/z
         M5CX1ynDVL1zDDBGn4Jj7/VOOSIkDXXBfq+N4TG86k9xIQUi98gH5Do5G4yaKVDsiNK2
         thHqusnQxKxaOh5daHnykj/qs13D1ALsnm0bH0i9wsvIWTBilZ6kkO+PsSaejvMawnEL
         ZIYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1783012777; x=1783617577; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vBZXCXIfp05oiGflqHRAW8T5MU2dNOq4FBN9pWokm6Q=;
        b=Aqs+Q9d6ctAFND1NqCdw3pxwdbkhU/+xAeptvO1mvNYjOG1DZCeBzdfqWRnm1mG1A3
         lhlH8D1TXP8Qjyenc6WtB3hmS6eo8kNSQxtN62xcJJHvLpD17kebVariOAI/Fjp0muVR
         35LIY9CtsPY2H6dK4Vf0UmwxHM/EUTirKFKWQGmlZWpxX7BzFScughOwVNT3HphNDN2A
         liyWqsF1yYBqKiScE9Mc/bVwv2P4iOSpUjoUiOGskqmz7G2bHKCU8rFtFxjJe9no2YOQ
         J5I/EFRrYbLFN2j1YS7eqMDQERPnMXrr0WWW1IfqxHtaNWmwjO4ceji0gtVRxNFomD5F
         aB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783012777; x=1783617577;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vBZXCXIfp05oiGflqHRAW8T5MU2dNOq4FBN9pWokm6Q=;
        b=qkq66U1KAd4vacI0zrevOSk4vXBnJvl8C+2M6hXGOHjvYOB0SaGXhJKaOukKqDJYto
         69jqlPM4g95UUvlimr73ZIBa1c8WxGpJ6Rsj+80IV8chc+yf9BNeZ7QX9nqZ0KUVLksN
         99sbxGce/fUtvEqiw6VSCGFxHTN5FqwSu3zkZVm4DjbALdr3qSTnDC0UCMykkt3Yp9rr
         NzUeteIOru8GcPnwOSOzMRoxtI8hIRu7eOGCVZpf+hnDiXgFcivQHa8YKYh5OVGs+fwj
         FuZGJZ06FlkV7hP6M3SgLt8+YQJ9DxEug/iLimyQ8Q9s+eEB3cXiJGLq8RjPNIJUcFgK
         BiAw==
X-Forwarded-Encrypted: i=1; AFNElJ83EXI75UZojKPT+JM4RoxKOhiybVN7LSRFWZd7PPdecO6mT/uLd1U8rl0XpFxBMV5nHIjYnF6Vkw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywkpe8piCesuFh8rbqR6qkRQpRW8loslaqioltP7t7T09eKClPt
	AOA9f/UEJjFJnS0ifNWRunStQqO5bQRZ7pG6SLUe1tJJCrqyL99X3LIPqGkDLiQjtBl04kt3OmA
	qLW8+j9vmHydisQ6Jfxa6hNL8kL5sxlrTy8yRgGFh1pnbJU+UZR+Xa7k52A==
X-Gm-Gg: AfdE7cltQq4S3nfWESsZRNlpaPr1IPnv3woeIOKy50tkhhPOgz5yb7GuAanfIwhJp9g
	xHkLpcQVAVk87Dpk4w78hDAMai2G22FbpFs0Uc/22+tN6FdWlE2Au6nU0faWY0POqDKA4aUsVY+
	rM3vQP9JPVEGdljm1jCGjcI0CKFlYrHGgEW0jwdJ+fhYawsOKrw58GKPGvskJKZZ47ouBDPhz/s
	GKAptR/3A/19SjVIjmT1ItXp4UhY7sYbNTxsIzOrxg19PviLokzGP1nPQXWvWblZZqC2TUy4w==
X-Received: by 2002:a05:6830:651b:b0:7e9:b772:9ab2 with SMTP id
 46e09a7af769-7eb4ccfdc83mr3090950a34.7.1783012777022; Thu, 02 Jul 2026
 10:19:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702082937.3707134-1-yangxiuwei@kylinos.cn> <20260702082937.3707134-3-yangxiuwei@kylinos.cn>
In-Reply-To: <20260702082937.3707134-3-yangxiuwei@kylinos.cn>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 2 Jul 2026 10:19:26 -0700
X-Gm-Features: AVVi8CdHXp1mBWnQWzW8LYLMiNMGHktMX5CMdnrI5nf7WvOGB5mhPZ_EFG7FTNo
Message-ID: <CADUfDZr7=imsLLNT7+2hAWTj2hTT6snNQA5swhG1tyJgqiVc7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring/uring_cmd: fix uring_cmd.c comments
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13875-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:yangxiuwei@kylinos.cn,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,vger.kernel.org:from_smtp,kylinos.cn:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 84D486FBE96

On Thu, Jul 2, 2026 at 1:43=E2=80=AFAM Yang Xiuwei <yangxiuwei@kylinos.cn> =
wrote:
>
> Fix "concelable" -> "cancelable" in the comment above
> io_uring_cmd_mark_cancelable(), and fix the memory ordering comment
> in __io_uring_cmd_done() to reference io_do_iopoll() and
> ->iopoll_completed.
>
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> ---
>  io_uring/uring_cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index fe32311b2e51..8313600583b5 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -90,7 +90,7 @@ static void io_uring_cmd_del_cancelable(struct io_uring=
_cmd *cmd,
>  }
>
>  /*
> - * Mark this command as concelable, then io_uring_try_cancel_uring_cmd()
> + * Mark this command as cancelable, then io_uring_try_cancel_uring_cmd()
>   * will try to cancel this issued command by sending ->uring_cmd() with
>   * issue_flags of IO_URING_F_CANCEL.
>   *
> @@ -168,7 +168,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd,=
 s32 ret, u64 res2,
>         }
>         io_req_uring_cleanup(req, issue_flags);
>         if (req->flags & REQ_F_IOPOLL) {
> -               /* order with io_iopoll_req_issued() checking ->iopoll_co=
mplete */
> +               /* order with io_do_iopoll() checking ->iopoll_completed =
*/

Looks like the comment in io_complete_rw_iopoll() also refers to a
(different) incorrect function

Best,
Caleb

>                 smp_store_release(&req->iopoll_completed, 1);
>         } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>                 if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
> --
> 2.25.1
>
>

