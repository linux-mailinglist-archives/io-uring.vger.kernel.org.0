Return-Path: <io-uring+bounces-422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B92C831170
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 03:34:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FE73B25459
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 02:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBDC8F40;
	Thu, 18 Jan 2024 02:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PVvoeYUS"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D368BF6
	for <io-uring@vger.kernel.org>; Thu, 18 Jan 2024 02:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705545242; cv=none; b=kmMq6GkuCW+zqSC9WgDK5rMX/Kz+x/PJHqdlAeSJ3eTlN9HQjDbQOJnEL12ORIfoMewF2VXkhAT3jRrSIp0iNk4E5cVoZ6FAs1m6cmBjyvDHS4pDvdNoUP0mrcZD95AOCh+xQ1bw2AiSyQCVjERSrGZSHRoIfV5kXo+ifNguowY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705545242; c=relaxed/simple;
	bh=DQfoLNWaA63ZoCrCqffGiOmeHADirwGYGc3fxuPM4qk=;
	h=Received:DKIM-Filter:DKIM-Signature:Received:Received:Received:
	 Received:Received:X-AuditID:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:MIME-Version:
	 Content-Transfer-Encoding:X-Brightmail-Tracker:
	 X-Brightmail-Tracker:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:DLP-Filter:X-CFilter-Loop:
	 X-CMS-RootMailID:References; b=DvxiltLc4iuhaOvob+08SOCyeh53Cdqpzo7+6v4FaTveHVQCTPweR0iW7QTQPdwO2qDcKv4CQznkqJvcLED7QxR+X+jkOQULg2EGK60H5OVPO1fsaAMV0o+sih2ySWhNMGpCRlEuEwC1zTdYQ3VweaZRyMqbxAp1/QcT5BVjBvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PVvoeYUS; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240118023357epoutp0256f2ba31bb41be147ed08fb1262ee7ed~rUFt3WIlt2347723477epoutp02m
	for <io-uring@vger.kernel.org>; Thu, 18 Jan 2024 02:33:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240118023357epoutp0256f2ba31bb41be147ed08fb1262ee7ed~rUFt3WIlt2347723477epoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705545237;
	bh=DQfoLNWaA63ZoCrCqffGiOmeHADirwGYGc3fxuPM4qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVvoeYUSzCjG6MNHGst86mAWSVKUE64P7QATDxrXHL9GNq8SHYpgn3GO2BVYAuVHN
	 ECUaH+eivNdJEFH8HtZTUh3Kt4knRLXCB5LIxQlq8X7C9Ayv1tlJRBwlcGB31CI8sv
	 0yOrT1n4tn9B95gHfE06jXK5LhNvfhjw+6pvEoFU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240118023356epcas5p47d72a536f48e935d090439ee022141cf~rUFtD1GPg0168001680epcas5p4b;
	Thu, 18 Jan 2024 02:33:56 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4TFmyq1m9Nz4x9Q3; Thu, 18 Jan
	2024 02:33:55 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	72.49.08567.31E88A56; Thu, 18 Jan 2024 11:33:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240118023341epcas5p37b8c206d763fd56f8a9cfb3193744124~rUFevWpeG2267822678epcas5p31;
	Thu, 18 Jan 2024 02:33:41 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240118023341epsmtrp1a2a66175573f7da9c15e9039b8911651~rUFeulUMG1919719197epsmtrp1i;
	Thu, 18 Jan 2024 02:33:41 +0000 (GMT)
X-AuditID: b6c32a44-617fd70000002177-5d-65a88e13a34c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8F.11.07368.50E88A56; Thu, 18 Jan 2024 11:33:41 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240118023340epsmtip222216eb9378eeec33e95235f88efef1e~rUFde4MCI1836718367epsmtip2o;
	Thu, 18 Jan 2024 02:33:39 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v6] io_uring: Statistics of the true utilization of
 sq threads.
Date: Thu, 18 Jan 2024 10:25:34 +0800
Message-Id: <20240118022534.13552-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0a626e1a-939a-44e5-bb82-0275c19f7143@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmlq5w34pUg1U32S3mrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFmcnfGC1mLplB5NFR8tlRgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM449cijYyVTRusS+gfEHYxcjJ4eEgIlE8/SX7F2MXBxC
	ArsZJbo23meBcD4xSnSs/MAM4XxjlJi8dQorTMuS6w+gWvYySqz4fAPKeckoMe/mJLAqNgFt
	ievrusBsEQFhif0drWBzmQX+MkpMePmbGSQhLBAp0fntPBOIzSKgKtEzZzvYVbwCNhKX//Wx
	QayTl9h/8CxYPaeArcSJhW9YIGoEJU7OfAJmMwPVNG+dzQxR/5NdYuZOGQjbRaL77l6ouLDE
	q+Nb2CFsKYmX/W1QdrHEkZ7vrCDHSQg0MEpMv30VKmEt8e/KHqAFHEALNCXW79KHCMtKTD21
	jgliL59E7+8nTBBxXokd82BsVYnVlx6yQNjSEq8bfkPFPSQmv1kEDeAJjBI/p59jmsCoMAvJ
	P7OQ/DMLYfUCRuZVjJKpBcW56anJpgWGeanl8FhOzs/dxAhOrFouOxhvzP+nd4iRiYPxEKME
	B7OSCK+/wbJUId6UxMqq1KL8+KLSnNTiQ4ymwACfyCwlmpwPTO15JfGGJpYGJmZmZiaWxmaG
	SuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwtTeYbbP58GDJwbjpwvdeTrhr/3pmkNGqn8ne
	T5JZ1n/ru/P7+JeKk8a/bdfcOF06Y+6BI3EbJrfuuSXb6qxx7u2ix/dY99UfmX5Q7/eBvpC0
	z/m5S5P9fCaLMjo6H438fc3M6WVNtsLhwx9yJEq4ee5P770pcth41/3Ll1g3srfxV1ntemLy
	6sSebyVau0wO/JtjZhMiclvlzdWTZ1fyn9rD8NkgfcIlRa7O2TcfmBbrffQ3/PJjw8RFK6WT
	63+oKuiu0Hk53fqgUlzUndenG8+cily7fuLJF5LKHyOFL26NeJ3NwKN41UfOuOY291kv7ZAP
	Qf+81+vmWh65Vnl2X6pD33MFgZtmu0X1/9879euiEktxRqKhFnNRcSIAvjPa7TUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSvC5r34pUg0UfRCzmrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFmcnfGC1mLplB5NFR8tlRgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZxx45FOxkqmhdYt/A+IOxi5GT
	Q0LARGLJ9QfsXYxcHEICuxkl/kz8CuRwACWkJf78KYeoEZZY+e85VM1zRonVS6+xgyTYBLQl
	rq/rYgWxRYCK9ne0soDYzAKdTBKvP+uB2MIC4RIHm2+BLWMRUJXombMdzOYVsJG4/K+PDWKB
	vMT+g2eZQWxOAVuJEwvfgM0RAqrZ2NcKVS8ocXLmE6j58hLNW2czT2AUmIUkNQtJagEj0ypG
	ydSC4tz03GTDAsO81HK94sTc4tK8dL3k/NxNjOCg19LYwXhv/j+9Q4xMHIyHGCU4mJVEeP0N
	lqUK8aYkVlalFuXHF5XmpBYfYpTmYFES5zWcMTtFSCA9sSQ1OzW1ILUIJsvEwSnVwLSB31Yy
	9cqTrQatXgYbs7kNl7z4Grfk4YHd+SpPzfq8DM8KnLxgGPzJQ0lntU63aoH2zJ3qnQ88Vu4J
	2hioI7/9Y6gZaxfLWg0mrc3l3Bue2H1zUg47/8yJy2zxSv/6g0IefhEW/kLsNxaVu2Tl53m+
	/lDAKhI4b9837Wy9LaX/GuOMVttcuH7x7d5MeU1pkYOzb7qe+cbq9HqZqRVDZOjeSbzmeQ/N
	sk4/vC8sKTBJ8qfdT1uPx9+2icaYGJU8eDAj7vTSVY+cee6Z9h/rOB5yMqZZQe2XzcEqX5m7
	jsuXyL87YGKr/c751DGj73J2mhcFF0hsZ87Ou9sYw7omnL0x+Vyl8IWn0tqvPP+tU2Ipzkg0
	1GIuKk4EANNBE+npAgAA
X-CMS-MailID: 20240118023341epcas5p37b8c206d763fd56f8a9cfb3193744124
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240118023341epcas5p37b8c206d763fd56f8a9cfb3193744124
References: <0a626e1a-939a-44e5-bb82-0275c19f7143@kernel.dk>
	<CGME20240118023341epcas5p37b8c206d763fd56f8a9cfb3193744124@epcas5p3.samsung.com>

On 1/17/24 23:04, Jens Axboe wrote:
>Possibly, can you send an actual patch? Would be easier to review that
>way. Bonus points for crafting test cases that can help vet that it
>calculates the right thing (eg test case that does 50% idle, 25% idle,
>75% idle, that kind of thing).

ok, I'll send out a v7.

