Return-Path: <io-uring+bounces-8353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92309ADA65F
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 04:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A791E3A76D7
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 02:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF44161302;
	Mon, 16 Jun 2025 02:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5l7j9+1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C775BB67A;
	Mon, 16 Jun 2025 02:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750041189; cv=none; b=YrF1pt1XtTfZ0u3iaV7Y6+yDJ2WIru5drp9tnaNsac2hAq8fB6EjX+wOFAA7jGWBxrnBtf1/Sn/aGCQB6eBfd2qPu/3GZ2xaFi305iMdJluTINk9wnpbt3+J8oQEYEDpb5RAtoCTlRLPenjMcSFXg8XV4wSJD7f7UC6zGx+j+Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750041189; c=relaxed/simple;
	bh=DGmFmt0OEF5m6jEbbbk6ax5DyKp9jCGfU3+C1Oe48dM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=I/VGcb+VY4X/NacEFiYgakK88YFr9xEdZRK/S7Rymxgfrf3Qo3KViZBfCyEO1FV6KAJor0wzfeBq9V6INu7CTcfdMiKsgujaY8I/6g5ES9y5lF68FdDzqYYUxS2nmlx1nzdjy6FDPojH7WCsQz1FTsvGTs8Bo8qHZwqLzbmD5M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5l7j9+1; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-70e102eada9so36823247b3.2;
        Sun, 15 Jun 2025 19:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750041187; x=1750645987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wg0fq5JT7wdN6rE9i8eYcWGElTqss0ZnqnUXadYm8PI=;
        b=b5l7j9+14W/Im4SB3Yyv63XUdxVbgtbo5u8fJMMZf/UzpAMGLSOYZqGtc4yBolNx5X
         Aon1Ma1EvshPBK10qzGdBM5mfr7lXzSnfL8LeRm2AAHsW4pi7mTYUtkbZnfCTxvClTwQ
         COpVthUwDugwj5gREDl1CLwhd3Pl2q7hixna+GUHi7sknc8Fg9Oh4w+DdWj78ll4l37n
         3uFyZjo9Jj6K9IFpc67timyc6z/u5wUfNUNoeYf6LMwL4WQf1XqkgKmCU/m/4I/TiA0o
         rTfEs/GesI5UA9c09d8PSMODqG9xNP92I3Qae8P5lb5eh7buVieflAz1npa/CEifa+tm
         A7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750041187; x=1750645987;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wg0fq5JT7wdN6rE9i8eYcWGElTqss0ZnqnUXadYm8PI=;
        b=M3vMyU1MSnJIcw8gux/7+tiJWi75Oh3eYYOzIz1cvFinX4MWVAT6wCo7DAQfXTcnWH
         kwwpkcfMJGihHutx9bM0psNodHkH2iMjubxG7K3Ymzkz0aZVrFPYXCYeVJHi1OXKpYTQ
         pHWPwEvUFf53Jk4hkEekFQ0nEL3aEv5m2ESxk3CwQISMHXO25ImXltk4wSWLa8fuyRR0
         lrVcgy4LmSMzYE9tHvhsriO4Vkg75j2y0oypqCC9lKrMhYNkeL3VznLp0ueNNCoRPp5g
         EQ+CcJdVkZwWVNGgweBkVZHP3E4WC8kDnWfcWWKoxAqusacYIL5/tWX8w2lE/QPvU+ON
         zs8g==
X-Forwarded-Encrypted: i=1; AJvYcCUkDAtCNdACwWR0WiVbITBMsOjzluU1KReHSTR974TaeY5vULQ1TJTyM3BLmbKQf57u8bfpuNZm@vger.kernel.org, AJvYcCWkaAUbU7Lrqq+gsDMyAnE9t90sc5OljkPNPZxVfHlghktTonVC+lIrcvgqp61Z1PlDWIZuv6ng/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxL+DK3xZSWClK1HHGi6YjsBggIoYuWTWyfBCAbYNOJz84fUHUz
	psyYgtDMcnXtlhDpiTVO4Mprx0gbtN2jvlBItlORymmyI8tYhFPN5N5z
X-Gm-Gg: ASbGncuSQXS0qc3zZmAv9YJ/dhOEIzYfC8QJPHmJxNSwU6ZFCXzaL57eqJO5yoFNIl/
	ERqCkzB8e1bEkzdZGWY+ZURzTB6YJmUnAa8HNUODL+3zsZjHXxm/L6xrAgUvtTbtjsVhn+DIaVz
	432JmAUPRoq4G1xKBGfWG+HWZ1Syiwx195ckHQfv0tmuPHqdbx3uu6/I81/8uziaXohWNCiikAT
	n5Gav1vRUFmL8Sb8ynNKdifWfEnKX25B6TvTz+12Cfszk6Ao4k78ykcmtyjNlfl7byV/Pr5xlgG
	AtULTrCdc2f4EJVsa+DLcVR3SPYflOgys3KnZjFgWfBy7l70/CaEtqR7JH0wyKyd0qkwW6phpuJ
	OhK60LB8EgA5uEUBe/CgLpOn4TOAimEdvX9va5bvkfA==
X-Google-Smtp-Source: AGHT+IGr8v1ka1UwAwdLaHnEEKH3crneqBW7m1R/hUa8BFNgsPobcuUVuzEKe74C3l8a2ZbuJCH7jA==
X-Received: by 2002:a05:690c:6c0a:b0:70e:7ff6:9ff3 with SMTP id 00721157ae682-7117547d25bmr111047647b3.35.1750041186609;
        Sun, 15 Jun 2025 19:33:06 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-7117dc6ddbfsm6457227b3.62.2025.06.15.19.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jun 2025 19:33:06 -0700 (PDT)
Date: Sun, 15 Jun 2025 22:33:05 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com, 
 netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 Jason Xing <kerneljasonxing@gmail.com>
Message-ID: <684f8261d288f_1e2690294b1@willemb.c.googlers.com.notmuch>
In-Reply-To: <a0e726f33e940429276a209532b36090d3976fa5.1749839083.git.asml.silence@gmail.com>
References: <cover.1749839083.git.asml.silence@gmail.com>
 <a0e726f33e940429276a209532b36090d3976fa5.1749839083.git.asml.silence@gmail.com>
Subject: Re: [PATCH v4 5/5] io_uring/netcmd: add tx timestamping cmd support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> Add a new socket command which returns tx time stamps to the user. It
> provide an alternative to the existing error queue recvmsg interface.
> The command works in a polled multishot mode, which means io_uring will
> poll the socket and keep posting timestamps until the request is
> cancelled or fails in any other way (e.g. with no space in the CQ). It
> reuses the net infra and grabs timestamps from the socket's error queue.
> 
> The command requires IORING_SETUP_CQE32. All non-final CQEs (marked with
> IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 bits
> of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). The
> timevalue is store in the upper part of the extended CQE. The final
> completion won't have IORING_CQE_F_MORE and will have cqe->res storing
> 0/error.
> 
> Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

