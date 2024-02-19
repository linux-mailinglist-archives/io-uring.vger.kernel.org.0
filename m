Return-Path: <io-uring+bounces-623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC17859CBA
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 08:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1FF91C20C2D
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 07:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CBCB65A;
	Mon, 19 Feb 2024 07:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fyUkx5KR"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF484653
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 07:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708327328; cv=none; b=km/sdlcjFVIVIdFaMrHrJc/RIRVDvxUaU/8WX9sK5PZ0O4oIxHOSSW2K569suaBW0W+dphpyJ0X2IFZUWi565y8LH9dAEYip9dGHW7zH4g9amWTvPFfwPuj58CyCFZ8mwGDKwZVpg8a2d4LKxECLaD6Nxf3tYZ3jegWA4kW7W6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708327328; c=relaxed/simple;
	bh=z5gEp1g+Cx86Qj4hb2iV/fY7GbbVaIldH4c4QsjgZLg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=V0JmJwdPzXIfcabju+Xtf82MPLp4Oe6+EZrCWWMElPonZsGIui2oPHSOnbZUFuoHrkGptE3spdDmgpVzOIRjqNxUfScdJlEdGrRTga1N95T1rQfAHb9vyyeem7TyAotgafVFrHGUwW9OKPdGGNx2G78qau76XqSt1rDze35KYnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fyUkx5KR; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240219072202epoutp0249a0fd1e53dfd9219e52c50e305fd188~1MqYDUahP2990729907epoutp02A
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 07:22:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240219072202epoutp0249a0fd1e53dfd9219e52c50e305fd188~1MqYDUahP2990729907epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1708327322;
	bh=t26mQRhskGWreQ+iBAEauW8i+bpFYE4AzVGSadA654I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyUkx5KRH8DAdigMCft6bN5zXONj8YwzDBQyAEv37ZtqitMiF4V/11YcHFJFJFkX2
	 gZBnf6CC1xyjgOorLr8HXHjSf2g1W5oEQQejfs/hCU1HvJIOLpsYoIbWppI/mk9yRj
	 Zw8oej/RosobbUZj/56B4EbCSP+t+JKfNsGJ+2kY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240219072201epcas5p41fbb970f2902d04565d8dbe3888cdb98~1MqXSaSGS1847418474epcas5p4W;
	Mon, 19 Feb 2024 07:22:01 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TdYrR6rp0z4x9Pw; Mon, 19 Feb
	2024 07:21:59 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A5.80.10009.79103D56; Mon, 19 Feb 2024 16:21:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240219031238epcas5p3aa330855093314a2c5768cf83971599c~1JQnjg2i31795817958epcas5p32;
	Mon, 19 Feb 2024 03:12:38 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240219031238epsmtrp25ad73a7782742174d219c1a1ae1d2925~1JQnisthy1454914549epsmtrp2W;
	Mon, 19 Feb 2024 03:12:38 +0000 (GMT)
X-AuditID: b6c32a4a-261fd70000002719-92-65d30197bd09
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EA.6A.08817.527C2D56; Mon, 19 Feb 2024 12:12:37 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240219031236epsmtip193194b00f806aa26e158495b77512ae7~1JQmQ4xjl2613326133epsmtip1T;
	Mon, 19 Feb 2024 03:12:36 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH] liburing: add script for statistics sqpoll running
 time.
Date: Mon, 19 Feb 2024 11:12:32 +0800
Message-Id: <20240219031232.203025-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <522c03d9-a8ba-459d-9f7c-dfbf461dcf6b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmuu50xsupBi1fTCzmrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFmcnfGC1mLplB5NFR8tlRgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM3Z0rWQq+CBS8XXaIcYGxj0CXYwcHBICJhJznkV1MXJx
	CAnsZpQ4er2BCcL5xCjx7dAnKOcbo8SZyY1sXYycYB1Htk9ihEjsZZTYd/YYE0hCSOAXo0RP
	VyKIzSagLXF9XRcriC0iICyxv6OVBaSBWeAvo8SEl7+ZQRLCAsESjQcXgjWzCKhKLNzbww5i
	8wrYSvT/X84CsU1eYv/Bs8wgt3ICxecvM4EoEZQ4OfMJWAkzUEnz1tnMIPMlBBo5JNr2/2GF
	6HWReHvzBSOELSzx6vgWdghbSuLzu71Q3xRLHOn5zgrR3MAoMf32Vagia4l/V/awgCxmFtCU
	WL9LHyIsKzH11DomiMV8Er2/nzBBxHkldsyDsVUlVl96CHW/tMTrht9QcQ+J6yfesUFCbgKj
	xKH2VywTGBVmIXloFpKHZiGsXsDIvIpRMrWgODc9tdi0wCgvtRwey8n5uZsYwYlVy2sH48MH
	H/QOMTJxMB5ilOBgVhLhdW+6kCrEm5JYWZValB9fVJqTWnyI0RQY4BOZpUST84GpPa8k3tDE
	0sDEzMzMxNLYzFBJnPd169wUIYH0xJLU7NTUgtQimD4mDk6pBqa21YwzYmRzZ71cHlRUMvt9
	v86hOQ7W5RN/p+epxJ85M+fE/z17tiZd+771XRari1qlr9+7OSs02qKO2O1Yci9W64OO8Yr9
	7Mkvu9M8jPfdkw1eveH3ym/xc88W3S5I3suaJOCc9XBmbsua6e4edfIOf7pKlqwNze82lL/w
	8XN7QJby0z9+Nk9nV/yxzTHaK7mcUSJjxbLecxse8vXl/xIV7vi96+3VW7fCTogzzQz6XNz0
	XuTrG9vgrTGfi9U+65+JPc1RbFOi0rDhaVAYd+uCC85XP9tsfB19xNDg+c+sh95/Ouz+nloc
	4+Dxtvqr59nu/7luplXS6St/LlHbpmCrq3wn9LsEyxOZL8YVO7YrsRRnJBpqMRcVJwIA9Yds
	KDUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSnK7q8UupBu/XmFvMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorhsUlJzMstSi/TtErgydnStZCr4IFLxddohxgbGPQJd
	jJwcEgImEke2T2LsYuTiEBLYzShxYPkuti5GDqCEtMSfP+UQNcISK/89Z4eo+cEosf3vCXaQ
	BJuAtsT1dV2sILYIUNH+jlYWEJtZoJNJ4vVnPRBbWCBQ4sarHrA4i4CqxMK9PWC9vAK2Ev3/
	l7NALJCX2H/wLDPIXk6g+PxlJiCmkICNxKTGAohqQYmTM59ATZeXaN46m3kCo8AsJKlZSFIL
	GJlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEB72W1g7GPas+6B1iZOJgPMQowcGs
	JMLr3nQhVYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvt9e9KUIC6YklqdmpqQWpRTBZJg5OqQam
	7Jw6MaVrp+9Vnu9kSr7R9HTJLJv2fWrhYk42eQEfHpxmF96l2NP08eOWt686Zk15Wf7sd+Y9
	pSsP1c003j5c9MP7wEz+c+s8r8Xamvy4FxK16pldurdGR0rt30V2DpcnM64/X+838+yLp2fm
	Lyp6F757Ovv/ZV+FHOp47leripekNidaHnlfwbp4msKWzlAXp5uWYk6Tk7jevZRy2f5Le00U
	b9QBk92hW9ZlbDOJajtnEruE5fiV39N2JGzckaYk97Uk+KGTd/WN7QoTon127Vp6/cu1C4/f
	1B7LVMtfo/FuQ9uz5MuNvsbZqU0SniI+D8PNj0ht/Pr9u8OS7Gs5m+e3vmx+tPiw2fdK9c9L
	opRYijMSDbWYi4oTAW+dnGPpAgAA
X-CMS-MailID: 20240219031238epcas5p3aa330855093314a2c5768cf83971599c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240219031238epcas5p3aa330855093314a2c5768cf83971599c
References: <522c03d9-a8ba-459d-9f7c-dfbf461dcf6b@kernel.dk>
	<CGME20240219031238epcas5p3aa330855093314a2c5768cf83971599c@epcas5p3.samsung.com>

On 2/18/24 06:00 AM, Jens Axboe wrote:
>And since your Signed-off-by is here, it also does not go into the
>commit message, which it must.
>
>> index 976e9500f651..18c6f4aa4a48 100644
>> --- a/io_uring/fdinfo.c
>> +++ b/io_uring/fdinfo.c
>> @@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>  	unsigned int sq_shift = 0;
>>  	unsigned int sq_entries, cq_entries;
>>  	int sq_pid = -1, sq_cpu = -1;
>> +	u64 sq_total_time = 0, sq_work_time = 0;
>>  	bool has_lock;
>>  	unsigned int i;
>>  
>> @@ -147,10 +148,17 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>>  
>>  		sq_pid = sq->task_pid;
>>  		sq_cpu = sq->sq_cpu;
>> +		struct rusage r;
>
>Here, and in one other spot, you're mixing variable declarations and
>code. Don't do that, they need to be top of that scope and before any
>code.
>
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index 65b5dbe3c850..9155fc0b5eee 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -251,6 +251,9 @@ static int io_sq_thread(void *data)
>>  		}
>>  
>>  		cap_entries = !list_is_singular(&sqd->ctx_list);
>> +		struct rusage start, end;
>> +
>> +		getrusage(current, RUSAGE_SELF, &start);
>
>Ditto, move the variables to the top of the scope.
>
>>  		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>>  			int ret = __io_sq_thread(ctx, cap_entries);
>>  
>> @@ -260,6 +263,11 @@ static int io_sq_thread(void *data)
>>  		if (io_run_task_work())
>>  			sqt_spin = true;
>>  
>> +		getrusage(current, RUSAGE_SELF, &end);
>> +		if (sqt_spin == true)
>> +			sqd->work_time += (end.ru_stime.tv_sec - start.ru_stime.tv_sec) *
>> +					1000000 + (end.ru_stime.tv_usec - start.ru_stime.tv_usec);
>> +
>
>and this should go in a helper instead. It's trivial code, but the way
>too long lines makes it hard to read. Compare the above to eg:
>
>static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
>{
>       struct rusage end;
>
>       getrusage(current, RUSAGE_SELF, &end);
>       end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
>       end_ru_stime.tv_usec -= start->ru_stime.tv_usec;
>
>       sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
>}
>
>which is so much nicer to look at.
>
>We're already doing an sqt_spin == true check right below, here:
>
>>  		if (sqt_spin || !time_after(jiffies, timeout)) {
>>  			if (sqt_spin)
>>  				timeout = jiffies + sqd->sq_thread_idle;
>
>why not just put io_sq_update_worktime(sqd, &start); inside this check?
>
 
ok, I got it, I will send out a v9.

--
Xiaobing Li

