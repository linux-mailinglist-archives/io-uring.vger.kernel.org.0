Return-Path: <io-uring+bounces-13250-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SF1aN25q+2miawMAu9opvQ
	(envelope-from <io-uring+bounces-13250-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 18:21:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DD19E4DE05C
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 18:21:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8F6033042C3B
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2026 16:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798AC4A2E1F;
	Wed,  6 May 2026 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Fx5q4hJt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC064ADD8C
	for <io-uring@vger.kernel.org>; Wed,  6 May 2026 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778084116; cv=pass; b=l25dpB7yhMS6xdeowtR8GknNEa0qV6zPgMv+0G885D9g7FCEQTnx2rSGvBzlFblbIHZ4jERlzJQ4zOb7rerTG7w+M+ktXN4Y3xnGd+2GU20IVt0ZLmKvLEv0KkH5W70sHig19oCWDTiS5HCXSdJd3+m0sKkiutfnL7vEY6Z1KL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778084116; c=relaxed/simple;
	bh=LvNxCpbDcj5zgWExdnWCmqTa1h3URpxZmhuK0Pce3EI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W77hW6QjR/P1eB1D38nbgRlr684RjNFsO1FgQYJpJEjEew+MdqFPl3Jlxv2/FvNHRqPn26abSDxba/855/09j+H7S0d7xlPK3CYZGPjyNnQ0X9oogWIu6DLPvF11cqOlG0/Xl3HUWudMqHxqVTRnVX/Q6Xi2dMoA55FtmC5IAkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Fx5q4hJt; arc=pass smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6948c21f72eso298488eaf.0
        for <io-uring@vger.kernel.org>; Wed, 06 May 2026 09:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778084109; cv=none;
        d=google.com; s=arc-20240605;
        b=PK5/GjWTqrtRGsY+yigHFVc/lv12VZs20u7tYqIKrTw/70VALajtIQDodB3Khg5AZ9
         9jfd5BW0xVrtv9whd9/DmeJM95cqLuLL+KMvpbhZMHmrCMcg7wJpHhkXqlsaTqy137ST
         ANaypCfvz6JUxB5tH628oJrZDzI2u/2TIrUd3PTwP5MBrNLKG+jjMwZd7aQ4f4o2HnCn
         /vqbaZs0IhSi3ozMmqXoy6uLmBzVXcuB0MhwNyd0PBtwBJiatsQuraQgOKvTtuacTbbF
         cP4Cjqwev/eZER6pJVu0qEMdagBxT4Gue+LS2K0cz9GL7imegESk/BRqXxC6YF928uJl
         VYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gepww4qXKMve+cI9eclE6iAPCQj7SGDe7YX09KIyVfY=;
        fh=THtEAWxJDgPQ25tM6yiGCOtDvkVXCTcLQyE4VGd9v7k=;
        b=Y8qzTnQwZgxowxi9O4ESr5cky1ktxCeoocFZH+l/LJkmAy4yT7hm/PKq5iPIpFrZfc
         adzUDmRXLH9w/kONY+CFr87Ei/Otv7QBn76JCoQhz+DCE6V7cMVZsxVd1H2C3jfTuE7V
         4SO4CVuijWJ7ASlkP8F10qJ+0XbbIfcFLl73C39x/akAbdq2EBRWleOG7irk/9fIR7bR
         mzTYPZlR+gCk8DM6yrsb9i/V4bBxdUTG3FNQa252GthmIABlJRaOIV9fRpjB12y17CjN
         uHX/LEO9uwcVVqmMahaTA2tgjlG7DhNpa4l2A0zQKG403udjueNyaOLfu4Tq4xoZ3apb
         hWTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1778084109; x=1778688909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gepww4qXKMve+cI9eclE6iAPCQj7SGDe7YX09KIyVfY=;
        b=Fx5q4hJtZikQ7ZCr1/PR41aMsspyLsdFgBc1g8N1whNWBloiW9SIb0e86KF/Q+PUfp
         6XyIOywGWuSkb+LQii9IvBZmGLMSMOYZutQnuqDUmzDcWsPS4I12myig3ny6GTmUDmaR
         NhTl8iFNrD0mo6gGoUceQ7CZ7LsoQBwtVBKJfud3a5yW4aEULza4Zfmr1SK2M7KUsldH
         dGLk0CXJWuTsAOXCw1Oxf/pDyumYj6ECslrm6+igXq2801mXImPL5qjHTilQhILGf6xw
         TGVheRbb14swxLf6VmAvtHoOkR0H0ZBglsDbMGAGOatvltBfIanYs4YYfao29cnXJMOO
         REAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778084109; x=1778688909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gepww4qXKMve+cI9eclE6iAPCQj7SGDe7YX09KIyVfY=;
        b=S+EN38OKdotPOG4anPdAYZzFYqzr49aZr/5rKN/eO5qLR4ftxGYBNXx0ON7DaWiMjF
         0QLtvdCFo6RPeE9ph8+XjtUf90c1cdlkrfRZXbsXoFBDG6v6GZAI8Xc+ZFaV58Un4pk+
         JzVnNtXVHYiWRa40Rnzgt2wJJX+dT/3HHAIkmbfgF+G8yc4SUVio8ewgB2R0/qlBkpEK
         y58jjI+6kXb1N2H0AXwEZBPLAGzcnOVgDVmGy90lY7cTLsXbtsWnu73k4bVsPabjfM2e
         4TxghKYMKfaRI0sRZSWm6c2vK9PlYj/EWtohF/IKqVxmtpU41m3TtCnF4d/1JLzmP3+3
         +WkQ==
X-Gm-Message-State: AOJu0YyTCSnFwchUMBsc5GZgqEr5VpZ8wqzmV4PqEfFYc0HpgHop3OrS
	26hZRWRc2NsxjUZbqepE27xSBU/9nUjN8iogRDzNOYOoUhuDSaJ1H1D+6GXplJJje+JvGYqGtp/
	6H00DSK5s+T65/8GJdmS6jly6WCQwSGXyP5VgO2/frA==
X-Gm-Gg: AeBDievZji313w6buvk9zcm7iDTwnHJXBH5sgbHGSZNJzbFM+1NOuzbvKglW7m01Fqy
	p11qCsrfPGJ5dn07RiG2vW+u8rSMinK8LUs+ZB4uj7RUsrIFBuW0Hee9xOITA+MgCZlQ6w3uUPk
	y1YUfsHhmqQMGhcGGKLebrzCvEBogqbkxLcbFH4weBkv1ohgg3+4Y7mOiLGLeAw+utanT7AQBzI
	fyU4tp/XmdQFrEMTzaN4ftyC7nSlO+5YIcG0+iGvF6RR0BoEcVVMpsVnDKCc6D3nY1WbR+/1Nsb
	sWs48Jj4Dex/q5vVo9M=
X-Received: by 2002:a05:6808:e8c:b0:479:db94:ff05 with SMTP id
 5614622812f47-48045136decmr1203350b6e.3.1778084109487; Wed, 06 May 2026
 09:15:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2469b617-3b4d-442f-84a9-7d1136d84065@kernel.dk>
In-Reply-To: <2469b617-3b4d-442f-84a9-7d1136d84065@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 6 May 2026 09:14:57 -0700
X-Gm-Features: AVHnY4JJQlekyfhXPkfCvFLzVsvJ8q5n-maIQ3sBvLTdg3v2l_7fR868BaZwSsU
Message-ID: <CADUfDZpZJMdFywHApMO3h+bn3S-SCDvEAHJ2e9yGD0r=2kJ_FA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: skip inline completion cleanup if unlocked
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DD19E4DE05C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWO(0.00)[2];
	TAGGED_FROM(0.00)[bounces-13250-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:email]

On Wed, May 6, 2026 at 4:04=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> If the call path to __io_uring_cmd_done() is not locked, then we
> cannot recycle the uring_cmd to our allocation cache. Check for
> that and skip it, and let the normal locked completion flushing
> do the cleanup.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> This effectively defeats proper cache recyling for uring_cmd opcodes,
> with the fix it's working fine again.
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 42be1be5b132..35e2aa8b9446 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -166,7 +166,9 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd,=
 s32 ret, u64 res2,
>                         req->cqe.flags |=3D IORING_CQE_F_32;
>                 io_req_set_cqe32_extra(req, res2, 0);
>         }
> -       io_req_uring_cleanup(req, issue_flags);
> +       /* defer cleanup if not locked, otherwise cache recyling is skipp=
ed */

"recycling"?

> +       if (!(issue_flags & IO_URING_F_UNLOCKED))
> +               io_req_uring_cleanup(req, issue_flags);

Doesn't io_req_uring_cleanup() already check this?

Best,
Caleb

>         if (req->flags & REQ_F_IOPOLL) {
>                 /* order with io_iopoll_req_issued() checking ->iopoll_co=
mplete */
>                 smp_store_release(&req->iopoll_completed, 1);
> @@ -211,6 +213,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
>         ac =3D io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
>         if (!ac)
>                 return -ENOMEM;
> +       req->flags |=3D REQ_F_NEED_CLEANUP;
>         ioucmd->sqe =3D sqe;
>         return 0;
>  }
>
> --
> Jens Axboe
>
>

