Return-Path: <io-uring+bounces-5741-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D97EA0486F
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 18:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65C8F3A666E
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488E618C345;
	Tue,  7 Jan 2025 17:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y/RlMGXR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB4F198A29
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736271538; cv=none; b=ednDLaucW6oFx5EJExHO1X3ql1R7ItnnWD6p0MvQhR0mZ2hX6kR1Akw4bUtKtaF09wuaqIRJwYqZCCpl0VbMDpOnzIOMto/QMsqYH0RIg9W06dHZ5dorFj/Q1kXFjesJXpkRxXL5yCdWS9b+QdvfFMbVn/g5LzF4uVEAAdPDdoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736271538; c=relaxed/simple;
	bh=7JAsg0jMIqzjpHUocaOM4Sl0iUPdIcl3GEIH/mgrNko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MbUHZ4Ji9uD5TIyEwgwEnkf88Pre1c2x+EgIeUdeorG3B6E+IyELhytTTZtNtMn64BfHoCAIlBBo9TWjZDe/hBRoY28NLvfBS59LviIz4+4LqmddKDVSiBH5sgC0Y9kC/BUDqdTrTzJHglibTWDLqChYwdKTkTndF0Cs11CCwuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y/RlMGXR; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3e6f6cf69so27454796a12.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 09:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1736271534; x=1736876334; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i+YiOaS/WwM+ePJ+wu5aFgqLo7Wb+boMYAzFfKRkDCE=;
        b=Y/RlMGXRZ7yH1TLw3YgF0Q5XfWvHZDu/bPimLmDV4jjCFPwTzZGNFVISwu/PXgeblR
         juuVc1acWc7n0NqQfHzvcyIms2GDfys36T49cYtp40Uvd361LeUUvF3JS+EO3FVNf7aW
         4EHprOnZGO3R1OGC8tY/tmlzEWgsHGWjpI4uE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736271534; x=1736876334;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i+YiOaS/WwM+ePJ+wu5aFgqLo7Wb+boMYAzFfKRkDCE=;
        b=tphNzMAQTSOWYdauNFr6IRYG4LHrIWF0hdSFu6vsdemClOV0xzjQqGBMC6VMGedyIN
         2WTK61CaX5dsxdONzyztL46HgWfA4Ft1Xzm5yxSrzibEszH5YF9BQsIy+s/V7O1OPLE3
         VJwLnOmpuIDHjLCZqRk5oN+LEjXdecKzEOcj2iqFAan5R4yBvu+AXrBfI0a2rGAXs1cM
         K2siqIh0w6UaCMF8SaAFz6vCPqw9Zjg66tjIGeGq2tTa+Xy2Yl1DjJlboHYyT2xqZGo6
         S1ia2DWDb9F73NwCJa6zAuHLqczeOY8AFoWqRO5HARlqyqqVxvK5t/7YoF5fuUHRdIZs
         MQcw==
X-Forwarded-Encrypted: i=1; AJvYcCXEIDZRHDUMpdMh7T59SOjM/fCeDyhkFjg/aIz9BBIuc2TrE7c44lVU7gVEAnBiOQMHyECmp1ICiA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0EzImO/R4rx54f9m7m5LUDqJpQdTPMi/ikFHERdKvZrFXE0MG
	ORDeZs9kIigKQC1jfOK++zMg9apaatB4WmSDSKFOnf5Iu72WgxD1QiBI35zCpD7wiNXcS6DzwZz
	prAM=
X-Gm-Gg: ASbGncvewDQVp4KkjPcbvmcj+wFmjdJCZrwbtEWQ6Tla98ghJHYC+v84MZ6kzaoXMeI
	S6l4ahuEi9vKdQ44R/jTCgHHQuDnsDoZE8tjzqMhIRdxUmJsPL319oHHBaWLE4dRNVF2oSdSBIZ
	ZFno/bAMeISU3bcp0OXKNaPeC6tl+uzQL3BM/NpA3xxv8cBreXS+3xyLOFKxI1vOQC/DnKep9Jt
	naFtLXpoW6OW5tlfKAGeq4qzcMb45uGBd5CRtzSmPxqAh0EgNG7gRR0/Omk26+GPuQhu+pMoSXg
	36kQ0sa9MMA7nXD8hscfwhGEbMu2H6s=
X-Google-Smtp-Source: AGHT+IFvs/pqUxPHlXDuzQIKc1UOWaKmzUIvk60WPKOI5U7ks91g90nZL1opBTrjPW/9UxXFwnEWDg==
X-Received: by 2002:a17:907:60d6:b0:aab:daf9:972 with SMTP id a640c23a62f3a-aac334c0ba9mr6226725666b.28.1736271534362;
        Tue, 07 Jan 2025 09:38:54 -0800 (PST)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f066130sm2417961066b.183.2025.01.07.09.38.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 09:38:54 -0800 (PST)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaeef97ff02so2006342666b.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 09:38:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUqfG6+EaX8egWmXp/gbfpc9xqF1E8IlrIiKNWHlQsMnAdRcDGiZTS4ONDPewkI0Ci4jXF56g+4rA==@vger.kernel.org
X-Received: by 2002:a17:907:3f89:b0:aa6:9624:78fd with SMTP id
 a640c23a62f3a-aac3444eb22mr6324195566b.48.1736271532650; Tue, 07 Jan 2025
 09:38:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107162649.GA18886@redhat.com>
In-Reply-To: <20250107162649.GA18886@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Jan 2025 09:38:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgvpziaLOTNV9cbitHXf7Lz0ZAW+gstacZqJqRqR8h66A@mail.gmail.com>
X-Gm-Features: AbW1kvaB-leK12kGlT66BV6_b6FtwbtDH9VocCPIxNTa3S3Gc83wtFOKyImflWY
Message-ID: <CAHk-=wgvpziaLOTNV9cbitHXf7Lz0ZAW+gstacZqJqRqR8h66A@mail.gmail.com>
Subject: Re: [PATCH 0/5] poll_wait: add mb() to fix theoretical race between
 waitqueue_active() and .poll()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Manfred Spraul <manfred@colorfullife.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 Jan 2025 at 08:27, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I misread fs/eventpoll.c, it has the same problem. And more __pollwait()-like
> functions, for example p9_pollwait(). So 1/5 adds mb() into poll_wait(), not
> into __pollwait().

Ack on all five patches, looks sane to me.

Christian, I'm assuming this goes through your tree? If not, holler,
and I can take it directly.

            Linus

