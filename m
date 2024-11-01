Return-Path: <io-uring+bounces-4321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E2829B96E5
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:54:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3221B1C20A1E
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5C21CDA1E;
	Fri,  1 Nov 2024 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Nw2TZno7"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3797E1CB321
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730483675; cv=none; b=NaR+isfhn42LtDwPRlWk2c83EgAzj6fajcOXGOE98QJqEfwIUAvplb6XqXjbdI01f30LcQx8YopUK1c+GWkSKIrHm1+2JBcrdFFkwT+Ktgye5efznPY2bbBISRihOMYNMYI/K4Esnw8nCCst1xAIVb/YYgv39ZOFc0MKxe6uhvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730483675; c=relaxed/simple;
	bh=ACjPRHF4938imeJvdByUPKKOQmFwdW/Irc+W/vwpLlI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:In-Reply-To:
	 Content-Type:References; b=UsQVwpzj6K/jdCuVtIp/okN9NRORn+YnEVb/4j4ZFZKE4mxpQYLoyju98wvPYTlc54COoucd+ut+0PqD/V9EsAapo/Z38qc31VRTjSLdXzCUlY+CV+iCRiyMDHp784mSXz4OInIvnmQ7lttsa82f/6jkYyO7kn5R2Xa/a0rHwa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Nw2TZno7; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241101175429epoutp03be0d0302aa700d6cb8d92ed1c734f3b8~D6bqoyOpg0377803778epoutp03g
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 17:54:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241101175429epoutp03be0d0302aa700d6cb8d92ed1c734f3b8~D6bqoyOpg0377803778epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730483669;
	bh=c5jILukSrTG9L/qJp/8Gej0z2povjeMHGl5jO0D8TP0=;
	h=Date:From:Subject:To:Cc:In-Reply-To:References:From;
	b=Nw2TZno78l9tlvABsOX9z0rmkhpicF4+nb4/eSmRY1riinm0J/PYloaGtkyfdreAh
	 CImq2P764BQwCkh0pPbkuPh0qhg8boXPe8AGX3ZJ19Jy+pAcT2Qrt4p1H2CZKuvn0h
	 vWAhtaJl/eg1BOz6Kss6wLtyLEhmhudcd60PwNOc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241101175428epcas5p174f072c7185d446f8c447b919b273d26~D6bpfM0MU0354703547epcas5p10;
	Fri,  1 Nov 2024 17:54:28 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Xg7m321Bpz4x9Pp; Fri,  1 Nov
	2024 17:54:27 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.3E.09800.3D515276; Sat,  2 Nov 2024 02:54:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241101175426epcas5p28cd4ef5a2e01db38ff56c3aeaf0b2ca6~D6bnWj7ne1320513205epcas5p2p;
	Fri,  1 Nov 2024 17:54:26 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241101175426epsmtrp2ec9ba1f4ac89e4fb7213a1440da6d111~D6bnVy0jK0075700757epsmtrp2J;
	Fri,  1 Nov 2024 17:54:26 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-d6-672515d3cd85
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B3.5F.07371.2D515276; Sat,  2 Nov 2024 02:54:26 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241101175423epsmtip15b00205ce519e8e19cacac9cec420314~D6bk6BkzR2648426484epsmtip1u;
	Fri,  1 Nov 2024 17:54:23 +0000 (GMT)
Message-ID: <ceb58d97-b2e3-4d36-898d-753ba69476be@samsung.com>
Date: Fri, 1 Nov 2024 23:24:15 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v6 06/10] io_uring/rw: add support to send metadata
 along with read/write
To: Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Content-Language: en-US
In-Reply-To: <914cd186-8d15-4989-ad4e-f7e268cd3266@gmail.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUwTZxzH81yv1ytJx1EkPFSFes4gLGA723o4wTncdomSMZ2b7h+40Fth
	lLb0WvaSuZU5mLgNQdyAwgYYNre6jFCoA4EMW3mTISw4hGa8iJAQEUEck00haz3c+O+T7+/3
	fX4vz/PgAukkJsMzDBbWbGD0JBaAXvRERcUMhmzTKU4+ElH3lh6i1MdFKwKq0nERUBdGT2PU
	rGcRUCPtzQj1w4UOhLqbdw2lKkpPINQZ9xCg2rzPUK1tPShV9d20iPrsRhNGne9aRaj+lS4h
	1W+vFD0fRDfbR0X0YJ+VdjoKMLqh9iO6ZcSG0femvShd2OgA9K/VV0T0fWc47ZyaQ5ID3szc
	k84yWtYsZw1pRm2GQRdPHjickpii1iiUMco4ahcpNzBZbDy5/2ByzEsZet84pDyH0Vt9UjLD
	ceSOhD1mo9XCytONnCWeZE1avUlliuWYLM5q0MUaWMtupULxrNqXmJqZ/nnLAGYa3/buQt3P
	mA2UhJ8CYhwSKuiq7MVOgQBcSrQA2PqJA/EHpMQigJ2zkA/8BaDXOYM9cfxd1Y7ygTYAXXdq
	RLxjDsDz0wl+lhAJ0DU7IPQzSjwNz/UOIrweBHvKp1A/hxARcNxb5vPiOEZEwYESq18OJlLg
	1TtLwM8biIOwpGpR5K8lIJYReL284HFAQIRC71TV4zPFRDycqC9FeT0CnnBVCPwGSCzj8Jdb
	vQjf9X44OvZAwHMwvN3VKOJZBu/fbVubLBNOTE6gPH8AmxoKhTzvhbZHw0J/owJfo3WXdvC1
	noJfPJxC/DIkJPBkvpTP3gLHzkyvOUPhzbLaNaZh41wT4PdWg8CvivNFRUBuX7cW+7rR7OvG
	sf9fuRqgDhDGmrgsHcupTTsN7Dv/3XeaMcsJHj/26ANNYHJiIdYNEBy4AcQF5AbJgmmrTirR
	Mu+9z5qNKWarnuXcQO27n2KBLCTN6PstBkuKUhWnUGk0GlXcTo2SDJXM5n2tlRI6xsJmsqyJ
	NT/xIbhYZkNS/0Q36kvZgp5Isa16a+5zzaeTOvH+XM8/wm86NiXqjmscxzaryTde0I8N7br8
	O1o/vxg8nbT7XLTy1vHIhrA+w/eu4fZDN/KOBWu/7V4twG3XtTWe4CJL4XA1Qbwy+CDD9ls5
	JlNcpTPqX2+tFSd9KXv7SJhnPDGi/OjZzsTLpT/Od+sy33KMyfFydvtQdtTmVwODApH5vX8w
	qyEd3uwZp/i1mfDUCi+5SubHX9livfbTy6IOZfZRrq9vpCOnmEDc28s8brN0n6qbIj22dlvj
	EXb5xaWNDbn7As7eFipyDh/6dCUy0NOivhRoSa9blvRsioVJtpty1AXxooQPs0mUS2eU0QIz
	x/wLle6hs3UEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWy7bCSnO4lUdV0gx9X2Cw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXRs/uC2wF91UrPqzfztbA
	OFmui5GTQ0LAROLn/AMsXYxcHEICuxkl7m/rZoZIiEs0X/vBDmELS6z89xzMFhJ4zSgx9UIF
	iM0rYCex9fUFVhCbRUBFYtHpy0wQcUGJkzOfsIDYogLyEvdvzQDq5eBgE9CUuDC5FMQUFoiX
	2DdTB6RCRMBHYvL8T+wgJzAL/GCS2NZzDWrVQiaJrt+SIDYz0Dm3nswHG88pYCvxYON0Foi4
	mUTX1i5GCFteonnrbOYJjEKzkFwxC0n7LCQts5C0LGBkWcUomVpQnJuem2xYYJiXWq5XnJhb
	XJqXrpecn7uJERzDWho7GO/N/6d3iJGJg/EQowQHs5II74cC5XQh3pTEyqrUovz4otKc1OJD
	jNIcLErivIYzZqcICaQnlqRmp6YWpBbBZJk4OKUamKJDv2i9+Pv5zCYXsXLGgz5JuYezp6+X
	6lq2szDiqz93+EKtk//W83//Gtn26mBiAP+B7KfL/yWHvRB9cfIq02u2FSsK2Ta2h6b0XhFj
	ifubK66woPPXnPZ5b79uyZ6aOTMvP/n37prDKuri1vcqOV3cr8T6NSYt2sFb73C7p3dlbMjT
	VqOYI9Vrzu8OejzPIE1xjpL96Z7M0Hl1E7YuvBkfoT/9aPB9i5I1qfN2s/xP3Xs5dN0OJ+HN
	H3P+yn/8+cz3qeupS48f80pHRn/jYqp7ldBY82LKSRmTR459n2dPPZEpyOvyK5rhppTf3NiM
	qyxZiw08TX7/k9t5ynWOzOnzzM1TlINe/7BfJJzpv1GJpTgj0VCLuag4EQCSpVXGUAMAAA==
X-CMS-MailID: 20241101175426epcas5p28cd4ef5a2e01db38ff56c3aeaf0b2ca6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181013epcas5p2762403c83e29c81ec34b2a7755154245
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com>
	<20241030180112.4635-7-joshi.k@samsung.com>
	<ZyKghoCwbOjAxXMz@kbusch-mbp.dhcp.thefacebook.com>
	<914cd186-8d15-4989-ad4e-f7e268cd3266@gmail.com>

On 10/31/2024 8:09 PM, Pavel Begunkov wrote:
> On 10/30/24 21:09, Keith Busch wrote:
>> On Wed, Oct 30, 2024 at 11:31:08PM +0530, Kanchan Joshi wrote:
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/ 
>>> io_uring.h
>>> index 024745283783..48dcca125db3 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -105,6 +105,22 @@ struct io_uring_sqe {
>>>            */
>>>           __u8    cmd[0];
>>>       };
>>> +    /*
>>> +     * If the ring is initialized with IORING_SETUP_SQE128, then
>>> +     * this field is starting offset for 64 bytes of data. For meta io
>>> +     * this contains 'struct io_uring_meta_pi'
>>> +     */
>>> +    __u8    big_sqe[0];
>>> +};
> 
> I don't think zero sized arrays are good as a uapi regardless of
> cmd[0] above, let's just do
> 
> sqe = get_sqe();
> big_sqe = (void *)(sqe + 1)
> 
> with an appropriate helper.

In one of the internal version I did just that (i.e., sqe + 1), and 
that's fine for kernel.
But afterwards added big_sqe so that userspace can directly access 
access second-half of SQE_128. We have the similar big_cqe[] within 
io_uring_cqe too.

Is this still an eyesore?

>>> +
>>> +/* this is placed in SQE128 */
>>> +struct io_uring_meta_pi {
>>> +    __u16        pi_flags;
>>> +    __u16        app_tag;
>>> +    __u32        len;
>>> +    __u64        addr;
>>> +    __u64        seed;
>>> +    __u64        rsvd[2];
>>>   };
>>
>> On the previous version, I was more questioning if it aligns with what
> 
> I missed that discussion, let me know if I need to look it up

Yes, please take a look at previous iteration (v5):
https://lore.kernel.org/io-uring/e7aae741-c139-48d1-bb22-dbcd69aa2f73@samsung.com/

Also the corresponding code, since my other answers will use that.

>> Pavel was trying to do here. I didn't quite get it, so I was more
>> confused than saying it should be this way now.
> 
> The point is, SQEs don't have nearly enough space to accommodate all
> such optional features, especially when it's taking so much space and
> not applicable to all reads but rather some specific  use cases and
> files. Consider that there might be more similar extensions and we might
> even want to use them together.
> 
> 1. SQE128 makes it big for all requests, intermixing with requests that
> don't need additional space wastes space. SQE128 is fine to use but at
> the same time we should be mindful about it and try to avoid enabling it
> if feasible.

Right. And initial versions of this series did not use SQE128. But as we 
moved towards passing more comprehensive PI information, first SQE was 
not enough. And we thought to make use of SQE128 rather than taking 
copy_from_user cost.

 > 2. This API hard codes io_uring_meta_pi into the extended part of the
> SQE. If we want to add another feature it'd need to go after the meta
> struct. SQE256?

Not necessarily. It depends on how much extra space it needs for another 
feature. To keep free space in first SQE, I chose to place PI in the 
second one. Anyone requiring 20b (in v6) or 18b (in v5) space, does not 
even have to ask for SQE128.
For more, they can use leftover space in second SQE (about half of 
second sqe will still be free). In v5, they have entire second SQE if 
they don't want to use PI.
If contiguity is a concern, we can move all PI bytes (about 32b) to the 
end of second SQE.


 > And what if the user doesn't need PI but only the second
> feature?

Not this version, but v5 exposed meta_type as bit flags.
And with that, user will not pass the PI flag and that enables to use 
all the PI bytes for something else. We will have union of PI with some 
other info that is known not to co-exist.

> In short, the uAPI need to have a clear vision of how it can be used
> with / extended to multiple optional features and not just PI.
> 
> One option I mentioned before is passing a user pointer to an array of
> structures, each would will have the type specifying what kind of
> feature / meta information it is, e.g. META_TYPE_PI. It's not a
> complete solution but a base idea to extend upon. I separately
> mentioned before, if copy_from_user is expensive we can optimise it
> with pre-registering memory. I think Jens even tried something similar
> with structures we pass as waiting parameters.
> 
> I didn't read through all iterations of the series, so if there is
> some other approach described that ticks the boxes and flexible
> enough, I'd be absolutely fine with it.

Please just read v5. I think it ticks as many boxes as possible without 
having to resort to copy_from_user.


