Return-Path: <io-uring+bounces-8672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BC9B04AD2
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 00:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7B9D4A5923
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 22:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58650244691;
	Mon, 14 Jul 2025 22:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0sVvCfNG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAB75103F
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 22:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532801; cv=none; b=ChK75A5VzBhstX2isGxyIBBOOfim/JkbXXXPwyyBfeHDtugkDus9rKvpWBaQSvBPi4acv1IqYLC8/MLyJyRqeBrurQw9mQAR5iPkRTFw+ZcgwEn61SkeW+yLYdNLt0QbGSn7H8zi2CxjmeOl/4YUruEsOhOYa/f5AKRah/X+Cc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532801; c=relaxed/simple;
	bh=Bn4ce0UP6Qd01I5Opc54i1HX6ZeET5Ftp6tfUD1ijRA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=B8nk5fWBibcYWoP2Jym6lBFqaVRxgGOEeqrMFmLP9ea12CzGz8f/Xvf4/w2H3d7rdlqeCh/0/m3AMtdW35lu/sq2mjGETjTadSFdAVlu2GEuRrOLBMYBE0cJPDMOMa4CevZR/yqprIRKbDan5rN9sPdMxntmEpSIxOlDZHEjDWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0sVvCfNG; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3ddd2710d14so42813055ab.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 15:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752532796; x=1753137596; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtqnlwYRu05wfXhM/a7TW/gz8Wi3VP0aM+4rTllqZEM=;
        b=0sVvCfNG9HFjCMMJEmMoSdiNZ4AIDMDerLFSUdUlfr2tGC9hfU+M3PTWEObOmqtmvX
         0TLVi36PidG/StztHgiiAmb2caMFrFFrx+g2bPM8Q+QwzP1VOYMQNdnb/Kn8sBy/ZcpL
         +/0iFpGFaoz6pzJ/UUjj3I8DQyL3OuyW3QOb6AUh5HvbqUDWcdWITW/xZJLN+8FMbdjJ
         7PTMYfLLvgzZ9hfxSWHmgNDVnM3lEJfITifGrnIiBEs+iVedM47NBfqIO05WTQRrP8j6
         hcvHymIulbSpeYn1oI2l68HU+J5eNl5oYFENysB+kkOXl8/OlD7+T7B1M7Zmcv254ghK
         irJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752532796; x=1753137596;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dtqnlwYRu05wfXhM/a7TW/gz8Wi3VP0aM+4rTllqZEM=;
        b=swMY+jtYW0GB8s2YO9H51CDXZsVqLt8rpC7IFNWgOSQjVb3ziDMmmrWDFt3pyMrLxg
         l2kR/clnbRqTWj6HEKPvIS86UqUoreE7txjlLwojseV9KAA+oVfdJVadLbq+c6HFgx1Z
         Kag7M3dscbUqx8WnuZBTfhI1rEZJG+DckodMSHaOh74sQU6Uclvcj5AwDPf5hA5ntvJh
         LsQh5BViB/J0pzRyjlN5i8YRngiXqEEIxPX3EiVShqZcz5HElXeLvtEoDKOJfROCBcVZ
         8+OUUolPfKNtNM/DVYhMFpvp1Ns1wXAGmpJVW6zhvO4cV+Ltqeuj5uymXaDMVC6bkH9x
         69sA==
X-Gm-Message-State: AOJu0YwgxTKBjVW4HprnNGTj7zK8JSIe5eyzGuu3lJKyKG/uZtkF4Nld
	2Zv2/orhJQ0ShVEu9oIAstBwJe6TppwooI1Wl10VmrxIWdwnJBsv2yMlFKxlNIUOor2rkQvz4eO
	wXxTa
X-Gm-Gg: ASbGncstBHxjhD1NXHNasynXjpkWU/jt8pYUbLrtnZMbNbf+21CgnkYjMQiUGXxhr3E
	WMLz6KkUUFqiFQv5LtLVpmPzoLqtnB2e6gK2wfTKwVbEDoJ2um4i4al9FuYk7H5kWmC5+FfG1Gx
	yhBD6OI5SQ0dqu+9BK40t6upYReIxcootUyLoB5NxyHB5WQF0Q77chQ9CwOrmzdrHZDq9MxXE02
	OsaZ9ikgP3vqyPneaSVw4Wd8GSUZC54k8NLq3vpszIkaWKFI/8ovfXTJoAVEZUvaYvNx0G2jHlc
	jf+QDvu6MsWJzsK5+1cjSWANLDaqraL9Rdv7UJBcwrg4ITLd1+q/6GjtZ0K7SQVFpqPwpzxm2Wc
	pJW6LD030O8aSyhrWrFY=
X-Google-Smtp-Source: AGHT+IHLtsMwETOI9o+w+cReJHI825uQQG0nzqKwrljZvVeiWN9kWdLMsAuHF0pszCq/n6zgVF68Sw==
X-Received: by 2002:a05:6e02:308a:b0:3df:29c8:49ff with SMTP id e9e14a558f8ab-3e2543f99b6mr164645555ab.22.1752532796057;
        Mon, 14 Jul 2025 15:39:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569cc683sm2176034173.107.2025.07.14.15.39.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 15:39:55 -0700 (PDT)
Message-ID: <83e6a86c-5892-423e-aeee-1d176158c521@kernel.dk>
Date: Mon, 14 Jul 2025 16:39:54 -0600
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
Subject: [PATCH for-next] io_uring/net: cast min_not_zero() type
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

kernel test robot reports that xtensa complains about different
signedness for a min_not_zero() comparison. Cast the int part to size_t
to avoid this issue.

Fixes: e227c8cdb47b ("io_uring/net: use passed in 'len' in io_recv_buf_select()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507150504.zO5FsCPm-lkp@intel.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 40f4ac0ab151..639f111408a1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1092,7 +1092,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		if (*len)
 			arg.max_len = *len;
 		else if (kmsg->msg.msg_inq > 1)
-			arg.max_len = min_not_zero(*len, kmsg->msg.msg_inq);
+			arg.max_len = min_not_zero(*len, (size_t) kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg);
 		if (unlikely(ret < 0))

-- 
Jens Axboe


