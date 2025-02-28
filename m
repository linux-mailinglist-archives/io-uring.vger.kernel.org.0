Return-Path: <io-uring+bounces-6858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDB9A49907
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 13:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD15C1894827
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 12:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D876D2528EB;
	Fri, 28 Feb 2025 12:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+zCqjX9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F881C5496;
	Fri, 28 Feb 2025 12:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740745125; cv=none; b=q6S186xuWmNALafELVDNz+ZZ1poUDIRSEJtsT19xuomikeyzTlnx5qZDBEAOuLUFkWZDJgHXilujPC5RStDgRRoKB9/Z2k9cYYTM5Iv4FHM+KdHt/4YMTlHlIHwTLA0a++CsD3wRT6JnzkVGONbmEX+2m4BH5DOy/gnLGaVRz/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740745125; c=relaxed/simple;
	bh=sgW0YNdwYRDSxmaWTWteJIM5nPR6z3Sc94USerxItm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FUXUg14T/IHewLrj8zZA6Jai+EmJfvzkJbhg2E0GAN2Ztax2ogALVZ4x7zCbYbamK1zfPfcSC/F9rRslGOuDDAiFpCZLGAvIA+XNH7cqVIfl1xfEgTNEgrOVSs72H5xuyVh/9TlQvqcR4PERo6EoUTd5kqeIFp6ZZ/Yc7Q5vGIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+zCqjX9; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abbdc4a0b5aso390911266b.0;
        Fri, 28 Feb 2025 04:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740745122; x=1741349922; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c7SIWr2ThFzB1tHI24D8Gk5qOz2TXXbNyYjOp42ZCuA=;
        b=V+zCqjX9XqHuDczJFA0eoexyCYZRwIP4LTrgzHYJ7Arjsrur70zlge974xnVJoDMkL
         RCTBWCq8D2CFOBWm+GQnutE8RVk9ZjSPJgwtEfZNfIepmLaUPR9yg0TCo27DLZwC8C2V
         Zu9moNigZVw8CLLiW61rhn9Uu8DpCCUV3AwHIGygw6MWFV8zjpslj2UDEMbaWxt7rhM5
         klOwjqLwbIPA+L0JsGMEKht07bjhf0IZLgmm4exHlTv1KQAfxJr3iCcNWo5gE5DryiZJ
         NeRhEb9rcQvONWNkbBl/5eJqMU49apzBQOSqCbfWu5DwzpvtR5IAU5Yt7n6ytwsQWilx
         Aqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740745122; x=1741349922;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c7SIWr2ThFzB1tHI24D8Gk5qOz2TXXbNyYjOp42ZCuA=;
        b=C8iTSh3Rq0ljiac1qY0ekBO+w6YSs06sCZh7cmnbLu877KFQIoEBNoQ8gCVGd6RbAV
         Lqe2bRxsmhTRaI+mx4Hhlo+YQaDPGm9EiJZLfeDPcqPKGq1IaKeBCE5fhQerWLTpmc68
         zDZt6O5NsLo4ZVNrs024IM4BNlGcvueLza4ICnrqp7l8FJj28dnJCUyo6qhaq3PUeNfG
         b3E1xTPFO/BDQz96iIQUxXUB7W/e1aqi7IJURfYeJGxEB6b1GzpvU0xMK/L7Uxrg+9BD
         +i908gljVrXuEGoVUelMvB2iN0W8CHCw8g/U+TiaOWfSxRC0QHDS63QYYWaA2uA+vdGE
         XTZw==
X-Forwarded-Encrypted: i=1; AJvYcCVWxlJCxC7fz0VMofZe/aU6mMycSZOEgXpcaoAKDQ6JmruKxjMgNdho/ORjRQofxIwRCzziN6ft5A==@vger.kernel.org, AJvYcCWDOvnMbTzMbgBKVYAGA+ho8v0aE9H2iGraMbSUBtieNvJvH9EVjhoCq/nP+PyKtvb+GXZ7EoJPtHsWv/s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4V3UiiBL1TAbCPe4jQH5YT56YAsyqrZFxukIt7Yhk0wpLdm08
	WPfvGXQex+/dpRs1/Ru518k7M/wfQ0j2MlNKBWp+BtwSxls/E/LC
X-Gm-Gg: ASbGnctWdFQ6LBVl4cZj8NDWiJPlROvlwH+DMqvqcYAxNAvAmiUNV5MMji3OJ4iOFJL
	GE7RAWR2ObWPbLDhYKaj9KeUo2W+5g0OM5It6bRPqpjR/qk2wOdAMaXCEG1gYfe5laA8Y6Wcqs1
	1JC35Ete0Pb5ex1AKsy2DQrrjZGXwUI1U7GTtkSolNSH1n2T1nZGc33cApeK6oysdQRSV29epOH
	fAu6WOmLh7oxTnc8yfRY3QEQWP1eBPrQvxLE3gl0XTZTMhjZu2ev3r016aEZZkSzzUoQm3ACi8y
	xenstpxB9BVjBnKJZAJX8Mt9BT2dQb16QxSoCFsgJdB0n+4hieOvKbZBLrM=
X-Google-Smtp-Source: AGHT+IGPHyLQsed5yUeRTWv+zphJytb9RblvbLpHZXgnTPHxwnh00nVYpIFZ8NrCIb54H4NVT7eoAg==
X-Received: by 2002:a17:906:c105:b0:aba:6385:576e with SMTP id a640c23a62f3a-abf26207785mr343879866b.3.1740745122166;
        Fri, 28 Feb 2025 04:18:42 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:aa16])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c0b9cbfsm286933666b.14.2025.02.28.04.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 04:18:41 -0800 (PST)
Message-ID: <9676dac3-446b-4476-819d-e3b2f4bd18ae@gmail.com>
Date: Fri, 28 Feb 2025 12:19:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 2/6] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com,
 csander@purestorage.com, linux-nvme@lists.infradead.org
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-3-kbusch@meta.com>
 <844f45ac-e36e-4784-9f8d-528b022dff9c@gmail.com>
 <Z8DrH7sBSS752Z3o@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z8DrH7sBSS752Z3o@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/25 22:45, Keith Busch wrote:
> On Thu, Feb 27, 2025 at 03:54:31PM +0000, Pavel Begunkov wrote:
>> On 2/26/25 18:20, Keith Busch wrote:
>>> From: Keith Busch <kbusch@kernel.org>
>>>
>>> Provide an interface for the kernel to leverage the existing
>>> pre-registered buffers that io_uring provides. User space can reference
>>> these later to achieve zero-copy IO.
>>>
>>> User space must register an empty fixed buffer table with io_uring in
>>> order for the kernel to make use of it.
>>
>> Can you also fail rw.c:loop_rw_iter()? Something like:
>>
>> loop_rw_iter() {
>> 	if ((req->flags & REQ_F_BUF_NODE) &&
>> 	    req->buf_node->buf->release)
>> 		return -EFAULT;
>> }
> 
> For posterity: the suggestion is because this function uses the
> file_operations' .read/.write callbacks, which expect __user pointers.
> 
> Playing devil's advocate here, I don't see how user space might know
> ahead of time if the file they opened implements the supported _iter
> versions. I think only esoteric and legacy interfaces still use it, so
> maybe we don't care.

Sure, but it's not like we can do anything about it anyway, we're
not going temporarily mmap the buffer into userspace for that. Normal
registered buffers use user ptrs we stashed during registration,
but I don't think even that is the right thing to do.

Reminds me that Jens was trying to completely get rid of the ->read/write
callbacks in favour of *iter variants, maybe that will happen at some
point.

-- 
Pavel Begunkov


