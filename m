Return-Path: <io-uring+bounces-11967-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Od4OcK0emma9QEAu9opvQ
	(envelope-from <io-uring+bounces-11967-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 02:15:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BEC6AA8C7
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 02:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A0463037164
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 01:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8437031B127;
	Thu, 29 Jan 2026 01:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtzeAgKQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6444D31618C
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 01:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649332; cv=pass; b=IeaGxcPYq4vJIxmXcLOTGR6uLMlq2BE5aVd/iAEE5LpAHUE1DEw92Kwhr8JPvvfX9t1rnW14vuJl1Xe94vkWHjOjhqfv+aUDOXTdjSGfD3bXVY+LtzBR7wLdXQ2b0tZYmJnDJrg8BV/ygCEo7Bo7SNMrcyY7Ntx8b2bUXczIAZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649332; c=relaxed/simple;
	bh=LL7o4vy/NoO6zKG10NFswNY37j+yETGJ/86umDxUc18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LAJs2tlQbEYfTaHKG1dTu8KJp/nl6Hv2ZNYA7o97PhxpEMSLanuVZ0gTdLHoklJwL0pk8bX63G+kfg7bee0joJdYqe3PV7kNoDjlRQKXFqCmJE0BCLCYGsUAioC0bNWxjf7s1a685m9ov7rkPBkCHQvE2Hue3/pWWgnAGVSriP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NtzeAgKQ; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-503347e8715so4775531cf.2
        for <io-uring@vger.kernel.org>; Wed, 28 Jan 2026 17:15:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769649329; cv=none;
        d=google.com; s=arc-20240605;
        b=W4x44sUdkLIEubGhLJkGHCFpOsWZcL+aLpv/qLYu22bnq81Gu2aD5/S29Ixo5h/IA6
         1EYqXXPQwAxRUnK/iYzub1bO3Jd1Jvq9zo25KWtnpY3jKUcDJTrV6EwtuNBBaG6Xjt+V
         PZf9bx2IvBRetlk9UomXFXOxlU13dtjnmLu4ENF9oN0O93PShYjHEfh/o9gcfJfuFbWf
         j22LAv2xC7gvdgMYHfpuS2vumcwn2B7x6frhlQeRpSR/oEQP6/ukG7D1VS+JKkBw+Rlb
         j2+iVugWlD1BMXUa9QncUTsZuebiC6Od33ZxlPVn8YKMVnbBaLNR5watD4m+DGqJRnwr
         zOrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wDykPZ8EL1Im5WBOSDWsyNHmCwU4viR22qWxLrqJr+g=;
        fh=8dhEb8hjtmKz7dC5Uc8j6Tn1u582M/uABZJK9gXcXBU=;
        b=Z06/+89TmzSYDgq+9F/J+eivTvj+Ujmw8R+9EsE0vVrXm2y1elIbUCjzmu0WgeJ27q
         MSFnZktIuttc9RniZFGgzVta7m0nx3cKp1MbVZCiqYXCs8RJYPRJKVwTTmzy8nxHiKUw
         gGx1ieKrZenGC0FyIxvQnoCcv2E0mt5VNrcpnGZCrbepRlVnSpb/+HLQk3zWfR0KKRty
         oNiMLv4IpUjCabmKfXpTqVyWb6ofk76XaajOTZ1A6/H9s4Kes9tJ+cv1Qf0RSszZAjrd
         rZ7FD/BWnMuo9ePsCiO04h0k3Vz8+5gx+ZD2LgR2Dmk/hZetWifPZO+HQEo1Yt2N5wbR
         2RIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769649329; x=1770254129; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wDykPZ8EL1Im5WBOSDWsyNHmCwU4viR22qWxLrqJr+g=;
        b=NtzeAgKQ9KXbw/jACgLooyHqipRvH7dEmmGiCyyEfetxrWSKpuxCIUJXA6mS9FvFRR
         K2fnkoAB+630BLBgSfgGkuInZf4PXVn7YyuEAE2GbRbKFdrWInWfRwyvrMYAxc9cqFVK
         ebOoi1kaiITXRc88Q4H8oYjduHtpK0rvjw6GW9OoFM1HiFeom4hJ8kWcAV70yiD41pBX
         YUtusqR7GTlnlmrIiMRBWo/mVfpytl+m0zp0B6gHdrQg8hf2NzHjwUsmzOL9BUULoguE
         b+Rj07DijREK3PQtKIB6a2LOokO97agydLT0WQMh3n8kTqNUPMeQooR1N1Tx+3yS3VgO
         kRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649329; x=1770254129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wDykPZ8EL1Im5WBOSDWsyNHmCwU4viR22qWxLrqJr+g=;
        b=tWjwZrZji9FtCQu5DoNA1Deeq9m7LKYCgH6bryA47K04iikCaXSgllbTWOoQUmNRu3
         sZFgws4U4veUFF6yMXxB1eYoH33sHSfNsclRSYVl0FDMN3S/9cq1N2kfTB8perBaOf2o
         vTZhfTrZbC4bbrbSzFwvfm0OezVJETpy9KSbIDdVU8TGh+yweJxAC/9fsomvGGU8cypm
         G5wvgmGFM7C5UHw2OHeder8yANMAoo9fhBPxQ6kZ7dSKZJkvhvHKyGpNl8Q/ga82/NaE
         jGRRNZMOQfCGxxWsFMAdJhQp94pEWUhD+JszPRjmIdCtUxf7jsJJHWw6rsVlie20aeDd
         Gl9A==
X-Forwarded-Encrypted: i=1; AJvYcCXc6hhs/FGsqWoK1lQpr7WFsSopZe57TvqPOFwONFBWNsM7PqqTT5qXN2NT+LCsms1+M0t0yNcpKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkbiLgSYOS+WjKNpcXvLoODFzIXcem5gEwHWDQX0uD2k8ppE0o
	mIB0aPtx49XKIgVU7XlfWbpMDyDbPLv4MdtSge6rZBdGyZhiFOTlSo3lqzqTE0v6dXUiRNsiL6C
	dWaRKGzwRD33sE41At/AGrtwMeyEwEoQ=
X-Gm-Gg: AZuq6aIVNrHgirQwpOnFRkK0r0ERUjSjmiSsijCT1biWJ8pm72qCL1LA1KZXAPdZ9mA
	miFqn4j+Q274ywwaDVcbfKNdRgK5+SuBA6wxRT7d3YZI1FDdqrosGlVAwfB4MQJ6JlJEUX8J6SH
	4f3NPsJvMUQD7QC1KNmKoff36dBD/+v872w0ayouTYjUnwOWfXq1HsGnudWLC2eD2Ek5cYM6abI
	oL0wpCxAdM1cgUj6lTeKkHpkU8XuEKpYzLaGWlirYjrtcK4RxmHn6m1988+w1zI9xFEAA==
X-Received: by 2002:a05:622a:1882:b0:4d2:4df8:4cb5 with SMTP id
 d75a77b69052e-5032f76dde8mr98794071cf.4.1769649329274; Wed, 28 Jan 2026
 17:15:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-20-joannelkoong@gmail.com> <2f14fb1a-0ee2-4d86-98be-ed6112ed706d@bsbernd.com>
In-Reply-To: <2f14fb1a-0ee2-4d86-98be-ed6112ed706d@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 28 Jan 2026 17:15:18 -0800
X-Gm-Features: AZwV_QihjUupbTeTFwTH7T-OHXs2qBZqfWRz2D4du-sr6Dv92w_b7RDQ6DzSz6U
Message-ID: <CAJnrk1b6gpxyFJWe44ryvBfdJqf5h8pCQAf1vAShGqoSFw9-ng@mail.gmail.com>
Subject: Re: [PATCH v4 19/25] fuse: add io-uring kernel-managed buffer ring
To: Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, csander@purestorage.com, 
	krisman@suse.de, io-uring@vger.kernel.org, asml.silence@gmail.com, 
	xiaobing.li@samsung.com, safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11967-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
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
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 4BEC6AA8C7
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 1:44=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 1/17/26 00:30, Joanne Koong wrote:
> > Add io-uring kernel-managed buffer ring capability for fuse daemons
> > communicating through the io-uring interface.
> >
> > This has two benefits:
> > a) eliminates the overhead of pinning/unpinning user pages and
> > translating virtual addresses for every server-kernel interaction
> >
> > b) reduces the amount of memory needed for the buffers per queue and
> > allows buffers to be reused across entries. Incremental buffer
> > consumption, when added, will allow a buffer to be used across multiple
> > requests.
> >
> > Buffer ring usage is set on a per-queue basis. In order to use this, th=
e
> > daemon needs to have preregistered a kernel-managed buffer ring and a
> > fixed buffer at index 0 that will hold all the headers, and set the
> > "use_bufring" field during registration. The kernel-managed buffer ring
> > will be pinned for the lifetime of the connection.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dev_uring.c       | 412 ++++++++++++++++++++++++++++++++------
> >  fs/fuse/dev_uring_i.h     |  31 ++-
> >  include/uapi/linux/fuse.h |  15 +-
> >  3 files changed, 389 insertions(+), 69 deletions(-)
> >
> > diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> > index b57871f92d08..40e8c2e6b77c 100644
> > --- a/fs/fuse/dev_uring.c
> > +++ b/fs/fuse/dev_uring.c

> > @@ -1305,7 +1311,14 @@ struct fuse_uring_cmd_req {
> >
> >       /* queue the command is for (queue index) */
> >       uint16_t qid;
> > -     uint8_t padding[6];
> > +
> > +     union {
> > +             struct {
> > +                     uint16_t flags;
> > +             } init;
> > +     };
> > +
>
> I won't manage to review everything of this patch today, but just
> noticed this. There is already an unused flags, why don't you use that?
> I had edded it exactly for such things.

Oh nice, I missed seeing that. I'll just use that flags variable then.

Thanks,
Joanne
>
> > +     uint8_t padding[4];
> >  };
> >
> >  #endif /* _LINUX_FUSE_H */
>
> Thanks,
> Bernd

