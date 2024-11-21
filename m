Return-Path: <io-uring+bounces-4944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB509D5345
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 20:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 808621F2179E
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 19:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56CF61AAE1B;
	Thu, 21 Nov 2024 19:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aKl5eeRb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B582F200A3;
	Thu, 21 Nov 2024 19:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732216136; cv=none; b=QsJg7zXnOXso1ea39217WJd9Z5xKNoI2ltrO9e2jH/9F7VYNy5GXNCCWWxWUh+HlmomM00Isn9WWi8L+tjdZeto/yxTVEcQieGtyf5kByafJds9Ou2vx0yKCrXItNPWdasuXncmybH9PtF8zA3vW6iuKeGoQcennqi4MzqNqlUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732216136; c=relaxed/simple;
	bh=aSnyh00fIsUC5ZDX5nHjI5fGwmj5u7jg46YIvqUp1x8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o397lgmQK+zTaMGsof+KdU/+2x8RLBWs/mhrOqzvIx5W0O1tnMcYxmAG1xjlrpQfoaG50m+TyB8OztKX3zSIf6DKqsZuR2vCVc7RRm8u1zfw3SNKxdQVKOkc8h6Cz8sB2qv7fP075AjfSv3ZzSP2nmVcggJVvRLys0lIpK5ysGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aKl5eeRb; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2126408cf52so10770565ad.1;
        Thu, 21 Nov 2024 11:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732216134; x=1732820934; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nbWq6dIR0dmg1klEoLZJOX63cY+RzZOanD3EV08YCvA=;
        b=aKl5eeRbqmO1z1/FLAAkQtwcm+i58dZdPqVBzBHgws/Vbsr+qjeBxcG8a2SHW4OAWv
         C4Q+Hf3wOu6NwAB4XRizSEasLPpiq/dTJYQKf4XvspSJ7SaXlF7Ei/2/5KFtBLTCfYkb
         v9uflF6x13xalCT/sDpK4mUMA9seCwlImuJDdeb9yKQaKsMUgTRWaF2vIVWh7RKLZJD4
         ICN7VNLZN3dqSQ8drxoT6AU4PNXkrr3NKCbtQtGF2lzdI+jiad4TnwON9UZBhAf0m3Js
         z2l1KlSG6HSHoJ1XstZ45I8y88Tzg2DWIzaZQlavVIL1ylE3qqOler8m/d/g8gWSXoJE
         YAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732216134; x=1732820934;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nbWq6dIR0dmg1klEoLZJOX63cY+RzZOanD3EV08YCvA=;
        b=iQS0b9BnPxPgXpgF0SbMjR52wcPxvgCEd0TW8a7FNpV2rIbWU1iC3IcBYUT7GImm4F
         q2FnAyoVzZJHdlhkfRrxk8wfQCUDQtWdR8brCViJ55teogwxYCziLllWRrJeOB15HtWD
         klqAwng31e6U+oCvg6s2dN0aSJof+jmGXs4Yeu0LK+hkvlH9G9e/edwUky0iwFuueav+
         gbOovsI5BOJ2WY52pWN6V6MgxqdbYLP/JsqzrvsbIQaWVjNNBvbStmJJIoQ80nl0J9zc
         mpHhLtUht+uDNnumOumLmGuSPDOlp3Ib3A6aC3N9wLYYe5icjYPMdaS2Ls4fr+tCxo6E
         sIVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSSNEZkuYqoI3A3S3qrPemuRx4BdyKPQoj+5rRMCjU8aZ5B6tEyp244FEXYhQW5+JD7I0BZtSMtUet+g==@vger.kernel.org, AJvYcCWYNX+axLbTyrGE17F3pVIoWrAmzCHpuZjg3MGcXe5bsanRbfVPkpdmXZSs5bcbCNu5DBMK6DrkrDo6XBX6@vger.kernel.org, AJvYcCXQLfw93NuliezF3NymagUKaszP1gwoFgsN3pnGYQvluBNjrJVUuLMEXPuWY6DnSyH4YX0U+qD2wg==@vger.kernel.org
X-Gm-Message-State: AOJu0YybDcf5MO8d29edzS3AGkrFfsKBUGZsHyWpDPoDgQzk0Q9gpwds
	PT97vI3OSgCaZpYh9jmkpe3hLCpiCR/VACGguYwB/E/Y10j4GH7T
X-Gm-Gg: ASbGnctWfq92DSOO9kgo34KfOYzC3ImFQKg4KDBjV25eiqxmFIEfUnfnwIw+Ap7Of/L
	1YZFasQznQitkprH2Jhmu8UKSCRV3p45ZkNLhFajDKhYehEF7uKrkGB1MJMuzUXMsw9uFzTW8R2
	js8eZGIfbmzQH1cV+Hy5USOIol5yRTuUeqXDdpMOiLAGQlVsBpGkG76lG0mMdk9Hk8xxs1CfSPt
	ivGaN/V+1AePHRvgsdBkOwJjxN1bORh3OseKt8qakRAb6XRpZDna1XWd90kBXk=
X-Google-Smtp-Source: AGHT+IFp1nsvaBxxBP2+yKyPHL6/9xKZ1ZMDef8nNNgh7X2q36YFA4vEpFb89L6mjd+kNgwZJ1m9+A==
X-Received: by 2002:a17:902:dad1:b0:20c:ee48:94f3 with SMTP id d9443c01a7336-2129f433d4fmr1047445ad.14.1732216133794;
        Thu, 21 Nov 2024 11:08:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dbf979csm1685255ad.129.2024.11.21.11.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 11:08:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Nov 2024 11:08:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
Message-ID: <508aa9c4-4176-4336-8948-a31f9791dd39@roeck-us.net>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>
 <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
 <CAMuHMdXDmLoNAcKHpjp2O4D05nAd5SOZ=Xqdbb2O_3B09yU1Gw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXDmLoNAcKHpjp2O4D05nAd5SOZ=Xqdbb2O_3B09yU1Gw@mail.gmail.com>

On Thu, Nov 21, 2024 at 07:50:33PM +0100, Geert Uytterhoeven wrote:
> On Thu, Nov 21, 2024 at 7:30 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > On Thu, Nov 21, 2024 at 09:23:28AM -0800, Christoph Lameter (Ampere) wrote:
> > > On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:
> > > > Linux has supported m68k since last century.
> > >
> > > Yeah I fondly remember the 80s where 68K systems were always out of reach
> > > for me to have. The dream system that I never could get my hands on. The
> > > creme de la creme du jour. I just had to be content with the 6800 and
> > > 6502 processors. Then IBM started the sick road down the 8088, 8086
> > > that led from crap to more crap. Sigh.
> > >
> > > > Any new such assumptions are fixed quickly (at least in the kernel).
> > > > If you need a specific alignment, make sure to use __aligned and/or
> > > > appropriate padding in structures.
> > > > And yes, the compiler knows, and provides __alignof__.
> > > >
> > > > > How do you deal with torn reads/writes in such a scenario? Is this UP
> > > > > only?
> > > >
> > > > Linux does not support (rate) SMP m68k machines.
> 
> s/rate/rare/
> 
> > > Ah. Ok that explains it.
> > >
> > > Do we really need to maintain support for a platform that has been
> > > obsolete for decade and does not even support SMP?
> >
> > Since this keeps coming up, I think there is a much more important
> > question to ask:
> >
> > Do we really need to continue supporting nommu machines ? Is anyone
> > but me even boot testing those ?
> 
> Not all m68k platform are nommu.
> 
Yes, I wasn't trying to point to m68k, but to nommu in general.

Guenter

