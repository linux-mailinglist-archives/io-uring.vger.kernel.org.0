Return-Path: <io-uring+bounces-4945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F26739D535B
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 20:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B423D283DCC
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 19:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC7D1B0F2B;
	Thu, 21 Nov 2024 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CjBKAZ7v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B76F06B;
	Thu, 21 Nov 2024 19:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732216982; cv=none; b=rk+XzwLlKUJxccjxekItdkhUR57KV7op2eJsKR4xtOqiIArg0vZPxbrbzQSIcP+JZtIR8yMf9ePZ1WNfHBNAk6djcf0mPuWulXhLVdBDg/jgf/0RntUc9JyR6HmvDSC9F8I0YckvjOEquNuc2kbk/g05WocEQrWnQmr42MTbPO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732216982; c=relaxed/simple;
	bh=UPoyReQdMmfcqLMHWBo+CpgHM6WoKSWI2eR30CAMYQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuOxnpHUSFTMwbMYv7VBLt61SGb8pIE5vYoGcV3ewJyG5Cb0S+EdNcLDJOS/gd7IlywEv2JlJ+bm0BxjTUOlECwzfYk6s0yv7Xp04xbLiyljP6hmG0W1+4ryOJywECZGVTh0pi9SFY0OK4wHOW5BKE1jPa5CvwBCcgZUbogVeIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CjBKAZ7v; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71e4e481692so1163884b3a.1;
        Thu, 21 Nov 2024 11:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732216980; x=1732821780; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jMXPl1e6luieU7Y9N+10kogflMGEnR+4YH0MSEtHxas=;
        b=CjBKAZ7vk4KuKXz58LR4rsAc2rmpaiMDHwEyyaYPp8MWfDiMGMrSnohj8gYuDXW583
         2GHog99XleXctdFD9T48fAhUmsZeOBAqriV2DbJKc8NXpPmkPIzXgcdOBae/nPE7R1u6
         YEWn1B6BaTYtLF+LIjwQNfrNUBK+TydERU71KXex30pDUHNqocuJMRrar41VetyD/9ai
         ayPxa9XZea80zkP4RfW32RmUbE0R50SOkAyj+8ubBTWGiMVov1pd5ME5IFerVBhA26ir
         yofcMA76edz+RJmras857Ih0FHVCFTQBAURCsLvYqcc81oNyosyYiflocTdp6om8kB0F
         C4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732216980; x=1732821780;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jMXPl1e6luieU7Y9N+10kogflMGEnR+4YH0MSEtHxas=;
        b=eo95uwpH9ccuTyD1BrIAxdfktL/bdMAiHKh3wcdHF654NcPgIqDLr7IWMM3zuAEcuA
         O/NnMXZVQWQUu9eASf+c8BBs0d17+3IEk9wSFLfC5KBvzWL1VZx6kE6ArN3GX//7vCu6
         cAs5F/Jag7WuMg4s6uK17V/ZK2p6svNie92E8qeSPuw2iG1vDlkVpncDNr+mRLi4hwW8
         Vyd0RbJUcpay0oKcdYzjARRNyIR1AhVMfzoq4afQZb2All5NFKMGzZkthLh9Aw1tluFu
         bEc3KCIPVLTI6lFA7AasVgev2j2R96BPfWwg0a7lXEoRKXrY9i3igOxUx33l+XkpTkc1
         lAxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU91SFjIRRG8WvXYDhrBQmBO7ccwgyDsl3j2RmTFOqxaNoeZPuHE1qkglhgvzEqMxBL9XBQxt4Hsg==@vger.kernel.org, AJvYcCWkSjeCzZm+HVNgERRr/rpJsmgObU3GnZMszh68YvXerUC6PJKVAG8vUWGo8i/ApHRmRq0fFq76G9dQ3dne@vger.kernel.org, AJvYcCXiiwaHB3JOFzhaCcLPYvB0jZNUPdzU9H3SoXJB9g+GKfGSp9385edkcF9tH46JqlLIP1LGixAKPei3Yg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyH9J48ZqGmBlJfHZp6lgCbzha4PYU+pP7XjAfH1oiftTsgPzhz
	abIPUafGWrk+WTxDW3l6jwhhksM0VxztkvI9SAo1wVutJjl9sGSv
X-Gm-Gg: ASbGncumRgqz2QlzAD62ZG4QZ5cawcSbOPrKfNRuk3qXEdfkUitNARCzFOLLkkQfMdu
	Zo3U94gzh+RFk6BTTHFvyiU7qXsoLrASFeQ0nBJqkXUCa2co6UgLTeHr1AituPTw/ynLhpfcaH8
	VUGohfWSjnPtUU/NWyTcI7UItHhJ7RN39lu+G8tR1R5ZxWSSc5tR31FN5bJ1Hw8nM3499yVCoLk
	Y/cg7q9uE3quqE8WYWLEa7nnr6I3C9dk238fF9YezpVA1SLJ1cLmUdzRM1nMSY=
X-Google-Smtp-Source: AGHT+IFeU+EeHn8aEsc8Xfk+MY5CRBA5V7KZ4Htnq0QrwacyN/wmUAYcZvwIq/4yFCBV76yCHJxspQ==
X-Received: by 2002:a05:6a00:9287:b0:724:d503:87a1 with SMTP id d2e1a72fcca58-724df5fcd72mr213508b3a.7.1732216980456;
        Thu, 21 Nov 2024 11:23:00 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724df8b04f2sm29739b3a.66.2024.11.21.11.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 11:22:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Nov 2024 11:22:58 -0800
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
Message-ID: <4535df8b-0ca2-4c3c-9523-d27d3de2b9c7@roeck-us.net>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>
 <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
 <CAMuHMdXDmLoNAcKHpjp2O4D05nAd5SOZ=Xqdbb2O_3B09yU1Gw@mail.gmail.com>
 <508aa9c4-4176-4336-8948-a31f9791dd39@roeck-us.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <508aa9c4-4176-4336-8948-a31f9791dd39@roeck-us.net>

On Thu, Nov 21, 2024 at 11:08:54AM -0800, Guenter Roeck wrote:
> On Thu, Nov 21, 2024 at 07:50:33PM +0100, Geert Uytterhoeven wrote:
> > On Thu, Nov 21, 2024 at 7:30 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > On Thu, Nov 21, 2024 at 09:23:28AM -0800, Christoph Lameter (Ampere) wrote:
> > > > On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:
> > > > > Linux has supported m68k since last century.
> > > >
> > > > Yeah I fondly remember the 80s where 68K systems were always out of reach
> > > > for me to have. The dream system that I never could get my hands on. The
> > > > creme de la creme du jour. I just had to be content with the 6800 and
> > > > 6502 processors. Then IBM started the sick road down the 8088, 8086
> > > > that led from crap to more crap. Sigh.
> > > >
> > > > > Any new such assumptions are fixed quickly (at least in the kernel).
> > > > > If you need a specific alignment, make sure to use __aligned and/or
> > > > > appropriate padding in structures.
> > > > > And yes, the compiler knows, and provides __alignof__.
> > > > >
> > > > > > How do you deal with torn reads/writes in such a scenario? Is this UP
> > > > > > only?
> > > > >
> > > > > Linux does not support (rate) SMP m68k machines.
> > 
> > s/rate/rare/
> > 
> > > > Ah. Ok that explains it.
> > > >
> > > > Do we really need to maintain support for a platform that has been
> > > > obsolete for decade and does not even support SMP?
> > >
> > > Since this keeps coming up, I think there is a much more important
> > > question to ask:
> > >
> > > Do we really need to continue supporting nommu machines ? Is anyone
> > > but me even boot testing those ?
> > 
> > Not all m68k platform are nommu.
> > 
> Yes, I wasn't trying to point to m68k, but to nommu in general.
> 

For some more context: I think it is highly unlikely that anyone is really
using a recent version of Linux on a nommu machine. Maybe that was the case
10 or 20 years ago, but nowadays there are other operating systems which are
much better suited than Linux for such systems. Yet, there is a _lot_ of
nommu code in the kernel. In comparison, supporting m68k (mmu based) is a no
brainer, plus there are actually people like Geert actively supporting it.

If we are talking about dropping m68k support, we should really talk about
dropping nommu support first to get some _real_ benefit.

Guenter

