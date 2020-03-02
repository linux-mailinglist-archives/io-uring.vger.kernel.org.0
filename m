Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93592176898
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 00:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgCBX56 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 18:57:58 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46722 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbgCBX5u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 18:57:50 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so440846pll.13
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 15:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QpzgLdNcZCU9OO5+64C+e3n+0yYZ05MxTaWXltZKO7s=;
        b=obLwOX26gYfZwAXHBPdVRQDwJWCkAjvkPOYMr/VcfABXHQWZsXSID2ofBPQZCPagUR
         SUvHRvJW3NNTYR5udhQ7NFEkkBbfKqxPyQZx1wWYxpIGOZ7AA8JYoy5zwImnfIDNR1JU
         L7GrzRLPr6hzDDgYrooI1W6Fmg2as0Q4HJiofhi5bfQzVvsVyii/U+CP/wwsZQ2VIDpE
         zc6lb+3G6E0zsCkxrXkCiQPV2eVMBCQxAd0KIMc+y/txnujyhT5F7w1fg7wgj9IC17wl
         tYbzS3m0fOWgMiFRb10CyMvuc2uxc+gNA4urpzBjWr5mu26VnwGjpsBPSjaHKFb3UoZu
         d/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QpzgLdNcZCU9OO5+64C+e3n+0yYZ05MxTaWXltZKO7s=;
        b=tSLl7ZwZUM9VYlHrfORrJyOkuEJTEuMu3XIfSLZurPao1NHS5LaeNIV1ykBp+ORafg
         rSNhd0JSoailFdgJ/kbWhuwT/pEzOrETWvO9GNJWvnWeYdnm6/W186PHJPw+ThJD5mw7
         I4go8bUPtqN9mDenGQYDdEcFSsJWS+MKUCbbMhrj2gcawIL0Jn5Xgf25By9OPJ+w9rhf
         VvppR4Q9tDlgEcp0ZFyUKm5ht97QWO8wNSdD2L4k3AvoDgqXWyChFi2FEmRIFV1d0lPk
         JR/UpvjqDI8aKvCJbsln3FFDx1O4nZoKVvHU3OWHWvefwNk1C12rRl0epxxEciToEY5f
         zDvg==
X-Gm-Message-State: ANhLgQ3AbRb073hyHb1QNrngpD7fVkUWQ+cmHcZwHbswOgZMyKktHSDO
        ckxw8PQNQvkhqAXEwnme03n9n7Usads=
X-Google-Smtp-Source: ADFU+vvIMxYLmfuAGoVHXbb+aBPb3nTasTU8k4GAczk0o5AHUSRENYyaIU2UVCYJZXwFESfImbdDyg==
X-Received: by 2002:a17:90a:8006:: with SMTP id b6mr1059152pjn.194.1583193468278;
        Mon, 02 Mar 2020 15:57:48 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u6sm252990pjy.3.2020.03.02.15.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 15:57:47 -0800 (PST)
Subject: Re: io_uring performance with block sizes > 128k
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <53e29125-025c-2fc1-f9b3-fccdea3060e6@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f11a29b0-cb7f-37c6-5535-7d95958ebda6@kernel.dk>
Date:   Mon, 2 Mar 2020 16:57:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <53e29125-025c-2fc1-f9b3-fccdea3060e6@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/20 4:55 PM, Bijan Mottahedeh wrote:
> I'm seeing a sizeable drop in perf with polled fio tests for block sizes 
>  > 128k:
> 
> filename=/dev/nvme0n1
> rw=randread
> direct=1
> time_based=1
> randrepeat=1
> gtod_reduce=1
> 
> fio --readonly --ioengine=io_uring --iodepth 1024 --fixedbufs --hipri 
> --numjobs=16
> fio --readonly --ioengine=pvsync2 --iodepth 1024 --hipri --numjobs=16
> 
> 
> Compared with the pvsync2 engine, the only major difference I could see 
> was the dio path, __blkdev_direct_IO() for io_uring vs. 
> __blkdev_direct_IO_simple() for pvsync2 because of the is_sync_kiocb() 
> check.
> 
> 
> static ssize_t
> blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
> {
>          ...
>          if (is_sync_kiocb(iocb) && nr_pages <= BIO_MAX_PAGES)
>                  return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
> 
>          return __blkdev_direct_IO(iocb, iter, min(nr_pages, 
> BIO_MAX_PAGES));
> }
> 
> Just for an experiment, I hacked io_uring code to force it through the 
> _simple() path and I get better numbers though the variance is fairly 
> high, but the drop at bs > 128k seems consistent:
> 
> 
> # baseline
> READ: bw=3167MiB/s (3321MB/s), 186MiB/s-208MiB/s (196MB/s-219MB/s)   #128k
> READ: bw=898MiB/s (941MB/s), 51.2MiB/s-66.1MiB/s (53.7MB/s-69.3MB/s) #144k
> READ: bw=1576MiB/s (1652MB/s), 81.8MiB/s-109MiB/s (85.8MB/s-114MB/s) #256k
> 
> # hack
> READ: bw=2705MiB/s (2836MB/s), 157MiB/s-174MiB/s (165MB/s-183MB/s) #128k
> READ: bw=2901MiB/s (3042MB/s), 174MiB/s-194MiB/s (183MB/s-204MB/s) #144k
> READ: bw=4194MiB/s (4398MB/s), 252MiB/s-271MiB/s (265MB/s-284MB/s) #256k

A quick guess would be that the IO is being split above 128K, and hence
the polling only catches one of the parts?

-- 
Jens Axboe

