Return-Path: <io-uring+bounces-3301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB949857A8
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 13:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34F0F1F25B18
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 11:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5FB21547C5;
	Wed, 25 Sep 2024 11:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O6k+H8mm"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A65E4962B
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727262596; cv=none; b=IiPHoHIqXLHtRrpGMiEQhv3beVFx8DDR+kj68nKDSPLjqPKdACFB06hyaK0r4OWJ++Tid3kPkP7BkFD2DoVLPpTrtAEv71jOop6uNnnKqROi0f3w7u/xkobNcC8oLIU/hYbbjCJoqEbyhXxrqLjOKrYbdPVT2LuVRj8LDtj1/WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727262596; c=relaxed/simple;
	bh=LQEzXPAIIICkhmqoZQCr+ZgX6AtcOa0R/eWt6GYdcmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=KrPbJy4iyO4zTkhHs9GMVV1XJhatJN6lnOD157o22U0PFW8Tgj8sQ+jp/l787qEx5TZc3RFqu11aXtyh5hSbaMjekgXz+oRxUjAmumhaP/RxdoeHDG53vXh8eTVmdaISBuWL2wFAj7dC1K8jPWnVGaQExvYbjR4PZxtNFVmaJ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=O6k+H8mm; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240925110947epoutp03e656d8964957f1363c4e9249ce0edffd~4eCv9AFn90056800568epoutp03o
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 11:09:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240925110947epoutp03e656d8964957f1363c4e9249ce0edffd~4eCv9AFn90056800568epoutp03o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727262587;
	bh=N+h3PsTPTQHDyIY9DQ7puLUE1ePpWavL+lGTJUupizU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=O6k+H8mm6iKRX5Zc+FhV3dBREcuw/+zRNC7A/CY2jdg9EZVZo7REij+jWss6liQ4V
	 6ktt0okuWPFEHJR7LX6s70bek43R1tcphY0z5RHIOZyvbUD1AL05SxR90rbaDvknge
	 vwRSoXxbyIZrhrmpDv3cQeQxnnLDbIok4cGkJKcE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240925110946epcas5p2d3caa556f7252ff32ef4283ce4becb0f~4eCvTn7cf1791117911epcas5p2F;
	Wed, 25 Sep 2024 11:09:46 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XDDX94bcYz4x9Pw; Wed, 25 Sep
	2024 11:09:45 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BE.48.08855.97FE3F66; Wed, 25 Sep 2024 20:09:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240925110945epcas5p33419ecc893436e250dc77fe629d86c4d~4eCtxtCtn2184821848epcas5p3u;
	Wed, 25 Sep 2024 11:09:45 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240925110945epsmtrp26fd009b541f5c043f80be1ddfacbbe1a~4eCtwuvnp0643906439epsmtrp2L;
	Wed, 25 Sep 2024 11:09:45 +0000 (GMT)
X-AuditID: b6c32a44-107ff70000002297-b2-66f3ef7983c6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7C.57.07567.87FE3F66; Wed, 25 Sep 2024 20:09:44 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240925110941epsmtip2688610a145f992978c8e49e754c94e0b~4eCqpQ_lf2519425194epsmtip2f;
	Wed, 25 Sep 2024 11:09:41 +0000 (GMT)
Message-ID: <678921a8-584c-f95e-49c8-4d9ce9db94ab@samsung.com>
Date: Wed, 25 Sep 2024 16:39:40 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v6 3/3] io_uring: enable per-io hinting capability
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, martin.petersen@oracle.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Nitesh
	Shetty <nj.shetty@samsung.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <28419703-681c-4d8c-9450-bdc2aff19d56@suse.de>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TaVBTVxid+/KygEVfo5RLRjFNx6GoQFKWXqyo0yK+Dm0Hl4FuSiN5EAok
	mSyltowyWECRTbCAYQlVKhBblLUghNKgoEGlI6BCK6IEtVD2wrQi2CQPW/6d891z7rnf983l
	MLj5bB4nSqamlDJxjIBlj9e3ubm6H5qYiRCm1PBRob4eoPP3MlkodbEWR6Nt0wDlTv7DQOOJ
	8zjqa23EUPOZbAxVnL+CofGkmzgqyDuKIfMFLQMN/T7DRtnG2wCdyk0EyNC/CTUbruFId26Y
	jco6FjFUP69joMrRCRx1LXQwUZe2kL3DiezuCSIbtffYZNdAFU5239CQ1frjLLJ6OptN1pQe
	IZv6Eljk1HA/Tk609LLIjFo9IK+XXLYcdn5NzlS7kNXmMSx41cfRW6WUWEIp+ZQsXC6JkkX6
	C4L2hr0T5uMrFLmL/NCbAr5MHEv5CwLeC3YPjIqxzEDA/0Ico7GUgsUqlcBz21alXKOm+FK5
	Su0voBSSGIW3wkMljlVpZJEeMkq9RSQUvuFjEX4WLU278R2m+NvpywJTGzsBjLyUCuw4kPCG
	beVVjFRgz+ESTQDO9uQDmkwD2JVWitNkDsAT9WfBC8vtq7+wrJhLGACsShTRojEAy4f+sokc
	iG1wOPGBTYQTG6DpuhGn6y/Da6fNNuxIHIRPewtt+tVEIKwp6GJaMYNwgv1mHWa9dA1RjsFH
	zbNMK2EQzwH8tkJvIRwOi3CDv+ZorAY74i34R0oRmzavh0frCmwNQcJkB/uTF5j0swNg162U
	pRZWw5GOWjaNeXBm3MCicTQcfDiI0zgeNtRkLHm3w4Rnd225DEvuhUuedNZKmD5vxqxlSDjA
	Y8lcWv0qHMgeXnI6wQf5pUxaQsLUhQ/oWY0AWNf+EGQBvnbZWLTL2tcu60b7f3AJwPXAmVKo
	YiOpcB+FSEbF/bfwcHlsNbB9kY0BDeCubtHDCDAOMALIYQjWOGT3TUVwHSTiQ19RSnmYUhND
	qYzAx7KfkwyeY7jc8sdk6jCRt5/Q29fX19vPy1ckcHIYTSqScIlIsZqKpigFpXzhwzh2vAQs
	S+Q8znQUxg+nZ9bl2BXvd9sUFKR8LI3LOxx+80xTbtmU+U+X9AMJOc8M9iF3sjs/fT/g0mLl
	47W60/MRJcbDXgMtO19fV5HWYrpStW/z8xCxsfXILDd4Vl6+R9ga9Vvefg31g/zgWEXN58mj
	g7vb2s0b3D9al+syN9fiq3McYP+4O8vZJNnV3hh63416+0Rb0/acfT3MnzrRWtYofyHjwCrD
	+tDu+1uewJRJ5x3x0j2zr0TpL37z2rHvjwdndjisCBxy9QyNLcrYbLy8q9L+5+LJEMmHT++s
	VKhdHlG8uOKTYhPvVO+qi2d3NvQoxgy39vLfrRovk5cVftKfdM7L9eoK45NpTwGukopFGxlK
	lfhfs/a3TKsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7bCSvG7F+89pBpe+m1vMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLG4e2MlksWfRJCaLlauPMlm8az3HYjF7ejOTxZP1s5gt
	Ht/5zG4x6dA1Rosp05oYLfbe0rbYs/cki8X8ZU/ZLZYf/8dkse33fGaLda/fs1ic/3uc1eL8
	rDnsDuIel694e+ycdZfd4/y9jSwel8+Wemxa1cnmsenTJHaPzUvqPXbfbGDz+Pj0FovH+31X
	2Tz6tqxi9Diz4AhQ8nS1x+dNch6bnrxlCuCP4rJJSc3JLEst0rdL4MroObuQqeCHeMXsU4fZ
	Gxhf8XQxcnJICJhIXDtxkK2LkYtDSGA3o8TXq/vZIBLiEs3XfrBD2MISK/89Z4coes0oMbN/
	JjNIglfATuJp00OwBhYBVYlTZw6xQMQFJU7OfAJmiwokSey538gEYgsLuElsnn2eFcRmBlpw
	68l8JpChIgIrmCQu/ZkH5jAL/GeU6Di2jAli3StGiR0XJgCN4uBgE9CUuDC5FKSbU8Ba4mX7
	XHaISWYSXVu7GCFseYnmrbOZJzAKzUJyyCwkC2chaZmFpGUBI8sqRsnUguLc9NxkwwLDvNRy
	veLE3OLSvHS95PzcTYzgpKGlsYPx3vx/eocYmTgYDzFKcDArifBOuvkxTYg3JbGyKrUoP76o
	NCe1+BCjNAeLkjiv4YzZKUIC6YklqdmpqQWpRTBZJg5OqQam7U9unX674FfNqRuL2M5d3PrW
	Q35DVbfaIWV7NaW1KyXLQycb6fLL7GXc72Bruna73+8nZof/T/BReiv1doqdbOPFw7vCkqYI
	XJX7pv/8lgjTm2mRs3y+CNgHFK39+4TpqEi9y8trcZu6YngZfvycMm9pzFPbJ/q7LwTnTtue
	8Wy5Yb4Ne73HwWrNrb4L2JtL0ksmMEw4vW1LzJrO7bv7Xdf1RS0rV/XLS/JweXtyUfSDG179
	i/eU747Y/dIhqas5I8ScI4Tp7Z3Ji2d2XreZsjH0jnaI193gMw6OEXGXzT5fmeY8da/gKv/y
	UO0bnn+OOl1MEe29zucV48nEc+FODceuiZIJ7oXtr1Y0rDTUUWIpzkg01GIuKk4EACcrUB6J
	AwAA
X-CMS-MailID: 20240925110945epcas5p33419ecc893436e250dc77fe629d86c4d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53
References: <20240924092457.7846-1-joshi.k@samsung.com>
	<CGME20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53@epcas5p1.samsung.com>
	<20240924092457.7846-4-joshi.k@samsung.com>
	<28419703-681c-4d8c-9450-bdc2aff19d56@suse.de>

On 9/25/2024 11:27 AM, Hannes Reinecke wrote:
>> @@ -98,6 +98,11 @@ struct io_uring_sqe {
>>               __u64    addr3;
>>               __u64    __pad2[1];
>>           };
>> +        struct {
>> +            /* To send per-io hint type/value with write command */
>> +            __u64    hint_val;
>> +            __u8    hint_type;
>> +        };
> Why is 'hint_val' 64 bits? Everything else is 8 bytes, so wouldn't it
> be better to shorten that? 

Right, within kernel hint is stored as 8bits value.
But I chose not because how kernel stores hint internally (which may 
change at any time) but how the existing F_SET_RW_HINT interface exposed 
this to user space. It expects u64.

If we do 8bits interface here, application needs to learn that for the 
same lifetime hint it needs u64 for fcntl interface, but u8 for io_uring 
interface. That seems a bit confusing.

Also, in future if we do support another hint type, we may be able to 
pass hint_val beyond what can be supported by u8.

As it stands the new struct will introduce
> a hole of 24 bytes after 'hint_type'.

This gets implicitly padded at this point [1][2], and overall size is 
still capped by largest struct (which is of 16 bytes, placed just above 
this).

[1] On 64bit
»       union {
»       »       struct {
»       »       »       __u64      addr3;                /*    48     8 */
»       »       »       __u64      __pad2[1];            /*    56     8 */
»       »       };                                       /*    48    16 */
»       »       struct {
»       »       »       __u64      hint_val;             /*    48     8 */
»       »       »       __u8       hint_type;            /*    56     1 */
»       »       };                                       /*    48    16 */
»       »       __u64              optval;               /*    48     8 */
»       »       __u8               cmd[0];               /*    48     0 */
»       };                                               /*    48    16 */

»       /* size: 64, cachelines: 1, members: 13 */

[2] On 32bit

»       union {
»       »       struct {
»       »       »       __u64      addr3;                /*    48     8 */
»       »       »       __u64      __pad2[1];            /*    56     8 */
»       »       };                                       /*    48    16 */
»       »       struct {
»       »       »       __u64      hint_val;             /*    48     8 */
»       »       »       __u8       hint_type;            /*    56     1 */
»       »       };                                       /*    48    12 */
»       »       __u64              optval;               /*    48     8 */
»       »       __u8               cmd[0];               /*    48     0 */
»       };                                               /*    48    16 */

»       /* size: 64, cachelines: 1, members: 13 */
};

