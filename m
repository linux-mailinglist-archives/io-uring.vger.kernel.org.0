Return-Path: <io-uring+bounces-4658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E03E9C7C0F
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 20:17:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DA5CB2EBBF
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 18:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151872038B1;
	Wed, 13 Nov 2024 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="t4uyjy0B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74E2200CB6
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731523199; cv=none; b=CSkHBVWCb09uqn5oAwOmyHjhNMYqV8Y8QK1N7Qa2QghQSCC7j62GqnJK7z55UotFRIW7JFNyR+sZiX8bgM6KGoSayjnVxgt4r4zZkbzrSMz9W8RsQExpt7nF/4VrIfm1UnGMnbXdiM/hugtRuiGorU2G7N9g7h6OlxdDxOlvB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731523199; c=relaxed/simple;
	bh=2oozyG9UXwFWfpyRebPhngHz207nrqCB7dySSeD1/u4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hvjMmGAELj+QaHR/MdE163vHLrmGTZ1v7ZbDdTuwB5RfaGh64DwioYQZIXnb9ZfG/VWac8JC5QgmFnSulzx+bIwZmXunh176ECqQXjV8nDWmp57eSkqWtsB7gDpksa5o7ffF4eGVSdKjfG+NB0moKo31zBt0tOLdeMfgeXICCjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=t4uyjy0B; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5ee8eaa1694so1061295eaf.0
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 10:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731523196; x=1732127996; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WgXDWP6uTO9OvPO11ONSGz0dajsnDJA8Ia+wd76L1pU=;
        b=t4uyjy0B5Aj6iDtnrraJnAyhKwczySCCW5Mw1q+I/zpXOQTdm+icnYteLDSTwawV4N
         XZnSXbYEyXPwSP9HPWJUYKppbFD2YMHOhL4Xkk4G6elv30iv6tnR5E/G39tVYTBwaA8j
         Q9wZdw91hIFkz5J4Tv9PtUvKXE3EVBArUVq4sauqt3dYBuh3NZaxl7lt19wvkjwCujzU
         GCsj8iohPtn+3sZMNYfLbwRuVX7hqiddohT+G/3KIMMpPdOwZY8yLbUgiswrED+EBnZY
         210m97AHwGFxi/cYouPgL2OX8rQZh2xMUpo4j1rOeqtO6NFTW1gFYgAjcGLBQOOrKhfn
         uQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731523196; x=1732127996;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WgXDWP6uTO9OvPO11ONSGz0dajsnDJA8Ia+wd76L1pU=;
        b=QUb7CoS9++zfNR39uiQogNQtfbnrCcVIvj3h4E3of930VGsgAJbhKkm6UbF7mUPfMJ
         nQn4Trv+pbP+zukRVk/AG2dHO5YG0OvPKcEQI6J1Ce6ncCiEc0vIXsaNzP6Cw0O740Dr
         oTTu/nZlvpxtIl9sBL/PB5e43wfiP6/t5GnzQKkyy3CyAC4cANha/fTz7f1u/qWVOZj9
         EXzfJGNcrtxVmuo2vuVm6p/HzyHnloRXEpySOzQPen9zww+rjPGJBr3Pa+Y65L6Ww+eS
         eHa+4q2f+zEns+8wZaLbFJodQBu9d90ONBO7LeOo5RV9NvqAuSxyelH58b4iD9dhKl2C
         aikA==
X-Forwarded-Encrypted: i=1; AJvYcCUsTvDpAbXfwlnOyolb4r03l9mNXEfyWdJ6Gjb1XeQmHBlkuj1MdvKeyN5/vDMRlrCdZGUDiCpfQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzroMciWyMAglVOEevpcTduWR673sQS1HrfSZwjXQp/KiXDp9SU
	rM0/Pg+ff6D5lJVHbOjsqWcPZZI1igeac5o5kVzGBpr05A4vPSZnABMjCen6GZ0=
X-Google-Smtp-Source: AGHT+IESBxgtKu/tqS069ieokYdQsF86VTGk5XXSX9JBOM6NYNLoE/FOQHmxs2aJ76kIzJOEXUf+Gw==
X-Received: by 2002:a4a:ec4c:0:b0:5e1:cd24:c19c with SMTP id 006d021491bc7-5ee868b0bf0mr6129208eaf.0.1731523194524;
        Wed, 13 Nov 2024 10:39:54 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5ee4950edfesm3141888eaf.14.2024.11.13.10.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 10:39:54 -0800 (PST)
Message-ID: <ffe1f8e9-5484-43f9-a410-2927d0c63659@kernel.dk>
Date: Wed, 13 Nov 2024 11:39:52 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't reorder requests passed to ->queue_rqs
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
 io-uring@vger.kernel.org
References: <20241113152050.157179-1-hch@lst.de>
 <92954431-349d-4b75-b63f-948b1df9a3fc@acm.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <92954431-349d-4b75-b63f-948b1df9a3fc@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 11:33 AM, Bart Van Assche wrote:
> 
> On 11/13/24 7:20 AM, Christoph Hellwig wrote:
>> currently blk-mq reorders requests when adding them to the plug because
>> the request list can't do efficient tail appends.  When the plug is
>> directly issued using ->queue_rqs that means reordered requests are
>> passed to the driver, which can lead to very bad I/O patterns when
>> not corrected, especially on rotational devices (e.g. NVMe HDD) or
>> when using zone append.
>>
>> This series first adds two easily backportable workarounds to reverse
>> the reording in the virtio_blk and nvme-pci ->queue_rq implementations
>> similar to what the non-queue_rqs path does, and then adds a rq_list
>> type that allows for efficient tail insertions and uses that to fix
>> the reordering for real and then does the same for I/O completions as
>> well.
> 
> Hi Christoph,
> 
> Could something like the patch below replace this patch series? I
> don't have a strong opinion about which approach to select.

I mean it obviously could, but it'd be a terrible way to go as we're now
iterating the full list just to reverse it...

-- 
Jens Axboe

