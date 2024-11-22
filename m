Return-Path: <io-uring+bounces-4969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 391179D5B02
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 09:25:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F34F5283635
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 08:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196CB172BDF;
	Fri, 22 Nov 2024 08:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NuaPxsdm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3FD230999;
	Fri, 22 Nov 2024 08:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732263947; cv=none; b=tqRBqeYBaHRrXK/O8JyYjrQthL3xNb3Du5u/mC9KVhgX1SYBZKw5Y9VDbC589G4N7EtSn1YsM3jHumBQ89dv/JWQAjpLtvS9ktS0vj3xTH2+uLzS0eFlAASLGCsWcazN3y9TmsSVpeeaxlmAYsIlqoqGRgc7+5VDoSNwnvMxZg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732263947; c=relaxed/simple;
	bh=yAmH6T1tdF0XcJyKdSiu0YYaLreJVAXRxiC/WfJt1f8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V9zNsocUt9XF2a8B1OKPElHoWqRyPwiBWEtIMega2k/L78540BQDtYo0Mb1qewfuZnS9HDa6sIWtnEfipXfOhuLEfae9tLiwNrx491eqsJd1L6vz2godMi3BiYkhzAu4QQR9AjmUxzfMoLK6RBtvocE8BGlfR2elYyobrY77FUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NuaPxsdm; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21269c8df64so19741885ad.2;
        Fri, 22 Nov 2024 00:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732263945; x=1732868745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAmH6T1tdF0XcJyKdSiu0YYaLreJVAXRxiC/WfJt1f8=;
        b=NuaPxsdmulAKYfKa7yg2XTfQUUHnr4WVw1JokB29Ojt/Ggem+tbdSp17LfjsaGazqG
         H/cdI95duwXQIyQ3lliZNLPhE/C+9SNlcHbJ+hoRiTRXKvpsBn79+d2hrqllrQ/3fD3O
         p0Rh1yroO9pYP247zfdcPPqgmi/23NS5/QxnlHd1GN8i7jCCNuflfLWAukhedtX6n8ft
         ulfvRbv1L8llpsjtYbRayL/Lt47FXjX+5lu1WRRc06vAJtN+drqRTfK5a3Pm12Ub0Eo7
         MZMdBhg75K8BKmzFC/xAWmf7BQpAJc3mMY/iz2VoUnlIoZ1c6Oc/FWKpjFiA87r/qKDQ
         rhjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732263945; x=1732868745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yAmH6T1tdF0XcJyKdSiu0YYaLreJVAXRxiC/WfJt1f8=;
        b=JwORXTVzlkJGeczCbewRXqHy1lZmg9Ud2SiXSnhZr3wfOokuc1XblayLAx5c4YjEUs
         jWHHlbBKKpgPnmnoSVLV5IDb8ZdUHeXBFGKaj06xgbG+B7sEsec71rIFF+U6W64oHly4
         BRvqcnZjUbwDsy2EJqYetIRO/QL7s4iD3EiIXKIJ0yc+qF+cdYzSpNLeXwYFyfv9AhZQ
         edhDn8N2ZKse0LXm1X4FvicVoW7ygwFHLjOiePmbaIQ1KmTRQTs0UPW7cXYzWp8FWli9
         FTyYlubmzLnWHYN/WsOJKpcVX+CY6MWSnSF2NlhFSjj76AtHdoIA2toRqARClRIOjf4d
         rPWA==
X-Forwarded-Encrypted: i=1; AJvYcCU42XoVnvFmb9Mzivp+GPJPJYmNxPC1BCKs20xuu/XQjRr6ME9yVIi0rK0gM1MC21o5RiFVv9Izsg==@vger.kernel.org, AJvYcCU7nGUJAuA25nNG1s3Z59bZaSFbXQVd/u4/+RQkRaCWrJXCNpFrVbF5hUncs2fGMOa7v1t4n3EZ7GItK4wO@vger.kernel.org, AJvYcCWSP+A2AHkEXDdidEunFfhGeHXNA2pE4Z+1bHYmQvJWTNP0PW76uLAvjbOwEcyWced+xrCqw8wYp9b48g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTpXRVtbqmbWm/hOfjRfnFmX+fLreuYKw4NYudfbqoVZTarjB4
	1gszBrQIiWN9mRpogyjGCHfFFL/RTibP/Vuh3C/P3UNiCNVCYrmRwWRk7mTbOD7uaNTOIiYrp+I
	fVA/SJsVDDpABVx0MjDel1HzrcF38Yg==
X-Gm-Gg: ASbGncu9eWSapYglE3Q9YaXFmgrbkcPXSPC1ddkSJjWbzXCtjm365Ycgfw/CAt7FO1q
	o8TnS/VhTNFRZF2//vkJ98zDU2mQ0ub2Xq5Ng+J2UOSBfKKhPkEBHibgYzqjYmGqZ
X-Google-Smtp-Source: AGHT+IH+YPumzZQQRK48vkUREEKMiUSkBhMEQ6X+5SUQkuD4WUq5yWNL/A4TjyAj6CWxeob4+HGzkW5IJZjAciXtsds=
X-Received: by 2002:a17:902:ce82:b0:205:3e6d:9949 with SMTP id
 d9443c01a7336-2129f7bf146mr23852325ad.52.1732263944705; Fri, 22 Nov 2024
 00:25:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz> <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org> <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
In-Reply-To: <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
From: Max Filippov <jcmvbkbc@gmail.com>
Date: Fri, 22 Nov 2024 00:25:50 -0800
Message-ID: <CAMo8BfJiihM6e30_seMpQ5EjdgrPW4Zhw-V-yMC3iNfAt6Bd4Q@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, io-uring@vger.kernel.org, linux-m68k@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 10:30=E2=80=AFAM Guenter Roeck <linux@roeck-us.net>=
 wrote:
> Do we really need to continue supporting nommu machines ? Is anyone
> but me even boot testing those ?

I do rather regular boot tests on nommu xtensa (esp32, esp32-s3).

--=20
Thanks.
-- Max

