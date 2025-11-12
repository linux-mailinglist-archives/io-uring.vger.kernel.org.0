Return-Path: <io-uring+bounces-10533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D41C512C0
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 09:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B363A4F3E75
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 08:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1722F39BD;
	Wed, 12 Nov 2025 08:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OO76L3K/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917482FD66C;
	Wed, 12 Nov 2025 08:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762937173; cv=none; b=oRrqen3gDkIzG4xD/1C9ywfyuf3ukv+j0TT1FsbrwCLPxYjh4++AlWkohM02ioAdhWPhDd0vZjqHEdervuHRIoJOSatT8erLVF9E/kFoMTAiAT2N1YKgDX+0RINbNfHQ2q6kwAPAwuy8whOPTQjbhh/uQqUtJPUgIkx20i5Nnwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762937173; c=relaxed/simple;
	bh=NZajaLJHkBGjAPCzb2TdcInoFaNwP01M5bKZN5Cm4x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWrdnlA6NpwqjlHEig51JvRDrLF3NPwpBebjFSa8SjidkrSqaKyTfh7FsKLfhJ38R4QmlTnfd16JmkuRHB1whgJxJ9kN1alBjebhsfcOubiL8eUnI7cZdSDdeLDfRV0sBiJ8Jcky024Szqrs8qbCOOCPctLUrfW9ZufJVcaTd1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OO76L3K/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E4FC4CEF5;
	Wed, 12 Nov 2025 08:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762937173;
	bh=NZajaLJHkBGjAPCzb2TdcInoFaNwP01M5bKZN5Cm4x4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OO76L3K/GGutixqCP4r5M7jArd4TibosGBck9m78JKg85bGAS1a+f4P9Xk4A08mFJ
	 usWTzjkaILFPur3Pvvs5nOHrMNJuUBeBL2Esh06lBeI8/EM4yH9hSPQ4syteHXKvwE
	 APNteFbBjJ9pb4V3Zd7Y/VrI0daSAxL9osSDggXhMdfCjvFHCjt4AXsbWpcWC/YeXE
	 bDLiG3VmHzCI+PMZoURbVeIPGfyFB9LMsupRu4Y6QMcBwcFCP/QDpyyZV88Cn7uqSW
	 Bw8HR6DJnrM8dfiq8bMaRvRUJ6SAclpUZ5Mo207wnI8ltuswygzW9dpN6VqDRNGIhB
	 r67gczgCzrhRg==
Message-ID: <d270734f-e7b4-4003-a0eb-25bd656d9139@kernel.org>
Date: Wed, 12 Nov 2025 17:46:09 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: enable iomap dio write completions from interrupt context
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong"
 <djwong@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 Avi Kivity <avi@scylladb.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20251112072214.844816-1-hch@lst.de>
 <8c957ed5-ce4e-4207-8757-47b8ac168832@kernel.org>
 <20251112084451.GA8742@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251112084451.GA8742@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/25 17:44, Christoph Hellwig wrote:
> On Wed, Nov 12, 2025 at 05:43:05PM +0900, Damien Le Moal wrote:
>> Where is the zonefs change ? Missing a patch ?
> 
> There's not zonefs change.  The zonefs fix is the core code now calling
> the read ->end_io handler from workqueue context after an I/O error, and
> thus now doing what zonefs incorrectly assumed before.

OK. Thanks for the clarification. I was thinking the other way around :)


-- 
Damien Le Moal
Western Digital Research

