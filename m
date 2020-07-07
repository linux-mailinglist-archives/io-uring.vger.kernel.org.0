Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1956F2173F9
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 18:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgGGQa4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 12:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgGGQa4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 12:30:56 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F0FC061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 09:30:56 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a11so28295970ilk.0
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 09:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fesot8nEPix5NLMyI8DyptyHNYOztFcSw6eWMuLtYSE=;
        b=miTP2Aq7+JSTYXDexqDXtxZ41Yg1+FrWVdSS9TXTfneyYEcovWhcCiFXwyfmMcc7/S
         9i6cDgw3Ajjkg2kEzpE307qjIUnbpsiWC/OJVeEadunQ6zjJLu4ykzPYjDmNMKghyNmK
         us75K4NqpJ908QKYCZfpiIXQ0Hwcmg2tSJTqdFlUdbwGL+xRO0GPHurMJUHGsomYNGD+
         /NkIs0+22WB8PeqXSxv+rXtK7/HbITHvdsF5FsWZ1CAgSk6PWasCqGUlN7v4jv8vJ8jQ
         2cxfmoiJdg5GehpqriRcTRb/SxdrEMveE+9bcBi7leh8HNJDR2XA2bjtpe7Kn+HC6Q+N
         b0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fesot8nEPix5NLMyI8DyptyHNYOztFcSw6eWMuLtYSE=;
        b=UL2v+FdtvrGIrgMF8EEE/2zrPqXPMTqD5g/quP6RDhNAWzyLsYKQQFVybfcJdOYTFI
         gIoTGkU+eFbForvCnQsOyYhk2X10Hij3clMlnEm4SiV/riQRZ+2Eh6pmS7pmuNxHxvlM
         J8koSCb1KXH6nQ4QGoOod/n3ye/re1XVTlxg0uGMp/fReHGGwy5hPYWqmQRtuQhgP/Xm
         bkWRbEUjqUtViJvM0Dya2V1RJcJTXycgL+JwazifgAt2cmtpKFSk1RWzAsMwWZ3bqXRC
         umtrkQ3qEtaYu+ZIql3ACONy/N99UTu6trY/9Y9HrQcwvLyQiONjz96W8jrgOsfeJAh2
         NyTw==
X-Gm-Message-State: AOAM5305hNnaJVt60ODNpR8FUDiPD0k5htaxAwcPD+vT/tYr+rIne++e
        13RH/gsYUHMoElmSzYn2fN8yfAM5EvIrvg==
X-Google-Smtp-Source: ABdhPJyccp1nEIBuknBTqFzMjuqwMwUZ8W1uWqdXQ05L/n1S/sMY8KSHfF+HrzfsgQ2Hhu0GyZd1UA==
X-Received: by 2002:a92:5a56:: with SMTP id o83mr37144171ilb.71.1594139455526;
        Tue, 07 Jul 2020 09:30:55 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y2sm11845833iox.22.2020.07.07.09.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 09:30:54 -0700 (PDT)
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200707132420.2007-1-xiaoguang.wang@linux.alibaba.com>
 <0ebded37-3660-e3c0-aa51-d3d7e56d634c@kernel.dk>
 <9b62548d-1a40-0706-21bd-7be699cc2c83@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <60fd3f45-16ce-12a9-ba03-8f07f1fc8de6@kernel.dk>
Date:   Tue, 7 Jul 2020 10:30:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9b62548d-1a40-0706-21bd-7be699cc2c83@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 10:29 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 7/7/20 7:24 AM, Xiaoguang Wang wrote:
>>> For those applications which are not willing to use io_uring_enter()
>>> to reap and handle cqes, they may completely rely on liburing's
>>> io_uring_peek_cqe(), but if cq ring has overflowed, currently because
>>> io_uring_peek_cqe() is not aware of this overflow, it won't enter
>>> kernel to flush cqes, below test program can reveal this bug:
>>>
>>> static void test_cq_overflow(struct io_uring *ring)
>>> {
>>>          struct io_uring_cqe *cqe;
>>>          struct io_uring_sqe *sqe;
>>>          int issued = 0;
>>>          int ret = 0;
>>>
>>>          do {
>>>                  sqe = io_uring_get_sqe(ring);
>>>                  if (!sqe) {
>>>                          fprintf(stderr, "get sqe failed\n");
>>>                          break;;
>>>                  }
>>>                  ret = io_uring_submit(ring);
>>>                  if (ret <= 0) {
>>>                          if (ret != -EBUSY)
>>>                                  fprintf(stderr, "sqe submit failed: %d\n", ret);
>>>                          break;
>>>                  }
>>>                  issued++;
>>>          } while (ret > 0);
>>>          assert(ret == -EBUSY);
>>>
>>>          printf("issued requests: %d\n", issued);
>>>
>>>          while (issued) {
>>>                  ret = io_uring_peek_cqe(ring, &cqe);
>>>                  if (ret) {
>>>                          if (ret != -EAGAIN) {
>>>                                  fprintf(stderr, "peek completion failed: %s\n",
>>>                                          strerror(ret));
>>>                                  break;
>>>                          }
>>>                          printf("left requets: %d\n", issued);
>>>                          continue;
>>>                  }
>>>                  io_uring_cqe_seen(ring, cqe);
>>>                  issued--;
>>>                  printf("left requets: %d\n", issued);
>>>          }
>>> }
>>>
>>> int main(int argc, char *argv[])
>>> {
>>>          int ret;
>>>          struct io_uring ring;
>>>
>>>          ret = io_uring_queue_init(16, &ring, 0);
>>>          if (ret) {
>>>                  fprintf(stderr, "ring setup failed: %d\n", ret);
>>>                  return 1;
>>>          }
>>>
>>>          test_cq_overflow(&ring);
>>>          return 0;
>>> }
>>>
>>> To fix this issue, export cq overflow status to userspace, then
>>> helper functions() in liburing, such as io_uring_peek_cqe, can be
>>> aware of this cq overflow and do flush accordingly.
>>
>> Is there any way we can accomplish the same without exporting
>> another set of flags? 

> I understand your concerns and will try to find some better methods
> later, but not sure there're some better :)

Ignore this one and look at the one I just sent, hopefully that'll be
better for you.

-- 
Jens Axboe

