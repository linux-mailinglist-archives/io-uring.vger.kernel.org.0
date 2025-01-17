Return-Path: <io-uring+bounces-5957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 28959A14802
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 03:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74A337A066D
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAB88F6B;
	Fri, 17 Jan 2025 02:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="K5ALaNwG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94653BBD8
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 02:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737080162; cv=none; b=Ck6CRP9vRIMgCVe40OGZG9ySqAsVEnqNYuk4By1Vdht1ExyWiVZLV9DFnVzXNjiwX4iWCTEul6ZlK21mnyKvuvgIFrce1NKYAw+v/G4rtO0y35Buu0Laf887m8dYJlw/BSCgC/lhjHvsej7T1eTeKlWyKBY1SjOp1eJkXJ3NhGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737080162; c=relaxed/simple;
	bh=GK6afS3pR7STHAAJosx89JAfCV4nfsvfsdBaf/OGF3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZlWXaTM4EVuOFsv4UE5A9aBZ5iXudMSdO52ff01dR70Tmdw9U+0+cXqlipFrGIOpTZu/LPO7RzQveikfeJmYrFh1L+R9s0W3+YsYZ2VElGFdTX4dnG1NK4G4dlVWuD3SDcVR9YaDElYOwU4bW9vHqW0ZJqJpxQ9n2XqCiaA2mWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=K5ALaNwG; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-216281bc30fso37003995ad.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 18:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737080160; x=1737684960; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TCuVVzkQy59UCcZDOiVi2Rn0kAlSnwhXHYiolAdQcns=;
        b=K5ALaNwG74qYfE1QmaRna5H4CbEbuA+ufaQ0BuDvDyfS+vY85fabswCaV4QZAOzunX
         QtbXo2MUuLsIhfPwryez9Utum3rJvCcW+GhpUEBTISnas/Qx1stoUWX7m77xmVbzNk4i
         MOyNCm7hh2wlcNji270u7E76ma0YKzHzXpEIOHnCPE11jX2oIndyLLdaWiPYZk34isfm
         U4c90wWnC3+JqORVL6WNHwU5if69yDwBKwsG0+dDwxKpCyqqXsjSTylG9Z7uNTa7G3Ef
         LWDKmRMmsg5bUQcC10W3GvUIrWkbcXi03FD6xAluiUyNJrNdsF4ULBfOoafeZ0276HhL
         cAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737080160; x=1737684960;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TCuVVzkQy59UCcZDOiVi2Rn0kAlSnwhXHYiolAdQcns=;
        b=WO7avXM1RvZjuRxoxryQ77KDB7ZV+QyIb1g5V+2OSxaJqmnoGNTRJv8omYnG300Ard
         IZ8k3r2L5qFFdv1p4Mu2E8T+zazIIjKuP/qzDo+DP7sF69Tccu474zzA0QpAlMrecPqe
         lPPmOc9KCEzXZNhTNX/+aD2oyWQMgX19tHVDe+RC58NS+1N91Ojvh4QNlRFB3omYpebZ
         oO2NFa+sBjk1If4JbTUiRuKH1DHVHo0u/b243hBriN6iy1QDPex9Gttnk8qUbx6NYmok
         MyH1YqJXNqIsACAnNlZCcSfQpgBnKHlI7STFJcECIa1J5Hl/NYLgJCUlHzX2KR5meiEB
         Q0jg==
X-Gm-Message-State: AOJu0Yzm9FgUyXWfn0ftsPVHgNFWpzVVlV/O9epKUQMWpxMt99AOGNUu
	ayi4W5Jdf3mJ65l36ve9Gr5W0fSvwN8Z134qsHqrsnCassWLJz/8t4r6FEQ2zvY=
X-Gm-Gg: ASbGncsShhsViCLLhwAm8D8BVs5Fup4RwHhvV6QhKBtSPbGz2B8dVnbPJ0K+AvPw3lx
	taplOetrJ2DtpWWr370VSrmz9Y5zazVcyr+fb/gV/azLqUGmw7EZZ+EwuwW8MIstZqHjsTy3jwl
	g489HbfS9ET+PgxeItVVrx2XF1SLMU3uDSUOmOFwn+XbRHw34cws0Mkt4wPcu+1zOWZeVAFYajN
	DeG/PI0e0jH1P3E995GlvSOwrqVL7hp5mzFfOZ4PmcBJ0g1bMxRjNIMZZ2VrZnphssjvLa7eEXZ
	MF83CKtJ4JDbHyZQJg==
X-Google-Smtp-Source: AGHT+IG7iU445RErzMyHQfWntDOYm0u6q8Co5wgOH5BezmytYlTIPCVKI3H5lcFN36ZKluXllht/Nw==
X-Received: by 2002:a05:6a20:b805:b0:1db:e40d:5f89 with SMTP id adf61e73a8af0-1eb21590232mr1301770637.28.1737080159994;
        Thu, 16 Jan 2025 18:15:59 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:cf1:8047:5c7b:abf4? ([2620:10d:c090:500::4:b8ed])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab7f1776sm690701b3a.7.2025.01.16.18.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 18:15:59 -0800 (PST)
Message-ID: <4f8dc7b1-0213-46a1-85f5-2d77e7b98067@davidwei.uk>
Date: Thu, 16 Jan 2025 18:15:57 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 04/21] net: page_pool: create hooks for
 custom memory providers
Content-Language: en-GB
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <20250116231704.2402455-5-dw@davidwei.uk>
 <20250116174634.0b421245@kernel.org> <20250116174822.6195f52e@kernel.org>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20250116174822.6195f52e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-01-16 17:48, Jakub Kicinski wrote:
> On Thu, 16 Jan 2025 17:46:34 -0800 Jakub Kicinski wrote:
>> On Thu, 16 Jan 2025 15:16:46 -0800 David Wei wrote:
>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>
>>> A spin off from the original page pool memory providers patch by Jakub,
>>> which allows extending page pools with custom allocators. One of such
>>> providers is devmem TCP, and the other is io_uring zerocopy added in
>>> following patches.
>>>
>>> Co-developed-by: Jakub Kicinski <kuba@kernel.org> # initial mp proposal
>>> Link: https://lore.kernel.org/netdev/20230707183935.997267-7-kuba@kernel.org/
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> Signed-off-by: David Wei <dw@davidwei.uk>  
>>
>> FWIW you still need to add my SoB for Co-developed-by.
>> Doesn't checkpatch complain?
>> I guess not a deal breaker here if I'm the one applying it...
> 
> Ah, and in case I am not..
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I'm sorry... Checkpatch does complain but I missed it in the sea of
warnings of 'prefer unsigned int to bare unsigned'.

