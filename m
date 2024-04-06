Return-Path: <io-uring+bounces-1433-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3547289AD05
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 23:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEEBC2820AF
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 21:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDFC4E1D1;
	Sat,  6 Apr 2024 21:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TuKgBBwj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1A433CF5;
	Sat,  6 Apr 2024 21:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712438623; cv=none; b=kMhSH11W2idBfbLIarnjS2YJwJtmnm/ps9ZLpTWmUC+OFzZeBSszKpmIxMr3B9pJwTiTJM5VXbsypzrxEOH786MtTWvn+nstD1u1vH3h3kxogqfq3/SHc+JilD2KsmrUc5mpGraKUNHzR04BizFw5Wy9rNaVjzflASDY1bj9U/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712438623; c=relaxed/simple;
	bh=xekX2VNMX9pkpb1KoWTSkt8oCN5TWOmbwAfup0O8TFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sSXUUKfDUCFhKP1U12cGNaq1DTNwIcohdT4JQjXEQKqfrPjZ+Ytj2CjJMYWVQaUfyQQ/HRbYfvimQAumrvOs7hcc28Zs6DHU6OnOvPV8JHemYy8LtkTwvu74FieNAXEXPZ7x99p9SYTX4QBxq7S1znpS0djhUKVxM8SYXkwt0uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TuKgBBwj; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4156c4fe401so21364595e9.1;
        Sat, 06 Apr 2024 14:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712438620; x=1713043420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xe9mpNX2ePbRFOYQ2jfSCtDgueOpx0fpIIDZK7IoYcM=;
        b=TuKgBBwj3IKpROHDz3+Y4zsg0EgRu1+Bv9MlVHXVw0F+puuieuDV7tnp+qvJiUU58Z
         0gwJFHqq7kz1CLmVm93ReKWXDeah1qyq2buE0hznUqBawqBzlKW3Snno/sr9DesHZEAE
         /VJOflYn+jg6MkCN3vj8+WukOkoBBmr/vhZm2eWG2KkSvsY3n7/JrtvjxwhmSslxZiyH
         nbuuLUjMc7GdgYTFAKlEphhiSIgR6xrZXuIAKlB9RcEowaSzZSKg/Ab/JP0ig0+1126V
         hHN0j5a17ktQgNdBiNAq0d5UmuGKcSwiusKFReEfZi0cdWkWJ7J6EUORbxPqpG61Cy2X
         DGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712438620; x=1713043420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xe9mpNX2ePbRFOYQ2jfSCtDgueOpx0fpIIDZK7IoYcM=;
        b=jeAlyc12HPQGa74PP4y63b9BpNwue65BRGP3Jt6nzsG20SrR7YCBEWx8GgNd3V7Ft1
         ergcr3yanXhKUHGMlizThmVXVu/RRi8922Cnr9lok0iWythlic9hL9drJe01UaudC3tv
         JBAKHFBy32ZoXJ9YUpNzt2H+nHeExnLTMRN0HsgGBZuIOdUCQB9tqjoGwehlFw01MniX
         RyFOFAgAO74rEvxXQR+rRz62xJekcSgmE9xcxlTmXDPUQrKqNEmdAr3N/CjK8dbPAY0y
         zqXp0NGw/WWSxSjlyOKD1GbHrDcBrm8Zkd4NEn/Y3Z4KYDiTw64I0jDxlt6JAOti+8BD
         egWw==
X-Forwarded-Encrypted: i=1; AJvYcCWp2tbtDkOGK/PVO2scPlhpF3HhlvunCnJZLoE13J1M92rpVK9lmf/7RpSbNmqz6BVtwMWuJ7r8DcLxapq4qNkZ/ni5OkZIuNVuHsZ7fJcYZfe3BmJn2VZFoY5gPG8w0DBqdQYIjNVhs9LM+0xrV9urzyxHmaq3p7N6fP72CXthH2ahCKbj
X-Gm-Message-State: AOJu0YzIdZtQLZad4T0sNu8/Yejp0f9VzOtahIuJWGYEGeBXR/jM8mDf
	IrTrXkIbWbZAqVONrl0QOokN8Orn3BSO1cPNwf6TdTPm6aVKYJYuhEWqzwRo
X-Google-Smtp-Source: AGHT+IHobdRPAl721MvMJSTDg4Ch3BQIPmtFuRakJ3lDIyFPFMOJVhTMq7lIHmrwners6HfubgXnEg==
X-Received: by 2002:a05:600c:1e23:b0:416:3e33:cd88 with SMTP id ay35-20020a05600c1e2300b004163e33cd88mr1633575wmb.30.1712438619811;
        Sat, 06 Apr 2024 14:23:39 -0700 (PDT)
Received: from [192.168.42.178] ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id i11-20020adfe48b000000b0034330c9eccasm5300058wrm.79.2024.04.06.14.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Apr 2024 14:23:39 -0700 (PDT)
Message-ID: <c2e63753-5901-47b2-8def-1a98d8fcdd41@gmail.com>
Date: Sat, 6 Apr 2024 22:23:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring
 zerocopy
To: Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, shuah@kernel.org, leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1712268605.git.ozlinuxc@gmail.com>
 <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
 <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com>
 <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/5/24 21:04, Oliver Crumrine wrote:
> Pavel Begunkov wrote:
>> On 4/4/24 23:17, Oliver Crumrine wrote:
>>> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
>>> specifically disabled REQ_F_CQE_SKIP, as (at least from my
>>> understanding) the userspace program wouldn't receive the
>>> IORING_CQE_F_MORE flag in the result value.
>>
>> No. IORING_CQE_F_MORE means there will be another CQE from this
>> request, so a single CQE without IORING_CQE_F_MORE is trivially
>> fine.
>>
>> The problem is the semantics, because by suppressing the first
>> CQE you're loosing the result value. You might rely on WAITALL
> That's already happening with io_send.

Right, and it's still annoying and hard to use

>> as other sends and "fail" (in terms of io_uring) the request
>> in case of a partial send posting 2 CQEs, but that's not a great
>> way and it's getting userspace complicated pretty easily.
>>
>> In short, it was left out for later because there is a
>> better way to implement it, but it should be done carefully
> Maybe we could put the return values in the notifs? That would be a
> discrepancy between io_send and io_send_zc, though.

Yes. And yes, having a custom flavour is not good. It'd only
be well usable if apart from returning the actual result
it also guarantees there will be one and only one CQE, then
the userspace doesn't have to do the dancing with counting
and checking F_MORE. In fact, I outlined before how a generic
solution may looks like:

https://github.com/axboe/liburing/issues/824

The only interesting part, IMHO, is to be able to merge the
main completion with its notification. Below is an old stash
rebased onto for-6.10. The only thing missing is relinking,
but maybe we don't even care about it. I need to cover it
well with tests.




commit ca5e4fb6d105b5dfdf3768d46ce01529b7bb88c5
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sat Apr 6 15:46:38 2024 +0100

     io_uring/net: introduce single CQE send zc mode
     
     IORING_OP_SEND[MSG]_ZC requests are posting two completions, one to
     notify that the data was queued, and later a second, usually referred
     as "notification", to let the user know that the buffer used can be
     reused/freed. In some cases the user might not care about the main
     completion and would be content getting only the notification, which
     would allow to simplify the userspace.
     
     One example is when after a send the user would be waiting for the other
     end to get the message and reply back not pushing any more data in the
     meantime. Another case is unreliable protocols like UDP, which do not
     require a confirmation from the other end before dropping buffers, and
     so the notifications are usually posted shortly after the send request
     is queued.
     
     Add a flag merging completions into a single CQE. cqe->res will store
     the send's result as usual, and it will have IORING_CQE_F_NOTIF set if
     the buffer was potentially used. Timewise, it would be posted at the
     moment when the notification would have been originally completed.
     
     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..e2b528c341c9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -356,6 +356,7 @@ enum io_uring_op {
  #define IORING_RECV_MULTISHOT		(1U << 1)
  #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
  #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
+#define IORING_SEND_ZC_COMBINE_CQE	(1U << 4)
  
  /*
   * cqe.res for IORING_CQE_F_NOTIF if
diff --git a/io_uring/net.c b/io_uring/net.c
index a74287692071..052f030ab8f8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -992,7 +992,19 @@ void io_send_zc_cleanup(struct io_kiocb *req)
  	}
  }
  
-#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF)
+static inline void io_sendzc_adjust_res(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+
+	if (sr->flags & IORING_SEND_ZC_COMBINE_CQE) {
+		sr->notif->cqe.res = req->cqe.res;
+		req->flags |= REQ_F_CQE_SKIP;
+	}
+}
+
+#define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | \
+			    IORING_RECVSEND_FIXED_BUF | \
+			    IORING_SEND_ZC_COMBINE_CQE)
  #define IO_ZC_FLAGS_VALID  (IO_ZC_FLAGS_COMMON | IORING_SEND_ZC_REPORT_USAGE)
  
  int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -1022,6 +1034,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  		if (zc->flags & ~IO_ZC_FLAGS_VALID)
  			return -EINVAL;
  		if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
+			if (zc->flags & IORING_SEND_ZC_COMBINE_CQE)
+				return -EINVAL;
  			io_notif_set_extended(notif);
  			io_notif_to_data(notif)->zc_report = true;
  		}
@@ -1197,6 +1211,9 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
  	else if (zc->done_io)
  		ret = zc->done_io;
  
+	io_req_set_res(req, ret, IORING_CQE_F_MORE);
+	io_sendzc_adjust_res(req);
+
  	/*
  	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
  	 * flushing notif to io_send_zc_cleanup()
@@ -1205,7 +1222,6 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
  		io_notif_flush(zc->notif);
  		io_req_msg_cleanup(req, 0);
  	}
-	io_req_set_res(req, ret, IORING_CQE_F_MORE);
  	return IOU_OK;
  }
  
@@ -1258,6 +1274,9 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
  	else if (sr->done_io)
  		ret = sr->done_io;
  
+	io_req_set_res(req, ret, IORING_CQE_F_MORE);
+	io_sendzc_adjust_res(req);
+
  	/*
  	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
  	 * flushing notif to io_send_zc_cleanup()
@@ -1266,7 +1285,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
  		io_notif_flush(sr->notif);
  		io_req_msg_cleanup(req, 0);
  	}
-	io_req_set_res(req, ret, IORING_CQE_F_MORE);
  	return IOU_OK;
  }
  
@@ -1278,8 +1296,10 @@ void io_sendrecv_fail(struct io_kiocb *req)
  		req->cqe.res = sr->done_io;
  
  	if ((req->flags & REQ_F_NEED_CLEANUP) &&
-	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
+	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
  		req->cqe.flags |= IORING_CQE_F_MORE;
+		io_sendzc_adjust_res(req);
+	}
  }
  
  int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)


-- 
Pavel Begunkov

