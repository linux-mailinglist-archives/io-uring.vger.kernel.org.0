Return-Path: <io-uring+bounces-4620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A5E9C4F0B
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 08:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8C41B257C9
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 07:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E075320B210;
	Tue, 12 Nov 2024 07:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BE1OaoQA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E6220ADDE
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 07:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731394803; cv=none; b=DDXgq1ZBXmVQY9ngTp+WFVRz7QL8tHOKa4kPVTd+v2C85KaAZa6rTralfpDIwqEGIpaHRd8twe08dO9efvQyxoCV6IKzzLHEOuKIXFqujmYVeD6zJ4XpnKpJoNW3fZlqvP+slhFusialBbN/KHDAZ69aBwgAPqWXLYM1BenwpNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731394803; c=relaxed/simple;
	bh=ge4EAtbAhDWGrlZBbShEboGJhVRQtXrSywbdah0VXC8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=n189eNYo/1kfbozKyA0CbgDAELEFEemLYYiepE0WPMa0e+UnsY0b20RwCLX+eOYKi56nZSWgoyddqsHKL7pL73Ds8FvNeiPECtgFlL1zXG25DChhbPhJYLZAlHy1CPg93P+eC4TPJ6ggjSFvzwEvf6IhYausuOlD9D4VoAEMKg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BE1OaoQA; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241112065958epoutp0440e3d47e9dc87785e43416140aab6b4e~HJmVZ0-a73232732327epoutp04C
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 06:59:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241112065958epoutp0440e3d47e9dc87785e43416140aab6b4e~HJmVZ0-a73232732327epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731394798;
	bh=4Z5+bJJ3lf2GerBU+UlP0eirnql7pOfea+SOeiQJ1tg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BE1OaoQA5qbV41WBMmlIb5fzoUHKz+98Dyc0YVLc+gukH/ulTwl73GNhUK8s6d/qJ
	 dS1IuRbNPIlAq3Zj+4J+n0aT3h6JBK4stXYl9c32fwZsW3gVXUuoC9TKlhegcprApI
	 lk884ulmu/ReDGWkkNVaqgPHw2OERdgTmrPMzfWY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241112065957epcas5p2738a8fc89ce5eb098c2c9cf432fc9bba~HJmUxp22F0451904519epcas5p2H;
	Tue, 12 Nov 2024 06:59:57 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xncjl4Mklz4x9Q2; Tue, 12 Nov
	2024 06:59:55 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A8.FA.09800.BECF2376; Tue, 12 Nov 2024 15:59:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241112065916epcas5p27585cf42be369dac28dab40e9821243f~HJluZ-ACY1817918179epcas5p2Q;
	Tue, 12 Nov 2024 06:59:16 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241112065916epsmtrp1077fcca8b716eae7ff7b592dcafd0d74~HJluYRg4W1445314453epsmtrp1j;
	Tue, 12 Nov 2024 06:59:16 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-17-6732fcebca65
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	BA.DC.18937.4CCF2376; Tue, 12 Nov 2024 15:59:16 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241112065914epsmtip16d0889ea24bf1285056da78c58904c49~HJlsB6rGt2220422204epsmtip1b;
	Tue, 12 Nov 2024 06:59:13 +0000 (GMT)
Date: Tue, 12 Nov 2024 12:21:27 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Anuj gupta <anuj1072538@gmail.com>, Christoph Hellwig <hch@lst.de>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v8 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241112065127.GA27622@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <72bb4c21-e597-497f-b54b-d09c6f753d13@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxbVRjGPfeW21ti2aUbcGBgyZ0KYwHaUcpFKBid80aWwJzOxH+6Cjct
	A9qmLQNxCg2rRGB8zCFbgTGCCnQRl/IRPmSQssnAAU4MDCY4FByjgclHnUkFbWkx/Pc7z/s8
	55z3fOAobwULwNOVOkajlGWSmCerc/BwaLj1n6NywVMTn1qz2VlUrakTUDdmyzHKOrgOqOmB
	boRquXEHoVYNYyyqproQoe78u4JRlyyTgOqbOUJ91zfMouq/XmRTJVNdGNU0tI1Q41tDHtS4
	sZb9qjfdbZxl0xOj2bTZ9BlGt32ZT/dOF2D02uIMiy5rNwH63vXbbHrD/AJtXlhBUjzfz4hX
	MLI0RhPMKFNVaelKuYRMOiV9XRotFgjDhbFUDBmslGUxEvLYiZTw4+mZjnbI4HOyzGyHlCLT
	asnIhHiNKlvHBCtUWp2EZNRpmWqROkIry9JmK+URSkb3ilAgOBrtMJ7JUMw/uIypS57PHW03
	ehSAXk4x4OCQEMHa9R5QDDxxHtEL4LLhEttZ4BHrAF6dj3MVHPzV2rzHbqJn7YI70Q1g11Kb
	e/AHgP2DeuB0sYiX4HBd0Q5jRAi8/diwwweII9A6ZWE7AyhxE4WVF1ewYoDj+wkpbP1V4kQu
	EQ6rrBKnnUt4w+GrCywncwgJHFuw7+zOhzgEBzqHEOc0kNjEYeEPt9iu3R2DPR1zwMX74fJQ
	u1sPgE/KP3WzHP49sYi4WA0Lv7/l9idCw0g56mSUUMBHs/2oSw+CVSOtiEv3ghftC+4sF3Zd
	22USFrXUuhnCvrECxNkLJGj4ZCrWdT4/I3DjYQVaAfjGPb0Z9yxndERQ4jD8tifSJfNhYUeN
	Wz4Im7bxPY7rADMBf0atzZIz2mh1lJLJ+f/qU1VZZrDz7sOSusBvj/6MsAAEBxYAcZQ8wA1N
	jpTzuGmyD/MYjUqqyc5ktBYQ7bi1SjTAJ1Xl+DhKnVQoihWIxGKxKDZKLCT9uFZDXRqPkMt0
	TAbDqBnNbg7BOQEFiEXwcY7vlai2zcvb/sK8Hz9659q+sxU2r7cPNW+9+d6F5ruGZ8MVE3X1
	+T+lF/A13wSl+hAn80YHq2At09LSufqYn6HZl2B7GePN2E2DZ8i4OONZff/Mqcm7L+ZGdZRS
	xz9oPm0/t7kUkPRaDQz0fy73r5K3GkRX+KXeeYt6WwyHV3YvMOJkjMn/aVlQIF7ifTNrrpET
	8u5B3ziWeSC4yDdfb/u8lJamJeIjS8LJjImw+vOrohD/pS/ub0kbWs0PK7G+8V+8NuShjXH8
	zWr7/TdmE5fb9QPeyZ/83oRWt8b3W/XJ0345xIOwNvGznFHJXJLQjzphU3icHk/gic83NoST
	LK1CJgxDNVrZf1gYK3uABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWy7bCSnO6RP0bpBpcPylt8/PqbxWLOqm2M
	Fqvv9rNZvD78idHi5oGdTBYrVx9lsnjXeo7FYvb0ZiaLo//fsllMOnSN0WLvLW2LPXtPsljM
	X/aU3aL7+g42i+XH/zFZnP97nNXi/Kw57A6CHjtn3WX3uHy21GPTqk42j81L6j1232xg8/j4
	9BaLR9+WVYweZxYcYff4vEnOY9OTt0wBXFFcNimpOZllqUX6dglcGV/O9jEWrOWs+LD/EXMD
	40+2LkZODgkBE4ldH1sYuxi5OIQEtjNK/DwzjwUiISFx6uUyRghbWGLlv+fsEEVPGCWeTGhn
	BUmwCKhKnJzbDlbEJqAuceR5K5gtIqAt8fr6IbAGZoENzBITe9+CrRMWiJe4teM6UxcjBwev
	gK7E1Ne2EEOvMUlsXrIWrIZXQFDi5MwnYFcwAw39M+8SM0g9s4C0xPJ/HBBheYnmrbOZQWxO
	AVuJc09+s4PYogLKEge2HWeawCg0C8mkWUgmzUKYNAvJpAWMLKsYRVMLinPTc5MLDPWKE3OL
	S/PS9ZLzczcxgqNXK2gH47L1f/UOMTJxMB5ilOBgVhLh1fDXTxfiTUmsrEotyo8vKs1JLT7E
	KM3BoiTOq5zTmSIkkJ5YkpqdmlqQWgSTZeLglGpgsppZfFr4ik5cQt8RmeKNReeO2n/ctk6u
	pjdg4qdPde/i0w93yGsVlN78eF1nRr6dYeKm1S2+jhuu8/FnPbxz+uQ66VDNHRlbk6+YaBbs
	LDN8ePCGsY6U35v/R344WPzIfsk769E/JZnjCx+L7eV5YPHt5/3ozbXWOwLPR71kPNqXF+m7
	/bEYf0lk4IxVOpuOXeVbs6zwu3vjoqfV1mXSTR+tXHQf/C5/qTrjSGH92d4I7pObTWKVcrNT
	z7twF++f6fVJT1FlUkzH7r9nFk9T3rdqp3JzkcYhkXhl3pd1RRutHI8xzUj25uU6KrTUIlla
	KqjBV21/2K7OdQJfLsRtfCoR/M5getfpJ30ePBnuSizFGYmGWsxFxYkA+hd9bk0DAAA=
X-CMS-MailID: 20241112065916epcas5p27585cf42be369dac28dab40e9821243f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_c13de_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f@epcas5p2.samsung.com>
	<20241106121842.5004-7-anuj20.g@samsung.com> <20241107055542.GA2483@lst.de>
	<CACzX3As284BTyaJXbDUYeKB96Hy+JhgDXs+7qqP6Rq6sGNtEsw@mail.gmail.com>
	<72bb4c21-e597-497f-b54b-d09c6f753d13@gmail.com>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_c13de_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Tue, Nov 12, 2024 at 12:54:23AM +0000, Pavel Begunkov wrote:
> On 11/7/24 07:26, Anuj gupta wrote:
> > On Thu, Nov 7, 2024 at 11:25 AM Christoph Hellwig <hch@lst.de> wrote:
> ...
> > > 
> > > struct io_uring_sqe_ext {
> > >          /*
> > >           * Reservered for please tell me what and why it is in the beginning
> > >           * and not the end:
> > >           */
> > >          __u64   rsvd0[4];
> > 
> > This space is reserved for extended capabilities that might be added down
> > the line. It was at the end in the earlier versions, but it is moved
> > to the beginning
> > now to maintain contiguity with the free space (18b) available in the first SQE,
> > based on previous discussions [1].
> > 
> > [1] https://lore.kernel.org/linux-block/ceb58d97-b2e3-4d36-898d-753ba69476be@samsung.com/
> 
> I don't believe it helps much anything, placing a structure on the
> border between SQEs also feels a bit odd.

In next version, I can move it to the beginning of second SQE.

ext_cap also keeps it open to pass the same/different attributes via
user pointer.
Is that fine, or do you want anything else to be changed?

> 
> -- 
> Pavel Begunkov
> 

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_c13de_
Content-Type: text/plain; charset="utf-8"


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_c13de_--

