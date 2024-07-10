Return-Path: <io-uring+bounces-2496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB9E192DB7F
	for <lists+io-uring@lfdr.de>; Thu, 11 Jul 2024 00:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B06C283BB7
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 22:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4134412F365;
	Wed, 10 Jul 2024 22:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O56ng+l/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71DE13DDCC;
	Wed, 10 Jul 2024 22:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720648908; cv=none; b=FZVUlPo937WwyFY1hXJzQ3fwghjPxfTA+S1hgM3dgjHVLoWP7BwgX2JwJlPVKiHfM0atqVYjTCoWeWGNo+7J5GoVvhMBILaYUSfgrI9fM8mdI2u1n0wB7bQxl0wYd07TN/FjrooLtGaOA3e+quMx8/XZhS7lOwTlYP04eK17xLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720648908; c=relaxed/simple;
	bh=EYN271ruk3PyKWOWvIqr9SBN3FvMvPxToMd41sXWudM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DoXYmWnD+3C8jajuf0H66cS3o/M0G/90DY4tRO+XuTPiSmB1eTbOLTgt+/uHaBUiO4bGsJDaLNQb5US0V55EYTcdFVYM1/U+4xrae0nqMffkvgB92fFb0ukIognLDWDaOWS5tnvTNjFQiOe16feXa6lTY74VG/sWyc3Evu5AUcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O56ng+l/; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fb472eacf4so1334605ad.1;
        Wed, 10 Jul 2024 15:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720648905; x=1721253705; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TLpQnze+EZOnpzppxx90Ycj4d+D8GRV0Lx4y0w9x7nc=;
        b=O56ng+l/e8smZnReRK24w6Exs9MiYGGujBDmvFnxWVNDM9iQsXWCTMyA6xaSRTxl2J
         7r2w5yMF+6RBCAZrAWhQIOsOYPRTt2tNhvUq+Y17eQFDEOslAgp3nBUdpI+5lGwu+a/Z
         vt++OC5bjwBMh18fxiXs0Vfzd4TIhBW43OPPpxzZSJcbRTFlZ4QdpQvtm/0aYhPpXxj7
         AYWbyaMPzCLf/y/yylKLjFGTaTKdmLKiUvYKocc4oAI80rKbcEG2UtFbskRJ0pn2gPYK
         Q9aJLFh9uqnPYsHlOAo9iHBiNaEp2bhDjfQqC9W0L81kPveCdmJYi4F4n2uS+tNsa9PA
         Yjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720648905; x=1721253705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLpQnze+EZOnpzppxx90Ycj4d+D8GRV0Lx4y0w9x7nc=;
        b=VGcRUgd9nUVvO6UbehAwRy+UuHnUSx8/UfuwLoLzSRLgh7ugK8XLHBEkoIP668BEMj
         Ap8AMWnMyM04a5xrEER2Uu0mtZWecEnEaoan4lOpuf07z+/Xt1iNfSOafH3BKtjDnRir
         SdrsbDMN1nWKh8O3ksXajJE/TMcqgXjqmtD0kIjsvvPcPazHUuLBEd7ykY5WAoNPbW83
         xhgx7zzQ2/gfmMiLPsNdQ97/JCe43XZW0/4/xDkizj5e4D1xsmxcsFfvBt7ogmbeR447
         3DUAxPqW/GydO5k9pZKkw8fh2Te0ECYlfcrmOYmG9iqTIik3yrwjDPjI7ffzRhQCovCm
         UekA==
X-Forwarded-Encrypted: i=1; AJvYcCXsZTHqloonP0AbRF+67zv3q5IYAeQnKZv0DD43TjGUyEIefo12laj4PI2/vzmSLJftvatDWp0LxPbIAIZMuPZMn1ZNHwtpwg/S/rSXQih8CtKuufMJFO1Xa2zWwN9wCR77WRQSYnY=
X-Gm-Message-State: AOJu0YxCZS1DYg0ZzetGL1RcLwLnQ3kwlYU1l3JNGuHZj/Ow0RNmd9fJ
	rq6V6XLn0e/mmHIpPS/Mo5Mivm/IOy4z82Brn5TU7wwkjbtYAikW
X-Google-Smtp-Source: AGHT+IGisPlsbF2WCSZ9A407F1aCaBzalbfpOjFG6s4tXoSdoPNLT5kOlAxmc89bVa8tknujRtzYFw==
X-Received: by 2002:a17:902:f644:b0:1f4:620b:6a27 with SMTP id d9443c01a7336-1fbb6d25158mr52528335ad.13.1720648904890;
        Wed, 10 Jul 2024 15:01:44 -0700 (PDT)
Received: from localhost (dhcp-141-239-149-160.hawaiiantel.net. [141.239.149.160])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a2bbd2sm39466845ad.90.2024.07.10.15.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 15:01:44 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 10 Jul 2024 12:01:43 -1000
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <Zo8Ex0qFRbU2mAOQ@slm.duckdns.org>
References: <Zo1ntduTPiF8Gmfl@slm.duckdns.org>
 <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
 <20240709193828.GC3892@redhat.com>
 <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>
 <Zo3bt3AJHSG5rVnZ@slm.duckdns.org>
 <933e7957-7a73-4c9a-87a7-c85b702a3a32@gmail.com>
 <20240710191015.GC9228@redhat.com>
 <Zo7e8RQQfG7U5fuT@slm.duckdns.org>
 <20240710213418.GH9228@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710213418.GH9228@redhat.com>

Hello,

On Wed, Jul 10, 2024 at 11:34:19PM +0200, Oleg Nesterov wrote:
...
> > it'd be better to freeze them together.
> 
> And I tend to agree. simply beacase do_freezer_trap() (and more users of
> clear_thread_flag(TIF_SIGPENDING) + schedule(TASK_INTERRUPTIBLE) pattern)
> do not take TIF_NOTIFY_SIGNAL into account.
> 
> But how do you think this patch can make the things worse wrt CRIU ?

Oh, I'm not arguing against the patch at all. Just daydreaming about what
future cleanups should look like.

...
> In short, I don't like this patch either, I just don't see a better
> solution for now ;)

I think we're on the same page.

Thanks.

-- 
tejun

