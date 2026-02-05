Return-Path: <io-uring+bounces-12061-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOrjHYLxhGne6wMAu9opvQ
	(envelope-from <io-uring+bounces-12061-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 20:37:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C94A9F6E3C
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 20:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 899593022F62
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 19:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC67327798;
	Thu,  5 Feb 2026 19:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnXythQE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815BB325735
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 19:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770320253; cv=pass; b=b83opQgdu5vEBMVC2yi91IWfs1SZ6/kkawQ2F3Is/4DhDGf3gS3aQ/2+YIALysPyfzMV4oyWGrgGiTwlT1vElsoxlZJ5lcXLrdH/5eRyS1BDlCDdrvHLlFBj1qbGo1ADiCPJQwQJ8PfIyBQMZspLLTYkIFSpjeGKwvFtpNcA/ZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770320253; c=relaxed/simple;
	bh=vFnqJ+55Lb7PwrdMeBmY/iKA1MVwH8D1tjgvR7EzywY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QqiZ7LS5qB5h6SYdJNl4ulfiqtYlB88jTHBJQ5mo1/l7jd1/2wrCW1O838C4ragoPpdPchPgiwEiOUsQS2Np7YMlivI+vWz7siNyHAIOwrha4+/1n9j7XlTkcKnf2jFnRBUWnhgBL/D51ZKufwBTjNx1mgLH1kdcKMpo9mDMNQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnXythQE; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-502a789834fso11017581cf.2
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 11:37:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770320252; cv=none;
        d=google.com; s=arc-20240605;
        b=hnEBRuCk2qOLulLAN5E6+1DeQzvObsgMagrk9g5V5o5ldBoB1O5GYEzwsxjUYP8RuR
         DuID1ktWs+ATxwazPjTnJO2QJDkYQ1PF2TfwkJyb6vmRLXRkRtazqqE8LfH0y1iG+np+
         BzmGERneD16g6uxtwsFDxofqXOJs58uAKtoiwECT7RWkbVkLrqT/TN4iMqz+43bJfjXU
         7tF1loRiWytaWr/Yo3tu1aBl1+AunMh/e/DUNBWOhXp6+YDmh9Wg12BrRXZq3sNBWoFK
         FE9grd+vimqqjnn9Kv8pY/NP7AAHEQt6HUgUphI3tVH/+1SR7e+gL8tkcbS+bLbxYFKI
         kczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bEKNdxw7GTbO88YUuQ0c5F/KKVxdOovyiGJQg56lElE=;
        fh=gtJLeNM0UPuGPXszL2v/37DnjAn63zavbnofSN2A0DY=;
        b=UYqkp/2yD/AKBsuKYFgcR7eG5JprGZvc7FKtIO8KDovlRJu4EYADCN0uoRlq8yeQoP
         CDSYHAAR5h/GoU+jFf7HmBzC/ddkYcaXUGqOboe5bniso0cePexGYmRNDit/cAq7fCJO
         BYo1KzwrjAigZv/kxslN5s234AhBrf2gYb83cdNqxvlg3SUl5iKjkIwVLqOZINflZ2Pq
         tzXTkdj9EbEj4SULpHgj0cS2fwBM0+4GGl+/FgPNvuBisX2XgbZPzoK/lYrBSrSo0xCV
         WipiQdqLEBenMSKY1yOw//RzQR1VK41OgBYFDmO88vzy1lsYdis/X3gl2geXNpr/H+5k
         eIfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770320252; x=1770925052; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEKNdxw7GTbO88YUuQ0c5F/KKVxdOovyiGJQg56lElE=;
        b=cnXythQEp39dWqLPuQ1IUbeKH5j7jzzDCWz0zcp3x6jAKHR4GGVjN9wOAS+kDJxBxh
         GHoht9mshMEMpAtnYL4NLn1l4w4MtAcgMkJ9lY0az98AsTiBWvXx+0BwrxkI+pBPAKmL
         OD0VfbAjqVCYjsCYhCjkVtN4pr/8QMhmYtFPsBVbagIn87tE5oGErqK7DPJZgyC0AQVd
         mJf3ip31AmcjCOy2f6fqrFu3At/vs6Q0Nkzmt6XJcEXNTdQlkf0rDTjeWPgh50WrTEwy
         tzTwy6swKM+Vr+B1fiyWyqNHetzTfgHFIxcu9CUlxDyjD7nsxF4hpmRRGrNqeBt1Aoog
         H6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770320252; x=1770925052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bEKNdxw7GTbO88YUuQ0c5F/KKVxdOovyiGJQg56lElE=;
        b=c/Jvk3zJjDjpEioN63820/P54bwz1GbkQegbO7fuPoSr2xmvQo18Z0XGxzwmYaG5C2
         miTAYRy3JM9BVCvoBIdmruNvhnYTyGCzEr1pJvtQcDr2dPSb5zA4pw9ZTTzUzGP7wAdG
         rK5DTpYCnXLu6m1SWbx+6oom5yeaall4nZmp3selX4a2VBYErcQV+paOQ4qCs4jn4p2O
         p+aYmS5SsWF4jJec5jLHUv/ojxEjo0AmiUITxGqRdLcUauGBFOXyc0EL+tOPkxx9yHp7
         TBNZrqf8cJxXgmPPRKWz827JQXB9/7Z+gPmKUUtYgd4fSWhJ7EYK3I7MHiskIMQ4H+HW
         pbUg==
X-Forwarded-Encrypted: i=1; AJvYcCW9WlRpT9i+Oxc0ux2c8F6SjeIm5aWepKB3iIz5iBXuqGFHnRMBi6CTTpznnWFqTFMEloijGCGcQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyS3sTPu2B/lzlpS1U5dNT+uxMpeehWzWa3zjrBoYCB9achC/+X
	KP2rIDcIf0wr2xhdZHR3u7cXcZecVW52mzScYgwrtWsr+mUw8dZGi3bvS7IaXupKrI4wM4fDzeP
	d9aIOLIBgA6XwcUjzn078fkvLhrrE3O4=
X-Gm-Gg: AZuq6aLeSTAlm7d7itvwaDtmk3MSjo9SN8k+sGzlKBvMSss6ftTdPIj2hxJoNReKtgi
	BI+3KBiqL/WPyPJZcoK5IrhLYo7RR1NHgQqTjdzlzzoRwKJTYZ+MLxA+Ng00bfWc2spwjU1T1UG
	0iRhhsjFZ/lMoySXnP62uDk3dtebT3r5dgAzcwDteWZ/AkQsrXw2dn8A310yrDld5ugdi3jDGfY
	5jBvgVLdU7TWm92to3w0RonI3hxu96fA4ZsPv/SIRLGlQvNSW1tuRjHr6N2Xap8fhhInA==
X-Received: by 2002:ac8:5841:0:b0:501:489d:f3f9 with SMTP id
 d75a77b69052e-5063994e652mr3738671cf.43.1770320252269; Thu, 05 Feb 2026
 11:37:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-7-joannelkoong@gmail.com> <9c32bd42-b935-48fa-80f8-d610f4085025@bsbernd.com>
In-Reply-To: <9c32bd42-b935-48fa-80f8-d610f4085025@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Feb 2026 11:37:21 -0800
X-Gm-Features: AZwV_QgZHssLF7mj_r-dU1lHXaRtROJHSPhxgkJfLJzCTUQ1YM0tZ6aAyf_pM4Y
Message-ID: <CAJnrk1YLyCD0XEgH7vpfKSHjx3-9x_JRBqROyB5Sxwqv-ooy_w@mail.gmail.com>
Subject: Re: [PATCH v4 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
To: Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, bschubert@ddn.com, 
	csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org, 
	asml.silence@gmail.com, xiaobing.li@samsung.com, safinaskar@gmail.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12061-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
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
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[man7.org:url,bsbernd.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: C94A9F6E3C
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 10:52=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
> On 1/17/26 00:30, Joanne Koong wrote:
> > Add kernel APIs to pin and unpin buffer rings, preventing userspace fro=
m
> > unregistering a buffer ring while it is pinned by the kernel.
> >
> > This provides a mechanism for kernel subsystems to safely access buffer
> > ring contents while ensuring the buffer ring remains valid. A pinned
> > buffer ring cannot be unregistered until explicitly unpinned. On the
> > userspace side, trying to unregister a pinned buffer will return -EBUSY=
.
> >
> > This is a preparatory change for upcoming fuse usage of kernel-managed
> > buffer rings. It is necessary for fuse to pin the buffer ring because
> > fuse may need to select a buffer in atomic contexts, which it can only
> > do so by using the underlying buffer list pointer.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/cmd.h | 17 +++++++++++++
> >  io_uring/kbuf.c              | 48 ++++++++++++++++++++++++++++++++++++
> >  io_uring/kbuf.h              |  5 ++++
> >  3 files changed, 70 insertions(+)
> >
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.=
h
> > index 375fd048c4cb..702b1903e6ee 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -84,6 +84,10 @@ struct io_br_sel io_uring_cmd_buffer_select(struct i=
o_uring_cmd *ioucmd,
> >  bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> >                                struct io_br_sel *sel, unsigned int issu=
e_flags);
> >
> > +int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group=
,
> > +                       unsigned issue_flags, struct io_buffer_list **b=
l);
> > +int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_gro=
up,
> > +                         unsigned issue_flags);
> >  #else
> >  static inline int
> >  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > @@ -126,6 +130,19 @@ static inline bool io_uring_mshot_cmd_post_cqe(str=
uct io_uring_cmd *ioucmd,
> >  {
> >       return true;
> >  }
> > +static inline int io_uring_buf_ring_pin(struct io_uring_cmd *cmd,
> > +                                     unsigned buf_group,
> > +                                     unsigned issue_flags,
> > +                                     struct io_buffer_list **bl)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +static inline int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd,
> > +                                       unsigned buf_group,
> > +                                       unsigned issue_flags)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> >  #endif
> >
> >  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_r=
eq tw_req)
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index d9bdb2be5f13..94ab23400721 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/poll.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/io_uring.h>
> > +#include <linux/io_uring/cmd.h>
> >
> >  #include <uapi/linux/io_uring.h>
> >
> > @@ -237,6 +238,51 @@ struct io_br_sel io_buffer_select(struct io_kiocb =
*req, size_t *len,
> >       return sel;
> >  }
> >
> > +int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group=
,
> > +                       unsigned issue_flags, struct io_buffer_list **b=
l)
>
> I'm just looking at the fuse part and I'm actually not sure what the
> "buf_group" parameter is. I guess it is a the buffer group set up by
> userspace? Does io-uring have some documentation like fuse has under
> Documentation/filesystems/fuse/?

Hi Bernd,

Yes, buf_group is the id of the buffer group set up by userspace. I
don't see anything documentation related for it under Documentation/,
I think the closest equivalent is the man page for the buffer
registration API in [1] where it says " bgid is the buffer group ID
associated with this ring. SQEs that select a buffer have a buffer
group associated with them in their buf_group field".

Thanks,
Joanne

[1] https://man7.org/linux/man-pages/man3/io_uring_register_buf_ring.3.html
>
>
> Thanks,
> Bernd

