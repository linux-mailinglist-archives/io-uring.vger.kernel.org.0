Return-Path: <io-uring+bounces-10045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C15BE7CCD
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 11:37:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7FF41566C95
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 09:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09232D8776;
	Fri, 17 Oct 2025 09:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Ff/ztjWD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E642D8791
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692928; cv=none; b=ZTfsWBQ/KUKkAJUndSeeWZoPQURGJu6maKL7p8Q6sFYK1J6d4oilkmIhLhxA88euIGkw1o11f88RQ7ZCechOsXJejBLGSIdpTZkbV5d82TDHzWhnx+V5Itg095AEh9YUqvbBAbjvl158xHgSBsBy8Eo76ZS5IDpO9SagO3QKqW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692928; c=relaxed/simple;
	bh=E3Xqt5nemlpYaXYu443Wo4/PYtOL9M/IwIbtROkeeCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uMQ4V93CzngEdhMe0bJy0FFHzu/mJEEPBoVScAFRIVXLO+Gh1lg21rR1T+E+WmB5snTdCOCVzDLXGk05csJlNjjg5gQeT5+7MN+cWYNgP5KR1WY4uRf0SIOBToRi84pOfu85EmYiCmpw1ZJQtpJDefzJk62mdt4eq5HS5ub8UF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Ff/ztjWD; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-3c97813e788so987020fac.0
        for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 02:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760692925; x=1761297725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ArPY738+uS83AEbIcuL4ba9WxKNM9UEC6sm+1OxElzg=;
        b=Ff/ztjWDfEty0UdlG0Nu15p+f32ttEck32QT7HmGdlXa2f2+9CYQ6GbL172k6AmNfc
         rc+h+n47naXlpAqu4vRXQ3x4bxxpx7F1vXsEJ4ie/qaNgM5EuSNJtkZ8/gXJluy8gW1h
         w0fqUNh9ywIFCka10IV+d/QACbljJmtrNioFPQ5J4e55Ncjf315lMA338JIyL45mb6Nn
         hEL5/bSGFO90+K46qWI/UNbNbSp3YuH2aWkYsLhrP2tRKdU2Z9u/Q3eQOjC8dGjVzRnk
         Zov7kyWN8qFrBIOWqiJX0438vS3KQwXntEPhJXj55y4iUEBpPHUZ6LZrbz/pKaK1EFLs
         ChqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760692925; x=1761297725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ArPY738+uS83AEbIcuL4ba9WxKNM9UEC6sm+1OxElzg=;
        b=P/vnPgcRu5tH1Vp8vX1qFcxgQnHOmCwKhhME268MZBCWJhd7bYBzsLnKzxMNLUZfbp
         rrT5EkZcst6SaNpzlvrUvKTAQwn/7ve9ev46oeHTUNbtnIPXJAHemvJdshkm14GT9pes
         4ZQxawJo+lrMG1vd5o/HlAEV54RSJr21r8iHT3PU1pdxPs0h56YDiIwSMwCpFC1wfAVy
         u17R2eu6zHLMVDXfjJd7mIfJBptiqOL0Hk2SfgMEtY4jEWP5oTlg5bqzsP69pxSxr/9X
         j5NYkrqHT50lMplVN1FYUjwFKD1pkWGc1s+n51sQ0yKVeu6MAjyjfHuzpNUweZYpqxiq
         7NQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnCPSxJCZbE9miiL06p7oE+7BPkVFeIUaoMI8A7Oq14vsBSdleuO62k/l6irGfYQ8TdkjpXTke/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWdlf3pNSox+O2iLMSLIp3vDYmBJB7uWHww/60WQwYuGQ8ZoR3
	ctAPZ97+IOx+seXWn0533si2b+Wj1HTOdFsilCqN2D/z2EigOVuHVJs1yUJNLkFn8W+Mw1EaGL/
	Kd5h1CkJSgluEo/5DFKaQPZ4IZDOTo4zGAyPb2PTK4g==
X-Gm-Gg: ASbGnctXm0rV0Xk2eCXpVIPbUuPZ4+2XJf7cPbqYRsMDngPjuxY/j2H65h2DvcznCQt
	CqQAmbV9YiPalWnA3ydKHpRrtrjjkFe7gbAIRwm1MtEf7fIo/fW7wwauv7QmOv76hXB8csro5UQ
	BHdrJ0BU3hsEmxZYyi0RhaNxAXJuIJltDXTEf82bIlj0KaSck15r4gtaENBe7q2qMA5XxC7DxbH
	YD71QAilCyiHv1RdzPLykWWzSlZLrRRP28tR/U+Vi8WLmQPgfCbDkoSzsdhwA==
X-Google-Smtp-Source: AGHT+IGf74OtLEg3AFRDQqYzZJj7bLWmsybbWfjWlTrxajv5ANN7VmYgkyOdGjZgpMQDasZdtbwwDEPdBb3O9Qd4mso=
X-Received: by 2002:a05:6870:7d89:b0:3c9:8185:45d8 with SMTP id
 586e51a60fabf-3c98d0e1a16mr1195376fac.26.1760692924769; Fri, 17 Oct 2025
 02:22:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20251017091046epcas5p35dfbcf4979f79b3a80441aed2d31a906@epcas5p3.samsung.com>
 <CAPFOzZuhDU0yD=nGioR1a3u9C0ZXxOpahZxv=PsHThEJJK=A3w@mail.gmail.com> <20251017090615.6580-1-xiaobing.li@samsung.com>
In-Reply-To: <20251017090615.6580-1-xiaobing.li@samsung.com>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Fri, 17 Oct 2025 17:21:53 +0800
X-Gm-Features: AS18NWDt1Z4sN0dOOQ3TzOYJvh9jEtUHfRTC1Si-VTS2IUB6aZW3HYupzIQh0rQ
Message-ID: <CAPFOzZtyfp_FhszhrT94PHiEGjY6JHrUAfpAEWs2LhijEnXr0Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] io_uring: add IORING_SETUP_NO_SQTHREAD_STATS
 flag to disable sqthread stats collection.
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	lidiangang@bytedance.com, kun.dou@samsung.com, peiwei.li@samsung.com, 
	joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Xiaobing Li <xiaobing.li@samsung.com> =E4=BA=8E2025=E5=B9=B410=E6=9C=8817=
=E6=97=A5=E5=91=A8=E4=BA=94 17:18=E5=86=99=E9=81=93=EF=BC=9A
>
> On 10/16/25 20:09, Fengnan Chang wrote:
> >On 10/16/25 20:03, Pavel Begunkov wrote=EF=BC=9A
> >>
> >> On 10/16/25 12:45, Fengnan Chang wrote:
> >> > introduces a new flag IORING_SETUP_NO_SQTHREAD_STATS that allows
> >> > user to disable the collection of statistics in the sqthread.
> >> > When this flag is set, the getrusage() calls in the sqthread are
> >> > skipped, which can provide a small performance improvement in high
> >> > IOPS workloads.
> >>
> >> It was added for dynamically adjusting SQPOLL timeouts, at least that
> >> what the author said, but then there is only the fdinfo to access it,
> >> which is slow and unreliable, and no follow up to expose it in a
> >> better way. To be honest, I have serious doubts it has ever been used,
> >> and I'd be tempted to completely remove it out of the kernel. Fdinfo
> >> format wasn't really stable for io_uring and we can leave it printing
> >> some made up values like 100% util.
> >
> >Agree,  IMO turning off stats by default would be a better approach, but
> >I'm concerned that some people are using this in fdinfo. I'd like to hea=
r
> >the author's opinion.
>
> We use fdinfo statistics to evaluate some of our internal test data.
> Initially, I tested the performance impact of adding this feature, and th=
e
> results showed that it had little impact on performance. Therefore,
> I didn't consider adding a switch to control its use. However,
> adding a switch to control whether to enable utilization statistics
> is a good idea.

Get, I think we have a common understanding to turn off stats by default
and add flags to turn them on. I'll send patch V2 to do this.
>
> --
> Xiaobing Li

