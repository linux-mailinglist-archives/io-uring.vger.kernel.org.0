Return-Path: <io-uring+bounces-3654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD6199C866
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 13:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEC34B29B28
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 11:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F52E4F21D;
	Mon, 14 Oct 2024 11:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="PZTH+pTC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7000132117
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 11:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904220; cv=none; b=aMXgXuW5TpEMmWHRWqq64lOslidv7FljWLkfMiPC6RvbcuwsveG7+EFSAs+rXGH/k3S+4Dzxul9Ty48I4ninbVJgy/1Owj/SIPi9jojEn45chzhvyDkpZSo+aSs7Go/RgiC/oWMzGpOt2ltkcf46EyYO+0QoB87TAj4yKVq4APc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904220; c=relaxed/simple;
	bh=X7hdAnDBRiFsp9pbNfm20bLF2XQDquP+h05zZKrsk84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nXkiHgvBdBkuwcj++UMZ18H5c+XxxBzziZikFUKXlWCx4raX3jhkB6Wiz/s2vI7FcOrI/QS7Y2qwAh3b6UqaiO5sKeqHjTfofIzCycEnUKVK7i/Cp18iRVWVmlwDjxccHiWbeWek8PyZ7BW9gCc1mWOJ8Cl62zN/+CNyB4KCgnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=PZTH+pTC; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9a16b310f5so64816666b.0
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 04:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1728904216; x=1729509016; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6wbDQEArnf1ZdmErEiHxbx7TqihEustaC3F8orDhSIE=;
        b=PZTH+pTCej4ccopCdH3z7Ob62ToJR5ptIHxW+GjNhPSSzvfbhMtosVwD/1OIJfrEc8
         V74vHR/GgKm8GQwFFYTxfNO1JC2b/2nZWuxiSwR8Qmeb7DQA21ptQcdA9Zl5bcHgvqZB
         6Lrb58Qm9EnzXK1XiMRJb3Mz5t9JDcZy+2bDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728904216; x=1729509016;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6wbDQEArnf1ZdmErEiHxbx7TqihEustaC3F8orDhSIE=;
        b=KRwXGN+nvcaeeJOvfFtOLypaOSZKuUsM49+uw2WcLG8hnps6dFt2S3fgQPBotOs0Z/
         qbaYw6QTZHYUUVtHTGLbk+xLRQ4eZ+Md6GOTmQxejC/0zzZvzBj1GJzgYVavjtfAYXjb
         MhF0FTA3CJVzm0RzWbpGUj6Q8fxXeE+mEeEKP613QkjXsVR+W3M43KrpJQHGYfs/FDwe
         GgHER1blSkKCqABtBvbbO2HR97GmWcAcOYLp1RKopsu4tSk+kIA0Fqnw47Q01nEJOJh4
         dLCnSToIE77ZngEY7hUMAnQkH08H5MLVKOfVA0qn1JDdVa51EPgOgYNrfabpFw7UvSTW
         bxsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVf9b5bzbhwDKU2XHeb8IE6xMghJIN6QAQ8hQ0LN1cipDUek21Ha1JEVfnYpniwudoe29/S9dQi1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCNuEZxAej3u/S1msGdHgWb1GVPS2aBn6MB1AUkVo07fJPYKPC
	8qkzAi968PXVJPLASZPwZ9VGDzXWb9lUPyl5qlOR8ElPANUB2t58JQitDy25tUALaWkcBMwjo3B
	adFsF/q/JMcE/2RmMmnz9D3g7kBl9LY4qN5gBkg==
X-Google-Smtp-Source: AGHT+IFAyxM0Dt6COqUymhWCRvHXs1qGGQcy/B4h6XwURk+SCiv6QGQD0USpvcL7z7VI7PcJJpRRSLNh4p9aFeHqQZ0=
X-Received: by 2002:a17:906:c14b:b0:a99:625d:22a6 with SMTP id
 a640c23a62f3a-a99b970bbc7mr957933866b.55.1728904215575; Mon, 14 Oct 2024
 04:10:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk> <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm>
 <ZwyFke6PayyOznP_@fedora>
In-Reply-To: <ZwyFke6PayyOznP_@fedora>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Oct 2024 13:10:03 +0200
Message-ID: <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
Subject: Re: Large CQE for fuse headers
To: Ming Lei <tom.leiming@gmail.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, Jens Axboe <axboe@kernel.dk>, 
	io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Oct 2024 at 04:44, Ming Lei <tom.leiming@gmail.com> wrote:

> It also depends on how fuse user code consumes the big CQE payload, if
> fuse header needs to keep in memory a bit long, you may have to copy it
> somewhere for post-processing since io_uring(kernel) needs CQE to be
> returned back asap.

Yes.

I'm not quite sure how the libfuse interface will work to accommodate
this.  Currently if the server needs to delay the processing of a
request it would have to copy all arguments, since validity will not
be guaranteed after the callback returns.  With the io_uring
infrastructure the headers would need to be copied, but the data
buffer would be per-request and would not need copying.  This is
relaxing a requirement so existing servers would continue to work
fine, but would not be able to take full advantage of the multi-buffer
design.

Bernd do you have an idea how this would work?

Thanks,
Miklos

