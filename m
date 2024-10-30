Return-Path: <io-uring+bounces-4220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D769B6A3F
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:08:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DE501F21C83
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB28217461;
	Wed, 30 Oct 2024 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MexNnD/a"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB056215C72;
	Wed, 30 Oct 2024 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307581; cv=none; b=rL6czn9gL1EuZQJOREa2/mTXw9wWyLK3Wteot5svRZM0I2G5d4a/mNFh+OZXQuKPhlHu2BHnoz7rv2bJGOcenH6VKRURGFUG6f6cr8hJ0MkvePfyIzXMWvdfBdYvyScd4teJ82Pt+t2Kd1vDXPN7Fpu1l1zo4iZP8Bfb+Wmbqsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307581; c=relaxed/simple;
	bh=Ijv1PLRNFIuvGDdpr83/vYACAw3BQ+sL/IAZM+Wjcmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8hCJeXjlYUBVFvfXrf6kp/4XfiszR6wWegiahxQql2P0U5iYvMrWT+tZGYPHCf6rba94NavlkW/I3kAYiGrrCtC68YAKUC/gRVWG+FuuCrS6tZZZYZ+mQ0LcV4LeFCwmYo0qNBLuVFMuwbJZdwp6gpp+/2xun1keZzmSssb8d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MexNnD/a; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xdtdk1cwnz6CkhT8;
	Wed, 30 Oct 2024 16:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730307570; x=1732899571; bh=SwxKfN96hIqYCkb8QGNlA8Ko
	sCPk0jUCEfVCsG/NExc=; b=MexNnD/aEVaXzpRD5MISzOL1S5JHtj7aKWSWgfVw
	HOMB19KGgbyPmg4UKxoOgLWrSRUxXot2/LDK941QdpGi7kcJc524kjWOMOznHEMc
	JZFjOQNHaqq0Aw6MUeThPKGoyinJEbqOKAqxxV5GuT4xCWg8zg6U3Y4gmfpV16T9
	ubJ4hrrpQ41SOl5ZHA3leu7hVEhYUreKQWXILrK3BoN7vkE1tAWSlpUxPw1fiPF7
	f4QPCL5OkcM/yU/UtJY1BFI8t+/AgfH8pXoLrfssVJ6vuQpLHbIcheCo8MR8Dfu8
	VdMsjKQ9xR3g+epauZYGRPFjnYvbtonLrIvSEta7m9PF+A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8PFHBzjVBJzT; Wed, 30 Oct 2024 16:59:30 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XdtdV5P1Wz6ClY9S;
	Wed, 30 Oct 2024 16:59:25 +0000 (UTC)
Message-ID: <c9c2574b-b3be-47ac-8a82-10d92c5892bc@acm.org>
Date: Wed, 30 Oct 2024 09:59:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 joshi.k@samsung.com, javier.gonz@samsung.com, Hannes Reinecke
 <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-10-kbusch@meta.com> <20241029152654.GC26431@lst.de>
 <ZyEAb-zgvBlzZiaQ@kbusch-mbp> <20241029153702.GA27545@lst.de>
 <ZyEBhOoDHKJs4EEY@kbusch-mbp> <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241030045526.GA32385@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/29/24 9:55 PM, Christoph Hellwig wrote:
> For the temperature hints the only public user I known is rocksdb, and
> that only started working when Hans fixed a brown paperbag bug in the
> rocksdb code a while ago.  Given that f2fs interprets the hints I suspect
> something in the Android world does as well, maybe Bart knows more.

UFS devices typically have less internal memory (SRAM) than the size of 
a single zone. Hence, it helps UFS devices if it can be decided at the
time a write command is received where to send the data (SRAM, SLC NAND
or TLC NAND). This is why UFS vendors asked to provide data lifetime
information to zoned logical units. More information about UFS device
internals is available in this paper: Hwang, Joo-Young, Seokhwan Kim,
Daejun Park, Yong-Gil Song, Junyoung Han, Seunghyun Choi, Sangyeun Cho,
and Youjip Won. "{ZMS}: Zone Abstraction for Mobile Flash Storage." In
2024 USENIX Annual Technical Conference (USENIX ATC 24), pp. 173-189.
2024 (https://www.usenix.org/system/files/atc24-hwang.pdf).

Bart.

