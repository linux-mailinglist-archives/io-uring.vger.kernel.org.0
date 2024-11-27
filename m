Return-Path: <io-uring+bounces-5085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 375AC9DAD49
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 19:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5136281A02
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 18:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7AE02010F0;
	Wed, 27 Nov 2024 18:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KxeChMC2"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E027F20102D;
	Wed, 27 Nov 2024 18:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732732970; cv=none; b=Y5kEoVB3UIsrQSeeLsOswpb3+HlLPI23l1dEpnB56NTzC+/DzRiucBNcg/FBjn/IkOPzXd2kqGywn/EdBdsYr1mkbiNj3fKpiYVEc8kBjg/Fwa4tS6na62Hmz8DeiJgjUuGGf6TKiyzSvbd3ol1CizZKb4jFrf0RgH9j8sySv+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732732970; c=relaxed/simple;
	bh=0Zz7daY/ckin9t0dZo+dfCS6qt5Sj8Q0wzVIPJ1JSN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GBSAf6G4bD6VUZ3xQXom9Ha5HH6wE2RryjnacSHL+LYfI1oxfkK8OlrRAQschj5JOau/Qo9zUmlODnCakoTedCUwDrgxtOUtDIIvu6h5QOWhs8jR3NGi+z1jJm2ALJypYyNPETcvT0zCtCuXzen2qkpN3UQaUDa381nccjuw/S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KxeChMC2; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xz7br15XmzlgMVS;
	Wed, 27 Nov 2024 18:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732732959; x=1735324960; bh=0rD1vtjL8fA5reiZaZ8j1ACA
	Zb6Pm8Jn43c0lhEXs8E=; b=KxeChMC2mhubsbiQVFc53lsKnxnkqs0K7jWNUosX
	bmQ8igiKF8XIAHggFcaQL28GCe41Zmk+f5hlSn8mUB3Ovr42fxV7JN7LSBN/puyr
	H6aDv8BehjS+I65ROCXdGDtwAwV0DTN2FBsyP30tYm2KYzcmjkMK2SlxJJpNz4RV
	G3PfAN3Hp4fuCvkxNhYOfQU2de31Tl5yRf448aSJa0m44wPW+z3hYUJHi8b1HKg1
	3F7ZYqwaS3vFB9XbSSSXQwsbm4kTvt2uG2T7hTBrgDB6P1LRHVE5kMJ3/aiWB0X9
	jWTMWh7Mxa/xLAHVQ3jF0Vjz5gWFbPhfdu8nPEFvSu48ig==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UZScfeYCTww0; Wed, 27 Nov 2024 18:42:39 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xz7bb3FMFzlgT1K;
	Wed, 27 Nov 2024 18:42:35 +0000 (UTC)
Message-ID: <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
Date: Wed, 27 Nov 2024 10:42:34 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nitesh Shetty <nj.shetty@samsung.com>,
 Javier Gonzalez <javier.gonz@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
 <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
 <CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
 <Zy5CSgNJtgUgBH3H@casper.infradead.org>
 <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
 <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
 <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
 <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
 <20241112135233.2iwgwe443rnuivyb@ubuntu>
 <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/24 6:54 PM, Martin K. Petersen wrote:
> Bart wrote:
>> There are some strong arguments in this thread from May 2024 in favor of
>> representing the entire copy operation as a single REQ_OP_ operation:
>> https://lore.kernel.org/linux-block/20240520102033.9361-1-nj.shetty@samsung.com/
> 
> As has been discussed many times, a copy operation is semantically a
> read operation followed by a write operation. And, based on my
> experience implementing support for both types of copy offload in Linux,
> what made things elegant was treating the operation as a read followed
> by a write throughout the stack. Exactly like the token-based offload
> specification describes.

Submitting a copy operation as two bios or two requests means that there 
is a risk that one of the two operations never reaches the block driver
at the bottom of the storage stack and hence that a deadlock occurs. I
prefer not to introduce any mechanisms that can cause a deadlock.

As one can see here, Damien Le Moal and Keith Busch both prefer to
submit copy operations as a single operation: Keith Busch, Re: [PATCH
v20 02/12] Add infrastructure for copy offload in block and request
layer, linux-block mailing list, 2024-06-24 
(https://lore.kernel.org/all/Znn6C-C73Tps3WJk@kbusch-mbp.dhcp.thefacebook.com/).

>> Token-based copy offloading (called ODX by Microsoft) could be
>> implemented by maintaining a state machine in the SCSI sd driver
> 
> I suspect the SCSI maintainer would object strongly to the idea of
> maintaining cross-device copy offload state and associated object
> lifetime issues in the sd driver.

Such information wouldn't have to be maintained inside the sd driver. A
new kernel module could be introduced that tracks the state of copy
operations and that interacts with the sd driver.

>> I'm assuming that the IMMED bit will be set to zero in the WRITE USING
>> TOKEN command. Otherwise one or more additional RECEIVE ROD TOKEN
>> INFORMATION commands would be required to poll for the WRITE USING TOKEN
>> completion status.
> 
> What would the benefit of making WRITE USING TOKEN be a background
> operation? That seems like a completely unnecessary complication.

If a single copy operation takes significantly more time than the time
required to switch between power states, power can be saved by using
IMMED=1. Mechanisms like run-time power management (RPM) or the UFS host
controller auto-hibernation mechanism can only be activated if no
commands are in progress. With IMMED=0, the link between the host and
the storage device will remain powered as long as the copy operation is
in progress. With IMMED=1, the link between the host and the storage
device can be powered down after the copy operation has been submitted
until the host decides to check whether or not the copy operation has
completed.

>> I guess that the block layer maintainer wouldn't be happy if all block
>> drivers would have to deal with three or four phases for copy
>> offloading just because ODX is this complicated.
> 
> Last I looked, EXTENDED COPY consumed something like 70 pages in the
> spec. Token-based copy is trivially simple and elegant by comparison.

I don't know of any storage device vendor who has implemented all
EXTENDED COPY features that have been standardized. Assuming that 50
lines of code fit on a single page, here is an example of an EXTENDED
COPY implementation that can be printed on 21 pages of paper:
$ wc -l drivers/target/target_core_xcopy.c
  1041
$ echo $(((1041 + 49) / 50))
21

The advantages of EXTENDED COPY over ODX are as follows:
- EXTENDED COPY is a single SCSI command and hence better suited for
   devices with a limited queue depth. While the UFS 3.0 standard
   restricts the queue depth to 32, most UFS 4.0 devices support a
   queue depth of 64.
- The latency of setting up a copy command with EXTENDED COPY is
   lower since only a single command has to be sent to the device.
   ODX requires three round-trips to the device (assuming IMMED=0).
- EXTENDED COPY requires less memory in storage devices. Each ODX
   token occupies some memory and the rules around token lifetimes
   are nontrivial.

Thanks,

Bart.

