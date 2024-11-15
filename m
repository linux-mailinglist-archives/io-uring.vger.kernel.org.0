Return-Path: <io-uring+bounces-4712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2649CD5E9
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 04:35:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A67DBB23690
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 03:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBAAD155747;
	Fri, 15 Nov 2024 03:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Mlv+oNrR"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810A514EC7E
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 03:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731641706; cv=none; b=OLUtnm4aaQye66Lj1/KtHih7CpNXKGupW+GFYCGsqmbYmoCiAPywrmvjvDs2KXphu1jqDKZvL879EfE0YZqGcXC8ictVdHrp4QgNXmPuJ0fTbnkNiRIjeaUCxdntv5GuWWqeuyuvYPZR/Fh9h+X+OGTcuNkLCyewKUzKQSeH4c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731641706; c=relaxed/simple;
	bh=OdaKeA49chuOmGEwu9ntzEuTNnt8Lj3wLFBw/pLo3YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=DJPF0AGmeQ4J0il4M0UQEPROxkeqAKxjIkJwGg2OCecvyYdqE9gsNI1q4KzdMrXRPC9Y7QnCs+CDOLmKzNmoHGug1TpNVq+pe76MsJfuI4+TYOn5jJP7sW43edompVrEmHIkegxT5j/MHDSsBtApw+8Jm9bmp7JijBL+8npt+zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Mlv+oNrR; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241115033500epoutp013eb76d8944c07c86bf68a2443c49c4bd~IBvOa4DRR1429114291epoutp01D
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 03:35:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241115033500epoutp013eb76d8944c07c86bf68a2443c49c4bd~IBvOa4DRR1429114291epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731641700;
	bh=xNUnz6s0GtAS1FyIAZxZiiIuk/5Za5SBjoccDcvkTzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mlv+oNrR9F0SuJlFK5GEIr5Is98qL6vpcJZSivNY0SfjCJ7FqDo7IJn4J069JGrQ8
	 C98D50MUhfm8M16hLDPix072TjXzvY4FL7AkUEYs+IFsS4Uonl/j5vm6ir3c55oXx9
	 tdLnnUYsIv/EHA+bzZ33jiiAKo7zzP93lpth83V8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241115033459epcas5p1d1edf9a125dd374c7199c51918594ce6~IBvOBnohZ0873608736epcas5p1Z;
	Fri, 15 Nov 2024 03:34:59 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XqN1t35Qsz4x9Q5; Fri, 15 Nov
	2024 03:34:58 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0C.D7.09770.261C6376; Fri, 15 Nov 2024 12:34:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241115033450epcas5p10bdbbfa584b483d8822535d43da868d2~IBvF2i_8e2347623476epcas5p1f;
	Fri, 15 Nov 2024 03:34:50 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241115033450epsmtrp12c4eeae59d3483569e4fdb355062af34~IBvF13JfV2014420144epsmtrp1B;
	Fri, 15 Nov 2024 03:34:50 +0000 (GMT)
X-AuditID: b6c32a4a-bbfff7000000262a-7b-6736c1621c36
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EF.81.19220.A51C6376; Fri, 15 Nov 2024 12:34:50 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241115033449epsmtip1298e7b08c38af00cd3f0dd5bfe431c47~IBvE0weA_1306813068epsmtip1U;
	Fri, 15 Nov 2024 03:34:49 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH liburing] test: add test cases for hybrid iopoll
Date: Fri, 15 Nov 2024 11:34:45 +0800
Message-ID: <20241115033445.742464-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3aada5a2-074a-45e8-882c-0302cae4c41b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTXTfpoFm6wbZtYhZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWBzaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZ3VvfshWc5a24
	1HKPpYHxB1cXIyeHhICJxLv1U1i7GLk4hAR2M0ocej2dHcL5xCjx4+09RgjnG6PE5EMnmWBa
	Fu2/xwyR2Mso8X//BBaQhJDAD0aJ9m0SIDabgJLE/i0fGEFsEQFhif0drUA1HBzMAiESN89E
	gISFBTwkpiw6zwZiswioSnQsXcIOYvMKWElMuf6ZFWKXvMTiHcuZQVo5BWwlTt5IhygRlDg5
	8wnYVmagkuats8HOkRC4xC6xtKEBqtdF4tfW+SwQtrDEq+Nb2CFsKYmX/W1Qdr7E5O/rGSHs
	Gol1m99B1VtL/LuyB+pkTYn1u/QhwrISU0+tY4LYyyfR+/sJNEh4JXbMg7GVJJYcWQE1UkLi
	94RFUOd4SDzc/RgauBMYJXqPtDNOYFSYheSfWUj+mYWwegEj8ypGydSC4tz01GLTAqO81HJ4
	HCfn525iBKdGLa8djA8ffNA7xMjEwXiIUYKDWUmE95SzcboQb0piZVVqUX58UWlOavEhRlNg
	eE9klhJNzgcm57ySeEMTSwMTMzMzE0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGpjY
	jabaLCm2z/J4W7LI7ce9OZ2XGOWvrDTiWPjpGsPCs6Z/N1qmz2F/mSbPeJBVdP/zcodtfgb2
	D9/0brq/RCNiydrS0wy3k83vPeGUmaioH/5s9jbli90fpecavhITmvr30Qa1GhW+V0fu6vwx
	K5BdvnmCymV2vfy1GQv8Zq9KevTg5sTcMqZrL+WyHGJnZz1v27HiVPvDU/w3j3W/drMoThY4
	8jXrGuObs5Y2qed52t3nlob0r6/coPFnBefp5wtU83QedR9fvG6yVP+8KZN2WtiVRu1k+lX+
	6eXpz88Puy8Pvbnvpf9Lt5Lbmd+Pqr9T1FQ9vcr07afH4osrv2+wEautjuBeGZK8w50no7j4
	nhJLcUaioRZzUXEiADKEhbsWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSnG7UQbN0g9VtGhZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWBzaPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBndW9+yFZzlrbjUco+lgfEHVxcjJ4eEgInEov33mEFsIYHdjBIX280g4hISOx79YYWw
	hSVW/nvO3sXIBVTzjVHi79td7CAJNgElif1bPjCC2CJARfs7WllAbGaBMImuHWfAmoUFPCSm
	LDrPBmKzCKhKdCxdAtbLK2AlMeX6Z6gF8hKLdywHOoKDg1PAVuLkjXSIe2wkNmxsYoIoF5Q4
	OfMJ1Hh5ieats5knMArMQpKahSS1gJFpFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZG
	cPBqae1g3LPqg94hRiYOxkOMEhzMSiK8p5yN04V4UxIrq1KL8uOLSnNSiw8xSnOwKInzfnvd
	myIkkJ5YkpqdmlqQWgSTZeLglGpgijuY3nL88LvLO00krd+4fvizz2nV3vyPd+WP/fubN63F
	/HzFp/SjG97Zfbjzt8GypPE3c+keceb/EZqmkysYw43dn+6MVq7ijTrzddvqLru/rE2usZFn
	j/HGpqt2hoszst+eFePw2dFEuVVu2VGxRyXXLmuHtDDtiN34ONM+YtoCXv/gYydl9qua7ojY
	yfLVSvJ3OaM+S9IWqdu10+3Dzs+JE/h2wJ31gNfDGWGtO5YVfJPJm+dwbpKK2pn2O0GHMxx4
	1tervDAK2fltaYdy67wMjZ1KwgxZdU5f305Y/mK7TkLdlW8LZGZ80td48PTGf4Ubn98Lt9cW
	tXkuy9vCm7m+2WnVbp4HL2RZhM+7KLEUZyQaajEXFScCABxmajvNAgAA
X-CMS-MailID: 20241115033450epcas5p10bdbbfa584b483d8822535d43da868d2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241115033450epcas5p10bdbbfa584b483d8822535d43da868d2
References: <3aada5a2-074a-45e8-882c-0302cae4c41b@kernel.dk>
	<CGME20241115033450epcas5p10bdbbfa584b483d8822535d43da868d2@epcas5p1.samsung.com>

>On 11/13/24 10:03 PM, hexue wrote:
>> diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
>> index 2f87783..fa928fa 100644
...
>
>This flag must be used with
>
>> +.B IORING_SETUP_IOPOLL
>> +flag. hybrid poll is a new
>
>Like before, skip new. Think about what happens when someone reads this
>in 5 years time. What does new mean? Yes it may be new now, but docs
>are supposed to be timeless.
>
>> +feature baed on iopoll, this could be a suboptimal solution when running
>
>based on
>
>> +on a single thread, it offers higher performance than IRQ and lower CPU
>> +utilization than polling. Similarly, this feature also requires the devices
>> +to support polling configuration.
>
>This doesn't explain how it works. I'd say something like:
>
>Hybrid io polling differs from strict polling in that it will delay a
>bit before doing completion side polling, to avoid wasting too much CPU.
>Like IOPOLL, it requires that devices support polling.

Thanks, will change the description.

...

>> +		return -EINVAL;
>> +

>The kernel should already do this, no point duplicating it in liburing.
>
>The test bits look much better now, way simpler. I'll just need to
>double check that they handle EINVAL on setup properly, and EOPNOTSUPP
>at completion time will turn off further testing of it. Did you run it
>on configurations where hybrid io polling will both fail at setup time,
>and at runtime (eg the latter where the kernel supports it, but the
>device/fs does not)?

Yes, I have run both of these error configurations. The running cases are: 
hybrid poll without IORING_SETUP_IOPOLL and device with incorrect queue
configuration, EINVAL and EOPNOTSUPP are both identified.

--
hexue

