Return-Path: <io-uring+bounces-10075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A950BF55E0
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 10:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DB6A03512CF
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 08:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352DB1A8F6D;
	Tue, 21 Oct 2025 08:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="CPLnjgYS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70940FC1D
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036893; cv=none; b=Ggky69kLIT0ijagxgSepAfGwLEb4Ln787sGQ4zjx4C55cbXfWMnk+NgqYzhQjsj7Knfl7tbQf/nA9VLuntTRjFv/3lKri667JkILwhj7MHqgcOjxrq7LPEJ7lwmCBmZFImfvjMAAlMmiEUK1XBQTKq8jb0akr1PYPdmuTBhPQwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036893; c=relaxed/simple;
	bh=yajR3CAVE5v/3r8G48OHxaQyfip6h66KSQNaTIYV3N8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GIVRyfBsdsGClXTD3bKsWsVYgwcfJvZcn+oTFkFD23mTwjcYo8+1vujBphda5pEF2vyQEJShqOfh7POjJrttCAs/sSf0Q/xwsAINrb5DmP3SC5DsnmoDllTbcXpTSY0/YStgAZgAP2qsiNnS6zrdN0GWHzWVyp1tuHh2arvZedY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=CPLnjgYS; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-3c917ea655bso3556347fac.1
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 01:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1761036890; x=1761641690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIcC2isdvBxiWOXUafuPSvSlyX8KafXt7rSvP40lSno=;
        b=CPLnjgYS3QDSFYAXpF7Qfvz6Nw+YJ6Erxp4wWsO2+4tzbtCSPWu56war+pkPsXcJ76
         uRmP1GAL8IhOF6629lra1++CAlpCqwSUaX7srN8P4+aDmCwGPdtVotaXpZktDj2EH8by
         zQs7MTkKFTybvOPYFkLuKJzCeEej+3gN3EuWgeysI3j/JJ16pvnVuGXRilaRrwPdcvt7
         Eqtt1tOtab9DabVIenC2nFuLQx0s6xEWCTc7mrkhvmYoGIMIu+dLj5ZD3ZwOr3pkVAMI
         0ZWA+ffxc9huP3Qqre9qa68zmHf3P5JIwZ1kDZnP+ah1kP3rddkKaDeZqQNOLLw4NfNa
         Mjvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036890; x=1761641690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIcC2isdvBxiWOXUafuPSvSlyX8KafXt7rSvP40lSno=;
        b=OJ/aR9G2SZXiVPLIh1IE6oylRaO/1TMNntO1GU8mWio99hIuV86UAkE/UTlh7molIn
         oSDv0nouOgdF2WNEt6oz22qNncKQtrlXjGp5rqeXwKrNSE6cW3HAfP6xABFhyphCf7VR
         kKyTTo8Z5I84o5tC2T36+utscD0a3/qafwyHPJz6EoFHcXpqYFRWu2KPY8FTcMIBvckq
         /uPWM0Pgqb3t88U0gFFeC0I8y7gGnYWGAcswKrR4xnJ/1mjFUsNgjlYanCDcrIBqZ/mV
         XuiicEHBxO4EshSDHDbXWMzvdqsw38MBF2pVxC2+xud6LZBXoQ+0DwZNuUdiZByMG02e
         4nKA==
X-Forwarded-Encrypted: i=1; AJvYcCUv72o/ELf+lEtqon0UPKkAZJnO6J2H5etWRcCsHScYsRYu26/YFTLc6yt4m4j1a3zSLLFsL41ixw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4YC53mwB3T6fW3MkvrzDhJ6c51Lp2fu4bFDayNx7+5G7AgyKY
	50y7w2g+6zYP+h/gRd0R3en7s9BUWDysfgLQ//8sp9nORp/E5a5aayhkEm0m9kVqg9qNi1DzY/6
	TB+5AppudUomUHqZDBvQnJ8vRaS9isVUkTUriMSxDHA==
X-Gm-Gg: ASbGncuf8n1gpvicVqgW0sbMHa2NLeySvtSFzpPNsFen2OqqMqW2koYCc3uPbvCGbBR
	PpyL06ELS+lm43AACZC+pHMGIIQ2Xz59BQHBWjwUl35pOAw3MREg6p+ONmrws7JyEiUlNcQ5o1y
	Ilumyk/T6aEOBCa1LgK4SgR34zDtqGKmgM2uX2XoPF5k8JepUBU0+P0CfRJxUS1DFN4/VBIVteK
	CBJISv9pF5oqSdRFfq73Bp6oLKXSSvFUmge3Pt+ps4flKCuL9JjRRThic115uHiBjngK7yi
X-Google-Smtp-Source: AGHT+IHTQTZj4xn3cTy4j4Xymr2Kdri788hK6cadIw1GApdt6YHcHaaQw41pgtYSO2u+DBAO5+CHSSbmRkMA1oT0218=
X-Received: by 2002:a05:6870:a995:b0:3c9:86d7:6d03 with SMTP id
 586e51a60fabf-3c98d145ca5mr7443605fac.51.1761036890411; Tue, 21 Oct 2025
 01:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020113031.2135-1-changfengnan@bytedance.com> <8ac97b77-4423-41cf-a1f3-99d93ac65f9d@kernel.dk>
In-Reply-To: <8ac97b77-4423-41cf-a1f3-99d93ac65f9d@kernel.dk>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Tue, 21 Oct 2025 16:54:39 +0800
X-Gm-Features: AS18NWA0y8q4bgqoOiOvN64ETvFslOgD1VJNr0lwdIT8P-8FZ-7SCz6wrNzD8xs
Message-ID: <CAPFOzZswzJMSdtpZZTTWQ0b3SUgPg5g1cFLVQTQh+os_tVzSnw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] io_uring: add IORING_SETUP_SQTHREAD_STATS
 flag to enable sqthread stats collection
To: Jens Axboe <axboe@kernel.dk>
Cc: xiaobing.li@samsung.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	Diangang Li <lidiangang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B410=E6=9C=8820=E6=97=A5=
=E5=91=A8=E4=B8=80 23:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On 10/20/25 5:30 AM, Fengnan Chang wrote:
> > In previous versions, getrusage was always called in sqrthread
> > to count work time, but this could incur some overhead.
> > This patch turn off stats by default, and introduces a new flag
> > IORING_SETUP_SQTHREAD_STATS that allows user to enable the
> > collection of statistics in the sqthread.
> >
> > ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 ./testfile
> > IOPS base: 570K, patch: 590K
> >
> > ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 /dev/nvme1n1
> > IOPS base: 826K, patch: 889K
>
> That's a crazy amount of overhead indeed. I'm assuming this is
> because the task has lots of threads? And/or going through the retry
> a lot? Might make more sense to have a cheaper and more rough
> getrusage() instead? All we really use is ru_stime.{tv_sec,tv_nsec}.
> Should it be using RUSAGE_THREAD? Correct me if I'm wrong, but using
> PTHREAD_SELF actually seems wrong as-is.

Only one sqpoll thread, no retry.  Only enable sq_thread_poll by default in
 ./t/io_uring.c to test.
Yeh, getrusage is not correct, I'll try to find a cheaper way.

>
> In any case, I don't think a setup flag is the right choice here. That
> space is fairly limited, and SQPOLL is also a bit of an esoteric
> feature. Hence not sure a setup flag is the right approach. Would
> probably make more sense to have a REGISTER opcode to get/set various
> features like this, I'm sure it's not the last thing like this we'll run
> into. But as mentioned, I do think just having a more light weight
> getrusage would perhaps be prudent.
Get your point,  I'll make it in REGISTER opcode.
>
> --
> Jens Axboe

