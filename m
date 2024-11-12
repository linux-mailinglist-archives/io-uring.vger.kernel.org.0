Return-Path: <io-uring+bounces-4633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D754D9C633B
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 22:19:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B206283E48
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 21:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA18F219E5E;
	Tue, 12 Nov 2024 21:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W9yGcKdm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA6E219E4A
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 21:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731446373; cv=none; b=roO0Rw5YkSapwWJHe8nAOnM/373bDZRz/AWq+otIIht9ZKfGs8kvJ4YNJJVS9lPVHkIYNce8u9FSqxmSpUAsBUljUXL1qXV6vnPPyrL3EOecrejRpz7aWcXhjuwmEgVH2hbwR+AdbletwzofzePfhkb0xQINw0NX7G3qzjDnyWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731446373; c=relaxed/simple;
	bh=SEL6X6hdUxF6ym4A9NUSeFNUTCyHas6dfssLeN1VhQo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=qdsaBq1Z+ZOvRVGq4QEtI060yG9MPFK1B8yDDBVs7f1rPvEkrQiqKf3smLZW84+RboAqe1e9889qhOjv4JPZLwhd5tuio7SMN9BblmHZOVWhxn0iLClVnYEgJEA2TMnJZvpeYYcdC2ncYDvOTeNmSheIVvg5inUh/XTYNgDXUc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W9yGcKdm; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3e5f835c024so3770535b6e.2
        for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 13:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731446371; x=1732051171; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g0LGAAhnzSPN+1d55yonk1/GMChB/jRmj1V/dRhQ/hk=;
        b=W9yGcKdm9K8ak393hUNH6YNvpU7+rVuMK+LhHjG9X5mUJQ3I4xbZMgY605A+2HgtwW
         0ybjcxib3ozswqOJL7yaznh51ZtEcS/9Uy6t15KTrhZtZSD9w6pK1rYczs2SzGKQXLSQ
         K8zDwGDMJfq4ToU9TOhQhGyGjTeEpjcllk4R7NHme08rV5hqJkmwK3+n8DiIzfb2O4sn
         l94nnyZ48ErGGT4J7C85e1OxFbV+9yBgxHm7YfveVIAnki1MDQTt6Vi6DxTAPXaEKceS
         4pWI/VqPMs0ZSdd/OaTxMLeXgXH9Y1I6C/8Bgp8qly+d8gLUZfd7Oz1kn/zmvwikkNLu
         MipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731446371; x=1732051171;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0LGAAhnzSPN+1d55yonk1/GMChB/jRmj1V/dRhQ/hk=;
        b=BFmsj5fza9LKqHi3ElcNMGsSpQ65g31XE9PrKU8Fw7aZo/A9f1jTJhFoyiZAnFMhul
         /m918qL3EEqrQ4Sudmedy7Wz91v3jo17Y0/QNNV6ZJzgBNs2em30TIfIWGP2wnOcMvqa
         +X7MyQRQNW/edLy4D0z8YZ/5bgV6479eoeYT4g+hUsElubaB22H6h+iqUbaEcTj+UMBY
         rBDwNOUredFcfOsF5KKaQW7p9+39pFbubuQxeyUaxdIcXwcKMR9AjDpQLIS52MmpL5Nx
         OjxuiDQTYr9f6Oi97yUzCwqYeFfAWgjBsYKlgUadnSO8/9guI0RhTUo+alpwGKdVFYwm
         NNjA==
X-Forwarded-Encrypted: i=1; AJvYcCXzG/U3NCFSaAVw0lHO2sCASeLiakr93hcqO2e7CNzHeCYL9mRBSskTiuDtSFhiql1+2EZ3Gq+gsQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz4xGdOS+w42E6MxybpSUN6Q6eCdfco8/+hcQ2tyKZ/ptbIpjT
	9S06jcLteUzgDFWLICQjI3VpA9M+Hb8H3aBBc5dp0+WyQllnqIuwaXVwyJjn8KU=
X-Google-Smtp-Source: AGHT+IHRWQzNVJxVEAh22puDycpcVGRjweG7PJYNurtD1CyzmW7C4IptCPtXOB2QuJi+mTvvENQ8tw==
X-Received: by 2002:a05:6808:138c:b0:3e6:2f8c:317a with SMTP id 5614622812f47-3e79469a506mr14762715b6e.2.1731446371234;
        Tue, 12 Nov 2024 13:19:31 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7b0969cddsm74292b6e.17.2024.11.12.13.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 13:19:30 -0800 (PST)
Message-ID: <4c59f6ff-c766-4820-9b7d-c5bd453ed3bc@kernel.dk>
Date: Tue, 12 Nov 2024 14:19:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded writes
From: Jens Axboe <axboe@kernel.dk>
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20241112163021.1948119-1-maharmstone@fb.com>
 <5ecbdce7-d143-4cee-b771-bf94a08f801a@kernel.dk>
Content-Language: en-US
In-Reply-To: <5ecbdce7-d143-4cee-b771-bf94a08f801a@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/24 2:01 PM, Jens Axboe wrote:
> I'm also pondering if the encoded read side suffers from the same issue?

It does, it needs the same fixup.

-- 
Jens Axboe

