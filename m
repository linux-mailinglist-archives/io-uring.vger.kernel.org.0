Return-Path: <io-uring+bounces-9963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A468FBCE820
	for <lists+io-uring@lfdr.de>; Fri, 10 Oct 2025 22:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBEB019A723C
	for <lists+io-uring@lfdr.de>; Fri, 10 Oct 2025 20:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8C8258ECC;
	Fri, 10 Oct 2025 20:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YFENwmmz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B517A310
	for <io-uring@vger.kernel.org>; Fri, 10 Oct 2025 20:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760129107; cv=none; b=q/FlwRKIBYrafPN4x1TvZ8mjbo2Y3yqw99bi7U6YX6ysyw7PG0fRVKKz/hL/HLLeSdB+cs1Pp5G9WyddDU/b+0L8io8OuuUsyxYrLJsStKDziYtgIeWFG+DSnANqjJkedzFuO5S5bo6IV7fgT/14MD/uNZT69/GdOUDStUfVP/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760129107; c=relaxed/simple;
	bh=nuSFDI9H1z7wN/nVEdoVNNqk05aGbOj9gvqEoxFvYGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IPRW9nyW9qMfHTi1xl4Ucw1fL364NbFVctVaf9F3/YBjHk5fS0my3KP+XKKVXfx9cuRt4Dxh7mXigjBJuD0AW4yxVsBQdpgbuJ2KBV5GVhx9EPwnsS6HCSNCs7/y9FwTfco3TfL6K8a2xAe8L7PF8ymUybqlnFBv4GUvRk/8Eb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YFENwmmz; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-267fa729a63so4223945ad.3
        for <io-uring@vger.kernel.org>; Fri, 10 Oct 2025 13:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1760129106; x=1760733906; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIXfrhAguGMv/bX4xmEAomoaQfyhDk8/Zl8fqtomZqo=;
        b=YFENwmmzRXvLjXuRA7KVx/unn0pvefhr3HCJabrKbnXLCNiwOSWk4DilROZnu0F5KM
         2+2kgWIwVj4SvW4YNg9G8mIWOpU10D2JLx4smn6CvfcdJAZr/d4fqFSZo+3TViKdX9ff
         No/xAJArfXgLEkpMvWktXoe4GmIwuuyJV7V+cmAAEP4RRlNKj9GvQ3EdQcs6sfMyV5Kp
         KrwmbpSLPqGbkOn5lS5yn/PpQUP7kK6jlTQjyNy/+Sp+jg5uoqzys0Wy88g+mPuEmrmx
         A3BketMXnYeJN0kPQJosVXXEks7af7AxsiUA3wLJ1+MXLwjfBiSWYZ51EyDPN9gNdWOF
         mU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760129106; x=1760733906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yIXfrhAguGMv/bX4xmEAomoaQfyhDk8/Zl8fqtomZqo=;
        b=ICcRoYslhIFmOPjnhbUndgnHTxS7z6YPq7aqGVPUUix4oxsg68K25W7GofqMs/16iD
         cuwqTmpuzs8pjO/tLEDE1LjZ3xxhH1CLagfprrzKxAIZ+CKG7ANjpQWnSZ82GVvunyKr
         /rb83Olb/CK7qDC2kFsBRbb1zsBPuITEnM1Mq3tAb0l3QekrmA3GvOv5OWGvuxABnxxG
         LMQe712TbM3/FRehSRsgxK3FUJSkRcSG+OGV8IFyAHeBpkG2AwNV5Jx/em95SpjlfEbT
         WDEvHhDWwK/YXTUgonXps3cfd0s8NLrpxuvzdnYR4SWd03o52nrNFdQPrVgwBqqn80qF
         serQ==
X-Forwarded-Encrypted: i=1; AJvYcCWskxJzEQG2FDVdyaM1boh94miJM3reAOxCUu61vDcl2HKtQMVV8or1fsIeDrBCQfRvgDoZHWkssw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxH3oEVx5Acw51ZZt7bI1eEux0Sb9KEaWZ9I+/iNHfMDWPTWdx8
	KPN4pb317LGG8Mqc4yvRAvRbUBjHmub03FcISh4M7AXDYzMTvo8M+M+JN6gaP3QFRUhqnKOCDvt
	zIJReTzz/c7xxGWTT2VpE0jhIENMmfGhc+1nuWStieA==
X-Gm-Gg: ASbGncvC5/SvliP1Dt3moX+tGD7XV2XwLpHHNvr965kEgodtX0a7+R2Fx9aD/KOy/oe
	bfpzmoayolxJTpER6MZHb+M61pKWjp106V+1clA/6xnAqiFoMbviR/2QeJnvBih+LbY60Z7bnpM
	kWeqRM+AQhYUPnJXUUxM+f3XMWiJ4nXSnokFmTlRa6AKX/18ASQt8r1IDfRRJCV+deOSjzNeurM
	kyIbEb4260Rlj0T8VPQEparpg1h4pEkgKt3fOTZ1AcOz6ze+bxv2zryOyObXx8x9887gKQ=
X-Google-Smtp-Source: AGHT+IGR3xF61Y1olOQgtoO6mAsjqi8GARXS1soZGepNoUVHDze5vbFgxUI9BjM5ZBJwEuO4wB1I1emRzI5N6XE1x14=
X-Received: by 2002:a17:902:da92:b0:25c:9a33:95fb with SMTP id
 d9443c01a7336-29027448385mr95222525ad.8.1760129105325; Fri, 10 Oct 2025
 13:45:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009143645.2659663-1-kbusch@meta.com>
In-Reply-To: <20251009143645.2659663-1-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 10 Oct 2025 13:44:52 -0700
X-Gm-Features: AS18NWCxV-d7dcGQfj1n45-foaMrIH4ayEU6u2zN_tOpKYYVLwJIIAxkClxLqKs
Message-ID: <CADUfDZoJkk6a6Kx4=MAnPbQHycA5AXe=MUrPkuWV8fmjb=H3HQ@mail.gmail.com>
Subject: Re: [PATCHv4 0/1] io_uring: mixed submission queue entries sizes
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, Keith Busch <kbusch@kernel.org>, 
	io-uring Mailing List <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

FYI looks like you may have the wrong email address for the mailing
list. Should be io-uring@ instead of io_uring@. CCing the correct
address.

Best,
Caleb

On Thu, Oct 9, 2025 at 7:37=E2=80=AFAM Keith Busch <kbusch@meta.com> wrote:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Changes from v3:
>
>  - Allowed 128b opcodes on both big and mixed SQ's
>
>  - Added additional comments for clarity
>
>  - Commit message fixups
>
>  - Moved the uring specific entry size fucntion to the uring code.
>
> Keith Busch (1):
>   io_uring: add support for IORING_SETUP_SQE_MIXED
>
>  include/uapi/linux/io_uring.h |  8 ++++++++
>  io_uring/fdinfo.c             | 34 +++++++++++++++++++++++++++-------
>  io_uring/io_uring.c           | 35 +++++++++++++++++++++++++++++++----
>  io_uring/io_uring.h           | 14 ++------------
>  io_uring/opdef.c              | 26 ++++++++++++++++++++++++++
>  io_uring/opdef.h              |  2 ++
>  io_uring/register.c           |  2 +-
>  io_uring/uring_cmd.c          | 17 +++++++++++++++--
>  8 files changed, 112 insertions(+), 26 deletions(-)
>
> --
> 2.47.3
>

