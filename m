Return-Path: <io-uring+bounces-6963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F2BA4F2E6
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 01:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 438A43A3ACD
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 00:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD623594C;
	Wed,  5 Mar 2025 00:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvGozZfX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6C4282F0;
	Wed,  5 Mar 2025 00:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741135488; cv=none; b=sKjOrQmowfO+8FSrqFFwHnnqgP392NMD+3f9KaAvX1tnlztKXHHCi+rQaQqqmmnyBCtXh8q1WItaM0Bq47Mlgji0uJ+DvcvvwfG9e6sB6FPhgJxbg11gRlQ1uhTcUHyHLf+TaNBAzahvhcUNFZGNXl9AMMABDeMJWmFRAINC9Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741135488; c=relaxed/simple;
	bh=sbLxkwpoirKN61WCU/wy7/FpI8SWjoP2Q93qHG4Ta7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SDxR1y5eowJQViRhEMfCN5EPX5W7mWiNMDh6JpHsKVFRzMfKhWk5TZA9bMjh370CNeJApp5vAz+6Ci8C+mLAExLxjNoiBBJhqyLuUiARMDXdEUX6gLFeXr8fzqMNxMsdkobgcqm7pWfHPNAlg/Ob049DX6Jw7bxxQYU0NlaNd7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvGozZfX; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43bcc85ba13so10242085e9.0;
        Tue, 04 Mar 2025 16:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741135485; x=1741740285; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zVOSz309vMaeAZ052sRb9oMuFusbIL8+VOKfNRrdoW8=;
        b=GvGozZfXaVe6Gsa5lYmWdWteUhFdKFAbb9z/O7BlXmqNR4IfkKMphWO3O7YvxdqRiX
         FMSt2TrcVfdBJLjpdBkhpCidyjuiYT8qSOkUQubK26rGAsLVvsshzWNQ93AsdjI1vW7k
         zR419Sl3iojeM5NeR551V53o+muG/aN9T2hTF+ml94H3xXiVToiuEFvEp+Vxfv6L3aK0
         0zIpU7Z7YHRQMc5CKjUNqrebci922T/hTQ8qhY/LeN8y2U5cM+X8A5SpuKTSst8R/sLs
         6PPyLZMs7TMR//c29a7r9K+OyQUWdvm9roIwVXL+ySemAoR+L63frTsgsrcQiOSGv6EX
         mGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741135485; x=1741740285;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVOSz309vMaeAZ052sRb9oMuFusbIL8+VOKfNRrdoW8=;
        b=n0MJ9GD6lWefldKttmCMgbNK5PkGh9rMx78wPIi40dzBtEcDhOCVp6GAXlgcjRRF4T
         s8mnJWqVcCV61GuTMTDUS0syxqCDD3Uto1WR1Mhn03X9d2fJfneJXubVwhF4QBrFMvCM
         00nQfeHQNZhPG2U8VxcevXw2OcjyMosUz28TtK7q9066wu7VVl2/gWqXwtli0tEOawTH
         XKtcmO1ohxXfHFYTD3LmrptA1Z9VYpxY+fhM8IJ1cTgnKtMKkpMyOZFqNrVKIrn3ag87
         jqPQ/ZpXjFpL9fNzR1KJDBjSlWZ4maN1DldNxlaJcO6AcvN3uAyCY5/kZpYLi5kXCxNB
         JyGA==
X-Forwarded-Encrypted: i=1; AJvYcCUZIY2uNMXCSs3OKdnMG+DXhzzdsuKBXdHKeBibyHSXvuafdT+hAvkRzRtZXkUeEG6UlNBgtv5oi2Vsq/lmlw==@vger.kernel.org, AJvYcCVofJ4RTpOtm1czbKmYdP0Dglcv+ArFaS7+IXboVSKm75BBTyv/6Y1CBL4cizSxqVwPO2NNcQxVFAsP@vger.kernel.org, AJvYcCXubZlrpvNvWuiV08+hp5fibHKyVf+AsGQvca50GthOQFAo/z9zOKAlATB15jCbQqpNy7Yh2KcY7Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywyl+xAa6oNXAkQM2Ar2oobb7ZlxAES1o2Jq9hG4K3W5MyOyCKG
	3sgy/XwolJLv9AwVKDSpcc+5dk6fsmnFeVjdFa1ENfW/6tVyopOs
X-Gm-Gg: ASbGncs1CpR8rZewUzZvJzeMbf1rjfPJoQWe+AddDVKB+U7x+GLwPyIBZP4g92Pkbdk
	q8OtNheLzOWafCb++NZYiHFVsI016d91SE8XMT8JelbQWykozUKHIlTi9xP3sDc+lrtW9HGEr5c
	9Vke/ZRj7axI4An+ced4SVID6Z5z9axIoMIkJzPVGTnrR6WScaAQEOmnPb3uu2atY2C9qX3AgKI
	j5QK1ZKIQfsHBKOfSt0drDJvXRH8HIIyAFZdVSa0iM/StIJzGEKhbcPLnSpFq8SVmt+ilynhdvJ
	qCoHF3ejCumv2Cegzoq/iGkESpEl+Ou5zA+R9sdGIIcV4FYBnZRhUg==
X-Google-Smtp-Source: AGHT+IE334WqjgxAWvcxkXUFSTXe4vCldXlyr9bDDzWGT2kgLAPdKDj36gqRqI4dHTgRN05YEc7R0g==
X-Received: by 2002:a05:600c:4f56:b0:43b:cd15:2ec6 with SMTP id 5b1f17b1804b1-43bd298ed36mr5260745e9.14.1741135484760;
        Tue, 04 Mar 2025 16:44:44 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e48445c5sm19152951f8f.78.2025.03.04.16.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 16:44:43 -0800 (PST)
Message-ID: <d1b985d3-aa2b-4b63-99bd-7ba0ea016821@gmail.com>
Date: Wed, 5 Mar 2025 00:45:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <20250304192205.GD2803749@frogsfrogsfrogs>
 <6374c617-e9a3-4e1c-86ee-502356c46557@gmail.com>
 <Z8eUVcqMYfCJtdge@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z8eUVcqMYfCJtdge@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 00:01, Christoph Hellwig wrote:
> On Tue, Mar 04, 2025 at 08:35:52PM +0000, Pavel Begunkov wrote:
>> Clarification: the mentioned work was reverted or pulled out _upstream_,
>> it wasn't about back porting.
> 
> I don't think we ever tried synchronous reporting of wouldblock errors,
> but maybe i'm just too old and confused by now.

It's not something recent. After some digging I think the
one I remember is

https://lore.kernel.org/all/20190717150445.1131-2-axboe@kernel.dk/

Remove by

commit 7b6620d7db566a46f49b4b9deab9fa061fd4b59b
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Aug 15 11:09:16 2019 -0600

     block: remove REQ_NOWAIT_INLINE


>> lines. And Christoph even of confirmed that the main check in the patch
>> does what's intended,
> 
> I absolutely did not.
> 
>> Another option is to push all io_uring filesystem / iomap requests
>> to the slow path (where blocking is possible) and have a meaningful
>> perf regression for those who still use fs+io_uring direct IO. And
>> I don't put any dramaticism into it, it's essentially what users
>> who detect the problem already do, either that but from the user
>> space or disabling io_uring all together.
> 
> If you don't want to do synchronous wouldblock errors that's your
> only option.  I think it would suck badly, but it's certainly easier
> to backport.

Is there some intrinsic difference of iomap from the block file
in block/fops.c? Or is that one broken?

-- 
Pavel Begunkov


