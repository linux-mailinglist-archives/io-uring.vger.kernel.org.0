Return-Path: <io-uring+bounces-7138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98154A69DC1
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 02:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D83E83BC00B
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 01:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873DF1D5CFD;
	Thu, 20 Mar 2025 01:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="TK3PNrbc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A5118CC1D
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 01:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742435280; cv=none; b=Ra3OiVuHxJBNzUWSoAPf9lEWJqqK9rKTfX10rJGlduVQxJdSUlYZvUUa9K4IdFblidhwjyGphfPjhU6Kt3SPQdtJoqDKFAC31bXr5tf69eBF2th+KMe6VwjyOens5cvvpQpBWAYD8eVoiF3o5LmiYUbZog3VLb1xoIBKG6ZVJrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742435280; c=relaxed/simple;
	bh=8vd93+qClvT7Jmn/2fjitb9N8zbtZJSVzHQ/sb/MSvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyKssFL4MNHidG+blTD58GUJDxJxFOtWJeApXlJsZqgBsQjwrt469N04PQpawKQxTk/VSupCQCgV98Ek5hE16czb2MXjltVrrnwXeX53XSig5C/7nI6YMQ8z0Zt5pcIGqyo4AkIgp5jhGW+CY7O+fnHhKkXxF7+Iw6kd08cWyGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=TK3PNrbc; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22398e09e39so3327285ad.3
        for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 18:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742435278; x=1743040078; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+9dN+i2AzDUfkPkdVFhgTMlxb4u3ArQIL7V+3H4EdIc=;
        b=TK3PNrbchWhUgvSI65oeS5fc4fFkbRpkO/Dn3pC9UIN81mP9SlyYHM8VhVky7V4XTL
         zEnJnKFxj568lbZKhNjUsbWaNLssmUxadLKEPhmWkZMuCgRlLmg4ZMqyE2HFy28LrXp3
         KfzhqBtwV8Rbb4oFIIN3VXy7f0sUqyIvKy8JA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742435278; x=1743040078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9dN+i2AzDUfkPkdVFhgTMlxb4u3ArQIL7V+3H4EdIc=;
        b=PEieQ62L13RCcicBEMkZ2qSzlkbvuXusjZlZqYzfauqhHuBfRLiQFF6fTkrW9yfXqH
         FVkw+46OjN85KyQPF8/po7CnpOjUrSbMbDnMh+2Hq85BmbehxXQtSUZhuWWfp5IaUAZw
         nLzvRtDhjGD69ooLbPeH3Y2Ar1ID8qdMEJ5f3L2Xrb07Krleffx/twcV7ABgowJtsWWt
         oiIyKwx7rDhQNvyPUd+25+SopRzQe7JzJf+ljqE05pwJf8kgQocxDzc1FaeN6Oz4Wg2s
         AhlityX4kPMPvSthahqnG/SRUT5UstvkAIkr0xF+DZufo5Qmp47q6bgms/Sz5PAff1LD
         2TFg==
X-Forwarded-Encrypted: i=1; AJvYcCUl635W80Kr2C3U2ABnPQ64sR3EIGoWKH8qzi33U/Hqn3wkSAdJt0P1UpGAlrmJpOQkPjKstvgmrw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9QoV3VlR6kPCrqwk8CaH9S5ub1DGPWuzMANL+i7PmeJw9os7P
	eDcohXVuSzXv4IB5MlULKiXrMTIzsDctB0RG1acokXKgaUtQWaJL3JTVjUtsdbkG4MyteORibsV
	0
X-Gm-Gg: ASbGnctN+YL4HuWTv/p6FqN40ecm7kmBrOJBt7kImT/pOJ3uBtWQj/2BMVOmiDWIC0o
	cb2YV4txouavUScvuMMcNME8NaG6N2dNLB7W2i9dwVi8R5hdsZgVFTiqQ52JVgElsic4z5zVaKK
	vrbepOS5WqzbN3BGVVicNaSduDKEddw1OEC0OUpVUTn6wHzdIsuUofZbhujEv6n6zTYJ0xVtU1q
	uZYzjW4nPBZBnA/+SrY4L12KkegPmBeMB7lKeeqXW+VewexKmVvW3zGVc6EdXbsOchgrrB5QbPn
	H67R6mYOxr7iEZVWHh/Pk4HfituAsxv3ukSnTdXxoEuinpRGvPPwWNtdasvqNSLS/jLD+9y/wet
	B
X-Google-Smtp-Source: AGHT+IEnL5zS2NVHMqd/Y2yTk6lYwUWXQfuMKAs4klVP0D5Ix1QzfZttlHpANYf8RWDNJxVQfzHybA==
X-Received: by 2002:a17:902:c944:b0:223:4d7e:e523 with SMTP id d9443c01a7336-2265ee93b4cmr19116065ad.50.1742435277699;
        Wed, 19 Mar 2025 18:47:57 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371152931bsm12453091b3a.3.2025.03.19.18.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 18:47:57 -0700 (PDT)
Date: Thu, 20 Mar 2025 10:47:43 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>
Cc: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: (subset) [RFC PATCH v5 0/5] introduce
 io_uring_cmd_import_fixed_vec
Message-ID: <Z9tzvz_4IDzMUOFb@sidongui-MacBookPro.local>
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <174239798984.85082.13872425373891225169.b4-ty@kernel.dk>
 <f78c156e-8712-4239-b17f-d917be03226a@kernel.dk>
 <20250319170710.GK32661@suse.cz>
 <4ba22ceb-d910-4d2c-addb-dc8bcb6dfd91@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ba22ceb-d910-4d2c-addb-dc8bcb6dfd91@kernel.dk>

On Wed, Mar 19, 2025 at 11:10:07AM -0600, Jens Axboe wrote:
> On 3/19/25 11:07 AM, David Sterba wrote:
> > On Wed, Mar 19, 2025 at 09:27:37AM -0600, Jens Axboe wrote:
> >> On 3/19/25 9:26 AM, Jens Axboe wrote:
> >>>
> >>> On Wed, 19 Mar 2025 06:12:46 +0000, Sidong Yang wrote:
> >>>> This patche series introduce io_uring_cmd_import_vec. With this function,
> >>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
> >>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> >>>> for new api for encoded read/write in btrfs by using uring cmd.
> >>>>
> >>>> There was approximately 10 percent of performance improvements through benchmark.
> >>>> The benchmark code is in
> >>>> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
> >>>>
> >>>> [...]
> >>>
> >>> Applied, thanks!
> >>>
> >>> [1/5] io_uring: rename the data cmd cache
> >>>       commit: 575e7b0629d4bd485517c40ff20676180476f5f9
> >>> [2/5] io_uring/cmd: don't expose entire cmd async data
> >>>       commit: 5f14404bfa245a156915ee44c827edc56655b067
> >>> [3/5] io_uring/cmd: add iovec cache for commands
> >>>       commit: fe549edab6c3b7995b58450e31232566b383a249
> >>> [4/5] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
> >>>       commit: b24cb04c1e072ecd859a98b2e4258ca8fe8d2d4d
> >>
> >> 1-4 look pretty straight forward to me - I'll be happy to queue the
> >> btrfs one as well if the btrfs people are happy with it, just didn't
> >> want to assume anything here.
> > 
> > For 6.15 is too late so it makes more sense to take it through the btrfs
> > patches targetting 6.16.
> 
> No problem - Sidong, guessing you probably want to resend patch 5/5 once
> btrfs has a next branch based on 6.15-rc1 or later.

Thanks, I'll resend only patch 5/5 then.

Thanks,
Sidong
> 
> -- 
> Jens Axboe
> 

