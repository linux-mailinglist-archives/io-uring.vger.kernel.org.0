Return-Path: <io-uring+bounces-9827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1D1B7FF4B
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 16:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1644262265D
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 14:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981D02D9487;
	Wed, 17 Sep 2025 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Qx3lqok8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B0A2D838A
	for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 14:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118739; cv=none; b=F/hHH++JlUj56YMNd0TbcgAWXQm7usrC2BD6S+rPjOLfiMdXvEkL/wZRjwxXCwBiz6SLS4ovVW4tfTQF0FmKpD9eSFRTky2a8S6gAawul/Q5plOyORDXsX3z2/6cFgqws11OM0b2TYKQh9+NWKFD44LDS09b8w8s7tEsGM1h6uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118739; c=relaxed/simple;
	bh=qvPmqnT0GuwUtOmZwK9Z04OkVVWN3ZAbCb5Yyg9H46U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jcSj1aelq2mSGGHuvzi+qK3tdcAYejZ71Nee62uzyMKLVLMT3Vnsz9aOHhGclt09LQziGO1A4+MUK8fNW7BZ1pB220dtNM3lxgg/zRPYQUXu2uw2XD/Qkz9PX/KrI1K5NQv8bhfqktIKbMB5IcXNmYfYxhVq1FXcz7iTJBrZIZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Qx3lqok8; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-88432ccd787so400638039f.0
        for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 07:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758118735; x=1758723535; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DA3VMHiGzzibDL6pUIUYW3tloC3K1AfAFuDtTzpA7b0=;
        b=Qx3lqok8daad6D7UmMoXWjGnWkEJe+mZgMbbvxDGdJVHHzrv372rY58P5XP3mZrp6M
         mNT4ruARxZsCJdCSHvf/Pz0jaQVnHf44AAaCrIvv9R+dRBIgpzKGePvZT+Ya5UJBJKDZ
         oyrvd+Iyfee+XEuXETjiRULFNiZzLvVoXekpGke9jYqjmxOi4sh9M5lnCp6GllDPw7nZ
         2iq1jg9W3tUPYz1XhLGIh4UDfWA0ENbgkwQnmCzElkNw4CBDEu7nRYTWP/0hAszi91AI
         9KNqv1XXSxdo1axzyfOFGr+CuetDBgnoL39Vv9uhDrfWe05AePHG1ziqSr9OCw1X/ZGl
         TOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758118735; x=1758723535;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DA3VMHiGzzibDL6pUIUYW3tloC3K1AfAFuDtTzpA7b0=;
        b=OhQvEy0m1SYNkb0BhqsZheKF4ece0USdIX7HdRWn/B7vxqkBcG76D74J8KQNKabaBo
         1JKvON1Apav0cEVtKLd5hRmXG6i38pLlehcA3Pj7fJ+kPCPIHHwp0sNII98bIWkhzl/I
         dn0eOI+qvS87F4vYLJP6SFwf+J2JEV2WPEaxz4a9p/r+wW0U7J0GPLZRNOw8t/Dcfp2h
         t7SgeboL84AvD49aHdeTGKO5dYRs0bLkESKcWFFkOqLBokOqVsPC/o1rt74tnBEa7Nnp
         fPHfi22RuoG39ttXsnFC0b5VUCd5Hm3hYO2iHrzTGXpWPXeFzbNNZSwfp1bUpkKAjDP/
         EzOg==
X-Forwarded-Encrypted: i=1; AJvYcCXkET3446qBEK2fnBvopatYHYK2NXcI2tJAyqSVE28ctCfYK6lRbEJSrxEsCydrLk4JNJm8CjByfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTgVIQcWe7iKgehuvAWUpELD+aJs/RVN+gDtgWhdlMrqSNDcop
	HRfrZ68B7uK0LLZdsSEZnhsSxib4Z9YvGUUh6y64BQX6t7kZkfaNhGewak1ONgotyBg=
X-Gm-Gg: ASbGncsrP1Cy9W38+eW9mRRzBGoKWwiSZHFI+Dvaxg+siehWGMLpO7lsIuegMk+IDf4
	OEjx/k1WBWZAGidSbnmoCUEAZpX+R7l0aOd8305MtGktHSKhmcdm2cHt9ZU28x9mJqslIHuesRc
	RFT0f+dIcPl+mpD8ZTxMjy/DE45ov5CJkl6recLmD96kJTjdZAUwcxIKucpUBIlvwiHFFbOQNru
	hndMQ9sPppNytadb48f2frqDYoWikoEXSG56eud5fxMPMaEGQmCzggOhxZorkf6WRBONMDf2C6m
	zNI5FDhnjjE/WdkybOCqhhEqTF68DtchFEOg6GDcM+ULh9Yets/4ZF6JjbOQpf9l5qSBTOxcPrj
	d1j0fodgLGddW3A/G/sQ=
X-Google-Smtp-Source: AGHT+IETaw7JxR4yD/B5BU++ndtz6o4tEdapBtyWCAqX6xlI0Emapaz/9BDEIacwy+P0KtLmhs7TOw==
X-Received: by 2002:a05:6602:2b14:b0:887:1b58:4e69 with SMTP id ca18e2360f4ac-89d1d4b1c12mr380124439f.8.1758118734932;
        Wed, 17 Sep 2025 07:18:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-88f2d0bfed6sm657283239f.2.2025.09.17.07.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 07:18:54 -0700 (PDT)
Message-ID: <c69b070f-2177-4b8d-80d0-721221fe0c49@kernel.dk>
Date: Wed, 17 Sep 2025 08:18:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] io_uring: add __io_open_prep() helper
To: Thomas Bertschinger <tahbertschinger@gmail.com>,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, cem@kernel.org, chuck.lever@oracle.com,
 jlayton@kernel.org, amir73il@gmail.com
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
 <20250912152855.689917-9-tahbertschinger@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250912152855.689917-9-tahbertschinger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/25 9:28 AM, Thomas Bertschinger wrote:
> This adds a helper, __io_open_prep(), which does the part of preparing
> for an open that is shared between openat*() and open_by_handle_at().
> 
> It excludes reading in the user path or file handle--this will be done
> by functions specific to the kind of open().

Looks fine to me.

-- 
Jens Axboe

