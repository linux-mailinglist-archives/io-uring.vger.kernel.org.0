Return-Path: <io-uring+bounces-7436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7064A820F2
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 11:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8178D3BE0DB
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 09:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2AFF25A2CB;
	Wed,  9 Apr 2025 09:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDhKEFpp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28731D6DBC
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 09:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744190628; cv=none; b=HjftGQpt9MPdHXPxMsOFEnglPJRs0sQOO4NMg+VFt1CdlwXbZWyABO8iA8JE10mIRfsQO02snqRq69MoBnOatm5aExk2+lf6AkSCPgund64eD8dSzpN7NNIuQsxgDRkumezzvdJamS2MaU04ljM2lfRauYckkJ2nHZ+66OYRrVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744190628; c=relaxed/simple;
	bh=XFxl3TSVYHBrLgOff5BZL4pXyBpy9HzLoqLePWrZRd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=l+gOl/Pn+EFv5YOnWEcm20KRqlBdrQShimBiyNHd/jBnCXbDhceIm8cbgCwyPwx0uwj1jCBRp3kW5uRxGVuDTSrFbRr67eMzwAgcNE/BrldMvIomUuVVOZVwAq3YNxaUV0uqtXFqLJ6HXcXDaKF3wF8rCbaZaIviao/CMwtDTUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDhKEFpp; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac29af3382dso1068285166b.2
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 02:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744190625; x=1744795425; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eyv1ZK+SojgtZvgiZO6GJ8bW6FErXyts3MogH2Nes2g=;
        b=YDhKEFpp/n1/Di3Y1v1qu0Dug6tcT24RApbvuYNkGDLOOGY+HDatIWB95QWL/ciwPR
         TsQBOIzDJ00XCZV8MXNYS0QOo6Jh+NeP7nL208eGCbW0cX3jAB2HIuaaojTYMZ2hEhbS
         shRdA65kV2l1xXfueMfYI+q0cdBSc2kXOMqhDGVIChVgnDxlWC/hGEA1YLglXXpyaehN
         Bk6ouJip91qVe4m1C3uTNlLd9DD58MvtXqzsRrv3yy2TFejrzld6X5AYVKpxqoP7cxMM
         pl4n5Ws/elneTBhB/dxm/pVeuZ5CyghZyMpiTxTZVc6UK74KQAsji8XQpltTJ8QMYRxt
         pc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744190625; x=1744795425;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eyv1ZK+SojgtZvgiZO6GJ8bW6FErXyts3MogH2Nes2g=;
        b=act4Qpv47N6dYQhY0Cldafqt73fkHcslUCGzjuIR5o+OVbcaNr4/qhjaPK+WYy8sm+
         ZkIwvM/ucfD1zoSwFs3gpCcWbZQgJv3XHglo3H+wpYldjhXVH+5O+zADu/m4nTd0/tVV
         lBXfMpjRwnBlWzO6NZlKuKadpka9Gvu+WoBRbn/NrV4Kfq9OWXA0Glod7wF+3HeBaapv
         lzb5LysdNQaBm02vy9kJwOtAslG8VFDFg/Gk0Hc4E83A/WV4pBg49WtlrHQxsaWK9IK/
         GMNtKuXSsWi8Vd1yc5zZW8rAMBlxaqAbpwRMt9JtprSRxCFZKbkYT5vCZEUxB8jcx41o
         7oQg==
X-Forwarded-Encrypted: i=1; AJvYcCUwM/TajvCAyUQ88+edr3tbqjz2mAbZvnVQOEyWSTlc4ec9Ys/WybKvoOw1AXXSwfaliKsVx2z2Lg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDpBS6iVA7SZzfrZwWg7lwBpel5Li0k+dHY98oQr1JZjuHwuPW
	MOl3O7eXvSgpeyUxYgAhJFmhKquJeo+SEczszbsOiKf0vTJTE1UqdVxslg==
X-Gm-Gg: ASbGncufvJZqVj3lElH+hLtB+aCYVbufZfWdACRRVqqem4AcWiMuCXj+33ixDRFWlvD
	YP30xfZDvKoeSGfi/miq92xXvncW4o1I2+Eq1/hiJPdJOli6fRIYiR3t33O7tspBMr5FduO1wwt
	egy0+pn+2WNueOKfXaW9rHPAhlX906grLT5pBSc/17pSKE0i6co1sgpWxF/jalRZKm5Y2TNDsuE
	yeux/iJEYMXHStnQhXbgGwvQ9T047TwPZWgHkA/zPqUNqyfkxwKrmLl/r36/YkOwfT/RGQZVAnd
	f9ek9FTihcwoGyhxCyJzGFt6C7wJokmgOS/xy+jSAH0GP4+MScz7
X-Google-Smtp-Source: AGHT+IEda00sSlJqlJspg7wHdDVrK1oGtoqWXyExYXhHEazPwwpZEv9esf0YHRQaVA9b2yGzTFFsrw==
X-Received: by 2002:a17:907:c29:b0:ac3:ad7b:5618 with SMTP id a640c23a62f3a-aca9b614af3mr225261366b.3.1744190624554;
        Wed, 09 Apr 2025 02:23:44 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::5b? ([2620:10d:c092:600::1:f00d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acaa1cb3ef7sm62218166b.89.2025.04.09.02.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 02:23:43 -0700 (PDT)
Message-ID: <c20c9c4c-19c4-47fe-b9d7-b4e8dde766bc@gmail.com>
Date: Wed, 9 Apr 2025 10:24:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring zero-copy send test results
To: vitalif@yourcmc.ru, io-uring@vger.kernel.org
References: <d7a31a1e-87bd-4a3b-abbb-f1e26b2a03f8@gmail.com>
 <5ce812ab-29a6-4132-a067-27ea27895940@gmail.com>
 <f1600745ba7b328019558611c1ad7684@yourcmc.ru>
 <f7e03e2c113fbbf45a4910538a9528ef@yourcmc.ru>
 <61b6b1d6cffae4344254ddaef9be6621@yourcmc.ru>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <61b6b1d6cffae4344254ddaef9be6621@yourcmc.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 13:43, vitalif@yourcmc.ru wrote:
>> What kernel version you use? I'm specifically interested whether it has:
>>
>> 6fe4220912d19 ("io_uring/notif: implement notification stacking")
>>
>> That would explain why it's slow even with huge pages.
> 
> It was Linux 6.8.12-4-pve (proxmox), so yeah, it didn't include that commit.
> 
> We repeated tests with Linux 6.11 also from proxmox:
> 
> AMD EPYC GENOA 9554 MELLANOX CX-5, iommu=pt, Linux 6.11
> 
> 4096 8192 10000 12000 16384 65435
> zc MB/s 2288 2422 2149 2396 2506 2476
> zc CPU 90% 67% 56% 56% 57% 44%
> send MB/s 1685 2033 2389 2343 2281 2415
> send CPU 95% 87% 49% 48% 62% 38%
> 
> AMD EPYC GENOA 9554 MELLANOX CX-5, iommu=pt, -l1, Linux 6.11
> 
> 4096 8192 10000 12000 16384 65435
> zc MB/s 2359 2509 2351 2508 2384 2424
> zc CPU 85% 58% 52% 45% 37% 18%
> send MB/s 1503 1892 2325 2447 2434 2440
> send CPU 99% 96% 50% 49% 57% 37%
> 
> Now it's nice and quick even without huge pages and even with 4k buffers!

Nice! Is ~2400 MB/s a hardware bottleneck? Seems like the t-put
converges to that, while I'd expect the gap to widen as we increase
the size to 64K.

>> That doesn't make sense. Do you see anything odd in the profile?
> 
> Didn't have time to repeat tests with perf on those servers yet, but I can check dmesg logs. In the default iommu mode, /sys/class/iommu is empty and dmesg includes the following lines:
> 
> DMAR-IR: IOAPIC id 8 under DRHD base  0x9b7fc000 IOMMU 9
> iommu: Default domain type: Translated
> iommu: DMA domain TLB invalidation policy: lazy mode
> 
> With iommu=pt, dmesg has:
> 
> DMAR-IR: IOAPIC id 8 under DRHD base  0x9b7fc000 IOMMU 9
> iommu: Default domain type: Passthrough (set via kernel command line)

-- 
Pavel Begunkov


