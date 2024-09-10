Return-Path: <io-uring+bounces-3102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2562B9735BF
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 12:58:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49C071C23D54
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 10:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F23185B4F;
	Tue, 10 Sep 2024 10:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBp0+qcY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE04185B43;
	Tue, 10 Sep 2024 10:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965880; cv=none; b=Des8TIhw4J7/PUnNzLUMlNpsLCFLYe49Z9N0VNyr5ss4ADDc3aoS9hY40nHmEnBaGUlKyfe9E6b2W+uyLJq4QwLTR5VdcJKz7x9ySB9ZtiY5oCEbIRDFiZFzIRIFKEvDtb3nrTVi8phAvVxCjjIrwSirmG7ftZFjSLBK5xi3uTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965880; c=relaxed/simple;
	bh=pF/tzfuszrq6RsRMAKS2cg91CVLkL87OAR07GZsdNrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IgHq83vPsxuE6EM/JM3+aFSM68gf/C4842TpRmXcAExmeb09lE1NK8ZY/ImoaG+nWS9aZMndcfBbFqdpJlCHJgnSZVduNFVXqQigkKQFbsFu8/DiMQmaJRQa8o4a0ta6MGQheL/tAWlhfyLCmX11nnUIEpxTVj3nt/8CXcWxRlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBp0+qcY; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a8d51a7d6f5so263767366b.2;
        Tue, 10 Sep 2024 03:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725965877; x=1726570677; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SJslusrrfXDGSsSDYUzneHTVhmBl5GEMcjjDhX1iRYg=;
        b=NBp0+qcYqc33xGV/1W3XalyY+FDwdw2lVfol30a4owrAIGXPdbbn7FYxneRkhXXUUq
         xj2Sfr3aWgunKsrwYRvUYymtUEA5CnRbPNuOP3ZcA048REh1DiznKaVDnxcaMrqzI2cq
         D+Fe2OWizQC0tNkKXW8ZkvafG+uQb/G2xkSyaHfguq4l2JhwJaXBV+d5nXj6USgdd8qp
         7HR7t/SV+Ayhw3KumiOukVPF8FFdwJDSlRl7Ro6YCkYbBbiNDttYC0GkEHaHatyOa8+c
         wo4Pn/SeCOU9FD4tUgw4TwLuqyjGYEBipNz6lHnXCRfJRixhHfw0JJhb98S8R7AnW+MG
         ltJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725965877; x=1726570677;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SJslusrrfXDGSsSDYUzneHTVhmBl5GEMcjjDhX1iRYg=;
        b=hVCtvcJRBWdT+y7ICO1aBCYkZWc96bRtdVhIRO2Cl9sQXfye1sxdTGX+lEiXu4RO68
         0ci5XgyTgv/1ByrcjOWKoSy3mEmLh/iFPFnLvTgJ6R/kp/YL7dFLMyU7eM7akbgtptK0
         mDCx856MyztNVOmX4cCtIbrQVBnpVgNRr5bJP+4kUVMEThjecmaupGnSJqq5WfubSCsM
         qGt0jMreOqRaCwnke079XaCjD4se/K57I9f/M6ocGL8YseHFQanN1Xg4UcSNa4RCjZaM
         z17Qs6aJLXvmwVif6HO9zd7zYsiPVqXhV1mb4UF1HaeoYTFUJUs637SiEcMGlCse7js0
         QStw==
X-Forwarded-Encrypted: i=1; AJvYcCUzkZ9vjmGY24TZ5YLplUWrmZbbV2HgweQatxTEgXeSmiS1+3ZTivESIUgUzNAHdL5iYR/yUMQPqtLWwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGo+IOfbiJsm7feORDIv5wAM89Yb0RZMS6o1ievmt9s4Tuj2nA
	TTgTPF/nbF1l3SUR+M5IqgCpVUi/IUV9QUbMFFf8sS1W/fLAJ0gv
X-Google-Smtp-Source: AGHT+IHJrz5lkl252drUfjQ7T3c25l0GDv7hN76cAIIs9WY19rUFlfCKvwm1+Pw85rtaKK0gycWHsw==
X-Received: by 2002:a17:907:c29:b0:a8f:f799:e7d1 with SMTP id a640c23a62f3a-a8ffab7e36amr36896466b.38.1725965876614;
        Tue, 10 Sep 2024 03:57:56 -0700 (PDT)
Received: from [192.168.42.232] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d258354d1sm467851266b.13.2024.09.10.03.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:57:56 -0700 (PDT)
Message-ID: <430ca5b3-6ee1-463b-9e4e-5d0b934578cc@gmail.com>
Date: Tue, 10 Sep 2024 11:58:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/8] block: implement async discard as io_uring cmd
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1725621577.git.asml.silence@gmail.com>
 <7fc0a61ae29190a42e958eddfefd6d44cdf372ad.1725621577.git.asml.silence@gmail.com>
 <Zt_8wlXTyS2E7Xbe@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zt_8wlXTyS2E7Xbe@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 09:01, Christoph Hellwig wrote:
>> +	sector_t sector = start >> SECTOR_SHIFT;
>> +	sector_t nr_sects = len >> SECTOR_SHIFT;
>> +	struct bio *prev = NULL, *bio;
>> +	int err;
>> +
>> +	if (!bdev_max_discard_sectors(bdev))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (!(file_to_blk_mode(cmd->file) & BLK_OPEN_WRITE))
>> +		return -EBADF;
>> +	if (bdev_read_only(bdev))
>> +		return -EPERM;
>> +	err = blk_validate_byte_range(bdev, start, len);
>> +	if (err)
>> +		return err;
> 
> Based on the above this function is misnamed, as it validates sector_t
> range and not a byte range.

Start and len here are in bytes. What do you mean?


>> +	if (nowait && nr_sects > bio_discard_limit(bdev, sector))
>> +		return -EAGAIN;
>> +
>> +	err = filemap_invalidate_pages(bdev->bd_mapping, start,
>> +					start + len - 1, nowait);
>> +	if (err)
>> +		return err;
>> +
>> +	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp))) {
>> +		if (nowait)
>> +			bio->bi_opf |= REQ_NOWAIT;
>> +		prev = bio_chain_and_submit(prev, bio);
>> +	}
>> +	if (!prev)
>> +		return -EAGAIN;
> 
> If a user changes the max_discard value between the check above and
> the loop here this is racy.

If the driver randomly changes it, it's racy either way. What do
you want to protect against?

>> +sector_t bio_discard_limit(struct block_device *bdev, sector_t sector);
> 
> And to be honest, I'd really prefer to not have bio_discard_limit
> exposed.  Certainly not outside a header private to block/.

Which is the other reason why first versions were putting down
a bio seeing that there is more to be done for nowait, which
you didn't like. I can return back to it or narrow the scopre.

>> +
>>   #endif /* __LINUX_BIO_H */
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index 753971770733..7ea41ca97158 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -208,6 +208,8 @@ struct fsxattr {
>>    * (see uapi/linux/blkzoned.h)
>>    */
>>   
>> +#define BLOCK_URING_CMD_DISCARD			_IO(0x12,137)
> 
> Whitespace after the comma please. 

That appears to be the "code style" of all BLK ioctls.

> Also why start at 137?  A comment
> would generally be pretty useful as well.

There is a comment, 2 lines above the new define.

/*
  * A jump here: 130-136 are reserved for zoned block devices
  * (see uapi/linux/blkzoned.h)
  */

Is that your concern?

> Also can we have a include/uapi/linux/blkdev.h for this instead of
> bloating fs.h that gets included just about everywhere?
I don't think it belongs to this series. Regardless, how do you
see it? The new file can have just those several new definitions,
in fs.h we'd have another comment why there is another empty range,
but I don't think it's worth it at all.

Another option is to move there everything block related, and make
fs.h include blkdev.h, which can always be done on top.

-- 
Pavel Begunkov

