Return-Path: <io-uring+bounces-2512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9C0931739
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 16:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2F611F21127
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 14:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0595A18EFE9;
	Mon, 15 Jul 2024 14:59:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F29E18EFDA;
	Mon, 15 Jul 2024 14:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721055544; cv=none; b=Dekc8xhVoOrTbfjLfF1rlQ3EnXCWhYS6RwxA7wr3cIkBGYOznFZPOq0ckE80NcArUye4DRPV671jJrVr5DdkT5IOpo7srRt2tpbuEp09gadrl0wmZij3zlDE4khsOU3kTDTTaXy6a2jbZociep+dr/rrbStSAOvzsiiTSPZH/Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721055544; c=relaxed/simple;
	bh=XPZ/2x7i9TXdlGROA0TXoMHVzstSMa8V+va0EHzXE6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2tkmWA9TUtQ//rJeOamBAlLPRfp2cyTtdN94U8j+U2MkXeq3ixft/YfObwdBj3D8KTt3EZdJpZ6SmKd9j/SPCQWN37/UIkwLsOYte65+f/k6SY9Zlbp4Cit6dgem8jYJCct5vmuV3h45qhIsf/YBx2FSwshem7QjGBlhJPHnZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from fsav415.sakura.ne.jp (fsav415.sakura.ne.jp [133.242.250.114])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 46FDxBZm053972;
	Mon, 15 Jul 2024 22:59:11 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav415.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp);
 Mon, 15 Jul 2024 22:59:11 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 46FDx6ui053939
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Jul 2024 22:59:11 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <01ef97b5-33a5-4c79-a0cf-4655881f106c@I-love.SAKURA.ne.jp>
Date: Mon, 15 Jul 2024 22:59:06 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
To: Matus Jokay <matus.jokay@stuba.sk>, Jens Axboe <axboe@kernel.dk>,
        Jakub Kicinski <kuba@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20240614163047.31581-1-krisman@suse.de>
 <20240618174953.5efda404@kernel.org>
 <68b482cd-4516-4e00-b540-4f9ee492d6e3@kernel.dk>
 <20240619080447.6ad08fea@kernel.org>
 <8002392e-5246-4d3e-8c8a-70ccffe39a08@kernel.dk>
 <498a6aad-3b53-4918-975e-3827f8230bd0@stuba.sk>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <498a6aad-3b53-4918-975e-3827f8230bd0@stuba.sk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/07/15 21:49, Matus Jokay wrote:
> Please fix io_bind and io_listen to not pass NULL ptr to related helpers
> __sys_bind_socket and __sys_listen_socket. The first helper's argument
> shouldn't be NULL, as related security hooks expect a valid socket object.
> 
> See the syzkaller's bug report:
> https://lore.kernel.org/linux-security-module/0000000000007b7ce6061d1caec0@google.com/

That was already fixed.

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-next&id=ad00e629145b2b9f0d78aa46e204a9df7d628978


