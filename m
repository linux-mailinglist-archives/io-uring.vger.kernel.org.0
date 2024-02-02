Return-Path: <io-uring+bounces-519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BAA9847696
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 18:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D51B21F279FF
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 17:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA83214900B;
	Fri,  2 Feb 2024 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pMKcQdqZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA02168B9
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 17:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706896151; cv=none; b=D0N3A0a96CMIyexAdS063FgYc6cWWlyoajaA0umzVtD6Bk+hQWBg/SZGkmsamidNU2t74hQ9fjHwFFx9V2+1oXKrimnP41vVQHrHDbfQtycSMsp+++f/Wg3dlDZD6WVKCWtCSc8dSRBArn14CTfQ32dxGCnblH77jhoYTps/Q0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706896151; c=relaxed/simple;
	bh=Whxn9HjcW0lZPWc/1CptL4yBX70DNO7v9fn/9+AT980=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=H/8Xt9tCCwbT8QP3GPbrfrMKwUhNdMWGpaxdVvL6groMlmgAE8luqsXjE6DQR6atO+5VbFYwSMcoyFi7M5KHuE9T+fmhjRr0LpnN2ZGRUdNxzjBRiazgjt/fGMAQsu8hNdTvRFdkTtb39Ej8MJIma+YIxNTZ658iH5bNHU3nNtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pMKcQdqZ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d3ae9d1109so4861355ad.0
        for <io-uring@vger.kernel.org>; Fri, 02 Feb 2024 09:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706896148; x=1707500948; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R5thaJRqFBv0QThvDktTpd659TN6kpAZIZPesHSzAx4=;
        b=pMKcQdqZZ2LGDfVi52MBKyDyd+gTQrqn7UxJCGiHVIwf5PCHexjuexMrpg1Z8Fjp7z
         CxHfGv6xs6ByreHRnj2tLg5UWSUOpq76tZckLC4d8HUmvMh09VIEwAOlQI9jR5D0oDc8
         cYWiYix7+mXb/Kx5GG0uunxiJcFEVmnRnnQnLyT1zVo6uqQbewVoaPLMSnK++2zlIla5
         yOVp8gnAk7C5SfT8HyNtIre8nahJsCvNKwlW/rTTRsphIGvrEPDynKAQq0bvq3Sa187N
         72nOusaH8acrpWDaroDhBTUBwlkgsLth4HvTBkW+387gYUts+QsiuiI5+PD2c6q+5b4A
         a6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706896148; x=1707500948;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R5thaJRqFBv0QThvDktTpd659TN6kpAZIZPesHSzAx4=;
        b=frO+7MNI7bupWIovymZFEfS6Hhb/C2QVVfHqO8o1xvLM+VJ1SQM9D+viMXkHgURa/p
         xUyzSk8BzbP2dI/H1aUakAF11nOJxDO7xq4o0Uc7S++woJO8zppnrkpLnOwgaxUFtG/d
         HnE2ls6fpA6JVcOMYEnZGrutMuFOgt4ofvzB6tgi9JVqL4/8Uw/xEx3ctHrkPkIF/C5B
         xnwIZhTTUKDBb1unL+YiAzaWZyR9Zsbjty1xOWl1ulOvJataEQO6leiUUz1ZUgkQ9wRa
         968MRj6CIqErfrDBck+o4I1Po0aW7FTvbBPRB1l+NWqQmv5wdLKmkGaV0qV/rsvzqZvY
         zFgg==
X-Gm-Message-State: AOJu0Yy/Hj9+Gx0VC0wxXZNnpOvW+R/rwsUjreDD8xPWcQrIPurYSkGm
	vxMCtKluDdOf9ZvmkdTJPHwRfUirgBJPmFYk+G294N+GkNSQZe34uZekXIcV/BrR4x8I+XqD4QD
	B
X-Google-Smtp-Source: AGHT+IEf0gf9MsrKIVuXGE1KC3vbGhF2vJ9hB+n519RnhTs2oAV1Isv7+wsBAGlNBqsm513gk6BThw==
X-Received: by 2002:a17:902:dc83:b0:1d9:1fb4:a5f8 with SMTP id n3-20020a170902dc8300b001d91fb4a5f8mr7017387pld.2.1706896148466;
        Fri, 02 Feb 2024 09:49:08 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXGGup3Ffz+XSQpNrVtOY44yVkRv0v8u8/AJzPz9JnqOmeGucWhjg4u3o9n37xNIu6j5bup190dBK55w08E1Mmb7ddNSjExzyS9Cb7gtXdyl0DVN5OmHTblxBBPM8sigJVa7o712pgzJ02sUf9ORbP+APc6TbY=
Received: from smtpclient.apple ([2600:380:7774:298d:793b:f0fe:fe73:2ad3])
        by smtp.gmail.com with ESMTPSA id kv15-20020a17090328cf00b001d706912d1esm1866058plb.225.2024.02.02.09.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 09:49:07 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jens Axboe <axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
Date: Fri, 2 Feb 2024 10:48:56 -0700
Message-Id: <3F08FF9B-ED0A-4719-88E4-0D8406E92A57@kernel.dk>
References: <cdfb1b49ff7c2d5a98d8f1032d2f0b6806b36845.camel@trillion01.com>
Cc: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com, ammarfaizi2@gnuweeb.org
In-Reply-To: <cdfb1b49ff7c2d5a98d8f1032d2f0b6806b36845.camel@trillion01.com>
To: Olivier Langlois <olivier@trillion01.com>
X-Mailer: iPhone Mail (21D50)

On Feb 2, 2024, at 10:41=E2=80=AFAM, Olivier Langlois <olivier@trillion01.co=
m> wrote:
>=20
> =EF=BB=BFOn Fri, 2024-02-02 at 09:42 -0700, Jens Axboe wrote:
>>> On 2/2/24 9:41 AM, Olivier Langlois wrote:
>>> On Tue, 2023-04-25 at 11:20 -0700, Stefan Roesch wrote:
>>>> +
>>>> +int io_uring_register_napi(struct io_uring *ring, struct
>>>> io_uring_napi *napi)
>>>> +{
>>>> +    return __sys_io_uring_register(ring->ring_fd,
>>>> +                IORING_REGISTER_NAPI, napi, 0);
>>>> +}
>>>> +
>>>> +int io_uring_unregister_napi(struct io_uring *ring, struct
>>>> io_uring_napi *napi)
>>>> +{
>>>> +    return __sys_io_uring_register(ring->ring_fd,
>>>> +                IORING_UNREGISTER_NAPI, napi,
>>>> 0);
>>>> +}
>>>=20
>>> my apologies if this is not the latest version of the patch but I
>>> think
>>> that it is...
>>>=20
>>> nr_args should be 1 to match what __io_uring_register() in the
>>> current
>>> corresponding kernel patch expects:
>>>=20
>>> https://git.kernel.dk/cgit/linux/commit/?h=3Dio_uring-napi&id=3D787d81d3=
132aaf4eb4a4a5f24ff949e350e537d0
>>=20
>> Can you send a patch I can fold in?
>>=20
> Jens,
>=20
> I am unsure of what you are asking me.
>=20
> You would like me to send a patch to fix a liburing patch that has
> never been applied AFAIK?
>=20
> if the v9 patch has never been applied. Wouldn't just editing Stefan
> patch by replacing the nr_args param from 0 to 1 directly do it?

The current version is what is in that branch you referenced. If you see any=
thing in there that needs changing, send a patch for that.=20

I can send out the series again if needed.

=E2=80=94=20
Jens Axboe


