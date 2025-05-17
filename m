Return-Path: <io-uring+bounces-8040-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0921ABAAB9
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 16:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C9CE169DA6
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52762110E;
	Sat, 17 May 2025 14:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZHRu7SW6"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355564B1E73
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 14:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747492279; cv=none; b=CgJHRyoHS1VvjESxspejCDLzD+eaY/NEprQ//n74SUT9vKu8dO86uU3DzW+jeY0ots1F9YVBCG7SAEgCGBJxYuSgMY/nU1+e3tcXgzunhb1530OMBkxmBJKz92yomu+E/Q/Vqux7v5bbJetKG9oFD2lafwugQV7NY3qpIXWhSdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747492279; c=relaxed/simple;
	bh=/7F66LHjYYQYufuLVbUFBK7UXmv0JOK7z+LhILzHzRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=scZvh7RLI/86E1ZM2wxohiY/bguFVYnjYotpu2AqSBWSo1nxtbrlTy9/DI4OzFVVSUDz92hjRr5DaonXbsLwmYcA/KjQjm2ydswCJuIpye6572/KXfcuE6RiCd04zTJ8w3GKl3WNCrau7s1XG1J4RosAP+y6hT7tmLx2dnyY158=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZHRu7SW6; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=BmCRs0Ws8Ou4M+v90M+ejmQBaZSzXamgBeGrXMeykkw=;
	b=ZHRu7SW643UKZylfzKZJDiJh0dV56BSD0LkJ0iigYqjuialUK6siGTvGhZt3ay
	rkpoUtNU0a8u1jSjRfLdrue2dHHGBW8+BL4DIINgO50PytLnY4BMrS+5Qee36O6j
	EZfe6Pf6VgiqeSohPUT7aMFj+qXMdbLPaytW4LQHpXvGE=
Received: from [192.168.31.211] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3_9msnShouorRCA--.62674S2;
	Sat, 17 May 2025 22:31:09 +0800 (CST)
Message-ID: <e6efc1d8-f317-4475-b33e-0027d4c4d140@163.com>
Date: Sat, 17 May 2025 22:31:07 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] register: Remove old API
 io_uring_register_wait_reg
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250517140725.24052-1-haiyuewa@163.com>
 <80d92472-402b-407c-8e39-ce39b8ef46ed@kernel.dk>
From: Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <80d92472-402b-407c-8e39-ce39b8ef46ed@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3_9msnShouorRCA--.62674S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4iJ3kKDUUUU
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiERFQa2gol9yE8QAAsF



On 2025/5/17 22:20, Jens Axboe wrote:
> On 5/17/25 8:07 AM, Haiyue Wang wrote:
>> The commit b38747291d50 ("queue: break reg wait setup") just left this
>> API definition with always "-EINVAL" result for building test.
>>
>> And new API 'io_uring_submit_and_wait_reg' has been implemented.
> 
> You can't just remove symbols from a previously released
> version of the library...

Cna only remove during the development cycle ?

> 


