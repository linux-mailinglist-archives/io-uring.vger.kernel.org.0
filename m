Return-Path: <io-uring+bounces-8003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B356ABA1C2
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 19:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01946188AE50
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 17:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C56A31;
	Fri, 16 May 2025 17:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FXjRHd8o"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C601D5174
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747415752; cv=none; b=QmY2odTnWXHEUvuR/ffWeFWFXRX8MdTExjinT8lbC8sXx7QykgOwowuFYdRRv0KoKRnzomQkcKrQRorNp0n+JKiX+0nm4XWarbv2aaUDIqaGpSmWZRWoDDp3qvrDkXMsm93x+NBqLXWV1E2EZStf4vHjVlYhyATc3vrC6AwJCR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747415752; c=relaxed/simple;
	bh=M6V1jV+g9SqfaZEcCjgdimRw9kqkqkiU4kIHIwizReM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sgLhcY2n2zwjJ5UCt3LCUFtfuBFkPl4UCO8G+Wgf2ypMsuo76VP2wKxT3DRCFJkraws5SikWQQt0hgp+8yN4t9KUVkHoj3VZToe9SgOz0m3ca3QgTLUTaEI3Leb6lLo8nIgjWMdAGGsofDLd0TXRBuLLXhYXprQHjaXoNJIWz+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FXjRHd8o; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=Wm9FQu/ttTmV7Y01VNMky5fMxig3RI+DVbM+I+XZLHQ=;
	b=FXjRHd8o78tKrubuUXmQEjuoqeMZoyNSOYlMP5gQCN9lYivTi/DO6KG0mhT9Zl
	fZ5StKeye8UBYGKPDKyYi2nZPiVrWQxo/0JZRrNaixYjh56Yx9OZyapIXe2AM1gg
	c9DytrurP7Et1D7ibkNGBKNUqHriN1U65zdozog5d3bIs=
Received: from [192.168.31.211] (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgCXJm+Vcido7cCyAw--.4336S2;
	Sat, 17 May 2025 01:15:02 +0800 (CST)
Message-ID: <9eec6ea3-369f-408d-8eef-6788ad1d380f@163.com>
Date: Sat, 17 May 2025 01:15:00 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2] register: Remove deprecated
 io_uring_cqwait_reg_arg
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250516091040.32374-1-haiyuewa@163.com>
 <c5f3ce6e-271e-43fd-9628-0a1a858a628c@kernel.dk>
From: Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <c5f3ce6e-271e-43fd-9628-0a1a858a628c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PygvCgCXJm+Vcido7cCyAw--.4336S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4ifHUBDUUUU
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiEQBPa2gna4mweQAAsR



On 2025/5/16 22:04, Jens Axboe wrote:
> On 5/16/25 3:09 AM, Haiyue Wang wrote:
>> The opcode IORING_REGISTER_CQWAIT_REG and its argument io_uring_cqwait_reg_arg
>> have been removed by [1] and [2].
>>
>> And a more generic opcode IORING_REGISTER_MEM_REGION has been introduced by [3]
>> since Linux 6.13.
> 
> It's a shame to remove this (though of course it needs to go) and not
> add the MEM_REGION replacement instead. Any interest in adding those
> parts?

Try to figure out the structure relationship in v3.

> 


