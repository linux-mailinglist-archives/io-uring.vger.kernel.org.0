Return-Path: <io-uring+bounces-8796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB77B12D3F
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 02:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8964A4A12F1
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 00:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43059288A2;
	Sun, 27 Jul 2025 00:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="WG2CXYun"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF2C2C187;
	Sun, 27 Jul 2025 00:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753577657; cv=none; b=qviPXX5ArXVRCWlgZKOYm69MslfcKXBAeFjJz7ZpGiS4cxAn5vYN6HJPWiIwhnG03zAn5iADF6yYtr4WOQBiqlZPiMsoYAywF5n6v64nHCr5JCFzeljl+z1Z6SVDskGs3AIacFSP9i3LD8QyZB0V1LQ6whSM/UMuSddLTolLvKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753577657; c=relaxed/simple;
	bh=pQcHxGWwus/q1kRkMfXoizdapL8eSLjtTmsqqYbS318=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CJexsuto3gRemJoFO0m1D56B+TZG9uhHwj5k9IaSWBY0F27lN8kFORSjwXHhILHMfEDFyA7c3DFV4lAnZS0Vw7oQks0PH0NNZWTERmqiaEOVZfqJM4QNfJ6881jW4kBcKLFae9rtO7Nzr5EGYMJfvydgLRDa/X7AMr7N9CC7tj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=WG2CXYun; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753577653;
	bh=pQcHxGWwus/q1kRkMfXoizdapL8eSLjtTmsqqYbS318=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=WG2CXYunhPmCe4Um00EGYwbozRWBqULFZLkk+n6Z14K3EFZKHQecOC7nphCN9eWeo
	 isK82ZGmv82sS8TDw0E59XXYIwNkF88PfUhoIoQ3xlz0FOsZ/XY/ml+qacd3ljXh9P
	 zNB+PxW9fyf4SDG0gZZt//bgmMRsy17zTiPjADkRnF57MkDhw6pgfQv+CUNa8/W9LM
	 3nyVDL9Lmy3rfYPAwIXwJ/yl18wGMJUijZcbZa/TadpcZjjtEE3z+p6EaYFlhiRBwP
	 ehQlZHhsl/9OVWYYpx/jM9z67j5iFb2Eze1wexATrDWEoVLFgFNEp4bqQOIv4jq6m4
	 sIM1CU5MggDng==
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id E1AFE3126E01;
	Sun, 27 Jul 2025 00:54:13 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4abc006bcadso38350471cf.0;
        Sat, 26 Jul 2025 17:54:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXHoKAan+dvM/uklnfGg+bCueg7UmsUTaKQ6zIcxyMuEy2ORsHUj081DOoTzoN2kMXmlUYwoq/H+4N1oPEr@vger.kernel.org, AJvYcCXqAmm0xuDpaojHESZ8/biGCnoKkhUJkw+iXREQ/vP/3agx7OoMNfeXIaAwqbu95A/EgN8eN9ieGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjyNnd5vqB2hF9MjWw0TTyevY7A+8L0LKSNCPsGMycGue1M5e5
	1L0gAxn2G1NWD1dUlrRnhVPm3uTrIU4KavQC/979Q/wi8LXY2SeGxZ+mNueHmJi2Hzp+qLzNKLr
	2uv2ZbDNGQni69+1HFkldk/shUp4Jrk0=
X-Google-Smtp-Source: AGHT+IHF0WaOPqXEUsQUJ/l+pqrJScDPvB86v0nuQTSX/AcHfsZL4qa5trO1Sd923uNNq/pOLgAvx4wHLLx7AziO4/M=
X-Received: by 2002:a05:622a:11c3:b0:4ab:6de9:46af with SMTP id
 d75a77b69052e-4ae8ef41b7dmr99422381cf.11.1753577652757; Sat, 26 Jul 2025
 17:54:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250727004316.3351033-1-ammarfaizi2@gnuweeb.org> <20250727004316.3351033-4-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20250727004316.3351033-4-ammarfaizi2@gnuweeb.org>
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 07:53:56 +0700
X-Gmail-Original-Message-ID: <CAFBCWQL6aCk__RwU-Fbq_1qvnfW9oG+58zikOrwfU=Dq6=6Tcg@mail.gmail.com>
X-Gm-Features: Ac12FXzWJYfBFt8x1us9z7oQiLJwcM3GZqt09LHU_21eR7gCuIUK2d0nPOhh0VE
Message-ID: <CAFBCWQL6aCk__RwU-Fbq_1qvnfW9oG+58zikOrwfU=Dq6=6Tcg@mail.gmail.com>
Subject: Re: [PATCH liburing 3/3] liburing: Don't use `IOURINGINLINE` on
 private helpers
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>, 
	"GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, Christian Mazakas <christian.mazakas@gmail.com>, 
	io-uring Mailing List <io-uring@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 27, 2025 at 7:43=E2=80=AFAM Ammar Faizi wrote:
>   __io_uring_set_target_fixed_file
>   __io_uring_peek_cqe
>   __io_uring_buf_ring_cq_advance

Oh wait, `__io_uring_buf_ring_cq_advance` is exported. I assumed that
the double-underscore prefix is for internal use only. I will send a
v2.

--=20
Ammar Faizi

