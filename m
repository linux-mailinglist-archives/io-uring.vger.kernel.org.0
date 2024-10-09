Return-Path: <io-uring+bounces-3526-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A24E997645
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C00D285339
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F1018A6B9;
	Wed,  9 Oct 2024 20:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SUhuRbJW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751E117BB34
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 20:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728505079; cv=none; b=AncI/moz7mdUxyDXhBugiTQm9WTYtE2ysubmzWG0mxUO2MRpp655Ax0FDsuz/O+unp+63ErU3cBLFn70xSad5C3oRiWHTpCgf6yWS2JXZ5Nm47CamfWFN7gNAA5fDiKr3C2ueUtEM1pYK34nInTuDCjIY+KPxPlpqFcakXCTMOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728505079; c=relaxed/simple;
	bh=maOx7b5x9FkkuEx3eAHB27tHVJF/LWrzXWhPOgT0klI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SZ2+Ac5AfYenCvJWXJRYiv5ZrYYgWaAiNOcSFtvMuJY2EAf4IH1ZlrWf/UA5uzZLusR4CH5/ClbgRgILI8siEmOTTmHsUaoTpJRaTKfl4P+5swSVBIbffzUdVx6/EpFYisFUB7/za0xVrlyuzpUO965oKcCHZWXyJ4pt961oD08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SUhuRbJW; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-460395fb1acso74801cf.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 13:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728505077; x=1729109877; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=maOx7b5x9FkkuEx3eAHB27tHVJF/LWrzXWhPOgT0klI=;
        b=SUhuRbJWWLI9fL95Sbr0W/eFgXOk/72u4p6SUfx6iI7MSBa/FoyrANQHvT5GdzeCDi
         t1tCO3PaC2uS7A0wQxjM32BasVEaniJ6JFUuXY2Qvcvegia2aMoRWbxxUfaveWTuWYOP
         uSyrYf35QPqFVcAnsDgzyU6jqtl+og8zpSk7nTNP3h+TDhS6QqYAYNe62F5J2mMnybl3
         e/HdEdLfOwE1eL8T0eO6MkcHEyWgRGfrTNKlkSCPZOs0IMwEvN7/XCk92x6OlmWWr9sE
         YJ+qBq6B5i4PN4TkqIqkjGM0raMbzdc7TgqVwKDNR+TQBHkL98mtcSmlpAB3Q8cI7Vlc
         3dHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728505077; x=1729109877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=maOx7b5x9FkkuEx3eAHB27tHVJF/LWrzXWhPOgT0klI=;
        b=M4Df14MwpvADn7FL6r59Z6VEV/mrw3uopQCT7SSNKTsAnh98BYOPy6K8/yuN7RVDIT
         Gs1+SQhRx7BoNnsSkP6o2uyjbHapaEBf+4TUdCmcfDoX5PrtFqcLkN948TA741LSQZSK
         iISfbwAuWjIF15qw8P/1b/8eCDW1kw4id7ZTVXRe8cOPM0xfHPhktq93hdUFZWahNL70
         MwST0Ey/n+sslPgQSJNF/DjUGlq/Z1/F9/SOD6wCLZa+1i0aLH72IfXbfT9EBEPyrMjI
         cZ42t6WgYpiaN9DbMN5H8p6sNNd2PrPD4qZETCKp19g6LfcF5sSfEgURjJ79d1Hg5Wjx
         Kbrw==
X-Gm-Message-State: AOJu0YzZLfo/FIfLVukC211Wfo+PRli5v0TZkU6NPYpeHzsloG25jVqh
	VOWrs9MFeoGEUZ10VSTODzWKYObJCuHbCerA4cXFy6rila893azOQvCiWTC6xi3+GVt9e8gpRBI
	1zNOD3OuwbbO+cqSJFVyojIm8jMKw/gL3Qi4R
X-Google-Smtp-Source: AGHT+IGheGV+/dYGxDE1SzkSbZdYcrDvUIOdhPJcDBPP0qxjpvF84SFjrNBdgEJeMOXRNLHA3vD8gxHfFEfvPNXkHLU=
X-Received: by 2002:a05:622a:2a14:b0:45c:9b41:248f with SMTP id
 d75a77b69052e-4604075365dmr522271cf.25.1728505077339; Wed, 09 Oct 2024
 13:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-2-dw@davidwei.uk>
In-Reply-To: <20241007221603.1703699-2-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Oct 2024 13:17:44 -0700
Message-ID: <CAHS8izMHmG8-Go6k63UaCtwvEcp=D73Ja0XfrTjNp_b5TUmUFA@mail.gmail.com>
Subject: Re: [PATCH v1 01/15] net: devmem: pull struct definitions out of ifdef
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Don't hide structure definitions under conditional compilation, it only
> makes messier and harder to maintain. Move struct
> dmabuf_genpool_chunk_owner definition out of CONFIG_NET_DEVMEM ifdef
> together with a bunch of trivial inlined helpers using the structure.
>

To be honest I think the way it is is better? Having the struct
defined but always not set (because the code to set it is always
compiled out) seem worse to me.

Is there a strong reason to have this? Otherwise maybe drop this?

--=20
Thanks,
Mina

