Return-Path: <io-uring+bounces-2625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B900594392F
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 01:08:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61A221F21D15
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 23:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C5A16D4D2;
	Wed, 31 Jul 2024 23:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoZZA5kH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025EE16D4CE
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 23:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722467325; cv=none; b=WqCbUXEY8B/MaPRXEwSaWkUHu9xW17sADtGzFoPx2YqYvhqS7nYKIZFMf7fM7Q5UuK4GhRveBVkXDyIsN89GAryZ4xuInKfTdlKaJm0zmT01ZlCd+rX/rMFdB/UszohSgJ+01O1SLxKHl4J1w2IM8Rbv6DbCPTWMa6VC29iNWu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722467325; c=relaxed/simple;
	bh=zzuh0mam8TFjFGNJ+/ZwsqdAfqpPJxU8nMCUvUhjfR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MJMiFFckf26Q57u9vmdJ7Ji5F5+yHc7pmoqV2lviqH/1Dcv1ZvcYTgGrIsSn7yiFArJYOTQ6YmX8XlbvnrZPY7qdS8DWIpG9Hp808qaXY466Pn8fMmRxOl4Mt9J29ilFpb7gIfFBtHMSB0/hBnxtjcljEaqI65tdfEzc1T9YpPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NoZZA5kH; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5a1f9bc80e3so5239515a12.2
        for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 16:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722467322; x=1723072122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=98ttgTRU8rISaNj1RxqDFxKrVlKVpJ2zcDj9HbSosd0=;
        b=NoZZA5kH05/YL3F8krg31vz9wKb3QfFq9ZBFw+nbzVk0rE/e1htUKnPKsyi9YdqN0j
         0psdkGjxElELY05IOavqNrreBmdDm1e51P4hl7hw9RlHZiN6ENhiFFmbRNsfA4+4TICY
         cWbFEP9LRHscYq+AWVKBykdM1B3+ySzOBE4zH24yObhmRcQ3KpB1rGMl9xnPRx0IZTwG
         NIyUf01Q40vZ803ZN1x4jDIndg5NpT49W+hZOHOauzCCb9lrhawfkN70pARwYZEcLWyE
         mejGjP3MAOG/FIQh2iZWPYzhjvZlo648bFoQ8vKEa5rSLHmQH8AqPJ/51C+GuiX+fjBW
         5TDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722467322; x=1723072122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=98ttgTRU8rISaNj1RxqDFxKrVlKVpJ2zcDj9HbSosd0=;
        b=B+n6j915elztIyL2czYziSDyairGVZfsX00aY1GjaBfzP0dCF8jHjZYW1ilvi7lsEz
         AE7FjbyWvx/eBCgWD/XTwSPRDiOCD/Dm8xi8gvRubMeRcce5bGY3xN3kfj6OB5aF4jgv
         sgFz990qPvk7KiIgmTTFYEA7dJygbimqcaK4lUSOG/fiHF+PV56yYVCizVGlxqyIQIil
         9Ry73K3puyxI3Gh+BMhITKxBCujzD4RcOe6xOsD5gWqfZRQKqP/bYxXWYtih/ZOTLLH/
         CXJztqmRvs7REeWdkmWRS8b/mPc3F0JADAVp6wXB32ip8xBjy8fjY4llWLexH91y7OKo
         Uxrw==
X-Gm-Message-State: AOJu0YyH5yVQYs/Ol5OpD4XNDfq4+6+BBUDVSHJjrLw+mYwwsTVd+KD9
	1ENA9tvX/2KM+eyQWT5Z/x292DA1f21Ubhcv6r/vn2NLdnbHxBh/
X-Google-Smtp-Source: AGHT+IHMsw2sh8lxtZr/levNj4Xw6v27gprxRvksbw1PNJdAS5API3h7OzZpw4n4fS7BrkPvOZmO3g==
X-Received: by 2002:aa7:c6c6:0:b0:5a1:4f76:1a1b with SMTP id 4fb4d7f45d1cf-5b6fef048afmr439167a12.15.1722467321974;
        Wed, 31 Jul 2024 16:08:41 -0700 (PDT)
Received: from [192.168.42.198] ([148.252.147.239])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63b59cb0sm9314946a12.45.2024.07.31.16.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 16:08:41 -0700 (PDT)
Message-ID: <5b853be8-15e9-481b-a99b-af6c3a5eca94@gmail.com>
Date: Thu, 1 Aug 2024 00:09:14 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/2] io_uring/rsrc: store folio shift and mask into imu
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20240731090133.4106-1-cliang01.li@samsung.com>
 <CGME20240731090143epcas5p2ade9e73c43ca6b839baa42761b4dc912@epcas5p2.samsung.com>
 <20240731090133.4106-2-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240731090133.4106-2-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 10:01, Chenliang Li wrote:
> Store the folio shift and folio mask into imu struct and use it in
> iov_iter adjust, as we will have non PAGE_SIZE'd chunks if a
> multi-hugepage buffer get coalesced.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

