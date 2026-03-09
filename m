Return-Path: <io-uring+bounces-12608-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uL2+DKc/r2mYSwIAu9opvQ
	(envelope-from <io-uring+bounces-12608-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 22:46:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 761D4241D81
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 22:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 322CE303FDC8
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 21:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7446C18871F;
	Mon,  9 Mar 2026 21:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="LJn00lNb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87D914EC73
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 21:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773092772; cv=pass; b=FlLYcqIwU18w7pSZYx+MfglC1z8Nbdm5o/XHFVN3i5tGy9WasWpz9Gs3FGL9mUEqZqWccOvGkQ6bO4TrYlwHcIsZNWczYCk0eA+bJGbQ+SOhrLb+bGv9rkTekCCLV9KmVJlTm9He5+W13ojxB/hk1upnNiCIunH3k5C8KY0rkeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773092772; c=relaxed/simple;
	bh=g1AE3YNxhMYwehjGkh5RXdJTkrhJkH5lkvCRLQOUP4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lYVE/S46ImJXZg4R5o69g+A4AYC8zk3L36OMry8mEF/P79+TaC3poAckgmpclSfe0gaGkCg4ovrFAVE2FAFiGljQwmgI2Jzlw3oYIF915+26MpscfrpJpBTTZjF9mH77WE5ZfZGB3UR8Vo0Rx5zq83DvrDHQSviKq7V0jfyRZrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=LJn00lNb; arc=pass smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-40efb4bceb6so11626fac.2
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 14:46:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773092770; cv=none;
        d=google.com; s=arc-20240605;
        b=Q7tpFcwCB6Bo/OTgTN49EMRpsBwldBUhtPah1F1ujAmuWsOcazqAW0Rm3PlWD/NR5e
         IA0+LCrBK816DDSLNjuuGAZzHZGp53YhvL4RC8lwDYHTnWe/SDPsc+NYtAQz691ROTS2
         w7S907dUvV5M/y2RYjBqcHZtpzuawKuNWv6yCBoA3Qw90Ds44PqAEg/Wfj5ezgXd6NJC
         MjUIW9OZieqI/zkzeYAVlBYr/sirFhWYK2TghQRrhhVUHryRVIt3EVAw8Q6mzh5dTkeW
         F24Y4BNd/Enq6QXDzYXEaTmUiI2ZKDt6ek1Vg0GzTb3ucLCO7925JXd4dPcZEZL35AHH
         t+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JPGfrFdJFZVkTOMYPWCXUWIPARkSp35GCjzRKChGYhw=;
        fh=Vm0c5vy42pnRtgFBGxdKfRsOBtiUAtcuwYd9752ojB4=;
        b=chCt2nmXT3nramdXRJLtCY32GC218aweVffuREA9mzGwpGHrpAAie+0NRGqbDHkkrx
         2CIgZ61pDnlFeJLZChW7o7euR2E53iFT6bo4CX0LJO3daim7VZzATEARIzXMIZVM8ltn
         NBMVZVKN356GFjeEYhUFv0oKPV6WKXQFbesr+CaVH/jauAntTlm7+sHb/LBZQbSDEzvu
         a2ZRR0eZJC+2IW4dbR2X9/z7LD/JvaMOQ28v2AFMxPRqsN/lc2BrYlfGGm/ORO7Vzrn4
         XsDXJsBCgbM9tSvYP5+XtAC+R0DJAGF9Rs9H6TZPWi0vEF9Q5mLNqXHE0yvsaULj7vQd
         RNCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773092770; x=1773697570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPGfrFdJFZVkTOMYPWCXUWIPARkSp35GCjzRKChGYhw=;
        b=LJn00lNbYNAv6uhKIP0cDGFmJlQwkJ10DpdFcuE6Hp7OZ54ZfqsfGIj7msQv/muoB7
         42WZ3/+a8712IoRO3H4sftAMj8JBz5XXi35RkOkvtNDwPxfFbKwwqL/sg5sgwiO7lPj2
         jS+ExTGARTa5wCTodeyH+TfvEHMQfbmw7UwmSHypYqU6IPBES0hai4NcLR+K4XEhXMSU
         lbxtg9vELhKyxvAyQ7UXPwLJPX9VYgctHAAsHc4VemRuTesGnJcohEQRA5kEhdNz1LHo
         VnTi7U7/qQpZ4mj1S/AgFHTcAKtCacGVlr8q5wpk7vOwqniutl2x7KFuLqJoUdmCUOQN
         tsvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773092770; x=1773697570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JPGfrFdJFZVkTOMYPWCXUWIPARkSp35GCjzRKChGYhw=;
        b=w3qk0g6OpPr5uoOv60yx+awLEGoC1jzrwElgEGJOUapnfXVTarg03BnFEMCwg+OZhD
         m+B/8rux6pUug4iTNd2oopPPpxY7UL7Y6D+ChReBRwY6/EqaICWj62OJdQPFzed2wOAG
         Txc0Hvlkvzh2ALbcyIpDOlBZvT4MBw46P1U9ZiEjVeWcy9ZgG0EQdDqvzxIZLuA1MQUQ
         PAq6qsBTGfjJyIIo/s1ICXMiIiFEfTpaw8qN+8SSuNBOK2pQavJI819gpjYmpKsfEeFW
         BqaqtaxAFXyn11o2aCKl4lsVR4WUt8SHPmQpCngSlscRd9aK6YDPgcSr0Y0MlQcJahVM
         ld0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXx6VYYnKAp0dMkYNmUqx5ZU0VVPXYqG0SY8VjxPW1Xn2wkZCL/TgcpdihCrB7faXUk3cvrHjgCOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVd/+oyWhL5SED0jUPfckz5gTxrNZNKadc5Cax3DUdrkqFtSh1
	x0eUCFRVwrymC46RPVNTboTjh4aCDRvDdlAI+1TFaR/oHEZ4+AEbGNykLTUY5QjGVvtoQkJDQNl
	jSrPNj3b82kxyzG/ZFr/YcMRMY12ped0eIvaVMgqkVIAA6VBQ6z7sg6OOJQ==
X-Gm-Gg: ATEYQzw5PDqKQbCIwirdUUhPnxOmsOF4hni3V78WEYcJaJie+AAMHulNDWyrDDw8w3E
	Uh976Q+DGdxJyiWgddZ9VAEWOppjgoTbotIlRC5dWltY5c5Vlkpod+XaPCPgcfjRizEV0HbgdPC
	6GCykeuh4sNJeHCVNIfEay95xwSzqR/VRQ1DSEtFkPJmf+o2N/r651sSEpbn/K/xduZmH0N2lOL
	VQ4mK5j1IS/oJhJsfW+63g7bk27JcZJPKro9/skB+FDqAvo+agtjcg5Nue0mutTDAbquVKpIijk
	FmGq0xw=
X-Received: by 2002:a05:6870:b3ce:b0:417:4754:c10e with SMTP id
 586e51a60fabf-4174754d5b3mr1451418fac.1.1773092769712; Mon, 09 Mar 2026
 14:46:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJuauuPNcDAAzjzVjOE_sNcUT5FX6dwcV9o=hLC6ZaQkkZ72Pg@mail.gmail.com>
 <aa871Xk0EHzDxOd6@kbusch-mbp>
In-Reply-To: <aa871Xk0EHzDxOd6@kbusch-mbp>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 9 Mar 2026 14:45:59 -0700
X-Gm-Features: AaiRm53mDgh7iVkUWU98u-FBe21ulIx6clh2MYIFK9sVMp7nFL9JyeuL7xqdrio
Message-ID: <CADUfDZpQ9=ZMR0kWzX_o3CT4G=9vGp2zsL_KKdPs6tUpG00c5A@mail.gmail.com>
Subject: Re: io_uring: OOB read in SQE_MIXED mode via sq_array physical index bypass
To: Keith Busch <kbusch@kernel.org>
Cc: Tom Ryan <ryan36005@gmail.com>, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 761D4241D81
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12608-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk,linuxfoundation.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[purestorage.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_DNSFAIL(0.00)[purestorage.com : server fail];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,purestorage.com:dkim]
X-Rspamd-Action: no action

On Mon, Mar 9, 2026 at 2:34=E2=80=AFPM Keith Busch <kbusch@kernel.org> wrot=
e:
>
> On Mon, Mar 09, 2026 at 02:20:38PM -0700, Tom Ryan wrote:
> > Patch attached.
>
> You can just submit the patch as text in the mail message.
>
> > @@ -1747,6 +1747,9 @@ static int io_init_req(struct io_ring_ctx *ctx, s=
truct io_kiocb *req,
> >               if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 |=
|
> >                   !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
> >                       return io_init_fail_req(req, -EINVAL);
> > +             /* Validate physical SQE index has room for 128-byte read=
 */
> > +             if ((unsigned)(sqe - ctx->sq_sqes) >=3D ctx->sq_entries -=
 1)
> > +                     return io_init_fail_req(req, -EINVAL);
>
> Isn't this new check redundant with the "left < 2" check preceding it?

I think it's orthogonal with *left < 2. How many SQEs are remaining to
submit is unrelated to the index of each SQE. It is, however,
redundant with !(ctx->cached_sq_head & (ctx->sq_entries - 1)), but
only in the IORING_SETUP_NO_SQARRAY case. For
non-IORING_SETUP_NO_SQARRAY rings, the SQ indirection array entry can
point to the last entry of the SQE array, causing the big SQE to
extend past the end. Probably, this added condition can replace
!(ctx->cached_sq_head & (ctx->sq_entries - 1)). That checks whether
this is the last entry *in the SQ indirection array*, but it should be
checking the SQE array.

Best,
Caleb

