Return-Path: <io-uring+bounces-11356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DDE1CEF1BD
	for <lists+io-uring@lfdr.de>; Fri, 02 Jan 2026 18:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 047C33025166
	for <lists+io-uring@lfdr.de>; Fri,  2 Jan 2026 17:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019AB2FA0C6;
	Fri,  2 Jan 2026 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gn0gvEYJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7572F9DBB
	for <io-uring@vger.kernel.org>; Fri,  2 Jan 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767376643; cv=none; b=uNWsaiv0opficfxISssv8ju2TPN6hwdkSH18+VC6eatMtXKIJ4KhyS2yvJFOJSlFjqoAYasVlNBWD2bCueQFT/6lO5htqjGBRRzSMS1qQIlFc2xzmChE+DwuYrNanRF2WTjKmUZDYkDSGNZmXgxV8dKZ/5TXAPyL1Dl0W30nHdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767376643; c=relaxed/simple;
	bh=gyDb2jd+vefeb5derpsvq7OglruyF0nZkG8dY+zRgDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cJZ40SOy3PgGS0p8cAXHw7T9rDH8wnwtW8vIao/yQH9BHlI01QXblLlJbt1DJpQoavaxv81rqwh+qpsS5NOXbLpY0L0NKUFImuVIkWkXCUTu5+Dm2M1TEnvey+LsQxNFexZwIOqFLKKRlrpS2BQFkLgVMT2E50qJ/1JQ1p7Juj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gn0gvEYJ; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4f822b2df7aso66055411cf.2
        for <io-uring@vger.kernel.org>; Fri, 02 Jan 2026 09:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767376640; x=1767981440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O18+3anvsQ996bavqCgxvMHI82KXbcuUs/EX7wR6K1s=;
        b=Gn0gvEYJFLfskRJjbCCkxCVCpwz0AZIxMs7Vgx7s60tIMHZPTlHulYxDVfQPeKUet2
         DdSrRR3ska24CIgGq0+hJc9H99xCc67HtXg609JXGsovNym4+/S74ANh6YrCicToSJGL
         +0kjCF7JwN+exGmt42r5QBZ4ya45ZFZRxRBXViY84G2rF+QxRQVXEbShSj9M152X2xJD
         dNy/6AVi+TkMz29mz8S4fdudT8E29cGGPLRemqC+6YM/EKijqZOraFbK4rE451U0qe9T
         oCgZzkiuCiF+NiGFuW2D+QfuhvJu0w7ThUMKdUqlgZqIUuvti9U3zbfvVfg6pfteUrKk
         l+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767376640; x=1767981440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O18+3anvsQ996bavqCgxvMHI82KXbcuUs/EX7wR6K1s=;
        b=AQLNx/SZuUZ6lf1Am1Tvt7Xb/+Fof7e4ZCvUNKTDkgKwi0uuMAN9P1H+sijR6lADUu
         UdDepVvkVmQv/DjYfJBFj5UzI7cBrrRJTOMdcKwQmz/rnAPlJ0eDoP+3HhHGueih+1qD
         YEY0Qd4+kepfqm5iowUsDicCGLAG1LmiZ++a0UA6mT02wNsy0dVXi81TACiJxcWKQhJt
         CGNziS/T8VrDcaehYmdAJaKVFLw4s/xhjuM7A4GxZ71+MOc5uA2eWuisxBJLIRPtk+mX
         QNKD/OZeSFGeFebdjjxDsfenM/PfamFyyJL0hjO/SNu0qGULCsJFax+e4tHTI+uNxhro
         KtvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOBMfK+tG3V7g0ApJDE1oAx4RVXFSH+3ng0jlvyPq3/TUcry5ypicwY1UIKFIBcNZp2xa5r+awuw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ4HKJ5yxzzQ6pLbCm0WFJLq1ipDUszbV/I0GQTktGNDNYynQ0
	1PXnqkGGY2t7E7I4ERf1JRZ37ZfPV4tQnDzmAKBORIBcM7A4RowX/JYup5qSTKbTvA2h5+DbHdY
	ZCiHlQQPf2qFEsvheyhdJGyvSI4wCo4c=
X-Gm-Gg: AY/fxX7SG4DK1rs8hEv4VBSu+GNNS0N9aXvRYhxe35DAnhASWMNK2gUBf0hEdq9+Dr+
	X4aOUYiLpZOLsZhYd7tBUOoKnnYE+M3hMhahRq/KuAY5n7puufyLMtGGZiWaGErjBZlNf1H/jqy
	sXu1pJy1nIwkddR0IS8bSMNgONQNtEr3naEBivWKZrKx1z8kOkEvZcm8CiyDTCKOKU5TJ+8Ynhl
	Zuh+2oNJVRThrWgQCmM5LuVWNLFEdsrL+2kAkOchuQnB8XmcS6ZvqbkSNJOan0Ct0jAfw==
X-Google-Smtp-Source: AGHT+IGorKA3maAZSXofCUy+HCC+njczBAg7rvZDg6EpFyE7TD4+DSfCoFgZ2bxYOgmujaLYA/z+r/Sp602TQv0GSmw=
X-Received: by 2002:a05:622a:6081:b0:4ed:b8d6:e0e8 with SMTP id
 d75a77b69052e-4f4abcd2ac5mr601470401cf.22.1767376640426; Fri, 02 Jan 2026
 09:57:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-7-joannelkoong@gmail.com> <87y0mlyp31.fsf@mailhost.krisman.be>
 <CAJnrk1a_qDe22E5WYN+yxJ3SrPCLp=uFKYQ6NU2WPf-wCiZOtg@mail.gmail.com> <87ikdnzwgo.fsf@mailhost.krisman.be>
In-Reply-To: <87ikdnzwgo.fsf@mailhost.krisman.be>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 2 Jan 2026 09:57:09 -0800
X-Gm-Features: AQt7F2rzrlK2P2sAM_OF9aPxCtuxCi-SzhqRwIpfqwqCRawDl8BmvdZb9N5jWa0
Message-ID: <CAJnrk1aAJmsK6Z0=F3n65pr0idGzDXFLEXXZDHOocy9ktnDZWQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, csander@purestorage.com, 
	xiaobing.li@samsung.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2025 at 9:54=E2=80=AFAM Gabriel Krisman Bertazi <krisman@su=
se.de> wrote:
>
> Joanne Koong <joannelkoong@gmail.com> writes:
>
> > On Mon, Dec 29, 2025 at 1:07=E2=80=AFPM Gabriel Krisman Bertazi <krisma=
n@suse.de> wrote:
> >
> >>
> >> Joanne Koong <joannelkoong@gmail.com> writes:
> >>
> >> > +int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
> >> > +                  unsigned issue_flags, struct io_buffer_list **bl)
> >> > +{
> >> > +     struct io_buffer_list *buffer_list;
> >> > +     struct io_ring_ctx *ctx =3D req->ctx;
> >> > +     int ret =3D -EINVAL;
> >> > +
> >> > +     io_ring_submit_lock(ctx, issue_flags);
> >> > +
> >> > +     buffer_list =3D io_buffer_get_list(ctx, buf_group);
> >> > +     if (likely(buffer_list) && likely(buffer_list->flags & IOBL_BU=
F_RING)) {
> >>
> >> FWIW, the likely construct is unnecessary here. At least, it should
> >> encompass the entire expression:
> >>
> >>     if (likely(buffer_list && buffer_list->flags & IOBL_BUF_RING))
> >>
> >> But you can just drop it.
> >
> > I see, thanks. Could you explain when likelys/unlikelys should be used
> > vs not? It's unclear to me when they need to be included vs can be
> > dropped. I see some other io-uring code use likely() for similar-ish
> > logic, but is the idea that it's unnecessary because the compiler
> > already infers it?
>
> likely/unlikely help the compiler decide whether it should reverse the
> jump to optimize branch prediction and code spacial locality for icache.
> The compiler is usually great in figuring it out by itself and, in
> general, these should only be used after profilings shows the specific
> jump is problematic, or when you know the jump will or will not be taken
> almost every time.  The compiler decision depends on heuristics (which I
> guess considers the leg size and favors the if leg), but it usually gets
> it right.
>
> One obvious case where *unlikely* is useful is to handle error paths.
> The logic behind it is that the error path is obviously not the
> hot-path, so a branch misprediction or a cache miss in that path is
> just fine.
>
> The usage of likely is more rare, and some usages are just cargo-cult.
> Here you could use it, as the hot path is definitely the if leg.  But
> if you look at the generated code, it most likely doesn't make any
> difference, because gcc is smart enough to handle it.
>
> A problem arises when likely/unlikely are used improperly, or the code
> changes and the frequency when each leg is taken changes.  Now the
> likely/unlikely is introducing mispredictions the compiler could have
> avoided and harming performance.
>
> I wasn't gonna comment in the review, since the likely() seems harmless
> in your patch.  But what got my attention was that each separate
> expression was under a single likely() expression.  I don't think that
> makes much sense, since the hint is useful for the placement of the
> if/else legs, it should encompass the whole condition.  That's how it is
> used almost anywhere else in the kernel (there are a few occurrences
> drivers/scsi/ that also look a bit fishy, IMO).

That makes sense. Thanks for the elaboration.
>
> --
> Gabriel Krisman Bertazi

