Return-Path: <io-uring+bounces-2511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78560931571
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 15:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAAD21C216E9
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 13:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B9618C34F;
	Mon, 15 Jul 2024 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stuba.sk header.i=@stuba.sk header.b="yRdfuyUk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out.cvt.stuba.sk (smtp-out.cvt.stuba.sk [147.175.1.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3016E18D4C1;
	Mon, 15 Jul 2024 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=147.175.1.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721049071; cv=none; b=fLVAWrBCYpapmQObrG7anPasg1vD6EJ5FfWMN4BXsuhGiC95CR+zIZUNynmzb9JMcuLKoMNcNy1h0Ug0AgA97N4XTl/NuaPo4Kk7YiRTlWTsbFNuyn0KryND/TQdV5zsMa2mLQoTPzILUFACqmkYGkReSR80ggld5FOgXz/ZfJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721049071; c=relaxed/simple;
	bh=UBfgy5+0l8x+M07N7A4Dki6luKXzyCWR4r70sFx/1SY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sookpNAuyUJLYdswfRzgMCfE8lTQgmGKrIwrsyBRUa/49SXmWiAq9VJEIhaG/e4kuxQnjQu/qnciIKnc2twRlSkfLkH66pIhXFIUQ2YdGc40VoU/7Hl8dRpP6b8Wuw+twJqhVJZHcpD6trQklSXOAyzP2buU1dtyY7K8b9Ns7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stuba.sk; spf=pass smtp.mailfrom=stuba.sk; dkim=pass (2048-bit key) header.d=stuba.sk header.i=@stuba.sk header.b=yRdfuyUk; arc=none smtp.client-ip=147.175.1.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stuba.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stuba.sk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=stuba.sk;
	s=20180406; h=Content-Transfer-Encoding:Content-Type:From:To:Subject:
	MIME-Version:Date:Message-ID; bh=hPXmEGrpNCxQtlE+7MmiOVH/DDCPb8s47qf1vlPNH8Y=
	; t=1721049068; x=1721481068; b=yRdfuyUka8R8o/yS9lizhVwyr0ygk5Wde5XqpaziEQpOp
	j1O7FP/gSubqEyJ6/+7NWKmQeGS3K2wpxTQkKnzyWSEDnzagJF0sqCFSpLb7D0nUHnJUfW4WSSvGR
	SU1o1LEdZMM4NF4htQGocy9AjBNIrLp1lXn7cQPWF1BVsq/87g8mhbHvXRY/nQh6CKpNNj5p1iTq4
	yB8dWUshaa+TyyUHM2vkXiDGhhBx5ycWvi1zKQwKqGdJqHXgfgYHqUy1YvHV7m/jOJyg7EZNQW1Gu
	gpUkjMSYm56MDGKnTQYo0apIxf6QzSJn0+oPMHxi5SYjlIzPHAnBii2daofaJGpgGA==;
X-STU-Diag: 0488aa0426ae2156 (auth)
Received: from ellyah.uim.fei.stuba.sk ([147.175.106.89])
	by mx1.stuba.sk (Exim4) with esmtpsa (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(envelope-from <matus.jokay@stuba.sk>)
	id 1sTL8u-000000003nF-2IVT;
	Mon, 15 Jul 2024 14:49:24 +0200
Message-ID: <498a6aad-3b53-4918-975e-3827f8230bd0@stuba.sk>
Date: Mon, 15 Jul 2024 14:49:24 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
To: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20240614163047.31581-1-krisman@suse.de>
 <20240618174953.5efda404@kernel.org>
 <68b482cd-4516-4e00-b540-4f9ee492d6e3@kernel.dk>
 <20240619080447.6ad08fea@kernel.org>
 <8002392e-5246-4d3e-8c8a-70ccffe39a08@kernel.dk>
Content-Language: en-US
From: Matus Jokay <matus.jokay@stuba.sk>
In-Reply-To: <8002392e-5246-4d3e-8c8a-70ccffe39a08@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19. 6. 2024 17:06, Jens Axboe wrote:
> On 6/19/24 9:04 AM, Jakub Kicinski wrote:
>> On Wed, 19 Jun 2024 07:40:40 -0600 Jens Axboe wrote:
>>> On 6/18/24 6:49 PM, Jakub Kicinski wrote:
>>>> On Fri, 14 Jun 2024 12:30:44 -0400 Gabriel Krisman Bertazi wrote:  
>>>>> io_uring holds a reference to the file and maintains a
>>>>> sockaddr_storage address.  Similarly to what was done to
>>>>> __sys_connect_file, split an internal helper for __sys_bind in
>>>>> preparation to supporting an io_uring bind command.
>>>>>
>>>>> Reviewed-by: Jens Axboe <axboe@kernel.dk>
>>>>> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>  
>>>>
>>>> Acked-by: Jakub Kicinski <kuba@kernel.org>  
>>>
>>> Are you fine with me queueing up 1-2 via the io_uring branch?
>>> I'm guessing the risk of conflict should be very low, so doesn't
>>> warrant a shared branch.
>>
>> Yup, exactly, these can go via io_uring without branch juggling.
> 
> Great thanks!
> 
Please fix io_bind and io_listen to not pass NULL ptr to related helpers
__sys_bind_socket and __sys_listen_socket. The first helper's argument
shouldn't be NULL, as related security hooks expect a valid socket object.

See the syzkaller's bug report:
https://lore.kernel.org/linux-security-module/0000000000007b7ce6061d1caec0@google.com/

Thanks,
mY

