Return-Path: <io-uring+bounces-2481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1672B92C7B4
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 02:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC9B81F23A98
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 00:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BF923A0;
	Wed, 10 Jul 2024 00:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/c3f2v0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0345E4A04;
	Wed, 10 Jul 2024 00:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720572859; cv=none; b=qgFP6FpxxXlDfBnhr9vikkvWaWNx7V2JM+xZtjVxgg/IiWRmweGxlKGoOQ/JN16CxTfzl7p/0eyBMsO8tDT4nkFnH5YEGvvp+P/FI8BiClx/mT15va5V91xLN9l4yPt8V5sSZtRDqIGhqVAxnUA3Gq6VaWIMrTHfb8pVxbMDp2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720572859; c=relaxed/simple;
	bh=zVstIod5DFgflvwMw3bTwrGFdUGTgZoMa0CVYXFwc7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PaHh1hKVN8sA6lWZcQ64ZUPOP4u14E7T6TxHz3EFP0/AERas9eNWXR3T63CDC118a3LFjYsP3XOe/FQZI+0XU0N1fgtrLfSnydt8Ue6BRSaN57N1sMF0gy/9zJq7fmOZeQMVoonIKdRmBZCR+361+MjgWjGPHM697Jk2zbmailQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/c3f2v0; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fb4fa1bb34so22269025ad.0;
        Tue, 09 Jul 2024 17:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720572857; x=1721177657; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nXUrbASi2IHeT51ZFvr1RaL7wSf24sZ/lvgPjV6K3jg=;
        b=a/c3f2v0hZT8Xn8yiseqhrxEqRvcqdCEEjGJZvuNDwH6fna2EsG4Gvi5QTgQ4sizph
         xhgP0gfe8sLrCRs0bv2zQZeXffI0G6M5Ni7fYXQk6jEcAmod7SDB2TDWz78pp+qD7oJ5
         Pi/n0sh5N6tGNFCJ9l8Kbm2ThWgsVrdC8eJ9G9ZU59pDWs4VJn+V0oi3s+wUjrkCB1NY
         oSrPM8ncUWfMkm5xjtrBB3Kb5Px7FeSG7S7sOYE6jW7MMRhJk8r3LcclTa3kZDMuRjzk
         vBzNPeZ6zbCG0RY9ka8fd2RzBb713o/UgvpYgU2o5nOmtDuxkMontxqupGJ9WtoDtsUd
         +89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720572857; x=1721177657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nXUrbASi2IHeT51ZFvr1RaL7wSf24sZ/lvgPjV6K3jg=;
        b=fpou/kH2XnGUIWCYc7aSfTguG8gSlRKFQd6bx1ZZIgqWhePKblVqTeZh+aDR1QE56E
         ZlG4lqDgPU/ZAa6U2qCbSHG/H2mXw3QSYhb3jlDy0X6SoscRbqH9Oa92OG6SWY3bxil2
         wTMjZf31vaVfMDSEgGcmih/qx7ol3zZ+fznSZkge2X2rUzj1Jj81kGBrMo7XrNqmrM8l
         JFiN6eGBJ3lawghYGJQU1kbuZR+onhyR8c9XLl20aJMeguDa9CnrZcudh8rLLVMmyzGR
         7kLSxe8NracvlvbP2Nc6CD8WwRp1+12wKIpsWp+cCkoMo+ehqbup8asgRBLs6+KtdxQn
         pR0w==
X-Forwarded-Encrypted: i=1; AJvYcCVKNiqsKhXuUYoJfkcsiVTokPTjONzl/XQCccOhhYhlSOMOv5RQfM0dXIDgCjWWqQfbbk7U5yziNqz47e36Ncljx/7PGs760r7KXUdhHRsRyXFMC0fXohWu4lEHY3Cve/W60MqeusQ=
X-Gm-Message-State: AOJu0Yy4pM+6MhfbNZXXdfcXKRLcjyFXyjTBXN7LSh6t/g+kqGbgqTvZ
	XZKDKpGtI9Q+/ej1qy9F0S4t6ZfFX6aqioSRGSZ11Tjr+WlXd4b/si27Tg==
X-Google-Smtp-Source: AGHT+IGx8b2K1cJ63oWhRAKsYzusq0dlwFUIXqyO/bqi1don2eRv6BVoEA3wWBv50LhEKzpLIV2mjA==
X-Received: by 2002:a17:902:e802:b0:1fa:acf0:72c8 with SMTP id d9443c01a7336-1fbb6ce11ccmr34449645ad.18.1720572857083;
        Tue, 09 Jul 2024 17:54:17 -0700 (PDT)
Received: from localhost (dhcp-141-239-149-160.hawaiiantel.net. [141.239.149.160])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6ab7c66sm21898105ad.121.2024.07.09.17.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 17:54:16 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 9 Jul 2024 14:54:15 -1000
From: Tejun Heo <tj@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <Zo3bt3AJHSG5rVnZ@slm.duckdns.org>
References: <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
 <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
 <20240709103617.GB28495@redhat.com>
 <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
 <Zo1ntduTPiF8Gmfl@slm.duckdns.org>
 <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
 <20240709193828.GC3892@redhat.com>
 <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>

Hello,

On Tue, Jul 09, 2024 at 08:55:43PM +0100, Pavel Begunkov wrote:
...
> > > CRIU, I assume. I'll try it ...
> > 
> > Than I think we can forget about task_works and this patch. CRIU dumps
> > the tasks in TASK_TRACED state.
> 
> And would be hard to test, io_uring (the main source of task_work)
> is not supported
> 
> (00.466022) Error (criu/proc_parse.c:477): Unknown shit 600 (anon_inode:[io_uring])
> ...
> (00.467642) Unfreezing tasks into 1
> (00.467656)     Unseizing 15488 into 1
> (00.468149) Error (criu/cr-dump.c:2111): Dumping FAILED.

Yeah, the question is: If CRIU is to use cgroup freezer to freeze the tasks
and then go around tracing each to make dump, would the freezer be enough in
avoiding interim state changes? Using CRIU implementation is a bit arbitrary
but I think checkpoint-restart is a useful bar to measure what should stay
stable while a cgroup is frozen.

Thanks.

-- 
tejun

