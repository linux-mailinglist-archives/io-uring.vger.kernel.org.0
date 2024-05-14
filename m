Return-Path: <io-uring+bounces-1896-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2758C4A99
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 02:49:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EEE12870C6
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 00:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA0AEC5;
	Tue, 14 May 2024 00:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MPBClWFI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D869C7EF
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 00:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715647762; cv=none; b=I/glITNFTLGaEpdgHDOyIpTNV+MfKb1KI9xPonBm1zBwDkenCYNiAfrGYIBSBma7tqKjoXAKCfmnTCAPQrXKAQvY1k/fxh7rz5jyV0lIzgskb/HBDeSbTJPGQtG4SM+ifBR+U0atig1hHCzinUcoJbwZCbjs+o4r3ymUTQ9SUCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715647762; c=relaxed/simple;
	bh=8tz74j6HeGBe7p0VZlSGg09J6dEmRnWHCDctXSvLw0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=aBxwFNxGKRNoF3sxeKRh98vfRIL1HVXlFWpEGARcesCrsk15mTbh4ghvlP8j5KF65ow2rwga5mYOmz27QJlowTIuq6u3ViVENv+/c9yQne6miYqL/1spMEdWOzL9QqUzNgVXHWJfdTzz6YTfP+tQgBMETO8BVv3H+I1goN4mFLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MPBClWFI; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240514004916epoutp037e35ffa1e0b3a36fe7d6736ae28f15af~PNIt2G7mx2105221052epoutp03U
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 00:49:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240514004916epoutp037e35ffa1e0b3a36fe7d6736ae28f15af~PNIt2G7mx2105221052epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715647756;
	bh=8dz/YxvJNzjKscKeC1bSg6XTCsJD3o89ehbSd+l1ZOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPBClWFIHCpXoiZ0dOpljZFcsk1DJUP6+ou38VYnqnyApYHU8av5n1rrh4G0WpewI
	 d65UKqyn/m2xcjvg1yT6Ap5uDa0Od6umXOZkOaX/o7yFx2l/Sn+fGjK5NRVeCPQ/xQ
	 8c0IWtmeLE1q0FUqchMZZmH/BfUwym7+0x8BY1RY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240514004915epcas5p3d7efdb63457740b63986bc991f141c5e~PNItLOnB12303023030epcas5p34;
	Tue, 14 May 2024 00:49:15 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Vdd622194z4x9Q5; Tue, 14 May
	2024 00:49:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AF.0A.19431.A05B2466; Tue, 14 May 2024 09:49:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240514001620epcas5p10d8c08ffc3dbd746213df21e47df19f7~PMr9U3xSH1748517485epcas5p12;
	Tue, 14 May 2024 00:16:20 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240514001620epsmtrp1a960091ea212e5cd4f6c3d53da456126~PMr9UEx7h0286202862epsmtrp1l;
	Tue, 14 May 2024 00:16:20 +0000 (GMT)
X-AuditID: b6c32a50-ccbff70000004be7-9f-6642b50ae86d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	06.53.09238.45DA2466; Tue, 14 May 2024 09:16:20 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240514001619epsmtip1b58e49eac49bb79abf5661cc7502e693~PMr8TLLAR1786517865epsmtip1c;
	Tue, 14 May 2024 00:16:19 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: anuj1072538@gmail.com
Cc: asml.silence@gmail.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v3 0/5] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Tue, 14 May 2024 08:16:14 +0800
Message-Id: <20240514001614.566276-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CACzX3At7k+kspDrzz-=HhFGHpcgi+O8S6D+fPND7imfiodHTOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmhi7XVqc0g4MLeCw+fv3NYjFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2RmLL5xmLGjnqpg/9SpjA+MEji5GTg4JAROJplMfWEFsIYE9jBIv
	N7l0MXIB2Z8YJbYuf8cIkfjGKNHQnNDFyAHW8H8RC0TNXkaJDW86WCBqfjFKPJurC2KzCehI
	/F7xCywuIiApsfPjQbAGZoF9jBIfZt5iARkkLBApcfcrE4jJIqAq8flfKEg5r4CtxO2mc2wQ
	t8lL7D94lhnE5hQIlLjaOIsVokZQ4uTMJ2DjmYFau488ZYKw5SWat85mhuidyCGxqDMUwnaR
	eNdxgAXCFpZ4dXwLO4QtJfGyv40d4q1iiWXr5ECulBBoYZR4/24OI0SNtcS/K3ugemUlpp5a
	B7WLT6L39xMmiDivxI55MLaqxIWD26DmS0usnbCVGWK+h8Sd1kxIsC1hlJg94wv7BEaFWUje
	mYXknVlI3lnAyLyKUSq1oDg3PTXZtMBQNy+1HB7Fyfm5mxjBiVQrYAfj6g1/9Q4xMnEwHmKU
	4GBWEuF1KLRPE+JNSaysSi3Kjy8qzUktPsRoCgzwicxSosn5wFSeVxJvaGJpYGJmZmZiaWxm
	qCTO+7p1boqQQHpiSWp2ampBahFMHxMHp1QDk+Gk2dosz0qDkj9bRu1v2JVYb7VpZo4y77W0
	xpWJ+YtdA+r//hblyUxhk1LfxF6xy6CKp2HmN/vugh9zp1s5ds3K3FPyPe2cpIjJZ+ljW5zW
	KhwS8U3eapbN8qacu6W+9D5DOG96U8xRiY873nC2bvdrCZu3d2+0L+Pu5LWvg2Iv31KME8p/
	w/7n2Ts1DwulQ1yPnjXYmP61SZHOOFS9qSdpxx2vG/GNFe5qjxoND/CVyS4+s4+1WKPfzHSS
	yfeHl87ryv/fylMnm8gz0eqRy2YflwQ53dzeBJFDgouCo3qvP2vb6PWJ7cC/XW7bJp9laK+c
	pODTf0SXx8mpVPGS4KxXCsYZew9Hzdjtv1eJpTgj0VCLuag4EQAOiyvKLQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSnG7IWqc0g4kNghYfv/5msZizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuILpxkL2rkq5k+9ytjAOIGji5GDQ0LA
	ROL/IpYuRi4OIYHdjBLLt99j7WLkBIpLS3QcamWHsIUlVv57zg5R9INR4uv+K8wgCTYBHYnf
	K36xgNgiApISOz8eBJvELHCCUaL//kmwbmGBcImuH59ZQLaxCKhKfP4XChLmFbCVuN10jg1i
	gbzE/oNnwWZyCgRKXG2cBXaEkECAxJ+ZO9gg6gUlTs58AraLWUBZouvMMjYIW16ieets5gmM
	grOQlM1CUjYLSdkCRuZVjJKpBcW56bnJhgWGeanlesWJucWleel6yfm5mxjB8aGlsYPx3vx/
	eocYmTgYDzFKcDArifA6FNqnCfGmJFZWpRblxxeV5qQWH2KU5mBREuc1nDE7RUggPbEkNTs1
	tSC1CCbLxMEp1cCU/UJcoz9sV9WisxILzf9d/KojcyRkpt+vBm6XbqboRiFWH8lr8cbrlq67
	0j3xSrCE5hW9VzXOd2PP7Ju/0PDjF86b52Y8Foo43ZbKc1yNZUpP40eWRcWnzYoyOQ3Du0Ic
	Za2VF+2dkTlrz1xF7ZMKTQ8jPkTMPV3+lCfg9QWFJgWh/kfVLbeP9tv7L7FeqTCl6iL/2TNL
	l9wPqNqy6uvatZpLZu9uOyD8xPyXAofYte2b5vskX7/q/2RByz+F9VUvb/I+PsUw89WGma97
	EsrlAiQnWPlX7L8jyHr54Zw1Em0vflwr9LqT4vtr0oMc/uDQOptLlh0Cq0O2t8qyibZoP/70
	0abh/du/9+8Y3SyVVGIpzkg01GIuKk4EAKu3ka7+AgAA
X-CMS-MailID: 20240514001620epcas5p10d8c08ffc3dbd746213df21e47df19f7
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514001620epcas5p10d8c08ffc3dbd746213df21e47df19f7
References: <CACzX3At7k+kspDrzz-=HhFGHpcgi+O8S6D+fPND7imfiodHTOg@mail.gmail.com>
	<CGME20240514001620epcas5p10d8c08ffc3dbd746213df21e47df19f7@epcas5p1.samsung.com>

On Mon, 13 May 2024 17:39:37 +0530, Anuj Gupta wrote:
> On Mon, May 13, 2024 at 1:59 PM Chenliang Li <cliang01.li@samsung.com> wrote:
>>
>> Registered buffers are stored and processed in the form of bvec array,
>> each bvec element typically points to a PAGE_SIZE page but can also work
>> with hugepages. Specifically, a buffer consisting of a hugepage is
>> coalesced to use only one hugepage bvec entry during registration.
>> This coalescing feature helps to save both the space and DMA-mapping time.
>>
>> However, currently the coalescing feature doesn't work for multi-hugepage
>> buffers. For a buffer with several 2M hugepages, we still split it into
>> thousands of 4K page bvec entries while in fact, we can just use a
>> handful of hugepage bvecs.
>>
>> This patch series enables coalescing registered buffers with more than
>> one hugepages. It optimizes the DMA-mapping time and saves memory for
>> these kind of buffers.
>>
>> Perf diff of 8M(4*2M) hugepage fixed buffer fio test:
>>
>> fio/t/io_uring -d64 -s32 -c32 -b8388608 -p0 -B1 -F0 -n1 -O1 -r10 \
>> -R1 /dev/nvme0n1
> 
> It seems you modified t/io_uring to allocate from hugepages. It would be nice
> to mention that part here.

Yeah I forgot to mention that. Thanks for pointing out.

