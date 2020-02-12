Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD7F15AE9D
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 18:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgBLRWw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 12:22:52 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35047 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgBLRWv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 12:22:51 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so1211727plt.2
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 09:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RxOpVdqZ6djdGAMWb97Muug8NmmESCG2MH3s9aM4WGA=;
        b=LcH060dNuLu3omLCguYY0zu1IZb5PpvvqpSWYoeaBHjIT6momMkjCah2B72DYIM+cW
         87rAdyTdEFpbZedHgCmffSaQOPH82sAFIzxk4F2P+HlblllqX0lYxJMfjDfcv4FOGOkB
         yrimHpo1MbB7JPkF4jxJyKagR7I6jhC/DhrMA4z4biFfXy7bfcflbGoGpgvLUH8yLWKr
         7Z/IA0p6ulEFO30wWR2TbbRkhb1DWf4cD62GHsVVo9RpNBAggGO2JJpLfZ0ooYW2/YyK
         bQ/QjHtlZ3Nm1aPylT9EZURKoxysyIbKxtU7coMLMVmJt9bgyiDP5lra5/XfZUgID2m5
         BkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RxOpVdqZ6djdGAMWb97Muug8NmmESCG2MH3s9aM4WGA=;
        b=Pxh0CJGhQfyNoXB8Ee5WSUIPH0nECZweIrk8qnppi4R/4CZmGLh4wAklwCNNYmesay
         WMlkkQDQBSJ3GuPxOWoyLeNqBJpuYVSGagSuV/BlmzVwAaiiDPaRFhMvTpZ7nZeaUaIG
         UxlB+bVH1YBY9dR5Ht5ZWWCbHVDxXuQgDi7L8tGOZTsc7LoRtBynMBtv3eTJ1vgo62v0
         yfVI5GjmxJB3LiiawmmblKLhqoPT5/Lk7yL/YKohSK38KaaFSpz6p05zLq+VUpnt8P4i
         c/8SmGdzmzF8OsG5E6lCEOI8oFb3crXRr+e4JzoMhFccvNThiy8eXSA07doh4iqqPEuf
         tO7w==
X-Gm-Message-State: APjAAAUb4yafqIGVKK1ZqevEEHAaTB2j7ELHEWgERMLHKpggsl4upCC3
        5Up7/BYWtt+JSUQ1DV+osVqLP1m01Ho=
X-Google-Smtp-Source: APXvYqyiHYolib/xYbR3EPJBS/Av7Ck8qlPmK9N8kh1IO95+ZrHW7VFAmJYbAGZhQtq9nl7xeDiUqA==
X-Received: by 2002:a17:902:8d83:: with SMTP id v3mr9557431plo.282.1581528169438;
        Wed, 12 Feb 2020 09:22:49 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1018? ([2620:10d:c090:180::78ef])
        by smtp.gmail.com with ESMTPSA id e11sm1037167pgj.70.2020.02.12.09.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 09:22:48 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
Message-ID: <c0bf9bf4-9932-0c74-aa74-72b9cfa488b0@kernel.dk>
Date:   Wed, 12 Feb 2020 10:22:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/20 10:11 AM, Jens Axboe wrote:
> On 2/12/20 9:31 AM, Carter Li 李通洲 wrote:
>> Hi everyone,
>>
>> IOSQE_IO_LINK seems to have very high cost, even greater then io_uring_enter syscall.
>>
>> Test code attached below. The program completes after getting 100000000 cqes.
>>
>> $ gcc test.c -luring -o test0 -g -O3 -DUSE_LINK=0
>> $ time ./test0
>> USE_LINK: 0, count: 100000000, submit_count: 1562500
>> 0.99user 9.99system 0:11.02elapsed 99%CPU (0avgtext+0avgdata 1608maxresident)k
>> 0inputs+0outputs (0major+72minor)pagefaults 0swaps
>>
>> $ gcc test.c -luring -o test1 -g -O3 -DUSE_LINK=1
>> $ time ./test1
>> USE_LINK: 1, count: 100000110, submit_count: 799584
>> 0.83user 19.21system 0:20.90elapsed 95%CPU (0avgtext+0avgdata 1632maxresident)k
>> 0inputs+0outputs (0major+72minor)pagefaults 0swaps
>>
>> As you can see, the `-DUSE_LINK=1` version emits only about half io_uring_submit calls
>> of the other version, but takes twice as long. That makes IOSQE_IO_LINK almost useless,
>> please have a check.
> 
> The nop isn't really a good test case, as it doesn't contain any smarts
> in terms of executing a link fast. So it doesn't say a whole lot outside
> of "we could make nop links faster", which is also kind of pointless.
> 
> "Normal" commands will work better. Where the link is really a win is if
> the first request needs to go async to complete. For that case, the
> next link can execute directly from that context. This saves an async
> punt for the common case.

Case in point, if I just add the below patch, we're a lot closer:

[root@archlinux liburing]# time test/nop-link 0
Using link: 0
count: 100000000, submit_count: 1562500


real	0m7.934s
user	0m0.740s
sys	0m7.157s
[root@archlinux liburing]# time test/nop-link 1
Using link: 1
count: 100000000, submit_count: 781250


real	0m9.009s
user	0m0.710s
sys	0m8.264s

The links are still a bit slower, which is to be expected as the
nop basically just completes, it doesn't do anything at all and
it never needs to go async.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f00f30e1790..d0f645be91cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2399,7 +2399,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
-static int io_nop(struct io_kiocb *req)
+static int io_nop(struct io_kiocb *req, struct io_kiocb **nxt)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -2407,7 +2407,7 @@ static int io_nop(struct io_kiocb *req)
 		return -EINVAL;
 
 	io_cqring_add_event(req, 0);
-	io_put_req(req);
+	io_put_req_find_next(req, nxt);
 	return 0;
 }
 
@@ -4355,7 +4355,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-		ret = io_nop(req);
+		ret = io_nop(req, nxt);
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:

-- 
Jens Axboe

