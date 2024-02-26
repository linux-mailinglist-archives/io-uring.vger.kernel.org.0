Return-Path: <io-uring+bounces-765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C02868111
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:34:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D594B2098D
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F85012FF69;
	Mon, 26 Feb 2024 19:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMI3GYS6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8F412FB28
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975918; cv=none; b=scL5134z8EL8VevJYlLWtK6N6WEFDi4u53x8uiaIgzt3dJ2j3PiPcDyGN9CX6zGUpDu+akKF2bDui91uspP17qsWL4b4rhgSJKcVUDzY2+XGUdPfaGCcaTXtp55I645iBI+IoL5PRH7mtBOFBI7HoZg8Zo1S6ZVOGsCS3Bf3m78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975918; c=relaxed/simple;
	bh=c5JIH66YKKuyHxFCMBZhRYZfbRjeDWKf7Mq8frkEzkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FacBwPPzccMwcaMiOx/FXCn35BgQTxz7fMWoq/1ROc7oWvpgl1qdQlrYh90VYObRMV1Kr0Q7U0qHmD3OTjvqI768h01U3MImAx/9YEKz2FV0ZTLLy8BSa6ZxSUac5EzLQ9+PYbyiFmTMWgV22vNV6XPpQrGhQNAzmukg9dCK3pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CMI3GYS6; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6091cfb2d5eso6755467b3.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708975915; x=1709580715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5JIH66YKKuyHxFCMBZhRYZfbRjeDWKf7Mq8frkEzkE=;
        b=CMI3GYS6x+2F/Ry4Ceus8Q8eidh7eub2Ne8eXtobPH6eB7YfQWmn+HIwXKJL1vAMRP
         CHS7j1UdlIJNdSd4rDtiIB3VgF0OzXP50pBaDt9ZlrLta59sEnj3n5zOZoagIcaaTOR4
         0OhN51Rd9Ltj0UVa+7bdiQgPSbhdpF4sTZIjhT3KiVyA2Glq79S1j1uUzUFjfAQvi+om
         vvcIP281AMoE5zW74gOaA/+8FdcJpoeO6HQUWNTnud1bn1VxOinWp4foDMqCrTibZTnT
         kcv1bVgAcY3aQ2BazrM5GLSxbSyCdQTBS1BBXosgmOtPbmR2yqcxlITRVFonkFDaP4GF
         azMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975915; x=1709580715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c5JIH66YKKuyHxFCMBZhRYZfbRjeDWKf7Mq8frkEzkE=;
        b=nnu7n/OyHxpqLUqPBG0b4tH5Qc8trPH74/+yRSGisBYBdS6PDOsQwg19DqQeeiP+i6
         Psz63JtOICBG0cxk5DZeJ9eBiSwrEExeOJXozsLFhSfCAcd93NzaAiu8jvxDkuZdILwN
         G8Krkl6QlHdRNxMlWgx/p2S2pzZLuad13qSDnW639lbDyd/anJ04zMJPBOupJ0OWK0GT
         kqTllRIZo/rRpSHNg0NVRClJ+ZW26upk2m56YGAY92M8Z0ZDDYSpTk8jB0RYFSMw1Mzh
         xnWp2BjzusZBK+qGfKwt+vHpn4HxBoX7JMbcVW6TaJhFOKOWfhqiUMRHS9RRa8N/p45N
         h2aQ==
X-Gm-Message-State: AOJu0YzQ05rbAWfH9F8of7W7rBbTsEy02KAlLe+0gft/d3IPrqvDZzpT
	3UY5XKy2YBh14OBlY+uhtxBv731pLHjSst8Y2Xjv+WBal9BSee+6iVwIf2CCXhH+QoIJPNbnKF/
	F7WzgYKII+kzWO94F8P5tMUAzYSo=
X-Google-Smtp-Source: AGHT+IFmNy+ftyQ3zxUE7SDlFd9ZdUz2gaERM04BAt/pWxiiYjwNTWXLXOIfYxqKz3hIQlKZkX4afZZF1M1agSV7PEk=
X-Received: by 2002:a05:6902:218f:b0:dbd:4578:5891 with SMTP id
 dl15-20020a056902218f00b00dbd45785891mr150332ybb.65.1708975915442; Mon, 26
 Feb 2024 11:31:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240225003941.129030-1-axboe@kernel.dk> <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
 <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk> <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
 <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
In-Reply-To: <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
From: Dylan Yudaken <dyudaken@gmail.com>
Date: Mon, 26 Feb 2024 19:31:46 +0000
Message-ID: <CAO_Yeoh=r+RVJ0vSt+C7YmoxSN4uKDw=O5GUfOUYGzr0UAt7RQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 2:27=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> > You do make a good point about MSG_WAITALL though - multishot send
> > doesn't really make sense to me without MSG_WAITALL semantics. I
> > cannot imagine a useful use case where the first buffer being
> > partially sent will still want the second buffer sent.
>
> Right, and I need to tweak that. Maybe we require MSG_WAITALL, or we
> make it implied for multishot send. Currently the code doesn't deal with
> that.
>
> Maybe if MSG_WAITALL isn't set and we get a short send we don't set
> CQE_F_MORE and we just stop. If it is set, then we go through the usual
> retry logic. That would make it identical to MSG_WAITALL send without
> multishot, which again is something I like in that we don't have
> different behaviors depending on which mode we are using.
>

It sounds like the right approach and is reasonably obvious. (I see
this is in v4 already)

Dylan

