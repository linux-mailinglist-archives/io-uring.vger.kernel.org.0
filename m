Return-Path: <io-uring+bounces-8222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D604ACE559
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 21:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5754E173253
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 19:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDE91F4E34;
	Wed,  4 Jun 2025 19:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUee7+F+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B31A111BF;
	Wed,  4 Jun 2025 19:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749066811; cv=none; b=fFMBSmVJy2VMPoO0E5sO2ObVmqp4twjnbNo7rLZxE8IBTCHpznXB0TiqEk+ku4F+xglUvXnMlV+gOyN0I4SWHDbErnOCa5wZwM9x0IGkXiTBWGRC74CYysKkZc4LKwsSdPSQvoRcTEQhT4UOLjkL3H/wXSNUUo8GVMZi1wgWCyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749066811; c=relaxed/simple;
	bh=6SAVqw289jRcTcQ+PCiFQKMlpJilukYhNge2apyk/+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=evM9hOpismL3S3TtTyQx3FRsa3ePT8fxFydZ/cmvaiuGDtCUYbY5fzMzIRtVqYTcDn0P541fwaPreJd0o81642tnEHPbK7QWaCQgBs6QnJkSuBmi6tKapjur8nyXYqDvvAp5KM7sfZtXyLoqVu3/wsSi+XdNuDhHs00MqN0PS/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUee7+F+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEE5C4CEE4;
	Wed,  4 Jun 2025 19:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749066810;
	bh=6SAVqw289jRcTcQ+PCiFQKMlpJilukYhNge2apyk/+I=;
	h=Date:Subject:To:Cc:References:From:Reply-To:In-Reply-To:From;
	b=aUee7+F+VVbFb88Y+zuXz53ah29uxU/8HSb3RpOHsN2DQOtp+vQSPXhub6o9Ki7Xi
	 ZabbZoTNumzuubufi1SPerZWVcxenWAo75fitcEUkEWI4TDVowNr78LX0C20rDYjB2
	 IlpNNcK7s5e9peptryVBghiubwhbwMdH0F/iq3AdwyO0RnjA82O3XFwAwGQ3IQSW/o
	 P+5DlQuCzULmDrY+s47xBwokZ9UDO0x5ScCHr5XxGUHn4izBuBYVr0rGAJE8HfGTLN
	 ntxhkvGJvcdBRbtDcgjjYeze7iDfknq95/gseMhxCIlY2g0vfRQpZuNTmcn756qImY
	 uiPKIenAXPnyw==
Message-ID: <2a5d123a-3c95-47dc-8306-df76bb2b077b@kernel.org>
Date: Wed, 4 Jun 2025 21:53:24 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/10] Read/Write with meta/integrity
To: Christoph Hellwig <hch@infradead.org>, Anuj Gupta <anuj20.g@samsung.com>,
 shinichiro.kawasaki@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
 brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
 io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org
References: <CGME20241128113036epcas5p397ba228852b72fff671fe695c322a3ef@epcas5p3.samsung.com>
 <20241128112240.8867-1-anuj20.g@samsung.com> <aD_qN7pDeYXz10NU@infradead.org>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
Reply-To: da.gomez@kernel.org
Organization: kernel.org
In-Reply-To: <aD_qN7pDeYXz10NU@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/06/2025 08.39, Christoph Hellwig wrote:
> On Thu, Nov 28, 2024 at 04:52:30PM +0530, Anuj Gupta wrote:
>> This adds a new io_uring interface to exchange additional integrity/pi
>> metadata with read/write.
>>
>> Example program for using the interface is appended below [1].
>>
>> The patchset is on top of block/for-next.
>>
>> Testing has been done by modifying fio:
>> https://github.com/SamsungDS/fio/tree/priv/feat/pi-test-v11
> 
> It looks like this never got into upstream fio.  Do you plan to submit
> it?  It would also be extremely useful to have a testing using it in
> blktests, because it seems like we don't have any test coverage for the
> read/write with metadata code at the moment.
> 
> Just bringing this up because I want to be able to properly test the
> metadata side of the nvme/block support for the new DMA mapping API
> and I'm ѕtruggling to come up with good test coverage.
> 

FWIW, we’re interested [1] in helping get this part properly tested as well.
We're already running blktests in CI as part of kdevops, regularly testing
against both linux-next and Linus' latest tags [2].

[1]
https://lore.kernel.org/all/Z9v-1xjl7dD7Tr-H@bombadil.infradead.org/

[2]
https://github.com/linux-kdevops/kdevops-ci/actions

Shin'ichiro, the current CI implementation is still experimental (we are missing
a few things like archive results and dashboard reporting) but we hope we can
discuss soon the possibility to automatically reporting tests results to the
mailing list

