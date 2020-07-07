Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5130C21750D
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 19:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgGGRX0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 13:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgGGRXZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 13:23:25 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7860C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 10:23:25 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e18so25971081ilr.7
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 10:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ldhRsPkqYt9ajnWhW+TBT3ExykQ4f8YgZroNRJDVlg=;
        b=D56fpnrhoyj7220WwXMUKukkjlVB/Cl7ulqYpcWhmp7XKuq5OtYO6x4mKdIsIE/RUW
         KC/5zYWG3HN+LKEJDqbMDjjcfik+BIhUkby8mwalxt97HhtE84o7946RFrzCHxptDymf
         4HWO5DD8180GeWKjCqEulnD8TlJfgYNbgTIDWqLdiH7ILHhXMG4q61G35ucvPprle0nd
         25L0f+PqNlMtoowvwC4KIX0B+NnWNlx2kVmK+q6bwRHQYsONXDYXeMEKwVWOEMO4ggXJ
         aD8R5yac/ulTKKqJK5bICXP2ZkUvs9IVVLLEBsSqX+4x5wJ6jUI4Je3vsB6xiJexiEKz
         CnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ldhRsPkqYt9ajnWhW+TBT3ExykQ4f8YgZroNRJDVlg=;
        b=QD5geGnKK90spjoye8SNVS6WOvD57ew+FV5pSIP8nyKDPzjgVi97PJ53y1Gb1hIMYB
         lsffN0RryHz5Nd/s9SpuIZRWHqMn0EodH8bruOZauMRY/V0ssUNqDKUar7aifwyVWQdT
         vHoImywDE3Q1/BWGvK/SAX0niulQ03fqJz5Rrc3T6HvvnyI0s9JWxLqeB/tqyoc6F4jn
         lqoqyH4SQRLlY02HCyWgJm1RYhPShiynI66xZTMO/TavD/gNkdaCYShRF2Js1aVuGsDh
         Ht104/4qUqBeLXnmyONmIzZ4tdXoYvKJ+3bCeOCUGJulERMb7s31DQlF+TTfND5aLTSP
         7MPQ==
X-Gm-Message-State: AOAM5300fIend/H0ionHnBgjYBvhPxYyIt8qJWGQe8fY72hD5pjH3+YB
        PD40vOm5BVl2CCs6WDd6I4MQe3pe+kftfg==
X-Google-Smtp-Source: ABdhPJyuZfhuNfzLByw8eAoLcXcidsAUzgFYsWdHwXRd8fnU4iGwSGVeoH0kuE6s+x8tfuyVkAREoQ==
X-Received: by 2002:a92:a196:: with SMTP id b22mr7411109ill.303.1594142604878;
        Tue, 07 Jul 2020 10:23:24 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s5sm9953280ilo.24.2020.07.07.10.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 10:23:24 -0700 (PDT)
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
 <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
 <bb9e165a-3193-5da2-d342-e5d9ed200070@kernel.dk>
 <cd98c11f-a453-b0c9-ceb0-569e0a161e17@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b0bd314f-c738-f428-2149-7b1addbcb280@kernel.dk>
Date:   Tue, 7 Jul 2020 11:23:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cd98c11f-a453-b0c9-ceb0-569e0a161e17@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 10:36 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 7/7/20 8:28 AM, Jens Axboe wrote:
>>> On 7/7/20 7:24 AM, Xiaoguang Wang wrote:
>>>> For those applications which are not willing to use io_uring_enter()
>>>> to reap and handle cqes, they may completely rely on liburing's
>>>> io_uring_peek_cqe(), but if cq ring has overflowed, currently because
>>>> io_uring_peek_cqe() is not aware of this overflow, it won't enter
>>>> kernel to flush cqes, below test program can reveal this bug:
>>>>
>>>> static void test_cq_overflow(struct io_uring *ring)
>>>> {
>>>>          struct io_uring_cqe *cqe;
>>>>          struct io_uring_sqe *sqe;
>>>>          int issued = 0;
>>>>          int ret = 0;
>>>>
>>>>          do {
>>>>                  sqe = io_uring_get_sqe(ring);
>>>>                  if (!sqe) {
>>>>                          fprintf(stderr, "get sqe failed\n");
>>>>                          break;;
>>>>                  }
>>>>                  ret = io_uring_submit(ring);
>>>>                  if (ret <= 0) {
>>>>                          if (ret != -EBUSY)
>>>>                                  fprintf(stderr, "sqe submit failed: %d\n", ret);
>>>>                          break;
>>>>                  }
>>>>                  issued++;
>>>>          } while (ret > 0);
>>>>          assert(ret == -EBUSY);
>>>>
>>>>          printf("issued requests: %d\n", issued);
>>>>
>>>>          while (issued) {
>>>>                  ret = io_uring_peek_cqe(ring, &cqe);
>>>>                  if (ret) {
>>>>                          if (ret != -EAGAIN) {
>>>>                                  fprintf(stderr, "peek completion failed: %s\n",
>>>>                                          strerror(ret));
>>>>                                  break;
>>>>                          }
>>>>                          printf("left requets: %d\n", issued);
>>>>                          continue;
>>>>                  }
>>>>                  io_uring_cqe_seen(ring, cqe);
>>>>                  issued--;
>>>>                  printf("left requets: %d\n", issued);
>>>>          }
>>>> }
>>>>
>>>> int main(int argc, char *argv[])
>>>> {
>>>>          int ret;
>>>>          struct io_uring ring;
>>>>
>>>>          ret = io_uring_queue_init(16, &ring, 0);
>>>>          if (ret) {
>>>>                  fprintf(stderr, "ring setup failed: %d\n", ret);
>>>>                  return 1;
>>>>          }
>>>>
>>>>          test_cq_overflow(&ring);
>>>>          return 0;
>>>> }
>>>>
>>>> To fix this issue, export cq overflow status to userspace, then
>>>> helper functions() in liburing, such as io_uring_peek_cqe, can be
>>>> aware of this cq overflow and do flush accordingly.
>>>
>>> Is there any way we can accomplish the same without exporting
>>> another set of flags? Would it be enough for the SQPOLl thread to set
>>> IORING_SQ_NEED_WAKEUP if we're in overflow condition? That should
>>> result in the app entering the kernel when it's flushed the user CQ
>>> side, and then the sqthread could attempt to flush the pending
>>> events as well.
>>>
>>> Something like this, totally untested...
>>
>> OK, took a closer look at this, it's a generic thing, not just
>> SQPOLL related. My bad!
>>
>> Anyway, my suggestion would be to add IORING_SQ_CQ_OVERFLOW to the
>> existing flags, and then make a liburing change almost identical to
>> what you had.
> Thanks.
> It's somewhat late today, I'll test and send these two patches tomorrow.

Sounds good, thanks.

-- 
Jens Axboe

