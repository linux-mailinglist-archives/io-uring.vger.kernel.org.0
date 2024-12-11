Return-Path: <io-uring+bounces-5452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE3719ED876
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 22:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF9B2168BF5
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 21:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A70B1E9B27;
	Wed, 11 Dec 2024 21:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M36mERpS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259531DA0FE;
	Wed, 11 Dec 2024 21:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952108; cv=none; b=m/R7pVuk/8WefpJXKgN2XHJQzP9oEFgVwjbK/Fya98P+sQlPhqI7LCirGprPjjKyEXEtIHCc7SWsPn4h38mLvE7zQS1ZXnYluxuqToVI46qCQNuUzzb0GOQtV91o/Tq5s93A6e9S/dm+Y8EpRqti0xALwruJyOEyF8cVrOUrDq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952108; c=relaxed/simple;
	bh=IaVdboK9++5RQ3hFpt89sE9pHIWJBLcZbpQWyCDkaME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpCwbA1QfvXPzN6dfGRd7tNrzT4AhJAGz+vh06BnS1dPz5v68hUA5Iae2IvZZl8AKykrMfaJqoug2VGPfGOQY2tD8WEr+fEBlbI6ROgwYQAij+csyNnKFcgBfOH0YQQqfz7K8SFj5mWBlJIjuhE9UryLLiTcCqL5CtlrnEU21ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M36mERpS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C98C4CEDD;
	Wed, 11 Dec 2024 21:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733952107;
	bh=IaVdboK9++5RQ3hFpt89sE9pHIWJBLcZbpQWyCDkaME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M36mERpSl2KG6yGOKVFPVUFiFJoJmnzxAr9I9L0WRvuAX9uAMuEwLz0+1j5JVZivX
	 980NduCXsymeKnFsx+atJRTapwFUrOe9lfsH9y+ryYZYSPAUAwBlbFpTsw70lRABVN
	 CrlfulJbyhNZ+n0BHHUZiftbqrf+PqCwsbRHR00oOynDbcF76Xy+PW9tvdG9iWUWO7
	 dsAcCE2tmN3aKOWA4w2MaDqy7C/O3UyRXScbhCnxNAhncze022rUqPFlfFmp6wTfUI
	 ATi05tkiy0cSiSAw7rPPjseZuS1empUiTdZdTuNNZ/GyLEhodhPC7IdjVwWH9sIgRF
	 pzOluCzKOlsoA==
Date: Wed, 11 Dec 2024 21:21:44 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, hch <hch@lst.de>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Javier Gonzalez <javier.gonz@samsung.com>,
	Matthew Wilcox <willy@infradead.org>,
	Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <Z1oCaLF8-xclgFB_@google.com>
References: <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
 <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
 <20241210071253.GA19956@lst.de>
 <2a272dbe-a90a-4531-b6a2-ee7c4c536233@wdc.com>
 <20241210105822.GA3123@lst.de>
 <a10da3f8-9a71-4794-9473-95385ac4e59f@acm.org>
 <6ff84297-d133-48d4-b847-807a75cab0f6@kernel.org>
 <97ed9def-7dfd-4170-9e60-6c081da409bc@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97ed9def-7dfd-4170-9e60-6c081da409bc@acm.org>

On 12/11, Bart Van Assche wrote:
> On 12/10/24 8:07 PM, Damien Le Moal wrote:
> > But for F2FS, the conventional unit is used for metadata and the other zoned LU
> > for data. How come copying from one to the other can be useful ?
> 
> Hi Damien,
> 
> What you wrote is correct in general. If a conventional and zoned LU are
> combined, data is only written to the conventional LU once the zoned LU
> is full. The data on the conventional LU may be migrated to the zoned LU
> during garbage collection. This is why copying from the conventional LU
> to the zoned LU is useful.
> 
> Jaegeuk, please correct me if I got this wrong.

Bart is correct. It doesn't make sense forcing to use conventional LU for
metadata only, but shows the remaining conventional LU space to user as well.
In order to do that, we exploited the multi-partition support in F2FS by
aligning the section to zoned partition offset simply.

> 
> Bart.

