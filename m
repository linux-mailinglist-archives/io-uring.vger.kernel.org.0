Return-Path: <io-uring+bounces-514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7586845944
	for <lists+io-uring@lfdr.de>; Thu,  1 Feb 2024 14:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C5561F2731A
	for <lists+io-uring@lfdr.de>; Thu,  1 Feb 2024 13:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D625336C;
	Thu,  1 Feb 2024 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NmnWqE5q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ABD5B669
	for <io-uring@vger.kernel.org>; Thu,  1 Feb 2024 13:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795452; cv=none; b=SNCYqme0MJR7qZKbLxAxiQV24h0BudWkhZ4S6QPn0ZK8e0PXOxq/J2u+gdcO3FQphJ/0G2uR01Jub68BHGzdPi14xYjHMwHRiiTBkfzqQERRak7iay8cTqxk59Pwno5jP+j6+617BTEWghfqTqgn06P/j9d3UCfvWggLP0ZsQSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795452; c=relaxed/simple;
	bh=lOKKLTQ8QtT98449JwXye3nQdyqblltXmW5XzbDuH0U=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=H4FQmYesu59ReoJXMA9sYkKx+sI5tA1jDiQL/2MBYS5g65apPZb7JZx9zb1fxzGN3c+1Sh7ueH3/hPu1GrGezK+caLo3B75NvEb0XevYQbIePEqSs81kiWIeFEUAKpyPk8V6tfGodWML7yrTJjviI9jNng5OjnjsQlTon1cPyq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NmnWqE5q; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so161782a12.0
        for <io-uring@vger.kernel.org>; Thu, 01 Feb 2024 05:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706795448; x=1707400248; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZhzykiD8OyRI2pg8qMK70xBdbi/njniTF8GGYIkORZU=;
        b=NmnWqE5qkjsqMTS7cIa7TYzVY7QArFBpELQ55fEl315zr+kxiJTBvme31QwXs03DzJ
         R4U4IqRCOvABLdQUFbElxq5DqyzcAF066XdANnvahykxgB1g45KcfWNlbXmTgbM/1aF1
         mPWihpH53M6ZHH8y1o6+B7uOCSBzjZOxHFpAzuiyf1dCl0vLlZT+eUTcO3wmY3yakpip
         IVwNuK2pQl3qkIOF364YQ1ty5OOG+soJ/pxla42hhXZfAxF98vOTD2brm2zbE1tjpBN5
         eE6EaFhfMJJ4ZXjUW2XKkK2EZvlmPuPj1CShu/v2r97A/ryXSqyHBOKtCZSqrLq+TCkr
         sYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706795448; x=1707400248;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZhzykiD8OyRI2pg8qMK70xBdbi/njniTF8GGYIkORZU=;
        b=Yk6vqQ6+w0+zszLvUeLi6JEhM//oRhl164nehLeiSx1TlqtVp3TIF4wKS770mFz1Oc
         fEDbZiC33hxMRM76r8Je8qlf0sQ9/ZjaEo+5vKMqmXULml5iXatFy4Nxs948m0mbvJBq
         KLEaPoPr4MAmAdGjcTj7pNgH5iGPenzvqX92SpEY6Ok8nX5ZjY855sYJ+LuUJciYiYZj
         c1llP3KsmMuZMbm+6ECXaF+wS87px/hOIUMdcwJXtX+yfGsTY/BrFFeAtv0xdCvdYbBo
         6Fd/4rBcycpw67Y6vqva5fIvLWtNoo1dpPfRDRnlF7OzsW6eKhDCLrHvKUBF4VqlmR3k
         rblg==
X-Gm-Message-State: AOJu0Yz9MLtGxsu9CwelIRM8NX302RzXXxTLXPjbQkCdGCq4uLek2jja
	UZwdFQZ4yn/6ZbwCynB4zSSk8El+TXs7d5ZstxpLYTozf29EGaAlUFszSAGvcNHdAUsJKIiaO7B
	oMpY=
X-Google-Smtp-Source: AGHT+IFbWwt00XZrNX0ttkQLtp2Td7VJ3ZGiQq33PYJKUrGcooihelxOMRO/BTp7SHRoBmy9unduAw==
X-Received: by 2002:a05:6a20:7486:b0:19e:3462:b7be with SMTP id p6-20020a056a20748600b0019e3462b7bemr2678968pzd.4.1706795447903;
        Thu, 01 Feb 2024 05:50:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id fa3-20020a17090af0c300b0029618868629sm1470795pjb.1.2024.02.01.05.50.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 05:50:47 -0800 (PST)
Message-ID: <26a24e17-0e75-4670-b127-38050421f433@kernel.dk>
Date: Thu, 1 Feb 2024 06:50:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: fix sr->len for IORING_OP_RECV with MSG_WAITALL
 and buffers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If we use IORING_OP_RECV with provided buffers and pass in '0' as the
length of the request, the length is retrieved from the selected buffer.
If MSG_WAITALL is also set and we get a short receive, then we may hit
the retry path which decrements sr->len and increments the buffer for
a retry. However, the length is still zero at this point, which means
that sr->len now becomes huge and import_ubuf() will cap it to
MAX_RW_COUNT and subsequently return -EFAULT for the range as a whole.

Fix this by always assigning sr->len once the buffer has been selected.

Cc: stable@vger.kernel.org
Fixes: 7ba89d2af17a ("io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index a12ff69e6843..43bc9a5f96f9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -923,6 +923,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		if (!buf)
 			return -ENOBUFS;
 		sr->buf = buf;
+		sr->len = len;
 	}
 
 	ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);

-- 
Jens Axboe


