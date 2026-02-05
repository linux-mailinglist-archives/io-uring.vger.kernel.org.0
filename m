Return-Path: <io-uring+bounces-12062-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAtjBfHzhGkq7AMAu9opvQ
	(envelope-from <io-uring+bounces-12062-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 20:48:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D4FF6EEA
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 20:48:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 28ABF30120C7
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 19:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4D032A3CA;
	Thu,  5 Feb 2026 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yxj1D0Cf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F46630BB80
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770320878; cv=pass; b=JX0teesb/0XZ0Nz53ef83CMIlyDWaSd6IOcWK/w0jvM7jmfyGyUySeJrIHBgcIjTtx6ztDpffw+x9dVMTreGq84HoEDItZwYvDcMMAIcLI5MylyXRKoxLZxKq4W44Kr4JVKaeUr2yGK3tlEYKFn+PTmTCVS7wqhCP7NP0cUNNus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770320878; c=relaxed/simple;
	bh=xMipxxaS1jf8fI9UvS/zGLVXSrAmECyos0ZCNaRRuNw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dr3hz7l7zx+rra3fyMMRe8pqbQDjENjxrdIZVKfk0Qtu40AsfCQyIOX4kV7WlA8UCJez5+9tXQr9yPZ3K4HOhSnrz0Of5FLz/uz+XuBw1eO9XJ4kZ1VdxvZUkuxTYUpz/yr5B5ICVlyfji1dCGWhBbCGPiSAXwUaW1fsAypVZu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yxj1D0Cf; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89473f15ed8so12536696d6.2
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 11:47:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770320877; cv=none;
        d=google.com; s=arc-20240605;
        b=aRuje7pvA2GFnwWyo9W14agil7Hle/I77Hg4121vUmd2PnMRV5V68HBbRS6nBcANuO
         Wl9ywTou196pyOgiN5F6rp4ouvXBoup/TlZpZiJC+Oa1HsF6yNk2jB/VfWIyZcLJQcvw
         wsK1qBJXfaBLgOHxL37fxqdLVNdCQWD4pUgNQO7b6XqXEB9jwL52mkocQwwHXUGB1kTC
         LmAMMMDOPz/ywPzNgNQyybrYpw7e57VNHq2PVNITmyD/mWBjsKSa7MeF150DKztCg/eh
         Dzx+8An+f6D1mw8yDzC0cm0MbGOs/c2mePn1aObd6U8i4Xgrva/IoXKk9I3uK4TWDAzn
         1mqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kFlhr6RPDkRedt0OgucOsRX5uExdwYqqByKKZziXS4g=;
        fh=8iZjbO/0fWUwuZiqXgc6tFUbKwzGdtbpT3o1DQApKRA=;
        b=YmhMAEWtzPrIHsTrpRU3qEfJa3nRFkGPbPgROH6dmcTx6p5PV55JQecq6B0K/XZ9t4
         qSuk43RY6Gf95yPT2UmQWr8YX66ok7P6flwnk305gZgQ+kibSpt0asK7da2mA5bhHUq0
         tkITlFVWGNx4q8MVg8d+tlqSeZ0rOCS7/rtmEcUg5ZJHH2LgdQG1w/dIZXq1NITLYkqD
         SkXT9givYiKaIz52JsbF9hJnxm9FPNeIs9V6lwgCLKczd9oGsv0y+6CD57Ogeq9dVt9V
         YmhqpZKOGM6MfegDRNTYC/MeIu128sKRBrcWIkqceERsGliMlZC70PiqUaUJAg7/qI2/
         amfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770320877; x=1770925677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFlhr6RPDkRedt0OgucOsRX5uExdwYqqByKKZziXS4g=;
        b=Yxj1D0CfTfSBg8AuHMrsHtnFQvZdQlu3ezJ9JpaYX+3cihUn0wjjNn8ii2IBj9lOMh
         F6MLptOHNw83CB/ZSnHSSGcdPYnYWLV8V9+0uJdU6aq8uQ65EgS14v+MpmOHEPUoS3e2
         dJS3wL6HicsciWQ5wYPBsDTlKCVb275fxCemz1rZiovhwEqTZempZXcDNFiX2JY3ngjF
         5PUQ+fkmorXbkycKaCaqTZacq09wi+7GC0cFdLI4OWMts1c+GhllpJcW0jmFqMUEhG1l
         bWf/HhcbCtdVHmysdTJ1B3uFQbI8OJDRJ0sBjs4/knusYAiLEuK0u4NFuCDXk99d6LLS
         nYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770320877; x=1770925677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kFlhr6RPDkRedt0OgucOsRX5uExdwYqqByKKZziXS4g=;
        b=JNiKDUHNNoo9AIyJZBm6aHDfULUb41P5ifYfMU8jZFg51sGLN7Khg4GOi/XdKXl5Q+
         POIWnHdTUz6a9RscXQ+SlSTWd7py7Q+/EtDnYnNIq9uIdahRBc0ZldlyBuGSIzjIiMPK
         kwWMrQE8kVsLSAs+xn00vO3C+Eo+CRz4+cC+nWgCa0kSKB5+l4IxqCpgt2AocVdD0Bzy
         OpWPQmgrhs2AuOtk7AqxXl+29fIB8TlaVSHMUqfCyVtHz/Ou3CcU/d2YfMUq9wqTmowT
         LhY0VB+oCRouWhrjAnopzOZLS4ffI2FJuwJcSxQScCCQ0TnbkHbB4Cfla15tqSbnvF/W
         +SKg==
X-Forwarded-Encrypted: i=1; AJvYcCWRL64nRmpfcxLFvJgKzC2qDIZ8UvCrget3AIM5IVeMHIP+YWHkF0WUO3nxVSm5MLkDKimbzkNAgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzegsVWUSDakipcsbxCpI4+aFh76LuIP1BkE7sXFPKr8gZLhwjP
	UR+1BUIuleBeujm920ma79V/4iYVGF48D3BHg7c3C7wLupeTmr2KrnoOOc9I7ARHzi6txfU7puH
	FLqW/cN243C18tp6fgFyg0ATSk7I3ZO4=
X-Gm-Gg: AZuq6aKQ2aIz+TRzF54PkB7sLBjRmTuP1VkTNGBuxX8ZqONiWOIjAJa/2kJiMME98y8
	TQiM7ZhBx7PR3f94Y3M5Se2snwS+iIwsLBEj/iHpvauURvLZbrJB+SY3MM2GTPvdT+tsOH3GUGC
	lsxKMtF4YCLxycvCilFNqLAIrMZTkjehpYzGmnxL4mi+8Wn2dO4eoWct4HIqPIxxIdvlZ4Ybj2y
	lmEU7XGi0OFv+PhrdBZwpyCipOaTxwQuRiwXmx+Doz7H43pcz1tD/YQpWURf7spBf7K9wEF51Gx
	P8S6
X-Received: by 2002:ac8:7fcf:0:b0:503:2c49:34b0 with SMTP id
 d75a77b69052e-50639a01b8emr3334781cf.62.1770320877157; Thu, 05 Feb 2026
 11:47:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-8-joannelkoong@gmail.com> <4f96f8b5-7f51-449c-9717-8c8392a3d671@bsbernd.com>
In-Reply-To: <4f96f8b5-7f51-449c-9717-8c8392a3d671@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Feb 2026 11:47:46 -0800
X-Gm-Features: AZwV_QhYBWmYp9BycNAQzsrtgDVQ5VuhGaSXHDxbgGR7nom0RYEUnDrPs6UIVo0
Message-ID: <CAJnrk1aQs99+xjTy01zTF2MpbaOe-TgkyazJ1pKgkHz+TNZ9AA@mail.gmail.com>
Subject: Re: [PATCH v4 07/25] io_uring/kbuf: add recycling for kernel managed
 buffer rings
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12062-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,bsbernd.com:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 50D4FF6EEA
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 10:44=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
> On 1/17/26 00:30, Joanne Koong wrote:
> > Add an interface for buffers to be recycled back into a kernel-managed
> > buffer ring.
> >
> > This is a preparatory patch for fuse over io-uring.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/cmd.h | 11 +++++++++
> >  io_uring/kbuf.c              | 44 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 55 insertions(+)
> >
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.=
h
> > index 702b1903e6ee..a488e945f883 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -88,6 +88,10 @@ int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, =
unsigned buf_group,
> >                         unsigned issue_flags, struct io_buffer_list **b=
l);
> >  int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_gro=
up,
> >                           unsigned issue_flags);
> > +
> > +int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_=
group,
> > +                        u64 addr, unsigned int len, unsigned int bid,
> > +                        unsigned int issue_flags);
> >  #else
> >  static inline int
> >  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > @@ -143,6 +147,13 @@ static inline int io_uring_buf_ring_unpin(struct i=
o_uring_cmd *cmd,
> >  {
> >       return -EOPNOTSUPP;
> >  }
> > +static inline int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd,
> > +                                      unsigned int buf_group, u64 addr=
,
> > +                                      unsigned int len, unsigned int b=
id,
> > +                                      unsigned int issue_flags)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> >  #endif
> >
> >  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_r=
eq tw_req)
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index 94ab23400721..a7d7d2c6b42c 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> > @@ -102,6 +102,50 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
> >       req->kbuf =3D NULL;
> >  }
> >
> > +int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_=
group,
> > +                        u64 addr, unsigned int len, unsigned int bid,
> > +                        unsigned int issue_flags)
> > +{
> > +     struct io_kiocb *req =3D cmd_to_io_kiocb(cmd);
> > +     struct io_ring_ctx *ctx =3D req->ctx;
> > +     struct io_uring_buf_ring *br;
> > +     struct io_uring_buf *buf;
> > +     struct io_buffer_list *bl;
> > +     int ret =3D -EINVAL;
> > +
> > +     if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
> > +             return ret;
> > +
> > +     io_ring_submit_lock(ctx, issue_flags);
> > +
> > +     bl =3D io_buffer_get_list(ctx, buf_group);
> > +
> > +     if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
> > +         WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
> > +             goto done;
>
> Misses "if bl"?

A buffer shouldn't be recycled back into the bufring if the bufring
has already been unregistered. I'll add a WARN_ON to make this more
clear. For the fuse case, this is ensured by the kmbuf ring pin which
prevents unregistration.

Thanks,
Joanne

>
>
>
> Thanks,
> Bernd

