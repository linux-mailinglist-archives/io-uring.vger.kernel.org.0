Return-Path: <io-uring+bounces-13381-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNVHAZvZCmrb8gQAu9opvQ
	(envelope-from <io-uring+bounces-13381-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:19:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9434E56989A
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 434333028C92
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 09:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B5A3E3170;
	Mon, 18 May 2026 09:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJ3LMwfL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D1C3E3C7A
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 09:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779095591; cv=none; b=Kqt6Do3dEI7d1NElQPQcurzIILDp6QirNlOKmqLndR6diBQa68lHcy+jfRWsjJPUz1Wst8+FBYeDKDgeU1Jj/MK29oX2h5bE1aVul7N1MjypOtyxHTCuoSEXz5PzV5sr/QaY5cTwP6Ia/JBOmMbqTU2b7j3iVV7EriabhIXmk0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779095591; c=relaxed/simple;
	bh=/W8E/uJT+njUZo+KbiayviEW8GF8DDjlc2Y8J9q3llA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KD/G3OIr7IOKt30vml9zyKhMt1ncGbAyYkFxtBCevaWjRaKkYXpuT6IbmaSK0BZrFEx2cQztKTNNifeV9/vORz66t5YJPfkzS3ud833JBo4vEP8NeIIZUzYqbCxrNvFDUQjis2MXUev5SuvDTs9n2g6NmGUAsjqUsA2+9oWeJcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJ3LMwfL; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488b0046078so17753305e9.1
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 02:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779095589; x=1779700389; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xG/69Jp5I3ufceWw4+S4Fo/It8aPbBbD9UGvG/3mKFY=;
        b=kJ3LMwfLwL6XVhhLsb1SGnpdIPkgtdx7c5aCOor9MszrVAOgWkZm3xdjWk+SpwPfO5
         M/f7UB8N7uLp1FYlYsum4j7R/boSI6kOkz0g547XeuJZEqnLF2xmz+oQKkBskRA11eoT
         0i7v6bXvmtOlabA2zcuSEFMODHUEvUQs0r/uENdTaKIeidz04Ye5OAkkPdPUaTdgNW4e
         9+JbALJQwZ4woVn+OsXerhiZ8NxPOChI2tTDcQt7KzLAV4Hd6Gj7NYdS+Ey6XU0bR5rQ
         0aXZ+PR/hgj/TxCFJKgGKhd0HjllXlzojeNw/N3haemcGtEo8vQNQmyp/Dc6DFv7rDqv
         4Geg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779095589; x=1779700389;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xG/69Jp5I3ufceWw4+S4Fo/It8aPbBbD9UGvG/3mKFY=;
        b=Cko4tSAptbt2XoIWrbraK46nABtwAkyG+m3lPQEi/d6i7PmBupZFQKQeaHKPfHp6ku
         0sd8df5PrQhs7a9UUiFPPV7P5G6fDM4VtK8xzxj9C+a9vCAYLclfBPeZcDVvTLBuThOG
         Pmyhv2IEhlLfSU4UquYLcBkAaB7vlBQYMh+Eh95RmKAyFxGtt6sBbXJerbVharByA1Al
         Coi7pA7XekGl8E8w+ek+IytiUaHBFDPjuq9GpbsRktwlfHbbPC4FGfKe1EsiqEkKlLq4
         m3CI9OdM3rri/J2dmz4HwINqNkR/rhS7nbmtdgYhCU2qSwLcHcJh2lFKHtPUjpMPQitw
         vkAA==
X-Forwarded-Encrypted: i=1; AFNElJ8AhW8LL/h207SScllF1WGYDaPHo1bYwxd9JKOwGZ7D+mKd0RwM0hi5d40ZmIcQ8ztBB/YnEzGwrw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw23ptF+XC6jWKXowsUdUnNje1h6xZzaXbySUI1hWly+Aml4CA5
	ADbXn4NQRPRmFBmx+x/0LPeaA+EbjSiLOKTDU1wlo1FTfhcyJ54lcS/G
X-Gm-Gg: Acq92OHe5VxJqCRh6TRqv1GsOrXDiRhF11K+09lpYzsg3FuFHSqi9FmCcyS5jgB14V5
	ZyndfRq6kbTdKFJbnvWr5EP0+0loPpPPNSUUApZlupYgSuJyOWqSnw4ssna5KuD25ctrzK6rhgS
	soS0/02AfAXMnl7t2Yxvwv53IsQ2MRnjq4xaco94cFVgB8rVlCLCTS47dDYDB/cILkpEZ53hQZZ
	iNUDhgz7G/3Z8g9AB1BnyD59H0zNSKaj75OoxOzETOJ4bt3encBSNKGeNvbGEOdXNHSGYFEgGCL
	aW/oMqaDiBj47pYIfOdOfMjdQEklZuOWdNQJNOyKAipGfg4n1ZW2QYigxUu5nrxOLAa0ZnxkIo8
	wAWT+r6kJSx46EPn79We9WjUgY5RNz+oxm0F2Gf16IR4/Ot/cAA8Q00ef1hlQkXYCBs+Kwf2qAi
	yb2sKUKg89MUfJaS+bOpSbjIU4MXrOzH4+Pz8WHFyISNRfa4z6tMYEpFIETgdMy23s2P5GVay63
	Dt+KFdiO22WjvSX+sCbC97cPRfqOsjkJItd30D+IfUq5PhRkczyNFDjELI=
X-Received: by 2002:a05:600c:1d0d:b0:489:1ff1:74df with SMTP id 5b1f17b1804b1-48fe5fcdf50mr205316035e9.1.1779095588623;
        Mon, 18 May 2026 02:13:08 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:6e9b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe13a7sm36837416f8f.29.2026.05.18.02.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 02:13:07 -0700 (PDT)
Message-ID: <88576019-44fc-4614-9e89-a17478dbf340@gmail.com>
Date: Mon, 18 May 2026 10:13:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/10] block: forward create_dmabuf_token to drivers
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <559756c5e22dcfa183080a979de039910d1b896d.1777475843.git.asml.silence@gmail.com>
 <20260513082553.GB6461@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260513082553.GB6461@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9434E56989A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13381-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/13/26 09:25, Christoph Hellwig wrote:
> On Wed, Apr 29, 2026 at 04:25:52PM +0100, Pavel Begunkov wrote:
>> Add a trivial implementation of the create_dmabuf_token call for
>> block devices that forwards the call to a new blk-mq callback if it's
>> available.
> 
> This should go into block_device_operations as there is nothing blk-mq
> specific about this.  I.e. even if this patchset doesn't handle stacking
> drivers yet, it should be easy enough to add them in the future.

Ok

-- 
Pavel Begunkov


