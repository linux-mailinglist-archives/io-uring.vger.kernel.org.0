Return-Path: <io-uring+bounces-4226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E659B6B37
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:44:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1870B20F59
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B765A199FB1;
	Wed, 30 Oct 2024 17:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zImrgFtc"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED171BD9C0;
	Wed, 30 Oct 2024 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730310265; cv=none; b=JDArC4hIe0pDym41u2mgF93bHDYoa6GdUeCHLq0IpsvWQS31phDhY9CVuyPFZw8EDrHnaEis555H9yp72pGs25mdAF6YsPHEpmSel4yw/hvH9rfLG1IVyt4QOzIc0BHG6kJDBga9oA7PTgeWDWfemUV7OcIbG28U1Xv7qeOt03s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730310265; c=relaxed/simple;
	bh=HzoqoQxLAgSlWELkuZ2vWH2LtTb72WtT6taUEEMTrVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gbitq+SIv4T8OtXhfKyWa9D2zVt1ceB5ZKTqTV8lQVkQ6uA+Qj9P4lYBYBnZD54B7rtjY97TOG/ZXSD79EUkKddr07D091OaJHdV5HepD/UGxJgPtr9W2NnVz44dPO5+jfYH67FcsEzMK5ey0cktwOpdEKZbhOjbFeq7PH3Ms0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zImrgFtc; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XdvdL5nBGz6Ckj6M;
	Wed, 30 Oct 2024 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730310256; x=1732902257; bh=XKM46jgi8Yb1+VYNYuSNNFeB
	emqErGUoGTbIhzVz62A=; b=zImrgFtcbi/b+BsWzqM8JJ2ZzeJJgF9nZnCpY0G+
	VfQoLefBtzp2V+h0cHbKPel70cGrwEW0eYQYWPQzC7cqVj03wDJ2dTnFb8n26wT4
	HJe8qhv0hP/eL4QjAmO76lKliGk4pCeWbQGQFv05Vp5K9NjXh8JmFfxnjotq3cwe
	jbmAYDT09ra6N0BbHC7TfHNDEz/AO/Icr2Uebe9/uMgOhfP/sDe9tdQotKlfYOUC
	kz97G3cG4+GOpoWeFB9zuwWI+kDHoo30JT0MIzbOcD4c1rL5JdZ4GPobF6pfkhCN
	djXky8JNaa8HKzFdgT8GwO8SZzwcuwSHYUVKbAf7DAThiA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id r8M1mEJJhr-B; Wed, 30 Oct 2024 17:44:16 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:6fdd:1e16:9f71:469c] (unknown [104.135.204.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xdvd66wP8z6CklsR;
	Wed, 30 Oct 2024 17:44:10 +0000 (UTC)
Message-ID: <f644c6b2-7549-458d-8a24-07aa44c4b4ee@acm.org>
Date: Wed, 30 Oct 2024 10:44:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, javier.gonz@samsung.com,
 Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-10-kbusch@meta.com> <20241029152654.GC26431@lst.de>
 <ZyEAb-zgvBlzZiaQ@kbusch-mbp> <20241029153702.GA27545@lst.de>
 <ZyEBhOoDHKJs4EEY@kbusch-mbp> <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de>
 <c9c2574b-b3be-47ac-8a82-10d92c5892bc@acm.org>
 <20241030171450.GA12580@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241030171450.GA12580@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 10:14 AM, Christoph Hellwig wrote:
> On Wed, Oct 30, 2024 at 09:59:24AM -0700, Bart Van Assche wrote:
>>
>> On 10/29/24 9:55 PM, Christoph Hellwig wrote:
>>> For the temperature hints the only public user I known is rocksdb, and
>>> that only started working when Hans fixed a brown paperbag bug in the
>>> rocksdb code a while ago.  Given that f2fs interprets the hints I suspect
>>> something in the Android world does as well, maybe Bart knows more.
>>
>> UFS devices typically have less internal memory (SRAM) than the size of a
>> single zone.
> 
> That wasn't quite the question.  Do you know what application in android
> set the fcntl temperature hints?

I do not know whether there are any Android apps that use the
F_SET_(FILE_|)RW_HINT fcntls.

The only use case in Android platform code I know of is this one: Daejun
Park, "f2fs-tools: add write hint support", f2fs-dev mailing list,
September 2024 
(https://lore.kernel.org/all/20240904011217epcms2p5a1b15db8e0ae50884429da7be4af4de4@epcms2p5/T/).
As you probably know f2fs-tools is a software package that includes
fsck.f2fs.

Jaegeuk, please correct me if necessary.

Bart.




