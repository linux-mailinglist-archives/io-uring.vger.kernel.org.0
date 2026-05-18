Return-Path: <io-uring+bounces-13403-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +GAeOBgpC2pAEAUAu9opvQ
	(envelope-from <io-uring+bounces-13403-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 16:58:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8A856F608
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 16:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8738030C3495
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C2940DFA3;
	Mon, 18 May 2026 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="aMQeUUz6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE563F6C41
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 14:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115384; cv=pass; b=R0hCg4LQakGr9So2aa1SSaaLRecLgFAFMJ55mnPNRwIqJxSQT4LJ/5Dck2YCL5MqWpo0ErDevIKQihih0FxfyXeRWn0VCFEf4N1ntJbnVjzAjPB/Xj8KwlxSdHyGsxjxf4JSdSA3FH7e3EJoD9+K0hIgF757u8dz8TAqBAdasSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115384; c=relaxed/simple;
	bh=0iEBT7j0po89ZfGdtsQ5GrAt6oBZh52FTaqdiWfvozA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alQ52P2QQjCLPKDcZlRfN+fb2NiESXAiVy4dOyh0jTy7/siqHYm3GkJrkrOGqF0akGjUYnJMYdPLTNSBOp1S7K2KH2Smu4mndTuYK5kf2cthuse/2YXZ11VZe97il7Ru0IIdwxXdpqOeo+D0qsrfh1Pkrifv5XNca3EOIcZCvRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=aMQeUUz6; arc=pass smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69b834fe69dso39823eaf.1
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 07:43:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779115381; cv=none;
        d=google.com; s=arc-20240605;
        b=Nd43OGuVC7jtDWMQKqLC9fjYwK4mgatuk/f1czdfI/VcLyAm5FqVnr9E5lqjfzAPwU
         8bTqhQXrHxvTXKSDqoNJA0GZyXYzPDStEa3RkFATYUjGgTYprQA0YUKaxPUmhvhL0J4D
         t9vYgGQzn+fpu7qtguT24tRxYi7qOjfMbPfg9m24WV8oN2R4tXvlWkfsqiz1P8umzAm7
         2bLpEJUTI5kU/Iiz0DTQ2qB9T3dOI/qLaN9s2LQ/RlAs6cev5qZy8U++OU3IKJuwhETi
         1C9xTRslBIe5s4QHjLSaDBhBah6jWx8lgD6joDEMPD1g0Se4jXQxdOhHInnv+zNSRFeX
         tGfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iG9M5raGb/Oo4VO/GaVguGodq4kj2zcuPRzczr9kVDs=;
        fh=zcxpHPNzb/z0IqiFka9DaQceqq8TlQkbS1TVHsIY08s=;
        b=HpIkGzZfmJ2k0A6bN0IkabqjYU1WkORaN04K/3Sq6+n+aR8yryVUdhbWYaNxhPWlPS
         4DfNEvv8aCgedMuZDpXT3eGCX56Uyw8ujkStriGcc3MZnVl8QMRQIhI7Yog+HM1ZG1XN
         7xzqfA7sm5+e57j1i6UYcMutEMxxy28rNL7TirClQIRm0+UgEit2zElDJ+96W9pobGde
         2EBVunV9YOPw+iz3JRRnavnpHgA1ovyq8zatr3LlMUiWyldcB7ZEHHNBgdg6E4JlWD6l
         oqZ6PcTyQQ6X+n7VS1Uh30aun1Fg+Yw4d1hMLInYfd4H8z9ReuVjFk2Qv/4Bi63NEBQs
         Btkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1779115381; x=1779720181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iG9M5raGb/Oo4VO/GaVguGodq4kj2zcuPRzczr9kVDs=;
        b=aMQeUUz6oP+rzC5UbpmHaNgMfRRe/UV+V7Il529chsJZDXgyt0qEaZQV3CdA/erBso
         FHXaJIlRiECs1owqItL2f3DisO3JbCEArTaJlHUgDr39lGA3J7c+eU6F8/ywL2gxXapr
         jl4mAcvBlmXio46LrBSvOANGVZ0kk6pPk32sXtPEMUSMowtVaobKXMsHzkjdMi/MQIbK
         vEx538K8G+Cp7hQmYZ6rA40dO1rtlNgULu+K9ZLK+ET3eFNL0/2bGHTE9Ev36+YW3Vf7
         lMfKzDo0MhGmBYaAQaKYO+WXJ6YSop5A56VzNErBFDMr/iK512ZO5ytIhf9S546RqGJ7
         MacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115381; x=1779720181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iG9M5raGb/Oo4VO/GaVguGodq4kj2zcuPRzczr9kVDs=;
        b=JzOTG2A458iRuCYD8Q0pddBoQ1h4ORMCvv7Ik3ybFQ1Am5htP6MqQtoHlBWvjbVxcS
         Ggq/xCqp9WqgNT0UQTv3MogkciSQpXS6SFRUu1eE0g2ENILPfOUduwMHlnqWGP+g5a80
         rTNgzy9vi50mF4HMjjw2HM4nHBoZxrAeRSitthc9hB4MvKynH8rdXjKX28FhIyu5AWy6
         XwD7HXX9hiy0HLSmVHuuSxiWqwgztheIdndGPV9sznaWpatqa0QTozAWdMUMtesUbzWl
         UJideVstMPt32pmWTMOyzn76PSDUYg8dTvwgM/TvI8rLwf9EQseZphxm4/mvea65qkQh
         tZZw==
X-Forwarded-Encrypted: i=1; AFNElJ/jhoxYyemvVo3uVMGRJ42kluf2sHKulUDbhK+ON8IWlue3GiDSRp0u9OayrTG3+kvszBDdUyrvvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOHCzOQtPdMF7cXSuSMjIc7Gy+oU3ZgTAZEwnrsLteTSul6xAp
	TFL4mgc6QyB885f4PIBiFqtUOXn5W7bzrujm9LNO0pLtO9G2PPDu2Bk+W5cIOpFGUEEnf7tFfXt
	WEKb2t/8EmTPSDN/aGMfPcVYt40Py08nUNT1d2Eb2fA==
X-Gm-Gg: Acq92OGJQ8SawMJ/RJr1dh9H02jNiiLT37ycGZQpkuacBTE3h03KOC5dRS63SIKc4ek
	WNFTpUpIf3ceGlFsnLVkBxLVLIAwuzG7wuHFKbCMaRm9JE8FbPRV7ibmmTIp01soCKU1tNEzZLF
	apYGrURZn0sv3JBBWXyrcP2IjcGjMDLaoxQ9FVRTu4lNidbDD5JFtdvJJrEPY4AItUTZDQfkDFM
	tcFOHPPGYGgORhTv69EpY7sJzakBkrXBJgC+L054jdk+Ki1AnqTVGERgC8kQbhSTXOEgDAa379P
	dcGpHwv7lroN2nj44Vw=
X-Received: by 2002:a4a:deda:0:b0:69b:21d4:6305 with SMTP id
 006d021491bc7-69c942a6383mr3890605eaf.1.1779115380838; Mon, 18 May 2026
 07:43:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260517213010.696135-1-michael.bommarito@gmail.com>
In-Reply-To: <20260517213010.696135-1-michael.bommarito@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 18 May 2026 07:42:49 -0700
X-Gm-Features: AVHnY4J__ipJOGXkibhZ9ziFC28dm0AHalg1OSB7xnyTTLfyAozQjrb4BD3_Xmg
Message-ID: <CADUfDZqJYvQEuUdWeqxvcBPhfj+zvsezcsnpbK0N9cnBTqr2qA@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: propagate array_index_nospec opcode into req->opcode
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13403-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[purestorage.com:+];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com,kernel.org];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:dkim,mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 5C8A856F608
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, May 17, 2026 at 2:30=E2=80=AFPM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
> array_index_nospec() to io_init_req(), but applied it only to a local
> opcode variable. req->opcode is initialized from sqe->opcode before the
> bounds check and remains the raw value.
>
> Keep req->opcode as the canonical opcode in io_init_req(): reject
> out-of-range values architecturally, then write the array_index_nospec()
> result back to req->opcode before any table lookup. This keeps downstream
> users of req->opcode from observing the raw user byte on a mispredicted
> path.
>
> No functional change: array_index_nospec() is a no-op for opcodes in
> [0, IORING_OP_LAST), and out-of-range opcodes are still rejected at the
> bounds check above the assignment. Boot-tested under UML (x86_64
> defconfig) by building stock and patched kernels and running a 54-test
> subset of liburing against each; pass/fail results were identical.
>
> Fixes: 1e988c3fe126 ("io_uring: prevent opcode speculation")
>
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> ---
> v2:
> - Fold the clamped value into req->opcode and use req->opcode for
>   the io_issue_defs[] lookup, rather than keeping a second local
>   opcode variable. Suggested by Jens.
> - Keep the hardening-only framing; no functional behavior change.
>
>  io_uring/io_uring.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4ed998d60c09c..84e16c3ad3f47 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1721,10 +1721,9 @@ static int io_init_req(struct io_ring_ctx *ctx, st=
ruct io_kiocb *req,
>         const struct io_issue_def *def;
>         unsigned int sqe_flags;
>         int personality;
> -       u8 opcode;
>
>         req->ctx =3D ctx;
> -       req->opcode =3D opcode =3D READ_ONCE(sqe->opcode);
> +       req->opcode =3D READ_ONCE(sqe->opcode);

The local variable should improve performance, I'm not sure removing
it is a good idea. Due to the intervening stores, the compiler can't
tell that req->opcode is unchanged between this assignment and the
later loads, so it will have to reload it from memory. Can you just
assign to the local variable opcode here and wait to assign to
req->opcode until after updating opcode with array_index_nospec()?

Best,
Caleb

>         /* same numerical values with corresponding REQ_F_*, safe to copy=
 */
>         sqe_flags =3D READ_ONCE(sqe->flags);
>         req->flags =3D (__force io_req_flags_t) sqe_flags;
> @@ -1734,13 +1733,13 @@ static int io_init_req(struct io_ring_ctx *ctx, s=
truct io_kiocb *req,
>         req->cancel_seq_set =3D false;
>         req->async_data =3D NULL;
>
> -       if (unlikely(opcode >=3D IORING_OP_LAST)) {
> +       if (unlikely(req->opcode >=3D IORING_OP_LAST)) {
>                 req->opcode =3D 0;
>                 return io_init_fail_req(req, -EINVAL);
>         }
> -       opcode =3D array_index_nospec(opcode, IORING_OP_LAST);
> +       req->opcode =3D array_index_nospec(req->opcode, IORING_OP_LAST);
>
> -       def =3D &io_issue_defs[opcode];
> +       def =3D &io_issue_defs[req->opcode];
>         if (def->is_128 && !(ctx->flags & IORING_SETUP_SQE128)) {
>                 /*
>                  * A 128b op on a non-128b SQ requires mixed SQE support =
as
> --
> 2.53.0
>

