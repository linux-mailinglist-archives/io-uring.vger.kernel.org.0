Return-Path: <io-uring+bounces-2476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0501692C245
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 19:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B5D1B2A3B7
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 17:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B9C1A00D7;
	Tue,  9 Jul 2024 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FRtAbM+1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB7A1A0712;
	Tue,  9 Jul 2024 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720543162; cv=none; b=IOSINtJ/tLOmWAOS53wiFgG/2nSkt0SN1YhdtulV1R2cgbfiuKqcEA8+A8FUcKZ38f4t9dL3PqLJhKgFn7ljZnikX0f8qOO8uMxP//M+22UOkUmujUqS8jYXuXNTdYK1cbdc43+rxxFHEO8G9WNuuZkUfjBqJPxv/QI7eg7hY0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720543162; c=relaxed/simple;
	bh=pFucpG6/x+NwuUD2iPojwPSQ9j8dX3c32uVpYsm4J9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZTzdXGZJAvKfkdITonLTj8UYcB20/MLtpLBoVAUxpCoQPWR/79u7tpopZZfpCnE0v807gxW7FbDm7J+oEzroXOMaZnScI2h3+E9HLqhQ7DG77vRbXv0pu/8xR6zxT3lA8pAWpRcfhfYsn0PNJE2fyRQnttBMD/VAXxT4PnyslY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FRtAbM+1; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5c651c521f2so2411154eaf.1;
        Tue, 09 Jul 2024 09:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720543159; x=1721147959; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6+VdH11sjrAe3PqjcossyLdY+HXcfeSaQR7JuWELh04=;
        b=FRtAbM+1vxiRc6tWy1MRgzYp1hGyqeKN8j5ckCySo00X2JNOqZcAjCv4JaMF4F/qAC
         1YwVde84l7QdRlA/ywpZqFW9FlqtFIFkoFuF74o7cjoWee6ASMg01b8M3fb7FVdUsloT
         uUlg3aBspIMYaUxNTNMT7R+jfPwiYrsGGCf3BVmuAl3smiNzHMGACAD4XQFUBWs0VSIK
         Ou4m1mzNylkOQpykaL7nJc2iCzqwPzRZgi5AdTuFavxHV+w0/5/Yfkz9+3SAmKY9eLN0
         ytA7/H6dAvoLMf3uiZhzej+GMMisERZKHVy2lt2WsOV/RSiNLVDWw2Y8RXSjm/s8nVUE
         v+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720543159; x=1721147959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6+VdH11sjrAe3PqjcossyLdY+HXcfeSaQR7JuWELh04=;
        b=A84ma3Q9lnBKYulCfK9WLzLrt64kGvWln93SjyRpW7vDTxd9hBvXBAb87vJYep9RZk
         VmlEsoNBSqBRU8xWsxSxkLW8AO+4EIHd8x3a1iYUmDNoXkYzgauxH9pUqouWmhPWu4NC
         9mTQPS8fDQaOWmpYjEx8yYrU/gKVh2VOdJVbpUTy4AEQ/YaD0fTwl7417fF+d82D1FG6
         ZsUYWnWPlrtVoKWFsxlw6dzZmixm7wAIwcx0jI60we+bK8mPylnxHDUCo8PIHiQo69rQ
         xQJPqaZYn+AgndUZuBWHCvSyk+NXgqS5VJuuh/Yoq0cKrkAEOC1ebOfCBSyGSvvlwcDE
         vRsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVX5sSoWcbokb53ue4V7zT9yf+JaPEeTiim+RgsvajqKRibfi2ZIZcV0htVfrf2xzQ2xU9+J+0A5E5fVag5x7+iz3a4UB3/Bgvd6sam8sAX9L2rXSSIix+p0kXTJ1zrOzLzgFNh3IQ=
X-Gm-Message-State: AOJu0Yx784+2ToI3cz/Duz7OFwtUfTGHXZq9kJ1EBCcMMjRqUA+Mu/Ye
	N6DLdK/9PHBbBdaO+xkw3hi0XY/eDoeaaXs6BL1LSSezYqN15VNn
X-Google-Smtp-Source: AGHT+IHqTrPJAzaXMDwxPW5KDIKdNSC6MrO/Cz/uZYlxkl/ty7aAXwkC0mugN859XmW0ECu3IGWAXw==
X-Received: by 2002:a05:6359:2f45:b0:1aa:c583:1650 with SMTP id e5c5f4694b2df-1aade1249c0mr227112555d.32.1720543159143;
        Tue, 09 Jul 2024 09:39:19 -0700 (PDT)
Received: from localhost (dhcp-141-239-149-160.hawaiiantel.net. [141.239.149.160])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-77d667ec487sm1372281a12.75.2024.07.09.09.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 09:39:18 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 9 Jul 2024 06:39:17 -1000
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
Message-ID: <Zo1ntduTPiF8Gmfl@slm.duckdns.org>
References: <cover.1720368770.git.asml.silence@gmail.com>
 <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
 <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
 <20240709103617.GB28495@redhat.com>
 <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>

Hello,

On Tue, Jul 09, 2024 at 03:05:21PM +0100, Pavel Begunkov wrote:
> > -----------------------------------------------------------------------
> > Either way I have no idea whether a cgroup_task_frozen() task should
> > react to task_work_add(TWA_SIGNAL) or not.
> > 
> > Documentation/admin-guide/cgroup-v2.rst says
> > 
> > 	Writing "1" to the file causes freezing of the cgroup and all
> > 	descendant cgroups. This means that all belonging processes will
> > 	be stopped and will not run until the cgroup will be explicitly
> > 	unfrozen.
> > 
> > AFAICS this is not accurate, they can run but can't return to user-mode.
> > So I guess task_work_run() is fine.
> 
> IIUC it's a user facing doc, so maybe it's accurate enough from that
> perspective. But I do agree that the semantics around task_work is
> not exactly clear.

A good correctness test for cgroup freezer is whether it'd be safe to
snapshot and restore the tasks in the cgroup while frozen. If that works,
it's most likely fine.

Thanks.

-- 
tejun

