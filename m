Return-Path: <io-uring+bounces-4548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3F79C0CDA
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E2A91C22894
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95BAE1917E7;
	Thu,  7 Nov 2024 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHLjb9st"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA61190049;
	Thu,  7 Nov 2024 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731000640; cv=none; b=IQZylMA58+CxjN6GB3rCpyw7sl29RJ+PIbzXQoAFxhpVFduBoIKZIIEwbtBlK2QPXYRTptdbXPUStKzcRxq31eLPy9uwxAHPNUf/xqqVn4m+tC4l/dy744Ij0UunNygbmYH6AHkPOyi4z9Bg9K8cdCVmRTlXU/nnMUpctZSkTjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731000640; c=relaxed/simple;
	bh=Kic2XLGRurlrGactitQeZzSqbNEAU2q2DiXEUxxAYj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SuN5LQLImGWmJzbq1kdYYUZ3QzxToLUC3p5dLX3wVrOPPrVi5+u3nZ6QShtR3sPb2pMYOsKwXqDZsVnr476rs8Y74SFNctQdgrsAs3kz5+PEpJOcGGeAFvC4hgNQ2+Bh2J7OkZsJE79kbpHmkrG1IKlJpSr0Y6woe2RxMUyBzTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHLjb9st; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5cacb76e924so1841140a12.0;
        Thu, 07 Nov 2024 09:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731000637; x=1731605437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lCnx04qdk6zMZ0LIRHX3e1wxnrAQ1/h0DrPbQAd66Xs=;
        b=KHLjb9stO5rXZeQB8rSS6cOZ+oKE2iI0ZEde+2OtIwUT5jXXN7q7DBht0YfEl4gXNt
         iCjRNupoM+ynr124e/FeZ2E15eqiscIbUdZnrF+Y12aBIIvvh8w0j/DnBCXP2MuBlphu
         d241jO6yvFgMaWJYPvfOzMqxmxyr4ODK9Bk4WESLHzXwyjW1i8CM2gil501C+7jiExLa
         amJE/0kfiBoNm+iHBE50oeJx1BZGaitQfEljjcWF0B5y6wLwbJ3OIsxIw4P4VH8y3HfR
         RVmHZkf3Ps4B0WrRl5d6xzahPZyvazqGESE1MlEfehc9Z9vaOJ4Bkf51TF0aC57f3YiN
         zoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731000637; x=1731605437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lCnx04qdk6zMZ0LIRHX3e1wxnrAQ1/h0DrPbQAd66Xs=;
        b=AEtRYiOK1cvwoGpWpkrM4bUOu73yIug9mvweIjFAR1ErGQsCbM3C9g6U07T8LL9tmm
         GHanIVYxnsWsUUCIgKCH87v87WCJuCUkSqBPiSJX1uhEBxVuIgb513xRpy+6MwNC02aF
         bdPGGhmfqkPaXJwvYasIDpqv7iOgfOS0LBguxONgtqGOakHWla94o1oh6ttK9iQdRsbF
         92LgDuvjh/6sn0vq8GXGsihq8QF39DoYlC1HMyhPJ8AxldE02qJUyjcFL5VFtnGnhKbL
         yLNOCqmJX2jEr+J/xjtkWMz0wUocubZgz6YVCF/7lWYoUJRSyf4oIFXy0+OBIyF2oAcz
         ha0w==
X-Forwarded-Encrypted: i=1; AJvYcCUtLnulpnFzeR8O2JJ+O6JQbvBBZtEnzaQs5o9ouWntGzlKSCE3qkf5snZg9v8i1vQkyhiLS9AgOU4hFnM=@vger.kernel.org, AJvYcCVK4WuEV3qCFFDx8c7xKEFurSZA7f7oiW+gCnsUm+gcErdQC8cs275Fgf0nZAtJySq/gggPEki1sS4npQ==@vger.kernel.org, AJvYcCWjJgfw4l6XUPcyoIaRhMol1IlJ7dSMvU51cBJGodrD3adO+UGvn4qLdFLUQPFgbQHLExREdq5BsQ==@vger.kernel.org, AJvYcCWkpYTVOXp/cV183izgyKwcfxp6ewmA4uTkD967WM4xZqlcikGCfTDVmSxcmppRDYwb1mKp/n8FAMqDPRzOng==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDC6bqWgJru9AbgTxwUMv737vQ1P71YnacgBeFgpyXNGITjl50
	PdUn2k7FCd2Pe5PtvswWMlHGcjRNLLXpHURIQ/NQqu2E+FnvfHqK
X-Google-Smtp-Source: AGHT+IESnbWGzA/22VokA2ZRCeQrgxKGn28bGagAmMqOxAFoTUKzdME8cEC2XEg/ojV+oORHekXoPw==
X-Received: by 2002:a17:907:1c05:b0:a9a:19c8:740c with SMTP id a640c23a62f3a-a9e6587e0bbmr2393468966b.47.1731000636974;
        Thu, 07 Nov 2024 09:30:36 -0800 (PST)
Received: from [192.168.42.191] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc56fcsm124607466b.125.2024.11.07.09.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 09:30:36 -0800 (PST)
Message-ID: <7995ffbd-7ec0-4f99-86a2-011bc3375228@gmail.com>
Date: Thu, 7 Nov 2024 17:30:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/10] io_uring/rw: add support to send metadata along
 with read/write
To: Keith Busch <kbusch@kernel.org>, Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
 anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
 viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241029162402.21400-1-anuj20.g@samsung.com>
 <CGME20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c@epcas5p2.samsung.com>
 <20241029162402.21400-7-anuj20.g@samsung.com>
 <ZyFuxfiRqH8YB-46@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyFuxfiRqH8YB-46@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 23:24, Keith Busch wrote:
> On Tue, Oct 29, 2024 at 09:53:58PM +0530, Anuj Gupta wrote:
>> This patch adds the capability of sending metadata along with read/write.
>> A new meta_type field is introduced in SQE which indicates the type of
>> metadata being passed. This meta is represented by a newly introduced
>> 'struct io_uring_meta_pi' which specifies information such as flags,buffer
>> length,seed and apptag. Application sets up a SQE128 ring, prepares
>> io_uring_meta_pi within the second SQE.
>> The patch processes the user-passed information to prepare uio_meta
>> descriptor and passes it down using kiocb->private.
>>
>> Meta exchange is supported only for direct IO.
>> Also vectored read/write operations with meta are not supported
>> currently.
> 
> It looks like it is reasonable to add support for fixed buffers too.
> There would be implications for subsequent patches, mostly patch 10, but
> it looks like we can do that.
> 
> Anyway, this patch mostly looks okay to me. I don't know about the whole
> "meta_type" thing. My understanding from Pavel was wanting a way to
> chain command specific extra options. For example, userspace metadata
> and write hints, and this doesn't look like it can be extended to do
> that.

It makes sense to implement write hints as a meta/attribute type,
but depends on whether it's supposed to be widely supported by
different file types vs it being a block specific feature, and if
SQEs have space for it.

-- 
Pavel Begunkov

