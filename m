Return-Path: <io-uring+bounces-4919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF41D9D4E62
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:13:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7075E2817CB
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A661DB527;
	Thu, 21 Nov 2024 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MgGIjaE8"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427FE1DB34B
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732198354; cv=none; b=sF/Jn8mDJj+01+AXRcGDULPxkU6y6OhbCNhYrWpwtuWMrnZy3bJd23Hh6yH0o6B5LVgqc2OVipFx5tksfcgh5a48wfCSti9FGfGTszrTdjP0p1CDzOtvCqV/40aqcSiyliWvi897jKulPm0xJNFtPq3D8uiZK6HS/uUefoJvMUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732198354; c=relaxed/simple;
	bh=s8vT+cUuucQdxZxmr6s3Mt1TxHz4+30DjZa8lMoNy0M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=GpwZvAmF4kVvoDmWrWizV6SY8ZJjhs8+/b1JufHNjmHbGtg5yHxtBAH0RIv8j22Bq3p3/b/mFcAZww9pYSonlE7Gt1K88M7HGagiUJb0Z+hOq97QhAfASD5Y5I6LjmXimX4UTIjxvQuAg3AgURqFNUworcg2ASFpJP9po1dSYv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MgGIjaE8; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241121141222epoutp013f916861ea7eabf34f2f9055c32cbace~KATcHArOq0339703397epoutp01A
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:12:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241121141222epoutp013f916861ea7eabf34f2f9055c32cbace~KATcHArOq0339703397epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732198342;
	bh=/jFwQg3L6x/QhXsFJXEKX5/pdgnqKEpG97iSSGqG2AQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MgGIjaE8zz8oICK69FcTaoU/3lQRGz7bdLX36BIgEQ0PFLCk3kfnhMXfuE422mNlV
	 k1tHAH4nAV6RvalLa7Jr7zV7s3w/ozZM2QbaSk7R7Xx/vRoTGEbc+/ebGskiNMNjBU
	 RnIlTe3+uG8BCj6EYZIvFC7hgK7a9US6b3jS7pz4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241121141221epcas5p1f717aaf925a0e63cae2e559997bef624~KATbGu9Mz2866128661epcas5p1K;
	Thu, 21 Nov 2024 14:12:21 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XvKtW4QNGz4x9Pq; Thu, 21 Nov
	2024 14:12:19 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F0.1C.20052.3CF3F376; Thu, 21 Nov 2024 23:12:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241121090727epcas5p378eff726d8ab3b727ff96ac6c8dd351d~J8JNJZAAv1902619026epcas5p3K;
	Thu, 21 Nov 2024 09:07:27 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241121090727epsmtrp22645c4c5508c147abbbe8e26eda3f86f~J8JNHeYKv1714217142epsmtrp2T;
	Thu, 21 Nov 2024 09:07:27 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-a1-673f3fc30d21
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	3F.3A.18937.E48FE376; Thu, 21 Nov 2024 18:07:26 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241121090724epsmtip223faf39b7052c34ce93410208c8e6f41~J8JK2_6n-0612906129epsmtip2I;
	Thu, 21 Nov 2024 09:07:24 +0000 (GMT)
Date: Thu, 21 Nov 2024 14:29:35 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241121085935.GA3851@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJsWRmVeSWpSXmKPExsWy7bCmlu5he/t0g/418hYfv/5msZizahuj
	xeq7/WwWrw9/YrS4eWAnk8XK1UeZLN61nmOxmD29mcni6P+3bBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAV1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QO0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpSc
	ApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iy1bz4zFryWq5j55yBjA+MJiS5GTg4JAROJra8b
	WLoYuTiEBHYzSjQfbWWFcD4xSqz7sYYJztn4/hkjTEtzz3dGiMRORokFKx+wQzjPGCX2zP7L
	BFLFIqAqseL9BGYQm01AXeLI81awbhEBbYnX1w+BNTALLGSWaLr5nx0kISwQI3H9zhRWEJtX
	QEdi3YddULagxMmZT1hAbE4BW4mtH8+zgdiiAsoSB7YdB7tPQuAJh8TvzhvsEPe5SDw/94AJ
	whaWeHV8C1RcSuLzu71sEHa6xI/LT6FqCiSaj+2D+s1eovVUP9jVzAIZEtO+X4SqkZWYemod
	E0ScT6L39xOoOK/EjnkwtpJE+8o5ULaExN5zDVC2h8SfF3OgAfmDSeLf3N3MExjlZyF5bhaS
	fRC2jsSC3Z/YZjFyANnSEsv/cUCYmhLrd+kvYGRdxSiZWlCcm55abFpgmJdaDo/z5PzcTYzg
	BK/luYPx7oMPeocYmTgYDzFKcDArifA6KNmnC/GmJFZWpRblxxeV5qQWH2I0BcbWRGYp0eR8
	YI7JK4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBiWHxzOMbX3J2
	PZt2xU8/LGJGtviLQBepMFUuPdFXn+bLeG3L7z8Yl3BxcpiMkpbIob9n9IOzrkt+frX79Af3
	bL85e/Rdbn75z1LRUix7a959VlGH06t7zisUrd1t5e9TFtHh1DNXI0Sttfx+yqwfNvwX7PeW
	1CWJvBQ0/X5Y74v0j7QX6fkrWH5GpFz+/fxjyvMz914eEpHNsvd4dv/fouTlFblBd8/yP11t
	7fh1076jt/QSfj5VVS+fftVPl6c17vPzlVo1MgdTssSWNB3Rtbr+NGyWEONRm8s9636tfdYV
	t9fShvH8kjV5xQ2tBRNCez+ukjz/d5qosOrmqjnzOhxW/TFOYMlZMlWRb7e9rxJLcUaioRZz
	UXEiADr6Ruh5BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSvK7fD7t0g4/PrC0+fv3NYjFn1TZG
	i9V3+9ksXh/+xGhx88BOJouVq48yWbxrPcdiMXt6M5PF0f9v2SwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArigum5TUnMyy1CJ9uwSujDcbO9kLVstUfGk/wt7A
	uFCsi5GTQ0LARKK55ztjFyMXh5DAdkaJZR1NbBAJCYlTL5cxQtjCEiv/PWeHKHrCKPGv6wMT
	SIJFQFVixfsJzCA2m4C6xJHnrWANIgLaEq+vH2IHsZkFFjNLTG6IArGFBWIkrt+Zwgpi8wro
	SKz7sIsVYugPJomXl2ZCJQQlTs58wgLRrCVx499LoGUcQLa0xPJ/HCBhTgFbia0fz4MdKiqg
	LHFg23GmCYyCs5B0z0LSPQuhewEj8ypG0dSC4tz03OQCQ73ixNzi0rx0veT83E2M4GjUCtrB
	uGz9X71DjEwcjIcYJTiYlUR4q3Wt04V4UxIrq1KL8uOLSnNSiw8xSnOwKInzKud0pggJpCeW
	pGanphakFsFkmTg4pRqYNh7U+fCfc4ukXPuvaeGeXp7uNssvzTjlU3d80ss3j1Vffjy6W45R
	0PnSo2lRGT1eHwuWn/srZbMjjU+87/De3kMBQq8KFrwMvLpL1uj6Z29TEasZWv8Wdxd8aYlO
	vra9XbVE1JWx4p+sre3z/V2fums/P+4z2tzyyyz3TsrBXxw/3s/d51G8Zv/dOXGXF908/jb7
	wyRzXwdpZ1GBXQ+/XzKbfmB7gXsC//zblh8sW3jnOfBc2eP0Q6FnebRrXlRtWXTkg6+9Z3xv
	nVR69tjTSFNc7daqravTPy25aebyL77//pq2pVHLOTztz8Q2rl4yZ2+QV8XTGbfXPlh/3DKe
	jbHV9prb532ssidXG34NOaLEUpyRaKjFXFScCAAxVp8INQMAAA==
X-CMS-MailID: 20241121090727epcas5p378eff726d8ab3b727ff96ac6c8dd351d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_1e8c2_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
	<20241114104517.51726-7-anuj20.g@samsung.com>
	<c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com>
	<b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com>
	<20241118125029.GB27505@lst.de>
	<2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com>

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_1e8c2_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Nov 18, 2024 at 04:59:22PM +0000, Pavel Begunkov wrote:
> On 11/18/24 12:50, Christoph Hellwig wrote:
> > On Sat, Nov 16, 2024 at 12:32:25AM +0000, Pavel Begunkov wrote:
> > > We can also reuse your idea from your previous iterations and
> > > use the bitmap to list all attributes. Then preamble and
> > > the explicit attr_type field are not needed, type checking
> > > in the loop is removed and packing is better. And just
> > > by looking at the map we can calculate the size of the
> > > array and remove all size checks in the loop.
> > 
> > Can we please stop overdesigning the f**k out of this?  Really,
> 
> Please stop it, it doesn't add weight to your argument. The design
> requirement has never changed, at least not during this patchset
> iterations.
> 
> > either we're fine using the space in the extended SQE, or
> > we're fine using a separate opcode, or if we really have to just
> > make it uring_cmd.  But stop making thing being extensible for
> > the sake of being extensible.
> 
> It's asked to be extendible because there is a good chance it'll need to
> be extended, and no, I'm not suggesting anyone to implement the entire
> thing, only PI bits is fine.
> 
> And no, it doesn't have to be "this or that" while there are other
> options suggested for consideration. And the problem with the SQE128
> option is not even about SQE128 but how it's placed inside, i.e.
> at a fixed spot.
> 
> Do we have technical arguments against the direction in the last
> suggestion? It's extendible and _very_ simple. The entire (generic)
> handling for the bitmask approach for this set would be sth like:
> 
> struct sqe {
> 	u64 attr_type_mask;
> 	u64 attr_ptr;
> };
> if (sqe->attr_type_mask) {
> 	if (sqe->attr_type_mask != TYPE_PI)
> 		return -EINVAL;
> 
> 	struct uapi_pi_structure pi;
> 	copy_from_user(&pi, sqe->attr_ptr, sizeof(pi));
> 	hanlde_pi(&pi);
> }
> 
> And the user side:
> 
> struct uapi_pi_structure pi = { ... };
> sqe->attr_ptr = &pi;
> sqe->attr_type_mask = TYPE_PI;
>

How about using this, but also have the ability to keep PI inline. 
Attributes added down the line can take one of these options:
1. If available space in SQE/SQE128 is sufficient for keeping attribute
fields, one can choose to keep them inline and introduce a TYPE_XYZ_INLINE
attribute flag.
2. If the available space is not sufficient, pass the attribute information
as pointer and introduce a TYPE_XYZ attribute flag.
3. One can choose to support a attribute via both pointer and inline scheme.
The pointer scheme can help with scenarios where user wants to avoid SQE128
for whatever reasons (e.g. mixed workload).

Something like this:

// uapi/.../io_uring.h

struct sqe {
	...
	u64 attr_type_mask;
	u64 attr_ptr;
};

// kernel space

if (sqe->attr_type_mask) {
	struct uapi_pi_struct pi, *piptr;

	if ((sqe->attr_type_mask & TYPE_PI_INLINE) &&
	    (sqe->attr_type_mask & TYPE_PI))
		return -EINVAL;
	/* inline PI case */
	if (sqe->attr_type_mask & TYPE_PI_INLINE) {
		if (!(ctx->flags & IORING_SETUP_SQE128))
			return -EINVAL;
		piptr = (sqe + 1);
	} else if (sqe->attr_type_mask & TYPE_PI) {
	/* indirect PI case */
		copy_from_user(&pi, sqe->attr_ptr, sizeof(pi));
		piptr = &pi;
	}

	handle_pi(piptr);
	
}

And the user side:

// send PI using pointer:

struct uapi_pi_structure pi = { ... };
sqe->attr_ptr = &pi;
sqe->attr_type_mask = TYPE_PI;

// send PI inline:

/* setup a big-sqe ring */
struct uapi_pi_structure *pi = (sqe+1);
prepare_pi(pi);
sqe->attr_type_mask = TYPE_PI_INLINE;


------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_1e8c2_
Content-Type: text/plain; charset="utf-8"


------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_1e8c2_--

