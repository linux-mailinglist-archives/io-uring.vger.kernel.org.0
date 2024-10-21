Return-Path: <io-uring+bounces-3859-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C239A6EFF
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72706283F49
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEBA5137750;
	Mon, 21 Oct 2024 16:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3X+JzZF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68AE17C224;
	Mon, 21 Oct 2024 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729526599; cv=none; b=hiMHDnic/P/0PDPZJt/11T7rx/fjvuCM0Cls49XqgMnoQOHXzcoYggYRIGy9KYAJaUeQpG1wfswvb78/wyUFvidCSGexheXtuk277vomY76qwQBgib/UeTDx62PzocJ106GDflSZnGgEs5F4i/XNHIAA1uAJ5pQCy0tThPkm3xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729526599; c=relaxed/simple;
	bh=FGr4Qsj06zUzUHVuKLNhO1H5bImxOCmYQAFVuLxT+2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYIbr0j+7PtyvwNa0qV6lA5eawV8iva6LIlPOWjlMgX3+9+EZAEhz9cXWescq73a6skR+AjUp/sWiMRyV3Fsv3d88N/I2Ehd8o+dOfScWKW26POejLgrZ5HCqd/LOHwp8DVSsllCtM3yG5XxYGkKVN/6AK/RZ+W5r0YikJ3UTAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3X+JzZF; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539e8607c2aso4987724e87.3;
        Mon, 21 Oct 2024 09:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729526596; x=1730131396; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z4G33DRMtPm23BbC189biiKlGJhxd9tSyy0FqMwL+Fc=;
        b=L3X+JzZF9aXlhZRp6Nt//JaU384VFvfh0MtUiVFh1elQCXbvGJmIfcyiYp4e5QrkQ/
         OmRlhlUlzuQgS0dCOEdAsSrWJSCYE+f0SXKACyp0vr9OwbnN4IIxupY974VnBTLrlOi/
         yAaRv7n0/6leN5Hqs4Uj1vYxOT8GXKtUbUj4bRKDLo8+EUe2Qt+d1+ABnJjWs3hMQ2oa
         aS8I0IckAGrjllNL0K9vwRZK92CAbNdgERd+ZWo6QEkpWAin/tPBls0dcMNpUAGj6jMw
         BbvoA3geQ2yv0DvzNbodYJaF7I2KXsQJLbVKavIyDE1mPuYWJLiEU0bE7hYxoNU4Ryh8
         J0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729526596; x=1730131396;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z4G33DRMtPm23BbC189biiKlGJhxd9tSyy0FqMwL+Fc=;
        b=TW32mGINohaQcBqpcQ0FiZCVb3YSrcebKTHioJ93Cq3wP5eIQ6Bv5Hfb7Evfu62RDC
         BxK6TfhIAgBCI05sQEPgoKPPp4sZeLlOUTyy/uZYNfguLda819BaCEFFU/Nn/OUaw4qW
         RdyKRsJApk7y8E1L2odvkkbD9+6epL16zCEKBOYJH2I5lRdTfaaMjjh6LQynTniPH0dM
         Do4eQiSNXklQ2bswoNv/p/7Xgaqd+Xuy9ZTD/3N8ZpIvFFDvXlua19IrMrFBktu09le1
         aWxUV2v1uwfcacgpkctYSzsWbTBJLu0vOXkGSSyp8GWPpaf+BiTe0pHYmqraJOs1IQOp
         WKPA==
X-Forwarded-Encrypted: i=1; AJvYcCUBS/gDHhkxFl3hiTMZvUNUibbCS1qT/I3qnprKJ7n1U9ZfwWzvITjDBkI+5z1oly0/RKkngsA0lA==@vger.kernel.org, AJvYcCVgpyvIbCLus1kZUSN/msGxRJip/iy0m6BFEfmLMsEqU1k4LB7Fr+Cr2lCO76vbS08Io3OMXuMKMSzQ5Z8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0BTUOoCkFxKrWV1+jAgoIeix2+pS6NOHpj3iKFN7t6OowzefV
	isAJfTmNMC5+sDth9aQuhXZCoPFbiPMcQwbGe7hiv7nc+99QLSkH
X-Google-Smtp-Source: AGHT+IFoQoQoEaud+eLTStEY9OPyvLF0VdXmN7ecMR/CgXdkr/3qTpxTs+6uQ/4yCk25IMLxxyA4QA==
X-Received: by 2002:a05:6512:2813:b0:533:44e7:1b2a with SMTP id 2adb3069b0e04-53a154b2d95mr5538344e87.40.1729526595551;
        Mon, 21 Oct 2024 09:03:15 -0700 (PDT)
Received: from [192.168.42.158] ([185.69.144.55])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316f580069sm61177885e9.14.2024.10.21.09.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:03:14 -0700 (PDT)
Message-ID: <106bc650-a79f-4408-b096-76d49a495195@gmail.com>
Date: Mon, 21 Oct 2024 17:04:00 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] nvme: use helpers to access io_uring cmd space
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
References: <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
 <b82b36c3-5ab5-4e99-941b-b099020d1b36@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b82b36c3-5ab5-4e99-941b-b099020d1b36@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/19/24 01:44, Chaitanya Kulkarni wrote:
> + (linux-nvme)

My bad, lost CC nvme. Thanks for review


> On 10/18/24 09:16, Pavel Begunkov wrote:
>> Command implementations shouldn't be directly looking into io_uring_cmd
>> to carve free space. Use an io_uring helper, which will also do build
>> time size sanitisation.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

