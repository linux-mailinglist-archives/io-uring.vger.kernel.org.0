Return-Path: <io-uring+bounces-10735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 046C6C7CE5E
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 12:31:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDAB83A7FF1
	for <lists+io-uring@lfdr.de>; Sat, 22 Nov 2025 11:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8794B2F28F0;
	Sat, 22 Nov 2025 11:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WR8bKuAq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94A529E10C
	for <io-uring@vger.kernel.org>; Sat, 22 Nov 2025 11:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763811106; cv=none; b=uPTt29YqYmbz74s1fZflsSWHSBKIccl5REiT5uO5lTVJ46utJbksG8+6sN4rlWQATdZ/sgmwCxF5HoE4nzMv04cfTR2czygEO1ryDh77Ew4/OcUIlQAoP+YGyEyUCcqK+0Ico5NRbADXKDVibLad5tp7jBHt/vRgmDchk2oNAi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763811106; c=relaxed/simple;
	bh=wmHp3rXeDWSQjkdzV0nTtmDYw4f+v+13WJTVYz8EFDM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mleuraNx8O1XCsmm32iGBgV6ynL9QCFS5/GoX9tJkz26MWobDj09jN0k9hl26eBofzJCm12Of2xykw9YnFSwHfDJRsfRn/tvyAslftJuhdbMO335mD0HBGQaUz9ljA2gMRsIZL43imck4NoZowYnWjZ1yOPD7i3fxrqUlokwwhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WR8bKuAq; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42bb288c1bfso1722548f8f.2
        for <io-uring@vger.kernel.org>; Sat, 22 Nov 2025 03:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763811102; x=1764415902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQ8THncOfm+J1kMHGeGBG0fceSI7AZuIrbUhZUaPBEc=;
        b=WR8bKuAqV1smPC01N24PRZiiY2M+cyrQxey5A/Hpjg9W1uxgvQpoBH0K8sW4dd43Tc
         /9ZITM8etgLZdhdNBZFaxxnI1bU4oFgMGRu9iFjyso46RKDGwyNH8h+DRJRrBwcgda0K
         Ua5Hma/2dXfGUDxsZhIkFHXJkWDHARb3X4hORgs24JgHlMw7NNwX4XgCcX5oJvJ1+9j5
         nhmnOt2Ao2g19cYqqAAC/Cm66eldrMa9hQUpRoNoQXmJjz3zNocnxYMdEDaVO37d6XJh
         8fZTr1XOdMyKBJBAV/cb1PQ75Oas33YP5+GYDHawg8mfoC7U7blAuKEBW0W58SvgQ5Cn
         Lifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763811102; x=1764415902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dQ8THncOfm+J1kMHGeGBG0fceSI7AZuIrbUhZUaPBEc=;
        b=A3BDj8wSgPe1IrryEUg9iCaluVkDnPMfb/nD1MJBkhvgn2HFJ/Su4ELtRVRsacFb3i
         FJEAfY+jjMRw0cJIjMFBSxm0ByRrwePXt+nXnODpi3dHGVBSa40OkP2g8td7CoQVfRl9
         EIaH/MisbBfQnPlKFkou3sJ/QllsYzHQPj6ulfpLOBPcLzDgswrpkFmI3B6tpb7ew6kz
         hAqzz5TQC3FPmpYqyieBNT2kUrkkxiKlpoD8Zdc7lZuysNTiFreIR/2aHby0WAktUUmd
         /VXGLziCL074ktnHHddwWbT/ZoLnFwrxX3yHw7MJIJ/I0b2YG0T4qUM1VQvB6hTJ4D/r
         cPSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEZiBxYcigud/9llERblJXF10bbSAXY/80RmYDqyWoPDy6d3xzP7awr82o7cZS/qH9gh+zEEtRXg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp23qzYINrA7q0vKfASRdjvMBUYxp7eOZHFeTSAGR1chIYeMNJ
	/t9lXkOsf8Cjlc+YmVc9ANNHVXUbmcS4ByQXx6TFK+klpzfvs9JtRtaH
X-Gm-Gg: ASbGnct3l7trVNAJmyBzb8vd6ZOq+daRPOrnZTFc7jfLRHK8SBgWtY1KMVXi+R6BCC/
	V7vJaK5mv7AtA7Eo0N7/jx5OVC3dFG0Ri83Eh1Hn7hNCTytmBP5wfUo1Nvs6SN00XJF7S09btKo
	h+9I34QEQg/+9XJZt5cl/41EwcqPVUHqksGXX6he0S/TpmMXFAJjWqqiFuZeFlIpe56rriK9jLh
	7KWfw9Hgu1ny0zdlDJaNcmnuEg9YCvLiXeg/MhtVgA7xCyBUq9P/+VcaRgtfmCkX7wcqsgUuQ4r
	S55ib5UuQDAl/YIc1CutKLBZKXCZwRpjhL3Kjhuohi+OGHpGXZ0Qizuykm0xVV16T3ARdYZvR4A
	Iwd+zUItljbu5SV4zycIeaKVahjiftPkmT0bgDoOf1IKY+s88UOb8Xxcu3qyrxFDro8U1NG9759
	DaFl7U3UK/YIUszEE1B0sDrlay97SAHWXnv8jzAIKg5VLUgJTiwFv1
X-Google-Smtp-Source: AGHT+IFpCNXvQJkuktd1+yH95amqCaFEYwq+Vi2X0F3ZwM1FqHxYpEmefVT0W67mZUstfw2O7XRJng==
X-Received: by 2002:a05:6000:1789:b0:42b:40b5:e64c with SMTP id ffacd0b85a97d-42cc1d0c3bdmr5811020f8f.30.1763811101605;
        Sat, 22 Nov 2025 03:31:41 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fd9b45sm16124281f8f.43.2025.11.22.03.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 03:31:41 -0800 (PST)
Date: Sat, 22 Nov 2025 11:31:39 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 04/44] io_uring/net: Change some dubious min_t()
Message-ID: <20251122113139.2462035d@pumpkin>
In-Reply-To: <312fe285-3915-4108-bc49-3357977d644d@kernel.dk>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-5-david.laight.linux@gmail.com>
	<3202c47d-532d-4c74-aff9-992ec1d9cbeb@kernel.dk>
	<20251120154817.0160eeac@pumpkin>
	<312fe285-3915-4108-bc49-3357977d644d@kernel.dk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Nov 2025 08:53:56 -0700
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/20/25 8:48 AM, David Laight wrote:
> > On Thu, 20 Nov 2025 07:48:58 -0700
> > Jens Axboe <axboe@kernel.dk> wrote:
> >   
> >> On 11/19/25 3:41 PM, david.laight.linux@gmail.com wrote:  
> >>> From: David Laight <david.laight.linux@gmail.com>
> >>>
> >>> Since iov_len is 'unsigned long' it is possible that the cast
> >>> to 'int' will change the value of min_t(int, iov[nbufs].iov_len, ret).
> >>> Use a plain min() and change the loop bottom to while (ret > 0) so that
> >>> the compiler knows 'ret' is always positive.
> >>>
> >>> Also change min_t(int, sel->val, sr->mshot_total_len) to a simple min()
> >>> since sel->val is also long and subject to possible trunctation.
> >>>
> >>> It might be that other checks stop these being problems, but they are
> >>> picked up by some compile-time tests for min_t() truncating values.    
> >>
> >> Fails with clang-21:
> >>
> >> io_uring/net.c:855:26: error: call to '__compiletime_assert_2006' declared with 'error' attribute: min(sel->val, sr->mshot_total_len) signedness error
> >>   855 |                 sr->mshot_total_len -= min(sel->val, sr->mshot_total_len);  
> > 
> > I'll take a look, I normally use gcc but there must be something
> > subtle going on. Actually which architecture? I only tested x86-64.  
> 
> This is x86-64.
> 

It is related to the test a few lines higher:
	if (sel->val > 0 && sr->flags & IORING_RECV_MSHOT_LIM) {
'sel->val' is ssize_t, gcc is tracking that test so statically_true(sel->val >= 0)
is 'true' and the signed variable can be compared against the 'unsigned'
'sr->mshot_total_len'.

It seems clang isn't as clever.
Perhaps it reloads sel->val from memory - so loses the result of the comparison.
Even swapping the order of the two tests might fix it.
As might caching sel->val in a local (even a signed one).

The comment in the header file for io_br_sel.val doesn't seem to include
the case where 'val' is a length!

The simple fix is to use umin() since all the values are clearly non-negative.

	David

 

