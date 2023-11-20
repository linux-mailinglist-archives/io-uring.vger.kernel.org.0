Return-Path: <io-uring+bounces-104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CEE87F18B2
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 17:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7522CB20F04
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 16:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0C91CAA3;
	Mon, 20 Nov 2023 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gp6hnjM0"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE8A93
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 08:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700498101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZvczFxIKyKy6D2excjoW9QSNl/x+SIklQ2YwnPNLtE=;
	b=Gp6hnjM0nN5WIinUdZ4cQMP6wxHtovXz9KVCpDQaJCS2IpCJX+puH/uQKYWv682IAJ7CzP
	ou+BB5AafrrquIRtDCu6pHRlSf59K6OP3hQjEcZlHYFhpq6tiPsQo50vQzBt+6C7xIeoae
	TuRQFlOoCu/YXbiD4yiWzZUT3HBzUVY=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-czGFX-P5OWKtzLbbp5iuoA-1; Mon, 20 Nov 2023 11:35:00 -0500
X-MC-Unique: czGFX-P5OWKtzLbbp5iuoA-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-589f2897a46so4360471eaf.2
        for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 08:35:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700498099; x=1701102899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RZvczFxIKyKy6D2excjoW9QSNl/x+SIklQ2YwnPNLtE=;
        b=LD2qQIaNbtSmcIpqhpV1yynVp5IKFvP09moAILXXxRMssyC63NTMua2SlcUCBMj6TF
         /Xmbv0HSftg7ZcnSGOlG0jk+b9LyCFXkK2Nrs6CKryof1nuZkoFAN83NHp4DVs40W51l
         BJJ4lvnGk58OEccs5Rf7BwDoZ0zMjn0fSpyyI72CNMWM+bmMROvThwveQoADv7C9fp4d
         j06nL1E5nlHqWVeITMFJaES5uxdgHRaeB3aLXnKP7TOX196UBjKburYWhAX18EFmxUeZ
         14w7NiglXdUJQNlfBog2kqhi8VPlHczo0oDca2C9cxZ15+7OD29VBaeMWbniH/MGLWCE
         K8Rw==
X-Gm-Message-State: AOJu0YyPSLUIxRgOELB3x8d/tGrtEAB0LzYTRhrZQ+89n1CLaEDYr3Jq
	mqjLPgBpzAayPi4sbwH1jWSCQQ/Dpfah+ZCJOcAqMwIrM4xqTPHP4Av88D1ACncr+RQQrHeYYYR
	ZNCqFbAJbR300WsPQkra+0C3I5mict2jLLhk=
X-Received: by 2002:a05:6358:726:b0:16b:4b12:1842 with SMTP id e38-20020a056358072600b0016b4b121842mr8647507rwj.6.1700498099545;
        Mon, 20 Nov 2023 08:34:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFR0FE8SSbDLW3AevgsAwFEu6zOq5yK2N2TwdyzHuvhL6NWib3gECyjA5arteEcU++mTZz2XKREqHBK0HUJhqc=
X-Received: by 2002:a05:6358:726:b0:16b:4b12:1842 with SMTP id
 e38-20020a056358072600b0016b4b121842mr8647488rwj.6.1700498099328; Mon, 20 Nov
 2023 08:34:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231120105545.1209530-1-cmirabil@redhat.com> <8818a183-84a3-4460-a8ca-73a366ae6153@kernel.dk>
In-Reply-To: <8818a183-84a3-4460-a8ca-73a366ae6153@kernel.dk>
From: Charles Mirabile <cmirabil@redhat.com>
Date: Mon, 20 Nov 2023 11:34:48 -0500
Message-ID: <CABe3_aHtkDm0y2mhKF0BJu5VUcMvzRWSd7sPeyTFCZEFZt05rA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/fs: consider link->flags when getting path for LINKAT
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, asml.silence@gmail.com, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2023 at 10:59=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 11/20/23 3:55 AM, Charles Mirabile wrote:
> > In order for `AT_EMPTY_PATH` to work as expected, the fact
> > that the user wants that behavior needs to make it to `getname_flags`
> > or it will return ENOENT.
>
> Looks good - do you have a liburing test case for this too?
Yes, see here https://github.com/axboe/liburing/issues/995 and here
https://github.com/axboe/liburing/pull/996.
>
> --
> Jens Axboe
>
Best - Charlie


