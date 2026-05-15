Return-Path: <io-uring+bounces-13362-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GACAMOo6B2ottwIAu9opvQ
	(envelope-from <io-uring+bounces-13362-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:25:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 624F35521AE
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B54F23009CD2
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C24494A05;
	Fri, 15 May 2026 15:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="hFSvs7Wl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FBE494A0E
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 15:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778858728; cv=none; b=GrfunWYJPHROli2vILshqnB9uP4tg3fUcrWbjGMWPlqdlfP+0rnzV26+zyGlC9ahdGjS1vgVmnvueiBelfbWI2netezpLr7IrNDGlQQmRhIpZR/Ki/uT0ZvQjIBrp30/878GzaMcipsvhhI2qSYvCfEF5qfimyuHAiSPNzSXUXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778858728; c=relaxed/simple;
	bh=a7Kt/m+0JnX1X8N5L6wTaDKQ2rl+hmTKrV/ONKOETJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NjSyXdumGhu9RMw5+ijti7rqW5dxXSYh/zMH8LfJ3swGt6AD+WQ04wfHaWNqot9PMb3oq58jLL+O2z3cAmrpnUHOPYI8v3IXkUOus33Zg+OJJP+AnK7LkrqIWQHLw+OXoOr0B4yzLjbxoizRS/PVZShr+6OVZBVhla3u3hEDuO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=hFSvs7Wl; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7dbe07d3ec3so5022267a34.0
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 08:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778858725; x=1779463525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X2dd+XUfkYHhyAA0KSTJMQh4TQprRfZ5CcOO5gIxkqo=;
        b=hFSvs7WlB5Jm1Koll8CvH724t7AFd0kYZ+mk+/mV6UfyesI5b6IkLb/6EXGnprosDk
         qKegzWOH5cp4AqKIbVj7CjwV987Yu0E8QT/qtK+roKO6xq+plsv70OdPTPIz/BUC+qlj
         gxsbo1Brdq33ZrLCS0MAH07YqbkKURPkFhjMj94Y/KOduD9jSr0ohcO9G7X1BJLUBBaj
         d1P0EfkrV9mZerMLKluQT/VMQhFn4gBkZwgvyaLyB6NZINZJ+zMCuA5/poq3eITCbx2d
         NCW5afbebSQvnWhsIhTgA8Q22W8tI/Otvu2MYIpbT7qH6QTK0W1xU6LhVEGk8sszgyHD
         7gSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778858725; x=1779463525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X2dd+XUfkYHhyAA0KSTJMQh4TQprRfZ5CcOO5gIxkqo=;
        b=roQHwHDfLI+az+1qVpE36ad5tO22VNdpOJ0Uu3paz3xvUAXgr1WkN34IY7vG+9AvoR
         ms0YMN5iXylNuUw8hnmRW51e442M0UNSP/8rFjsta93he34EsYy/S/sSE+4/df5Q0mkt
         YJZd/743E9xvAJkcQaLN5dX3n5XeqHjd3IVZOitkbz6wOsn1BZzDGv/M15+bOtN5IVLd
         /YuikzUosXybQoqFB1SEFylHwNzg6zt+zQ81BmqLjD6uguTcfugQX4Ehu6adIc8XdzyX
         E8dKKHpkmRbOp/5ZfYpLGOVI9dkYfdWVMbMfeAI9TAVqEbuAwJgYC5Dnr+P4jaHgTXH0
         eakw==
X-Forwarded-Encrypted: i=1; AFNElJ8ba5IUaiSxxTu1io5YaI6Y5H287+zruD9QNH7jsHmo6/R3FMgY136EYPl0yYMuBX+6h3LxIOHaqw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6fxi7l2d9w1m3LET2iHojC4i+nrbRd9YpLvG3d0x+ZKXSoFdA
	0hf7EaODzfnpa//Epd0DpEruCSe3E7buMDQ91Dmjw5WGEMu0svXBs+9BsEMVCyHX8bY=
X-Gm-Gg: Acq92OFDVf4+GkoAEazjEX6m3MNIGOBhsbYhafTRyvZggjyb6Jg1G2RSp8oPbHMUvzB
	EUCCmKdpIjokhTnxTb41gxAB+9+EmNMshn+RC8nJTqOQnME6b1XQoaHo7RS6qYGNcjFaL8Oqnkd
	W0gbcj0pcaUCahVRwz8wqCmWYuTBhR1b0v0kAH9Rmu8idL9G0Wh5JdL4w4m+bgJJH+pequzMxBv
	WDM/+qVyMQMb4RDwxz6W7zeRcTa0pP/O3JCRos36WjoThLcFyXxFzKUtNGZpt9dRsdCP1YK0C+1
	7orxT3jpL4IKJ49gcNm5Zr/cWDBb3q4jo7pb8/ImNiuJdhrTbDJDLB7xu9s4iyH82rINlk6kM9l
	cghahMgX679Bx6356Trit3KztXb7JHMrvor2g2rTaQtAUTGpi5cnEoExBg/KBC8ZBOhCRC3Gmhr
	tHnlYNBPVXCta+WuDFTnalF8/JAMpwoUYIQkYaY8uRDdBkYlNTGZztcqMfWfacSd42x77CQVW++
	nLdnsbJ
X-Received: by 2002:a05:6830:6588:b0:7d7:5113:f83a with SMTP id 46e09a7af769-7e4fa090162mr2978796a34.25.1778858725212;
        Fri, 15 May 2026 08:25:25 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bc4983asm1471700a34.26.2026.05.15.08.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 08:25:24 -0700 (PDT)
Message-ID: <b2ecc3cf-12bf-470a-b30c-f89e64301629@kernel.dk>
Date: Fri, 15 May 2026 09:25:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCHSET v2 0/6] io_uring related epoll cleanups
To: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
References: <20260514140817.623026-1-axboe@kernel.dk>
 <20260515-lachnummer-havarie-c6e68d7fe5ef@brauner>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260515-lachnummer-havarie-c6e68d7fe5ef@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 624F35521AE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13362-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/15/26 9:08 AM, Christian Brauner wrote:
> On Thu, 14 May 2026 08:07:16 -0600, Jens Axboe wrote:
>> One of the nastier things about epoll is how it allows nesting contexts
>> inside each other, leading to the necessity of loop detection and the
>> issues that have come with that.
>>
>> I don't believe there's any reason to support nesting on the io_uring
>> side, in fact IORING_OP_EPOLL_CTL is a historical mistake, imho. But
>> let's at least try and contain the damage and disallow nested contexts
>> from our side.
>>
>> [...]
> 
> @Jens, I added the epoll specific change to vfs-7.2.eventpoll. There
> were quite some merge conflicts now that I had to fix up. Please take a
> look and make sure it's sane. Otherwise I'm going to push this and will
> keep the branch stable.

I think your merge commit ended up messing it up, as you have

- static inline bool is_file_epoll(struct file *f)
 -int is_file_epoll(struct file *f)
++bool is_file_epoll(struct file *f)

which now makes it return a bool, and the header has it as an int
still.

-- 
Jens Axboe


