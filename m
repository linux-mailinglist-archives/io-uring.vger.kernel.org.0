Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF90829BEB7
	for <lists+io-uring@lfdr.de>; Tue, 27 Oct 2020 17:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814504AbgJ0Q4m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 12:56:42 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:46079 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1814483AbgJ0Q4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 12:56:24 -0400
Received: by mail-il1-f193.google.com with SMTP id g7so2116561ilr.12
        for <io-uring@vger.kernel.org>; Tue, 27 Oct 2020 09:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nxiwNglDu0IrK6XR/Tuh+/jfFG+5vsir9MSwzrLYdyM=;
        b=gb4HL0MpxvYLlrJHBSik/SfkXVNnK+f4G6xkMJAedK4VUMNfxfMHF7yNLp7Q2zGVqM
         dJ8fE5mE2F4fT1LhUKaybYAoOB6x5OiabCyDcTZcYkscLg5YIhNbDyzWBp5v1jX1PxeB
         9ms2TdyoPm8kXxA+XVSnxJaGtSAb+ifKQ/OZs425QBleE0wNK1x8cB08EOw4oS/zP4Q3
         GVxlJFmnun3uBavpkXYISHHfnEgY40a1SUtUHR/n4JxE2Lyt0oP8rxXYB+wrI2tWHRPQ
         sMJVB5+WPxgF8OZTDzF5T0ZlZ08J8GPpDN0XWApu+WXkcoN5R7ks5DcHcNGEqzDQ75uA
         oUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nxiwNglDu0IrK6XR/Tuh+/jfFG+5vsir9MSwzrLYdyM=;
        b=mLgWRjNBCPowzq8K6CkPjQFiiQ/fD7ly7v3kfvvRiHVxePw5B0CGJGRm/20P/X9Iw1
         840uK379O3qFa0vsgqFZWp8pJiFX2WeN7Gu8+lBR8F5lNIAOmMyFOpVPBYKM5fKExrQ7
         +RXE2AG4h6Zuf5UiHPAIrgMA3AN6zb7wHjDLGEv5qGIVwq4HLqgYcs6sYZMUIH5t6nN8
         cfUs7VJYtJaePEYcTffW5uUM9mEC+IhUc6BR7FJPyB5ItMMVWsSqDkAs0KiMQDoIXprN
         5IY7LeN239V7P+SFQ4Oda7A0oAP3NVeLwlOfKbTbLIRQtVStOG7NswHQbonD2+ed3D9f
         fLTQ==
X-Gm-Message-State: AOAM533Je51ffUb04MkVZWR9L0jtNvUSuE0Ui127IivAsk3FFYEqZZvy
        OsdGYcv3HEkJ8vrgc6KDiUTPlHW6vrQqiA==
X-Google-Smtp-Source: ABdhPJw4BcyPcYoP/ae/bk+1dEuUc1by9gjL7Q33bZxvbePIrXkcLD/q9zt5adS19vNeOH+68fiCxw==
X-Received: by 2002:a92:600e:: with SMTP id u14mr2588570ilb.303.1603817783487;
        Tue, 27 Oct 2020 09:56:23 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f5sm1122135ioq.5.2020.10.27.09.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 09:56:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: refactor io_sq_thread() handling
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20201020082345.19628-1-xiaoguang.wang@linux.alibaba.com>
 <20201020082345.19628-2-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2afcd03d-0b19-648c-67a6-36e8ddc201ef@kernel.dk>
Date:   Tue, 27 Oct 2020 10:56:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201020082345.19628-2-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/20 2:23 AM, Xiaoguang Wang wrote:
> @@ -6638,24 +6578,52 @@ static int io_sq_thread(void *data)
>  			}
>  			io_sq_thread_associate_blkcg(ctx, &cur_css);
>  
> -			ret |= __io_sq_thread(ctx, start_jiffies, cap_entries);
> +			ret = __io_sq_thread(ctx, cap_entries);
> +			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
> +				sqt_spin = true;
> +		}
>  
> -			io_sq_thread_drop_mm();
> +		if (sqt_spin) {
> +			io_run_task_work();
> +			cond_resched();
> +			continue;
>  		}
>  
> -		if (ret & SQT_SPIN) {
> +		if (!time_after(jiffies, timeout)) {
>  			io_run_task_work();
>  			cond_resched();
> -		} else if (ret == SQT_IDLE) {
> -			if (kthread_should_park())
> -				continue;
> +			io_sq_thread_drop_mm();
> +			continue;
> +		}
> +
> +		needs_sched = true;
> +		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
> +		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> +			    !list_empty_careful(&ctx->iopoll_list)) {
> +				needs_sched = false;
> +				break;
> +			}
> +			to_submit = io_sqring_entries(ctx);
> +			if (to_submit) {
> +				needs_sched = false;
> +				break;
> +			}
> +		}
> +
> +		if (needs_sched) {
>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>  				io_ring_set_wakeup_flag(ctx);
> +		}
> +
> +		if (needs_sched) {
>  			schedule();
> -			start_jiffies = jiffies;
>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>  				io_ring_clear_wakeup_flag(ctx);
> -		}
> +			finish_wait(&sqd->wait, &wait);
> +		} else
> +			finish_wait(&sqd->wait, &wait);
> +		timeout = jiffies + sqd->sq_thread_idle;
>  	}

Not sure why, but you have two

if (needs_sched) {
}

right after each other, that should be folded into one.

And I'd get rid of the to_submit, just do:

if (io_sqring_entries(ctx)) {
	needs_sched = false;
	break;
}

as we're not going to be using that value anyway.

As a minor style thing, always includes bracket on both cases if one has
it, don't do this:

if (foo) {
	...
	...
} else
	bar();


-- 
Jens Axboe

