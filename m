Return-Path: <io-uring+bounces-12087-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KOsfGEWGhmn7OQQAu9opvQ
	(envelope-from <io-uring+bounces-12087-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 07 Feb 2026 01:24:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B9220104468
	for <lists+io-uring@lfdr.de>; Sat, 07 Feb 2026 01:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B10A3029E4B
	for <lists+io-uring@lfdr.de>; Sat,  7 Feb 2026 00:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01841E1DE9;
	Sat,  7 Feb 2026 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8TSQrwK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90211A9FAF
	for <io-uring@vger.kernel.org>; Sat,  7 Feb 2026 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770423874; cv=pass; b=WpDzahJ1ROlJOcScTEr7G6vqj4fbcsEhkh6L65G55L80jBUghJDKMs3/WdRjfcOxUhkXJZCCqjOj86WHs3OfuHTWTiCeRkNhpFdlnDmDPfw559yIjh7Ple3equu7sVsPdU1RTDV4rpOvUNrBoG26X9BMRMOw8C8kgshtn848ql0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770423874; c=relaxed/simple;
	bh=nz/X6BTvr+nL3B3hjTqOBHfNkcoeCHJoAFxDQVFk7AE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j1ffHsD1TpfuoP2yzKLO7oOOTcIrOpKukkmbJp1/TG3kkrVTXc0ohNPxxvVw2TuTGpjfVMbjjmKlXtspS8zYa+hNkYmhAxo4+UpInP67fqJHgS7EgyU2dmrYlX6ilK5xClGlkjTw/BZ00cfEzyeCG5E+VXXNISguVgoIuqtPsSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h8TSQrwK; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-894676e6863so29184866d6.2
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 16:24:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770423874; cv=none;
        d=google.com; s=arc-20240605;
        b=M4qCqwLCSoYRtE+EvMnlLQzk0X2DVpIwoQ4YlWz2Ac2u1AJdjc2wc5um+sX3+rHc32
         deyZQVfrS7W63M8i8C6+NSxtWNLwMvuBp2bPm4yJY5qKseVpw3SAcJ7LQZL/4uj1pA8y
         m8/vTJat+mSToa7vLGO75lzVSUWi2aD2wBdzTUH9QUGzxv+sFSediQfsL9TiK/Oes9ua
         CKXRMoysYIae+ImaZsNuKwGYb+dzPEDAHwxrGQ2Dpi0LY7TERESykeMjmtxRxx4voE+G
         BHzALdr0s56kwxT6H94HLyAh1G9LngPh8IqTXOaA3ogDKdfGC0Geulb6bpi3FQPLH4ka
         G8uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nz/X6BTvr+nL3B3hjTqOBHfNkcoeCHJoAFxDQVFk7AE=;
        fh=l8c0ch5avfYSzvxrWr+qlXhQuJ/qOHh2q+Ka+X+sGxE=;
        b=DFXajLGUs7lZzP4cWsA0KSeJd2Dj7tE2LUgjROMaFx/8o2adWt5vHUYsdHJ15LSwUw
         ASTaNyjKw6Vm7OdlHcCZpGiER8cedBIB1zijvWxWN3iLVYwjNHLlk3hErKYU8RFdBdCG
         gtDgf1oUFVl8kQTJMpN4Bd/a5KhFzN63Pr93l1GXOiiydFAB2e5YDm8ewR2/Ouz7fzHO
         lHtilk4GjZzQXJWv2+bSbnOxhib44WRgbq45hNA20WqC5xhQrb1VriWP3MyfxWpY7Rud
         16T1ATU9c9d4fHSva98z2PFEiZSPeoXwhZAejZ+TtaWAgRpDStNr9jUJCWgiYjCBGPeW
         mPUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770423874; x=1771028674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nz/X6BTvr+nL3B3hjTqOBHfNkcoeCHJoAFxDQVFk7AE=;
        b=h8TSQrwKj071jpHdqpAZ6FqpsWwGYuu18s9LA20Fg2mFmqADrOC3byZ0e5iELbpIOE
         RbwQIJgmPzTPV8gFxvelENrMrqPjUwWw6vyFOf0H+OFkXCKLJBrMcZohbXV59bZPHvuR
         5VKHFv6Qn09GRnDemMHW2l19GaB9SB/c0U9cmxuzFtE6vcIopcqOmjS1Jt8q0aOWvxBY
         9LyJBkidnXjC2JAQgxpRLn7/dqvM3LgGKf8GpTGo4+OCgBDeqeIqWK07wXAXJIpMxIuS
         2Kro9yagOoJDg9S1FEzFy97+hYVmkdyeBrDb/YKQvH33/s+D9zeJcZZH3Zas8OA3RTmR
         6+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770423874; x=1771028674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nz/X6BTvr+nL3B3hjTqOBHfNkcoeCHJoAFxDQVFk7AE=;
        b=q+EOSpGpzqIYifzldyQCgCYjNgxgr8RhS1VfhEj9GmgmSdbXFP4qpu9ZuO1wk57Tmv
         wJz30nyLNFNsl5lRmcjWVCiB1bRwHdCTUDeuxP2d1o1jrWMzePhDGdf3Cmo9ujy0jQYP
         Pddauuc658WecLmpzOfajwRIn7q1tkMxpWNuWMT/B3fqmhXN/jDVb0LPTYx8eQWFdJg4
         mOxrQ9/3pYOvdKJ701AEvsnzBedi1Whn09MSvPXi9x4GN/n/D36ymA+uCiB2gDEgP66D
         9id7baNH9xG0JLS+zNOIPmxoyf8ZENFd5OJZbbsAfmzUigD4zUl7OAgRDt1/dwQEz1Tz
         UoCw==
X-Forwarded-Encrypted: i=1; AJvYcCUiWTnu0n2VTDmiONkVJe0XtNW+BfSUe+xFnK1BYS8GaJ7uE5TBCkKWlHiiyZdZf2GEf41+9cV5qg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJgcGZRXWv6sW1ei3TSs8eFHjgFmoX7mTKV86Y3HnJmRnPyg9/
	deI6VulZ+SIis6NJLQmu83oItAnBHCuNf1l+KH2Nuq5KBtwmaQgbMnsZ87+vAtHU9KJ1DHONh5I
	P0vlEpSC+zHR8uwe4qz9YfDNh8xNicYI=
X-Gm-Gg: AZuq6aK8CmvgM+65rhIku/XORHDnCI16ysUvqskNA3q01sPAha6D6OvTcpIxrAEtWgf
	HAUO30yXa13WL7RfKXIl/hU2jMKKnRnVsVfeFNcLZG84lwjOr3A6zGl3xbxx35kQWulDUtJZgv8
	ZGHioh5a7+/ZYqVpX/l27uzjtcWMADkJlkEJYRqckuZbZ+uzut26d+1k+IjE5rlNr2UB9xoYTuZ
	7Kl3Rowr5KNZsuU2lzFC4xb22aEn9xy9vl/esURZEaljxb1Pyw+gfgnoBzFrqTyJY1Vqg==
X-Received: by 2002:ad4:5d66:0:b0:890:65fa:1ec2 with SMTP id
 6a1803df08f44-8953c7f44f3mr64930806d6.29.1770423873655; Fri, 06 Feb 2026
 16:24:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com> <aYWbXV9pfyLwfy-t@infradead.org>
In-Reply-To: <aYWbXV9pfyLwfy-t@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 6 Feb 2026 16:24:22 -0800
X-Gm-Features: AZwV_QjQPVTnRHLmKm2-KYoVtk3n3ilApukoJS2L6ExyYn8j59z2lc-kHUOdX6M
Message-ID: <CAJnrk1aQ2aQ9NZyGkrXGH78j+dKPfN7cHnp+GxtMriKh9h=-Bg@mail.gmail.com>
Subject: Re: [PATCH v4 00/25] fuse/io-uring: add kernel-managed buffer rings
 and zero-copy
To: Christoph Hellwig <hch@infradead.org>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	TAGGED_FROM(0.00)[bounces-12087-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: B9220104468
X-Rspamd-Action: no action

On Thu, Feb 5, 2026 at 11:42=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Jan 16, 2026 at 03:30:19PM -0800, Joanne Koong wrote:
> > This series adds buffer ring and zero-copy capabilities to fuse over io=
-uring.
> > This requires adding a new kernel-managed buf (kmbuf) ring type to io-u=
ring
> > where the buffers are provided and managed by the kernel instead of by
> > userspace.
> >
> > On the io-uring side, the kmbuf interface is basically identical to pbu=
fs.
> > They differ mostly in how the memory region is set up and whether it is
> > userspace or kernel that recycles back the buffer. Internally, the
> > IOBL_KERNEL_MANAGED flag is used to mark the buffer ring as kernel-mana=
ged.
>
> Can you split that series out as it also has other applications
> and smaller series might be easier to review?

I'll split this out and send it by itself.

Thanks,
Joanne
>

