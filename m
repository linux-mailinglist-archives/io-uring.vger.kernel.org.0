Return-Path: <io-uring+bounces-6049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E2BA19B94
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 00:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C2BC7A3302
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 23:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572311C5D54;
	Wed, 22 Jan 2025 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="AR5BZ8z1"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-o92.zoho.com (sender4-pp-o92.zoho.com [136.143.188.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8331CAA86
	for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 23:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737589753; cv=pass; b=HTSDho4uWRUqZURLPTyWLbNYINDb1vyUFNln1YHVyJ/lXVok4gnqXdb0BWm4hyfjyAp3qqdnZyVlWs5FDvunwrEgAKXvyMxUZbZTvOj2RTRBH+i2+BMjTtMxxCYV0egp0S5e+5YX+5YYJCGj+f8He7yMEz26L4VtSf6Hsc5HpAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737589753; c=relaxed/simple;
	bh=hIHOR4wEPbIjYyRfhd9CzTnjX9SG2VWVqszu3cmHXKM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=sV9Ba1rTS+WZU4enWY4yVYb7p3euAXPEJGlO9oj2XLrARvWWfmsnUW1VasnULBBQYKmrQ+t6CNzC0jxnOivzAg9weVlRKbqhbHTSCSUxSA1vA0wEMEu5rD77cvVuv8erxs5jdpYIGmqj3pPaN4k3mikXRZ/IaobzRMjQfRorIjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=AR5BZ8z1; arc=pass smtp.client-ip=136.143.188.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
ARC-Seal: i=1; a=rsa-sha256; t=1737589742; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gxMKXqkIsHEEknV7EjfUkuafXqFlWNRW/lhhhxMj6R2/KcDoAbPQCB4K0GeAnL4Tnl1ElIwTMe7VPznl+MP0jFdyVcR7z8nkONfCxI6YRHj/ve3QHQTM98GDxLQbDEVUZaPAtuE9kw80vUA5N6j6+CYBsEA4QkMo1YOvmjrSOUE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1737589742; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=p3WbN5IRrfd3kP8Uu5cz9uSS0JfVUgxChMSLDCXRJ7M=; 
	b=RJgHYipIOQTpDI/WntiZqkHtzSoq0tywLCC+ERfaJJ6s8LpRUoM/kpwZu/wzK1R5DRRbKkAGjwN/6ClxaZ2G5DjanH14WXSO+k6iRXZY702qpwqCzXdZFwcqU/p0LgeYGYhL9iQPxsbvS76bCMveJ4uiiKX2odnO0PhjEkIsDQA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1737589742;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=p3WbN5IRrfd3kP8Uu5cz9uSS0JfVUgxChMSLDCXRJ7M=;
	b=AR5BZ8z1UphOdZ1BMQHRfMcIYmqEVhMrM/DdG/fZb5cAleR54Oy5rfwQRGdRcotA
	iKutMiF6jlVQJwg2HDmgL1ntfXkfjztsPr8HXBUQ8efhVfToaapv1Wn0SB1rVGbjuPZ
	1UfL+ZvpCzt2elq0DFZegSu9IId5VFwQPrSnyP2s=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1737589740136605.3768365859215; Wed, 22 Jan 2025 15:49:00 -0800 (PST)
Received: from  [212.73.77.104] by mail.zoho.com
	with HTTP;Wed, 22 Jan 2025 15:49:00 -0800 (PST)
Date: Thu, 23 Jan 2025 03:49:00 +0400
From: Askar Safin <safinaskar@zohomail.com>
To: "Pavel Begunkov" <asml.silence@gmail.com>
Cc: "axboe" <axboe@kernel.dk>, "io-uring" <io-uring@vger.kernel.org>,
	"josh" <josh@joshtriplett.org>, "krisman" <krisman@suse.de>
Message-ID: <194906b5253.5821bf1b68241.219025268281574714@zohomail.com>
In-Reply-To: <9ee30fc7-0329-4a69-b686-3131ce323c97@gmail.com>
References: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
 <20250118223309.3930747-1-safinaskar@zohomail.com> <9ee30fc7-0329-4a69-b686-3131ce323c97@gmail.com>
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Feedback-ID: rr08011227d7198118d3b61aaff4581d3c00002b504eb4256f7106062b0464955ea923ceb72e6dbae890b202:zu080112273e0291ad7fa37af88b01a2e5000041fbeeab45651520c5eed5be6a32031bb983257e69c6d920e2:rf0801122b6e851eb3610e80bb869dbd980000ad6bde1873243b2a340baaa8364da760e43dee41fe9044ac8775c988fd:ZohoMail

 ---- On Sun, 19 Jan 2025 07:03:51 +0400  Pavel Begunkov  wrote --- 
 > I also wonder, if copying the page table is a performance problem, why
 > CLONE_VM + exec is not an option?

Do you mean CLONE_VFORK? Anyway, CLONE_VM surprisingly turns out
to be a good solution. So thank you!

There is a bug in libc or in Linux: https://sourceware.org/bugzilla/show_bug.cgi?id=32565 .

I suspect this is actually a Linux bug.

After receiving your letter I decided to try CLONE_VM. And it works!
There is no bug in CLONE_VM version! You can see more details here:
https://www.openwall.com/lists/musl/2025/01/22/1

--
Askar Safin
https://types.pl/@safinaskar


