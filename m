Return-Path: <io-uring+bounces-12873-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cP3kIOiTxWmq/gQAu9opvQ
	(envelope-from <io-uring+bounces-12873-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 21:15:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F313733B504
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 21:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 129E53028B05
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8313A3831;
	Thu, 26 Mar 2026 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTki4Cq9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BA839A7FD
	for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 20:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774555761; cv=pass; b=VyUBhxdxcQXfPBi69ZrEeDhcMpjsWxapa4hHGx1QnmbrhXZxu9LuOKPz17tDaKUbGclhMJEan7Bcw9TYkwm6Zr30XFDve368BCRWfZ1YFDLdIvu0SkSFUspojtwipb7kGvrohyd+b+GdXfSd8GXzeYr8A49dHK8ubfZb19sJXy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774555761; c=relaxed/simple;
	bh=gzhu+CqUtrVezttb8Z2iXnjh5eZo7Vdxey490E+JjDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k0UdOYSUuli96ge1OxP01RLFTyD/PZgi81DwBchB0CEJTDzGAybfsaHgTAF01jt+VJ8SoKU/CfFOEF9A+2I1JO5u0+Q0E8iVfNVMoXBBj6r/7EyYgLHL06Q24lweiRne7y488xwsmX12/mWKUwop4Qwh+vneoEv1MT/Dztx5GqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTki4Cq9; arc=pass smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-439b9cf8cb5so1352204f8f.0
        for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 13:09:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774555757; cv=none;
        d=google.com; s=arc-20240605;
        b=CjkfZWq+37IRPWXxEXBDREdJW9g/EbMXBhIIhsS3LSTiGqfr3XKvDXLbqiqdvcPUex
         q3qkzPbncOsgFQu/1Cl1PPjTNGsy0CKjHYReZfy3oLVDWI4UUqh3NFoFW6lrnBUE3euJ
         17okriUBLteFZFXgIgmosT6LDHEPQ14oOgRao5oDF0RDJLcYXd5nZJRCHryOy54VmdH2
         6u09ZSxwaSP0oL3X89quMliRSLXt/2P0wThzzeGSYf+PhdDWm7xOEH57GpLGZAuLGkOq
         MrV+mVYrXiU89BTAcl8UG1DMLS0Tl/HG1YkzRoKQphwRTgFZGC5t/tupU7kLIw+Mv8c1
         q9Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pSO5Vci2cBEWyd9BSx5G0lqNsVvZH3gUM8GItXsYDhw=;
        fh=fJB4Zj7yk2e68FPNjBzyJepPJ0fFu7QhvYzgR9D97sA=;
        b=CV3zgIFh7SEufNen7jDxUMioL4LLJ0amCDxvn7kIFEHWv3q9hefyd1+wNR/S/+upOW
         VQWi539WhktMPvCHsQOu0kGNmagw35wkXPI6UOqGs0INisVK4rjiTWtnGnQh8T7rpTNC
         j1Wqfl646xEnCvTY1sg76XzAnafMA0KKSxvxX+nAvL5OhtF4EOTvEbMVdOjuDojYgKwD
         ynVxB3MFu7R0gc3s3UGgMb3b+6Z8tfLkO/glp7IcSg6ksEXh4w3hLcgR/58P4IJ65GYk
         EAyF41OWAC/mA1QABYnySg+iCinkM5fyiQdpuzKc+zFPaHbQdiyCz1Ex49NPli754oyE
         FKcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774555757; x=1775160557; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSO5Vci2cBEWyd9BSx5G0lqNsVvZH3gUM8GItXsYDhw=;
        b=gTki4Cq93fauyh6mGoJTBnIrc3Fwoob+MFYqbJD7T2KI3QENjpHupJCyD+kO0+82s7
         S3F9HqEIdrWndEvi3czMbUOiAYtiwkxn3wTqmADALufyjJau618KIKR/zZFT9UlmoThs
         3oe+StZIAI5jhRMBy4BTyjWmuoChaMgFpxEbc80p1PDmW+ZZn4QmgbjepF+BjJpnUYgI
         404aqdydWerrpXLrm2+BE6leJ8inhc6tBKctsoSJl3eKMcUBxfcsBymm1TQoUc4uoRYb
         bNov3n+AhSutGl7z7hoJ6CiA347koCBwWoKaARM+l5u1vNiwLcHgXp4tb8xEdMULn/w2
         ogcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774555757; x=1775160557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pSO5Vci2cBEWyd9BSx5G0lqNsVvZH3gUM8GItXsYDhw=;
        b=WhQaZy5f4w+EyerAlvJwl70hUbbYdWGo48xmJKYsOoHXR9VU/FRUnajimN8VwU5zYM
         uiaEZFFVqswxDF+3IKYeUc+aoraCDv/Sm+gjJISZpRMTrVCJ9JF+4bw3o8XZT3JmNHwN
         R8RSESvRTOni+nTQlQdDdIhVqzo9w7NlAwWqOIt0epEG2cfjM5LUvFwPpu9rfprf3FaT
         fa7y1GEY19sEzaJ+uDmS81OYyHrXH5HLxCbMvFZovp5CmWMX8ZKAhZ8M0SdqlQMvc+qZ
         ssr5WeWL2cEClr3iBicsRGnob7iuSXrFB6HDgE7tae2/bff4skk6o4OHziHbXoYetCRf
         BQPg==
X-Forwarded-Encrypted: i=1; AJvYcCUj1CPx8cjJTGHTPC3P8c5ADb8HFOvKSrgP42YaMhr9+KnqLXb8YRGjIfe3sFNxCHYm/SgtzwEAxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKuU2kz/F8eLPuK9oSZfuAjqRFmUnyCCMLgtm/ICXm/0AxbvwG
	I7yeJl89QV2sIoahwc6uHcGXglPiutIv5q0Reij4bCsN7QcGqXijBqhZFSfqOI9rlr/DKqh1zL/
	ojw04hCNteW8NBhSvJyqYNBwCGiK1/k4=
X-Gm-Gg: ATEYQzxIOuxj4cC5aKmPw5HqlcHL2ZXanVskhcn27nkiSasu91IXpECI7KJlqLvoNup
	imgmurMAFbzoyDGOjYZZbZZQSKwRad0nmNHdbPsDMHgL8RIbACAh/Skox+9EAYYO8rDQ20pu+19
	ZYx9EWxfBSDyYoMAXvhCJqg+FPAEcqBie8EabHhj6M5Q/FSzMaqT4DlBYGjF0bBIX8i/M5xkXwS
	03QYgKYnw/YTbMORhFTJC/zF/KHlHPNzNTLqdfTYD8kIieHftmJoGvGbzf1ewglRwNSySPeEg8v
	9jWBWdtbpqcWojdW
X-Received: by 2002:a05:6000:420e:b0:43b:4720:10f2 with SMTP id
 ffacd0b85a97d-43b88a8ea25mr13987946f8f.43.1774555756849; Thu, 26 Mar 2026
 13:09:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
 <20260306003224.3620942-3-joannelkoong@gmail.com> <CAG48ez1QJZMO0+6FHBU4NHb_jp3appDWaw-KBzvJ0vzHWmXMQQ@mail.gmail.com>
In-Reply-To: <CAG48ez1QJZMO0+6FHBU4NHb_jp3appDWaw-KBzvJ0vzHWmXMQQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 26 Mar 2026 13:09:04 -0700
X-Gm-Features: AQROBzDrqW0kWt11sHOKcDhoAUH681FTTWU_vKdUyT9FiPuio18gxRZyIl70GPk
Message-ID: <CAJnrk1Yv5GN4J8-VnWYCRhdkwwtvJJRFy4o=Yn7CGM86-h=WJg@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] io_uring/kbuf: support kernel-managed buffer rings
 in buffer selection
To: Jann Horn <jannh@google.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com, 
	bernd@bsbernd.com, csander@purestorage.com, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12873-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
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
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: F313733B504
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 26, 2026 at 12:40=E2=80=AFPM Jann Horn <jannh@google.com> wrote=
:
>
> On Fri, Mar 6, 2026 at 1:32=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> > Allow kernel-managed buffers to be selected. This requires modifying th=
e
> > io_br_sel struct to separate the fields for address and val, since a
> > kernel address cannot be distinguished from a negative val when error
> > checking.
> [...]
> > @@ -200,9 +205,12 @@ static struct io_br_sel io_ring_buffer_select(stru=
ct io_kiocb *req, size_t *len,
> >         req->flags |=3D REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
> >         req->buf_index =3D READ_ONCE(buf->bid);
> >         sel.buf_list =3D bl;
> > -       sel.addr =3D u64_to_user_ptr(READ_ONCE(buf->addr));
> > +       if (bl->flags & IOBL_KERNEL_MANAGED)
> > +               sel.kaddr =3D (void *)(uintptr_t)READ_ONCE(buf->addr);
> > +       else
> > +               sel.addr =3D u64_to_user_ptr(READ_ONCE(buf->addr));
>
> Nit: For IOBL_KERNEL_MANAGED buffers, "struct io_uring_buf" is stored
> in a normal kernel allocation that isn't concurrently accessed from
> anywhere else, right? So no READ_ONCE() is needed in the
> IOBL_KERNEL_MANAGED case?

Yes you're right, I had copied it over from the userptr case but it's
unnecessary here. I'll submit a follow-up to take this out or maybe
Jens can remove it locally.

Thanks,
Joanne

