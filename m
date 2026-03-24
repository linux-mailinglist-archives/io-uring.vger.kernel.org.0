Return-Path: <io-uring+bounces-12840-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJx7LmULw2lKnwQAu9opvQ
	(envelope-from <io-uring+bounces-12840-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:08:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3659431D22E
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD8D03154B3F
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 22:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867CF351C21;
	Tue, 24 Mar 2026 22:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cb9FwVPd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044B235F5E6
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774389930; cv=pass; b=GoKqtMgGoGkWMVhCp8CZ5sbxJFEKPwcLVS9i2hwbRU3mE4Yp6GFejiVJ9+Si181B12ZZVP7mwIdL5WHgsVseeB2JZvIji6gvNmAsrwBcYUFRKD8X7+vlBDb5AXgZXUC3vUFUM8/WPdtSOTEpC+q1vMydvoz13JxXMPMrecZp+Wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774389930; c=relaxed/simple;
	bh=+kxv0wXIUDjV7iTNPPkhuARRmoOcHvfdH5z0c4sP5pU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=foXKKv74HyBWqa/5MshMilCTwgXgj0ykNrBzsYIclMGH02hGQ4KzIeYtokDRFzNxIPeR1vw+dP8zIvFqmfmNt9U6S/Vkb0tcXUfZ0Q27zzrnAxtrbrlD2M5dA3iWBFigiFmn6RrP9fHN+hDqAkg0wn0FY2N0Aa8IO4biXilWoBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cb9FwVPd; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4852afd42ceso13434935e9.2
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 15:05:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774389927; cv=none;
        d=google.com; s=arc-20240605;
        b=LI2BIBXsF+FktjiWvwmDhXu1ENVjYToHKwKE8t0/j1j45WdUAyAC8i/ZkzfpTu02Mk
         6+XdiFteIgUks+LIQ3p1z5exYWwqO+DVSD6DOPzJFkO4AWrkuP2rUNqPLe/KFqrwHM8I
         LPnGIjrNw/xt+u6FYicL13y+MuAVssEXGxv0HwEhH20Ufeuf7qxC5KqKU6RODrzcX0qV
         xtdmGJzN3vOkgkBO86UPz82A5cnnPDt8nQCPH5pBOJoBiFGmjzUJt2+PmsZLBbLSHsVp
         /tAFgQeukUg1FGxhjH06X3NU4WNXBtvcgAc/UJJtHdB3ZFJ42ch4lK/J+oxR0JXOPvJP
         6hdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yCEdTHT2+JZwmHJzsRjulCLmjv3YxefFaE+zjxTqTPs=;
        fh=JyXrguY4lWvykBv/ms1U6M0L7PxTJyRhoQZYUbv0zik=;
        b=NL0BsXJ0uvcwZbkSburPw/wD700mOiVtygqFmMc5w3JovxItekKj/V3EDRWW4DgdP9
         u8JTyBb0fF/h1mNzNJ4nkQhxoqpOkBNmvBvyZdJT60+GeSfWWuhKns1NMuStHqwInmMg
         6DzZPLQAoY4qGs2mG6EcTO2KM74VijBLJh7lN+q4zlJZNgL7SWqcMe9EjpVN7YYUDO6R
         Iz6PNAqWmFzOZC5/hJKLLYUiS+UzIhsqq7VGmSUcd739jTuWMw+eOSAcoELrF1ICoW3x
         lN27/VOTt0rvnu7LUtEF0kPf8HhCPqbAdTsciH7Y16jXPJ5ZQD29dWHT1Uz3KKFP7aiT
         DNVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774389927; x=1774994727; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCEdTHT2+JZwmHJzsRjulCLmjv3YxefFaE+zjxTqTPs=;
        b=cb9FwVPdqzSSS+X67B6x/hh0BUWPHgqYDhtEB9kc6rVAUNk4pP6ByGh7NaiwA4ldOh
         lutV56y6GGFLmJjFd4sIy2U+BvCV3o9jZEMnkSv17Uql5OKJkXDHIzse6RvNcAp17Z3F
         616vkYEA8mO4nzUDIb8yaoYaILFL6SWhx2UgZeL8j0DcYRh9r863cmWRLQzD6rhPi3ni
         8E3TFCiWXMZdOD0Hek1xJrjZy9Jahl+UmoTpRpHakLVQLoCXSv7BXFoZy3SNjtqtEhFO
         sce7M0zNN+FNvChGypCumOSyZjV335gD5Xskxo+5ErNzusV9Mo1PrbQofqo4uvrBQ46W
         QpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774389927; x=1774994727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yCEdTHT2+JZwmHJzsRjulCLmjv3YxefFaE+zjxTqTPs=;
        b=cfpu5PmpkVzE3BbKvZ7OXeOi28/T8ie3jV9PC3b9Utm8jiRNEuDRghtA8KxF63Nz6T
         pmyCc8dp0/BivAFxuMT7IoPAoiuiNAwkK4No/9+1ov7Pkq6YmF3lBUGawuKwMl3s8RCZ
         JmPYUIR34VDf2KqxUmolx4jdD+Vqgi8N533cT8BR8TK7ATFRBpDMpvq/zLdg4NrHFAAH
         5Uzsxx9ZuCiuALK2f+gBeK5c1ARWTqV3FN5cegEiBzvqL1wPj+Q4R4HmnLw3JqVp6pQS
         et+um6E08KGeiLdcHinfarGSwLFCgISa6r8FNJ97dsvbg71izqiPTjFl2MRoIh+9FSlh
         9ZDA==
X-Forwarded-Encrypted: i=1; AJvYcCWFRN5oIoqNp3SJYmwafsSo/5o2A2kaeGP8VE6aVQcBiCPVuHNSneIPvJPhNbpynUhlqcapDTP8CA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRokJhkO0CeiRHf7BIzpNm4eQKFkrvy3ohZzIIx2FnP2kaKfm9
	brJlqyQhYtmLOR/Qw91lcBhmw/+yWPZPmMpAyseL4rV/jqoUzrUJujpNGY2Rd89b5eg8IqZzvnr
	gfiEW84m0gP4Lqn2aHec9OwtzNK4pT68=
X-Gm-Gg: ATEYQzzG7bt8zK4qZL9YaSHO4YMWR+aZZQ5nAibddTasKTf/ph32vaXYwGy2uYNgmhr
	VQMPDxFlMzy+lURl1VROfT2mwZoTRJVKzPLENID2v1g9NCzvTt8xOcVkgwV77B2w90r8v2XGLmq
	4WWNclQhb0AKUzhwNShcq4Z4nF/oYKYENtPcLo6SoEA48fGKjdlpPH+ixsrgWjwYXDSLRwGgjAE
	xIQwHIPCpjSEbWm0DB5P/x4JD2eFJCe70YEj0GDzCUXuER/uOQKhc5yP3rZsM/pGreBnDObbDS+
	D4JvGw==
X-Received: by 2002:a05:600c:524e:b0:486:fe45:483 with SMTP id
 5b1f17b1804b1-4871605078fmr18851185e9.22.1774389927212; Tue, 24 Mar 2026
 15:05:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324182157.990864-1-joannelkoong@gmail.com> <20260324182157.990864-4-joannelkoong@gmail.com>
In-Reply-To: <20260324182157.990864-4-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 24 Mar 2026 15:05:16 -0700
X-Gm-Features: AQROBzCznm7IBQwDXVBDZTeu9n7xpxKweaPPNA4XIPo7YK8fmp_zlgVOQw6M4T8
Message-ID: <CAJnrk1aCevas2+r63hzwr67_phEfZC=TKE-n8ARbUsm9Wx71dA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] io_uring/rsrc: allow buffer release callback to be optional
To: axboe@kernel.dk
Cc: csander@purestorage.com, asml.silence@gmail.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12840-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,purestorage.com:email]
X-Rspamd-Queue-Id: 3659431D22E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 24, 2026 at 11:22=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> This is a preparatory patch for supporting kernel-populated buffers in
> fuse io-uring, which does not need a release callback.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/rsrc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 01c3619e5f07..73ee03f85509 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -133,7 +133,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, =
struct io_mapped_ubuf *imu)
>
>         if (imu->acct_pages)
>                 io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pa=
ges);
> -       imu->release(imu->priv);
> +       if (imu->release)
> +               imu->release(imu->priv);
>         io_free_imu(ctx, imu);
>  }

I'm going to drop this patch. While going over the fuse side of
things, I realized there's the possibiltiy of spontaneous unmounts
(which even with privileged servers can happen while non-fuse io-uring
requests are inflight). fuse will need to grab and release refcounts
on the underlying pages.

I'll submit a new v3 with this change (and with an added patch that
exports IO_IMU_DEST/IO_IMU_SOURCE), sorry for the noise. The fuse
changes that depend on this series will be submitted shortly
thereafter.

Thanks,
Joanne



>
> --
> 2.52.0
>

