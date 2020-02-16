Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8605C1604F1
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2020 18:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgBPROC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 12:14:02 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36347 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728370AbgBPROC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 12:14:02 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so7793407pgu.3
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2020 09:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SaNvcIlvlJ60eWkUWtXTLHOg1msWrtwuor9UhgQ0e+U=;
        b=oZYKHVdsnUOKDh9lGlz+iTcbnUw+181E7AzTIbhA643LnR/8z/6R6a4GyuqVbNZwVK
         pJ0p3NKkGiPdpcvewjpWJYnKeX3UX48ZVamRGU6pjY0PO6y9r4//gP96Dwown4bVCdzh
         Qcg8G9+JcjobTNgmd8wHgQMKqB8X189vugAVhK9lc/bqD9WKOVGArXPJ167Cym+jzbFN
         26m6pgOVuZ8a9Rd4QFEWX1/f7Wb437uww9tIPlHxlDqn2nwV7KqQWAdTfrJpoUbEqLg6
         nwQEq2YLMekOkFPtElFg62SobIhKtUtkAuEPkdKwFjTZPXj/Sp3uqaCl10rDSc/p9YEA
         hLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SaNvcIlvlJ60eWkUWtXTLHOg1msWrtwuor9UhgQ0e+U=;
        b=q3h+XQ/gDRj5mwpxsWVzu8oMgFViIyLglstzxTCP5ECgdivJJeNC+eqxMqn+wBuUFT
         XqDw/JQQ4MTdS5aVvCYJf/Z8uySZzLWO5BqMfXuQ2+KcQT97gRQTGsS5mTJaHNv77zTw
         RHYNNL+TwAjvXajSF9SqQmWyKIvRcMMUQ4ZWH+3LBYAOar5NLlEVz/5+8EKbZVA28P3P
         F8coep063OVq0dt84YXLMR2XEwR8jSMyZUErJl3YXt5lsyH5KKdl4O6B2CsUHY7GALD5
         kphqVZ9j2V2WlQFq0bDjFC1JMz69MC+nJVkUl7NRR1GvgVtGrBhqjV6jfvAn8omlW6Fx
         MY3Q==
X-Gm-Message-State: APjAAAXOWj4/ELSyJxZrmzUpMJH8pEefkC94iZcPJlZYDR0eXGNI7P2G
        mwzSO6TWE+AgcteL//6FmgPS6ugERCM=
X-Google-Smtp-Source: APXvYqz1kLCaHGyUK2e3O/IyNTKkNE483FnTLGd+PYStnE/2iKrGUi/tA32RmagvNZMEAQnbCY+V9Q==
X-Received: by 2002:a63:583:: with SMTP id 125mr13497998pgf.100.1581873241523;
        Sun, 16 Feb 2020 09:14:01 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:b1fd:20cc:c368:304b? ([2605:e000:100e:8c61:b1fd:20cc:c368:304b])
        by smtp.gmail.com with ESMTPSA id c68sm14049356pfc.156.2020.02.16.09.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 09:14:01 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix poll_list race for
 SETUP_IOPOLL|SETUP_SQPOLL
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20200214131125.3391-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <880c7bef-ac1d-30bf-6ab7-9866d0614afa@kernel.dk>
Date:   Sun, 16 Feb 2020 09:13:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214131125.3391-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 6:11 AM, Xiaoguang Wang wrote:
> After making ext4 support iopoll method:
>   let ext4_file_operations's iopoll method be iomap_dio_iopoll(),
> we found fio can easily hang in fio_ioring_getevents() with below fio
> job:
>     rm -f testfile; sync;
>     sudo fio -name=fiotest -filename=testfile -iodepth=128 -thread
> -rw=write -ioengine=io_uring  -hipri=1 -sqthread_poll=1 -direct=1
> -bs=4k -size=10G -numjobs=8 -runtime=2000 -group_reporting
> with IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL enabled.
> 
> There are two issues that results in this hang, one reason is that
> when IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL are enabled, fio
> does not use io_uring_enter to get completed events, it relies on
> kernel io_sq_thread to poll for completed events.
> 
> Another reason is that there is a race: when io_submit_sqes() in
> io_sq_thread() submits a batch of sqes, variable 'inflight' will
> record the number of submitted reqs, then io_sq_thread will poll for
> reqs which have been added to poll_list. But note, if some previous
> reqs have been punted to io worker, these reqs will won't be in
> poll_list timely. io_sq_thread() will only poll for a part of previous
> submitted reqs, and then find poll_list is empty, reset variable
> 'inflight' to be zero. If app just waits these deferred reqs and does
> not wake up io_sq_thread again, then hang happens.
> 
> For app that entirely relies on io_sq_thread to poll completed requests,
> let io_iopoll_req_issued() wake up io_sq_thread properly when adding new
> element to poll_list.

I think your analysis is correct, but the various conditional locking
and unlocking in io_sq_thread() is not easy to follow. When I see
things like:

@@ -5101,16 +5095,22 @@ static int io_sq_thread(void *data)
 			if (!to_submit || ret == -EBUSY) {
 				if (kthread_should_park()) {
 					finish_wait(&ctx->sqo_wait, &wait);
+					if (iopoll)
+						mutex_unlock(&ctx->uring_lock);
 					break;
 				}
 				if (signal_pending(current))
 					flush_signals(current);
+				if (iopoll)
+					mutex_unlock(&ctx->uring_lock);
 				schedule();
 				finish_wait(&ctx->sqo_wait, &wait);
 
 				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
 				continue;
 			}
+			if (iopoll)
+				mutex_unlock(&ctx->uring_lock);
 			finish_wait(&ctx->sqo_wait, &wait);
 
 			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;

it triggers the taste senses a bit. Any chance you could take another
look at that part and see if we can clean it up a bit?

Even if that isn't possible, then I think it'd help to rename 'iopoll'
to something related to the lock, and have a comment when you first do:

	/* If we're doing polled IO, we need to bla bla */
	if (ctx->flags & IORING_SETUP_IOPOLL)
		needs_uring_lock = true;


-- 
Jens Axboe

