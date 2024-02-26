Return-Path: <io-uring+bounces-728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3817867200
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 11:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D3E72889AD
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 968491D545;
	Mon, 26 Feb 2024 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GobBCXdO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D981CAB9
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708944435; cv=none; b=QsbpLlSPQBJXfeOwDzcy+f9wjyIyQt9C0jb1GtvxkgbKO0u3JlCcxRUlrPeYThjs0xx60VF5cTVFx2Ho2Ycket6x4f/urKAewassJUbIRsVjWYu4KspN8aWEuL2hSWkpiBEoXvEUsCztZn2rsVW5l/c+hFaAPSgSdcdMFQQdO0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708944435; c=relaxed/simple;
	bh=FPz6riJ7HNcXzS2oy0AUWRfYolJE9pw/GmIvmlivqWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LqkzVj0cd18roJ/e6XFgNTcDdlkOC7JcbB6q5uSjVq4Kl4BaDmwFGZfw//ju6NzbWaVNMdGa7wo4Xsrwy4Mk3AuCgkT7Pv3uuVlMJ4B8afQagc8fSIpZdvc58meiRHDQWeKS5LshZ3MSEqz9HrQ1Iq9UnhG8dJwZugCSQD9VECI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GobBCXdO; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-dbed179f0faso1528018276.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 02:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708944433; x=1709549233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FPz6riJ7HNcXzS2oy0AUWRfYolJE9pw/GmIvmlivqWY=;
        b=GobBCXdObsRGgPFAY2XzrsYTofAmCl52O3LjGk1eNmQl8aav+A74asVgln9Ee59Yss
         ZWgoB1KejzRHNt8rcvj4noD3VpmOuvpRZkJvEA0cHYeWU6NcLoBOkEoRAQ/OkmRHlVQ3
         M1QUuyIDYb0pDfNElOgUvdK07p7KNrMJGZJn2Jiq0MgQpSPq2bBus18ofJRuasFQ71fT
         SLajJSeHjFdcyrL8lV3ZDWliERpNP7db7B2wwpYxNG29YToUwGGJd8i2o8cATwaRyubZ
         Yx4qFbF9lHpZAadJo3ruXGpqXS9wAkb88Ko+U2WFxjXnLlav1J9FRZZGvj1jtgJfaSMl
         q6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708944433; x=1709549233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FPz6riJ7HNcXzS2oy0AUWRfYolJE9pw/GmIvmlivqWY=;
        b=XwQsd4gMltDp16+xGMrRccU4qKbCuwf0qggIrlfh6BDdeReAUQQv8lASx/KAHzkNBB
         iGNmnXyHflulNkKtOQCn0VEJimN/RY8QV08a04UCy92apyFeYV96CvuQ4HoHN+JaBwQA
         /yc/avzQmmHWh0WVfw+JFz6tCfdU1ObKXxnfT1JslY7+3R/PNcEXPsvKHjt14ZkIKzJB
         BAQynih5uEbiX+u3GbKHjloR3y/mRSCTXTX3vjah46p+tpiFF+EQo8aVVlz2F6DEuwW8
         AzvtCzyrgc1suGzO3YFs3JxjqcQTaSADaU9xtCIvisF8Bn16jBEqtJskAeRuV1U6UTVf
         pLXg==
X-Gm-Message-State: AOJu0YwBL3Ew5sdbw24phz/ztjpo2YPUP/5t2hWoa3PpN5UUSnUzqxTs
	AnVgJQqmxEUrykDEIvSg2L5E8+ef2hLj7+fTIGQBIAP5wzx3ZL5wJACLO02r9NuP6Duc8cfUxP3
	ol4Na7mZd9gx0fa9jBzX2NjS+TmMhlZq1KmM=
X-Google-Smtp-Source: AGHT+IE7UyHSusK0JSIVBF7npu2P21MHT+ytKU05m+IJ231EpAnJc5jlCDUYFqDME8imhab/4KnQzzcB3Rn7Yqto0Vc=
X-Received: by 2002:a25:7bc2:0:b0:dc2:271a:3799 with SMTP id
 w185-20020a257bc2000000b00dc2271a3799mr3653922ybc.23.1708944432920; Mon, 26
 Feb 2024 02:47:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240225003941.129030-1-axboe@kernel.dk> <20240225003941.129030-7-axboe@kernel.dk>
In-Reply-To: <20240225003941.129030-7-axboe@kernel.dk>
From: Dylan Yudaken <dyudaken@gmail.com>
Date: Mon, 26 Feb 2024 10:47:03 +0000
Message-ID: <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 25, 2024 at 12:46=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> This works very much like the receive side, except for sends. The idea
> is that an application can fill outgoing buffers in a provided buffer
> group, and then arm a single send that will service them all. For now
> this variant just terminates when we are out of buffers to send, and
> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
> set, as per usual for multishot requests.
>

This feels to me a lot like just using OP_SEND with MSG_WAITALL as
described, unless I'm missing something?

I actually could imagine it being useful for the previous patches' use
case of queuing up sends and keeping ordering,
and I think the API is more obvious (rather than the second CQE
sending the first CQE's data). So maybe it's worth only
keeping one approach?

