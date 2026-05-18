Return-Path: <io-uring+bounces-13407-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APpLMmQpC2pAEAUAu9opvQ
	(envelope-from <io-uring+bounces-13407-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 16:59:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A5156F692
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 16:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3B1DE308A8D9
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A416282F26;
	Mon, 18 May 2026 14:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MBR9MOs9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AAE27FB25
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115980; cv=pass; b=aX5mV8NJOj856c9CVOTyDIqdMOp9s4eqnZ3Lo+DawSK1Ki8HGCGTjr4n477y+wD/EYEkQu57v3iRLbz/1JSauigsrX9Lhr8AxioGNu+aXWMCJUFlYvxXN0zlxsy9nIhdTUZbdQNlQ4R/SEE/dEscdYU74jzjrgIJzE05LmShuNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115980; c=relaxed/simple;
	bh=7GwEFPjEmNAX8fbpCx5kLOgLszYtu0Nx7Dokn9mMt8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iWRU5P4cASJxspl41x8ku8xUJmLKUZq+ENPXLODp14J174stm3RbyHklf0vofqm89lyT8ehxEoIhZrTFZDAH1oJS4gT3Y6KmBTqBBURXBo0maoVFz8Bzv3vFYOOh3fGX82B3HHVd5YBqip3L47SI6msnik+2FFXzysGkiVlGhOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=MBR9MOs9; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6961c690dfcso55469eaf.0
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 07:52:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779115977; cv=none;
        d=google.com; s=arc-20240605;
        b=QqI4Ut7hw2WG7jCy/sXvKZdKZY2HvFsaCZFF+CkUa1D04YGDwSBj+AewLC0jJOJeqN
         xZUzuQTdSwwU1LMqcXkJr/beAjdNVa2LgR2AAfNdT/wcJT9E7HMIMMSGCJGGekgv37LH
         U9I7Fuqn1d/dnGoNeLJIZE9iqq6/kmX7BEG5tSxBIApePzOlqgsPCr401zHRto880N4f
         rAfZBXt47otzdjvjOVFSM0WtM7jfQwEC+OiZriVE/LuG65IArmFA0a3JmQe5zj2FCB4H
         DBqRzp2aaIzXA6RsNcbdutJNlpZ5VtELqP5luDDRcN3hw8k2mTalVZtHsx93eMh6VHBu
         bDWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=en1qHs+fEUqE4xVhbN1jKpnkaWJ0/dc4UTIL9ip1ulY=;
        fh=OCKa8R+Gxe5SHu4cRuz5VpWOnpO2zgz+fWjDUhgVjdk=;
        b=lXAEN4SSxez5PdAGa7oM3K2GWblUithn/1wx2LOjpfdFceUpFkuLiDI76ImmJv1syp
         P4nAXoObT8FnD/kdfwE8k+1qCJ1rx3XuM6pl01eSTqmSaEnRl+u0WUU+mAlzgALYljy7
         fCjHrCuqrDfoW+jD0+TIchCU/L/OuTpnfB48wdRIs0cKnqM7nNwQ1Eq3bnWc9fN8sVPn
         ehNBo6Eo/H/EyU4hg4BgjepbXxigIgshvFpOGrWYbfMoyLfOe9k8aAzoUw5ihRnM0x/y
         lJ4j6QRzizdDVAa9B0+ZUDSiMml0BgvkYZekJHMa+leAvT93E0zA6b/mCp7xhyhrUcVu
         52/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1779115977; x=1779720777; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=en1qHs+fEUqE4xVhbN1jKpnkaWJ0/dc4UTIL9ip1ulY=;
        b=MBR9MOs9003hHhIbRfH+gpBrJSdFactIvV4APyrGN/jaCs81Jj4dO/DmVcefm4tXkb
         YW2o7PBxcWPrEGs+ArVtXiiOejvEcpvpdde3X/rl0tyxIx6yJcCoqlIBbPL1ifGBTu/+
         OtceohiEMVFgB1LJSV9eMx9Tpk+H1ExeFe+kqEGS63yK0j6w/oplsOTrUtKSM994UZfj
         F8voJqYR7/FPbyHzLZq0/AHhp4i4Bhp+YwS/SQAR+vhre4N7WqPpDftG3vleISyzIEcd
         yRXUxlKxQAp0pUJPqD2mU8N2GhLNWKvc1B2CF6s8KwDAwhtOXkSGQRO4f7v0QZgf6mET
         lA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115977; x=1779720777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=en1qHs+fEUqE4xVhbN1jKpnkaWJ0/dc4UTIL9ip1ulY=;
        b=U70Zj0ku0ziLGxaZIs0Js7fAc3KlDTN2OD/3c5zehL2fy44dzCEBJ3hWPezSGHLAqx
         NC8rLfqhWK2U6f6F4mFNGB3Xs1lUL64VTZyUTnC++KiSB+7DMKYmldPW0bNPnj0FKHgu
         duBqq1CQeH7HjFGTmwCNbHEBwWlkCVmCw/eWoCytFuqkt4tGV4vGemasO/cZot0+jy6Y
         6DC3IgZoq4dEsNDo5zHnANc55qosxFGy0ua6aCuZX/CpHKmNSXs0E6dxK4IACHonb4v8
         by+JuXPC8fJN2nEjh+ttLwOo5w7bmD5iOk8d+TFtXUUB8Ras9RRA5il92z3xZzxnIjA8
         CUaA==
X-Forwarded-Encrypted: i=1; AFNElJ/LLmXzNfgt6Qa+kxsnuxNUlK5vYYTO8XY0zeupOAe36I48Kqs/HhS70LdPGT2aMXJxmiOf8fjxvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzam17Af6W6SKVkt/auWsVdIj2Z8NKeEjXvVyaMlH8qPr2qpP0o
	4hlGrrSiClFhfk94WJPLfOASwF0jBQpor+tiuVVAmHCDjhGI3EMJCb6j8ab63Wmbe2xRAqogbRh
	sWWUWWGayDGJN7/azlOevLSeNBTS250w3XQ6WthjXNw==
X-Gm-Gg: Acq92OEn9GYtJtnEHQr4yL6IeKcRiLYc44bq9tYhjsZvFhLmMqiIg/JJUGwvjI/7BGp
	/ndzi9uXl004aDHUa1Q9P5xcqzCbKkdUOcb3/7JyN7jLCXblXKb71UOnqt61mK2cIHdoddIjWYH
	9f081F9rEDcpxrogEUFD15LARwktRAcinzdJbsxZHnit+u163uch39yC+ubDjYAmyK0yLiOftZv
	sOySs6xrU6FOCDWqkyfX9L3idikr4qH2Fdm8WwOJ67jql2OIZoourF5siuFSeyhVlMMwYwiuRU0
	YKR5X/9Qe5zieJsoffY=
X-Received: by 2002:a05:6820:620c:b0:696:8fa7:5f20 with SMTP id
 006d021491bc7-69c94337384mr3586771eaf.1.1779115977504; Mon, 18 May 2026
 07:52:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260517213010.696135-1-michael.bommarito@gmail.com>
 <CADUfDZqJYvQEuUdWeqxvcBPhfj+zvsezcsnpbK0N9cnBTqr2qA@mail.gmail.com> <2bcbace8-6038-4253-be39-351f9d2f2a18@kernel.dk>
In-Reply-To: <2bcbace8-6038-4253-be39-351f9d2f2a18@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 18 May 2026 07:52:46 -0700
X-Gm-Features: AVHnY4LCotD17LfZaJ7_ts23T4l05T9IWaz1hoLjj9CH2995bONsmSlA68i5Zbk
Message-ID: <CADUfDZpB__CEbcjwtOOuHCwVcnD1yEAx8F+8EJ3UqXY4YJCj0A@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: propagate array_index_nospec opcode into req->opcode
To: Jens Axboe <axboe@kernel.dk>
Cc: Michael Bommarito <michael.bommarito@gmail.com>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13407-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[purestorage.com:+];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.org];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel.dk:email,mail.gmail.com:mid,purestorage.com:dkim]
X-Rspamd-Queue-Id: 48A5156F692
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, May 18, 2026 at 7:49=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/18/26 8:42 AM, Caleb Sander Mateos wrote:
> > On Sun, May 17, 2026 at 2:30?PM Michael Bommarito
> > <michael.bommarito@gmail.com> wrote:
> >>
> >> Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
> >> array_index_nospec() to io_init_req(), but applied it only to a local
> >> opcode variable. req->opcode is initialized from sqe->opcode before th=
e
> >> bounds check and remains the raw value.
> >>
> >> Keep req->opcode as the canonical opcode in io_init_req(): reject
> >> out-of-range values architecturally, then write the array_index_nospec=
()
> >> result back to req->opcode before any table lookup. This keeps downstr=
eam
> >> users of req->opcode from observing the raw user byte on a mispredicte=
d
> >> path.
> >>
> >> No functional change: array_index_nospec() is a no-op for opcodes in
> >> [0, IORING_OP_LAST), and out-of-range opcodes are still rejected at th=
e
> >> bounds check above the assignment. Boot-tested under UML (x86_64
> >> defconfig) by building stock and patched kernels and running a 54-test
> >> subset of liburing against each; pass/fail results were identical.
> >>
> >> Fixes: 1e988c3fe126 ("io_uring: prevent opcode speculation")
> >>
> >> Assisted-by: Claude:claude-opus-4-7
> >> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> >> ---
> >> v2:
> >> - Fold the clamped value into req->opcode and use req->opcode for
> >>   the io_issue_defs[] lookup, rather than keeping a second local
> >>   opcode variable. Suggested by Jens.
> >> - Keep the hardening-only framing; no functional behavior change.
> >>
> >>  io_uring/io_uring.c | 9 ++++-----
> >>  1 file changed, 4 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >> index 4ed998d60c09c..84e16c3ad3f47 100644
> >> --- a/io_uring/io_uring.c
> >> +++ b/io_uring/io_uring.c
> >> @@ -1721,10 +1721,9 @@ static int io_init_req(struct io_ring_ctx *ctx,=
 struct io_kiocb *req,
> >>         const struct io_issue_def *def;
> >>         unsigned int sqe_flags;
> >>         int personality;
> >> -       u8 opcode;
> >>
> >>         req->ctx =3D ctx;
> >> -       req->opcode =3D opcode =3D READ_ONCE(sqe->opcode);
> >> +       req->opcode =3D READ_ONCE(sqe->opcode);
> >
> > The local variable should improve performance, I'm not sure removing
> > it is a good idea. Due to the intervening stores, the compiler can't
> > tell that req->opcode is unchanged between this assignment and the
> > later loads, so it will have to reload it from memory. Can you just
> > assign to the local variable opcode here and wait to assign to
> > req->opcode until after updating opcode with array_index_nospec()?
>
> It generated the same code on my end, using gcc and arm64. If that's not
> the case for you, yeah then retaining the local variable would be fine
> too, like v1 did.

Oh, I missed that the only stores in between are to other fields of
*req. Yeah, the compiler should be able to tell that those don't alias
req->opcode. Removing the local variable sounds good.

Thanks,
Caleb

