Return-Path: <io-uring+bounces-7255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1C4A723F2
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 23:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5453A1782CD
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 22:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D481A76AE;
	Wed, 26 Mar 2025 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mccaYWhh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8814430;
	Wed, 26 Mar 2025 22:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743028239; cv=none; b=ZCZkToUsTFwv2B7l183KCXoT7em++8FClD2ehCAG9FRedAU3MMY6xYc7sMJX4bHW2IEBEAgvELLWuy1hywHq5xyNgRaYTdkybnoOxv3QfdkyZ5kBeClksxIfq1icdHuUqqj/SJx3h3jxuoPF2RfBBIUiaMw90kA7yuBgnaqxnXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743028239; c=relaxed/simple;
	bh=tuEwC67X2K6KPMrZGkJtbrLf5Sp30oMIKRWl3wkeBGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KYumlpbjGJRq0PdE5QUuAj11D0rensIwE2H8Lt/bEySGx/C4lkauM1g8458EPcF3Ax/FAK8SJ9Cv+2MwgmmujSsvt2CKQYZIBCTxVBcMuShXWmtL0vpt51zEXDk300F21XeeE192ZDBKgAU55vKhpRCn+utYogShAICl9zLFLAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mccaYWhh; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e6194e9d2cso623178a12.2;
        Wed, 26 Mar 2025 15:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743028236; x=1743633036; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Mb5LQqfnEcJgziIU9UWtOckujfFuIn52pCw2YFX8Sg=;
        b=mccaYWhhCXB6RdUNvZkWuKBelZN9bkD7zcEIzwdxHeid2pqzRTyLjh7A0/W7c4adow
         21MN0i6Tc2Q2QBrFRtGBWV1KEuzkFBXBCXVUIdHMNFOYPIsYx/FRTg7g3zGOgC3l7aVH
         7PaFTzCITU5YZYBod3oLIZktuHShXBzxHaDSnKg5/AjYIZsn8h5/Akw4VZRNzF/riPhG
         JgmfTMYU+W8w9dbMUcgigiBEC/5deqKArNgXhIvBAlIkW19YrJ/m4+RFcHod29VNdKFW
         JTK+41LsHrGDPlFmtaO89zRMVH/PP0hDSKzNJXpkzobbBv0Tnnpq3jSdVkS2QW3fuqkC
         mbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743028236; x=1743633036;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Mb5LQqfnEcJgziIU9UWtOckujfFuIn52pCw2YFX8Sg=;
        b=u7ZPZcp32Qj4oqdEOTE5JcVrt80jVEC9h3748dPuxNv4pleK5Zuf6b4OKsDkeZXxoG
         TYpu5Fvw5XBLDHFFtmvpNRVNkR+kzRTk7eaM0MIMNApP0L76v7t5nv3fN5sY9J45w6A8
         nI56Ywoqsb4y4pbp2zUsNqZUNVOIK3fNyqrKYbZUN2GvkXxho3ajBvuwoUHSZKfKf6+X
         DOV9+eUF1kNxPJH8H3mifC1e+CS9UKon8AlLbUkaVVVwl5NY08wmfB5+nD02GE5LdR1l
         6mBj9GIr+4eMfmpOfk1vOWkArIuUPWkyhrVN/sNF7pM2Z1yNtNL70Bt2vGG3kfSeYrG6
         tN9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUAyEYXsfVMZB508xbAFe8gOwcMjwumdwebdOM6eN9GVjZIpMoeB4bDQ41V1GjSEc9SZ/ei/DJOrDgwZbk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7dx35wdMnxS4EBqcZpKocrngj/iuO64knCKH9ZudSINf2Gmnt
	F9sw/q8R4/daKoE/5/inM1tZW3n99Zm4W7bGkbuLVM6TmQ0dp+kb
X-Gm-Gg: ASbGnctBuz4+FgIUOsIkwGbK2umMNFj1ExdxV1TK6OUEd+b2+HPxenwW8721qjCP1JP
	waETWEUS4Z210+nDHO3c7PiuT2Oz+5mAyaaNeST4qV2E2Si4YXqILjyH/RKc3LCzquueOPMd7tf
	BU/zchvOIvABleR3likXEh7Rtx4qH7n5q6aBCWRy5IBTqvAp6Z6QDwLNMalEqt/ozkGQFXVXVls
	qzwe9P/28PCR/icY/fkxfu2mxPU2uYgoywiyt+PSi2gqA1cLdTwW3GkWvdGAgXOqdqw3w3BWQPF
	w/UAU+7HU8qhtb/VUL51tVRY94VVkkUHGEoTqodgx/UOOGl/SNKFLGOXeiXhkGYr
X-Google-Smtp-Source: AGHT+IE8tsEYj2xepuB3HQp5nRkqZ5nof2dW3KzPEr1y2H9FbJdUbIxwbLPu5rhoAsFm9A0igk2QaQ==
X-Received: by 2002:a05:6402:2813:b0:5e7:8501:8c86 with SMTP id 4fb4d7f45d1cf-5ed8ec1e7eamr1106620a12.22.1743028235838;
        Wed, 26 Mar 2025 15:30:35 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.207])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ebccf687fbsm9987978a12.4.2025.03.26.15.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 15:30:35 -0700 (PDT)
Message-ID: <d1bf1b35-126d-4484-8bb5-0a720717ad78@gmail.com>
Date: Wed, 26 Mar 2025 22:31:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250325143943.1226467-1-csander@purestorage.com>
 <5b6b20d7-5230-4d30-b457-4d69c1bb51d4@gmail.com>
 <CADUfDZoo11vZ3Yq-6y4zZNNoyE+YnSSa267hOxQCvH66vM1njQ@mail.gmail.com>
 <9770387a-9726-4905-9166-253ec02507ff@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9770387a-9726-4905-9166-253ec02507ff@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/26/25 17:05, Jens Axboe wrote:
> On 3/26/25 11:01 AM, Caleb Sander Mateos wrote:
>> On Wed, Mar 26, 2025 at 2:59?AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 3/25/25 14:39, Caleb Sander Mateos wrote:
>>>> Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
>>>> track whether io_send_zc() has already imported the buffer. This flag
>>>> already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.
>>>
>>> It didn't apply cleanly to for-6.15/io_uring-reg-vec, but otherwise
>>> looks good.
>>
>> It looks like Jens dropped my earlier patch "io_uring/net: import
>> send_zc fixed buffer before going async":
>> https://lore.kernel.org/io-uring/20250321184819.3847386-3-csander@purestorage.com/T/#u
>> .
>> Not sure why it was dropped. But this change is independent, I can
>> rebase it onto the current for-6.15/io_uring-reg-vec if desired.
> 
> Mostly just around the discussion on what we want to guarantee here. I
> do think that patch makes sense, fwiw!
> 
>>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Thanks!
>>
>>>
>>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>>>
>>> Note for the future, it's a good practice to put your sob last.
>>
>> Okay. Is the preferred order of tags documented anywhere? I ran
>> scripts/checkpatch.pl, but it didn't have any complaints.
> 
> I think that one is minor, as it's not reordering with another SOB. Eg
> mine would go below it anyway. But you definitely should always include
> a list of what changed since v1 when posting v2, and so forth. Otherwise
> you need to find the old patch and compare them to see what changed.
> Just put it below the --- line in the email.

Minor, yes. But to answer why, because it's normally chronological.
By default I read it as Suggested-by was added later and not by the
patch author, which nobody cares too much about, but that's why Jens
mentions ordering b/w sob of other people.

-- 
Pavel Begunkov


