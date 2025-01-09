Return-Path: <io-uring+bounces-5791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22782A07F76
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 19:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3D7A188A4AD
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 18:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B80198E77;
	Thu,  9 Jan 2025 18:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXJVC9TE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353901891A8;
	Thu,  9 Jan 2025 18:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736445964; cv=none; b=VvHEyCfUg876uGgrEmYxXy8UlEdiwWGoaWWMkr5oFovrJb2FwTebjDin5EpnoVGYN28ukq2myVh045svMJRL8JsE63HRfqjdXQUl0H7gIUF9MzCVFKBKpnJjQbHKPxKz4Cwf4idIawEkLnve+ppo6OhZbiIIU0jjqIZfLC+2X38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736445964; c=relaxed/simple;
	bh=rp9xKD+8m1msQ0xxbCs9oZzFyU1GURrqUZhq3NbpvyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VZDfMAbOVoBTLRuPumm/61F/h2i1GJZRnbEgzMhnss0baXDo1f0XYOpYBi4tzja4LFrqQzafYP5JJv1S7AdbWgoNz5EGEy4gUerg2ncDitCupUAfGFl3lErZBMARDgI5diRRJnipAROC50bHeFT1zHg9fSZZr/jK+qNPqzMkH2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXJVC9TE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C334DC4CEE4;
	Thu,  9 Jan 2025 18:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736445963;
	bh=rp9xKD+8m1msQ0xxbCs9oZzFyU1GURrqUZhq3NbpvyQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hXJVC9TEna9TWYKbS9F02aIUvOHalq4E7m1+cvMk0ArDdbnyNkOQeESQ7Ur7QTEYq
	 oV3fJnNHiU6ugTU9/tuOjHdJ9qaR831jsML8BcJ2B2+uzRQfA4kpmr3AmZ+XqRvw70
	 BTN8HX8ggLtR2WOIhN2X2Ipa4OKa5qs1wwTNGfy1p+9su4jHqsiWIAwGFmgaxU7Nfw
	 H9Abn1fQ/2SPP2QU6lVw0EYHITfjtwSWp9wIQJbaVZRVNv4TDYE1jWwRNuescPEqI8
	 vYK392uOFALwuMqP1HoC1bERclFcBuYV7fmAeGJqkaXECHPwUoHQw9LVho0fFgK9tk
	 fJ+fXn+JQWXLQ==
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-844e61f3902so84636339f.0;
        Thu, 09 Jan 2025 10:06:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU7vJw0Yhmq1HoAJE/OsvsfkQbIo3Qpr1D+sW06TxmQ5b/DqPayTYNKisT6YlckhoJ/IfnE5UGOvIbJrutD@vger.kernel.org, AJvYcCUKdmxyZjBp3BN7k7bDpN4N42WSL1faJzx46lngDyuVmFlNTI2wAZ/leYEmL86hu//fxZPWQhEABSYGBg==@vger.kernel.org, AJvYcCULY3K6q3eLHaJUinkOdCYzYWWRKDGEXIaMe8mEfRkN7N0K8Ln5LelCSICnWBP+PVw21khAYRY0I/yXGM34ex8875Lt@vger.kernel.org, AJvYcCVCk/MjPKokyvIFdvJp7RsCvf++XNAKuITebk7mFTLuT4l7VFi6vfvJas82zOGLosM7pdOUakoKNiRPAVV1L9BY@vger.kernel.org, AJvYcCVFFZUa45jD1kY7O9eFU5SsUOqiXanSiyk6iItfL/7JIGCYDwQAnECEOmbGSW/J+JeHcB6lQHM7lC43jd5b@vger.kernel.org, AJvYcCVKb72VeDQU6u4ACgTVz6YEQ9f7JtoFU9ctAvBDnt3aKvFaKQ54WshcK/7b9jpNv5D7FWre/NxGxAk=@vger.kernel.org, AJvYcCWSrc8M6fjpLnYyFHGOEb0RYL+mB/Fgxv1FV7zmoLzsAJ/Wtn0fIkCarRXTIngSvrano0x6/jdeyxsYuYEC@vger.kernel.org, AJvYcCWtgvWJyxsKGbn8X+vDuQqN1WrpeWmOWctnx7Ti3HzLu15h1v1usBlf1r3HeMsvDVagzn8TvL7uzPxfkw==@vger.kernel.org, AJvYcCX1Empd1OmdV4QaxGiw76Wp2zNEdc/H8iMRZeDlhlVKhz+vvxL6oJW0ZpjcVO3ki6VJyF8ALxZck6AoB/K1dw==@vger.kernel.org, AJvY
 cCXCdgnNYyUlkiKT78jlZjfznht9f2JVWR1FljjRzn/hSF7yDBGVSj/joJqZdFNNQVpgo7plN3gnyhdWbQ==@vger.kernel.org, AJvYcCXFAQPNv8JtV7Wufe/McLhaGMCOYYMEUuHAmDXIIawBAvL4rUEOqJWikiBGT1GQ0wOeS3/g9CdYIF2h@vger.kernel.org, AJvYcCXGtnrLPWgALgr4QfzQA/NmEN6VmXmCX3wvTuErCHMi7SS8EiHmFcpyctKEJjF0V//QHSPsdom+rrFL3VKS@vger.kernel.org, AJvYcCXIzeaTKwsRbHvTyT2sT4J+p6Lh7htnXdaRITEsFqjlkKr7xu+q6+m2LKFK5/i2uR/Qu6E=@vger.kernel.org, AJvYcCXTsx3jAkPtqX7iahsPp8jY9cpP/DM984HqW5e5UUcTmN4TWdk2KDFO+cbAx2jA6Ae3+lm91tc+D1yVGg==@vger.kernel.org, AJvYcCXZ70fEeI70dxqfxPZVy8gOKyomd4lrw3DiPAmwp8fv74mTYEvvhCkSKuLewpzIZgciA3MiXVGc2Ys=@vger.kernel.org, AJvYcCXkhvwjOgsaIzBVYWxnjX61N5K2at4QUYgwmwKHhktkaridkUeBV6OMnzfq0vd6TMRwa9M/P7iyAql4@vger.kernel.org, AJvYcCXrcdxhbTsLKpwI1RIN5zp6raljAefAN4PXOQoTv2fBw5HAHfCD7FvZy5vJWBmhGWDqwVNFKpR8Co/lYKYTnT8acJP5/X5U@vger.kernel.org
X-Gm-Message-State: AOJu0YwAA8huuUN4T/BErSHEBklOz+LJ/qJkbUPu2hkdEypz5WdiISEO
	+iw2r5548Ec7U0VJ51OVdV81QeQasNe8w7IkhP5T2gqDd/c925a0zD8/6rhvfa+CwPjO/nxhtxn
	OkxDxrMGctxtZtN+RNCllTsC25ns=
X-Google-Smtp-Source: AGHT+IHw82IqZn0L3vIWI2GRAE2/Fu1vkOzFuTOkK3ccul7HxPp7E2ac95iMCNTUN8mztI4YyZ2Kf9FZUsicSlonzfg=
X-Received: by 2002:a05:6e02:3048:b0:3a7:6a98:3fdf with SMTP id
 e9e14a558f8ab-3ce3a9da817mr60484875ab.14.1736445963152; Thu, 09 Jan 2025
 10:06:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
In-Reply-To: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 9 Jan 2025 10:05:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5zpA28gkBQYMMuYCUbnDzdeq4pHsd0Mx=PBnDPiHKqHw@mail.gmail.com>
X-Gm-Features: AbW1kvZZD8oqcdTZ9DXv7tEUC7bpyqeBsuw6nnhXboAE2kNg_1eTiibnv93HXj8
Message-ID: <CAPhsuW5zpA28gkBQYMMuYCUbnDzdeq4pHsd0Mx=PBnDPiHKqHw@mail.gmail.com>
Subject: Re: [PATCH] treewide: const qualify ctl_tables where applicable
To: Joel Granados <joel.granados@kernel.org>
Cc: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
	Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, 
	openipmi-developer@lists.sourceforge.net, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, 
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, 
	kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 5:16=E2=80=AFAM Joel Granados <joel.granados@kernel.=
org> wrote:
>
[...]
>  drivers/base/firmware_loader/fallback_table.c | 2 +-
>  drivers/cdrom/cdrom.c                         | 2 +-
>  drivers/char/hpet.c                           | 2 +-
>  drivers/char/ipmi/ipmi_poweroff.c             | 2 +-
>  drivers/char/random.c                         | 2 +-
>  drivers/gpu/drm/i915/i915_perf.c              | 2 +-
>  drivers/gpu/drm/xe/xe_observation.c           | 2 +-
>  drivers/hv/hv_common.c                        | 2 +-
>  drivers/infiniband/core/iwcm.c                | 2 +-
>  drivers/infiniband/core/ucma.c                | 2 +-
>  drivers/macintosh/mac_hid.c                   | 2 +-
>  drivers/md/md.c                               | 2 +-

For md bits:

Reviewed-by: Song Liu <song@kernel.org>

Thanks,
Song

[...]

