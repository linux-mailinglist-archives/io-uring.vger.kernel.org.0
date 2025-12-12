Return-Path: <io-uring+bounces-11015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 138B7CB77FA
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 02:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E199301AF55
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 01:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DC8221FD0;
	Fri, 12 Dec 2025 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIe0zEWO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B952127055F
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 01:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765501324; cv=none; b=kuu+Cf2yEuW4LNaaXSV88urF3/Z5wm0Dr3oKihus6tFBxWL1EAd/j77Ep0vBDs5EInot02OrEus4/KdjsRK8eqbpRe7+LyMSoyF2diGl4zg23elOVfFfr9edpfUHjiwp4D6irqxtM38jqPtgpbbJXB4mxN8AdEwH7da+81/Fpj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765501324; c=relaxed/simple;
	bh=yjTz9N1XnY76DvE5bcGPlvLqbXen/pl4og5ZynCkays=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYTz46brIa4AO6HGLPqXrvgaG8J+aFpsECQyzsGDUmuGV6XefoJDCOMjaTQT4NZXDzu2axmNmDk7CwNMRASAB9+qq8xTk7TDl2X2BCq/mPy426BST4kJ65xZS95DuWNmUzZOJ+dvKS/VtKR8TRioVqQX6Unqa6zV3K2YT3yCsMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIe0zEWO; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso825267b3a.0
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 17:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765501320; x=1766106120; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PiqT1y0DQKTCKplE+X4RtztJVQKRqPD52kbRIZIB4Kc=;
        b=mIe0zEWOhKI4U9y7ZGHmoHnn9HlPYwG1u3dzSpG27lFusenPgMQaop0WsHh82S9K32
         ibTUsc7Tqo0HBmmHetIvsFh8C4moGVobhEDzFgXL+e+qJ7UGnCaHPQQkZw3NHSZGeKOt
         OdqkbWC4mq3AMmTu+1ZmEutP3AWH1qYgGOGhS/gcEc+RGtMbDegyLHkZbq5GGcsCNI6d
         Q+DUai5SxF5/eKeIGhwbRZlFy0M1YFSYBIGEdvDbQogDgD+qbQEvlJRcNnzUDezwAdc7
         1le/zBt2FNQey8IoPMHjkRXwEkgjmY2tpMppumGngsaHpEqwxU5yKjE/EPdOYqO0Wt4e
         icbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765501320; x=1766106120;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PiqT1y0DQKTCKplE+X4RtztJVQKRqPD52kbRIZIB4Kc=;
        b=gAjNifFQgTyLQgXrVXQW4NFtRAwh3pJIb1WggdvtY+g5E/oVu2lgaoJDY/zty9k681
         LPbHXF78UWLetMwjzBOsGnUvbnNb47mF+GXIZV3cQQd3hVMHAKKUHDgGMeuqxzWAYyNd
         gxhKIjxq/0e7LfopHa+SXqYMiS23wJL4GQ+4AUlklx4mA73BFo1eSqly1ag/tIuZkYdW
         LS5eIbT3xOpQYqXHnU80jDkiRxAcgXtwe5O7SEFb5M+TXL6rtB8JDFpbxFrNfyb6zdAy
         50++YCNz+lKtvRA6Rx1K2hGOAfUXHIiM97E56nBKCdhbWv6TdqO9wmcO5rE8u8+KLTuA
         uH7g==
X-Forwarded-Encrypted: i=1; AJvYcCXGOA1vHuAKWmG3FZpB8dmEPHyJyfQyTPhc6E3dWxtuCfWi9wvIYTBwQuW2Ei5kCxnXk/1zL9Mjqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6AsCjUckJt7ugNJAQuliKOg1uBlByLGc1QlIY7xKSJ0l4748G
	hHTLopGQHXcXVPxaWWM8ki3EuS3NXxFohRLp9IpNdYSHrefuyLJ8HaD1
X-Gm-Gg: AY/fxX4PfG7nqQgO8mRtlexel91pEjsFd46zkvtCL4p6uNRlhDCPVBvXc/ysBDPxVYf
	OwTOL+LQebO+cgz+GbvUJjOMA3FEuhpOUjAvy4Ckc8WoLQXSLQhTL5K49tcifCTqEVq+5ZnY8M9
	fgCSNyjkisyPMfv+SsmLq3DcbnBqvzWBgKRYI4Bo68v5pZ/GB0ZLaIic4q4MuxTiWLZFf6yNsGh
	oyJcaV3vv448mKuneypxmb+3ScoszMuZEPgJ5VudXn1ZipixrPFz0szEz7VwNitXK8dwL4ar4f0
	kbJriYtnewopJomFLk3PJTKj0gAa4PgBC9X91JLSjxLC8KTJqVOmbtNt/3T8e30qBhDt5dQ6wLC
	za4onc5QUlYAGD+ULQE6owJ30iP9va24I4r8BjIMt07ExIqKHbPVU9sosP6PDlhD6IaTYcp7q/+
	wAnTnyHN846NhuXuEUxa+VjBYHaBpnCBr5D4yqLBgqqXutkT2Qyc9wOs+cWKKn49SAwCgjrbivv
	40QA9yYk3QOftbbuA+Otye9h74DHS+P+hfyekDo0OFZnhHAAypfMVVzyafCzA==
X-Google-Smtp-Source: AGHT+IG0+NAokoVmG4o76ltchxh72cgR5S6czK8w8NPqiA4lCkRSaBrc+e6H5PWtVLyiGmX8KUNYIA==
X-Received: by 2002:a05:6a20:1584:b0:35d:7f7:4aac with SMTP id adf61e73a8af0-369afa01e9emr370191637.47.1765501320420;
        Thu, 11 Dec 2025 17:02:00 -0800 (PST)
Received: from [10.200.8.97] (fs98a57d9c.tkyc007.ap.nuro.jp. [152.165.125.156])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2b9d8a2bsm3358325a12.27.2025.12.11.17.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 17:01:59 -0800 (PST)
Message-ID: <fb1abb05-ac8a-4130-a6a9-1a1089df441d@gmail.com>
Date: Fri, 12 Dec 2025 01:02:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
 <aTFllxgsNCzGdzKB@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aTFllxgsNCzGdzKB@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 10:42, Christoph Hellwig wrote:
> On Sun, Nov 23, 2025 at 10:51:21PM +0000, Pavel Begunkov wrote:
>> +static inline struct dma_token *
>> +dma_token_create(struct file *file, struct dma_token_params *params)
>> +{
>> +	struct dma_token *res;
>> +
>> +	if (!file->f_op->dma_map)
>> +		return ERR_PTR(-EOPNOTSUPP);
>> +	res = file->f_op->dma_map(file, params);
> 
> Calling the file operation ->dmap_map feels really misleading.

agreed

> create_token as in the function name is already much better, but
> it really is not just dma, but dmabuf related, and that should really
> be encoded in the name.
> 
> Also why not pass the dmabuf and direction directly instead of wrapping
> it in the odd params struct making the whole thing hard to follow?

I added it after I forgot about the direction and had to plumb
it through all the layers. In a draft of v3 I had I already
removed it as dmabuf is passed with the token to drivers.

-- 
Pavel Begunkov


