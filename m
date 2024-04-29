Return-Path: <io-uring+bounces-1676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE85E8B634B
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 22:11:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BD5F1F2142A
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 20:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B641411DC;
	Mon, 29 Apr 2024 20:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Xh1KsC9o"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126E41411D9
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 20:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714421503; cv=none; b=rWQUuEZ2QfZ+k1wuODZLo6ZEuTStVrYUOFlj52PFhlpdVQCQ+fgRoeHFxL66GWTnd2FbDEbULVHTj0jDweU+nt6SgD4N1SQZmVkZM1QVmP2FrLAaOGKETALQlDHNwpuNvJYJk4PjMPVQlQA3uDrKNNc1ZcySUgxi9xPNYPn9qKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714421503; c=relaxed/simple;
	bh=WEWQN5o56I3YJ/AUz00bONPDVK4LPQhYPThgN0/ZIYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Mx2woMEEoNOA9kctX2wkcZDWgQppoYNAl7nyxMcA/hZHMXUsnVs91Man+afENvxt3xHH+eU8ZIg3d6Kxx2/KWmksEt9MrK4h34uxbkgWsLvNzG65k5FvA+DOcm1v/sS2s3Cy0+G7rmo0SZVbGp3u8S6+cGE9fpabLKnlPD8tAJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Xh1KsC9o; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240429201138epoutp03b7de440133bd22e88d2a8636d1ac6a56~K2UUJPpz02592325923epoutp03b
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 20:11:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240429201138epoutp03b7de440133bd22e88d2a8636d1ac6a56~K2UUJPpz02592325923epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714421498;
	bh=NkQa6E/G7D+kT+TNHA4Xlk1TA770QfnquVFmByHOQUU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Xh1KsC9oFzpllzHgYkWS36mL2jfZ+3YDhPEgJXQq5wSd45NVbVep3CwisJ8Jzg7CI
	 E2WCO6Od6oECxuk4ZNLW4O8ONYYshXcqL78GyNc4PW6D9NqbDg41sDdNztQ04EUhGV
	 mNkdCnbWvaC3Ay7Y+PcOGh0fr+iXdTOqUMTi+QwA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240429201137epcas5p4b11bc6b16e2594f7e9afcf562e2b0249~K2US0rsN11144111441epcas5p4c;
	Mon, 29 Apr 2024 20:11:37 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VSvc80ySdz4x9Pq; Mon, 29 Apr
	2024 20:11:36 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6F.B1.09665.7FEFF266; Tue, 30 Apr 2024 05:11:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240429201135epcas5p488c04012edb75b73264adf8723a1262c~K2URUWGgj1144011440epcas5p4R;
	Mon, 29 Apr 2024 20:11:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240429201135epsmtrp1af0774e0887d8aa88f1da7c52e04e6fc~K2URTTsDH3109031090epsmtrp1x;
	Mon, 29 Apr 2024 20:11:35 +0000 (GMT)
X-AuditID: b6c32a4b-829fa700000025c1-ae-662ffef77070
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5E.40.08924.7FEFF266; Tue, 30 Apr 2024 05:11:35 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240429201133epsmtip1c7bb2e34e7e468eab43eb387c3b6b37c~K2UPbpOAA2816128161epsmtip1f;
	Mon, 29 Apr 2024 20:11:33 +0000 (GMT)
Message-ID: <2e8eb4e8-beb2-51cd-67b5-75e920c9fff4@samsung.com>
Date: Tue, 30 Apr 2024 01:41:32 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 08/10] io_uring/rw: add support to send meta along with
 read/write
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com,
	kbusch@kernel.org, hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Nitesh Shetty
	<nj.shetty@samsung.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <f3489d0c-2d27-4e27-ae49-df2e9dad2e00@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmlu6Pf/ppBl8OMFk0TfjLbDFn1TZG
	i9V3+9ksXh/+xGjxasZaNoubB3YyWaxcfZTJ4l3rORaLSYeuMVrsvaVtMX/ZU3aL5cf/MVls
	+z2f2YHX49qMiSweO2fdZfe4fLbUY9OqTjaPzUvqPXbfbGDz+Pj0FotH35ZVjB6fN8kFcEZl
	22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
	UwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM54
	+fkcc8FzvYqWBXcYGxibVbsYOTkkBEwkXi17ww5iCwnsZpT4vjWji5ELyP7EKHFu/V92COcb
	o8SWnkdsMB3XZ/5jg0jsZZT4uGMvM4TzllHizNq/YLN4Bewk7q84D9bBIqAqcfTmX2aIuKDE
	yZlPWEBsUYFkiZ9dB8BqhAUiJB48egNWwywgLnHryXwmEFtEoFBix6mrYNuYBZ4zSlyZ95W1
	i5GDg01AU+LC5FKQGk4BW4lHl1ewQvTKS2x/OwfsIAmBKxwSP680M0Gc7SLRf/MHC4QtLPHq
	+BZ2CFtK4mV/G5SdLHFp5jmo+hKJx3sOQtn2Eq2n+plB9jID7V2/Sx9iF59E7+8nTCBhCQFe
	iY42IYhqRYl7k56yQtjiEg9nLIGyPSTuXJrEDAnqN4wShx4kT2BUmIUUKrOQfD8LyTezEBYv
	YGRZxSiZWlCcm55abFpgnJdaDo/v5PzcTYzgNK3lvYPx0YMPeocYmTgYDzFKcDArifBOWaif
	JsSbklhZlVqUH19UmpNafIjRFBg9E5mlRJPzgZkiryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQh
	gfTEktTs1NSC1CKYPiYOTqkGphPiL0Obazj5JOViA6fybrnQNEFvicG536XP3jW5SQfcXH9y
	omqib8VR/d6Wyxfmqum0Gc14vdL9lHKaCrP51bCNRg/1+E5LHLtZvbjOUS588l++3U+PiT6v
	eW/B9ejcFrnqNcJrXnnrNHpcmFZpclI9z6e1MeN7ZcmWJOcErYdncli+7dTz3taVbHIrLkj7
	Vc9S95WfF5zd3flOIbtohtBsvxjZRwFZe/nXBjVUcW5qKNujdu3acru0GotLnZ9LSjdm+TyU
	2XH7yMLgIsUv9S8DZn5Pdw87/e1SvXLcVaXdzBuFvwbdnht2s0G++7NT9kbO00eKrh0oe3hW
	a3KWuHPSpYbfzHZnJK27dlkVKrEUZyQaajEXFScCAGuYoWhcBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWy7bCSnO73f/ppBl0z5C2aJvxltpizahuj
	xeq7/WwWrw9/YrR4NWMtm8XNAzuZLFauPspk8a71HIvFpEPXGC323tK2mL/sKbvF8uP/mCy2
	/Z7P7MDrcW3GRBaPnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Pm+QCOKO4
	bFJSczLLUov07RK4Ml5+Psdc8FyvomXBHcYGxmbVLkZODgkBE4nrM/+xdTFycQgJ7GaUWDx3
	JjtEQlyi+doPKFtYYuW/5+wQRa8ZJe6132MESfAK2EncX3GeDcRmEVCVOHrzLzNEXFDi5Mwn
	LCC2qECyxMs/E8EGCQtESDx49Aashhlowa0n85lAbBGBQonde56DXcEs8JxR4s+vXawQ294w
	Ssxd1AdUxcHBJqApcWFyKUgDp4CtxKPLK1ghBplJdG3tYoSw5SW2v53DPIFRaBaSO2Yh2TcL
	ScssJC0LGFlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEx6WW5g7G7as+6B1iZOJg
	PMQowcGsJMI7ZaF+mhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe8Re9KUIC6YklqdmpqQWpRTBZ
	Jg5OqQamFRclA+/7t6ZtMb958n5b5IcU8YwZTzNPHXFz9WLdUBG86d3ty99+C/btf5C3Oi2q
	SjjslfDK10/vGk+ML1ikPCvNsuhUw17/f5ejn5zSP9N16ElOT8urvRLWRhf1prorbdE70q1+
	9qpqu9n+sBWTWxM1jrYt1AgNjnK483iPXqA1f11gkYKg0hHxyTK+JrUmTrnLmVnfF5soRG3Z
	YdNyf5ZDYlfI3PtVPwo7nkxnnXb7UVCqzNzy7aUrshjMij2Lrjf/Tt6ZtjnNjbsqQLQ140sT
	q/SV3tdRZbr+O/tE3y5Q4lnPH2k4yUU1c5ldlm7/H4Y/rxUuL/paIDGVP9mA+/fR7EKTOSxd
	hZdOxSuxFGckGmoxFxUnAgBgGPlyOgMAAA==
X-CMS-MailID: 20240429201135epcas5p488c04012edb75b73264adf8723a1262c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184706epcas5p1d75c19d1d1458c52fc4009f150c7dc7d
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184706epcas5p1d75c19d1d1458c52fc4009f150c7dc7d@epcas5p1.samsung.com>
	<20240425183943.6319-9-joshi.k@samsung.com>
	<f3489d0c-2d27-4e27-ae49-df2e9dad2e00@kernel.dk>

On 4/26/2024 7:55 PM, Jens Axboe wrote:
>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>> index 3134a6ece1be..b2c9ac91d5e5 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -587,6 +623,8 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
>>   
>>   		req->flags &= ~REQ_F_REISSUE;
>>   		iov_iter_restore(&io->iter, &io->iter_state);
>> +		if (unlikely(rw->kiocb.ki_flags & IOCB_USE_META))
>> +			iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
>>   		return -EAGAIN;
>>   	}
>>   	return IOU_ISSUE_SKIP_COMPLETE;
> This puzzles me a bit, why is the restore now dependent on
> IOCB_USE_META?

Both saving/restore for meta is under this condition (so seemed natural).
Also, to avoid growing "struct io_async_rw" too much, this patch keeps 
keeps meta/iter_meta_state in the same memory as wpq. So doing this 
unconditionally can corrupt wpq for buffered io.

>> @@ -768,7 +806,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>>   	if (!(req->flags & REQ_F_FIXED_FILE))
>>   		req->flags |= io_file_get_flags(file);
>>   
>> -	kiocb->ki_flags = file->f_iocb_flags;
>> +	kiocb->ki_flags |= file->f_iocb_flags;
>>   	ret = kiocb_set_rw_flags(kiocb, rw->flags);
>>   	if (unlikely(ret))
>>   		return ret;
>> @@ -787,7 +825,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>>   		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
>>   			return -EOPNOTSUPP;
>>   
>> -		kiocb->private = NULL;
>> +		if (likely(!(kiocb->ki_flags & IOCB_USE_META)))
>> +			kiocb->private = NULL;
>>   		kiocb->ki_flags |= IOCB_HIPRI;
>>   		kiocb->ki_complete = io_complete_rw_iopoll;
>>   		req->iopoll_completed = 0;
> 
> Why don't we just set ->private generically earlier, eg like we do for
> the ki_flags, rather than have it be a branch in here?

Not sure if I am missing what you have in mind.
But kiocb->private was set before we reached to this point (in 
io_rw_meta). So we don't overwrite that here.

>> @@ -853,7 +892,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>>   	} else if (ret == -EIOCBQUEUED) {
>>   		return IOU_ISSUE_SKIP_COMPLETE;
>>   	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
>> -		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
>> +		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req) ||
>> +		   (kiocb->ki_flags & IOCB_USE_META)) {
>>   		/* read all, failed, already did sync or don't want to retry */
>>   		goto done;
>>   	}
> 
> Would it be cleaner to stuff that IOCB_USE_META check in
> need_complete_io(), as that would closer seem to describe why that check
> is there in the first place? With a comment.

Yes, will do.

>> @@ -864,6 +904,12 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>>   	 * manually if we need to.
>>   	 */
>>   	iov_iter_restore(&io->iter, &io->iter_state);
>> +	if (unlikely(kiocb->ki_flags & IOCB_USE_META)) {
>> +		/* don't handle partial completion for read + meta */
>> +		if (ret > 0)
>> +			goto done;
>> +		iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
>> +	}
> 
> Also seems a bit odd why we need this check here, surely if this is
> needed other "don't do retry IOs" conditions would be the same?

Yes, will revisit.
>> @@ -1053,7 +1099,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>>   		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
>>   			goto ret_eagain;
>>   
>> -		if (ret2 != req->cqe.res && ret2 >= 0 && need_complete_io(req)) {
>> +		if (ret2 != req->cqe.res && ret2 >= 0 && need_complete_io(req)
>> +				&& !(kiocb->ki_flags & IOCB_USE_META)) {
>>   			trace_io_uring_short_write(req->ctx, kiocb->ki_pos - ret2,
>>   						req->cqe.res, ret2);
> 
> Same here. Would be nice to integrate this a bit nicer rather than have
> a bunch of "oh we also need this extra check here" conditions.

Will look into this too.
>> @@ -1074,12 +1121,33 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>>   	} else {
>>   ret_eagain:
>>   		iov_iter_restore(&io->iter, &io->iter_state);
>> +		if (unlikely(kiocb->ki_flags & IOCB_USE_META))
>> +			iov_iter_restore(&io->meta.iter, &io->iter_meta_state);
>>   		if (kiocb->ki_flags & IOCB_WRITE)
>>   			io_req_end_write(req);
>>   		return -EAGAIN;
>>   	}
>>   }
> 
> Same question here on the (now) conditional restore.

Did not get the concern. Do you prefer it unconditional.

>> +int io_rw_meta(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
>> +	struct io_async_rw *io = req->async_data;
>> +	struct kiocb *kiocb = &rw->kiocb;
>> +	int ret;
>> +
>> +	if (!(req->file->f_flags & O_DIRECT))
>> +		return -EOPNOTSUPP;
> 
> Why isn't this just caught at init time when IOCB_DIRECT is checked?

io_rw_init_file() gets invoked after this, and IOCB_DIRECT check is only 
for IOPOLL situation. We want to check/fail it regardless of IOPOLL.

> 
>> +	kiocb->private = &io->meta;
>> +	if (req->opcode == IORING_OP_READ_META)
>> +		ret = io_read(req, issue_flags);
>> +	else
>> +		ret = io_write(req, issue_flags);
>> +
>> +	return ret;
>> +}
> 
> kiocb->private is a bit of an odd beast, and ownership isn't clear at
> all. It would make the most sense if the owner of the kiocb (eg io_uring
> in this case) owned it, but take a look at eg ocfs2 and see what they do
> with it... I think this would blow up as a result.

Yes, ocfs2 is making use of kiocb->private. But seems that's fine. In 
io_uring we use the field only to send the information down. ocfs2 (or 
anything else unaware of this interface) may just overwrite the 
kiocb->private.
If the lower layer want to support meta exchange, it is supposed to 
extract meta-descriptor from kiocb->private before altering it.

This case is same for block direct path too when we are doing polled io.

