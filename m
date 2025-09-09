Return-Path: <io-uring+bounces-9689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C382DB5050E
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 20:14:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C03341C64E8E
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 18:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9786633EB10;
	Tue,  9 Sep 2025 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pr0ujVPx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DAB2F4A
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 18:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757441683; cv=none; b=A5G+LYI/BVBDv0whjUdZMU02JyoRDFF6Re4cGfZKmE258EDVFEQBa4co5u8pzmX8nwFRU4AdFqLEVXGcw0wCubcfoLCJqXn/uzQH75BhzfW1K4WYOGiUumVv3ZxxPkeq9jWpYIAD2GgpdFq+GcP2MQjgGfuHE2Aa7eulr59+UN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757441683; c=relaxed/simple;
	bh=uI1wjvIjVie1NesRLG312MngKxT3eOO8ZcLL/uPo1aE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rxdk83jeUirshhS7eYzBXHo6HcujyEP4jVQ2u0lBRv2Y3fg++EiE4RHEwT047Ip0CnD2J9s0gEWSBuw3AWnK2IFHDKbRy/MZ0N1LslhWlR+eMq27So08tDw9+aNC3nesaUcIvBCvUTGf8Vjm9Y0h0xWXk5cB4syNvrvc02PjrmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pr0ujVPx; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61cb4374d2fso8991554a12.2
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 11:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757441679; x=1758046479; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vfO17BHW0rZfNCT/9fgYlAw+m8wHcd9WOi8933xChxE=;
        b=Pr0ujVPxUut2n+gUpYcLp9ufQo2akhalm3hFRK3QBBGXlD5CoWcogZJ09LbZ5hyTY6
         nAdgU1hAo8DvqJHChupnY3i5aiLBBhEHBxNYm1DJN65IYvDX14ymvzOuSI9EXn+9g/Lp
         EoyHVTrflYCkpeOLS3ePrwbsc0hiPyimCgpws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757441679; x=1758046479;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vfO17BHW0rZfNCT/9fgYlAw+m8wHcd9WOi8933xChxE=;
        b=vDyMTOg3ULKpjQpb7yzkkp6l1hbmdpNbYlIhYFVCweYvi6Z2MZnKweznD34o59QYHu
         itgN6qhVZFsWQpND4IJy2bkenjD2tb02Bhux31H+6AnSwKCIyMq46UDNqFU5eQRI6Bvn
         j+1jKvoGPjGVJ0Kr1nf+02rMQX1fb5HjJB44CVwNTRtg6uhHFlxLcGzQPoaSvJGIh0us
         0H8IjOCKsiRka0f0FV5ZCJL0YyymP2/XTt8VbdjPdjbd+E2CoU77/dAeM+9ViAr21/5h
         DXAUDoD8nWZSWsqDY8HDG+7FKDswx/ubD/wcL25U7zMue1NRbrDZ0P261zX1khvgG963
         gGRg==
X-Forwarded-Encrypted: i=1; AJvYcCWDA1t1s+QFVm9isTUkUpGNT3HI7oqyG0aQUh80CDHOCqrZx2YTedB1TafmNfjyepW73HCnyQmniw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuDjHwhu3aElwwbFI3WhaEN+6hZfqeZDUKFVivkQ/j/N4brdOY
	O5mcVeFjZwtOmTSP9A5NcUId7e+ztGE7dvdt4OJpkUScllSYM/4kIvBL1n+N2qEbaqgEcmBWPM/
	EeXc7o9g=
X-Gm-Gg: ASbGncv7lGyQBLPps3JfIrMlw3q74qvtG/wZLEMBDyeMGAJjijKt7Dy8EeP2+r+DXnJ
	JKeBC6NvXvjnnilPo0JlNZ+UhgiwiJ88mPl/62qR3oy+o5t0K6uzgGtlWLMz64fxZMrh77SVC9o
	dEJZ2sYagnUAxn2FrcSCBnVpCMJfSeDmeR41Jfv9iosVZ6FKCm71HSicujL6SSnXDsBSXBC0FoL
	tfzSBxwK8f0xAd5/TYD+MpJ1ixEoz+HpS4nz6bKxjYGuD5wzIW95JcdkfeRDsGiUkqXr7EmuHDQ
	n2z4klHMzsPz8ItIzzN2h1qNb515Tm5NB96OOJrDlV9yUl2wgdhMwF0+QrbtHCmh/WuYD6w4Fhy
	dOslTky7NAbH8Vfu+4GlmgOQGVmRyCZW8T/WlV3vBOSz3yLGBYOGPhY9jYiLinekfQdV8v9uEFF
	Gv4APlyos=
X-Google-Smtp-Source: AGHT+IGEAjsB5+KLtTOe7DEwFnh/RKaDzVTwccmUADGa6pVJtC6gE7IRQs5slV8MJbItNj2gJlM5Cw==
X-Received: by 2002:a05:6402:3510:b0:625:fd40:c590 with SMTP id 4fb4d7f45d1cf-625fd40c6e4mr10492758a12.22.1757441679381;
        Tue, 09 Sep 2025 11:14:39 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62c0123f23dsm1742094a12.25.2025.09.09.11.14.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 11:14:38 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b0411b83aafso979282666b.1
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 11:14:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXRQLl1x8rUjU/gv8zZADceUJANd19wiuIuC4J9OvwdT8oPa1Y8+wDePXK+DpcfZMeoM235p8tnjQ==@vger.kernel.org
X-Received: by 2002:a17:907:9483:b0:b04:4786:5dfc with SMTP id
 a640c23a62f3a-b04b14aec52mr1479633666b.27.1757441677560; Tue, 09 Sep 2025
 11:14:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur> <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk> <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz> <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com> <e09555bc-4b0f-4f3a-82a3-914f38c3cde5@suse.cz>
In-Reply-To: <e09555bc-4b0f-4f3a-82a3-914f38c3cde5@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Sep 2025 11:14:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgfWG+MHXoFG2guu2GAoSBrmcdXU2apj+MJpgdCXxwbwA@mail.gmail.com>
X-Gm-Features: Ac12FXyIDqMJF8_mBB-HCaVHrznKHzDDMIKV8gHotVb8Ejnx9UQuz0JOlJMmxC0
Message-ID: <CAHk-=wgfWG+MHXoFG2guu2GAoSBrmcdXU2apj+MJpgdCXxwbwA@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>, 
	Jakub Kicinski <kuba@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Sept 2025 at 11:07, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> Later in the thread patch-id is mentioned. I think it was mentioned in the
> past threads that due to small context changes due to e.g. base that the
> submitter used and the maintainer used to apply, and even diff algorithm not
> being set in stone, they can't be made fully reliable?

Yes, the patch-id is a heuristic. It's really a very good heuristic in
practice, though.

Also, if the argument is "it might not always work", I still claim
that "99.5% useful" is a hell of a lot better than "_maybe_ useful in
the future, but known to be painful".

Because that's the trade-off here: people are arguing for something
that wastes time and effort, and with very dubious use cases.

But yes: please do continue to add links to the original email - IF
you thought about it. That has always been my standpoint. Exactly like
"Fixes", and exactly like EVERY SINGLE OTHER THING you add to a commit
message.

              Linus

