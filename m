Return-Path: <io-uring+bounces-500-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADBE841D1A
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 08:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 038A61F21665
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 07:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CB8376F6;
	Tue, 30 Jan 2024 07:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cPvp6T35"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667E054670
	for <io-uring@vger.kernel.org>; Tue, 30 Jan 2024 07:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706601573; cv=none; b=rijQeBEiONIs++IF14l3cCOxwnXK+zFUaFtlhYISj1hg8jjIZsz5MFOXQs2Hv+Yo4InP+ndRxf/UAZfLpt8swFd3DWqK1533nPylxXULJKc1YJ3Pn8CFXC8drDTRJGHIUEV4Uz2u9KNavanFbIxe2vBbugnOUMSs5OIkRT0TbLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706601573; c=relaxed/simple;
	bh=0Q+E6kRva+/RjLoYooYJxbptgewzdyZaRx/rMpCfyB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=flDQZltBQcACZsi/ziIZsyFcD2UrOp8RK/quUKRn4HX9dYha/QHvkRG+wMpR4to7SANqaN2ghIjz7bVEBB1eKl0q9qGtW8KexwLKg/35OYsIBRsJoReHSy7s7W5+ZKEp1gaUJA+JOhNqquSBO2++loQx+hDzkS0j2h+AenuRe6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cPvp6T35; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240130075229epoutp017bc9f59da381c3a8ca56a61a0294f6e4~vELQIa4dT1084710847epoutp01X
	for <io-uring@vger.kernel.org>; Tue, 30 Jan 2024 07:52:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240130075229epoutp017bc9f59da381c3a8ca56a61a0294f6e4~vELQIa4dT1084710847epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706601149;
	bh=P8USmMDWyZvTuJQ5N9jjWEMwGP1hRVmRDjIvhJMCatw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPvp6T35AtjuRSyF4l7XkLaygaChKUbKPgEd01ZwcsZb6QCzGZQTspKzNU86EB/qz
	 9kPKNGfwddyHifheG9h/LZi8c1EBsC1UC/BQwGtth0Cd6xDN8Gqdv1aMuSBfwILE82
	 xc2DW1AzWghEbefqAhC7g5VRYuXewRyZjBfqaVs8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240130075228epcas5p3d6c6e139979785c598a847fe7db7ebd4~vELPrLviF0783407834epcas5p3f;
	Tue, 30 Jan 2024 07:52:28 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4TPHSq04fnz4x9QB; Tue, 30 Jan
	2024 07:52:27 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F9.F5.19369.ABAA8B56; Tue, 30 Jan 2024 16:52:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240130070518epcas5p41bdf16f1e864c2590e2f39dac703febb~vDiDhRI_i3016030160epcas5p4c;
	Tue, 30 Jan 2024 07:05:18 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240130070518epsmtrp255c2f99de24ebab1df4c19c0e7f5ce9e~vDiDgSNIX0303903039epsmtrp2b;
	Tue, 30 Jan 2024 07:05:18 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-85-65b8aabaaba5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5D.CF.07368.DAF98B56; Tue, 30 Jan 2024 16:05:18 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240130070516epsmtip260674efe39a1fbb849e4e439a464a65d~vDiCSSr5r3157231572epsmtip2Q;
	Tue, 30 Jan 2024 07:05:16 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v7] io_uring: Statistics of the true utilization of
 sq threads.
Date: Tue, 30 Jan 2024 14:57:06 +0800
Message-Id: <20240130065706.423175-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e2a84850-95a3-48a8-b4ce-e5b005fbf186@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmpu6uVTtSDU4cNreYs2obo8Xqu/1s
	Fu9az7FYHP3/ls3iV/ddRoutX76yWlzeNYfN4tleTosvh7+zW5yd8IHVYuqWHUwWHS2XGR14
	PHbOusvucflsqUffllWMHp83yQWwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQ
	K07MLS7NS9fLSy2xMjQwMDIFKkzIzrh68zpTwV3Bis+HrrI0MB7k7WLk5JAQMJG4+vosSxcj
	F4eQwB5Gids7vzBCOJ8YJTY+nc4GUiUk8I1R4vM2eZiOBUsfM0EU7WWUWLHnBCuE85JR4t/H
	WawgVWwC2hLX13WB2SICwhL7O1rBdjAL/GWUmPDyNzNIQlggUmLBxxlgK1gEVCXaz3YA2Rwc
	vAK2Ek/uhkJsk5fYf/AsWDknUPjnw1YmEJtXQFDi5MwnLCA2M1BN89bZzCDzJQQ6OSTufL3I
	AtHsInHy/Ct2CFtY4tXxLVC2lMTnd3vZIOxiiSM931khmhsYJabfvgpVZC3x78oeFpCDmAU0
	Jdbv0ocIy0pMPbWOCWIxn0Tv7ydMEHFeiR3zYGxVidWXHkLdIC3xuuE3VNxDomniW2ZIaE1g
	lDjVc5F9AqPCLCQPzULy0CyE1QsYmVcxSqUWFOempyabFhjq5qWWw+M5OT93EyM4uWoF7GBc
	veGv3iFGJg7GQ4wSHMxKIrw/NbemCvGmJFZWpRblxxeV5qQWH2I0BYb4RGYp0eR8YHrPK4k3
	NLE0MDEzMzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBSShgl474hF1brG8dLPi2
	RjYn5Hat26+e3duOv43Y2qaQ+yPa/mr0JdvLjNXmt/ylPjFKKvBdvM0y6c8m9+uM97r53EXN
	9hcly7Bf7ta9b3aaRY+vkfX4j65bzW/lNhR1fIkP9b9cEhynuOPZ0pyHp/edrDjIPEWr8Dz/
	rkXsr5hU1VMvf+5/K8It2TghQtho1XfTsxZ5W0Xqomu3zFosNXUxm8eVlF3HJ9+3Fnfnf1ty
	qr/5bYP3/g1bzmxY42I37Z2hxVG9vZ01gqmyj2R2PDvq/7skS9X9g1OVWX30kYZThdanXlta
	GX6/8DHsvH8M47/ATwVqISf69OSL/us4dd6X40qslftXL6a2+DSvEktxRqKhFnNRcSIA3gAV
	mzcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSvO66+TtSDZ7sYLaYs2obo8Xqu/1s
	Fu9az7FYHP3/ls3iV/ddRoutX76yWlzeNYfN4tleTosvh7+zW5yd8IHVYuqWHUwWHS2XGR14
	PHbOusvucflsqUffllWMHp83yQWwRHHZpKTmZJalFunbJXBlXL15nangrmDF50NXWRoYD/J2
	MXJySAiYSCxY+pipi5GLQ0hgN6PEjou7GbsYOYAS0hJ//pRD1AhLrPz3nB2i5jmjxLypF1hA
	EmwC2hLX13WxgtgiQEX7O1rB4swCnUwSrz/rgdjCAuESKw/+YAKxWQRUJdrPdrCBzOcVsJV4
	cjcUYr68xP6DZ5lBbE6g8M+HrUwgJUICNhLHtxmDhHkFBCVOznwCNV1eonnrbOYJjAKzkKRm
	IUktYGRaxSiZWlCcm56bbFhgmJdarlecmFtcmpeul5yfu4kRHPRaGjsY783/p3eIkYmD8RCj
	BAezkgjvT82tqUK8KYmVValF+fFFpTmpxYcYpTlYlMR5DWfMThESSE8sSc1OTS1ILYLJMnFw
	SjUwLa4z7bjwRmrh6peLdq2OOjvJjHmenLfJ/LM385fLuVz81qU2s+zrTobquOcZStqbbx1d
	qauzqOF3aam27rnsmnmHQqOEqu/8CNjJUXHJvn2V5j6e+T3r9v045mzP53zlfsD5/InKOwO2
	zm/m5Snx+vLqo8OrcKMrxuem31FPXWPFb8En4eKueaW4eMOudXMOFFvHzoj7qNDif5b37tuc
	+2mvmT12ZXuK1qle3ztzF4/l3CT2Kas19G9V39DefPFoZfo0PlHHFbtcrBQyZHZdCZs+I33p
	leXvf95Q3xZ++FmfMmvHktrNy+9uOtS47OYnd9nXH60vTk7Um96wcc6PDElj4yx3j8+ikVOf
	nwtgCFNiKc5INNRiLipOBACdratk6QIAAA==
X-CMS-MailID: 20240130070518epcas5p41bdf16f1e864c2590e2f39dac703febb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240130070518epcas5p41bdf16f1e864c2590e2f39dac703febb
References: <e2a84850-95a3-48a8-b4ce-e5b005fbf186@kernel.dk>
	<CGME20240130070518epcas5p41bdf16f1e864c2590e2f39dac703febb@epcas5p4.samsung.com>

On 1/29/24 14:00, Jens Axboe wrote:
>On 1/29/24 12:18 AM, Xiaobing Li wrote:
>> On 1/18/24 19:34, Jens Axboe wrote:
>>>> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
>>>> index 8df37e8c9149..c14c00240443 100644
>>>> --- a/io_uring/sqpoll.h
>>>> +++ b/io_uring/sqpoll.h
>>>> @@ -16,6 +16,7 @@ struct io_sq_data {
>>>>  	pid_t			task_pid;
>>>>  	pid_t			task_tgid;
>>>>  
>>>> +	long long			work_time;
>>>>  	unsigned long		state;
>>>>  	struct completion	exited;
>>>>  };
>>>
>>> Probably just make that an u64.
>>>
>>> As Pavel mentioned, I think we really need to consider if fdinfo is the
>>> appropriate API for this. It's fine if you're running stuff directly and
>>> you're just curious, but it's a very cumbersome API in general as you
>>> need to know the pid of the task holding the ring, the fd of the ring,
>>> and then you can get it as a textual description. If this is something
>>> that is deemed useful, would it not make more sense to make it
>>> programatically available in addition, or even exclusively?
>> 
>> Hi, Jens and Pavel
>> sorry for the late reply.
>> 
>> I've tried some other methods, but overall, I haven't found a more suitable 
>> method than fdinfo.
>> If you think it is troublesome to obtain the PID,  then I can provide
>>  a shell script to output the total_time and work_time of all sqpoll threads 
>>  to the terminal, so that we do not have to manually obtain the PID of each 
>>  thread (the script can be placed in tools/ include/io_uring).
>> 
>> eg:
>> 
>> PID    WorkTime(us)   TotalTime(us)   COMMAND
>> 9330   1106578        2215321         iou-sqp-9329
>> 9454   1510658        1715321         iou-sqp-9453
>> 9478   165785         223219          iou-sqp-9477
>> 9587   106578         153217          iou-sqp-9586
>> 
>> What do you think of this solution?
>
>I don't think it's a great interface, but at the same time, I don't feel
>that strongly about it and perhaps bundling a script that outputs the
>above in liburing would be Good Enough. I'm a bit reluctant to add a
>stats API via io_uring_register() just for this.
>
>So maybe spin a v8 with the s/long long/u64 change and include your
>script as well?
 
ok, I'll send out a v8.

--
Xiaobing Li

