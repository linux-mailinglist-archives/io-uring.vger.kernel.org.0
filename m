Return-Path: <io-uring+bounces-7565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F420A944BE
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 18:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42BE83A93B5
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 16:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C2A1DEFDC;
	Sat, 19 Apr 2025 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="WAiMhuUR"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A316F7E107
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 16:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745081506; cv=none; b=ZiHBW74fKNvNW/7EV5jNm7GE85s3WiL4zy/ynH9uO6ms4fEcBTQLfmp6CyWy1sTNCsaZ8iFBmaEVc9FKQSH+zZnONmCp5hIANFBZ+n9PK2dXKbbo+lJ9SljnK3MOA9HDBn9imZUEjEyIwt/NhW7OJvcrbJq7N72GLGOMVak5Rz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745081506; c=relaxed/simple;
	bh=rgXFAkJg60nJm1xRpuVDyreIaUtmtXKe6JAhocDBm1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ceMVTbXnEqT4x4mc74QaMnNHnnMPB12l3M4pV/islyKZn+AyxC3BnSv4i80G6nec4PktAxJ9UijUrJYJ3ehOJqJBJRdu9yRTpLAtHg+CEZ7mP12i3i2shi4SM0CG3UXAT1UyZbHqBVtZPK3wf/TIMlqVdPkJWQz/ClgOVzwolBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WAiMhuUR; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=GsxyiLvfufeKEymUtU/qkz6yrjEY7l+ecz/XlspbHYU=;
	b=WAiMhuURAXhVX4e5t0IoDcLthGjN+YzHdvyKFtkqklfELrciehceZtnykJNHBx
	3hIkm8i1PwqODWzpT2gKLwoGSkjp4mYF9Vrb7B6saYzP6GkH7pxYO0u+pxYGBta4
	kh8uS6midTUjxcR+mJLTxPv15QL+Z+0r/0oJW8f9UU12M=
Received: from [192.168.31.211] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3f+uP1ANowOjrBA--.15858S2;
	Sun, 20 Apr 2025 00:51:27 +0800 (CST)
Message-ID: <9c76875c-fab5-4248-ab6b-9a1ac8765fad@163.com>
Date: Sun, 20 Apr 2025 00:51:26 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] zcrx: Get the page size at runtime
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250419133819.7633-1-haiyuewa@163.com>
 <debd0318-2d0c-4e0e-80c0-b47acbf93987@kernel.dk>
From: Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <debd0318-2d0c-4e0e-80c0-b47acbf93987@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3f+uP1ANowOjrBA--.15858S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF1DAF18Xw1xurWkKrWktFb_yoWDGFcE9r
	Zayw4UJa9rWFyDKa17twn5CFWUJasxury2vr45JrWUGw18XFn8Ar4kurWfA3WSg3W5Zrnx
	W39xAa47Kw43ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_Xo2UUUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiYA00a2gDusxdxAABs3

On 2025/4/19 23:12, Jens Axboe wrote:
> On 4/19/25 7:38 AM, Haiyue Wang wrote:
>> Use the API `sysconf()` to query page size at runtime, instead of using
>> hard code number 4096.
> 
> This is v2, no? It's customary to include a "changes since the last
> version" when posting a v2. JFYI.
> 

Got it. Will send v3, fix the tab issue.

>> @@ -329,7 +329,13 @@ static void parse_opts(int argc, char **argv)
>>   
>>   int main(int argc, char **argv)
>>   {
>> -	parse_opts(argc, argv);
>> +	page_size = sysconf(_SC_PAGESIZE);
>> +	if (page_size < 0) {
>> +		perror("sysconf(_SC_PAGESIZE)");
>> +		return 1;
>> +	}
>> +
>> +        parse_opts(argc, argv);
> 
> Whitespace damage here, it's using spaces rather than tabs.
> 
> Outside of that, I think this looks fine. liburing helpers should
> probably have something for this going forward, so every test that uses
> the correct page size (or still hardcodes 4096...) would get it right
> without needing to know about this. But that's beyond the scope of this
> change.
> 


