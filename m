Return-Path: <io-uring+bounces-6574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A0AA3D62E
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 11:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CE243AE6FB
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 10:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C6A1EEA37;
	Thu, 20 Feb 2025 10:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwyRd8+/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CEA1EE032;
	Thu, 20 Feb 2025 10:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740046297; cv=none; b=PbAmNspyM/n+l+4kTJVkrmAQA2mWGuqIdA9nsXJ9q0xExergwMrNYL4SDq8D1q8SnKKkzUZ7VeT77+T8558yHTa39xt8+5wHW9MMYpnKHwrFp5x+Hizqyqj5NczuUnIc8Zb35Ppl1dwxR0MtwYpKffnnjMMQMHb/HN/zVzTGFhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740046297; c=relaxed/simple;
	bh=jkiVGj/TUdQIFOaAygxX7+Jk2trB891Z7v8mo2A0Eb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R2+IbRthopkJxJpPRApRugsib3sEt3QOKzS3B7q+D/7pXouRbYeG5gAdAG/sEEB7qQnfyd79H+T4hEyXg0Rcw92HjcOn8/l32l4Yztmg0os8izAZn2YJVDF23yYuWFQ4g8TLRKh5leeTvQozdMiPGKihiv+iQODAQidtXtL4ozQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwyRd8+/; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e050b1491eso3306711a12.0;
        Thu, 20 Feb 2025 02:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740046294; x=1740651094; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GpFFsAs5cvbWFTBWXYhRXN2UcEGPZZftq0JzXbR36CI=;
        b=NwyRd8+/kTKuI/K1g5Moa5nQKoH47wbvec+lBp+SUVJuL1k+u9OQcegeRZnyLaOMVv
         yByulCqxSPeDfw5bbgLY3kS7p+HTqN9MFbxm+Br7/cHDaxb/cMvLR1zu89pfvm7dkjwG
         2OrTK5rmlct6HWAtBdqnmgWr/5M4koZV8DHNfLpqMDWgDl6eS+AZ5l3osy+x+DSQCfFV
         p8g453fCNMY+ocgSQSBuw3j0TPPMRtTw7QzPXTityxzH/4n08rWJNkP06qVC29peW29H
         GQ4aDJuUj5LdrxMhiOTg5ra7ide4ZWvPfzDwv6EPxoV8PPHieOg8tKGmhErQqVIyWtvR
         /sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740046294; x=1740651094;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GpFFsAs5cvbWFTBWXYhRXN2UcEGPZZftq0JzXbR36CI=;
        b=jJoTXh/1hnoJYY8mZOg9fJ9cobAFkoweoycPIEfU50k3Od0+OLV4cEp2a5CnaxfCiM
         oTvEe5AfhuVKKj5lXeHf/+quAf8/gr4LeNT/WFzN7bGsJGI17VOVXvb59iyRQk/7w5UE
         +tkKtJxkOnwyig9+DwbQ8TTMXhc7pmjdIc0JTC/s6QS/qv14uj2e+aNDIIEonzdNFQWJ
         QI+eSCVrnOrNbGD6kp9CJFeI4ht7MulDLFQQmK4veJhy5brtaWBJq+KDmNKs5TmRGE0C
         2KkQegFd+TzlPWnMXPMqGCsRQTs43Z80g2beicAh5oO8C/obNwtDcf0B4fMlgfvXkl6i
         mC1w==
X-Forwarded-Encrypted: i=1; AJvYcCV6ZCkLaVUearVxFYT7y94IKEKzRgKTzzXVTLduYwGncq6Hwj3L9TM4ZjcZHiGnIEh6TqJLRzuRhAM01Ag=@vger.kernel.org, AJvYcCVE3FhGoE7DVDJupdv7rHJNZQMIKDniboQkwQYU+hvDCp1YBu5nAszOoSxYBn0YGSoNqltDtSrR3A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz5pPwFEJFJPGipGkibbtrpKy9lKw30Rw1WY7gOR1EqI/bZKSW
	sFp8sf9yQd7JSAiVpExiX3JAmjWSQYFzh1fXB7xBAM+EozL/bTkX
X-Gm-Gg: ASbGncuWB3HsPKjNp6SKLTCj6zv+/Jtg5Y0qmu+1jGiFPfri30vYVHwHcnHP3zCElic
	32A1G07KPaHycjO6939wyqe1GgmQOfMDBbf0rTvw/44q7ailbzUhvDnC5B6gJt+tShniblSwgJ7
	YfMYGPjHor+7xocByzyZLC2CqJiRXtRROZsipbhPwS6xOKuTfTSW4AL5YwagL005/X+bs/N20Oj
	La0+Or5IT2Db7WR+mUAQnMnU03hYF8/x6iWLkclETm4qki6+BwjhHdWAhLuDhCUMzAxYwoTuH+Y
	sR0Fcp9c3dUhioX7san/XdFlgNDu6i7IwMrMLLFluJN9KYxv
X-Google-Smtp-Source: AGHT+IEpnVmezDMTHnEJMcRGWitQtO2QoMSoow/C/56q2yB2h9Q5VP5S9PPFB9LOywGK78RKf91F2g==
X-Received: by 2002:a17:907:9989:b0:abb:daa7:f769 with SMTP id a640c23a62f3a-abbed5b21b4mr284392866b.0.1740046293733;
        Thu, 20 Feb 2025 02:11:33 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:f455])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb916db37bsm829929666b.165.2025.02.20.02.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 02:11:33 -0800 (PST)
Message-ID: <06c87de5-6b4d-405d-8b1b-a9684e441ea3@gmail.com>
Date: Thu, 20 Feb 2025 10:12:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 1/5] io_uring: move fixed buffer import to issue path
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com,
 csander@purestorage.com
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-2-kbusch@meta.com>
 <c4a0cdb8-ac99-4a7a-9791-d2c833e45533@gmail.com>
 <Z7aEhR8qh3P58hkE@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z7aEhR8qh3P58hkE@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/25 01:25, Keith Busch wrote:
> On Wed, Feb 19, 2025 at 04:48:30PM +0000, Pavel Begunkov wrote:
>> We're better to remove the lookup vs import split like below.
>> Here is a branch, let's do it on top.
>>
>> https://github.com/isilence/linux.git regbuf-import
> 
> Your first patch adds a 10th parameter to an nvme function, most of
> which are unused in half the branches. I think we've done something
> wrong here, so I want to take a shot at cleaning that up. Otherwise I

That would be great, I didn't feel great about it either, even
the existing ioucmd arg doesn't seem like a perfect fit.


> think what you're proposing is an improvement.

-- 
Pavel Begunkov


