Return-Path: <io-uring+bounces-6637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C12A40BD6
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 23:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4BF31898054
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 22:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CE1202C45;
	Sat, 22 Feb 2025 22:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VPoDYqc9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F10E1EA7EA;
	Sat, 22 Feb 2025 22:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740262430; cv=none; b=O7AMqj5BMkL9ZF3mDok9G0UWHsXInNlXGxZtEbIFN3vh46TJXbyz2TQ8x1t2kh+e3P5Kp73e/z0Qy9qlUIcX0IQez56tkH5xmcbwVSUC/nTZIzKQhrx1eHuKBaO9BGQsV3eQgaNWN+OFRTQZe+fG0k28Dljyd2B+WdJ6MXS7pv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740262430; c=relaxed/simple;
	bh=9+n4eKHVqWyOAQ+Ejt3I4Fk9kezlq4D9Uo9sZ82At+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VaP9dxAlW4qmJDwvp4/ABNpcbhd7iCCTrfdDDf4G/bPOFz2D3RbD2XR8QJ6LUSXDdEVKmU2guZ0f59pVZJ5psioiJgtBpJ/QlyZOIZKibUpWhj16J2Zcu8ZZ21AqexkXdO3Q4MdSjpf/zEb63U/TAjaW/yDjSwbE1o1cW95E0Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VPoDYqc9; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5fcd50841f4so1548207eaf.0;
        Sat, 22 Feb 2025 14:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740262428; x=1740867228; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3OrIm5B4Ty1aWJ4bIU6oPl91Lfouy89JgD45wVN9QRM=;
        b=VPoDYqc9dFWB66MVvKqGLgy4TLNwpNFGDpg8Z0pdpUJNx8KXi+Lhwr8EtnwsBVUyN5
         H3e3YyTXXrivVAX9arw5VPB2sbMwhy4MEtCfo3Juq5yYxQRISS0SmPuk34bL6n+GijPL
         mOCPxc/q23yeMV3fGJ+Jw0HtboifVPd0QXI69Z2dz7jQFgW1P+hVwm0I/49pc/Cki8eq
         WAC00bugWm8JHeBiYT1AxxfRp8UZjGrhUfX9nH9+qyyv52EufTBUfVxl0g1cu0rf72az
         qib/uj8DTTKv1KC915DnS70tW5EFvXUb4gqYmz/mvZkJybxljyHXCxU0JLf+P9UQdvdr
         ZiQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740262428; x=1740867228;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3OrIm5B4Ty1aWJ4bIU6oPl91Lfouy89JgD45wVN9QRM=;
        b=mjGnLb5fdYy9DqJ32wS7we5Kf7MNpEzqzGqQaExJeY8qN19DQouioc//UxhDiq24Nd
         7jUYAljgMG1tSb1oFh36G1KDAYcxU9dX/ge8nZIpBxAST5NWYAqPmmtCWWKVf6nwkxMH
         SiFWDnA1N6z5DC/CeMeeIcPxMx2fI2yZ5cRE92uHYqTyiOVuYRZEVf1JD99jRNooJJMr
         6YiVH+8/qguUhq+AsT2h9yGrJU5IpBirPKRE6GGkmER8BNhDURlfRD27IxYcu4ckGZob
         /sv5vou1NO1ScchtsNydoa3OgJlKcVxzcOhnrPmTHD1Avh5Izo9JwH+WcsWei7UJatwc
         uyVg==
X-Forwarded-Encrypted: i=1; AJvYcCUoNZcX9gGm4w/IAOxEI1aNTDszIXOEg7O6kSsQFHuZ4qQnH1W2ynQT+ynQVcc9m6zQzex4LswfVdhDlT6Znw==@vger.kernel.org, AJvYcCWO9pvDoKALtOmpPiBCE83CY6bl9p+iF9K2vpUb76tZpTgHIrY3YNO4B+5wtVroxv4RfsWkJ1yvLPnklikP@vger.kernel.org, AJvYcCXBrsJoGlSeICRbBgYMNka83haxnt5iI47DTiD/lnjpMjQd7JESK7gRoXnSop0YzFuxHVfDZgqzlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhwzyWAaq3xuHpZR9INGJlBvhpAjo3OCTyo4TJ0XWzYsfx3PG7
	pBg7C6So1urLAyZ1Go6wk2RYwzPCgGEXetsEw3XmhM8OtOb/nfii9vs/fGeIp4w=
X-Gm-Gg: ASbGncu8KLX/YwtxNJulW1phjDtvG47vqH89NtTYjV6SxfgYg5Aac7/JVGP2wKW1hwA
	JOr1EIuj0TKhN3YrdylX+2B3z0I1rCtxlkp1PRLHAGiTC1URNkl5eSenMfMQZttwqe9+XNnOtfu
	fSzTNZmTpFFs9NKGkfn5gawGDD3BNKF3ERqlGDFeMsbqc/0VBg0BXcrAksl2nJ3wbO5R+0WDtLB
	MfJywnCO8LL6tDNi+Vqqp3Pf6kbSXOo4az+5LY5qK2ub+xlsC+2cTAypJULGG0M7Bqyf94Pz9SR
	Vfb+sE9t+K/9Wlpjrn9mEP65qlS7K1O13L+pNUgJRavAOMcY5Nlh0e8sBUUfoMRGRrTA+Z/3XS5
	OoH8LTVHdtrNJBA==
X-Google-Smtp-Source: AGHT+IHf4cI5C1esT8UAeqhrbnRDDAs/cubdMJpIiF1CBejP/8GAUbK1crmD/KhrWz20Lf7gMJhxkQ==
X-Received: by 2002:a05:6820:1b86:b0:5fd:82c:1d5 with SMTP id 006d021491bc7-5fd1966074amr5376852eaf.8.1740262428526;
        Sat, 22 Feb 2025 14:13:48 -0800 (PST)
Received: from ?IPV6:2603:8080:1b00:3d:9800:76a6:5d39:1458? ([2603:8080:1b00:3d:9800:76a6:5d39:1458])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fcf9579744sm2154338eaf.36.2025.02.22.14.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2025 14:13:47 -0800 (PST)
Message-ID: <9eb067b6-bde8-4505-a9f9-33f33c323b6d@gmail.com>
Date: Sat, 22 Feb 2025 16:13:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Amir Goldstein <amir73il@gmail.com>
Cc: Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
 <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
 <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
 <72ac0bc2-ff75-4efe-987e-5002b7687729@gmail.com>
 <CAOQ4uxieuFTN4Ni4HoBsEvTPW_odWSo78-5shJTh3T2A-vzP=g@mail.gmail.com>
Content-Language: en-US
From: Moinak Bhattacharyya <moinakb001@gmail.com>
In-Reply-To: <CAOQ4uxieuFTN4Ni4HoBsEvTPW_odWSo78-5shJTh3T2A-vzP=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



> So fc->backing_files_map are not really fds registered for IO,
> they are essential references to backing inodes.

That's essentially what registered FD's are, they fget() the FD and 
stash them in an internal data structure. It's not necessarily for I/O 
per se, its more a mechanism to ensure fast Uring access to a given FD.

 > Could you explain how fd registration into the ring would help here?

 From my understanding of the previous problem with passthrough, we want 
to make sure that one can't issue arbitrary write() calls to the open 
FUSE FD to sneak in an arbitrary file passthrough (I admit, I don't 
fully understand the concern). In any case, this is obviated by using 
URING-only mechanisms, right?

