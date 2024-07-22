Return-Path: <io-uring+bounces-2537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53504938F26
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 14:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFF771F21C31
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 12:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D923316C863;
	Mon, 22 Jul 2024 12:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stuba.sk header.i=@stuba.sk header.b="H+vDKdwy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out.cvt.stuba.sk (smtp-out.cvt.stuba.sk [147.175.1.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ED816CD16;
	Mon, 22 Jul 2024 12:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=147.175.1.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721651885; cv=none; b=Nyy6T3VSYs5GjvI7F7PzyBVbu4+50DbQ32PbscB7PrOw5Yha4jsMgYkH9M08AtEyaKVx+uvtdcPa5D9BZDUdcEigP12rlzcuI+/8TYpGUsiNR5eKk+6tzeWDrtRqNFVoDo/L4kuOj6VsErPGfdOUvk1xEqrdN1YGYm7MlfHNNmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721651885; c=relaxed/simple;
	bh=eTg5NAhjkg+X6jjYwP1XPcO3kFbYYOFgrmRWIhOoUU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GhiICaugOCCJudpq6Zk+QwggvRdZRQijQeV+eQ4/iiSK+nEKvjl7D6adrbwU28O2zZwvJJ+j05alStVnQ5AL5PW+QDda4ELhotuitQc0w9oKJ2YRKeBWckd/g2lfYJK7MmG9yIPLP3QJsk2ig40aXp07KNxB20ZL/RbHjKgB6RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stuba.sk; spf=pass smtp.mailfrom=stuba.sk; dkim=pass (2048-bit key) header.d=stuba.sk header.i=@stuba.sk header.b=H+vDKdwy; arc=none smtp.client-ip=147.175.1.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stuba.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stuba.sk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=stuba.sk;
	s=20180406; h=Content-Transfer-Encoding:Content-Type:From:To:Subject:
	MIME-Version:Date:Message-ID; bh=seaaaDrmsxI8CHZMu8BAxDgz1W7j+k0jOcWgowxaoEc=
	; t=1721651883; x=1722083883; b=H+vDKdwyR3z0DJr/vX0DTqoap/fdQPdPKSqw/KHOybZyE
	s/pce2VpbaCPfqN1tCNNXnvuLgtWeyjeqVZ/ujbakDYneigOfwPn001hHMz6+bX4uX1CWwf2RBEu8
	cqRAmcW9tKP/XFhgWDQlJH2Oh1goEP5/pa7UlSRpPJDUo8PT2M6jPGIGnCW1iEkV6b1/t6mB67Esb
	Ylq323k/+bcZQ4TOgtNIEfkBAOz6Ix94K6mu7htIiojpCvfvzPyisZ+7f0RuOngXQzixvoAmhQZwz
	jzB/hhHeNBGpX2fzQXLisB1nSolo1JoHsBZ3Ezl2POB2mEUx2VvCPZZBrVgK9ElrKg==;
X-STU-Diag: ddbf88033a8394d7 (auth)
Received: from ellyah.uim.fei.stuba.sk ([147.175.106.89])
	by mx1.stuba.sk (Exim4) with esmtpsa (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(envelope-from <matus.jokay@stuba.sk>)
	id 1sVsIi-000000007GU-0deN;
	Mon, 22 Jul 2024 14:38:00 +0200
Message-ID: <bcbb8961-392c-431b-8199-673bbb80af3a@stuba.sk>
Date: Mon, 22 Jul 2024 14:37:59 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20240614163047.31581-1-krisman@suse.de>
 <20240618174953.5efda404@kernel.org>
 <68b482cd-4516-4e00-b540-4f9ee492d6e3@kernel.dk>
 <20240619080447.6ad08fea@kernel.org>
 <8002392e-5246-4d3e-8c8a-70ccffe39a08@kernel.dk>
 <498a6aad-3b53-4918-975e-3827f8230bd0@stuba.sk>
 <01ef97b5-33a5-4c79-a0cf-4655881f106c@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Matus Jokay <matus.jokay@stuba.sk>
In-Reply-To: <01ef97b5-33a5-4c79-a0cf-4655881f106c@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15. 7. 2024 15:59, Tetsuo Handa wrote:
> On 2024/07/15 21:49, Matus Jokay wrote:
>> Please fix io_bind and io_listen to not pass NULL ptr to related helpers
>> __sys_bind_socket and __sys_listen_socket. The first helper's argument
>> shouldn't be NULL, as related security hooks expect a valid socket object.
>>
>> See the syzkaller's bug report:
>> https://lore.kernel.org/linux-security-module/0000000000007b7ce6061d1caec0@google.com/
> 
> That was already fixed.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-next&id=ad00e629145b2b9f0d78aa46e204a9df7d628978
> 
> 
Tetsuo, you are very fast ;)
Thank you!
mY


