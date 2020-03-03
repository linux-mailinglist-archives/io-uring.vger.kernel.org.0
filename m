Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD86176E41
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 06:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgCCFB7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 00:01:59 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33513 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgCCFB6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 00:01:58 -0500
Received: by mail-pj1-f67.google.com with SMTP id m7so731621pjs.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 21:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2b8QYmLpxW0UURVVmT/Y5a3O2tSxMXvCUigrvbW1tE4=;
        b=0ru7QvbO+MwNos6svUz76FXtRfdwWhV4dMHOAg6ydLVx25JK+Qra33yTSD2P/oY3GM
         IJMR4SkrjbID+F6uRk4frz0NzkRTiW+AvwjkjM9Se7gx5J8pt/AvMMvHj1RQdw0ZuFFl
         su8xUmbEqOrgdndNFKexRzCNhGdszKbvKqMwupe0xDr7RDirVaazXtj3GysKD23uRtxa
         rSGN+N1CBC4FEk4guHAvJtA0dEgeZ9XSsSWxcdDQyveGGNEiQRyJl8UrQikdCfKRQocl
         wZ7g1CAtlPn4YkfQMYeMRTbLqFaGsMCQx0cCL2KzHkOdt2KvdfYkP+BHnJIbpT7pqi3S
         jBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2b8QYmLpxW0UURVVmT/Y5a3O2tSxMXvCUigrvbW1tE4=;
        b=jzqFmBoi6TgeliI6aO9J+5bXoWQy7bT5wZjA8a+/VnhHiPxIS7UFWV/jri+VAlMM0p
         YMsHR9MmAl14syQodz2Zw4x87RtM98UulbeUlCvUq8IVLrJJt42JO+VcxGiFfwu2okuU
         yhdeRIK1bG4cyXHy5zyJhGUuh0qiwLxUQVRBTQrMFDuNJYzb8R0B89hvJhu9L/B/FbqF
         7JNhaIOe0RrB0IBS4y5kz5QAVcAl3CJ6OXVdpDk32/UA2gQFW+NzuGo5J9IRcuvusocQ
         kH0g6fx4T/OSADqw/nkF2hQmTj4fEZnEDgUIo5nnEbVkcmPHwDPhqPAq7Qp0szGamt2y
         8XdA==
X-Gm-Message-State: ANhLgQ19D/B7jBitpkm6rykIYXc9WEfSHX9HfRauu7Jmz5nx13AoedMP
        P56O4sjPtY6lzeTPI/hD7aRgTStf68s=
X-Google-Smtp-Source: ADFU+vusPnaJ1PcrWA6sC9C4CW543xAOG0QALjK54eST6G4Kl+fj4lHRK9vdGtS1N8eoPDwmhm1AmA==
X-Received: by 2002:a17:90a:a102:: with SMTP id s2mr2189491pjp.44.1583211716960;
        Mon, 02 Mar 2020 21:01:56 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a6sm3438193pfl.82.2020.03.02.21.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 21:01:56 -0800 (PST)
Subject: Re: io_uring performance with block sizes > 128k
From:   Jens Axboe <axboe@kernel.dk>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <53e29125-025c-2fc1-f9b3-fccdea3060e6@oracle.com>
 <f11a29b0-cb7f-37c6-5535-7d95958ebda6@kernel.dk>
Message-ID: <83e00693-59df-1c18-6712-158f42656de7@kernel.dk>
Date:   Mon, 2 Mar 2020 22:01:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f11a29b0-cb7f-37c6-5535-7d95958ebda6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/20 4:57 PM, Jens Axboe wrote:
> On 3/2/20 4:55 PM, Bijan Mottahedeh wrote:
>> I'm seeing a sizeable drop in perf with polled fio tests for block sizes 
>>  > 128k:
>>
>> filename=/dev/nvme0n1
>> rw=randread
>> direct=1
>> time_based=1
>> randrepeat=1
>> gtod_reduce=1
>>
>> fio --readonly --ioengine=io_uring --iodepth 1024 --fixedbufs --hipri 
>> --numjobs=16
>> fio --readonly --ioengine=pvsync2 --iodepth 1024 --hipri --numjobs=16
>>
>>
>> Compared with the pvsync2 engine, the only major difference I could see 
>> was the dio path, __blkdev_direct_IO() for io_uring vs. 
>> __blkdev_direct_IO_simple() for pvsync2 because of the is_sync_kiocb() 
>> check.
>>
>>
>> static ssize_t
>> blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>> {
>>          ...
>>          if (is_sync_kiocb(iocb) && nr_pages <= BIO_MAX_PAGES)
>>                  return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
>>
>>          return __blkdev_direct_IO(iocb, iter, min(nr_pages, 
>> BIO_MAX_PAGES));
>> }
>>
>> Just for an experiment, I hacked io_uring code to force it through the 
>> _simple() path and I get better numbers though the variance is fairly 
>> high, but the drop at bs > 128k seems consistent:
>>
>>
>> # baseline
>> READ: bw=3167MiB/s (3321MB/s), 186MiB/s-208MiB/s (196MB/s-219MB/s)   #128k
>> READ: bw=898MiB/s (941MB/s), 51.2MiB/s-66.1MiB/s (53.7MB/s-69.3MB/s) #144k
>> READ: bw=1576MiB/s (1652MB/s), 81.8MiB/s-109MiB/s (85.8MB/s-114MB/s) #256k
>>
>> # hack
>> READ: bw=2705MiB/s (2836MB/s), 157MiB/s-174MiB/s (165MB/s-183MB/s) #128k
>> READ: bw=2901MiB/s (3042MB/s), 174MiB/s-194MiB/s (183MB/s-204MB/s) #144k
>> READ: bw=4194MiB/s (4398MB/s), 252MiB/s-271MiB/s (265MB/s-284MB/s) #256k
> 
> A quick guess would be that the IO is being split above 128K, and hence
> the polling only catches one of the parts?

Can you try and see if this makes a difference?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 571b510ef0e7..cf7599a2c503 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1725,8 +1725,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (ret < 0)
 			break;
 
+#if 0
 		if (ret && spin)
 			spin = false;
+#endif
 		ret = 0;
 	}
 

-- 
Jens Axboe

