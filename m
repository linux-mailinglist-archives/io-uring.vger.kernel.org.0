Return-Path: <io-uring+bounces-12870-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KwuKiaNxWlc+wQAu9opvQ
	(envelope-from <io-uring+bounces-12870-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:46:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4204B33B1C2
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:46:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2ECAE30B2F6C
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 19:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974D234BA5A;
	Thu, 26 Mar 2026 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bHLGk6rN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D374393DE8
	for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 19:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774554020; cv=pass; b=BuSTrmKrK5tpqSsb7pgNYhAohGAfSZBCr6A49TQt1kZ7ESeiKe/3Qc0Hm5/DRIFhEL/Rr5NyO/W69gdEJizixbMGhqI4xyWwwsBXP8j+msNvxecSRuVDpQLFIvqCD7gyj0G5Qw9GVf0wU33DW1O1i5HzckRQyY1rmm+Ig6u0HnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774554020; c=relaxed/simple;
	bh=T14abehY8VeKfFoZhSc3VYDg0CDKqmTM9HxW8fyrcKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FPxuAIzNcWH4MzF4gkoLEMQXrr++nVu7hkPerT2SV8nRYgd3+hDyNmKboBQcIGQ2OY/fvxk2Fraoa6gTzNrYfMrrNDtYlHy98/BhQ+048unOoMWvl/AV+CXqklvxsk4WbEUYJ2CxZ0aL5nDKTwJWTokl64XsecFV/j3I9xJH/vU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bHLGk6rN; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-661ce258878so2586a12.0
        for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 12:40:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774554017; cv=none;
        d=google.com; s=arc-20240605;
        b=IXof1AasTAEfQGCL14hxn5ZUVgNXcMxsoD3V83WJdABJo8p9qYcF6pGQ46TFv8uenD
         ShOhUdZl8Y8I0zCMRBZlkSb6JImP2GuFzL4GasjCRjo/NnkwnbZDPMyUMoVJbxYO/kHN
         c68iDVjjCl00ES3kKiN3bIEPbhm1vKSVA+BAfWKWWXOQNRzBdap7oUg/L8daZFI0JH4T
         JRHb+S0/xeuIXFBRqmdLb3jUGF6LIXHFCBcczE+GjUEI6ZOE6t6WFafBvKFVj4Ta9nvR
         89YJSb/9ZsnvPj7C/nKAdROas2dD99nH1Ik4ilGhdDq8/K01bibazxFZnCH5SUyGDPtO
         MiZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=smG5Tg0EOyJh6ryr2/NdAiIXA5c3CAlpXYr7aOjiALQ=;
        fh=PmPFAdQwN3OL8Z+ZiLbXjgiA9T+J1bm6gIqBVX9Rh8Y=;
        b=cLun/kyWwhv3bJ8OE/fahT9g9wYKNz0CW70FXoCqK7wcZ3Mx7xb4XkXp8l4+G0Zxey
         IoxciDBZuRm6Qffo7EaTP0ikt3CY7N+MIiJQNKMn+Eq4D59QIySeVZuSUvRinI5BYGCN
         9lhPsYlS6XmyUyYSMDGtrAM/EYa1o553O5q6yN0lkHRoIDAicCC+dZDPxvPX8y8ctr5E
         Sj3KBg9PJU+jcc9Mm2FrKM3DXTm2cHVL0gmflBjkUJA32puHWSj8Agw6N4tRRTdH5nRQ
         DPLGcOztJLSzmUXc7wxLF1GNpQ2Tm2mVkS840KpPqolu1MF6gpBuvtK/cp098bZfeWqD
         T15Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774554017; x=1775158817; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smG5Tg0EOyJh6ryr2/NdAiIXA5c3CAlpXYr7aOjiALQ=;
        b=bHLGk6rN6EO80bINv6dN8jbCZIXHkcoCkcA6xUGBQ3rkiU0wRLCSu/1o4mA6n22v6F
         K0skbK3YTc6KTq6jq/D7h3ueLe+lZJ30OxyIP3ckOGenOd0xewg4Q4JPAjjCAWpjslMe
         SMtcWZ5tuxeIF+FYnUlInn0c9eWJQQK0Dy41sEQqTDXDZUswfBF5gysOhqk2Nb5YozuF
         ttB0SZPyEJwW7LATJ+sig2QHbJYl5EXNg+Ff+OakAOrbJNE3j3R7n0ZQlklg1FgEEwzr
         3VvQFJeFoVS5Smx91xaINzbSbgmLtAo2wldMo6d4aCae4BfC3MEPU+BvbhklU/MDc0N3
         nrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774554017; x=1775158817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=smG5Tg0EOyJh6ryr2/NdAiIXA5c3CAlpXYr7aOjiALQ=;
        b=VTROkzoj66WJgw5/FEyTuS8k0oUFrMOywX0LHeCEO6g0Uskktp7vB1b1bzq8WDRG01
         lkaPVYgzENIF2rcae1Iqdb6MSQeJlVGk5kIraukPsFRFYEN+sBlNbBxI1ioE6cAhNfA/
         BGOiF7UZtq6t7TE/vDkqr1SzNiUCwV+lKomJqy5gpQ3dT8idoRBLeY4PjcRql+2BzVhU
         lLAEcCjlFrpktZEAWVW5e1wxD3inx6vrF1lMklHu7uGsk5DWmsNiO+xRK1l5GXYJ2BXB
         IJXftMct2qBRjPX0t4QyoCmCRu7xbCqpzV4n9WC81KG5OZ1Kc8s9mGfil9Qd63TMEzMd
         bCVw==
X-Forwarded-Encrypted: i=1; AJvYcCWVqIAmu/GeDtcDj7vOf9FZiOoWUqz98+X4YqNRjoS4qVA3LwvbQsMnM4J0qwxxtpC7GiSS//Ad6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDjqqGkqsy2v2sB9BPwfg6+3QdcObedhtq7YDgIpZfJ0oIMR0Q
	KcwZ6HtntcWHiUW7/2HQ/aKQ6i5N+q+ocatdRvPxAFUHyHdg9hHfTtJXJR6r8GvzpZmnL01qMdN
	M6WT1hiUYrAGFUtWp6qV9VvKPpbT2k7wC9ErZVWXs
X-Gm-Gg: ATEYQzxkEe9ITfdU/nQcHH+930q3tPFN7xI1bKZQOp9y4t+TuRLVozHo6/dAGrc5L5e
	4IKh0dvFXy/porgphgeCyXn70xCmkp3+N8lHhtwfI1gEY5DA1ZNnrIAYvvAOLshZHB5BxR7GSbj
	dSLOOPgCKAf6l/WANaxchZ+mJfAH/XJ/6oGSYoxZv2qAyyErDwvv3SSNTRKtep+qS7oRAkq3vkg
	EYihK/td0ycoi8y/fL20CxZIaDzFKuPubHmxPFaNooJ+Yu2O4oVKYtul7OMODRIfQ/o5/XHMSQ3
	GpX71wOjjWhZxUdx76dFDQE7YLuLUcY3HsCI
X-Received: by 2002:a05:6402:524e:b0:660:efc9:900a with SMTP id
 4fb4d7f45d1cf-66b19d7cdc5mr11420a12.10.1774554016932; Thu, 26 Mar 2026
 12:40:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com> <20260306003224.3620942-3-joannelkoong@gmail.com>
In-Reply-To: <20260306003224.3620942-3-joannelkoong@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 26 Mar 2026 20:39:40 +0100
X-Gm-Features: AQROBzDzwqdBTqpXLzNjW79nbt59mFHqUgS8x2u6j3haKVdwU9v_EeFhzu9nPcg
Message-ID: <CAG48ez1QJZMO0+6FHBU4NHb_jp3appDWaw-KBzvJ0vzHWmXMQQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] io_uring/kbuf: support kernel-managed buffer rings
 in buffer selection
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com, 
	bernd@bsbernd.com, csander@purestorage.com, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12870-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jannh@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 4204B33B1C2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 6, 2026 at 1:32=E2=80=AFAM Joanne Koong <joannelkoong@gmail.com=
> wrote:
> Allow kernel-managed buffers to be selected. This requires modifying the
> io_br_sel struct to separate the fields for address and val, since a
> kernel address cannot be distinguished from a negative val when error
> checking.
[...]
> @@ -200,9 +205,12 @@ static struct io_br_sel io_ring_buffer_select(struct=
 io_kiocb *req, size_t *len,
>         req->flags |=3D REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
>         req->buf_index =3D READ_ONCE(buf->bid);
>         sel.buf_list =3D bl;
> -       sel.addr =3D u64_to_user_ptr(READ_ONCE(buf->addr));
> +       if (bl->flags & IOBL_KERNEL_MANAGED)
> +               sel.kaddr =3D (void *)(uintptr_t)READ_ONCE(buf->addr);
> +       else
> +               sel.addr =3D u64_to_user_ptr(READ_ONCE(buf->addr));

Nit: For IOBL_KERNEL_MANAGED buffers, "struct io_uring_buf" is stored
in a normal kernel allocation that isn't concurrently accessed from
anywhere else, right? So no READ_ONCE() is needed in the
IOBL_KERNEL_MANAGED case?

