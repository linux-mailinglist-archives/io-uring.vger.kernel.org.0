Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCDE1C96DD
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 18:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgEGQun (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 12:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726222AbgEGQun (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 12:50:43 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E290C05BD43
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 09:50:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d184so3278215pfd.4
        for <io-uring@vger.kernel.org>; Thu, 07 May 2020 09:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WuW7YUkcsP0fBu4HDlMlcovY4Vx58GgUKGnH5pUiz+E=;
        b=sZpH2prd14ryaPJC87NyJNiptmJXK4piFMlYYu6+n3YjseZuuJG5FOsz2Y00H1zPjD
         /Sj9nFavh8o78ccdmBig+xcIzKsmnkGaUEKzXfONZpfA7IAlb1tBsqbD5tm9Q3dbrF+0
         GIy0oOUj+6NQsu2wQw7oIFthhelTnwfzyHjjm0Pyy+dVMV5Ko867YzybG19FYO40zL8C
         HfGucRVWJrTKWH1eQvwwCAEsm3u6OsCGgmaR9tJH3idunwBPAw+3Vffv/bdBU9zXJt0X
         18jfsiekLCcYzEnRBc+ax7w9P40/n/oHDA5JOaFKn0UD6A+oGpG0ptiEdaA7gIraehVc
         YA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WuW7YUkcsP0fBu4HDlMlcovY4Vx58GgUKGnH5pUiz+E=;
        b=ItlymxgI8BoQWqLIbFW9KCUS+pAW1+siKS33jfA5HIsvDZxaLkSNmLHF1vPjrKHP+6
         zL60b/6FwQjPgh3xsuxBELKFYp5Vmp/DLZSeg5w+rcIFFqKQI1g0iZcLBSHwckL5LQlV
         8m+kR6qTbgZptF0pb0SnhQLsbJdSNWadh6qfry8FiUzfO2Q0EuJkY48VmkSlbzn/4g1Y
         gmHwajHcwZooR+IMynH8lngl4kHt2ujPRPNNIgORd5whXyePC9rZifMC1v2UYaG5Tq5b
         ftxeAc0NRzTNPZ5TectL/llbJE0Eur9Wf6f71r0Jkg79iTvRz9/qo9hOEj9j27/zQDvF
         HepA==
X-Gm-Message-State: AGi0PubMWgpPUwUdhJ/Dn48qYybjXWrFxO8QpOrd6vS6k8qezjmxal0Y
        5VD35uB3qA7NNYTy8H3yt0GlEA==
X-Google-Smtp-Source: APiQypIXUSWU9cTnD5wBGJ8LLqnbNy9k2d9/iCN/3Y/paSUrLAd7h47GdD/7qxc/TYOPAvVNXitZcw==
X-Received: by 2002:a62:7656:: with SMTP id r83mr14403232pfc.71.1588870242745;
        Thu, 07 May 2020 09:50:42 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::1239? ([2620:10d:c090:400::5:ddfe])
        by smtp.gmail.com with ESMTPSA id t23sm286575pji.32.2020.05.07.09.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 09:50:42 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
To:     Jeremy Allison <jra@samba.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
 <6fb9286a-db89-9d97-9ae3-d3cc08ef9039@gmail.com>
 <9c99b692-7812-96d7-5e88-67912cef6547@samba.org>
 <117f19ce-e2ef-9c99-93a4-31f9fff9e132@gmail.com>
 <97508d5f-77a0-e154-3da0-466aad2905e8@kernel.dk>
 <20200507164802.GB25085@jeremy-acer>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <01778c43-866f-6974-aa4a-7dc364301764@kernel.dk>
Date:   Thu, 7 May 2020 10:50:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507164802.GB25085@jeremy-acer>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/20 10:48 AM, Jeremy Allison wrote:
> On Thu, May 07, 2020 at 10:43:17AM -0600, Jens Axboe wrote:
>>
>> Replying here, as I missed the storm yesterday... The reason why it's
>> different is that later kernels no longer attempt to prevent the short
>> reads. They happen when you get overlapping buffered IO. Then one sqe
>> will find that X of the Y range is already in cache, and return that.
>> We don't retry the latter blocking. We previously did, but there was
>> a few issues with it:
>>
>> - You're redoing the whole IO, which means more copying
>>
>> - It's not safe to retry, it'll depend on the file type. For socket,
>>   pipe, etc we obviously cannot. This is the real reason it got disabled,
>>   as it was broken there.
>>
>> Just like for regular system calls, applications must be able to deal
>> with short IO.
> 
> Thanks, that's a helpful definitive reply. Of course, the SMB3
> protocol is designed to deal with short IO replies as well, and
> the Samba and linux kernel clients are well-enough written that
> they do so. MacOS and Windows however..

I'm honestly surprised that such broken clients exists! Even being
a somewhat old timer cynic...

> Unfortunately they're the most popular clients on the planet,
> so we'll probably have to fix Samba to never return short IOs.

That does sound like the best way forward, short IOs is possible
with regular system calls as well, but will definitely be a lot
more frequent with io_uring depending on the access patterns,
page cache, number of threads, and so on.

-- 
Jens Axboe

