Return-Path: <io-uring+bounces-3307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E2298643E
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 17:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0371A1F28C87
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 15:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672771AAC4;
	Wed, 25 Sep 2024 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GAHcGNsp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD181BC23;
	Wed, 25 Sep 2024 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727279816; cv=none; b=bpGlAL6Mb09sn6J0bGHd5jzc/6lgUBTQ4WuyuzMb8UutqYF6qWCQ8HortnYOKvSFJFMCX3VZB9PKhRmnUdQmUEn+rZjWcPfLs8TFNY1jc42NS8MSuHlhUESyyd+RsNNx3nDBIN4C9CiZYLH443fUX/XVagEW6w0Q3TolHa+ywgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727279816; c=relaxed/simple;
	bh=5OUE80WtU0P2alzw7pidUQvYWCHPiDGNs8PM/oEiQK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O+sbFUdSSRNSyQ63+9uiNoQrt1rBYgIHpXJ+z+bHto6B36IUPcQszobjBny9mDjrvfkkih7HHW3CjU387mPnf9uWsjKupNEkdXrBKiedEb0O/fooCn6tQl5Z8TC0QolhvI2++DN+lOG7u8BQW1EbCe7PNYKdX5H4189dbMG4tkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GAHcGNsp; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5365aa568ceso24371e87.0;
        Wed, 25 Sep 2024 08:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727279813; x=1727884613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OUE80WtU0P2alzw7pidUQvYWCHPiDGNs8PM/oEiQK8=;
        b=GAHcGNspvNOOZN4pr7h8DGjOX4a+OHYjRbM0m0KGbwq6MT/ZPaDo3irqFQAZcjT4u3
         hX0pXr9AtSbByQuL8dvSm5hOjLY2E3rup3XRbFhw/yF5N8/N8SowBGI1X5HAsmZgJnyM
         OhQ23KnIyAhiFKE5JtWS00ERhdXlhq+WdwpA4t3Pqvvaa/UurLqbL2dPkoA9gNG17ORR
         tpYhBf/4q/pcgtUnK7BA1K9YsZNRkwO9l1M2YhKZMngIomAxBXnHKRSDjMHMb2ci0WI3
         T+ppoBNaV01zct+vw5wSINIfL7ETEjb38DRxg55HFY0wnAY9/8q0nSZC1VgQ92y/nw8S
         H+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727279813; x=1727884613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5OUE80WtU0P2alzw7pidUQvYWCHPiDGNs8PM/oEiQK8=;
        b=QefLNKmeh+cc/OhUtUoQYFKjcPKwtduMGItd1Rk9eamk8s7RrTMSmiLpogNjkpj3Ge
         gjpDQEJMxbfqsXr5a4X15uNx0qW5Yks332MeL0qYLPtsN/gwoOHAuHiv2VRVCSmkqpHt
         y/Q8uZ1txd0K0AUEJmu3GXnL0xmSLmQSYqcJj7PCbpUw3MbzyQ/jSWXuR1+m9PeFAEHb
         Tn5yCy7KT9UuWPs1NJBqRxbd8FsooavmHE+W2yfDQB1/5wN401ixUsg0h+rXlEM1884G
         L2JtaEP9xv72DlgQFwb2ccMd8lOBXvOsAuLCpbwYK7axSTQe4cW3ponJ9ihxfCWIRiBr
         /Q5g==
X-Forwarded-Encrypted: i=1; AJvYcCUg8i18PulqKPnwiF1D6g9g8pdBfyrCrxCbGVO5S1XcbUGdPgvKP4maKFvfaMDGAPwGJaJh92eHMYlmS+kL@vger.kernel.org, AJvYcCVjr5vYEErFNoTy4toA7klY9WQv+HkgwW/5PQvM5tAU1fjU6wF081OwHlROx9SDllTVr5FcocCfvJNArNmBFQ==@vger.kernel.org, AJvYcCX9m1jgtRlB8klbEaYQb/c6v92gef2KbxZi//mf9P7kTv7+hegqRMZogYLb0n6KnOlcls/r/GH6yw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRmM7MqPPOw5wm2ZuZU5WxslJj2zbdk7xzB1yCiLMOaGlt4erM
	v0KYpvDmgz3wgepyGkUz5bWbSSpxX58alJ68KprIXvQywmpGAJWo8KPxKabNly4bAbYv6AQ8ODt
	sQSjLm9BD9BtC3phWgr0BQq2Oo+I=
X-Google-Smtp-Source: AGHT+IFdEcDsvri2q6U3WW1OBmRMf60+DtFuTxhJJuwUKPa6CEiFG2mxuppBB82HSIGEhIhVV0fcvjyRAZVHKcFLOjw=
X-Received: by 2002:a05:6512:124b:b0:52c:e10b:cb33 with SMTP id
 2adb3069b0e04-5387756630cmr2857168e87.50.1727279812232; Wed, 25 Sep 2024
 08:56:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625151807.620812-1-mjguzik@gmail.com> <6afb4e1e2bad540dcb4790170c42f38a95d369bb.camel@xry111.site>
In-Reply-To: <6afb4e1e2bad540dcb4790170c42f38a95d369bb.camel@xry111.site>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 25 Sep 2024 17:56:40 +0200
Message-ID: <CAGudoHFrTWktBYQjrQMJbVZvWLPD3A51YsOMOJqAtpdruSkGsQ@mail.gmail.com>
Subject: Re: [PATCH v3] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>
Cc: brauner@kernel.org, Miao Wang <shankerwangmiao@gmail.com>, viro@zeniv.linux.org.uk, 
	jack@suse.cz, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 4:30=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
> There's a special case, AT_FDCWD + NULL + AT_EMPTY_PATH, still resulting
> EFAULT, while AT_FDCWD + "" + AT_EMPTY_PATH is OK (returning the stat of
> current directory).
>
> I know allowing NULL with AT_FDCWD won't produce any performance gain,
> but it seems the difference would make the document of the API more
> nasty.
>
> So is it acceptable to make the kernel "hide" this difference, i.e.
> accept AT_FDCWD + NULL + AT_EMPTY_PATH as-is AT_FDCWD + "" +
> AT_EMPTY_PATH?
>

huh, that indeed makes sense to add. kind of weird this was not sorted
out at the time, but i'm not going to pointer a finger at myself :) so
ACK from me as far as the idea goes

I presume you can do the honors? :)

--=20
Mateusz Guzik <mjguzik gmail.com>

